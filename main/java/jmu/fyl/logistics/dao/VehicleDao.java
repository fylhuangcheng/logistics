package jmu.fyl.logistics.dao;

import jmu.fyl.logistics.entity.Vehicle;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VehicleDao extends BaseDao<Vehicle> {
    Vehicle findByLicensePlate(@Param("licensePlate") String licensePlate);
    List<Vehicle> findByStationId(@Param("stationId") Integer stationId);
    List<Vehicle> findByStatus(@Param("status") Integer status);
    List<Vehicle> findByCurrentDriverId(@Param("driverId") Integer driverId); // 新增
    List<Vehicle> findAvailableVehicles(@Param("stationId") Integer stationId,
                                        @Param("minCapacity") Double minCapacity);
    int updateStatus(@Param("vehicleId") Integer vehicleId, @Param("status") Integer status);
    int updateCurrentStation(@Param("vehicleId") Integer vehicleId, @Param("stationId") Integer stationId);
    int assignDriver(@Param("vehicleId") Integer vehicleId, @Param("driverId") Integer driverId); // 新增
    int clearDriver(@Param("vehicleId") Integer vehicleId); // 新增
}