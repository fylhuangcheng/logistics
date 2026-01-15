package jmu.fyl.logistics.controller.api;

import jmu.fyl.logistics.entity.Driver;
import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.DriverService;
import jmu.fyl.logistics.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/drivers")
public class DriverController {

    @Autowired
    private DriverService driverService;

    @PostMapping
    public Result<Driver> addDriver(@RequestBody Driver driver, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() >= 3) {
                return Result.error(403, "无权添加司机");
            }

            driverService.addDriver(driver);
            return Result.success("司机添加成功", driver);
        } catch (Exception e) {
            return Result.error("添加司机失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public Result<Driver> updateDriver(@PathVariable Integer id, @RequestBody Driver driver, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() >= 3) {
                return Result.error(403, "无权更新司机信息");
            }

            driver.setDriverId(id);
            driverService.updateDriver(driver);
            return Result.success("司机信息更新成功", driver);
        } catch (Exception e) {
            return Result.error("更新司机信息失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteDriver(@PathVariable Integer id, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() >= 3) {
                return Result.error(403, "无权删除司机");
            }

            driverService.deleteDriver(id);
            return Result.success("司机删除成功");
        } catch (Exception e) {
            return Result.error("删除司机失败: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public Result<Driver> getDriverById(@PathVariable Integer id) {
        try {
            Driver driver = driverService.getDriverById(id);
            if (driver != null) {
                return Result.success(driver);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取司机信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/user/{userId}")
    public Result<Driver> getDriverByUserId(@PathVariable Integer userId) {
        try {
            Driver driver = driverService.getDriverByUserId(userId);
            if (driver != null) {
                return Result.success(driver);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取用户对应的司机信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/license/{licenseNumber}")
    public Result<Driver> getDriverByLicenseNumber(@PathVariable String licenseNumber) {
        try {
            Driver driver = driverService.getDriverByLicenseNumber(licenseNumber);
            if (driver != null) {
                return Result.success(driver);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取驾照信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/available/{stationId}")
    public Result<List<Driver>> getAvailableDrivers(@PathVariable Integer stationId) {
        try {
            List<Driver> drivers = driverService.getAvailableDrivers(stationId);
            return Result.success(drivers);
        } catch (Exception e) {
            return Result.error("获取可用司机失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/status")
    public Result<Void> updateCurrentStatus(@PathVariable Integer id, @RequestBody Map<String, Integer> statusInfo, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() >= 3) {
                return Result.error(403, "无权更新司机状态");
            }

            Integer currentStatus = statusInfo.get("currentStatus");
            driverService.updateCurrentStatus(id, currentStatus);
            return Result.success("司机状态更新成功");
        } catch (Exception e) {
            return Result.error("更新司机状态失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/vehicle")
    public Result<Void> updateAssignedVehicle(@PathVariable Integer id, @RequestBody Map<String, Integer> vehicleInfo, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() >= 3) {
                return Result.error(403, "无权分配车辆");
            }

            Integer vehicleId = vehicleInfo.get("vehicleId");
            driverService.updateAssignedVehicle(id, vehicleId);
            return Result.success("车辆分配成功");
        } catch (Exception e) {
            return Result.error("分配车辆失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/rest")
    public Result<Void> updateLastRestTime(@PathVariable Integer id, @RequestBody Map<String, Date> restInfo, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() >= 3) {
                return Result.error(403, "无权更新休息时间");
            }

            Date lastRestTime = restInfo.get("lastRestTime");
            driverService.updateLastRestTime(id, lastRestTime);
            return Result.success("休息时间更新成功");
        } catch (Exception e) {
            return Result.error("更新休息时间失败: " + e.getMessage());
        }
    }

    @GetMapping("/expiring")
    public Result<List<Driver>> getExpiringDrivers(@RequestParam(defaultValue = "30") Integer days) {
        try {
            List<Driver> drivers = driverService.getExpiringDrivers(days);
            return Result.success(drivers);
        } catch (Exception e) {
            return Result.error("获取即将到期驾照失败: " + e.getMessage());
        }
    }

    @GetMapping("/stats")
    public Result<Map<String, Object>> getDriverStats() {
        try {
            Map<String, Object> stats = driverService.getDriverStats();
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取司机统计失败: " + e.getMessage());
        }
    }

    @PostMapping("/search")
    public Result<List<Driver>> searchDrivers(@RequestBody Map<String, Object> params) {
        try {
            List<Driver> drivers = driverService.searchDrivers(params);
            return Result.success(drivers);
        } catch (Exception e) {
            return Result.error("搜索司机失败: " + e.getMessage());
        }
    }

    @PostMapping("/count")
    public Result<Map<String, Object>> countDrivers(@RequestBody Map<String, Object> params) {
        try {
            int count = driverService.countDrivers(params);
            Map<String, Object> result = new HashMap<>();
            result.put("count", count);
            return Result.success(result);
        } catch (Exception e) {
            return Result.error("统计司机数量失败: " + e.getMessage());
        }
    }
}
