package jmu.fyl.logistics.dao;

import jmu.fyl.logistics.entity.Order;
import org.apache.ibatis.annotations.MapKey;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Repository
public interface OrderDao extends BaseDao<Order> {
    Order findByOrderNumber(@Param("orderNumber") String orderNumber);
    List<Order> findByStatus(@Param("status") Integer status);
    List<Order> findBySenderPhone(@Param("phone") String phone);
    List<Order> findByReceiverPhone(@Param("phone") String phone);
    List<Order> findByCreateTimeRange(@Param("startTime") Date startTime,
                                      @Param("endTime") Date endTime);
    List<Order> findByCreateUserId(@Param("userId") Integer userId);
    List<Order> findOrdersByStation(@Param("stationId") Integer stationId,
                                    @Param("status") Integer status);
    List<Order> findByTransportTaskId(@Param("transportTaskId") Integer transportTaskId); // 新增
    List<Order> findByVehicleId(@Param("vehicleId") Integer vehicleId); // 新增
    int updateStatus(@Param("orderId") Integer orderId,
                     @Param("status") Integer status);
    int updateCurrentStation(@Param("orderId") Integer orderId,
                             @Param("stationId") Integer stationId);
    int assignVehicle(@Param("orderId") Integer orderId,
                      @Param("vehicleId") Integer vehicleId);
    int assignTransportTask(@Param("orderId") Integer orderId,
                            @Param("taskId") Integer taskId); // 新增
    @MapKey("status")
    Map<String, Object> getOrderStats();
    @MapKey("date")
    List<Map<String, Object>> getOrderStatsByDate(@Param("startDate") Date startDate,
                                                  @Param("endDate") Date endDate);

}
