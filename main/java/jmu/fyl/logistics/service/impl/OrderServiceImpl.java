package jmu.fyl.logistics.service.impl;

import jmu.fyl.logistics.dao.OrderDao;

import jmu.fyl.logistics.entity.Order;

import jmu.fyl.logistics.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.text.SimpleDateFormat;
import java.util.stream.Collectors;


@Service
@Transactional
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderDao orderDao;

    @Override
    public int addOrder(Order order) {
        if (order.getOrderNumber() == null || order.getOrderNumber().isEmpty()) {
            order.setOrderNumber(generateOrderNumber());
        }
        if (order.getStatus() == null) {
            order.setStatus(1); // 默认已下单
        }
        if (order.getCurrentStationId() == null && order.getStartStationId() != null) {
            order.setCurrentStationId(order.getStartStationId());
        }
        return orderDao.insert(order);
    }

    @Override
    public int updateOrder(Order order) {
        return orderDao.update(order);
    }

    @Override
    public int deleteOrder(Integer orderId) {
        return orderDao.delete(orderId);
    }

    @Override
    public Order getOrderById(Integer orderId) {
        return orderDao.findById(orderId);
    }

    @Override
    public Order getOrderByNumber(String orderNumber) {
        return orderDao.findByOrderNumber(orderNumber);
    }

    @Override
    public List<Order> getAllOrders() {
        return orderDao.findAll();
    }

    @Override
    public List<Order> getOrdersByStatus(Integer status) {
        return orderDao.findByStatus(status);
    }

    @Override
    public List<Order> getOrdersBySenderPhone(String phone) {
        return orderDao.findBySenderPhone(phone);
    }

    @Override
    public List<Order> getOrdersByReceiverPhone(String phone) {
        return orderDao.findByReceiverPhone(phone);
    }

    @Override
    public List<Order> getOrdersByCreateUserId(Integer userId) {
        return orderDao.findByCreateUserId(userId);
    }

    @Override
    public List<Order> getOrdersByTimeRange(Date startTime, Date endTime) {
        return orderDao.findByCreateTimeRange(startTime, endTime);
    }

    @Override
    public List<Order> getOrdersByStation(Integer stationId, Integer status) {
        return orderDao.findOrdersByStation(stationId, status);
    }

    @Override
    public int updateOrderStatus(Integer orderId, Integer status) {
        return orderDao.updateStatus(orderId, status);
    }

    @Override
    public int updateCurrentStation(Integer orderId, Integer stationId) {
        return orderDao.updateCurrentStation(orderId, stationId);
    }

    @Override
    public int assignVehicleToOrder(Integer orderId, Integer vehicleId) {
        return orderDao.assignVehicle(orderId, vehicleId);
    }

    @Override
    public String generateOrderNumber() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String timestamp = sdf.format(new Date());
        String random = String.format("%03d", (int)(Math.random() * 1000));
        return "ORD" + timestamp + random;
    }

    @Override
    public List<Order> getOrdersByUserId(Integer userId) {
        return orderDao.findByCreateUserId(userId);
    }


    @Override
    public List<Order> searchOrders(Map<String, Object> params) {
        return orderDao.findByCondition(params);
    }

    @Override
    public int countOrders(Map<String, Object> params) {
        return orderDao.countByCondition(params);
    }

    @Override
    public Map<String, Object> getOrderStats() {
        Map<String, Object> stats = orderDao.getOrderStats();
        if (stats == null) {
            stats = new HashMap<>();
        }

        // 补充其他统计
        stats.put("total", countOrders(new HashMap<>()));
        stats.put("pending", orderDao.findByStatus(1).size());
        stats.put("collected", orderDao.findByStatus(2).size());
        stats.put("transporting", orderDao.findByStatus(3).size());
        stats.put("arrived", orderDao.findByStatus(4).size());
        stats.put("signed", orderDao.findByStatus(5).size());

        return stats;
    }

    @Override
    public List<Map<String, Object>> getOrderStatsByDate(Date startDate, Date endDate) {
        return orderDao.getOrderStatsByDate(startDate, endDate);
    }
    @Override
    public int assignTransportTask(Integer orderId, Integer taskId) {
        return orderDao.assignTransportTask(orderId, taskId);
    }

    @Override
    public List<Order> getOrdersByTransportTaskId(Integer transportTaskId) {
        return orderDao.findByTransportTaskId(transportTaskId);
    }

    @Override
    public List<Order> getOrdersByVehicleId(Integer vehicleId) {
        return orderDao.findByVehicleId(vehicleId);
    }
}