package jmu.fyl.logistics.service;

import jmu.fyl.logistics.entity.CostDetail;
import java.util.Date;
import java.util.List;
import java.util.Map;

public interface CostDetailService {
    int addCostDetail(CostDetail costDetail);
    int updateCostDetail(CostDetail costDetail);
    int deleteCostDetail(Integer costId);
    CostDetail getCostDetailById(Integer costId);
    List<CostDetail> getAllCostDetails();
    List<CostDetail> getCostDetailsByOrderId(Integer orderId);
    List<CostDetail> getCostDetailsByTaskId(Integer taskId);
    List<CostDetail> getCostDetailsByCostType(Integer costType);
    List<CostDetail> getCostDetailsByCostCategory(Integer costCategory);
    List<CostDetail> getCostDetailsByPaymentStatus(Integer paymentStatus);
    List<CostDetail> getCostDetailsByPayerId(Integer payerId);
    List<CostDetail> getCostDetailsByPayeeId(Integer payeeId);
    List<CostDetail> getCostDetailsByInvoiceStatus(Integer invoiceStatus);
    List<CostDetail> getCostDetailsByCostTimeRange(Date startTime, Date endTime);
    List<CostDetail> getCostDetailsByPaymentTimeRange(Date startTime, Date endTime);
    int updatePaymentStatus(Integer costId, Integer paymentStatus);
    int updatePaymentInfo(Integer costId, Integer paymentStatus, String paymentMethod, Date paymentTime);
    int updateInvoiceInfo(Integer costId, String invoiceNumber, Integer invoiceStatus);
    double getTotalAmountByOrder(Integer orderId);
    double getTotalAmountByTask(Integer taskId);
    double getTotalAmountByTimeRange(Date startTime, Date endTime);
    List<Map<String, Object>> getCostStatsByCategory(Date startDate, Date endDate);
    List<Map<String, Object>> getCostStatsByType(Date startDate, Date endDate);
    List<Map<String, Object>> getUnpaidCosts(Integer days);
    List<Map<String, Object>> getRevenueByDate(Date startDate, Date endDate);
    List<CostDetail> searchCostDetails(Map<String, Object> params);
    int countCostDetails(Map<String, Object> params);
}