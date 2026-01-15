package jmu.fyl.logistics.controller.web;

import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.entity.Vehicle;
import jmu.fyl.logistics.entity.Station;
import jmu.fyl.logistics.service.VehicleService;
import jmu.fyl.logistics.service.StationService;
import jmu.fyl.logistics.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/vehicles")
public class VehiclePageController extends BaseController {

    @Autowired
    private VehicleService vehicleService;

    @Autowired
    private StationService stationService;

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String licensePlate,
            @RequestParam(required = false) String vehicleType,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) Integer stationId,
            Model model,
            HttpServletRequest request) {

        // 设置页面信息
        model.addAttribute("pageTitle", "车辆管理");
        model.addAttribute("activeMenu", "vehicles");
        model.addAttribute("subMenu", "vehicle_list");
        model.addAttribute("contentPage", "vehicles/list.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> current = new HashMap<>();
        current.put("name", "车辆列表");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 计算分页参数 - 使用 start 和 limit
        int start = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();

        // ============ 添加权限控制逻辑 ============
        // 获取当前登录用户
        Object userObj = request.getSession().getAttribute("user");
        if (userObj != null && userObj instanceof User) {
            User currentUser = (User) userObj;

            // 判断用户类型：假设1=管理员，2=司机，3=普通用户
            if (currentUser.getUserType() != 1) { // 不是管理员
                // 如果是司机，只显示驾驶员名字是自己的车辆
                if (currentUser.getUserType() == 2) {
                    // 司机的姓名就是驾驶员名字
                    params.put("driverName", currentUser.getRealName());
                    model.addAttribute("isDriverView", true);
                    model.addAttribute("currentUserName", currentUser.getRealName());
                } else {
                    // 普通用户，可能返回空列表
                    params.put("driverName", "NO_ACCESS_USER_" + currentUser.getUserId());
                }
            } else {
                model.addAttribute("isAdmin", true);
            }

            // 设置用户类型标识
            model.addAttribute("currentUserType", currentUser.getUserType());
        } else {
            // 未登录用户，返回空列表
            params.put("driverName", "NO_LOGIN_USER");
        }
        // ============ 权限控制逻辑结束 ============

        // 原有的搜索参数处理
        params.put("licensePlate", licensePlate);
        params.put("vehicleType", vehicleType);
        params.put("status", status);
        params.put("currentStationId", stationId);
        params.put("start", start);
        params.put("limit", size);

        List<Vehicle> vehicles = vehicleService.searchVehicles(params);
        int total = vehicleService.countVehicles(params);

        // 创建分页数据Map
        Map<String, Object> pageData = new HashMap<>();
        pageData.put("list", vehicles);
        pageData.put("total", total);
        pageData.put("pageNum", page);
        pageData.put("pageSize", size);
        pageData.put("pages", (int) Math.ceil((double) total / size));

        // 使用Result包装数据
        Result<Map<String, Object>> result = Result.success("查询成功", pageData);
        model.addAttribute("result", result);

        // 同时保留原来的属性（用于兼容）
        model.addAttribute("vehicles", vehicles);
        model.addAttribute("total", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", (int) Math.ceil((double) total / size));
        model.addAttribute("searchParams", params);

        // 获取车辆统计（只有管理员才显示完整的统计）
        if (model.containsAttribute("isAdmin")) {
            model.addAttribute("vehicleStats", vehicleService.getVehicleStats());
        } else {
            // 司机视图显示简化的统计
            Map<String, Object> driverStats = new HashMap<>();
            driverStats.put("total", total);
            model.addAttribute("vehicleStats", driverStats);
        }

        return "layout/main";
    }

    @GetMapping("/add")
    public String addForm(Model model, HttpServletRequest request) {
        // 检查权限：只有管理员才能新增车辆
        Object userObj = request.getSession().getAttribute("user");
        boolean isAdmin = false;
        if (userObj != null && userObj instanceof User) {
            User currentUser = (User) userObj;
            isAdmin = (currentUser.getUserType() == 1);
        }

        if (!isAdmin) {
            model.addAttribute("pageTitle", "权限不足");
            model.addAttribute("activeMenu", "vehicles");
            model.addAttribute("contentPage", "error/403.jsp");
            return "layout/main";
        }

        // 获取所有启用的网点列表
        try {
            List<Station> stations = stationService.getStationsByStatus(1);  // 1表示启用
            model.addAttribute("stations", stations);
            System.out.println("成功获取到 " + stations.size() + " 个启用的网点");
        } catch (Exception e) {
            System.err.println("获取网点列表失败: " + e.getMessage());
            model.addAttribute("stations", new ArrayList<Station>());
        }

        model.addAttribute("pageTitle", "新增车辆");
        model.addAttribute("activeMenu", "vehicles");
        model.addAttribute("subMenu", "vehicle_add");
        model.addAttribute("contentPage", "vehicles/form.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "车辆列表");
        list.put("url", "/vehicles");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "新增车辆");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Integer id, Model model, HttpServletRequest request) {
        // 检查权限：只有管理员才能编辑车辆
        Object userObj = request.getSession().getAttribute("user");
        boolean isAdmin = false;
        if (userObj != null && userObj instanceof User) {
            User currentUser = (User) userObj;
            isAdmin = (currentUser.getUserType() == 1);
        }

        if (!isAdmin) {
            model.addAttribute("pageTitle", "权限不足");
            model.addAttribute("activeMenu", "vehicles");
            model.addAttribute("contentPage", "error/403.jsp");
            return "layout/main";
        }

        Vehicle vehicle = vehicleService.getVehicleById(id);

        // 获取所有启用的网点列表
        try {
            List<Station> stations = stationService.getStationsByStatus(1);  // 1表示启用
            model.addAttribute("stations", stations);
            System.out.println("编辑页面: 成功获取到 " + stations.size() + " 个启用的网点");
        } catch (Exception e) {
            System.err.println("编辑页面获取网点列表失败: " + e.getMessage());
            model.addAttribute("stations", new ArrayList<Station>());
        }

        model.addAttribute("pageTitle", "编辑车辆 - " + vehicle.getLicensePlate());
        model.addAttribute("activeMenu", "vehicles");
        model.addAttribute("contentPage", "vehicles/form.jsp");
        model.addAttribute("vehicle", vehicle);

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "车辆列表");
        list.put("url", "/vehicles");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "编辑车辆");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }


    @GetMapping("/{id}")
    public String detail(@PathVariable Integer id, Model model) {
        Vehicle vehicle = vehicleService.getVehicleById(id);

        model.addAttribute("pageTitle", "车辆详情 - " + vehicle.getLicensePlate());
        model.addAttribute("activeMenu", "vehicles");
        model.addAttribute("contentPage", "vehicles/detail.jsp");
        model.addAttribute("vehicle", vehicle);

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "车辆列表");
        list.put("url", "/vehicles");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "车辆详情");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }
    // 新增方法

    /**
     * 根据司机查看车辆
     */
    @GetMapping("/driver/{driverId}")
    public String getVehiclesByDriver(
            @PathVariable Integer driverId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {

        model.addAttribute("pageTitle", "司机车辆列表");
        model.addAttribute("activeMenu", "vehicles");
        model.addAttribute("contentPage", "vehicles/list.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "车辆列表");
        list.put("url", "/vehicles");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "司机车辆");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 计算分页参数
        int start = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();
        params.put("currentDriverId", driverId);
        params.put("start", start);
        params.put("limit", size);

        List<Vehicle> vehicles = vehicleService.searchVehicles(params);
        int total = vehicleService.countVehicles(params);

        model.addAttribute("vehicles", vehicles);
        model.addAttribute("total", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", (int) Math.ceil((double) total / size));
        model.addAttribute("driverId", driverId);

        return "layout/main";
    }

    /**
     * 批量更新车辆状态页面
     */
    @GetMapping("/batch-update-status")
    public String batchUpdateStatusForm(Model model) {
        model.addAttribute("pageTitle", "批量更新车辆状态");
        model.addAttribute("activeMenu", "vehicles");
        model.addAttribute("subMenu", "vehicle_batch");
        model.addAttribute("contentPage", "vehicles/batch-update-status.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "车辆列表");
        list.put("url", "/vehicles");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "批量更新状态");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    /**
     * 车辆统计报表页面
     */
    @GetMapping("/statistics")
    public String statisticsPage(Model model) {
        model.addAttribute("pageTitle", "车辆统计报表");
        model.addAttribute("activeMenu", "vehicles");
        model.addAttribute("subMenu", "vehicle_stats");
        model.addAttribute("contentPage", "vehicles/statistics.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "车辆列表");
        list.put("url", "/vehicles");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "统计报表");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 获取车辆统计
        model.addAttribute("vehicleStats", vehicleService.getVehicleStats());

        return "layout/main";
    }

    /**
     * 车辆位置跟踪页面
     */
    @GetMapping("/tracking")
    public String vehicleTracking(Model model) {
        model.addAttribute("pageTitle", "车辆位置跟踪");
        model.addAttribute("activeMenu", "vehicles");
        model.addAttribute("subMenu", "vehicle_tracking");
        model.addAttribute("contentPage", "vehicles/tracking.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "车辆列表");
        list.put("url", "/vehicles");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "位置跟踪");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    /**
     * 车辆调度页面
     */
    @GetMapping("/dispatch")
    public String vehicleDispatch(Model model) {
        // 获取所有启用的网点和空闲车辆
        try {
            List<Station> stations = stationService.getStationsByStatus(1);
            Map<String, Object> params = new HashMap<>();
            params.put("status", 1); // 空闲状态
            List<Vehicle> availableVehicles = vehicleService.searchVehicles(params);

            model.addAttribute("stations", stations);
            model.addAttribute("availableVehicles", availableVehicles);
        } catch (Exception e) {
            model.addAttribute("stations", new ArrayList<Station>());
            model.addAttribute("availableVehicles", new ArrayList<Vehicle>());
        }

        model.addAttribute("pageTitle", "车辆调度管理");
        model.addAttribute("activeMenu", "vehicles");
        model.addAttribute("subMenu", "vehicle_dispatch");
        model.addAttribute("contentPage", "vehicles/dispatch.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "车辆列表");
        list.put("url", "/vehicles");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "车辆调度");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

}