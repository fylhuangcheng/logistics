package jmu.fyl.logistics.service;

import jmu.fyl.logistics.entity.User;
import java.util.List;
import java.util.Map;


public interface UserService {
    int addUser(User user);
    int updateUser(User user);
    int deleteUser(Integer userId);
    User getUserById(Integer userId);
    User getUserByUsername(String username);
    List<User> getAllUsers();
    List<User> getUsersByType(Integer userType);
    List<User> getUsersByStation(Integer stationId);
    int updatePassword(Integer userId, String newPassword);
    int updateUserStatus(Integer userId, Integer status);
    boolean authenticate(String username, String password);
    boolean checkUsernameExists(String username);
    List<User> searchUsers(Map<String, Object> params);
    int countUsers(Map<String, Object> params);
    Map<String, Object> getUserStats();
    // 新增：注册用户
    User register(User user);
    // 新增：检查邮箱是否存在
    boolean checkEmailExists(String email);
    // 新增：检查手机号是否存在
    boolean checkPhoneExists(String phone);
    // 新增：用户注销
    void logout();

}