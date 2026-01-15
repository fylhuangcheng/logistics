package jmu.fyl.logistics.dao;

import jmu.fyl.logistics.entity.Order;
import jmu.fyl.logistics.entity.User;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;


@Repository
public interface UserDao extends BaseDao<User> {
    User findByUsername(@Param("username") String username);
    List<User> findByStatus(@Param("status") Integer status);
    List<User> findByUserType(@Param("userType") Integer userType);
    int updatePassword(@Param("userId") Integer userId, @Param("password") String password);
    int updateStatus(@Param("userId") Integer userId, @Param("status") Integer status);
    int checkUsernameExists(@Param("username") String username);
    int checkEmailExists(@Param("email") String email);
    int checkPhoneExists(@Param("phone") String phone);
}