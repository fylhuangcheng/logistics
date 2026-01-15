package jmu.fyl.logistics.controller.api;

import jmu.fyl.logistics.entity.Order;
import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import jmu.fyl.logistics.util.Result;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

    @Autowired
    private OrderService orderService;


    @PostMapping
    public Result<Order> addOrder(@RequestBody Order order, HttpSession session) {
        try {
            // 设置创建用户
            User user = (User) session.getAttribute("user");
            if (user != null) {
                order.setCreateUserId(user.getUserId());
            }

            // 检查订单号是否已存在
            Order existing = orderService.getOrderByNumber(order.getOrderNumber());
            if (existing != null) {
                return Result.error(400, "订单号已存在");
            }

            orderService.addOrder(order);
            return Result.success("订单添加成功", order);
        } catch (Exception e) {
            return Result.error("添加订单失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public Result<Order> updateOrder(@PathVariable Integer id, @RequestBody Order order, HttpSession session) {
        try {
            // 权限检查：客户用户不能更新订单
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() == 3) {
                return Result.error(403, "客户用户无法更新订单");
            }

            order.setOrderId(id);
            orderService.updateOrder(order);
            return Result.success("订单更新成功", order);
        } catch (Exception e) {
            return Result.error("更新订单失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteOrder(@PathVariable Integer id, HttpSession session) {
        try {
            // 权限检查：客户用户不能删除订单
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() == 3) {
                return Result.error(403, "客户用户无法删除订单");
            }

            orderService.deleteOrder(id);
            return Result.success("订单删除成功");
        } catch (Exception e) {
            return Result.error("删除订单失败: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public Result<Order> getOrderById(@PathVariable Integer id, HttpSession session) {
        try {
            Order order = orderService.getOrderById(id);
            if (order != null) {
                // 权限检查
                User user = (User) session.getAttribute("user");
                if (user != null) {
                    // 如果是客户，只能查看自己作为寄件人的订单
                    if (user.getUserType() == 3) {
                        // 检查是否是客户的订单
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
                            return Result.error(403, "没有权限查看此订单");
                        }
                    }
                }

                return Result.success(order);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取订单信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/number/{orderNumber}")
    public Result<Order> getOrderByNumber(@PathVariable String orderNumber) {
        try {
            Order order = orderService.getOrderByNumber(orderNumber);
            if (order != null) {
                return Result.success(order);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取订单信息失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/status")
    public Result<Void> updateOrderStatus(@PathVariable Integer id, @RequestBody Map<String, Integer> statusInfo, HttpSession session) {
        try {
            // 权限检查：只有管理员和员工可以更新状态
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() == 3) {
                return Result.error(403, "客户用户无法更新订单状态");
            }

            Integer status = statusInfo.get("status");
            if (status == null) {
                return Result.error(400, "状态不能为空");
            }

            orderService.updateOrderStatus(id, status);
            return Result.success("订单状态更新成功");
        } catch (Exception e) {
            return Result.error("更新订单状态失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/assign-vehicle")
    public Result<Void> assignVehicle(@PathVariable Integer id, @RequestBody Map<String, Integer> vehicleInfo, HttpSession session) {
        try {
            // 权限检查：只有管理员和员工可以分配车辆
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() == 3) {
                return Result.error(403, "客户用户无法分配车辆");
            }

            Integer vehicleId = vehicleInfo.get("vehicleId");
            orderService.assignVehicleToOrder(id, vehicleId);
            return Result.success("车辆分配成功");
        } catch (Exception e) {
            return Result.error("分配车辆失败: " + e.getMessage());
        }
    }

    @GetMapping("/generate-number")
    public Result<Map<String, String>> generateOrderNumber() {
        try {
            Map<String, String> result = new HashMap<>();
            result.put("orderNumber", orderService.generateOrderNumber());
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("生成订单号失败: " + e.getMessage());
        }
    }

    @GetMapping("/stats")
    public Result<Map<String, Object>> getOrderStats() {
        try {
            Map<String, Object> stats = orderService.getOrderStats();
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取订单统计失败: " + e.getMessage());
        }
    }
    // 新增方法

    /**
     * 根据运输任务ID获取订单
     */
    @GetMapping("/task/{taskId}")
    public Result<List<Order>> getOrdersByTransportTaskId(@PathVariable Integer taskId) {
        try {
            List<Order> orders = orderService.getOrdersByTransportTaskId(taskId);
            return Result.success(orders);
        } catch (Exception e) {
            return Result.error("获取运输任务订单失败: " + e.getMessage());
        }
    }

    /**
     * 根据车辆ID获取订单
     */
    @GetMapping("/vehicle/{vehicleId}")
    public Result<List<Order>> getOrdersByVehicleId(@PathVariable Integer vehicleId) {
        try {
            List<Order> orders = orderService.getOrdersByVehicleId(vehicleId);
            return Result.success(orders);
        } catch (Exception e) {
            return Result.error("获取车辆订单失败: " + e.getMessage());
        }
    }

    /**
     * 根据创建用户ID获取订单
     */
    @GetMapping("/user/{userId}")
    public Result<List<Order>> getOrdersByCreateUserId(@PathVariable Integer userId, HttpSession session) {
        try {
            User user = (User) session.getAttribute("user");

            // 权限检查：客户只能查看自己的订单
            if (user != null && user.getUserType() == 3) {
                // 客户用户 - 只能通过寄件人信息查看订单
                String senderName = user.getRealName();
                String senderPhone = user.getPhone();

                // 创建一个新的参数map
                Map<String, Object> params = new HashMap<>();
                if (senderName != null && !senderName.trim().isEmpty()) {
                    params.put("senderName", senderName.trim());
                }
                if (senderPhone != null && !senderPhone.trim().isEmpty()) {
                    params.put("senderPhone", senderPhone.trim());
                }

                List<Order> orders = orderService.searchOrders(params);
                return Result.success(orders);
            }

            // 管理员和员工可以查看所有用户的订单
            List<Order> orders = orderService.getOrdersByCreateUserId(userId);
            return Result.success(orders);
        } catch (Exception e) {
            return Result.error("获取用户订单失败: " + e.getMessage());
        }
    }

    /**
     * 根据发货方电话获取订单
     */
    @GetMapping("/sender/{phone}")
    public Result<List<Order>> getOrdersBySenderPhone(@PathVariable String phone) {
        try {
            List<Order> orders = orderService.getOrdersBySenderPhone(phone);
            return Result.success(orders);
        } catch (Exception e) {
            return Result.error("获取发货方订单失败: " + e.getMessage());
        }
    }

    /**
     * 根据收货方电话获取订单
     */
    @GetMapping("/receiver/{phone}")
    public Result<List<Order>> getOrdersByReceiverPhone(@PathVariable String phone) {
        try {
            List<Order> orders = orderService.getOrdersByReceiverPhone(phone);
            return Result.success(orders);
        } catch (Exception e) {
            return Result.error("获取收货方订单失败: " + e.getMessage());
        }
    }

    /**
     * 根据状态获取订单
     */
    @GetMapping("/status/{status}")
    public Result<List<Order>> getOrdersByStatus(@PathVariable Integer status) {
        try {
            List<Order> orders = orderService.getOrdersByStatus(status);
            return Result.success(orders);
        } catch (Exception e) {
            return Result.error("获取状态订单失败: " + e.getMessage());
        }
    }

    /**
     * 根据时间范围获取订单
     */
    @GetMapping("/time-range")
    public Result<List<Order>> getOrdersByTimeRange(
            @RequestParam Date startTime,
            @RequestParam Date endTime) {
        try {
            List<Order> orders = orderService.getOrdersByTimeRange(startTime, endTime);
            return Result.success(orders);
        } catch (Exception e) {
            return Result.error("获取时间段订单失败: " + e.getMessage());
        }
    }

    /**
     * 根据站点获取订单
     */
    @GetMapping("/station/{stationId}")
    public Result<List<Order>> getOrdersByStation(
            @PathVariable Integer stationId,
            @RequestParam(required = false) Integer status) {
        try {
            List<Order> orders = orderService.getOrdersByStation(stationId, status);
            return Result.success(orders);
        } catch (Exception e) {
            return Result.error("获取站点订单失败: " + e.getMessage());
        }
    }

    /**
     * 更新订单当前站点
     */
    @PutMapping("/{id}/station")
    public Result<Void> updateCurrentStation(
            @PathVariable Integer id,
            @RequestBody Map<String, Integer> stationInfo,
            HttpSession session) {
        try {
            // 权限检查：只有管理员和员工可以更新站点
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() == 3) {
                return Result.error(403, "客户用户无法更新订单站点");
            }

            Integer stationId = stationInfo.get("stationId");
            if (stationId == null) {
                return Result.error(400, "站点ID不能为空");
            }

            orderService.updateCurrentStation(id, stationId);
            return Result.success("订单站点更新成功");
        } catch (Exception e) {
            return Result.error("更新订单站点失败: " + e.getMessage());
        }
    }

    /**
     * 分配运输任务给订单
     */
    @PutMapping("/{id}/assign-task")
    public Result<Void> assignTransportTask(
            @PathVariable Integer id,
            @RequestBody Map<String, Integer> taskInfo,
            HttpSession session) {
        try {
            // 权限检查：只有管理员和调度员可以分配任务
            User user = (User) session.getAttribute("user");
            if (user != null && (user.getUserType() == 3 || user.getUserType() == 4)) {
                return Result.error(403, "无权分配运输任务");
            }

            Integer taskId = taskInfo.get("taskId");
            if (taskId == null) {
                return Result.error(400, "任务ID不能为空");
            }

            orderService.assignTransportTask(id, taskId);
            return Result.success("运输任务分配成功");
        } catch (Exception e) {
            return Result.error("分配运输任务失败: " + e.getMessage());
        }
    }

    /**
     * 获取所有订单
     */
    @GetMapping("/all")
    public Result<List<Order>> getAllOrders() {
        try {
            List<Order> orders = orderService.getAllOrders();
            return Result.success(orders);
        } catch (Exception e) {
            return Result.error("获取所有订单失败: " + e.getMessage());
        }
    }

    /**
     * 条件搜索订单
     */
    /**
     * 条件搜索订单 - 添加权限控制
     */
    @GetMapping("/search")
    public Result<List<Order>> searchOrders(
            @RequestParam Map<String, Object> params,
            HttpSession session) {
        try {
            // 权限控制
            User user = (User) session.getAttribute("user");
            if (user != null) {
                // 如果是客户用户，只能查看自己作为寄件人的订单
                if (user.getUserType() == 3) {
                    // 通过寄件人姓名匹配
                    String senderName = user.getRealName();
                    if (senderName != null && !senderName.trim().isEmpty()) {
                        params.put("senderName", senderName.trim());
                    }
                    // 通过寄件人电话匹配
                    String userPhone = user.getPhone();
                    if (userPhone != null && !userPhone.trim().isEmpty()) {
                        params.put("senderPhone", userPhone.trim());
                    }
                }
            }

            List<Order> orders = orderService.searchOrders(params);
            return Result.success(orders);
        } catch (Exception e) {
            return Result.error("搜索订单失败: " + e.getMessage());
        }
    }

    @GetMapping("/count")
    public Result<Map<String, Object>> countOrders(
            @RequestParam Map<String, Object> params,
            HttpSession session) {
        try {
            // 权限控制
            User user = (User) session.getAttribute("user");
            if (user != null) {
                // 如果是客户用户，只能查看自己作为寄件人的订单
                if (user.getUserType() == 3) {
                    // 通过寄件人姓名匹配
                    String senderName = user.getRealName();
                    if (senderName != null && !senderName.trim().isEmpty()) {
                        params.put("senderName", senderName.trim());
                    }
                    // 通过寄件人电话匹配
                    String userPhone = user.getPhone();
                    if (userPhone != null && !userPhone.trim().isEmpty()) {
                        params.put("senderPhone", userPhone.trim());
                    }
                }
            }

            int count = orderService.countOrders(params);
            Map<String, Object> result = new HashMap<>();
            result.put("count", count);
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("统计订单数量失败: " + e.getMessage());
        }
    }

    /**
     * 按日期统计订单
     */
    @GetMapping("/stats/by-date")
    public Result<List<Map<String, Object>>> getOrderStatsByDate(
            @RequestParam Date startDate,
            @RequestParam Date endDate) {
        try {
            List<Map<String, Object>> stats = orderService.getOrderStatsByDate(startDate, endDate);
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取订单日期统计失败: " + e.getMessage());
        }
    }
}