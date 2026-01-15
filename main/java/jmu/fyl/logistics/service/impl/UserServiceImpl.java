package jmu.fyl.logistics.service.impl;

import jmu.fyl.logistics.dao.UserDao;
import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;
import org.springframework.util.DigestUtils;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.HashMap;

@Service
@Transactional
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public User register(User user) {
        // 检查用户名是否已存在
        if (checkUsernameExists(user.getUsername())) {
            throw new RuntimeException("用户名已存在");
        }

        // 检查邮箱是否已存在
        if (user.getEmail() != null && !user.getEmail().isEmpty()) {
            if (checkEmailExists(user.getEmail())) {
                throw new RuntimeException("邮箱已被注册");
            }
        }

        // 检查手机号是否已存在
        if (user.getPhone() != null && !user.getPhone().isEmpty()) {
            if (checkPhoneExists(user.getPhone())) {
                throw new RuntimeException("手机号已被注册");
            }
        }

        // 设置默认值
        if (user.getUserType() == null) {
            user.setUserType(3); // 默认为客户类型
        }
        if (user.getStatus() == null) {
            user.setStatus(1); // 默认启用状态
        }

        // 加密密码
        user.setPassword(encodePassword(user.getPassword()));

        // 保存用户
        userDao.insert(user);
        return user;
    }

    @Override
    public boolean checkEmailExists(String email) {
        if (email == null || email.isEmpty()) {
            return false;
        }
        return userDao.checkEmailExists(email) > 0;
    }

    @Override
    public boolean checkPhoneExists(String phone) {
        if (phone == null || phone.isEmpty()) {
            return false;
        }
        return userDao.checkPhoneExists(phone) > 0;
    }

    @Override
    public void logout() {
        // 这里主要处理一些清理工作，实际的session清理在Controller中完成
        System.out.println("用户注销");
    }


    @Override
    public int addUser(User user) {
        if (user.getPassword() != null) {
            user.setPassword(encodePassword(user.getPassword()));
        }
        return userDao.insert(user);
    }

    @Override
    public int updateUser(User user) {
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            user.setPassword(encodePassword(user.getPassword()));
        }
        return userDao.update(user);
    }

    @Override
    public int deleteUser(Integer userId) {
        return userDao.delete(userId);
    }

    @Override
    public User getUserById(Integer userId) {
        return userDao.findById(userId);
    }

    @Override
    public User getUserByUsername(String username) {
        return userDao.findByUsername(username);
    }

    @Override
    public List<User> getAllUsers() {
        return userDao.findAll();
    }

    @Override
    public List<User> getUsersByType(Integer userType) {
        return userDao.findByUserType(userType);
    }

    @Override
    public List<User> getUsersByStation(Integer stationId) {
        return Collections.emptyList();
    }


    @Override
    public int updatePassword(Integer userId, String newPassword) {
        String encodedPassword = encodePassword(newPassword);
        return userDao.updatePassword(userId, encodedPassword);
    }

    @Override
    public int updateUserStatus(Integer userId, Integer status) {
        return userDao.updateStatus(userId, status);
    }

    @Override
    public boolean authenticate(String username, String password) {
        System.out.println("开始验证用户: " + username);

        User user = userDao.findByUsername(username);
        if (user == null) {
            System.out.println("用户不存在: " + username);
            return false;
        }

        System.out.println("数据库中的用户状态: " + user.getStatus());
        System.out.println("输入的原始密码: " + password);

        // 对输入的密码进行MD5加密
        String encodedInputPassword = encodePassword(password);
        System.out.println("输入密码MD5后: " + encodedInputPassword);
        System.out.println("数据库中存储的密码: " + user.getPassword());

        // 比较加密后的密码
        boolean passwordMatch = encodedInputPassword.equals(user.getPassword());
        boolean isActive = user.getStatus() == 1;

        System.out.println("密码是否匹配: " + passwordMatch);
        System.out.println("用户是否启用: " + isActive);

        return passwordMatch && isActive;
    }

    @Override
    public boolean checkUsernameExists(String username) {
        return userDao.checkUsernameExists(username) > 0;
    }

    @Override
    public List<User> searchUsers(Map<String, Object> params) {
        return userDao.findByCondition(params);
    }

    @Override
    public int countUsers(Map<String, Object> params) {
        return userDao.countByCondition(params);
    }

    @Override
    public Map<String, Object> getUserStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total", countUsers(new HashMap<>()));
        stats.put("active", userDao.findByStatus(1).size());
        stats.put("inactive", userDao.findByStatus(0).size());
        stats.put("admin", userDao.findByUserType(1).size());
        stats.put("customer", userDao.findByUserType(3).size());
        return stats;
    }

    private String encodePassword(String password) {
        return DigestUtils.md5DigestAsHex(password.getBytes(StandardCharsets.UTF_8));
    }
}