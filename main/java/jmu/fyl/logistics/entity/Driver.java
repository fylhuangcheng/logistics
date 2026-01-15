package jmu.fyl.logistics.entity;

import java.util.Date;

public class Driver extends BaseEntity {
    private Integer driverId;
    private Integer userId;
    private String licenseNumber;
    private String licenseType;
    private Date licenseExpiryDate;
    private Integer yearsExperience;
    private String emergencyContact;
    private String emergencyPhone;
    private String healthStatus;
    private Double totalMileage;
    private Double safetyScore;
    private Integer currentStatus;
    private Integer assignedVehicleId;
    private Date lastRestTime;

    private User user;
    private Vehicle assignedVehicle;

    public Integer getDriverId() {
        return driverId;
    }

    public void setDriverId(Integer driverId) {
        this.driverId = driverId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getLicenseNumber() {
        return licenseNumber;
    }

    public void setLicenseNumber(String licenseNumber) {
        this.licenseNumber = licenseNumber;
    }

    public String getLicenseType() {
        return licenseType;
    }

    public void setLicenseType(String licenseType) {
        this.licenseType = licenseType;
    }

    public Date getLicenseExpiryDate() {
        return licenseExpiryDate;
    }

    public void setLicenseExpiryDate(Date licenseExpiryDate) {
        this.licenseExpiryDate = licenseExpiryDate;
    }

    public Integer getYearsExperience() {
        return yearsExperience;
    }

    public void setYearsExperience(Integer yearsExperience) {
        this.yearsExperience = yearsExperience;
    }

    public String getEmergencyContact() {
        return emergencyContact;
    }

    public void setEmergencyContact(String emergencyContact) {
        this.emergencyContact = emergencyContact;
    }

    public String getEmergencyPhone() {
        return emergencyPhone;
    }

    public void setEmergencyPhone(String emergencyPhone) {
        this.emergencyPhone = emergencyPhone;
    }

    public String getHealthStatus() {
        return healthStatus;
    }

    public void setHealthStatus(String healthStatus) {
        this.healthStatus = healthStatus;
    }

    public Double getTotalMileage() {
        return totalMileage;
    }

    public void setTotalMileage(Double totalMileage) {
        this.totalMileage = totalMileage;
    }

    public Double getSafetyScore() {
        return safetyScore;
    }

    public void setSafetyScore(Double safetyScore) {
        this.safetyScore = safetyScore;
    }

    public Integer getCurrentStatus() {
        return currentStatus;
    }

    public void setCurrentStatus(Integer currentStatus) {
        this.currentStatus = currentStatus;
    }

    public Integer getAssignedVehicleId() {
        return assignedVehicleId;
    }

    public void setAssignedVehicleId(Integer assignedVehicleId) {
        this.assignedVehicleId = assignedVehicleId;
    }

    public Date getLastRestTime() {
        return lastRestTime;
    }

    public void setLastRestTime(Date lastRestTime) {
        this.lastRestTime = lastRestTime;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Vehicle getAssignedVehicle() {
        return assignedVehicle;
    }

    public void setAssignedVehicle(Vehicle assignedVehicle) {
        this.assignedVehicle = assignedVehicle;
    }
}