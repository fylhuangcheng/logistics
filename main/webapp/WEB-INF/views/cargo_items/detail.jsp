<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="row">
    <div class="col-12">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">货物详情</h6>
                <a href="${pageContext.request.contextPath}/cargo_items" class="btn btn-sm btn-secondary">返回列表</a>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty cargoItem}">
                        <div class="row mb-4">
                            <div class="col-md-8">
                                <h4>货物ID: ${cargoItem.cargoId}</h4>
                            </div>
                            <div class="col-md-4 text-end">
                                <c:choose>
                                    <c:when test="${cargoItem.status == 1}">
                                        <span class="badge bg-success">正常</span>
                                    </c:when>
                                    <c:when test="${cargoItem.status == 2}">
                                        <span class="badge bg-warning">已破损</span>
                                    </c:when>
                                    <c:when test="${cargoItem.status == 3}">
                                        <span class="badge bg-danger">已丢失</span>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">货物名称</label>
                                    <input type="text" class="form-control" value="${cargoItem.cargoName}" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">货物类型</label>
                                    <input type="text" class="form-control" value="${cargoItem.cargoType}" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label class="form-label text-muted">所属订单</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control"
                                               value="${not empty cargoItem.order ? cargoItem.order.orderNumber : cargoItem.orderId}" readonly>
                                        <a href="${pageContext.request.contextPath}/orders/${cargoItem.orderId}"
                                           class="btn btn-outline-info" target="_blank">查看</a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label class="form-label text-muted">数量</label>
                                    <input type="text" class="form-control"
                                           value="${cargoItem.quantity} ${cargoItem.unit}" readonly>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label class="form-label text-muted">重量(kg)</label>
                                    <input type="text" class="form-control"
                                           value="${not empty cargoItem.totalWeight ? cargoItem.totalWeight : '未记录'}" readonly>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">体积(m³)</label>
                                    <input type="text" class="form-control"
                                           value="${not empty cargoItem.totalVolume ? cargoItem.totalVolume : '未记录'}" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">货物价值(¥)</label>
                                    <input type="text" class="form-control text-primary fw-bold"
                                           value="¥${not empty cargoItem.declaredValue ? cargoItem.declaredValue : '未记录'}" readonly>
                                </div>
                            </div>
                        </div>

                        <c:if test="${not empty cargoItem.specialRequirements}">
                            <div class="mb-3">
                                <label class="form-label text-muted">特殊要求</label>
                                <textarea class="form-control" rows="3" readonly>${cargoItem.specialRequirements}</textarea>
                            </div>
                        </c:if>

                        <div class="mb-3">
                            <label class="form-label text-muted">创建时间</label>
                            <input type="text" class="form-control"
                                   value="${not empty cargoItem.createTime ? cargoItem.createTime : '未记录'}" readonly>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-muted">更新时间</label>
                            <input type="text" class="form-control"
                                   value="${not empty cargoItem.updateTime ? cargoItem.updateTime : '未记录'}" readonly>
                        </div>

                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/cargo_items/${cargoItem.cargoId}/edit"
                               class="btn btn-sm btn-primary me-2">
                                <i class="fas fa-edit"></i> 编辑
                            </a>
                            <button onclick="deleteCargoItem(${cargoItem.cargoId})"
                                    class="btn btn-sm btn-danger me-2">
                                <i class="fas fa-trash"></i> 删除
                            </button>
                            <c:if test="${cargoItem.status == 1}">
                                <button onclick="updateCargoStatus(${cargoItem.cargoId}, 2)"
                                        class="btn btn-sm btn-warning me-2">
                                    标记为破损
                                </button>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-danger">无法加载货物信息</div>
                        <a href="${pageContext.request.contextPath}/cargo_items" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> 返回列表
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
    // 删除货物
    function deleteCargoItem(cargoId) {
        Utils.confirm('确定要删除这个货物吗？<br><small class="text-muted">删除后将无法恢复</small>', function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/cargo_items/' + cargoId,
                type: 'DELETE',
                success: function(response) {
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/cargo_items?success=' +
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

    // 更新货物状态
    function updateCargoStatus(cargoId, status) {
        const statusText = status === 2 ? '破损' : '正常';
        Utils.confirm(`确定要将货物标记为"${statusText}"状态吗？`, function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/cargo_items/' + cargoId + '/status',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify({ status: status }),
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

    $(document).ready(function() {
        console.log('货物详情页加载完成');
    });
</script>