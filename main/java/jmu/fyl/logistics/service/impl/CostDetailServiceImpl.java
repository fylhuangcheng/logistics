package jmu.fyl.logistics.service.impl;

import jmu.fyl.logistics.dao.CostDetailDao;
import jmu.fyl.logistics.entity.CostDetail;
import jmu.fyl.logistics.service.CostDetailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Service
@Transactional
public class CostDetailServiceImpl implements CostDetailService {

    @Autowired
    private CostDetailDao costDetailDao;

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
    public List<CostDetail> searchCostDetails(Map<String, Object> params) {
        return costDetailDao.findByCondition(params);
    }

    @Override
    public int countCostDetails(Map<String, Object> params) {
        return costDetailDao.countByCondition(params);
    }
}