package jmu.fyl.logistics.service;

import jmu.fyl.logistics.entity.Station;
import java.util.List;
import java.util.Map;


public interface StationService {
    int addStation(Station station);
    int updateStation(Station station);
    int deleteStation(Integer stationId);
    Station getStationById(Integer stationId);
    Station getStationByCode(String stationCode);
    List<Station> getAllStations();
    List<Station> getStationsByStatus(Integer status);
    List<Station> searchStations(Map<String, Object> params);
    int countStations(Map<String, Object> params);
    boolean checkStationCodeExists(String stationCode);
    Map<String, Object> getStationStats();
    // 在 StationService 接口中添加
    Map<String, Object> getStationDetailStats(Integer stationId);
}