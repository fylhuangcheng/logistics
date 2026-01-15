package jmu.fyl.logistics.entity;

import java.util.Date;

public class CargoItem extends BaseEntity {
    private Integer cargoId;
    private Integer orderId;
    private String cargoCode;
    private String cargoName;
    private String cargoType;
    private Integer quantity;
    private String unit;
    private Double unitWeight;
    private Double unitVolume;
    private Double totalWeight;
    private Double totalVolume;
    private Double declaredValue;
    private Double insuranceAmount;
    private String packagingType;
    private String specialRequirements;
    private String storageConditions;
    private Integer currentLocationType;
    private Integer currentStationId;
    private Integer status;
    private Date lastScanTime;

    private Order order;
    private Station currentStation;

    public Integer getCargoId() {
        return cargoId;
    }

    public void setCargoId(Integer cargoId) {
        this.cargoId = cargoId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Integer getCargoItemId() {
        return this.cargoId;
    }

    public Double getWeight() {
        return this.totalWeight;
    }

    public Double getValue() {
        return this.declaredValue;
    }

    public String getOrderNumber() {
        if (this.order != null) {
            return this.order.getOrderNumber();
        }
        return null;
    }

    public String getCargoCode() {
        return cargoCode;
    }

    public void setCargoCode(String cargoCode) {
        this.cargoCode = cargoCode;
    }

    public String getCargoName() {
        return cargoName;
    }

    public void setCargoName(String cargoName) {
        this.cargoName = cargoName;
    }

    public String getCargoType() {
        return cargoType;
    }

    public void setCargoType(String cargoType) {
        this.cargoType = cargoType;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public Double getUnitWeight() {
        return unitWeight;
    }

    public void setUnitWeight(Double unitWeight) {
        this.unitWeight = unitWeight;
    }

    public Double getUnitVolume() {
        return unitVolume;
    }

    public void setUnitVolume(Double unitVolume) {
        this.unitVolume = unitVolume;
    }

    public Double getTotalWeight() {
        return totalWeight;
    }

    public void setTotalWeight(Double totalWeight) {
        this.totalWeight = totalWeight;
    }

    public Double getTotalVolume() {
        return totalVolume;
    }

    public void setTotalVolume(Double totalVolume) {
        this.totalVolume = totalVolume;
    }

    public Double getDeclaredValue() {
        return declaredValue;
    }

    public void setDeclaredValue(Double declaredValue) {
        this.declaredValue = declaredValue;
    }

    public Double getInsuranceAmount() {
        return insuranceAmount;
    }

    public void setInsuranceAmount(Double insuranceAmount) {
        this.insuranceAmount = insuranceAmount;
    }

    public String getPackagingType() {
        return packagingType;
    }

    public void setPackagingType(String packagingType) {
        this.packagingType = packagingType;
    }

    public String getSpecialRequirements() {
        return specialRequirements;
    }

    public void setSpecialRequirements(String specialRequirements) {
        this.specialRequirements = specialRequirements;
    }

    public String getStorageConditions() {
        return storageConditions;
    }

    public void setStorageConditions(String storageConditions) {
        this.storageConditions = storageConditions;
    }

    public Integer getCurrentLocationType() {
        return currentLocationType;
    }

    public void setCurrentLocationType(Integer currentLocationType) {
        this.currentLocationType = currentLocationType;
    }

    public Integer getCurrentStationId() {
        return currentStationId;
    }

    public void setCurrentStationId(Integer currentStationId) {
        this.currentStationId = currentStationId;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Date getLastScanTime() {
        return lastScanTime;
    }

    public void setLastScanTime(Date lastScanTime) {
        this.lastScanTime = lastScanTime;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public Station getCurrentStation() {
        return currentStation;
    }

    public void setCurrentStation(Station currentStation) {
        this.currentStation = currentStation;
    }
}
