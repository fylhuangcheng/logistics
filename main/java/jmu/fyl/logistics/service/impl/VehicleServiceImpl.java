package jmu.fyl.logistics.service.impl;

import jmu.fyl.logistics.dao.VehicleDao;
import jmu.fyl.logistics.entity.Vehicle;
import jmu.fyl.logistics.service.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.HashMap;



@Service
@Transactional
public class VehicleServiceImpl implements VehicleService {

    @Autowired
    private VehicleDao vehicleDao;

    @Override
    public int addVehicle(Vehicle vehicle) {
        return vehicleDao.insert(vehicle);
    }

    @Override
    public int updateVehicle(Vehicle vehicle) {
        return vehicleDao.update(vehicle);
    }

    @Override
    public int deleteVehicle(Integer vehicleId) {
        return vehicleDao.delete(vehicleId);
    }

    @Override
    public Vehicle getVehicleById(Integer vehicleId) {
        return vehicleDao.findById(vehicleId);
    }

    @Override
    public Vehicle getVehicleByLicensePlate(String licensePlate) {
        return vehicleDao.findByLicensePlate(licensePlate);
    }

    @Override
    public List<Vehicle> getAllVehicles() {
        return vehicleDao.findAll();
    }

    @Override
    public List<Vehicle> getVehiclesByStation(Integer stationId) {
        return vehicleDao.findByStationId(stationId);
    }

    @Override
    public List<Vehicle> getAvailableVehicles(Integer stationId, Double minCapacity) {
        return vehicleDao.findAvailableVehicles(stationId, minCapacity);
    }

    @Override
    public List<Vehicle> searchVehicles(Map<String, Object> params) {
        return vehicleDao.findByCondition(params);
    }

    @Override
    public int countVehicles(Map<String, Object> params) {
        return vehicleDao.countByCondition(params);
    }

    @Override
    public int updateVehicleStatus(Integer vehicleId, Integer status) {
        return vehicleDao.updateStatus(vehicleId, status);
    }

    @Override
    public int updateVehicleLocation(Integer vehicleId, Integer stationId) {
        return vehicleDao.updateCurrentStation(vehicleId, stationId);
    }

    @Override
    public Map<String, Object> getVehicleStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", countVehicles(new HashMap<>()));
        stats.put("available", vehicleDao.findByStatus(1).size());
        stats.put("busy", vehicleDao.findByStatus(2).size());
        stats.put("maintenance", vehicleDao.findByStatus(3).size());

        // 按类型统计
        Map<String, Object> params = new HashMap<>();
        params.put("vehicleType", "重型货车");
        stats.put("heavyTruck", countVehicles(params));

        params.put("vehicleType", "中型货车");
        stats.put("mediumTruck", countVehicles(params));

        params.put("vehicleType", "厢式货车");
        stats.put("van", countVehicles(params));

        return stats;
    }
    @Override
    public int assignDriver(Integer vehicleId, Integer driverId) {
        return vehicleDao.assignDriver(vehicleId, driverId);
    }

    @Override
    public int clearDriver(Integer vehicleId) {
        return vehicleDao.clearDriver(vehicleId);
    }

    @Override
    public List<Vehicle> getVehiclesByCurrentDriverId(Integer driverId) {
        return vehicleDao.findByCurrentDriverId(driverId);
    }
}