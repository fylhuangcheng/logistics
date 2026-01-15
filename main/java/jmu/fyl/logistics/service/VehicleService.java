package jmu.fyl.logistics.service;

import jmu.fyl.logistics.entity.Vehicle;
import java.util.List;
import java.util.Map;


public interface VehicleService {
    int addVehicle(Vehicle vehicle);
    int updateVehicle(Vehicle vehicle);
    int deleteVehicle(Integer vehicleId);
    Vehicle getVehicleById(Integer vehicleId);
    Vehicle getVehicleByLicensePlate(String licensePlate);
    List<Vehicle> getAllVehicles();
    List<Vehicle> getVehiclesByStation(Integer stationId);
    List<Vehicle> getAvailableVehicles(Integer stationId, Double minCapacity);
    List<Vehicle> searchVehicles(Map<String, Object> params);
    int countVehicles(Map<String, Object> params);
    int updateVehicleStatus(Integer vehicleId, Integer status);
    int updateVehicleLocation(Integer vehicleId, Integer stationId);
    Map<String, Object> getVehicleStats();
    // 添加以下方法到 VehicleService 接口
    int assignDriver(Integer vehicleId, Integer driverId);
    int clearDriver(Integer vehicleId);
    List<Vehicle> getVehiclesByCurrentDriverId(Integer driverId);
    }