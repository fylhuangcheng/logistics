package jmu.fyl.logistics.entity;

import java.util.Date;

public class CostDetail extends BaseEntity {
    private Integer costId;
    private Integer orderId;
    private Integer taskId;
    private Integer costType;
    private Integer costCategory;
    private Double amount;
    private String currency;
    private Integer payerId;
    private Integer payeeId;
    private Integer paymentStatus;
    private String paymentMethod;
    private Date paymentTime;
    private String invoiceNumber;
    private Integer invoiceStatus;
    private String costDescription;
    private Date costTime;
    private Integer accountedBy;
    private Date accountedTime;

    private Order order;
    private TransportTask task;
    private User payer;
    private User payee;
    private User accountUser;

    public Integer getCostId() {
        return costId;
    }

    public void setCostId(Integer costId) {
        this.costId = costId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public Integer getTaskId() {
        return taskId;
    }

    public void setTaskId(Integer taskId) {
        this.taskId = taskId;
    }

    public Integer getCostType() {
        return costType;
    }

    public void setCostType(Integer costType) {
        this.costType = costType;
    }

    public Integer getCostCategory() {
        return costCategory;
    }

    public void setCostCategory(Integer costCategory) {
        this.costCategory = costCategory;
    }

    public Double getAmount() {
        return amount;
    }

    public void setAmount(Double amount) {
        this.amount = amount;
    }

    public String getCurrency() {
        return currency;
    }

    public void setCurrency(String currency) {
        this.currency = currency;
    }

    public Integer getPayerId() {
        return payerId;
    }

    public void setPayerId(Integer payerId) {
        this.payerId = payerId;
    }

    public Integer getPayeeId() {
        return payeeId;
    }

    public void setPayeeId(Integer payeeId) {
        this.payeeId = payeeId;
    }

    public Integer getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(Integer paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Date getPaymentTime() {
        return paymentTime;
    }

    public void setPaymentTime(Date paymentTime) {
        this.paymentTime = paymentTime;
    }

    public String getInvoiceNumber() {
        return invoiceNumber;
    }

    public void setInvoiceNumber(String invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
    }

    public Integer getInvoiceStatus() {
        return invoiceStatus;
    }

    public void setInvoiceStatus(Integer invoiceStatus) {
        this.invoiceStatus = invoiceStatus;
    }

    public String getCostDescription() {
        return costDescription;
    }

    public void setCostDescription(String costDescription) {
        this.costDescription = costDescription;
    }

    public Date getCostTime() {
        return costTime;
    }

    public void setCostTime(Date costTime) {
        this.costTime = costTime;
    }

    public Integer getAccountedBy() {
        return accountedBy;
    }

    public void setAccountedBy(Integer accountedBy) {
        this.accountedBy = accountedBy;
    }

    public Date getAccountedTime() {
        return accountedTime;
    }

    public void setAccountedTime(Date accountedTime) {
        this.accountedTime = accountedTime;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public TransportTask getTask() {
        return task;
    }

    public void setTask(TransportTask task) {
        this.task = task;
    }

    public User getPayer() {
        return payer;
    }

    public void setPayer(User payer) {
        this.payer = payer;
    }

    public User getPayee() {
        return payee;
    }

    public void setPayee(User payee) {
        this.payee = payee;
    }

    public User getAccountUser() {
        return accountUser;
    }

    public void setAccountUser(User accountUser) {
        this.accountUser = accountUser;
    }
}
