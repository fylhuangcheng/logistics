package jmu.fyl.logistics.service;

import jmu.fyl.logistics.entity.Driver;
import java.util.Date;
import java.util.List;
import java.util.Map;

public interface DriverService {
    int addDriver(Driver driver);
    int updateDriver(Driver driver);
    int deleteDriver(Integer driverId);
    Driver getDriverById(Integer driverId);
    Driver getDriverByUserId(Integer userId);
    Driver getDriverByLicenseNumber(String licenseNumber);
    List<Driver> getAllDrivers();
    List<Driver> getDriversByCurrentStatus(Integer currentStatus);
    List<Driver> getDriversByLicenseType(String licenseType);
    List<Driver> getDriversByYearsExperience(Integer minYears, Integer maxYears);
    List<Driver> getDriversBySafetyScoreRange(Double minScore, Double maxScore);
    List<Driver> getExpiringDrivers(Integer days);
    List<Driver> getAvailableDrivers(Integer stationId);
    List<Driver> getDriversByAssignedVehicleId(Integer vehicleId);
    int updateCurrentStatus(Integer driverId, Integer currentStatus);
    int updateAssignedVehicle(Integer driverId, Integer vehicleId);
    int updateSafetyScore(Integer driverId, Double safetyScore);
    int updateTotalMileage(Integer driverId, Double additionalMileage);
    int updateLastRestTime(Integer driverId, Date lastRestTime);
    List<Driver> searchDrivers(Map<String, Object> params);
    int countDrivers(Map<String, Object> params);
    Map<String, Object> getDriverStats();
}