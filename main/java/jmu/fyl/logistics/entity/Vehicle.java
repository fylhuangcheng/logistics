package jmu.fyl.logistics.entity;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties({"currentDriver"})
public class Vehicle extends BaseEntity {
    private Integer vehicleId;
    private String licensePlate;
    private String vehicleType;
    private Double loadCapacity;
    private Integer status;
    private Integer currentStationId;
    private Integer currentDriverId;  // 已存在
    private String driverName;
    private String driverPhone;

    private Station currentStation;
    private Driver currentDriver;  // 新增关联对象

    public Integer getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(Integer vehicleId) {
        this.vehicleId = vehicleId;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public Double getLoadCapacity() {
        return loadCapacity;
    }

    public void setLoadCapacity(Double loadCapacity) {
        this.loadCapacity = loadCapacity;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getCurrentStationId() {
        return currentStationId;
    }

    public void setCurrentStationId(Integer currentStationId) {
        this.currentStationId = currentStationId;
    }

    public Integer getCurrentDriverId() {
        return currentDriverId;
    }

    public void setCurrentDriverId(Integer currentDriverId) {
        this.currentDriverId = currentDriverId;
    }

    public String getDriverName() {
        return driverName;
    }

    public void setDriverName(String driverName) {
        this.driverName = driverName;
    }

    public String getDriverPhone() {
        return driverPhone;
    }

    public void setDriverPhone(String driverPhone) {
        this.driverPhone = driverPhone;
    }

    public Station getCurrentStation() {
        return currentStation;
    }

    public void setCurrentStation(Station currentStation) {
        this.currentStation = currentStation;
    }

    public Driver getCurrentDriver() {
        return currentDriver;
    }

    public void setCurrentDriver(Driver currentDriver) {
        this.currentDriver = currentDriver;
    }
}