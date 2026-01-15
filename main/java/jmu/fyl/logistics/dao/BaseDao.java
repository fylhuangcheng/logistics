package jmu.fyl.logistics.dao;

import java.util.List;
import java.util.Map;

public interface BaseDao<T> {
    int insert(T entity);
    int update(T entity);
    int delete(Integer id);
    T findById(Integer id);
    List<T> findAll();
    List<T> findByCondition(Map<String, Object> params);
    int countByCondition(Map<String, Object> params);
}