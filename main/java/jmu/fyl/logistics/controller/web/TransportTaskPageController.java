package jmu.fyl.logistics.controller.web;

import jmu.fyl.logistics.entity.*;
import jmu.fyl.logistics.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Controller
@RequestMapping("/transport_tasks")
public class TransportTaskPageController extends BaseController {

    @Autowired
    private TransportTaskService transportTaskService;

    @Autowired
    private DriverService driverService;

    @Autowired
    private VehicleService vehicleService;

    @Autowired
    private StationService stationService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String taskNumber,
            @RequestParam(required = false) Integer taskType,
            @RequestParam(required = false) Integer taskStatus,
            @RequestParam(required = false) Integer driverId,
            @RequestParam(required = false) Integer vehicleId,
            @RequestParam(required = false) Integer startStationId,
            @RequestParam(required = false) Integer endStationId,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate,
            Model model,
            HttpServletRequest request) {

        model.addAttribute("pageTitle", "运输任务管理");
        model.addAttribute("activeMenu", "transport_tasks");
        model.addAttribute("subMenu", "transport_task_list");
        model.addAttribute("contentPage", "transport_tasks/list.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> current = new HashMap<>();
        current.put("name", "运输任务列表");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 计算分页参数
        int start = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();

        // ============ 添加权限控制逻辑 ============
        // 获取当前登录用户
        Object userObj = request.getSession().getAttribute("user");
        if (userObj != null && userObj instanceof User) {
            User currentUser = (User) userObj;

            // 判断用户类型：假设1=管理员，2=司机，3=普通用户
            if (currentUser.getUserType() != 1) { // 不是管理员
                // 尝试获取司机ID
                Driver driver = driverService.getDriverByUserId(currentUser.getUserId());
                if (driver != null) {
                    // 如果是司机，强制设置driverId为自己
                    params.put("driverId", driver.getDriverId());
                    model.addAttribute("isDriverView", true);
                    model.addAttribute("currentDriver", driver);
                } else {
                    // 如果不是司机，可能是普通用户，返回空列表
                    params.put("driverId", -1); // 设置不存在的driverId
                }
            } else {
                model.addAttribute("isAdmin", true);
            }

            // 设置用户类型标识
            model.addAttribute("currentUserType", currentUser.getUserType());
        }
        // ============ 权限控制逻辑结束 ============

        // 原有的搜索参数处理
        params.put("taskNumber", taskNumber);
        params.put("taskType", taskType);
        params.put("taskStatus", taskStatus);

        // 如果不是司机视图，才允许使用传入的driverId参数
        if (!params.containsKey("driverId") && driverId != null &&
                (model.containsAttribute("isAdmin") || Boolean.TRUE.equals(model.getAttribute("isAdmin")))) {
            params.put("driverId", driverId);
        }

        params.put("vehicleId", vehicleId);
        params.put("startStationId", startStationId);
        params.put("endStationId", endStationId);
        if (startDate != null && endDate != null) {
            params.put("startDate", startDate);
            params.put("endDate", endDate);
        }
        params.put("start", start);
        params.put("limit", size);

        List<TransportTask> tasks = transportTaskService.searchTransportTasks(params);
        int total = transportTaskService.countTransportTasks(params);
        int totalPages = (int) Math.ceil((double) total / size);

        // ============ 添加符合JSP的Result结构 ============
        Map<String, Object> result = new HashMap<>();
        result.put("code", 200);
        result.put("message", "成功");

        Map<String, Object> data = new HashMap<>();
        data.put("list", tasks);
        data.put("total", total);
        data.put("pageNum", page);
        data.put("pageSize", size);
        data.put("pages", totalPages);

        result.put("data", data);
        model.addAttribute("result", result);

        // 原有代码保持不变
        model.addAttribute("tasks", tasks);
        model.addAttribute("total", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("searchParams", params);

        // 获取相关数据（如果是司机视图，可能不需要所有数据）
        // 管理员才显示所有选项，司机只显示必要信息
        if (model.containsAttribute("isAdmin") || !model.containsAttribute("isDriverView")) {
            model.addAttribute("drivers", driverService.getAllDrivers());
            model.addAttribute("vehicles", vehicleService.getAllVehicles());
            model.addAttribute("stations", stationService.getAllStations());
            model.addAttribute("users", userService.getAllUsers());
        }

        return "layout/main";
    }

    @GetMapping("/add")
    public String addForm(Model model) {
        model.addAttribute("pageTitle", "新增运输任务");
        model.addAttribute("activeMenu", "transport_tasks");
        model.addAttribute("subMenu", "transport_task_add");
        model.addAttribute("contentPage", "transport_tasks/form.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "运输任务列表");
        list.put("url", "/transport_tasks");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "新增运输任务");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 获取相关数据
        model.addAttribute("drivers", driverService.getAllDrivers());
        model.addAttribute("vehicles", vehicleService.getAllVehicles());
        model.addAttribute("stations", stationService.getAllStations());
        model.addAttribute("users", userService.getAllUsers());

        // 获取可用订单
        Map<String, Object> params = new HashMap<>();
        params.put("transportTaskId", null); // 获取未分配任务的订单
        List<Order> orders = orderService.searchOrders(params);
        model.addAttribute("orders", orders);

        // 新增页面没有已选订单
        model.addAttribute("selectedOrderIds", new HashSet<Integer>());

        // 创建一个空的TransportTask对象
        TransportTask task = new TransportTask();
        task.setTaskStatus(1); // 默认状态
        task.setTaskPriority(1); // 默认优先级
        model.addAttribute("transportTask", task);

        return "layout/main";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Integer id, Model model) {
        TransportTask task = transportTaskService.getTransportTaskById(id);

        if (task == null) {
            model.addAttribute("error", "运输任务不存在");
            model.addAttribute("pageTitle", "404错误");
            model.addAttribute("contentPage", "error/404.jsp");
            return "layout/main";
        }

        model.addAttribute("pageTitle", "编辑运输任务 - " + task.getTaskNumber());
        model.addAttribute("activeMenu", "transport_tasks");
        model.addAttribute("contentPage", "transport_tasks/form.jsp");
        model.addAttribute("transportTask", task);

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "运输任务列表");
        list.put("url", "/transport_tasks");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "编辑运输任务");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 获取相关数据
        model.addAttribute("drivers", driverService.getAllDrivers());
        model.addAttribute("vehicles", vehicleService.getAllVehicles());
        model.addAttribute("stations", stationService.getAllStations());
        model.addAttribute("users", userService.getAllUsers());

        // 获取可用订单
        Map<String, Object> params = new HashMap<>();
        params.put("transportTaskId", null); // 获取未分配任务的订单
        List<Order> orders = orderService.searchOrders(params);
        model.addAttribute("orders", orders);

        // 创建已选订单ID的集合（用于前端检查复选框状态）
        Set<Integer> selectedOrderIds = new HashSet<>();
        if (task.getOrderIds() != null && !task.getOrderIds().trim().isEmpty()) {
            String[] ids = task.getOrderIds().split(",");
            for (String idStr : ids) {
                try {
                    selectedOrderIds.add(Integer.parseInt(idStr.trim()));
                } catch (NumberFormatException e) {
                    // 忽略无效ID
                }
            }
        }
        model.addAttribute("selectedOrderIds", selectedOrderIds);

        return "layout/main";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Integer id, Model model) {
        TransportTask task = transportTaskService.getTransportTaskById(id);

        if (task == null) {
            model.addAttribute("error", "运输任务不存在");
            model.addAttribute("pageTitle", "404错误");
            model.addAttribute("contentPage", "error/404.jsp");
            return "layout/main";
        }

        // 获取关联订单的详细信息（包含订单号）
        List<Map<String, Object>> relatedOrderInfos = new ArrayList<>();

        if (task.getOrderIds() != null && !task.getOrderIds().trim().isEmpty()) {
            String[] orderIdArray = task.getOrderIds().split(",");
            for (String orderIdStr : orderIdArray) {
                try {
                    Integer orderId = Integer.parseInt(orderIdStr.trim());
                    Order order = orderService.getOrderById(orderId);
                    if (order != null) {
                        Map<String, Object> orderInfo = new HashMap<>();
                        orderInfo.put("orderId", order.getOrderId());
                        orderInfo.put("orderNumber", order.getOrderNumber());
                        orderInfo.put("senderName", order.getSenderName());
                        orderInfo.put("receiverName", order.getReceiverName());
                        orderInfo.put("status", order.getStatus());
                        relatedOrderInfos.add(orderInfo);
                    }
                } catch (NumberFormatException e) {
                    // 忽略无效的订单ID
                }
            }
        }

        model.addAttribute("pageTitle", "运输任务详情 - " + task.getTaskNumber());
        model.addAttribute("activeMenu", "transport_tasks");
        model.addAttribute("contentPage", "transport_tasks/detail.jsp");
        model.addAttribute("transportTask", task);
        model.addAttribute("relatedOrderInfos", relatedOrderInfos); // 添加关联订单信息

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "运输任务列表");
        list.put("url", "/transport_tasks");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "任务详情");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    @GetMapping("/driver/{driverId}")
    public String getTasksByDriver(
            @PathVariable Integer driverId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {

        Driver driver = driverService.getDriverById(driverId);
        if (driver == null) {
            model.addAttribute("error", "司机不存在");
            model.addAttribute("pageTitle", "404错误");
            model.addAttribute("contentPage", "error/404.jsp");
            return "layout/main";
        }

        String driverName = driver.getUser() != null ? driver.getUser().getRealName() : "未知司机";
        model.addAttribute("pageTitle", "司机任务 - " + driverName);
        model.addAttribute("activeMenu", "drivers");
        model.addAttribute("contentPage", "transport_tasks/list.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> driverList = new HashMap<>();
        driverList.put("name", "司机列表");
        driverList.put("url", "/drivers");
        breadcrumb.add(driverList);

        Map<String, String> current = new HashMap<>();
        current.put("name", "司机任务");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 计算分页参数
        int start = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();
        params.put("driverId", driverId);
        params.put("start", start);
        params.put("limit", size);

        List<TransportTask> tasks = transportTaskService.getTransportTasksByDriverId(driverId);
        int total = tasks.size();

        model.addAttribute("tasks", tasks);
        model.addAttribute("total", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", (int) Math.ceil((double) total / size));
        model.addAttribute("driver", driver);

        return "layout/main";
    }

    @GetMapping("/vehicle/{vehicleId}")
    public String getTasksByVehicle(
            @PathVariable Integer vehicleId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {

        Vehicle vehicle = vehicleService.getVehicleById(vehicleId);
        if (vehicle == null) {
            model.addAttribute("error", "车辆不存在");
            model.addAttribute("pageTitle", "404错误");
            model.addAttribute("contentPage", "error/404.jsp");
            return "layout/main";
        }

        model.addAttribute("pageTitle", "车辆任务 - " + vehicle.getLicensePlate());
        model.addAttribute("activeMenu", "vehicles");
        model.addAttribute("contentPage", "transport_tasks/list.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> vehicleList = new HashMap<>();
        vehicleList.put("name", "车辆列表");
        vehicleList.put("url", "/vehicles");
        breadcrumb.add(vehicleList);

        Map<String, String> current = new HashMap<>();
        current.put("name", "车辆任务");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 计算分页参数
        int start = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();
        params.put("vehicleId", vehicleId);
        params.put("start", start);
        params.put("limit", size);

        List<TransportTask> tasks = transportTaskService.getTransportTasksByVehicleId(vehicleId);
        int total = tasks.size();

        model.addAttribute("tasks", tasks);
        model.addAttribute("total", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", (int) Math.ceil((double) total / size));
        model.addAttribute("vehicle", vehicle);

        return "layout/main";
    }

    @GetMapping("/active")
    public String activeTasks(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") Date date,
            Model model) {

        model.addAttribute("pageTitle", "当日活跃任务");
        model.addAttribute("activeMenu", "transport_tasks");
        model.addAttribute("subMenu", "transport_task_active");
        model.addAttribute("contentPage", "transport_tasks/active.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "运输任务列表");
        list.put("url", "/transport_tasks");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "当日活跃任务");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        try {
            List<TransportTask> tasks = transportTaskService.getActiveTasks(date);
            model.addAttribute("tasks", tasks);
            model.addAttribute("selectedDate", date);
        } catch (Exception e) {
            model.addAttribute("error", "获取活跃任务失败: " + e.getMessage());
            model.addAttribute("transport_tasks", new ArrayList<>());
        }

        return "layout/main";
    }

    @GetMapping("/dispatch")
    public String dispatchPage(Model model) {
        model.addAttribute("pageTitle", "任务调度");
        model.addAttribute("activeMenu", "transport_tasks");
        model.addAttribute("subMenu", "transport_task_dispatch");
        model.addAttribute("contentPage", "transport_tasks/dispatch.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "运输任务列表");
        list.put("url", "/transport_tasks");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "任务调度");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 获取待调度的任务
        try {
            List<TransportTask> pendingTasks = transportTaskService.getTransportTasksByTaskStatus(1); // 待调度
            model.addAttribute("pendingTasks", pendingTasks);

            // 获取可用资源
            model.addAttribute("availableDrivers", driverService.getAvailableDrivers(null));

            // 修复：使用 HashMap 替代 Map.of()
            Map<String, Object> vehicleParams = new HashMap<>();
            vehicleParams.put("status", 1);
            model.addAttribute("availableVehicles", vehicleService.searchVehicles(vehicleParams));

            model.addAttribute("stations", stationService.getAllStations());
        } catch (Exception e) {
            model.addAttribute("error", "获取调度数据失败: " + e.getMessage());
            model.addAttribute("pendingTasks", new ArrayList<>());
        }

        return "layout/main";
    }

    @GetMapping("/monitoring")
    public String monitoringPage(Model model) {
        model.addAttribute("pageTitle", "运输监控");
        model.addAttribute("activeMenu", "transport_tasks");
        model.addAttribute("subMenu", "transport_task_monitoring");
        model.addAttribute("contentPage", "transport_tasks/monitoring.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "运输任务列表");
        list.put("url", "/transport_tasks");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "运输监控");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 获取正在运输的任务
        try {
            List<TransportTask> transportingTasks = transportTaskService.getTransportTasksByTaskStatus(4); // 运输中
            model.addAttribute("transportingTasks", transportingTasks);
        } catch (Exception e) {
            model.addAttribute("error", "获取监控数据失败: " + e.getMessage());
            model.addAttribute("transportingTasks", new ArrayList<>());
        }

        return "layout/main";
    }

    @GetMapping("/statistics")
    public String statisticsPage(Model model) {
        model.addAttribute("pageTitle", "任务统计");
        model.addAttribute("activeMenu", "transport_tasks");
        model.addAttribute("subMenu", "transport_task_stats");
        model.addAttribute("contentPage", "transport_tasks/statistics.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "运输任务列表");
        list.put("url", "/transport_tasks");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "任务统计");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    @GetMapping("/calendar")
    public String calendarView(Model model) {
        model.addAttribute("pageTitle", "任务日历");
        model.addAttribute("activeMenu", "transport_tasks");
        model.addAttribute("subMenu", "transport_task_calendar");
        model.addAttribute("contentPage", "transport_tasks/calendar.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "运输任务列表");
        list.put("url", "/transport_tasks");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "任务日历");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    @GetMapping("/reports")
    public String reportsPage(
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endDate,
            Model model) {

        model.addAttribute("pageTitle", "任务报表");
        model.addAttribute("activeMenu", "reports");
        model.addAttribute("subMenu", "transport_task_reports");
        model.addAttribute("contentPage", "transport_tasks/reports.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> reports = new HashMap<>();
        reports.put("name", "报表中心");
        reports.put("url", "/reports");
        breadcrumb.add(reports);

        Map<String, String> current = new HashMap<>();
        current.put("name", "任务报表");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        if (startDate != null && endDate != null) {
            try {
                List<TransportTask> tasks = transportTaskService.getTasksByDateRange(startDate, endDate);
                model.addAttribute("tasks", tasks);
                model.addAttribute("startDate", startDate);
                model.addAttribute("endDate", endDate);
            } catch (Exception e) {
                model.addAttribute("error", "获取报表数据失败: " + e.getMessage());
            }
        }

        return "layout/main";
    }
}