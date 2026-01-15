package jmu.fyl.logistics.controller.api;

import jmu.fyl.logistics.entity.Station;
import jmu.fyl.logistics.service.StationService;
import jmu.fyl.logistics.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/stations")
public class StationController {

    @Autowired
    private StationService stationService;

    @PostMapping
    public Result<Station> addStation(@RequestBody Station station) {
        try {
            if (stationService.checkStationCodeExists(station.getStationCode())) {
                return Result.error(400, "网点编码已存在");
            }
            stationService.addStation(station);
            return Result.success("网点添加成功", station);
        } catch (Exception e) {
            return Result.error("添加网点失败: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public Result<Station> updateStation(@PathVariable Integer id, @RequestBody Station station) {
        try {
            station.setStationId(id);
            stationService.updateStation(station);
            return Result.success("网点更新成功", station);
        } catch (Exception e) {
            return Result.error("更新网点失败: " + e.getMessage());
        }
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteStation(@PathVariable Integer id) {
        try {
            stationService.deleteStation(id);
            return Result.success("网点删除成功");
        } catch (Exception e) {
            return Result.error("删除网点失败: " + e.getMessage());
        }
    }

    @GetMapping("/{id}")
    public Result<Station> getStationById(@PathVariable Integer id) {
        try {
            Station station = stationService.getStationById(id);
            if (station != null) {
                return Result.success(station);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取网点信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/code/{code}")
    public Result<Station> getStationByCode(@PathVariable String code) {
        try {
            Station station = stationService.getStationByCode(code);
            if (station != null) {
                return Result.success(station);
            } else {
                return Result.notFound();
            }
        } catch (Exception e) {
            return Result.error("获取网点信息失败: " + e.getMessage());
        }
    }

    @GetMapping("/check-code")
    public Result<Boolean> checkStationCode(@RequestParam String code) {
        try {
            boolean exists = stationService.checkStationCodeExists(code);
            return Result.success(exists);
        } catch (Exception e) {
            return Result.error("检查网点编码失败: " + e.getMessage());
        }
    }

    @GetMapping("/active")
    public Result<List<Station>> getActiveStations() {
        try {
            List<Station> stations = stationService.getStationsByStatus(1);
            return Result.success(stations);
        } catch (Exception e) {
            return Result.error("获取活跃网点列表失败: " + e.getMessage());
        }
    }

    @GetMapping("/{id}/detail-stats")
    public Result<Map<String, Object>> getStationDetailStats(@PathVariable Integer id) {
        try {
            Map<String, Object> stats = stationService.getStationDetailStats(id);
            return Result.success(stats);
        } catch (Exception e) {
            return Result.error("获取网点详情统计失败: " + e.getMessage());
        }
    }
}