package jmu.fyl.logistics.controller.web;

import jmu.fyl.logistics.entity.CargoItem;
import jmu.fyl.logistics.entity.Order;
import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.CargoItemService;
import jmu.fyl.logistics.service.OrderService;
import jmu.fyl.logistics.service.StationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/cargo_items")
public class CargoItemPageController extends BaseController {

    @Autowired
    private CargoItemService cargoItemService;

    @Autowired
    private OrderService orderService;


    @Autowired
    private StationService stationService;

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String cargoCode,
            @RequestParam(required = false) String cargoName,
            @RequestParam(required = false) String cargoType,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String orderNumber,
            @RequestParam(required = false) Integer stationId,
            Model model,
            HttpSession session) {

        model.addAttribute("pageTitle", "货物管理");
        model.addAttribute("activeMenu", "cargo_items");
        model.addAttribute("subMenu", "cargo_items_list");
        model.addAttribute("contentPage", "cargo_items/list.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> current = new HashMap<>();
        current.put("name", "货物列表");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 计算分页参数
        int start = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();
        params.put("cargoCode", cargoCode);
        params.put("cargoName", cargoName);
        params.put("cargoType", cargoType);
        params.put("status", status);
        params.put("orderNumber", orderNumber);
        params.put("currentStationId", stationId);
        params.put("start", start);
        params.put("limit", size);

        // 获取当前登录用户
        User user = (User) session.getAttribute("user");

        // 根据用户权限查询货物数据
        List<CargoItem> cargoItems;
        int total;

        if (user != null) {
            // 传入用户对象，Service层会根据用户类型过滤数据
            cargoItems = cargoItemService.searchCargoItems(params, user);
            total = cargoItemService.countCargoItems(params, user);
        } else {
            // 如果没有登录，按管理员权限处理（查看所有）
            cargoItems = cargoItemService.searchCargoItems(params);
            total = cargoItemService.countCargoItems(params);
        }

        // 创建符合 JSP 页面期望的 Result 数据结构
        Map<String, Object> data = new HashMap<>();
        data.put("list", cargoItems);
        data.put("pageNum", page);
        data.put("pageSize", size);
        data.put("total", total);
        data.put("pages", (int) Math.ceil((double) total / size));

        // 创建 Result 对象（模拟 Result.success() 的结构）
        Map<String, Object> result = new HashMap<>();
        result.put("code", 200);
        result.put("message", "success");
        result.put("data", data);
        model.addAttribute("result", result);

        model.addAttribute("cargoItems", cargoItems);
        model.addAttribute("total", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", (int) Math.ceil((double) total / size));

        // 将搜索参数放到模型中
        Map<String, Object> searchParams = new HashMap<>();
        searchParams.put("cargoCode", cargoCode);
        searchParams.put("cargoName", cargoName);
        searchParams.put("cargoType", cargoType);
        searchParams.put("status", status);
        searchParams.put("orderNumber", orderNumber);
        searchParams.put("stationId", stationId);
        model.addAttribute("searchParams", searchParams);

        // 获取相关数据
        model.addAttribute("stations", stationService.getAllStations());

        // 获取订单列表（用于搜索和显示）
        List<Order> orders;
        if (user != null && user.getUserType() == 3) { // 客户
            orders = orderService.getOrdersByUserId(user.getUserId());
        } else {
            orders = orderService.getAllOrders(); // 管理员和司机查看所有
        }
        model.addAttribute("orders", orders);

        return "layout/main";
    }

    @GetMapping("/add")
    public String addForm(
            @RequestParam(required = false) Integer orderId,
            Model model) {

        model.addAttribute("pageTitle", "新增货物");
        model.addAttribute("activeMenu", "cargo_items");
        model.addAttribute("subMenu", "cargo_items_add");
        model.addAttribute("contentPage", "cargo_items/form.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "货物列表");
        list.put("url", "/cargo_items");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "新增货物");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 如果有关联订单，预加载订单信息
        if (orderId != null) {
            Order order = orderService.getOrderById(orderId);
            if (order != null) {
                model.addAttribute("order", order);
                model.addAttribute("orderId", orderId);
            }
        }

        // 获取可用订单和站点
        model.addAttribute("orders", orderService.getAllOrders());
        model.addAttribute("stations", stationService.getAllStations());

        return "layout/main";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Integer id, Model model) {
        CargoItem cargoItem = cargoItemService.getCargoItemById(id);

        if (cargoItem == null) {
            model.addAttribute("error", "货物不存在");
            model.addAttribute("pageTitle", "404错误");
            model.addAttribute("contentPage", "error/404.jsp");
            return "layout/main";
        }

        model.addAttribute("pageTitle", "编辑货物 - " + cargoItem.getCargoName());
        model.addAttribute("activeMenu", "cargo_items");
        model.addAttribute("contentPage", "cargo_items/form.jsp");
        model.addAttribute("cargoItem", cargoItem);

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "货物列表");
        list.put("url", "/cargo_items");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "编辑货物");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 获取相关数据
        model.addAttribute("orders", orderService.getAllOrders());
        model.addAttribute("stations", stationService.getAllStations());

        return "layout/main";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Integer id, Model model) {
        CargoItem cargoItem = cargoItemService.getCargoItemById(id);

        if (cargoItem == null) {
            model.addAttribute("error", "货物不存在");
            model.addAttribute("pageTitle", "404错误");
            model.addAttribute("contentPage", "error/404.jsp");
            return "layout/main";
        }

        model.addAttribute("pageTitle", "货物详情 - " + cargoItem.getCargoName());
        model.addAttribute("activeMenu", "cargo_items");
        model.addAttribute("contentPage", "cargo_items/detail.jsp");
        model.addAttribute("cargoItem", cargoItem);

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "货物列表");
        list.put("url", "/cargo_items");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "货物详情");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    @GetMapping("/order/{orderId}")
    public String getCargoByOrder(
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

        model.addAttribute("pageTitle", "订单货物 - " + order.getOrderNumber());
        model.addAttribute("activeMenu", "orders");
        model.addAttribute("contentPage", "cargo_items/list.jsp");

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
        current.put("name", "订单货物");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        // 计算分页参数
        int start = (page - 1) * size;

        Map<String, Object> params = new HashMap<>();
        params.put("orderId", orderId);
        params.put("start", start);
        params.put("limit", size);

        List<CargoItem> cargoItems = cargoItemService.getCargoItemsByOrderId(orderId);
        int total = cargoItems.size();

        model.addAttribute("cargoItems", cargoItems);
        model.addAttribute("total", total);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", (int) Math.ceil((double) total / size));
        model.addAttribute("order", order);

        return "layout/main";
    }

    @GetMapping("/scan")
    public String scanPage(Model model) {
        model.addAttribute("pageTitle", "货物扫描");
        model.addAttribute("activeMenu", "cargo_items");
        model.addAttribute("subMenu", "cargo_items_scan");
        model.addAttribute("contentPage", "cargo_items/scan.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "货物列表");
        list.put("url", "/cargo_items");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "货物扫描");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    @GetMapping("/tracking")
    public String trackingPage(Model model) {
        model.addAttribute("pageTitle", "货物跟踪");
        model.addAttribute("activeMenu", "cargo_items");
        model.addAttribute("subMenu", "cargo_items_tracking");
        model.addAttribute("contentPage", "cargo_items/tracking.jsp");

        // 设置面包屑导航
        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "货物列表");
        list.put("url", "/cargo_items");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "货物跟踪");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }
}
