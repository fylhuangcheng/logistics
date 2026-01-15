package jmu.fyl.logistics.service.impl;

import jmu.fyl.logistics.dao.CostDetailDao;
import jmu.fyl.logistics.dao.OrderDao;
import jmu.fyl.logistics.entity.CostDetail;
import jmu.fyl.logistics.entity.Order;
import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.CostDetailService;
import jmu.fyl.logistics.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
public class CostDetailServiceImpl implements CostDetailService {

    @Autowired
    private CostDetailDao costDetailDao;

    @Autowired
    private OrderDao orderDao;

    @Autowired
    private OrderService orderService;
    @Override
    public int addCostDetail(CostDetail costDetail) {
        // 设置默认值
        if (costDetail.getPaymentStatus() == null) {
            costDetail.setPaymentStatus(1); // 默认未支付
        }
        if (costDetail.getInvoiceStatus() == null) {
            costDetail.setInvoiceStatus(1); // 默认未开票
        }
        if (costDetail.getCurrency() == null || costDetail.getCurrency().isEmpty()) {
            costDetail.setCurrency("CNY"); // 默认人民币
        }
        if (costDetail.getCostTime() == null) {
            costDetail.setCostTime(new Date());
        }

        return costDetailDao.insert(costDetail);
    }

    @Override
    public int updateCostDetail(CostDetail costDetail) {
        return costDetailDao.update(costDetail);
    }

    @Override
    public int deleteCostDetail(Integer costId) {
        return costDetailDao.delete(costId);
    }

    @Override
    public CostDetail getCostDetailById(Integer costId) {
        return costDetailDao.findById(costId);
    }

    @Override
    public List<CostDetail> getAllCostDetails() {
        return costDetailDao.findAll();
    }

    @Override
    public List<CostDetail> getCostDetailsByOrderId(Integer orderId) {
        return costDetailDao.findByOrderId(orderId);
    }

    @Override
    public List<CostDetail> getCostDetailsByTaskId(Integer taskId) {
        return costDetailDao.findByTaskId(taskId);
    }

    @Override
    public List<CostDetail> getCostDetailsByCostType(Integer costType) {
        return costDetailDao.findByCostType(costType);
    }

    @Override
    public List<CostDetail> getCostDetailsByCostCategory(Integer costCategory) {
        return costDetailDao.findByCostCategory(costCategory);
    }

    @Override
    public List<CostDetail> getCostDetailsByPaymentStatus(Integer paymentStatus) {
        return costDetailDao.findByPaymentStatus(paymentStatus);
    }

    @Override
    public List<CostDetail> getCostDetailsByPayerId(Integer payerId) {
        return costDetailDao.findByPayerId(payerId);
    }

    @Override
    public List<CostDetail> getCostDetailsByPayeeId(Integer payeeId) {
        return costDetailDao.findByPayeeId(payeeId);
    }

    @Override
    public List<CostDetail> getCostDetailsByInvoiceStatus(Integer invoiceStatus) {
        return costDetailDao.findByInvoiceStatus(invoiceStatus);
    }

    @Override
    public List<CostDetail> getCostDetailsByCostTimeRange(Date startTime, Date endTime) {
        return costDetailDao.findByCostTimeRange(startTime, endTime);
    }

    @Override
    public List<CostDetail> getCostDetailsByPaymentTimeRange(Date startTime, Date endTime) {
        return costDetailDao.findByPaymentTimeRange(startTime, endTime);
    }

    @Override
    public int updatePaymentStatus(Integer costId, Integer paymentStatus) {
        return costDetailDao.updatePaymentStatus(costId, paymentStatus);
    }

    @Override
    public int updatePaymentInfo(Integer costId, Integer paymentStatus, String paymentMethod, Date paymentTime) {
        return costDetailDao.updatePaymentInfo(costId, paymentStatus, paymentMethod, paymentTime);
    }

