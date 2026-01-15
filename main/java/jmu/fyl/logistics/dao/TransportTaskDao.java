package jmu.fyl.logistics.dao;

import jmu.fyl.logistics.entity.TransportTask;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Repository
public interface TransportTaskDao extends BaseDao<TransportTask> {
    TransportTask findByTaskNumber(@Param("taskNumber") String taskNumber);
    List<TransportTask> findByTaskStatus(@Param("taskStatus") Integer taskStatus);
    List<TransportTask> findByDriverId(@Param("driverId") Integer driverId);
    List<TransportTask> findByVehicleId(@Param("vehicleId") Integer vehicleId);
    List<TransportTask> findByStartStationId(@Param("stationId") Integer stationId);
    List<TransportTask> findByEndStationId(@Param("stationId") Integer stationId);
    List<TransportTask> findBySupervisorId(@Param("supervisorId") Integer supervisorId);
    List<TransportTask> findByTaskType(@Param("taskType") Integer taskType);
    List<TransportTask> findByPriority(@Param("taskPriority") Integer taskPriority);
    List<TransportTask> findActiveTasks(@Param("date") Date date);
    List<TransportTask> findTasksByDateRange(@Param("startDate") Date startDate,
                                             @Param("endDate") Date endDate);
    int updateTaskStatus(@Param("taskId") Integer taskId, @Param("taskStatus") Integer taskStatus);
    int updateActualTimes(@Param("taskId") Integer taskId,
                          @Param("actualDepartureTime") Date actualDepartureTime,
                          @Param("actualArrivalTime") Date actualArrivalTime,
                          @Param("actualDistance") Double actualDistance);
    int updateRouteInfo(@Param("taskId") Integer taskId, @Param("routeInfo") String routeInfo);
    int updateWeatherConditions(@Param("taskId") Integer taskId, @Param("weatherConditions") String weatherConditions);
    int updateFuelConsumption(@Param("taskId") Integer taskId, @Param("fuelConsumption") Double fuelConsumption);
    int assignSupervisor(@Param("taskId") Integer taskId, @Param("supervisorId") Integer supervisorId);
    List<Map<String, Object>> getTaskStatsByStatus();
    List<Map<String, Object>> getTaskStatsByType(@Param("startDate") Date startDate,
                                                 @Param("endDate") Date endDate);
    Map<String, Object> getDriverTaskStats(@Param("driverId") Integer driverId,
                                           @Param("startDate") Date startDate,
                                           @Param("endDate") Date endDate);
}