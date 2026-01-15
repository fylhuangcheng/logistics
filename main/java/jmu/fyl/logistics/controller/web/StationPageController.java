package jmu.fyl.logistics.controller.web;

import jmu.fyl.logistics.entity.Station;
import jmu.fyl.logistics.service.StationService;
import jmu.fyl.logistics.util.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/stations")
public class StationPageController extends BaseController {

    @Autowired
    private StationService stationService;

    @GetMapping
    public String list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String stationCode,
            @RequestParam(required = false) String stationName,
            @RequestParam(required = false) Integer status,
            Model model) {

        model.addAttribute("pageTitle", "网点管理");
        model.addAttribute("activeMenu", "stations");
        model.addAttribute("subMenu", "station_list");
        model.addAttribute("contentPage", "stations/list.jsp");

        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> current = new HashMap<>();
        current.put("name", "网点列表");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        Map<String, Object> params = new HashMap<>();
        params.put("stationCode", stationCode);
        params.put("stationName", stationName);
        params.put("status", status);
        params.put("start", (page - 1) * size);
        params.put("limit", size);

        List<Station> stations = stationService.searchStations(params);
        int total = stationService.countStations(params);

        Map<String, Object> pageData = new HashMap<>();
        pageData.put("list", stations);
        pageData.put("total", total);
        pageData.put("pageNum", page);
        pageData.put("pageSize", size);
        pageData.put("pages", (int) Math.ceil((double) total / size));

        Result<Map<String, Object>> result = Result.success("查询成功", pageData);
        model.addAttribute("result", result);

        return "layout/main";
    }

    @GetMapping("/add")
    public String addForm(Model model) {
        model.addAttribute("pageTitle", "新增网点");
        model.addAttribute("activeMenu", "stations");
        model.addAttribute("subMenu", "station_add");
        model.addAttribute("contentPage", "stations/form.jsp");

        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "网点列表");
        list.put("url", "/stations");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "新增网点");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    @GetMapping("/{id}")
    public String detail(@PathVariable Integer id, Model model) {
        Station station = stationService.getStationById(id);

        model.addAttribute("pageTitle", "网点详情 - " + station.getStationName());
        model.addAttribute("activeMenu", "stations");
        model.addAttribute("contentPage", "stations/detail.jsp");
        model.addAttribute("station", station);

        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "网点列表");
        list.put("url", "/stations");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "网点详情");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Integer id, Model model) {
        Station station = stationService.getStationById(id);

        model.addAttribute("pageTitle", "编辑网点 - " + station.getStationName());
        model.addAttribute("activeMenu", "stations");
        model.addAttribute("contentPage", "stations/form.jsp");
        model.addAttribute("station", station);

        List<Map<String, String>> breadcrumb = new ArrayList<>();
        Map<String, String> home = new HashMap<>();
        home.put("name", "首页");
        home.put("url", "/");
        breadcrumb.add(home);

        Map<String, String> list = new HashMap<>();
        list.put("name", "网点列表");
        list.put("url", "/stations");
        breadcrumb.add(list);

        Map<String, String> current = new HashMap<>();
        current.put("name", "编辑网点");
        breadcrumb.add(current);
        model.addAttribute("breadcrumb", breadcrumb);

        return "layout/main";
    }
}