package jmu.fyl.logistics.controller.api;

import jmu.fyl.logistics.entity.CostDetail;
import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.CostDetailService;
import jmu.fyl.logistics.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/cost_details")
public class CostDetailController {

    @Autowired
    private CostDetailService costDetailService;

    @PostMapping
    public Result<CostDetail> addCostDetail(@RequestBody CostDetail costDetail, HttpSession session) {
        try {
            // 权限检查：只有财务相关人员可以添加费用
            User user = (User) session.getAttribute("user");
            if (user != null && (user.getUserType() == 3 || user.getUserType() == 4)) {
                return Result.error(403, "无权添加费用记录");
            }

            costDetailService.addCostDetail(costDetail);
            return Result.success("费用记录添加成功", costDetail);
        } catch (Exception e) {
            return Result.error("添加费用记录失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public Result<CostDetail> updateCostDetail(@PathVariable Integer id, @RequestBody CostDetail costDetail, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && (user.getUserType() == 3 || user.getUserType() == 4)) {
                return Result.error(403, "无权更新费用记录");
            }

            costDetail.setCostId(id);
            costDetailService.updateCostDetail(costDetail);
            return Result.success("费用记录更新成功", costDetail);
        } catch (Exception e) {
            return Result.error("更新费用记录失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteCostDetail(@PathVariable Integer id, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && (user.getUserType() == 3 || user.getUserType() == 4)) {
                return Result.error(403, "无权删除费用记录");
            }

            costDetailService.deleteCostDetail(id);
            return Result.success("费用记录删除成功");
        } catch (Exception e) {
            return Result.error("删除费用记录失败: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public Result<CostDetail> getCostDetailById(@PathVariable Integer id) {
        try {
            CostDetail costDetail = costDetailService.getCostDetailById(id);
            if (costDetail != null) {
                return Result.success(costDetail);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取费用记录失败: " + e.getMessage());
        }
    }

    @GetMapping("/order/{orderId}")
    public Result<List<CostDetail>> getCostDetailsByOrderId(@PathVariable Integer orderId) {
        try {
            List<CostDetail> costDetails = costDetailService.getCostDetailsByOrderId(orderId);
            return Result.success(costDetails);
        } catch (Exception e) {
            return Result.error("获取订单费用失败: " + e.getMessage());
        }
    }

    @GetMapping("/task/{taskId}")
    public Result<List<CostDetail>> getCostDetailsByTaskId(@PathVariable Integer taskId) {
        try {
            List<CostDetail> costDetails = costDetailService.getCostDetailsByTaskId(taskId);
            return Result.success(costDetails);
        } catch (Exception e) {
            return Result.error("获取任务费用失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/payment-status")
    public Result<Void> updatePaymentStatus(@PathVariable Integer id, @RequestBody Map<String, Integer> statusInfo, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && (user.getUserType() == 3 || user.getUserType() == 4)) {
                return Result.error(403, "无权更新支付状态");
            }

            Integer paymentStatus = statusInfo.get("paymentStatus");
            costDetailService.updatePaymentStatus(id, paymentStatus);
            return Result.success("支付状态更新成功");
        } catch (Exception e) {
            return Result.error("更新支付状态失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/payment")
    public Result<Void> updatePaymentInfo(
            @PathVariable Integer id,
            @RequestBody Map<String, Object> paymentInfo,
            HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && (user.getUserType() == 3 || user.getUserType() == 4)) {
                return Result.error(403, "无权更新支付信息");
            }

            Integer paymentStatus = (Integer) paymentInfo.get("paymentStatus");
            String paymentMethod = (String) paymentInfo.get("paymentMethod");
            Date paymentTime = new Date(); // 默认当前时间

            costDetailService.updatePaymentInfo(id, paymentStatus, paymentMethod, paymentTime);
            return Result.success("支付信息更新成功");
        } catch (Exception e) {
            return Result.error("更新支付信息失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/invoice")
    public Result<Void> updateInvoiceInfo(
            @PathVariable Integer id,
            @RequestBody Map<String, Object> invoiceInfo,
            HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && (user.getUserType() == 3 || user.getUserType() == 4)) {
                return Result.error(403, "无权更新发票信息");
            }

            String invoiceNumber = (String) invoiceInfo.get("invoiceNumber");
            Integer invoiceStatus = (Integer) invoiceInfo.get("invoiceStatus");

            costDetailService.updateInvoiceInfo(id, invoiceNumber, invoiceStatus);
            return Result.success("发票信息更新成功");
        } catch (Exception e) {
            return Result.error("更新发票信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/stats/order/{orderId}")
    public Result<Map<String, Object>> getTotalAmountByOrder(@PathVariable Integer orderId) {
        try {
            double totalAmount = costDetailService.getTotalAmountByOrder(orderId);
            Map<String, Object> result = new HashMap<>();
            result.put("orderId", orderId);
            result.put("totalAmount", totalAmount);
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("获取订单总金额失败: " + e.getMessage());
        }
    }

    @GetMapping("/stats/category")
    public Result<List<Map<String, Object>>> getCostStatsByCategory(
            @RequestParam Date startDate,
            @RequestParam Date endDate) {
        try {
            List<Map<String, Object>> stats = costDetailService.getCostStatsByCategory(startDate, endDate);
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取分类统计失败: " + e.getMessage());
        }
    }

    @GetMapping("/unpaid")
    public Result<List<Map<String, Object>>> getUnpaidCosts(@RequestParam(defaultValue = "30") Integer days) {
        try {
            List<Map<String, Object>> unpaidCosts = costDetailService.getUnpaidCosts(days);
            return Result.success(unpaidCosts);
        } catch (Exception e) {
            return Result.error("获取未付款项失败: " + e.getMessage());
        }
    }

    @GetMapping("/revenue")
    public Result<List<Map<String, Object>>> getRevenueByDate(
            @RequestParam Date startDate,
            @RequestParam Date endDate) {
        try {
            List<Map<String, Object>> revenue = costDetailService.getRevenueByDate(startDate, endDate);
            return Result.success(revenue);
        } catch (Exception e) {
            return Result.error("获取收支统计失败: " + e.getMessage());
        }
    }

    @GetMapping("/search")
    public Result<List<CostDetail>> searchCostDetails(@RequestParam Map<String, Object> params) {
        try {
            List<CostDetail> costDetails = costDetailService.searchCostDetails(params);
            return Result.success(costDetails);
        } catch (Exception e) {
            return Result.error("搜索费用记录失败: " + e.getMessage());
        }
    }
}
