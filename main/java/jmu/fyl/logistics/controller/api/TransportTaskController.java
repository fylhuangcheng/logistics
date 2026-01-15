package jmu.fyl.logistics.controller.api;

import jmu.fyl.logistics.entity.TransportTask;
import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.TransportTaskService;
import jmu.fyl.logistics.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/transport_tasks")
public class TransportTaskController {

    @Autowired
    private TransportTaskService transportTaskService;

    @PostMapping
    public Result<TransportTask> addTransportTask(@RequestBody TransportTask transportTask, HttpSession session) {
        try {
            // 权限检查：只有管理员和调度员可以创建运输任务
            User user = (User) session.getAttribute("user");
            if (user != null && (user.getUserType() == 3 || user.getUserType() == 4)) {
                return Result.error(403, "无权创建运输任务");
            }

            transportTaskService.addTransportTask(transportTask);
            return Result.success("运输任务添加成功", transportTask);
        } catch (Exception e) {
            return Result.error("添加运输任务失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public Result<TransportTask> updateTransportTask(@PathVariable Integer id, @RequestBody TransportTask transportTask, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && (user.getUserType() == 3 || user.getUserType() == 4)) {
                return Result.error(403, "无权更新运输任务");
            }

            transportTask.setTaskId(id);
            transportTaskService.updateTransportTask(transportTask);
            return Result.success("运输任务更新成功", transportTask);
        } catch (Exception e) {
            return Result.error("更新运输任务失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteTransportTask(@PathVariable Integer id, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && (user.getUserType() == 3 || user.getUserType() == 4)) {
                return Result.error(403, "无权删除运输任务");
            }

            transportTaskService.deleteTransportTask(id);
            return Result.success("运输任务删除成功");
        } catch (Exception e) {
            return Result.error("删除运输任务失败: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public Result<TransportTask> getTransportTaskById(@PathVariable Integer id) {
        try {
            TransportTask transportTask = transportTaskService.getTransportTaskById(id);
            if (transportTask != null) {
                return Result.success(transportTask);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取运输任务失败: " + e.getMessage());
        }
    }

    @GetMapping("/number/{taskNumber}")
    public Result<TransportTask> getTransportTaskByNumber(@PathVariable String taskNumber) {
        try {
            TransportTask transportTask = transportTaskService.getTransportTaskByNumber(taskNumber);
            if (transportTask != null) {
                return Result.success(transportTask);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取运输任务失败: " + e.getMessage());
        }
    }

    @GetMapping("/driver/{driverId}")
    public Result<List<TransportTask>> getTransportTasksByDriverId(@PathVariable Integer driverId) {
        try {
            List<TransportTask> tasks = transportTaskService.getTransportTasksByDriverId(driverId);
            return Result.success(tasks);
        } catch (Exception e) {
            return Result.error("获取司机任务失败: " + e.getMessage());
        }
    }

    @GetMapping("/vehicle/{vehicleId}")
    public Result<List<TransportTask>> getTransportTasksByVehicleId(@PathVariable Integer vehicleId) {
        try {
            List<TransportTask> tasks = transportTaskService.getTransportTasksByVehicleId(vehicleId);
            return Result.success(tasks);
        } catch (Exception e) {
            return Result.error("获取车辆任务失败: " + e.getMessage());
        }
    }

    @GetMapping("/status/{taskStatus}")
    public Result<List<TransportTask>> getTransportTasksByTaskStatus(@PathVariable Integer taskStatus) {
        try {
            List<TransportTask> tasks = transportTaskService.getTransportTasksByTaskStatus(taskStatus);
            return Result.success(tasks);
        } catch (Exception e) {
            return Result.error("获取状态任务失败: " + e.getMessage());
        }
    }

    @GetMapping("/station/start/{stationId}")
    public Result<List<TransportTask>> getTransportTasksByStartStationId(@PathVariable Integer stationId) {
        try {
            List<TransportTask> tasks = transportTaskService.getTransportTasksByStartStationId(stationId);
            return Result.success(tasks);
        } catch (Exception e) {
            return Result.error("获取起始站点任务失败: " + e.getMessage());
        }
    }

    @GetMapping("/station/end/{stationId}")
    public Result<List<TransportTask>> getTransportTasksByEndStationId(@PathVariable Integer stationId) {
        try {
            List<TransportTask> tasks = transportTaskService.getTransportTasksByEndStationId(stationId);
            return Result.success(tasks);
        } catch (Exception e) {
            return Result.error("获取目的站点任务失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/status")
    public Result<Void> updateTaskStatus(@PathVariable Integer id, @RequestBody Map<String, Integer> statusInfo, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && (user.getUserType() == 3 || user.getUserType() == 4)) {
                return Result.error(403, "无权更新任务状态");
            }

            Integer taskStatus = statusInfo.get("taskStatus");
            transportTaskService.updateTaskStatus(id, taskStatus);
            return Result.success("任务状态更新成功");
        } catch (Exception e) {
            return Result.error("更新任务状态失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/actual-times")
    public Result<Void> updateActualTimes(
            @PathVariable Integer id,
            @RequestBody Map<String, Object> timesInfo,
            HttpSession session) {
        try {
            // 权限检查：只有司机和相关人员可以更新实际时间
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() == 3) {
                return Result.error(403, "无权更新实际时间");
            }

            Date actualDepartureTime = (Date) timesInfo.get("actualDepartureTime");
            Date actualArrivalTime = (Date) timesInfo.get("actualArrivalTime");
            Double actualDistance = timesInfo.get("actualDistance") != null ?
                    Double.parseDouble(timesInfo.get("actualDistance").toString()) : null;

            transportTaskService.updateActualTimes(id, actualDepartureTime, actualArrivalTime, actualDistance);
            return Result.success("实际时间更新成功");
        } catch (Exception e) {
            return Result.error("更新实际时间失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/supervisor")
    public Result<Void> assignSupervisor(@PathVariable Integer id, @RequestBody Map<String, Integer> supervisorInfo, HttpSession session) {
        try {
            // 权限检查
            User user = (User) session.getAttribute("user");
            if (user != null && (user.getUserType() == 3 || user.getUserType() == 4)) {
                return Result.error(403, "无权分配监督员");
            }

            Integer supervisorId = supervisorInfo.get("supervisorId");
            transportTaskService.assignSupervisor(id, supervisorId);
            return Result.success("监督员分配成功");
        } catch (Exception e) {
            return Result.error("分配监督员失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}/weather")
    public Result<Void> updateWeatherConditions(
            @PathVariable Integer id,
            @RequestBody Map<String, String> weatherInfo,
            HttpSession session) {
        try {
            // 权限检查：司机和相关人员可以更新天气
            User user = (User) session.getAttribute("user");
            if (user != null && user.getUserType() == 3) {
                return Result.error(403, "无权更新天气信息");
            }

            String weatherConditions = weatherInfo.get("weatherConditions");
            transportTaskService.updateWeatherConditions(id, weatherConditions);
            return Result.success("天气信息更新成功");
        } catch (Exception e) {
            return Result.error("更新天气信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/active")
    public Result<List<TransportTask>> getActiveTasks(@RequestParam Date date) {
        try {
            List<TransportTask> tasks = transportTaskService.getActiveTasks(date);
            return Result.success(tasks);
        } catch (Exception e) {
            return Result.error("获取活跃任务失败: " + e.getMessage());
        }
    }

    @GetMapping("/date-range")
    public Result<List<TransportTask>> getTasksByDateRange(
            @RequestParam Date startDate,
            @RequestParam Date endDate) {
        try {
            List<TransportTask> tasks = transportTaskService.getTasksByDateRange(startDate, endDate);
            return Result.success(tasks);
        } catch (Exception e) {
            return Result.error("获取日期范围任务失败: " + e.getMessage());
        }
    }

    @GetMapping("/stats/status")
    public Result<List<Map<String, Object>>> getTaskStatsByStatus() {
        try {
            List<Map<String, Object>> stats = transportTaskService.getTaskStatsByStatus();
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取任务状态统计失败: " + e.getMessage());
        }
    }

    @GetMapping("/stats/driver/{driverId}")
    public Result<Map<String, Object>> getDriverTaskStats(
            @PathVariable Integer driverId,
            @RequestParam Date startDate,
            @RequestParam Date endDate) {
        try {
            Map<String, Object> stats = transportTaskService.getDriverTaskStats(driverId, startDate, endDate);
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取司机任务统计失败: " + e.getMessage());
        }
    }

    @GetMapping("/search")
    public Result<List<TransportTask>> searchTransportTasks(@RequestParam Map<String, Object> params) {
        try {
            List<TransportTask> tasks = transportTaskService.searchTransportTasks(params);
            return Result.success(tasks);
        } catch (Exception e) {
            return Result.error("搜索运输任务失败: " + e.getMessage());
        }
    }
}