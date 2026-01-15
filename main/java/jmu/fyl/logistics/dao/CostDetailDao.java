package jmu.fyl.logistics.dao;

import jmu.fyl.logistics.entity.CostDetail;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Repository
public interface CostDetailDao extends BaseDao<CostDetail> {
    List<CostDetail> findByOrderId(@Param("orderId") Integer orderId);
    List<CostDetail> findByTaskId(@Param("taskId") Integer taskId);
    List<CostDetail> findByCostType(@Param("costType") Integer costType);
    List<CostDetail> findByCostCategory(@Param("costCategory") Integer costCategory);
    List<CostDetail> findByPaymentStatus(@Param("paymentStatus") Integer paymentStatus);
    List<CostDetail> findByPayerId(@Param("payerId") Integer payerId);
    List<CostDetail> findByPayeeId(@Param("payeeId") Integer payeeId);
    List<CostDetail> findByInvoiceStatus(@Param("invoiceStatus") Integer invoiceStatus);
    List<CostDetail> findByCostTimeRange(@Param("startTime") Date startTime, @Param("endTime") Date endTime);
    List<CostDetail> findByPaymentTimeRange(@Param("startTime") Date startTime, @Param("endTime") Date endTime);
    List<CostDetail> findByOrderAndType(@Param("orderId") Integer orderId, @Param("costType") Integer costType);
    int updatePaymentStatus(@Param("costId") Integer costId, @Param("paymentStatus") Integer paymentStatus);
    int updatePaymentInfo(@Param("costId") Integer costId,
                          @Param("paymentStatus") Integer paymentStatus,
                          @Param("paymentMethod") String paymentMethod,
                          @Param("paymentTime") Date paymentTime);
    int updateInvoiceInfo(@Param("costId") Integer costId,
                          @Param("invoiceNumber") String invoiceNumber,
                          @Param("invoiceStatus") Integer invoiceStatus);
    double getTotalAmountByOrder(@Param("orderId") Integer orderId);
    double getTotalAmountByTask(@Param("taskId") Integer taskId);
    double getTotalAmountByTimeRange(@Param("startTime") Date startTime, @Param("endTime") Date endTime);
    List<Map<String, Object>> getCostStatsByCategory(@Param("startDate") Date startDate, @Param("endDate") Date endDate);
    List<Map<String, Object>> getCostStatsByType(@Param("startDate") Date startDate, @Param("endDate") Date endDate);
    List<Map<String, Object>> getUnpaidCosts(@Param("days") Integer days);
    List<Map<String, Object>> getRevenueByDate(@Param("startDate") Date startDate, @Param("endDate") Date endDate);
}