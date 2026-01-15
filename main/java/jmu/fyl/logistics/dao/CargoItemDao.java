package jmu.fyl.logistics.dao;

import jmu.fyl.logistics.entity.CargoItem;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Date;
import java.util.Map;


@Repository
public interface CargoItemDao extends BaseDao<CargoItem> {
    List<CargoItem> findByOrderId(@Param("orderId") Integer orderId);
    List<CargoItem> findByCargoCode(@Param("cargoCode") String cargoCode);
    List<CargoItem> findByCargoType(@Param("cargoType") String cargoType);
    List<CargoItem> findByStatus(@Param("status") Integer status);
    List<CargoItem> findByCurrentStationId(@Param("stationId") Integer stationId);
    List<CargoItem> findByCurrentLocationType(@Param("locationType") Integer locationType);
    CargoItem findByCodeAndOrder(@Param("cargoCode") String cargoCode, @Param("orderId") Integer orderId);
    List<CargoItem> findByScanTimeRange(@Param("startTime") Date startTime, @Param("endTime") Date endTime);
    List<CargoItem> findCargoesByOrderIds(@Param("orderIds") List<Integer> orderIds);
    int updateStatus(@Param("cargoId") Integer cargoId, @Param("status") Integer status);
    int updateCurrentStation(@Param("cargoId") Integer cargoId, @Param("stationId") Integer stationId);
    int updateCurrentLocation(@Param("cargoId") Integer cargoId,
                              @Param("locationType") Integer locationType,
                              @Param("stationId") Integer stationId);
    int updateLastScanTime(@Param("cargoId") Integer cargoId, @Param("lastScanTime") Date lastScanTime);
    int updateMultipleStatus(@Param("cargoIds") List<Integer> cargoIds, @Param("status") Integer status);
    Map<String, Object> getCargoStatsByOrder(@Param("orderId") Integer orderId);
    Map<String, Object> getCargoStatsByStation(@Param("stationId") Integer stationId);
}