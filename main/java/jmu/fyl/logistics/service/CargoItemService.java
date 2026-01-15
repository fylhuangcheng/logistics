package jmu.fyl.logistics.service;

import jmu.fyl.logistics.entity.CargoItem;
import jmu.fyl.logistics.entity.User;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface CargoItemService {
    int addCargoItem(CargoItem cargoItem);

    // 添加获取客户所有货物的方法

    List<CargoItem> searchCargoItems(Map<String, Object> params, User user);

    int countCargoItems(Map<String, Object> params, User user);

    int updateCargoItem(CargoItem cargoItem);
    int deleteCargoItem(Integer cargoId);
    CargoItem getCargoItemById(Integer cargoId);
    List<CargoItem> getAllCargoItems();
    List<CargoItem> getCargoItemsByOrderId(Integer orderId);
    List<CargoItem> getCargoItemsByCargoCode(String cargoCode);
    List<CargoItem> getCargoItemsByCargoType(String cargoType);
    List<CargoItem> getCargoItemsByStatus(Integer status);
    List<CargoItem> getCargoItemsByCurrentStationId(Integer stationId);
    List<CargoItem> getCargoItemsByCurrentLocationType(Integer locationType);
    List<CargoItem> getCargoItemsByScanTimeRange(Date startTime, Date endTime);
    int updateCargoStatus(Integer cargoId, Integer status);
    int updateCurrentStation(Integer cargoId, Integer stationId);
    int updateCurrentLocation(Integer cargoId, Integer locationType, Integer stationId);
    int updateLastScanTime(Integer cargoId, Date lastScanTime);
    int updateMultipleStatus(List<Integer> cargoIds, Integer status);
    Map<String, Object> getCargoStatsByOrder(Integer orderId);
    Map<String, Object> getCargoStatsByStation(Integer stationId);
    List<CargoItem> searchCargoItems(Map<String, Object> params);
    int countCargoItems(Map<String, Object> params);
}