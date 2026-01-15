package jmu.fyl.logistics.service;

import jmu.fyl.logistics.entity.TransportTask;
import java.util.Date;
import java.util.List;
import java.util.Map;

public interface TransportTaskService {
    int addTransportTask(TransportTask transportTask);
    int updateTransportTask(TransportTask transportTask);
    int deleteTransportTask(Integer taskId);
    TransportTask getTransportTaskById(Integer taskId);
    TransportTask getTransportTaskByNumber(String taskNumber);
    List<TransportTask> getAllTransportTasks();
    List<TransportTask> getTransportTasksByTaskStatus(Integer taskStatus);
    List<TransportTask> getTransportTasksByDriverId(Integer driverId);
    List<TransportTask> getTransportTasksByVehicleId(Integer vehicleId);
    List<TransportTask> getTransportTasksByStartStationId(Integer stationId);
    List<TransportTask> getTransportTasksByEndStationId(Integer stationId);
    List<TransportTask> getTransportTasksBySupervisorId(Integer supervisorId);
    List<TransportTask> getTransportTasksByTaskType(Integer taskType);
    List<TransportTask> getTransportTasksByPriority(Integer taskPriority);
    List<TransportTask> getActiveTasks(Date date);
    List<TransportTask> getTasksByDateRange(Date startDate, Date endDate);
    int updateTaskStatus(Integer taskId, Integer taskStatus);
    int updateActualTimes(Integer taskId, Date actualDepartureTime, Date actualArrivalTime, Double actualDistance);
    int updateRouteInfo(Integer taskId, String routeInfo);
    int updateWeatherConditions(Integer taskId, String weatherConditions);
    int updateFuelConsumption(Integer taskId, Double fuelConsumption);
    int assignSupervisor(Integer taskId, Integer supervisorId);
    List<Map<String, Object>> getTaskStatsByStatus();
    List<Map<String, Object>> getTaskStatsByType(Date startDate, Date endDate);
    Map<String, Object> getDriverTaskStats(Integer driverId, Date startDate, Date endDate);
    List<TransportTask> searchTransportTasks(Map<String, Object> params);
    int countTransportTasks(Map<String, Object> params);
}