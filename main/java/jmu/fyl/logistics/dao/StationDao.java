package jmu.fyl.logistics.dao;

import jmu.fyl.logistics.entity.Station;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;
import java.util.List;


@Repository
public interface StationDao extends BaseDao<Station> {
    Station findByCode(@Param("stationCode") String stationCode);
    List<Station> findByStatus(@Param("status") Integer status);
    List<Station> findByNameLike(@Param("name") String name);
    int checkCodeExists(@Param("stationCode") String stationCode);
}
