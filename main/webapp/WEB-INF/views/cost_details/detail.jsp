<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="row">
    <div class="col-12">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">费用详情</h6>
                <a href="${pageContext.request.contextPath}/cost_details" class="btn btn-sm btn-secondary">返回列表</a>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty costDetail}">
                        <div class="row mb-4">
                            <div class="col-md-8">
                                <h4>费用ID: ${costDetail.costId}</h4>
                            </div>
                            <div class="col-md-4 text-end">
                                <c:choose>
                                    <c:when test="${costDetail.paymentStatus == 1}">
                                        <span class="badge bg-success">未支付</span>
                                    </c:when>
                                    <c:when test="${costDetail.paymentStatus == 2}">
                                        <span class="badge bg-primary">已支付</span>
                                    </c:when>
                                    <c:when test="${costDetail.paymentStatus == 3}">
                                        <span class="badge bg-danger">已取消</span>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">所属订单</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" value="${costDetail.order.orderNumber}" readonly>
                                        <a href="${pageContext.request.contextPath}/orders/${costDetail.orderId}"
                                           class="btn btn-outline-info" target="_blank">查看</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">费用类型</label>
                                    <input type="text" class="form-control" value="${costDetail.costType}" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">费用金额</label>
                                    <input type="text" class="form-control text-primary fw-bold"
                                           value="${costDetail.currency}${costDetail.amount}" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">支付方式</label>
                                    <input type="text" class="form-control"
                                           value="${costDetail.paymentMethod != null ? costDetail.paymentMethod : '未设置'}" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">费用说明</label>
                                    <textarea class="form-control" rows="3" readonly>${costDetail.costDescription}</textarea>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">发票号</label>
                                    <input type="text" class="form-control" value="${costDetail.invoiceNumber != null ? costDetail.invoiceNumber : '无'}" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label class="form-label text-muted">费用时间</label>
                                    <input type="text" class="form-control"
                                           value="${costDetail.costTime}" readonly>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label class="form-label text-muted">支付时间</label>
                                    <input type="text" class="form-control"
                                           value="${costDetail.paymentTime != null ? costDetail.paymentTime : '未支付'}" readonly>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label class="form-label text-muted">记账人</label>
                                    <input type="text" class="form-control"
                                           value="${costDetail.accountUser != null ? costDetail.accountUser.username : '系统'}" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">付款方</label>
                                    <input type="text" class="form-control"
                                           value="${costDetail.payer != null ? costDetail.payer.username : '未设置'}" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">收款方</label>
                                    <input type="text" class="form-control"
                                           value="${costDetail.payee != null ? costDetail.payee.username : '未设置'}" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/cost_details/${costDetail.costId}/edit"
                               class="btn btn-sm btn-primary me-2">
                                <i class="fas fa-edit"></i> 编辑
                            </a>
                            <button onclick="deleteCostDetail(${costDetail.costId})"
                                    class="btn btn-sm btn-danger me-2">
                                <i class="fas fa-trash"></i> 删除
                            </button>
                            <c:if test="${costDetail.paymentStatus == 1}">
                                <button onclick="updatePaymentStatus(${costDetail.costId}, 2)"
                                        class="btn btn-sm btn-success me-2">
                                    标记为已支付
                                </button>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-danger">无法加载费用信息</div>
                        <a href="${pageContext.request.contextPath}/cost_details" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> 返回列表
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
    // 删除费用
    function deleteCostDetail(costId) {
        Utils.confirm('确定要删除这个费用记录吗？<br><small class="text-muted">删除后将无法恢复</small>', function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/cost_details/' + costId,
                type: 'DELETE',
                success: function(response) {
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/cost_details?success=' +
                                encodeURIComponent(response.message || '删除成功');
                        }, 1000);
                    } else {
                        Utils.showError(response.message || '删除失败');
                    }
                },
                error: function(xhr) {
                    let errorMsg = '删除失败';
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        errorMsg = xhr.responseJSON.message;
                    }
                    Utils.showError(errorMsg);
                }
            });
        });
    }

    // 更新费用状态
    function updatePaymentStatus(costId, status) {
        const statusText = status === 2 ? '已支付' : '未支付';
        Utils.confirm(`确定要将费用标记为"${statusText}"吗？`, function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/cost_details/' + costId + '/status',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify({
                    paymentStatus: status,
                    paymentMethod: status === 2 ? '在线支付' : null
                }),
                success: function(response) {
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '状态更新成功');
                        setTimeout(() => {
                            window.location.reload();
                        }, 1000);
                    } else {
                        Utils.showError(response.message || '状态更新失败');
                    }
                },
                error: function(xhr) {
                    Utils.showError('状态更新失败');
                }
            });
        });
    }
</script>