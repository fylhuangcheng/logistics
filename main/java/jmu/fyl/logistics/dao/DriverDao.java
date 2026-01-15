package jmu.fyl.logistics.dao;

import jmu.fyl.logistics.entity.Driver;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface DriverDao extends BaseDao<Driver> {
    Driver findByUserId(@Param("userId") Integer userId);
    Driver findByLicenseNumber(@Param("licenseNumber") String licenseNumber);
    List<Driver> findByCurrentStatus(@Param("currentStatus") Integer currentStatus);
    List<Driver> findByLicenseType(@Param("licenseType") String licenseType);
    List<Driver> findByYearsExperience(@Param("minYears") Integer minYears, @Param("maxYears") Integer maxYears);
    List<Driver> findBySafetyScoreRange(@Param("minScore") Double minScore, @Param("maxScore") Double maxScore);
    List<Driver> findExpiringDrivers(@Param("days") Integer days); // 驾照即将到期
    List<Driver> findAvailableDrivers(@Param("stationId") Integer stationId); // 可用司机
    List<Driver> findByAssignedVehicleId(@Param("vehicleId") Integer vehicleId);
    int updateCurrentStatus(@Param("driverId") Integer driverId, @Param("currentStatus") Integer currentStatus);
    int updateAssignedVehicle(@Param("driverId") Integer driverId, @Param("vehicleId") Integer vehicleId);
    int updateSafetyScore(@Param("driverId") Integer driverId, @Param("safetyScore") Double safetyScore);
    int updateTotalMileage(@Param("driverId") Integer driverId, @Param("additionalMileage") Double additionalMileage);
    int updateLastRestTime(@Param("driverId") Integer driverId, @Param("lastRestTime") Date lastRestTime);
}
