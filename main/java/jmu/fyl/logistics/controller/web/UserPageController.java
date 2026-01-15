package jmu.fyl.logistics.controller.web;

import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.StationService;
import jmu.fyl.logistics.service.UserService;
import jmu.fyl.logistics.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.net.URLEncoder;

@Controller
@RequestMapping("/users")
public class UserPageController extends BaseController {

    @Autowired
    private UserService userService;

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String realName,
            @RequestParam(required = false) Integer userType,
            @RequestParam(required = false) Integer status,
            Model model) {

        // 设置页面信息
        model.addAttribute("pageTitle", "用户管理");
        model.addAttribute("activeMenu", "users");
        model.addAttribute("subMenu", "user_list");
        model.addAttribute("contentPage", "users/list.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> current = new HashMap<>();
        current.put("name", "用户列表");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 计算分页参数 - 使用 start 和 limit
        int start = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();
        params.put("username", username);
        params.put("realName", realName);
        params.put("userType", userType);
        params.put("status", status);
        params.put("start", start);
        params.put("limit", size);

        List<User> users = userService.searchUsers(params);
        int total = userService.countUsers(params);

        // 创建分页数据Map
        Map<String, Object> pageData = new HashMap<>();
        pageData.put("list", users);
        pageData.put("total", total);
        pageData.put("pageNum", page);
        pageData.put("pageSize", size);
        pageData.put("pages", (int) Math.ceil((double) total / size));

        // 使用Result包装数据
        Result<Map<String, Object>> result = Result.success("查询成功", pageData);
        model.addAttribute("result", result);

        // 同时保留原来的属性
        model.addAttribute("users", users);
        model.addAttribute("total", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", (int) Math.ceil((double) total / size));
        model.addAttribute("searchParams", params);

        // 获取用户统计
        model.addAttribute("userStats", userService.getUserStats());

        return "layout/main";
    }

    @GetMapping("/add")
    public String addForm(Model model) {
        // 检查权限 - 只有管理员可以新增用户
        if (currentUser == null || currentUser.getUserType() != 1) {
            return "redirect:/";
        }

        model.addAttribute("pageTitle", "新增用户");
        model.addAttribute("activeMenu", "users");
        model.addAttribute("subMenu", "user_add");
        model.addAttribute("contentPage", "users/form.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "用户列表");
        list.put("url", "/users");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "新增用户");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);


        // 创建一个空用户对象用于表单
        model.addAttribute("user", new User());

        return "layout/main";
    }

    @PostMapping("/add")
    public String createUser(@ModelAttribute User user, Model model) {
        try {
            // 检查权限
            if (currentUser == null || currentUser.getUserType() != 1) {
                return "redirect:/";
            }

            // 使用 Service 中存在的 addUser 方法
            userService.addUser(user);
            return "redirect:/users/" + user.getUserId() + "?success=用户创建成功";
        } catch (Exception e) {
            model.addAttribute("error", "创建用户失败: " + e.getMessage());
            model.addAttribute("user", user);
            model.addAttribute("pageTitle", "新增用户");
            model.addAttribute("activeMenu", "users");
            model.addAttribute("subMenu", "user_add");
            model.addAttribute("contentPage", "users/form.jsp");
            return "layout/main";
        }
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Integer id, Model model) {
        try {
            System.out.println("请求用户详情，用户ID: " + id);

            User user = userService.getUserById(id);
            if (user == null) {
                System.out.println("用户不存在，ID: " + id);
                model.addAttribute("error", "用户不存在");
                return "redirect:/users?error=用户不存在";
            }

            System.out.println("查询到用户: " + user.getUsername());


            model.addAttribute("pageTitle", "用户详情 - " + user.getRealName());
            model.addAttribute("activeMenu", "users");
            model.addAttribute("contentPage", "users/detail.jsp");
            model.addAttribute("user", user);

            // 设置面包屑导航
            List<Map<String, String>> breadcrumb = new ArrayList<>();
            Map<String, String> home = new HashMap<>();
            home.put("name", "首页");
            home.put("url", "/");
            breadcrumb.add(home);

            Map<String, String> list = new HashMap<>();
            list.put("name", "用户列表");
            list.put("url", "/users");
            breadcrumb.add(list);

            Map<String, String> current = new HashMap<>();
            current.put("name", "用户详情");
            breadcrumb.add(current);
            model.addAttribute("breadcrumb", breadcrumb);

            return "layout/main";

        } catch (Exception e) {
            System.err.println("用户详情页面异常: " + e.getMessage());
            e.printStackTrace();
            return "redirect:/users?error=" + e.getMessage();
        }
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Integer id, Model model) {
        // 检查权限（只能编辑自己或管理员权限）
        if (currentUser == null || (currentUser.getUserType() != 1 && !currentUser.getUserId().equals(id))) {
            return "redirect:/";
        }

        User user = userService.getUserById(id);

        model.addAttribute("pageTitle", "编辑用户 - " + user.getRealName());
        model.addAttribute("activeMenu", "users");
        model.addAttribute("contentPage", "users/form.jsp");
        model.addAttribute("user", user);

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "用户列表");
        list.put("url", "/users");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "编辑用户");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    @PostMapping("/{id}/edit")
    public String updateUser(@PathVariable Integer id, @ModelAttribute User user, Model model) {
        try {
            // 检查权限（只能编辑自己或管理员权限）
            if (currentUser == null || (currentUser.getUserType() != 1 && !currentUser.getUserId().equals(id))) {
                return "redirect:/";
            }

            user.setUserId(id);
            userService.updateUser(user);

            // 如果更新的是当前用户，更新session
            if (currentUser.getUserId().equals(id)) {
                currentUser = userService.getUserById(id);
            }

            return "redirect:/users/" + id + "?success=用户更新成功";
        } catch (Exception e) {
            model.addAttribute("error", "更新用户失败: " + e.getMessage());
            model.addAttribute("user", user);
            model.addAttribute("pageTitle", "编辑用户 - " + user.getRealName());
            model.addAttribute("activeMenu", "users");
            model.addAttribute("contentPage", "users/form.jsp");
            return "layout/main";
        }
    }

    @PostMapping("/{id}/delete")
    public String deleteUser(@PathVariable Integer id) {
        // 检查权限（只有管理员可以删除）
        if (currentUser == null || currentUser.getUserType() != 1) {
            return "redirect:/";
        }

        // 不能删除自己
        if (currentUser.getUserId().equals(id)) {
            return "redirect:/users?error=不能删除自己";
        }

        userService.deleteUser(id);
        return "redirect:/users?success=用户删除成功";
    }

    @PostMapping("/{id}/update-status")
    public String updateUserStatus(
            @PathVariable Integer id,
            @RequestParam Integer status) {

        // 检查权限（只有管理员可以更新状态）
        if (currentUser == null || currentUser.getUserType() != 1) {
            return "redirect:/";
        }

        // 使用 Service 中存在的 updateUserStatus 方法
        userService.updateUserStatus(id, status);
        return "redirect:/users/" + id + "?success=用户状态更新成功";
    }

    @PostMapping("/{id}/reset-password")
    public String resetPassword(
            @PathVariable Integer id,
            @RequestParam String newPassword) {

        // 检查权限（只有管理员可以重置密码）
        if (currentUser == null || currentUser.getUserType() != 1) {
            return "redirect:/";
        }

        // 使用 Service 中存在的 updatePassword 方法
        userService.updatePassword(id, newPassword);
        return "redirect:/users/" + id + "?success=密码重置成功";
    }

    // 新增：注册页面
    @GetMapping("/register")
    public String registerForm(Model model) {
        // 如果已登录，跳转到首页
        if (currentUser != null) {
            return "redirect:/";
        }

        model.addAttribute("pageTitle", "用户注册");
        // 直接返回注册页面，不使用layout模板
        return "users/register";
    }

    // 新增：注册处理
    @PostMapping("/register")
    public String register(@ModelAttribute User user,
                           @RequestParam String confirmPassword,
                           Model model,
                           HttpSession session) {
        try {
            // 如果已登录，跳转到首页
            if (currentUser != null) {
                return "redirect:/";
            }

            // 验证必填字段
            if (user.getUsername() == null || user.getUsername().trim().isEmpty()) {
                throw new RuntimeException("用户名不能为空");
            }
            if (user.getPassword() == null || user.getPassword().isEmpty()) {
                throw new RuntimeException("密码不能为空");
            }
            if (!user.getPassword().equals(confirmPassword)) {
                throw new RuntimeException("两次输入的密码不一致");
            }
            if (user.getRealName() == null || user.getRealName().trim().isEmpty()) {
                throw new RuntimeException("真实姓名不能为空");
            }

            // 注册用户
            User registeredUser = userService.register(user);

            // 自动登录
            session.setAttribute("user", registeredUser);
            session.setAttribute("userId", registeredUser.getUserId());
            session.setAttribute("username", registeredUser.getUsername());
            session.setAttribute("userType", registeredUser.getUserType());

            return "redirect:/?success=注册成功，已自动登录";

        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            model.addAttribute("user", user);
            return "users/register";
        } catch (Exception e) {
            model.addAttribute("error", "注册失败: " + e.getMessage());
            model.addAttribute("user", user);
            return "users/register";
        }
    }

    // 修改现有的注销方法，使其能够从Web页面访问
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        // 调用service的logout方法进行清理
        userService.logout();
        // 清除session
        session.invalidate();
        return "redirect:/users/login?success=已成功退出登录";
    }

    // 修改现有的登录页面方法，添加注册链接
    @GetMapping("/login")
    public String loginForm(Model model) {
        if (currentUser != null) {
            return "redirect:/";
        }
        // 传递是否有注册成功的信息
        model.addAttribute("pageTitle", "用户登录");
        return "users/login";
    }

    @GetMapping("/profile")
    public String profile(Model model) {
        if (currentUser == null) {
            return "redirect:/users/login";
        }

        model.addAttribute("pageTitle", "个人资料");
        model.addAttribute("activeMenu", "profile");
        model.addAttribute("contentPage", "users/profile.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> current = new HashMap<>();
        current.put("name", "个人资料");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 重新获取最新用户信息
        User latestUser = userService.getUserById(currentUser.getUserId());
        model.addAttribute("user", latestUser);

        // 添加用户统计信息（如果 Service 中有相应方法）
        try {
            // 创建一个临时的 userStats 对象，防止 JSP 报错
            Map<String, Object> userStats = new HashMap<>();
            userStats.put("orderCount", 0);
            userStats.put("todayOrders", 0);
            userStats.put("completedOrders", 0);
            userStats.put("vehicleCount", 0);
            model.addAttribute("userStats", userStats);
        } catch (Exception e) {
            // 如果获取统计信息失败，提供一个空对象
            model.addAttribute("userStats", new HashMap<String, Object>());
        }

        return "layout/main";
    }

    @PostMapping("/profile")
    public String updateProfile(@ModelAttribute User user, Model model) {
        if (currentUser == null) {
            return "redirect:/users/login";
        }

        try {
            user.setUserId(currentUser.getUserId());
            userService.updateUser(user);

            // 更新当前用户信息
            currentUser = userService.getUserById(currentUser.getUserId());

            return "redirect:/users/profile?success=个人资料更新成功";
        } catch (Exception e) {
            model.addAttribute("error", "更新失败: " + e.getMessage());
            model.addAttribute("user", user);
            model.addAttribute("pageTitle", "个人资料");
            model.addAttribute("activeMenu", "profile");
            model.addAttribute("contentPage", "users/profile.jsp");

            // 重新设置面包屑导航
            List<Map<String, String>> breadcrumb = new ArrayList<>();
            Map<String, String> home = new HashMap<>();
            home.put("name", "首页");
            home.put("url", "/");
            breadcrumb.add(home);

            Map<String, String> current = new HashMap<>();
            current.put("name", "个人资料");
            breadcrumb.add(current);
            model.addAttribute("breadcrumb", breadcrumb);

            return "layout/main";
        }
    }

    @GetMapping("/password")
    public String changePassword(Model model) {
        if (currentUser == null) {
            return "redirect:/users/login";
        }

        model.addAttribute("pageTitle", "修改密码");
        model.addAttribute("activeMenu", "password");
        model.addAttribute("contentPage", "users/password.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> profile = new HashMap<>();
        profile.put("name", "个人资料");
        profile.put("url", "/users/profile");
        breadcrumb.add(profile);

        Map<String, String> current = new HashMap<>();
        current.put("name", "修改密码");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    @PostMapping("/password")
    public String updatePassword(
            @RequestParam String oldPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            Model model,
            HttpSession session) {

        System.out.println("=== 密码修改诊断开始 ===");
        System.out.println("当前用户ID: " + currentUser.getUserId());
        System.out.println("当前用户名: " + currentUser.getUsername());
        System.out.println("输入的旧密码长度: " + oldPassword.length());
        System.out.println("输入的新密码长度: " + newPassword.length());

        // 打印密码内容（调试用，生产环境移除）
        System.out.println("旧密码(前3位): " + oldPassword.substring(0, Math.min(3, oldPassword.length())));
        System.out.println("新密码(前3位): " + newPassword.substring(0, Math.min(3, newPassword.length())));

        if (currentUser == null) {
            return "redirect:/users/login";
        }

        try {
            if (!newPassword.equals(confirmPassword)) {
                System.out.println("错误：新密码和确认密码不一致");
                throw new Exception("新密码和确认密码不一致");
            }

            System.out.println("开始验证旧密码...");

            // 直接从数据库获取最新的用户信息（避免缓存问题）
            User freshUser = userService.getUserById(currentUser.getUserId());
            System.out.println("从数据库获取的用户状态: " + freshUser.getStatus());
            System.out.println("数据库中的密码哈希: " + freshUser.getPassword());

            // 验证旧密码
            boolean authResult = userService.authenticate(currentUser.getUsername(), oldPassword);
            System.out.println("旧密码验证结果: " + authResult);

            if (!authResult) {
                System.out.println("错误：旧密码验证失败");

                // 手动计算MD5对比，用于调试
                String oldPasswordMD5 = DigestUtils.md5DigestAsHex(oldPassword.getBytes(StandardCharsets.UTF_8));
                System.out.println("输入的旧密码MD5: " + oldPasswordMD5);
                System.out.println("数据库中的密码MD5: " + freshUser.getPassword());
                System.out.println("两者是否相等: " + oldPasswordMD5.equals(freshUser.getPassword()));

                throw new Exception("旧密码错误");
            }

            System.out.println("验证新密码是否与旧密码相同...");
            if (newPassword.equals(oldPassword)) {
                System.out.println("错误：新密码不能与旧密码相同");
                throw new Exception("新密码不能与原密码相同");
            }

            System.out.println("执行密码更新操作...");
            // 使用 Service 中存在的 updatePassword 方法
            int updateResult = userService.updatePassword(currentUser.getUserId(), newPassword);
            System.out.println("密码更新返回值: " + updateResult);

            // 验证更新是否成功
            User updatedUser = userService.getUserById(currentUser.getUserId());
            System.out.println("更新后数据库中的密码哈希: " + updatedUser.getPassword());

            String newPasswordMD5 = DigestUtils.md5DigestAsHex(newPassword.getBytes(StandardCharsets.UTF_8));
            System.out.println("新密码计算出的MD5: " + newPasswordMD5);
            System.out.println("数据库中的MD5是否匹配: " + newPasswordMD5.equals(updatedUser.getPassword()));

            if (updateResult > 0) {
                System.out.println("密码修改成功！");

                // 重要：清除session，强制重新登录
                session.invalidate();
                return "redirect:/users/login?message=密码修改成功，请重新登录";
            } else {
                System.out.println("错误：密码更新返回值为0");
                throw new Exception("密码更新失败，请联系管理员");
            }

        } catch (Exception e) {
            System.out.println("密码修改失败: " + e.getMessage());
            e.printStackTrace();

            model.addAttribute("error", "密码修改失败: " + e.getMessage());
            model.addAttribute("pageTitle", "修改密码");
            model.addAttribute("activeMenu", "password");
            model.addAttribute("contentPage", "users/password.jsp");
            return "layout/main";
        } finally {
            System.out.println("=== 密码修改诊断结束 ===");
        }
    }
}
