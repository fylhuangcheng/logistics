<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="row">
    <div class="col-12">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">运输任务详情</h6>
                <a href="${pageContext.request.contextPath}/transport_tasks" class="btn btn-sm btn-secondary">返回列表</a>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty transportTask}">
                        <div class="row mb-4">
                            <div class="col-md-8">
                                <h4>任务编号: ${transportTask.taskNumber}</h4>
                                <p class="text-muted mb-0">${transportTask.taskNumber}</p>
                            </div>
                            <div class="col-md-4 text-end">
                                <c:choose>
                                    <c:when test="${transportTask.taskStatus == 1}">
                                        <span class="badge bg-secondary">待分配</span>
                                    </c:when>
                                    <c:when test="${transportTask.taskStatus == 2}">
                                        <span class="badge bg-primary">已分配</span>
                                    </c:when>
                                    <c:when test="${transportTask.taskStatus == 3}">
                                        <span class="badge bg-warning">运输中</span>
                                    </c:when>
                                    <c:when test="${transportTask.taskStatus == 4}">
                                        <span class="badge bg-success">已完成</span>
                                    </c:when>
                                    <c:when test="${transportTask.taskStatus == 5}">
                                        <span class="badge bg-danger">已取消</span>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h6 class="mb-0">任务信息</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label class="form-label text-muted">任务编号</label>
                                            <input type="text" class="form-control" value="${transportTask.taskNumber}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">任务类型</label>
                                            <input type="text" class="form-control" value="${transportTask.taskType}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">优先级</label>
                                            <input type="text" class="form-control"
                                                   value="${transportTask.taskPriority == 1 ? '高' : transportTask.taskPriority == 2 ? '中' : '低'}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">关联订单</label>
                                            <c:choose>
                                                <c:when test="${not empty relatedOrderInfos and relatedOrderInfos.size() > 0}">
                                                    <c:forEach items="${relatedOrderInfos}" var="orderInfo">
                                                        <div class="input-group mb-2">
                                                            <input type="text" class="form-control"
                                                                   value="${orderInfo.orderNumber}" readonly>
                                                            <a href="${pageContext.request.contextPath}/orders/${orderInfo.orderId}"
                                                               class="btn btn-outline-info"
                                                               target="_blank"
                                                               title="查看订单 ${orderInfo.orderNumber}">
                                                                查看
                                                            </a>
                                                        </div>
                                                    </c:forEach>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="input-group">
                                                        <input type="text" class="form-control" value="无" readonly>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h6 class="mb-0">路线信息</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label class="form-label text-muted">始发网点</label>
                                            <div class="input-group">
                                                <input type="text" class="form-control"
                                                       value="${not empty transportTask.startStation ? transportTask.startStation.stationName : '未设置'}" readonly>
                                                <c:if test="${not empty transportTask.startStation}">
                                                    <a href="${pageContext.request.contextPath}/stations/${transportTask.startStationId}"
                                                       class="btn btn-outline-info" target="_blank">查看</a>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">目的网点</label>
                                            <div class="input-group">
                                                <input type="text" class="form-control"
                                                       value="${not empty transportTask.endStation ? transportTask.endStation.stationName : '未设置'}" readonly>
                                                <c:if test="${not empty transportTask.endStation}">
                                                    <a href="${pageContext.request.contextPath}/stations/${transportTask.endStationId}"
                                                       class="btn btn-outline-info" target="_blank">查看</a>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">预计距离(km)</label>
                                            <input type="text" class="form-control"
                                                   value="${transportTask.estimatedDistance != null ? transportTask.estimatedDistance : '未设置'} km" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">预计时长(分钟)</label>
                                            <input type="text" class="form-control"
                                                   value="${transportTask.estimatedDurationMinutes != null ? transportTask.estimatedDurationMinutes : '未设置'} 分钟" readonly>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h6 class="mb-0">时间信息</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label class="form-label text-muted">计划出发时间</label>
                                            <input type="text" class="form-control"
                                                   value="<fmt:formatDate value="${transportTask.plannedDepartureTime}"
                                                        pattern="yyyy/MM/dd HH:mm" />" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">计划到达时间</label>
                                            <input type="text" class="form-control"
                                                   value="<fmt:formatDate value="${transportTask.plannedArrivalTime}"
                                                        pattern="yyyy/MM/dd HH:mm" />" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">实际出发时间</label>
                                            <input type="text" class="form-control"
                                                   value="${transportTask.actualDepartureTime != null ? transportTask.actualDepartureTime : '未出发'}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">实际到达时间</label>
                                            <input type="text" class="form-control"
                                                   value="${transportTask.actualArrivalTime != null ? transportTask.actualArrivalTime : '未到达'}" readonly>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h6 class="mb-0">资源分配</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label class="form-label text-muted">分配车辆</label>
                                            <div class="input-group">
                                                <input type="text" class="form-control"
                                                       value="${not empty transportTask.vehicle ? transportTask.vehicle.licensePlate : '未分配'}" readonly>
                                                <c:if test="${not empty transportTask.vehicle}">
                                                    <a href="${pageContext.request.contextPath}/vehicles/${transportTask.vehicleId}"
                                                       class="btn btn-outline-info" target="_blank">查看</a>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">分配司机</label>
                                            <div class="input-group">
                                                <input type="text" class="form-control"
                                                       value="${not empty transportTask.driver and not empty transportTask.driver.user ? transportTask.driver.user.realName : '未分配'}" readonly>
                                                <c:if test="${not empty transportTask.driver}">
                                                    <a href="${pageContext.request.contextPath}/drivers/${transportTask.driverId}"
                                                       class="btn btn-outline-info" target="_blank">查看</a>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">负责人</label>
                                            <div class="input-group">
                                                <input type="text" class="form-control"
                                                       value="${not empty transportTask.supervisor ? transportTask.supervisor.username : '未分配'}" readonly>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">实际距离(km)</label>
                                            <input type="text" class="form-control"
                                                   value="${transportTask.actualDistance != null ? transportTask.actualDistance : '未记录'} km" readonly>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h6 class="mb-0">运输信息</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label class="form-label text-muted">路线信息</label>
                                            <textarea class="form-control" rows="2" readonly>${transportTask.routeInfo != null ? transportTask.routeInfo : '无'}</textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">天气状况</label>
                                            <input type="text" class="form-control"
                                                   value="${transportTask.weatherConditions != null ? transportTask.weatherConditions : '未记录'}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">交通状况</label>
                                            <input type="text" class="form-control"
                                                   value="${transportTask.trafficConditions != null ? transportTask.trafficConditions : '未记录'}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">燃油消耗</label>
                                            <input type="text" class="form-control"
                                                   value="${transportTask.fuelConsumption != null ? transportTask.fuelConsumption : '未记录'} L" readonly>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h6 class="mb-0">任务记录</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label class="form-label text-muted">延误原因</label>
                                            <textarea class="form-control" rows="2" readonly>${transportTask.delayReason != null ? transportTask.delayReason : '无'}</textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">完成备注</label>
                                            <textarea class="form-control" rows="2" readonly>${transportTask.completionNotes != null ? transportTask.completionNotes : '无'}</textarea>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">创建时间</label>
                                            <input type="text" class="form-control" value="${transportTask.createTime}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">更新时间</label>
                                            <input type="text" class="form-control" value="${transportTask.updateTime}" readonly>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 关联订单 -->
                        <c:if test="${not empty relatedOrders}">
                            <div class="card mt-4">
                                <div class="card-header d-flex justify-content-between align-items-center">
                                    <h6 class="mb-0">关联订单</h6>
                                    <span class="badge bg-primary">${relatedOrders.size()} 个订单</span>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-sm">
                                            <thead>
                                            <tr>
                                                <th>订单号</th>
                                                <th>寄件人</th>
                                                <th>收件人</th>
                                                <th>货物类型</th>
                                                <th>重量(kg)</th>
                                                <th>状态</th>
                                                <th>操作</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            <c:forEach items="${relatedOrders}" var="order">
                                                <tr>
                                                    <td>${order.orderNumber}</td>
                                                    <td>${order.senderName}</td>
                                                    <td>${order.receiverName}</td>
                                                    <td>${order.goodsType}</td>
                                                    <td>${order.weight}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${order.status == 1}"><span class="badge bg-secondary">已下单</span></c:when>
                                                            <c:when test="${order.status == 2}"><span class="badge bg-info">已揽收</span></c:when>
                                                            <c:when test="${order.status == 3}"><span class="badge bg-warning">运输中</span></c:when>
                                                            <c:when test="${order.status == 4}"><span class="badge bg-success">已到达</span></c:when>
                                                            <c:when test="${order.status == 5}"><span class="badge bg-primary">已签收</span></c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/orders/${order.orderId}"
                                                           class="btn btn-sm btn-info">详情</a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/transport_tasks/${transportTask.taskId}/edit"
                               class="btn btn-sm btn-primary me-2">
                                <i class="fas fa-edit"></i> 编辑
                            </a>
                            <button onclick="deleteTransportTask(${transportTask.taskId})"
                                    class="btn btn-sm btn-danger me-2">
                                <i class="fas fa-trash"></i> 删除
                            </button>
                            <c:if test="${transportTask.taskStatus == 1}">
                                <button onclick="assignTask(${transportTask.taskId})"
                                        class="btn btn-sm btn-success me-2">
                                    分配任务
                                </button>
                            </c:if>
                            <c:if test="${transportTask.taskStatus == 3}">
                                <button onclick="completeTask(${transportTask.taskId})"
                                        class="btn btn-sm btn-success me-2">
                                    完成任务
                                </button>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-danger">无法加载运输任务信息</div>
                        <a href="${pageContext.request.contextPath}/transport_tasks" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> 返回列表
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
    // 删除运输任务
    function deleteTransportTask(taskId) {
        Utils.confirm('确定要删除这个运输任务吗？<br><small class="text-muted">删除后将无法恢复</small>', function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/transport_tasks/' + taskId,
                type: 'DELETE',
                success: function(response) {
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/transport_tasks?success=' +
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

    // 分配任务
    function assignTask(taskId) {
        window.location.href = '${pageContext.request.contextPath}/transport_tasks/' + taskId + '/assign';
    }

    // 完成任务
    function completeTask(taskId) {
        Utils.confirm('确定要标记这个任务为已完成吗？', function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/transport_tasks/' + taskId + '/complete',
                type: 'PUT',
                success: function(response) {
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '任务完成状态已更新');
                        setTimeout(() => {
                            window.location.reload();
                        }, 1000);
                    } else {
                        Utils.showError(response.message || '操作失败');
                    }
                },
                error: function(xhr) {
                    Utils.showError('操作失败');
                }
            });
        });
    }

    $(document).ready(function() {
        console.log('运输任务详情页加载完成');
    });
</script>