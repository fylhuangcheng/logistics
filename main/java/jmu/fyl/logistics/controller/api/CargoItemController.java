package jmu.fyl.logistics.controller.api;

import jmu.fyl.logistics.entity.CargoItem;
import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.CargoItemService;
import jmu.fyl.logistics.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/cargo_items")
public class CargoItemController {

    @Autowired
    private CargoItemService cargoItemService;

    @PostMapping
    public Result<CargoItem> addCargoItem(@RequestBody CargoItem cargoItem, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() == 3) {
                return Result.error(403, "客户用户无法添加货物");
            }

            cargoItemService.addCargoItem(cargoItem);
            return Result.success("货物添加成功", cargoItem);
        } catch (Exception e) {
            return Result.error("添加货物失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public Result<CargoItem> updateCargoItem(@PathVariable Integer id, @RequestBody CargoItem cargoItem, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() == 3) {
                return Result.error(403, "客户用户无法更新货物");
            }

            cargoItem.setCargoId(id);
            cargoItemService.updateCargoItem(cargoItem);
            return Result.success("货物更新成功", cargoItem);
        } catch (Exception e) {
            return Result.error("更新货物失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteCargoItem(@PathVariable Integer id, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() == 3) {
                return Result.error(403, "客户用户无法删除货物");
            }

            cargoItemService.deleteCargoItem(id);
            return Result.success("货物删除成功");
        } catch (Exception e) {
            return Result.error("删除货物失败: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public Result<CargoItem> getCargoItemById(@PathVariable Integer id) {
        try {
            CargoItem cargoItem = cargoItemService.getCargoItemById(id);
            if (cargoItem != null) {
                return Result.success(cargoItem);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取货物信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/order/{orderId}")
    public Result<List<CargoItem>> getCargoItemsByOrderId(@PathVariable Integer orderId) {
        try {
            List<CargoItem> cargoItems = cargoItemService.getCargoItemsByOrderId(orderId);
            return Result.success(cargoItems);
        } catch (Exception e) {
            return Result.error("获取订单货物失败: " + e.getMessage());
        }
    }

    @GetMapping("/code/{cargoCode}")
    public Result<List<CargoItem>> getCargoItemsByCargoCode(@PathVariable String cargoCode) {
        try {
            List<CargoItem> cargoItems = cargoItemService.getCargoItemsByCargoCode(cargoCode);
            return Result.success(cargoItems);
        } catch (Exception e) {
            return Result.error("获取货物代码失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/status")
    public Result<Void> updateCargoStatus(@PathVariable Integer id, @RequestBody Map<String, Integer> statusInfo, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() == 3) {
                return Result.error(403, "客户用户无法更新货物状态");
            }

            Integer status = statusInfo.get("status");
            cargoItemService.updateCargoStatus(id, status);
            return Result.success("货物状态更新成功");
        } catch (Exception e) {
            return Result.error("更新货物状态失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/station")
    public Result<Void> updateCurrentStation(@PathVariable Integer id, @RequestBody Map<String, Integer> stationInfo, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() == 3) {
                return Result.error(403, "客户用户无法更新货物站点");
            }

            Integer stationId = stationInfo.get("stationId");
            cargoItemService.updateCurrentStation(id, stationId);
            return Result.success("货物站点更新成功");
        } catch (Exception e) {
            return Result.error("更新货物站点失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/scan")
    public Result<Void> updateLastScanTime(@PathVariable Integer id, @RequestBody Map<String, Date> scanInfo, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() == 3) {
                return Result.error(403, "客户用户无法更新扫描时间");
            }

            Date lastScanTime = scanInfo.get("lastScanTime");
            cargoItemService.updateLastScanTime(id, lastScanTime);
            return Result.success("扫描时间更新成功");
        } catch (Exception e) {
            return Result.error("更新扫描时间失败: " + e.getMessage());
        }
    }

    @GetMapping("/stats/order/{orderId}")
    public Result<Map<String, Object>> getCargoStatsByOrder(@PathVariable Integer orderId) {
        try {
            Map<String, Object> stats = cargoItemService.getCargoStatsByOrder(orderId);
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取货物统计失败: " + e.getMessage());
        }
    }

    @GetMapping("/stats/station/{stationId}")
    public Result<Map<String, Object>> getCargoStatsByStation(@PathVariable Integer stationId) {
        try {
            Map<String, Object> stats = cargoItemService.getCargoStatsByStation(stationId);
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取站点货物统计失败: " + e.getMessage());
        }
    }

    @PostMapping("/batch/status")
    public Result<Void> updateMultipleStatus(@RequestBody Map<String, Object> batchInfo, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() == 3) {
                return Result.error(403, "客户用户无法批量更新状态");
            }

            @SuppressWarnings("unchecked")
            List<Integer> cargoIds = (List<Integer>) batchInfo.get("cargoIds");
            Integer status = (Integer) batchInfo.get("status");

            cargoItemService.updateMultipleStatus(cargoIds, status);
            return Result.success("批量状态更新成功");
        } catch (Exception e) {
            return Result.error("批量更新状态失败: " + e.getMessage());
        }
    }
}
