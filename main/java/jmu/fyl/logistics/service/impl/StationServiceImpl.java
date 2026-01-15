package jmu.fyl.logistics.service.impl;

import jmu.fyl.logistics.dao.StationDao;
import jmu.fyl.logistics.entity.Station;
import jmu.fyl.logistics.service.OrderService;
import jmu.fyl.logistics.service.StationService;
import jmu.fyl.logistics.service.UserService;
import jmu.fyl.logistics.service.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Service
@Transactional
public class StationServiceImpl implements StationService {

    @Autowired
    private StationDao stationDao;

    @Autowired
    private VehicleService vehicleService;

    @Autowired
    private UserService userService;

    @Autowired
    private OrderService orderService;

    @Override
    public int addStation(Station station) {
        return stationDao.insert(station);
    }

    @Override
    public int updateStation(Station station) {
        return stationDao.update(station);
    }

    @Override
    public int deleteStation(Integer stationId) {
        return stationDao.delete(stationId);
    }

    @Override
    public Station getStationById(Integer stationId) {
        return stationDao.findById(stationId);
    }

    @Override
    public Station getStationByCode(String stationCode) {
        return stationDao.findByCode(stationCode);
    }

    @Override
    public List<Station> getAllStations() {
        return stationDao.findAll();
    }

    @Override
    public List<Station> getStationsByStatus(Integer status) {
        return stationDao.findByStatus(status);
    }

    @Override
    public List<Station> searchStations(Map<String, Object> params) {
        return stationDao.findByCondition(params);
    }

    @Override
    public int countStations(Map<String, Object> params) {
        return stationDao.countByCondition(params);
    }

    @Override
    public boolean checkStationCodeExists(String stationCode) {
        return stationDao.checkCodeExists(stationCode) > 0;
    }

    @Override
    public Map<String, Object> getStationStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", countStations(new HashMap<>()));
        stats.put("active", stationDao.findByStatus(1).size());
        stats.put("inactive", stationDao.findByStatus(0).size());
        return stats;
    }
    @Override
    public Map<String, Object> getStationDetailStats(Integer stationId) {
        Map<String, Object> stats = new HashMap<>();

        try {
            // 1. 获取网点基本信息
            Station station = getStationById(stationId);
            if (station == null) {
                stats.put("error", "网点不存在");
                return stats;
            }

            // 2. 统计车辆信息
            Map<String, Object> vehicleParams = new HashMap<>();
            vehicleParams.put("currentStationId", stationId);
            stats.put("vehicleCount", vehicleService.countVehicles(vehicleParams));

            Map<String, Object> activeVehicleParams = new HashMap<>();
            activeVehicleParams.put("currentStationId", stationId);
            activeVehicleParams.put("status", 1); // 空闲状态
            stats.put("activeVehicleCount", vehicleService.countVehicles(activeVehicleParams));

            // 3. 统计员工信息
            Map<String, Object> employeeParams = new HashMap<>();
            employeeParams.put("stationId", stationId);
            employeeParams.put("userType", 2); // 司机
            stats.put("employeeCount", userService.countUsers(employeeParams));

            // 4. 统计订单信息
            // 作为起始网点的订单
            Map<String, Object> startOrderParams = new HashMap<>();
            startOrderParams.put("startStationId", stationId);
            int startOrders = orderService.countOrders(startOrderParams);

            // 作为目的网点的订单
            Map<String, Object> endOrderParams = new HashMap<>();
            endOrderParams.put("endStationId", stationId);
            int endOrders = orderService.countOrders(endOrderParams);

            // 当前所在网点的订单
            Map<String, Object> currentOrderParams = new HashMap<>();
            currentOrderParams.put("currentStationId", stationId);
            int currentOrders = orderService.countOrders(currentOrderParams);

            stats.put("orderCount", startOrders + endOrders + currentOrders);

            // 5. 今日订单（如果需要）
            // Map<String, Object> todayParams = new HashMap<>();
            // todayParams.put("stationId", stationId);
            // todayParams.put("today", true);
            // stats.put("todayOrders", orderService.countOrders(todayParams));

        } catch (Exception e) {
            e.printStackTrace();
            // 发生异常时返回0值
            stats.put("vehicleCount", 0);
            stats.put("activeVehicleCount", 0);
            stats.put("employeeCount", 0);
            stats.put("orderCount", 0);
        }

        return stats;
    }
}