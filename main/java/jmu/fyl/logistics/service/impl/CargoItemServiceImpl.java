package jmu.fyl.logistics.service.impl;
import java.util.ArrayList;
import java.util.stream.Collectors;
import jmu.fyl.logistics.dao.CargoItemDao;
import jmu.fyl.logistics.dao.OrderDao;
import jmu.fyl.logistics.entity.CargoItem;
import jmu.fyl.logistics.entity.Order;
import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.CargoItemService;
import jmu.fyl.logistics.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional
public class CargoItemServiceImpl implements CargoItemService {

    @Autowired
    private CargoItemDao cargoItemDao;

    @Autowired
    private OrderDao orderDao;

    @Autowired
    private OrderService orderService;

    @Override
    public int addCargoItem(CargoItem cargoItem) {
        // 自动计算总重量和总体积
        if (cargoItem.getQuantity() != null && cargoItem.getUnitWeight() != null) {
            cargoItem.setTotalWeight(cargoItem.getQuantity() * cargoItem.getUnitWeight());
        }
        if (cargoItem.getQuantity() != null && cargoItem.getUnitVolume() != null) {
            cargoItem.setTotalVolume(cargoItem.getQuantity() * cargoItem.getUnitVolume());
        }

        // 设置默认状态
        if (cargoItem.getStatus() == null) {
            cargoItem.setStatus(1); // 默认已创建
        }

        // 设置默认当前位置
        if (cargoItem.getCurrentLocationType() == null) {
            cargoItem.setCurrentLocationType(1); // 默认在仓库
        }

        return cargoItemDao.insert(cargoItem);
    }


    @Override
    public List<CargoItem> searchCargoItems(Map<String, Object> params, User user) {
        // 如果是客户，自动限制为只能查看自己的货物
        if (user != null && user.getUserType() == 3) { // 客户类型为3
            // 获取客户的所有订单号
            List<Order> customerOrders = orderService.getOrdersByUserId(user.getUserId());
            if (customerOrders.isEmpty()) {
                return new ArrayList<>();
            }

            // 提取订单号列表 - 用 orderNumber 进行匹配
            List<String> orderNumbers = customerOrders.stream()
                    .map(Order::getOrderNumber)
                    .collect(Collectors.toList());

            params.put("customerOrderNumbers", orderNumbers);
        }
        // 管理员（userType = 1）和司机（userType = 2）可以看到所有货物

        List<CargoItem> cargoItems = cargoItemDao.findByCondition(params);
        // 为每个货物加载订单信息
        for (CargoItem cargo : cargoItems) {
            if (cargo.getOrderId() != null) {
                Order order = orderDao.findById(cargo.getOrderId());
                cargo.setOrder(order);
            }
        }
        return cargoItems;
    }

    @Override
    public int countCargoItems(Map<String, Object> params, User user) {
        // 如果是客户，自动限制为只能查看自己的货物
        if (user != null && user.getUserType() == 3) { // 客户类型为3
            // 获取客户的所有订单号
            List<Order> customerOrders = orderService.getOrdersByUserId(user.getUserId());
            if (customerOrders.isEmpty()) {
                return 0;
            }

            // 提取订单号列表 - 用 orderNumber 进行匹配
            List<String> orderNumbers = customerOrders.stream()
                    .map(Order::getOrderNumber)
                    .collect(Collectors.toList());

            params.put("customerOrderNumbers", orderNumbers);
        }
        return cargoItemDao.countByCondition(params);
    }
    // 添加新方法：

    @Override
    public int updateCargoItem(CargoItem cargoItem) {
        return cargoItemDao.update(cargoItem);
    }

    @Override
    public int deleteCargoItem(Integer cargoId) {
        return cargoItemDao.delete(cargoId);
    }

    @Override
    public CargoItem getCargoItemById(Integer cargoId) {
        CargoItem cargo = cargoItemDao.findById(cargoId);
        if (cargo != null && cargo.getOrderId() != null) {
            // 加载订单信息
            Order order = orderDao.findById(cargo.getOrderId());
            cargo.setOrder(order);
        }
        return cargo;
    }

    @Override
    public List<CargoItem> getAllCargoItems() {
        return cargoItemDao.findAll();
    }

    @Override
    public List<CargoItem> getCargoItemsByOrderId(Integer orderId) {
        return cargoItemDao.findByOrderId(orderId);
    }

    @Override
    public List<CargoItem> getCargoItemsByCargoCode(String cargoCode) {
        return cargoItemDao.findByCargoCode(cargoCode);
    }

    @Override
    public List<CargoItem> getCargoItemsByCargoType(String cargoType) {
        return cargoItemDao.findByCargoType(cargoType);
    }

    @Override
    public List<CargoItem> getCargoItemsByStatus(Integer status) {
        return cargoItemDao.findByStatus(status);
    }

    @Override
    public List<CargoItem> getCargoItemsByCurrentStationId(Integer stationId) {
        return cargoItemDao.findByCurrentStationId(stationId);
    }

    @Override
    public List<CargoItem> getCargoItemsByCurrentLocationType(Integer locationType) {
        return cargoItemDao.findByCurrentLocationType(locationType);
    }

    @Override
    public List<CargoItem> getCargoItemsByScanTimeRange(Date startTime, Date endTime) {
        return cargoItemDao.findByScanTimeRange(startTime, endTime);
    }

    @Override
    public int updateCargoStatus(Integer cargoId, Integer status) {
        return cargoItemDao.updateStatus(cargoId, status);
    }

    @Override
    public int updateCurrentStation(Integer cargoId, Integer stationId) {
        return cargoItemDao.updateCurrentStation(cargoId, stationId);
    }

    @Override
    public int updateCurrentLocation(Integer cargoId, Integer locationType, Integer stationId) {
        return cargoItemDao.updateCurrentLocation(cargoId, locationType, stationId);
    }

    @Override
    public int updateLastScanTime(Integer cargoId, Date lastScanTime) {
        return cargoItemDao.updateLastScanTime(cargoId, lastScanTime);
    }

    @Override
    public int updateMultipleStatus(List<Integer> cargoIds, Integer status) {
        return cargoItemDao.updateMultipleStatus(cargoIds, status);
    }

    @Override
    public Map<String, Object> getCargoStatsByOrder(Integer orderId) {
        Map<String, Object> stats = cargoItemDao.getCargoStatsByOrder(orderId);
        if (stats == null) {
            stats = new HashMap<>();
        }
        return stats;
    }

    @Override
    public Map<String, Object> getCargoStatsByStation(Integer stationId) {
        Map<String, Object> stats = cargoItemDao.getCargoStatsByStation(stationId);
        if (stats == null) {
            stats = new HashMap<>();
        }
        return stats;
    }

    @Override
    public List<CargoItem> searchCargoItems(Map<String, Object> params) {
        List<CargoItem> cargoItems = cargoItemDao.findByCondition(params);
        // 为每个货物加载订单信息
        for (CargoItem cargo : cargoItems) {
            if (cargo.getOrderId() != null) {
                Order order = orderDao.findById(cargo.getOrderId());
                cargo.setOrder(order);
            }
        }
        return cargoItems;
    }

    @Override
    public int countCargoItems(Map<String, Object> params) {
        return cargoItemDao.countByCondition(params);
    }
}