package jmu.fyl.logistics.service.impl;

import jmu.fyl.logistics.dao.DriverDao;
import jmu.fyl.logistics.entity.Driver;
import jmu.fyl.logistics.service.DriverService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Service
@Transactional
public class DriverServiceImpl implements DriverService {

    @Autowired
    private DriverDao driverDao;

    @Override
    public int addDriver(Driver driver) {
        // 设置默认值
        if (driver.getCurrentStatus() == null) {
            driver.setCurrentStatus(1); // 默认待命
        }
        if (driver.getSafetyScore() == null) {
            driver.setSafetyScore(100.0); // 默认安全分100
        }
        if (driver.getTotalMileage() == null) {
            driver.setTotalMileage(0.0); // 默认行驶里程为0
        }

        return driverDao.insert(driver);
    }

    @Override
    public int updateDriver(Driver driver) {
        return driverDao.update(driver);
    }

    @Override
    public int deleteDriver(Integer driverId) {
        return driverDao.delete(driverId);
    }

    @Override
    public Driver getDriverById(Integer driverId) {
        return driverDao.findById(driverId);
    }

    @Override
    public Driver getDriverByUserId(Integer userId) {
        return driverDao.findByUserId(userId);
    }

    @Override
    public Driver getDriverByLicenseNumber(String licenseNumber) {
        return driverDao.findByLicenseNumber(licenseNumber);
    }

    @Override
    public List<Driver> getAllDrivers() {
        return driverDao.findAll();
    }

    @Override
    public List<Driver> getDriversByCurrentStatus(Integer currentStatus) {
        return driverDao.findByCurrentStatus(currentStatus);
    }

    @Override
    public List<Driver> getDriversByLicenseType(String licenseType) {
        return driverDao.findByLicenseType(licenseType);
    }

    @Override
    public List<Driver> getDriversByYearsExperience(Integer minYears, Integer maxYears) {
        return driverDao.findByYearsExperience(minYears, maxYears);
    }

    @Override
    public List<Driver> getDriversBySafetyScoreRange(Double minScore, Double maxScore) {
        return driverDao.findBySafetyScoreRange(minScore, maxScore);
    }

    @Override
    public List<Driver> getExpiringDrivers(Integer days) {
        return driverDao.findExpiringDrivers(days);
    }

    @Override
    public List<Driver> getAvailableDrivers(Integer stationId) {
        return driverDao.findAvailableDrivers(stationId);
    }

    @Override
    public List<Driver> getDriversByAssignedVehicleId(Integer vehicleId) {
        return driverDao.findByAssignedVehicleId(vehicleId);
    }

    @Override
    public int updateCurrentStatus(Integer driverId, Integer currentStatus) {
        return driverDao.updateCurrentStatus(driverId, currentStatus);
    }

    @Override
    public int updateAssignedVehicle(Integer driverId, Integer vehicleId) {
        return driverDao.updateAssignedVehicle(driverId, vehicleId);
    }

    @Override
    public int updateSafetyScore(Integer driverId, Double safetyScore) {
        return driverDao.updateSafetyScore(driverId, safetyScore);
    }

    @Override
    public int updateTotalMileage(Integer driverId, Double additionalMileage) {
        return driverDao.updateTotalMileage(driverId, additionalMileage);
    }

    @Override
    public int updateLastRestTime(Integer driverId, Date lastRestTime) {
        return driverDao.updateLastRestTime(driverId, lastRestTime);
    }

    @Override
    public List<Driver> searchDrivers(Map<String, Object> params) {
        return driverDao.findByCondition(params);
    }

    @Override
    public int countDrivers(Map<String, Object> params) {
        return driverDao.countByCondition(params);
    }

    @Override
    public Map<String, Object> getDriverStats() {
        Map<String, Object> stats = new HashMap<>();

        // 统计总数
        stats.put("total", countDrivers(new HashMap<>()));

        // 按状态统计
        stats.put("standby", driverDao.findByCurrentStatus(1).size());
        stats.put("working", driverDao.findByCurrentStatus(2).size());
        stats.put("resting", driverDao.findByCurrentStatus(3).size());
        stats.put("leave", driverDao.findByCurrentStatus(4).size());

        // 按驾照类型统计 - 修复：使用 HashMap 替代 Map.of()
        Map<String, Object> aLicenseParams = new HashMap<>();
        aLicenseParams.put("licenseType", "A1");
        stats.put("aLicense", countDrivers(aLicenseParams));

        Map<String, Object> bLicenseParams = new HashMap<>();
        bLicenseParams.put("licenseType", "B2");
        stats.put("bLicense", countDrivers(bLicenseParams));

        Map<String, Object> cLicenseParams = new HashMap<>();
        cLicenseParams.put("licenseType", "C1");
        stats.put("cLicense", countDrivers(cLicenseParams));

        // 平均安全分
        List<Driver> allDrivers = getAllDrivers();
        double totalScore = allDrivers.stream()
                .mapToDouble(Driver::getSafetyScore)
                .average()
                .orElse(0.0);
        stats.put("avgSafetyScore", Math.round(totalScore * 100) / 100.0);

        return stats;
    }
}