package jmu.fyl.logistics.controller.web;

import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.nio.charset.StandardCharsets;
import java.util.Map;

@Controller
public class DashboardController {

    @Autowired
    private UserService userService;



    @GetMapping("/")
    public String index(HttpSession session) {
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            // 未登录，跳转到登录页
            return "redirect:/users/login";
        } else {
            // 所有用户都跳转到仪表盘
            return "redirect:/dashboard";
        }
    }

    // 显示登录页面
    @GetMapping("/login")
    public String loginPage(HttpSession session, Model model) {
        if (session.getAttribute("user") != null) {
            return "redirect:/dashboard";
        }
        return "users/login";
    }

    // 处理登录请求 - 根据SQL数据更新
    @PostMapping("/login")
    public String login(
            @RequestParam String username,
            @RequestParam String password,
            HttpSession session,
            Model model) {

        System.out.println("收到登录请求 - 用户名：" + username + ", 密码：" + password);

        try {
            // 1. 查询用户是否存在
            User user = userService.getUserByUsername(username);
            if (user == null) {
                System.out.println("用户不存在：" + username);
                model.addAttribute("error", "用户名或密码错误");
                return "users/login";
            }

            // 2. 检查用户状态（如果有状态字段）
            if (user.getStatus() != null && user.getStatus() != 1) {
                System.out.println("用户状态异常：" + username + "，状态：" + user.getStatus());
                model.addAttribute("error", "账户不可用");
                return "users/login";
            }

            // 3. 验证密码
            // 先计算输入密码的MD5
            String encryptedPassword = DigestUtils.md5DigestAsHex(password.getBytes(StandardCharsets.UTF_8));
            System.out.println("输入密码MD5：" + encryptedPassword);
            System.out.println("数据库密码：" + user.getPassword());

            if (!encryptedPassword.equals(user.getPassword())) {
                System.out.println("密码不匹配：" + username);
                model.addAttribute("error", "用户名或密码错误");
                return "users/login";
            }

            // 4. 登录成功
            System.out.println("登录成功：" + username);

            // 设置session
            session.setAttribute("user", user);
            session.setAttribute("userType", user.getUserType());
            session.setAttribute("username", user.getUsername());

            return "redirect:/dashboard";

        } catch (Exception e) {
            System.err.println("登录异常：" + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "登录失败：" + e.getMessage());
            return "users/login";
        }
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        // 添加用户信息到模型
        model.addAttribute("user", user);
        model.addAttribute("userType", user.getUserType());
        model.addAttribute("username", user.getUsername());

        // 根据SQL中的user_type进行判断
        // 1-系统管理员，2-司机，3-客户
        switch (user.getUserType()) {
            case 1:
                model.addAttribute("role", "管理员");
                break;
            case 2:
                model.addAttribute("role", "司机");
                break;
            case 3:
                model.addAttribute("role", "客户");
                break;
            default:
                model.addAttribute("role", "用户");
        }

        return "dashboard";
    }

    @PostMapping("/dashboard/settings")
    public String saveDashboardSettings(
            @RequestParam(required = false) String theme,
            @RequestParam(required = false) Integer pageSize,
            HttpSession session) {

        // 保存用户偏好设置到session或数据库
        if (theme != null) {
            session.setAttribute("theme", theme);
        }
        if (pageSize != null) {
            session.setAttribute("pageSize", pageSize);
        }

        return "redirect:/dashboard?success=设置已保存";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}