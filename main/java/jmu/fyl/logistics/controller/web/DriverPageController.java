package jmu.fyl.logistics.controller.web;

import jmu.fyl.logistics.entity.Driver;
import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.entity.Vehicle;
import jmu.fyl.logistics.service.DriverService;
import jmu.fyl.logistics.service.StationService;
import jmu.fyl.logistics.service.UserService;
import jmu.fyl.logistics.service.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/drivers")
public class DriverPageController extends BaseController {

    @Autowired
    private DriverService driverService;

    @Autowired
    private UserService userService;

    @Autowired
    private VehicleService vehicleService;

    @Autowired
    private StationService stationService;

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String licenseNumber,
            @RequestParam(required = false) String licenseType,
            @RequestParam(required = false) Integer currentStatus,
            @RequestParam(required = false) Integer minYears,
            @RequestParam(required = false) Integer maxYears,
            @RequestParam(required = false) Double minScore,
            @RequestParam(required = false) Double maxScore,
            Model model) {

        model.addAttribute("pageTitle", "司机管理");
        model.addAttribute("activeMenu", "drivers");
        model.addAttribute("subMenu", "driver_list");
        model.addAttribute("contentPage", "drivers/list.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> current = new HashMap<>();
        current.put("name", "司机列表");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 计算分页参数
        int start = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();
        params.put("licenseNumber", licenseNumber);
        params.put("licenseType", licenseType);
        params.put("currentStatus", currentStatus);
        params.put("minYears", minYears);
        params.put("maxYears", maxYears);
        params.put("minScore", minScore);
        params.put("maxScore", maxScore);
        params.put("start", start);
        params.put("limit", size);

        List<Driver> drivers = driverService.searchDrivers(params);
        int total = driverService.countDrivers(params);
        int totalPages = (int) Math.ceil((double) total / size);

        // ============ 添加符合JSP的Result结构 ============
        Map<String, Object> result = new HashMap<>();
        result.put("code", 200);
        result.put("message", "成功");

        Map<String, Object> data = new HashMap<>();
        data.put("list", drivers);
        data.put("total", total);
        data.put("pageNum", page);
        data.put("pageSize", size);
        data.put("pages", totalPages);

        result.put("data", data);
        model.addAttribute("result", result);
        // ============ 添加结束 ============

        // 原有代码保持不变
        model.addAttribute("drivers", drivers);
        model.addAttribute("total", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("searchParams", params);

        // 获取司机统计
        model.addAttribute("driverStats", driverService.getDriverStats());

        return "layout/main";
    }

    @GetMapping("/add")
    public String addForm(Model model) {
        model.addAttribute("pageTitle", "新增司机");
        model.addAttribute("activeMenu", "drivers");
        model.addAttribute("subMenu", "driver_add");
        model.addAttribute("contentPage", "drivers/form.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "司机列表");
        list.put("url", "/drivers");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "新增司机");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 获取用户和车辆数据
        List<User> users = userService.getAllUsers();
        List<Vehicle> vehicles = vehicleService.getAllVehicles();

        model.addAttribute("users", users);
        model.addAttribute("vehicles", vehicles);

        return "layout/main";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Integer id, Model model) {
        Driver driver = driverService.getDriverById(id);

        if (driver == null) {
            model.addAttribute("error", "司机不存在");
            model.addAttribute("pageTitle", "404错误");
            model.addAttribute("contentPage", "error/404.jsp");
            return "layout/main";
        }

        model.addAttribute("pageTitle", "编辑司机 - " +
                (driver.getUser() != null ? driver.getUser().getRealName() : "未知"));
        model.addAttribute("activeMenu", "drivers");
        model.addAttribute("contentPage", "drivers/form.jsp");
        model.addAttribute("driver", driver);

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "司机列表");
        list.put("url", "/drivers");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "编辑司机");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 获取用户和车辆数据
        List<User> users = userService.getAllUsers();
        List<Vehicle> vehicles = vehicleService.getAllVehicles();

        model.addAttribute("users", users);
        model.addAttribute("vehicles", vehicles);

        return "layout/main";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Integer id, Model model) {
        Driver driver = driverService.getDriverById(id);

        if (driver == null) {
            model.addAttribute("error", "司机不存在");
            model.addAttribute("pageTitle", "404错误");
            model.addAttribute("contentPage", "error/404.jsp");
            return "layout/main";
        }

        model.addAttribute("pageTitle", "司机详情 - " +
                (driver.getUser() != null ? driver.getUser().getRealName() : "未知"));
        model.addAttribute("activeMenu", "drivers");
        model.addAttribute("contentPage", "drivers/detail.jsp");
        model.addAttribute("driver", driver);

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "司机列表");
        list.put("url", "/drivers");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "司机详情");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    @GetMapping("/available")
    public String availableDrivers(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Integer stationId,
            Model model) {

        model.addAttribute("pageTitle", "可用司机列表");
        model.addAttribute("activeMenu", "drivers");
        model.addAttribute("subMenu", "driver_available");
        model.addAttribute("contentPage", "drivers/available.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "司机列表");
        list.put("url", "/drivers");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "可用司机");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        List<Driver> drivers = new ArrayList<>();
        if (stationId != null) {
            drivers = driverService.getAvailableDrivers(stationId);
        }

        model.addAttribute("drivers", drivers);
        model.addAttribute("stationId", stationId);

        return "layout/main";
    }

    @GetMapping("/expiring")
    public String expiringDrivers(
            @RequestParam(defaultValue = "30") Integer days,
            Model model) {

        model.addAttribute("pageTitle", "驾照即将到期司机");
        model.addAttribute("activeMenu", "drivers");
        model.addAttribute("subMenu", "driver_expiring");
        model.addAttribute("contentPage", "drivers/expiring.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "司机列表");
        list.put("url", "/drivers");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "即将到期驾照");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        try {
            List<Driver> drivers = driverService.getExpiringDrivers(days);
            model.addAttribute("drivers", drivers);
            model.addAttribute("days", days);
        } catch (Exception e) {
            model.addAttribute("error", "获取数据失败: " + e.getMessage());
            model.addAttribute("drivers", new ArrayList<>());
        }

        return "layout/main";
    }

    @GetMapping("/statistics")
    public String statisticsPage(Model model) {
        model.addAttribute("pageTitle", "司机统计");
        model.addAttribute("activeMenu", "drivers");
        model.addAttribute("subMenu", "driver_stats");
        model.addAttribute("contentPage", "drivers/statistics.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "司机列表");
        list.put("url", "/drivers");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "司机统计");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 获取司机统计
        model.addAttribute("driverStats", driverService.getDriverStats());

        return "layout/main";
    }

    @GetMapping("/safety")
    public String safetyManagement(Model model) {
        model.addAttribute("pageTitle", "安全管理");
        model.addAttribute("activeMenu", "drivers");
        model.addAttribute("subMenu", "driver_safety");
        model.addAttribute("contentPage", "drivers/safety.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "司机列表");
        list.put("url", "/drivers");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "安全管理");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 获取司机按安全分排序
        List<Driver> drivers = driverService.getAllDrivers();
        drivers.sort((d1, d2) -> Double.compare(d2.getSafetyScore(), d1.getSafetyScore()));
        model.addAttribute("drivers", drivers);

        return "layout/main";
    }

    @GetMapping("/schedule")
    public String schedulePage(Model model) {
        model.addAttribute("pageTitle", "司机调度");
        model.addAttribute("activeMenu", "drivers");
        model.addAttribute("subMenu", "driver_schedule");
        model.addAttribute("contentPage", "drivers/schedule.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "司机列表");
        list.put("url", "/drivers");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "司机调度");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }
}