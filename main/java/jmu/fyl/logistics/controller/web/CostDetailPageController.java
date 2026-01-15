package jmu.fyl.logistics.controller.web;

import jmu.fyl.logistics.entity.CostDetail;
import jmu.fyl.logistics.entity.Order;
import jmu.fyl.logistics.entity.TransportTask;
import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.CostDetailService;
import jmu.fyl.logistics.service.OrderService;
import jmu.fyl.logistics.service.TransportTaskService;
import jmu.fyl.logistics.service.UserService;
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
@RequestMapping("/cost_details")
public class CostDetailPageController extends BaseController {

    @Autowired
    private CostDetailService costDetailService;

    @Autowired
    private OrderService orderService;

    @Autowired
    private TransportTaskService transportTaskService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String orderNumber,  // 改为接收orderNumber
            @RequestParam(required = false) Integer orderId,  // 保留orderId用于其他情况
            @RequestParam(required = false) Integer taskId,
            @RequestParam(required = false) Integer costType,
            @RequestParam(required = false) Integer costCategory,
            @RequestParam(required = false) Integer paymentStatus,
            @RequestParam(required = false) Integer payerId,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date startTime,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date endTime,
            Model model,
            HttpSession session) {

        model.addAttribute("pageTitle", "费用管理");
        model.addAttribute("activeMenu", "cost_details");
        model.addAttribute("subMenu", "cost_details_list");
        model.addAttribute("contentPage", "cost_details/list.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> current = new HashMap<>();
        current.put("name", "费用列表");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 计算分页参数
        int start = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();

        // 如果传入了orderNumber，需要先查询对应的orderId
        if (orderNumber != null && !orderNumber.trim().isEmpty()) {
            try {
                Order order = orderService.getOrderByOrderNumber(orderNumber.trim());
                if (order != null) {
                    params.put("orderId", order.getOrderId());
                    System.out.println("根据订单号 " + orderNumber + " 找到订单ID: " + order.getOrderId());
                } else {
                    System.out.println("订单号 " + orderNumber + " 不存在");
                }
            } catch (Exception e) {
                System.out.println("查询订单号 " + orderNumber + " 出错: " + e.getMessage());
            }
        } else {
            params.put("orderId", orderId);
        }

        params.put("taskId", taskId);
        params.put("costType", costType);
        params.put("costCategory", costCategory);
        params.put("paymentStatus", paymentStatus);
        params.put("payerId", payerId);
        if (startTime != null && endTime != null) {
            params.put("startTime", startTime);
            params.put("endTime", endTime);
        }
        params.put("start", start);
        params.put("limit", size);

        // 获取当前登录用户
        User user = (User) session.getAttribute("user");
        System.out.println("当前登录用户: " + (user != null ? user.getUsername() + " (类型: " + user.getUserType() + ")" : "null"));

        // 根据用户权限查询费用数据
        List<CostDetail> costDetails;
        int total;

        if (user != null) {
            // 传入用户对象，Service层会根据用户类型过滤数据
            costDetails = costDetailService.searchCostDetails(params, user);
            total = costDetailService.countCostDetails(params, user);
        } else {
            // 如果没有登录，按管理员权限处理（查看所有）
            costDetails = costDetailService.searchCostDetails(params);
            total = costDetailService.countCostDetails(params);
        }

        int totalPages = (int) Math.ceil((double) total / size);

        // 创建符合JSP的Result结构
        Map<String, Object> result = new HashMap<>();
        result.put("code", 200);
        result.put("message", "成功");

        Map<String, Object> data = new HashMap<>();
        data.put("list", costDetails);
        data.put("total", total);
        data.put("pageNum", page);
        data.put("pageSize", size);
        data.put("pages", totalPages);

        result.put("data", data);
        model.addAttribute("result", result);

        // 搜索参数
        Map<String, Object> searchParams = new HashMap<>();
        searchParams.put("orderNumber", orderNumber);
        searchParams.put("orderId", orderId);
        searchParams.put("taskId", taskId);
        searchParams.put("costType", costType);
        searchParams.put("costCategory", costCategory);
        searchParams.put("paymentStatus", paymentStatus);
        searchParams.put("payerId", payerId);
        model.addAttribute("searchParams", searchParams);

        model.addAttribute("costDetails", costDetails);
        model.addAttribute("total", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("searchParams", params);

        // 获取相关数据（根据用户权限）
        List<Order> orders;
        if (user != null && user.getUserType() == 3) { // 客户
            orders = orderService.getOrdersByUserId(user.getUserId());
        } else {
            orders = orderService.getAllOrders(); // 管理员和司机查看所有
        }
        model.addAttribute("orders", orders);

        model.addAttribute("tasks", transportTaskService.getAllTransportTasks());
        model.addAttribute("users", userService.getAllUsers());

        return "layout/main";
    }

    @GetMapping("/add")
    public String addForm(
            @RequestParam(required = false) Integer orderId,
            @RequestParam(required = false) Integer taskId,
            Model model) {

        model.addAttribute("pageTitle", "新增费用");
        model.addAttribute("activeMenu", "cost_details");
        model.addAttribute("subMenu", "cost_details_add");
        model.addAttribute("contentPage", "cost_details/form.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "费用列表");
        list.put("url", "/cost_details");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "新增费用");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 如果有关联订单或任务，预加载信息
        if (orderId != null) {
            Order order = orderService.getOrderById(orderId);
            if (order != null) {
                model.addAttribute("order", order);
                model.addAttribute("orderId", orderId);
            }
        }

        if (taskId != null) {
            TransportTask task = transportTaskService.getTransportTaskById(taskId);
            if (task != null) {
                model.addAttribute("task", task);
                model.addAttribute("taskId", taskId);
            }
        }

        // 获取相关数据
        model.addAttribute("orders", orderService.getAllOrders());
        model.addAttribute("tasks", transportTaskService.getAllTransportTasks());
        model.addAttribute("users", userService.getAllUsers());

        return "layout/main";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Integer id, Model model) {
        CostDetail costDetail = costDetailService.getCostDetailById(id);

        if (costDetail == null) {
            model.addAttribute("error", "费用记录不存在");
            model.addAttribute("pageTitle", "404错误");
            model.addAttribute("contentPage", "error/404.jsp");
            return "layout/main";
        }

        model.addAttribute("pageTitle", "编辑费用记录");
        model.addAttribute("activeMenu", "cost_details");
        model.addAttribute("contentPage", "cost_details/form.jsp");
        model.addAttribute("costDetail", costDetail);

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "费用列表");
        list.put("url", "/cost_details");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "编辑费用");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 获取相关数据
        model.addAttribute("orders", orderService.getAllOrders());
        model.addAttribute("tasks", transportTaskService.getAllTransportTasks());
        model.addAttribute("users", userService.getAllUsers());

        return "layout/main";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Integer id, Model model) {
        CostDetail costDetail = costDetailService.getCostDetailById(id);

        if (costDetail == null) {
            model.addAttribute("error", "费用记录不存在");
            model.addAttribute("pageTitle", "404错误");
            model.addAttribute("contentPage", "error/404.jsp");
            return "layout/main";
        }

        model.addAttribute("pageTitle", "费用详情");
        model.addAttribute("activeMenu", "cost_details");
        model.addAttribute("contentPage", "cost_details/detail.jsp");
        model.addAttribute("costDetail", costDetail);

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "费用列表");
        list.put("url", "/cost_details");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "费用详情");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    @GetMapping("/order/{orderId}")
    public String getCostsByOrder(
            @PathVariable Integer orderId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {

        Order order = orderService.getOrderById(orderId);
        if (order == null) {
            model.addAttribute("error", "订单不存在");
            model.addAttribute("pageTitle", "404错误");
            model.addAttribute("contentPage", "error/404.jsp");
            return "layout/main";
        }

        model.addAttribute("pageTitle", "订单费用 - " + order.getOrderNumber());
        model.addAttribute("activeMenu", "cost_details");
        model.addAttribute("contentPage", "cost_details/list.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> orderList = new HashMap<>();
        orderList.put("name", "订单列表");
        orderList.put("url", "/orders");
        breadcrumb.add(orderList);

        Map<String, String> current = new HashMap<>();
        current.put("name", "订单费用");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 计算分页参数
        int start = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();
        params.put("orderId", orderId);
        params.put("start", start);
        params.put("limit", size);

        List<CostDetail> costDetails = costDetailService.getCostDetailsByOrderId(orderId);
        int total = costDetails.size();

        model.addAttribute("costDetails", costDetails);
        model.addAttribute("total", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", (int) Math.ceil((double) total / size));
        model.addAttribute("order", order);

        return "layout/main";
    }

    @GetMapping("/payment")
    public String paymentManagement(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Integer paymentStatus,
            Model model) {

        model.addAttribute("pageTitle", "支付管理");
        model.addAttribute("activeMenu", "cost_details");
        model.addAttribute("subMenu", "payment_manage");
        model.addAttribute("contentPage", "cost_details/payment.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> current = new HashMap<>();
        current.put("name", "支付管理");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 计算分页参数
        int start = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();
        params.put("paymentStatus", paymentStatus);
        params.put("start", start);
        params.put("limit", size);

        List<CostDetail> costDetails = costDetailService.searchCostDetails(params);
        int total = costDetailService.countCostDetails(params);

        model.addAttribute("costDetails", costDetails);
        model.addAttribute("total", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", (int) Math.ceil((double) total / size));

        return "layout/main";
    }

    @GetMapping("/invoice")
    public String invoiceManagement(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Integer invoiceStatus,
            Model model) {

        model.addAttribute("pageTitle", "发票管理");
        model.addAttribute("activeMenu", "cost_details");
        model.addAttribute("subMenu", "invoice_manage");
        model.addAttribute("contentPage", "cost_details/invoice.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> current = new HashMap<>();
        current.put("name", "发票管理");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 计算分页参数
        int start = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();
        params.put("invoiceStatus", invoiceStatus);
        params.put("start", start);
        params.put("limit", size);

        List<CostDetail> costDetails = costDetailService.searchCostDetails(params);
        int total = costDetailService.countCostDetails(params);

        model.addAttribute("costDetails", costDetails);
        model.addAttribute("total", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", (int) Math.ceil((double) total / size));

        return "layout/main";
    }

    @GetMapping("/statistics")
    public String statisticsPage(Model model) {
        model.addAttribute("pageTitle", "费用统计");
        model.addAttribute("activeMenu", "cost_details");
        model.addAttribute("subMenu", "cost_stats");
        model.addAttribute("contentPage", "cost/statistics.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "费用列表");
        list.put("url", "/cost_details");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "费用统计");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    @GetMapping("/unpaid-report")
    public String unpaidReport(
            @RequestParam(defaultValue = "30") Integer days,
            Model model) {

        model.addAttribute("pageTitle", "未付款项报表");
        model.addAttribute("activeMenu", "reports");
        model.addAttribute("subMenu", "unpaid_report");
        model.addAttribute("contentPage", "cost_details/unpaid-report.jsp");

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
        current.put("name", "未付款项");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        try {
            List<Map<String, Object>> unpaidCosts = costDetailService.getUnpaidCosts(days);
            model.addAttribute("unpaidCosts", unpaidCosts);
            model.addAttribute("days", days);
        } catch (Exception e) {
            model.addAttribute("error", "获取未付款项失败: " + e.getMessage());
            model.addAttribute("unpaidCosts", new ArrayList<>());
        }

        return "layout/main";
    }
}