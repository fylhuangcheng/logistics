<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="row">
    <div class="col-md-8">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">网点详情</h5>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty station}">
                        <table class="table table-bordered">
                            <tr>
                                <th style="width: 30%">网点编码</th>
                                <td>${station.stationCode}</td>
                            </tr>
                            <tr>
                                <th>网点名称</th>
                                <td>${station.stationName}</td>
                            </tr>
                            <tr>
                                <th>地址</th>
                                <td>${station.address}</td>
                            </tr>
                            <tr>
                                <th>联系电话</th>
                                <td>${station.phone}</td>
                            </tr>
                            <tr>
                                <th>状态</th>
                                <td>
                                    <span class="badge ${station.status == 1 ? 'bg-success' : 'bg-danger'}">
                                            ${station.status == 1 ? '启用' : '停用'}
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <th>创建时间</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty station.createTime}">
                                            ${station.createTime}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">未记录</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <th>更新时间</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty station.updateTime}">
                                            ${station.updateTime}
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">未记录</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </table>

                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/stations/${station.stationId}/edit"
                               class="btn btn-warning me-2">
                                <i class="fas fa-edit"></i> 编辑
                            </a>
                            <button onclick="deleteStation(${station.stationId})"
                                    class="btn btn-danger me-2">
                                <i class="fas fa-trash"></i> 删除
                            </button>
                            <a href="${pageContext.request.contextPath}/stations" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> 返回列表
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-danger">
                            <c:choose>
                                <c:when test="${not empty error}">
                                    无法加载网点信息：${error}
                                </c:when>
                                <c:otherwise>
                                    无法加载网点信息：数据为空或网点不存在
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <a href="${pageContext.request.contextPath}/stations" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> 返回列表
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <!-- 快速操作 -->
        <div class="card mb-3">
            <div class="card-header">
                <h6 class="mb-0">快速操作</h6>
            </div>
            <div class="card-body">
                <c:if test="${not empty station}">
                    <div class="d-grid gap-1">
                        <c:choose>
                            <c:when test="${station.status == 1}">
                                <button onclick="updateStatus(${station.stationId}, 0)"
                                        class="btn btn-warning">
                                    <i class="fas fa-pause"></i> 停用网点
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button onclick="updateStatus(${station.stationId}, 1)"
                                        class="btn btn-success">
                                    <i class="fas fa-play"></i> 启用网点
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- 统计信息 -->
        <div class="card">
            <div class="card-header">
                <h6 class="mb-0">统计信息</h6>
            </div>
            <div class="card-body">
                <div id="stationStats" class="text-center">
                    <c:if test="${not empty station}">
                        <div class="spinner-border spinner-border-sm text-primary" role="status">
                            <span class="visually-hidden">加载中...</span>
                        </div>
                        加载统计信息...
                    </c:if>
                    <c:if test="${empty station}">
                        <div class="text-center text-muted">
                            <i class="fas fa-exclamation-circle mb-2"></i>
                            <p>无数据</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // 加载统计信息
        <c:if test="${not empty station}">
        loadStationStats(${station.stationId});
        </c:if>
    });

    function loadStationStats(stationId) {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/stations/' + stationId + '/detail-stats',
            type: 'GET',
            success: function(response) {
                if (response.code === 200) {
                    const stats = response.data;

                    // 安全获取值
                    const vehicleCount = stats.vehicleCount != null ? stats.vehicleCount : 0;
                    const employeeCount = stats.employeeCount != null ? stats.employeeCount : 0;
                    const orderCount = stats.orderCount != null ? stats.orderCount : 0;
                    const todayOrders = stats.todayOrders != null ? stats.todayOrders : 0;
                    const activeVehicleCount = stats.activeVehicleCount != null ? stats.activeVehicleCount : 0;

                    let html = '<div class="row text-center">';

                    // 车辆统计
                    html += '<div class="col-6 mb-3">';
                    html += '<div class="h4 text-primary">' + vehicleCount + '</div>';
                    html += '<div class="text-muted small">车辆总数</div>';
                    if (activeVehicleCount > 0) {
                        html += '<div class="text-success small">可用: ' + activeVehicleCount + '</div>';
                    }
                    html += '</div>';

                    // 员工统计
                    html += '<div class="col-6 mb-3">';
                    html += '<div class="h4 text-success">' + employeeCount + '</div>';
                    html += '<div class="text-muted small">员工数量</div>';
                    html += '</div>';

                    // 订单统计
                    html += '<div class="col-6">';
                    html += '<div class="h4 text-warning">' + orderCount + '</div>';
                    html += '<div class="text-muted small">相关订单</div>';
                    html += '</div>';

                    // 今日订单
                    html += '<div class="col-6">';
                    html += '<div class="h4 text-info">' + todayOrders + '</div>';
                    html += '<div class="text-muted small">今日订单</div>';
                    html += '</div>';

                    html += '</div>';

                    $('#stationStats').html(html);
                } else {
                    showEmptyStats();
                }
            },
            error: function() {
                showEmptyStats();
            }
        });
    }

    function showEmptyStats(message) {
        const msg = message || '暂时无法获取统计信息';
        $('#stationStats').html(`
        <div class="text-center text-muted py-4">
            <i class="fas fa-chart-line fa-2x mb-3"></i>
            <p class="mb-1">${msg}</p>
            <small>统计功能正在完善中</small>
        </div>
    `);
    }

    // 删除网点
    function deleteStation(stationId) {
        Utils.confirm('确定要删除这个网点吗？<br><small class="text-muted">删除后数据将无法恢复</small>', function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/stations/' + stationId,
                type: 'DELETE',
                success: function(response) {
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/stations?success=' +
                                encodeURIComponent(response.message || '删除成功');
                        }, 1000);
                    } else {
                        Utils.showError(response.message || '删除失败');
                    }
                },
                error: function(xhr) {
                    Utils.showError('删除失败: ' + (xhr.responseJSON?.message || xhr.statusText));
                }
            });
        });
    }

    // 更新状态
    function updateStatus(stationId, status) {
        const action = status === 1 ? '启用' : '停用';
        Utils.confirm('确定要' + action + '这个网点吗？', function() {
            const data = {
                stationId: stationId,
                status: status
            };

            $.ajax({
                url: '${pageContext.request.contextPath}/api/stations/' + stationId,
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function(response) {
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || action + '成功');
                        setTimeout(() => {
                            window.location.reload();
                        }, 1000);
                    } else {
                        Utils.showError(response.message || action + '失败');
                    }
                },
                error: function(xhr) {
                    Utils.showError('操作失败: ' + (xhr.responseJSON?.message || xhr.statusText));
                }
            });
        });
    }
</script>

<style>
    .table th {
        background-color: #f8f9fa;
        font-weight: 600;
    }
    .table td {
        vertical-align: middle;
    }
</style>