package jmu.fyl.logistics.service;

import jmu.fyl.logistics.entity.Order;
import java.util.Date;
import java.util.List;
import java.util.Map;



public interface OrderService {
    int addOrder(Order order);
    int updateOrder(Order order);
    int deleteOrder(Integer orderId);
    Order getOrderById(Integer orderId);
    Order getOrderByNumber(String orderNumber);
    List<Order> getAllOrders();
    List<Order> getOrdersByStatus(Integer status);
    List<Order> getOrdersBySenderPhone(String phone);
    List<Order> getOrdersByReceiverPhone(String phone);
    List<Order> getOrdersByCreateUserId(Integer userId);
    List<Order> getOrdersByTimeRange(Date startTime, Date endTime);
    List<Order> getOrdersByStation(Integer stationId, Integer status);
    int updateOrderStatus(Integer orderId, Integer status);
    int updateCurrentStation(Integer orderId, Integer stationId);
    int assignVehicleToOrder(Integer orderId, Integer vehicleId);
    String generateOrderNumber();
    List<Order> searchOrders(Map<String, Object> params);
    int countOrders(Map<String, Object> params);
    Map<String, Object> getOrderStats();
    List<Map<String, Object>> getOrderStatsByDate(Date startDate, Date endDate);
    // 添加以下方法到 OrderService 接口
    int assignTransportTask(Integer orderId, Integer taskId);
    List<Order> getOrdersByTransportTaskId(Integer transportTaskId);
    List<Order> getOrdersByVehicleId(Integer vehicleId);
    // 在 OrderService 接口中添加以下方法：
    List<Order> getOrdersByUserId(Integer userId);
    Order getOrderByOrderNumber(String orderNumber);
}