    @Override
    public int updateInvoiceInfo(Integer costId, String invoiceNumber, Integer invoiceStatus) {
        return costDetailDao.updateInvoiceInfo(costId, invoiceNumber, invoiceStatus);
    }

    @Override
    public double getTotalAmountByOrder(Integer orderId) {
        return costDetailDao.getTotalAmountByOrder(orderId);
    }

    @Override
    public double getTotalAmountByTask(Integer taskId) {
        return costDetailDao.getTotalAmountByTask(taskId);
    }

    @Override
    public double getTotalAmountByTimeRange(Date startTime, Date endTime) {
        return costDetailDao.getTotalAmountByTimeRange(startTime, endTime);
    }

    @Override
    public List<Map<String, Object>> getCostStatsByCategory(Date startDate, Date endDate) {
        return costDetailDao.getCostStatsByCategory(startDate, endDate);
    }

    @Override
    public List<Map<String, Object>> getCostStatsByType(Date startDate, Date endDate) {
        return costDetailDao.getCostStatsByType(startDate, endDate);
    }

    @Override
    public List<Map<String, Object>> getUnpaidCosts(Integer days) {
        return costDetailDao.getUnpaidCosts(days);
    }

    @Override
    public List<Map<String, Object>> getRevenueByDate(Date startDate, Date endDate) {
        return costDetailDao.getRevenueByDate(startDate, endDate);
    }

    @Override
    public List<CostDetail> searchCostDetails(Map<String, Object> params, User user) {
        // 如果是客户，自动限制为只能查看自己的费用
        if (user != null && user.getUserType() == 3) { // 客户类型为3
            System.out.println("=== 客户权限过滤 - 费用查询 ===");
            System.out.println("客户ID: " + user.getUserId());

            // 获取客户的所有订单号
            List<Order> customerOrders = orderService.getOrdersByUserId(user.getUserId());
            System.out.println("客户订单数量: " + customerOrders.size());

            if (customerOrders.isEmpty()) {
                System.out.println("客户没有订单，返回空列表");
                return new ArrayList<>();
            }

            // 提取订单号列表 - 用 orderNumber 进行匹配
            List<String> orderNumbers = customerOrders.stream()
                    .map(Order::getOrderNumber)
                    .collect(Collectors.toList());

            System.out.println("客户订单号列表: " + orderNumbers);
            params.put("customerOrderNumbers", orderNumbers);
        }
        // 管理员（userType = 1）和司机（userType = 2）可以看到所有费用

        List<CostDetail> costDetails = costDetailDao.findByCondition(params);
        System.out.println("查询到的费用数量: " + costDetails.size());

        // 为每个费用加载订单信息
        for (CostDetail cost : costDetails) {
            if (cost.getOrderId() != null) {
                Order order = orderDao.findById(cost.getOrderId());
                if (order != null) {
                    cost.setOrder(order);
                    System.out.println("加载订单信息: 费用ID=" + cost.getCostId() +
                            ", 订单号=" + order.getOrderNumber());
                }
            }
        }
        return costDetails;
    }

    @Override
    public int countCostDetails(Map<String, Object> params, User user) {
        // 如果是客户，自动限制为只能查看自己的费用
        if (user != null && user.getUserType() == 3) { // 客户类型为3
            // 获取客户的所有订单号
            List<Order> customerOrders = orderService.getOrdersByUserId(user.getUserId());
            if (customerOrders.isEmpty()) {
                return 0;
            }

            // 提取订单号列表 - 用 orderNumber 进行匹配
            List<String> orderNumbers = customerOrders.stream()
                    .map(Order::getOrderNumber)
                    .collect(Collectors.toList());

            params.put("customerOrderNumbers", orderNumbers);
        }
        return costDetailDao.countByCondition(params);
    }

    // 修改原有的方法，默认传入null表示管理员
    @Override
    public List<CostDetail> searchCostDetails(Map<String, Object> params) {
        return searchCostDetails(params, null);
    }

    @Override
    public int countCostDetails(Map<String, Object> params) {
        return countCostDetails(params, null);
    }
}
