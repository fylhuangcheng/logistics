package jmu.fyl.logistics.controller.api;

import jmu.fyl.logistics.controller.web.BaseController;
import jmu.fyl.logistics.entity.Vehicle;
import jmu.fyl.logistics.service.VehicleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;


import jmu.fyl.logistics.util.Result;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.*;


@RestController
@RequestMapping("/api/vehicles")
public class VehicleController {

    @Autowired
    private VehicleService vehicleService;

    @PostMapping
    public Result<Vehicle> addVehicle(@RequestBody Vehicle vehicle) {
        try {
            // 检查车牌号是否已存在
            Vehicle existing = vehicleService.getVehicleByLicensePlate(vehicle.getLicensePlate());
            if (existing != null) {
                return Result.error(400, "车牌号已存在");
            }

            vehicleService.addVehicle(vehicle);
            return Result.success("车辆添加成功", vehicle);
        } catch (Exception e) {
            return Result.error("添加车辆失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public Result<Vehicle> updateVehicle(@PathVariable Integer id, @RequestBody Vehicle vehicle) {
        try {
            vehicle.setVehicleId(id);
            vehicleService.updateVehicle(vehicle);
            return Result.success("车辆更新成功", vehicle);
        } catch (Exception e) {
            return Result.error("更新车辆失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteVehicle(@PathVariable Integer id) {
        try {
            vehicleService.deleteVehicle(id);
            return Result.success("车辆删除成功");
        } catch (Exception e) {
            return Result.error("删除车辆失败: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public Result<Vehicle> getVehicleById(@PathVariable Integer id) {
        try {
            Vehicle vehicle = vehicleService.getVehicleById(id);
            if (vehicle != null) {
                return Result.success(vehicle);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取车辆信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/license/{licensePlate}")
    public Result<Vehicle> getVehicleByLicensePlate(@PathVariable String licensePlate) {
        try {
            Vehicle vehicle = vehicleService.getVehicleByLicensePlate(licensePlate);
            if (vehicle != null) {
                return Result.success(vehicle);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取车辆信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/stations/{stationId}")
    public Result<List<Vehicle>> getVehiclesByStation(@PathVariable Integer stationId) {
        try {
            List<Vehicle> vehicles = vehicleService.getVehiclesByStation(stationId);
            return Result.success(vehicles);
        } catch (Exception e) {
            return Result.error("获取站点车辆列表失败: " + e.getMessage());
        }
    }

    @GetMapping("/available/{stationId}")
    public Result<List<Vehicle>> getAvailableVehicles(
            @PathVariable Integer stationId,
            @RequestParam(required = false) Double minCapacity) {

        try {
            double capacity = minCapacity != null ? minCapacity : 0.0;
            List<Vehicle> vehicles = vehicleService.getAvailableVehicles(stationId, capacity);
            return Result.success(vehicles);
        } catch (Exception e) {
            return Result.error("获取可用车辆列表失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/status")
    public Result<Void> updateVehicleStatus(@PathVariable Integer id, @RequestBody Map<String, Integer> statusInfo) {
        try {
            Integer status = statusInfo.get("status");
            vehicleService.updateVehicleStatus(id, status);
            return Result.success("车辆状态更新成功");
        } catch (Exception e) {
            return Result.error("更新车辆状态失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/location")
    public Result<Void> updateVehicleLocation(@PathVariable Integer id, @RequestBody Map<String, Integer> locationInfo) {
        try {
            Integer stationId = locationInfo.get("stationId");
            vehicleService.updateVehicleLocation(id, stationId);
            return Result.success("车辆位置更新成功");
        } catch (Exception e) {
            return Result.error("更新车辆位置失败: " + e.getMessage());
        }
    }

    @GetMapping("/stats")
    public Result<Map<String, Object>> getVehicleStats() {
        try {
            Map<String, Object> stats = vehicleService.getVehicleStats();
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取车辆统计失败: " + e.getMessage());
        }
    }
    // 新增方法

    /**
     * 获取所有车辆
     */
    @GetMapping("/all")
    public Result<List<Vehicle>> getAllVehicles() {
        try {
            List<Vehicle> vehicles = vehicleService.getAllVehicles();
            return Result.success(vehicles);
        } catch (Exception e) {
            return Result.error("获取所有车辆失败: " + e.getMessage());
        }
    }

    /**
     * 条件搜索车辆
     */
    @GetMapping("/search")
    public Result<List<Vehicle>> searchVehicles(
            @RequestParam Map<String, Object> params) {
        try {
            List<Vehicle> vehicles = vehicleService.searchVehicles(params);
            return Result.success(vehicles);
        } catch (Exception e) {
            return Result.error("搜索车辆失败: " + e.getMessage());
        }
    }

    /**
     * 统计车辆数量
     */
    @GetMapping("/count")
    public Result<Map<String, Object>> countVehicles(
            @RequestParam Map<String, Object> params) {
        try {
            int count = vehicleService.countVehicles(params);
            Map<String, Object> result = new HashMap<>();
            result.put("count", count);
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("统计车辆数量失败: " + e.getMessage());
        }
    }

    /**
     * 分配司机给车辆
     */
    @PutMapping("/{id}/assign-driver")
    public Result<Void> assignDriver(
            @PathVariable Integer id,
            @RequestBody Map<String, Integer> driverInfo) {
        try {
            Integer driverId = driverInfo.get("driverId");
            if (driverId == null) {
                return Result.error(400, "司机ID不能为空");
            }

            vehicleService.assignDriver(id, driverId);
            return Result.success("司机分配成功");
        } catch (Exception e) {
            return Result.error("分配司机失败: " + e.getMessage());
        }
    }

    /**
     * 清除车辆的司机分配
     */
    @PutMapping("/{id}/clear-driver")
    public Result<Void> clearDriver(@PathVariable Integer id) {
        try {
            vehicleService.clearDriver(id);
            return Result.success("司机分配已清除");
        } catch (Exception e) {
            return Result.error("清除司机分配失败: " + e.getMessage());
        }
    }

    /**
     * 根据司机ID获取车辆
     */
    @GetMapping("/driver/{driverId}")
    public Result<List<Vehicle>> getVehiclesByCurrentDriverId(@PathVariable Integer driverId) {
        try {
            List<Vehicle> vehicles = vehicleService.getVehiclesByCurrentDriverId(driverId);
            return Result.success(vehicles);
        } catch (Exception e) {
            return Result.error("获取司机车辆失败: " + e.getMessage());
        }
    }

    /**
     * 根据车辆类型获取车辆
     */
    @GetMapping("/type/{vehicleType}")
    public Result<List<Vehicle>> getVehiclesByType(@PathVariable String vehicleType) {
        try {
            Map<String, Object> params = new HashMap<>();
            params.put("vehicleType", vehicleType);
            List<Vehicle> vehicles = vehicleService.searchVehicles(params);
            return Result.success(vehicles);
        } catch (Exception e) {
            return Result.error("获取车辆类型列表失败: " + e.getMessage());
        }
    }

    /**
     * 根据状态获取车辆
     */
    @GetMapping("/status/{status}")
    public Result<List<Vehicle>> getVehiclesByStatus(@PathVariable Integer status) {
        try {
            // 修复 Map.of() 问题
            Map<String, Object> params = new HashMap<>();
            params.put("status", status);
            List<Vehicle> vehicles = vehicleService.searchVehicles(params);
            return Result.success(vehicles);
        } catch (Exception e) {
            return Result.error("获取状态车辆列表失败: " + e.getMessage());
        }
    }
}