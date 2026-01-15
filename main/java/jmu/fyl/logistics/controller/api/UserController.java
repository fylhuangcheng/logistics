package jmu.fyl.logistics.controller.api;

import jmu.fyl.logistics.controller.web.BaseController;
import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.UserService;
import jmu.fyl.logistics.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.HashMap;
import java.util.Map;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;


@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public Result<User> register(@RequestBody User user) {
        try {
            // 验证必填字段
            if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
                return Result.error(400, "用户名不能为空");
            }
            if (user.getPassword() == null || user.getPassword().isEmpty()) {
                return Result.error(400, "密码不能为空");
            }
            if (user.getRealName() == null || user.getRealName().trim().isEmpty()) {
                return Result.error(400, "真实姓名不能为空");
            }

            // 注册用户
            User registeredUser = userService.register(user);

            // 清除密码信息
            registeredUser.setPassword(null);

            return Result.success("注册成功", registeredUser);
        } catch (RuntimeException e) {
            return Result.error(400, e.getMessage());
        } catch (Exception e) {
            return Result.error("注册失败: " + e.getMessage());
        }
    }

    // 检查邮箱是否已存在
    @GetMapping("/check-email")
    public Result<Map<String, Boolean>> checkEmail(@RequestParam String email) {
        Map<String, Boolean> result = new HashMap<>();
        result.put("exists", userService.checkEmailExists(email));
        return Result.success(result);
    }

    // 检查手机号是否已存在
    @GetMapping("/check-phone")
    public Result<Map<String, Boolean>> checkPhone(@RequestParam String phone) {
        Map<String, Boolean> result = new HashMap<>();
        result.put("exists", userService.checkPhoneExists(phone));
        return Result.success(result);
    }
    @PostMapping
    public Result<User> addUser(@RequestBody User user) {
        try {
            // 检查用户名是否已存在
            if (userService.checkUsernameExists(user.getUsername())) {
                return Result.error(400, "用户名已存在");
            }

            userService.addUser(user);
            return Result.success("用户添加成功", user);
        } catch (Exception e) {
            return Result.error("添加用户失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public Result<User> updateUser(@PathVariable Integer id, @RequestBody User user) {
        try {
            user.setUserId(id);
            userService.updateUser(user);
            return Result.success("用户更新成功", user);
        } catch (Exception e) {
            return Result.error("更新用户失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteUser(@PathVariable Integer id) {
        try {
            userService.deleteUser(id);
            return Result.success("用户删除成功");
        } catch (Exception e) {
            return Result.error("删除用户失败: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public Result<User> getUserById(@PathVariable Integer id) {
        try {
            User user = userService.getUserById(id);
            if (user != null) {
                return Result.success(user);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取用户信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/username/{username}")
    public Result<User> getUserByUsername(@PathVariable String username) {
        try {
            User user = userService.getUserByUsername(username);
            if (user != null) {
                return Result.success(user);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取用户信息失败: " + e.getMessage());
        }
    }

    @PostMapping("/login")
    public Result<User> login(@RequestBody Map<String, String> loginInfo, HttpSession session) {
        try {
            String username = loginInfo.get("username");
            String password = loginInfo.get("password");

            System.out.println("API收到登录请求 - 用户名: " + username);

            boolean authenticated = userService.authenticate(username, password);
            if (authenticated) {
                User user = userService.getUserByUsername(username);
                System.out.println("用户验证成功: " + user.getUserId() + ", " + user.getUsername());

                // 清除密码信息
                user.setPassword(null);
                // 存入session
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getUserId());
                session.setAttribute("username", user.getUsername());
                session.setAttribute("userType", user.getUserType());

                System.out.println("Session设置完成: " + session.getId());

                return Result.success("登录成功", user);
            } else {
                System.out.println("用户验证失败: " + username);
                return Result.error(401, "用户名或密码错误");
            }
        } catch (Exception e) {
            System.err.println("登录异常: " + e.getMessage());
            e.printStackTrace();
            return Result.error("登录失败: " + e.getMessage());
        }
    }

    @PostMapping("/logout")
    public Result<Void> logout(HttpSession session) {
        try {
            userService.logout();
            session.invalidate();
            return Result.success("退出登录成功");
        } catch (Exception e) {
            return Result.error("退出登录失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/password")
    public Result<Void> updatePassword(@PathVariable Integer id, @RequestBody Map<String, String> passwordInfo) {
        try {
            String newPassword = passwordInfo.get("newPassword");
            userService.updatePassword(id, newPassword);
            return Result.success("密码修改成功");
        } catch (Exception e) {
            return Result.error("修改密码失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/status")
    public Result<Void> updateUserStatus(@PathVariable Integer id, @RequestBody Map<String, Integer> statusInfo) {
        try {
            Integer status = statusInfo.get("status");
            userService.updateUserStatus(id, status);
            return Result.success("用户状态更新成功");
        } catch (Exception e) {
            return Result.error("更新用户状态失败: " + e.getMessage());
        }
    }

    @GetMapping("/check-username")
    public Result<Map<String, Boolean>> checkUsername(@RequestParam String username) {
        Map<String, Boolean> result = new HashMap<>();
        result.put("exists", userService.checkUsernameExists(username));
        return Result.success(result);
    }


    @GetMapping("/type/{userType}")
    public Result<List<User>> getUsersByType(@PathVariable Integer userType) {
        try {
            List<User> users = userService.getUsersByType(userType);
            return Result.success(users);
        } catch (Exception e) {
            return Result.error("获取用户列表失败: " + e.getMessage());
        }
    }

    @GetMapping("/stations/{stationId}")
    public Result<List<User>> getUsersByStation(@PathVariable Integer stationId) {
        try {
            List<User> users = userService.getUsersByStation(stationId);
            return Result.success(users);
        } catch (Exception e) {
            return Result.error("获取站点用户列表失败: " + e.getMessage());
        }
    }

    @GetMapping("/current")
    public Result<User> getCurrentUser(HttpSession session) {
        try {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                return Result.success(user);
            } else {
                return Result.unauthorized();
            }
        } catch (Exception e) {
            return Result.error("获取当前用户信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/stats")
    public Result<Map<String, Object>> getUserStats() {
        try {
            Map<String, Object> stats = userService.getUserStats();
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取用户统计失败: " + e.getMessage());
        }
    }
}