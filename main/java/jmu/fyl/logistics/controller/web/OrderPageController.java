package jmu.fyl.logistics.controller.web;

import jmu.fyl.logistics.entity.Order;
import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.OrderService;
import jmu.fyl.logistics.service.StationService;
import jmu.fyl.logistics.service.VehicleService;
import jmu.fyl.logistics.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/orders")
public class OrderPageController extends BaseController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private StationService stationService;

    @Autowired
    private VehicleService vehicleService;

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String orderNumber,
            @RequestParam(required = false) String senderPhone,
            @RequestParam(required = false) String receiverPhone,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) Integer startStationId,
            @RequestParam(required = false) Integer endStationId,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startTime,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyy-MM-dd") Date endTime,
                    Model model,
            HttpSession session) {

        // 设置页面信息
        model.addAttribute("pageTitle", "订单管理");
        model.addAttribute("activeMenu", "orders");
        model.addAttribute("subMenu", "order_list");
        model.addAttribute("contentPage", "orders/list.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> current = new HashMap<>();
        current.put("name", "订单列表");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 计算分页参数
        int start = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();
        params.put("orderNumber", orderNumber);
        params.put("senderPhone", senderPhone);
        params.put("receiverPhone", receiverPhone);
        params.put("status", status);
        params.put("startStationId", startStationId);
        params.put("endStationId", endStationId);
        params.put("startTime", startTime);
        params.put("endTime", endTime);
        params.put("start", start);
        params.put("limit", size);

        // 获取用户信息并设置权限
        User user = (User) session.getAttribute("user");
        if (user != null) {
            model.addAttribute("userType", user.getUserType());
            model.addAttribute("currentUser", user);

            // 用户类型：1=管理员，2=员工，3=客户
            if (user.getUserType() == 3) { // 客户用户
                // 客户只能查看自己作为寄件人的订单（通过姓名匹配）
                // 假设寄件人姓名就是用户的真实姓名
                String senderName = user.getRealName();
                if (senderName != null && !senderName.trim().isEmpty()) {
                    params.put("senderName", senderName.trim()); // 精确匹配寄件人姓名
                }

                // 也可以同时通过寄件人电话来匹配
                String userPhone = user.getPhone();
                if (userPhone != null && !userPhone.trim().isEmpty()) {
                    params.put("senderPhone", userPhone.trim());
                }

                model.addAttribute("isCustomer", true);
                model.addAttribute("customerName", senderName);
                model.addAttribute("customerPhone", userPhone);

                System.out.println("客户用户权限设置：寄件人姓名=" + senderName + ", 电话=" + userPhone);
            } else if (user.getUserType() == 2) { // 员工用户
                model.addAttribute("isStaff", true);
                // 员工可以查看所有订单
            } else if (user.getUserType() == 1) { // 管理员
                model.addAttribute("isAdmin", true);
                // 管理员可以查看所有订单
            }
        }

        List<Order> orders = orderService.searchOrders(params);
        int total = orderService.countOrders(params);

        // 创建分页数据Map
        Map<String, Object> pageData = new HashMap<>();
        pageData.put("list", orders);
        pageData.put("total", total);
        pageData.put("pageNum", page);
        pageData.put("pageSize", size);
        pageData.put("pages", (int) Math.ceil((double) total / size));

        // 使用Result包装数据
        Result<Map<String, Object>> result = Result.success("查询成功", pageData);
        model.addAttribute("result", result);

        // 保留原来的属性
        model.addAttribute("orders", orders);
        model.addAttribute("total", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", (int) Math.ceil((double) total / size));
        model.addAttribute("searchParams", params);

        // 获取所有网点（用于筛选）
        model.addAttribute("stations", stationService.getAllStations());

        return "layout/main";
    }

    @GetMapping("/add")
    public String addForm(Model model) {
        model.addAttribute("pageTitle", "新建订单");
        model.addAttribute("activeMenu", "orders");
        model.addAttribute("subMenu", "order_add");
        model.addAttribute("contentPage", "orders/form.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "订单列表");
        list.put("url", "/orders");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "新建订单");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 获取所有网点
        model.addAttribute("stations", stationService.getAllStations());

        return "layout/main";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Integer id, Model model, HttpSession session) {
        // 检查权限（保持原逻辑）
        if (checkCustomerPermission(session)) {
            model.addAttribute("error", "客户用户无法编辑订单");
            model.addAttribute("pageTitle", "权限错误");
            model.addAttribute("contentPage", "error/403.jsp");
            return "layout/main";
        }

        try {
            Order order = orderService.getOrderById(id);

            if (order == null) {
                model.addAttribute("error", "订单不存在");
                model.addAttribute("pageTitle", "404错误");
                model.addAttribute("contentPage", "error/404.jsp");
                return "layout/main";
            }

            model.addAttribute("pageTitle", "编辑订单 - " + order.getOrderNumber());
            model.addAttribute("activeMenu", "orders");
            model.addAttribute("contentPage", "orders/form.jsp");
            model.addAttribute("order", order);

            // 设置面包屑导航
            List<Map<String, String>> breadcrumb = new ArrayList<>();
            Map<String, String> home = new HashMap<>();
            home.put("name", "首页");
            home.put("url", "/");
            breadcrumb.add(home);

            Map<String, String> list = new HashMap<>();
            list.put("name", "订单列表");
            list.put("url", "/orders");
            breadcrumb.add(list);

            Map<String, String> current = new HashMap<>();
            current.put("name", "编辑订单");
            breadcrumb.add(current);
            model.addAttribute("breadcrumb", breadcrumb);

            // 获取所有网点
            model.addAttribute("stations", stationService.getAllStations());

            // 获取可用车辆
            if (order.getCurrentStationId() != null && order.getWeight() != null) {
                model.addAttribute("availableVehicles",
                        vehicleService.getAvailableVehicles(order.getCurrentStationId(), order.getWeight()));
            }

            return "layout/main";
        } catch (Exception e) {
            model.addAttribute("error", "获取编辑页面失败: " + e.getMessage());
            model.addAttribute("pageTitle", "服务器错误");
            model.addAttribute("contentPage", "error/500.jsp");
            return "layout/main";
        }
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Integer id, Model model, HttpSession session) {
        try {
            Order order = orderService.getOrderById(id);

            if (order == null) {
                model.addAttribute("error", "订单不存在");
                model.addAttribute("pageTitle", "404错误");
                model.addAttribute("contentPage", "error/404.jsp");
                return "layout/main";
            }

            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null) {
                // 如果是客户，只能查看自己作为寄件人的订单
                if (user.getUserType() == 3) {
                    // 检查是否是客户的订单（通过寄件人姓名或电话）
                    boolean canView = false;

                    // 通过寄件人姓名检查
                    String customerName = user.getRealName();
                    if (customerName != null && customerName.equals(order.getSenderName())) {
                        canView = true;
                    }

                    // 通过寄件人电话检查
                    String customerPhone = user.getPhone();
                    if (!canView && customerPhone != null && customerPhone.equals(order.getSenderPhone())) {
                        canView = true;
                    }

                    if (!canView) {
                        model.addAttribute("error", "没有权限查看此订单");
                        model.addAttribute("pageTitle", "权限错误");
                        model.addAttribute("contentPage", "error/403.jsp");
                        return "layout/main";
                    }
                }
            }



            // 设置面包屑导航
            List<Map<String, String>> breadcrumb = new ArrayList<>();
            Map<String, String> home = new HashMap<>();
            home.put("name", "首页");
            home.put("url", "/");
            breadcrumb.add(home);

            Map<String, String> list = new HashMap<>();
            list.put("name", "订单列表");
            list.put("url", "/orders");
            breadcrumb.add(list);

            Map<String, String> current = new HashMap<>();
            current.put("name", "订单详情");
            breadcrumb.add(current);
            model.addAttribute("breadcrumb", breadcrumb);

            return "layout/main";
        } catch (Exception e) {
            model.addAttribute("error", "获取订单详情失败: " + e.getMessage());
            model.addAttribute("pageTitle", "服务器错误");
            model.addAttribute("contentPage", "error/500.jsp");
            return "layout/main";
        }
    }

    // 保持原权限检查方法
    private boolean checkCustomerPermission(HttpSession session) {
        Integer userType = (Integer) session.getAttribute("userType");
        if (userType == null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            userType = user.getUserType();
        }
        return userType != null && userType == 3;
    }
}