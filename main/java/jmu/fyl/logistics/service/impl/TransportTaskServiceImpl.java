package jmu.fyl.logistics.service.impl;

import jmu.fyl.logistics.dao.TransportTaskDao;
import jmu.fyl.logistics.entity.TransportTask;
import jmu.fyl.logistics.service.TransportTaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Service
@Transactional
public class TransportTaskServiceImpl implements TransportTaskService {

    @Autowired
    private TransportTaskDao transportTaskDao;

    @Override
    public int addTransportTask(TransportTask transportTask) {
        // 生成任务编号
        if (transportTask.getTaskNumber() == null || transportTask.getTaskNumber().isEmpty()) {
            transportTask.setTaskNumber(generateTaskNumber());
        }

        // 设置默认值
        if (transportTask.getTaskStatus() == null) {
            transportTask.setTaskStatus(1); // 默认待调度
        }
        if (transportTask.getTaskPriority() == null) {
            transportTask.setTaskPriority(3); // 默认普通优先级
        }

        return transportTaskDao.insert(transportTask);
    }

    @Override
    public int updateTransportTask(TransportTask transportTask) {
        return transportTaskDao.update(transportTask);
    }

    @Override
    public int deleteTransportTask(Integer taskId) {
        return transportTaskDao.delete(taskId);
    }

    @Override
    public TransportTask getTransportTaskById(Integer taskId) {
        return transportTaskDao.findById(taskId);
    }

    @Override
    public TransportTask getTransportTaskByNumber(String taskNumber) {
        return transportTaskDao.findByTaskNumber(taskNumber);
    }

    @Override
    public List<TransportTask> getAllTransportTasks() {
        return transportTaskDao.findAll();
    }

    @Override
    public List<TransportTask> getTransportTasksByTaskStatus(Integer taskStatus) {
        return transportTaskDao.findByTaskStatus(taskStatus);
    }

    @Override
    public List<TransportTask> getTransportTasksByDriverId(Integer driverId) {
        return transportTaskDao.findByDriverId(driverId);
    }

    @Override
    public List<TransportTask> getTransportTasksByVehicleId(Integer vehicleId) {
        return transportTaskDao.findByVehicleId(vehicleId);
    }

    @Override
    public List<TransportTask> getTransportTasksByStartStationId(Integer stationId) {
        return transportTaskDao.findByStartStationId(stationId);
    }

    @Override
    public List<TransportTask> getTransportTasksByEndStationId(Integer stationId) {
        return transportTaskDao.findByEndStationId(stationId);
    }

    @Override
    public List<TransportTask> getTransportTasksBySupervisorId(Integer supervisorId) {
        return transportTaskDao.findBySupervisorId(supervisorId);
    }

    @Override
    public List<TransportTask> getTransportTasksByTaskType(Integer taskType) {
        return transportTaskDao.findByTaskType(taskType);
    }

    @Override
    public List<TransportTask> getTransportTasksByPriority(Integer taskPriority) {
        return transportTaskDao.findByPriority(taskPriority);
    }

    @Override
    public List<TransportTask> getActiveTasks(Date date) {
        return transportTaskDao.findActiveTasks(date);
    }

    @Override
    public List<TransportTask> getTasksByDateRange(Date startDate, Date endDate) {
        return transportTaskDao.findTasksByDateRange(startDate, endDate);
    }

    @Override
    public int updateTaskStatus(Integer taskId, Integer taskStatus) {
        return transportTaskDao.updateTaskStatus(taskId, taskStatus);
    }

    @Override
    public int updateActualTimes(Integer taskId, Date actualDepartureTime, Date actualArrivalTime, Double actualDistance) {
        return transportTaskDao.updateActualTimes(taskId, actualDepartureTime, actualArrivalTime, actualDistance);
    }

    @Override
    public int updateRouteInfo(Integer taskId, String routeInfo) {
        return transportTaskDao.updateRouteInfo(taskId, routeInfo);
    }

    @Override
    public int updateWeatherConditions(Integer taskId, String weatherConditions) {
        return transportTaskDao.updateWeatherConditions(taskId, weatherConditions);
    }

    @Override
    public int updateFuelConsumption(Integer taskId, Double fuelConsumption) {
        return transportTaskDao.updateFuelConsumption(taskId, fuelConsumption);
    }

    @Override
    public int assignSupervisor(Integer taskId, Integer supervisorId) {
        return transportTaskDao.assignSupervisor(taskId, supervisorId);
    }

    @Override
    public List<Map<String, Object>> getTaskStatsByStatus() {
        return transportTaskDao.getTaskStatsByStatus();
    }

    @Override
    public List<Map<String, Object>> getTaskStatsByType(Date startDate, Date endDate) {
        return transportTaskDao.getTaskStatsByType(startDate, endDate);
    }

    @Override
    public Map<String, Object> getDriverTaskStats(Integer driverId, Date startDate, Date endDate) {
        return transportTaskDao.getDriverTaskStats(driverId, startDate, endDate);
    }

    @Override
    public List<TransportTask> searchTransportTasks(Map<String, Object> params) {
        return transportTaskDao.findByCondition(params);
    }

    @Override
    public int countTransportTasks(Map<String, Object> params) {
        return transportTaskDao.countByCondition(params);
    }

    private String generateTaskNumber() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String timestamp = sdf.format(new Date());
        String random = String.format("%03d", (int)(Math.random() * 1000));
        return "TASK" + timestamp + random;
    }
}