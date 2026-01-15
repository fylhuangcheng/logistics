<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="row">
    <div class="col-md-8">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">订单详情</h5>
            </div>
            <div class="card-body">
                <!-- 直接使用 order 对象，而不是从 result 中获取 -->
                <c:choose>
                    <c:when test="${not empty order}">
                        <div class="row mb-4">
                            <div class="col-md-8">
                                <h4>订单号: ${order.orderNumber}</h4>
                            </div>
                            <div class="col-md-4 text-end">
                                <c:choose>
                                    <c:when test="${order.status == 1}">
                                        <span class="badge bg-secondary fs-6">已下单</span>
                                    </c:when>
                                    <c:when test="${order.status == 2}">
                                        <span class="badge bg-info fs-6">已揽收</span>
                                    </c:when>
                                    <c:when test="${order.status == 3}">
                                        <span class="badge bg-warning fs-6">运输中</span>
                                    </c:when>
                                    <c:when test="${order.status == 4}">
                                        <span class="badge bg-success fs-6">已到达</span>
                                    </c:when>
                                    <c:when test="${order.status == 5}">
                                        <span class="badge bg-primary fs-6">已签收</span>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>

                        <!-- 基本信息 -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header bg-light">
                                        <h6 class="mb-0">寄件人信息</h6>
                                    </div>
                                    <div class="card-body">
                                        <p class="mb-1"><strong>${order.senderName}</strong></p>
                                        <p class="mb-1"><i class="fas fa-phone me-2"></i>${order.senderPhone}</p>
                                        <p class="mb-0"><i class="fas fa-map-marker-alt me-2"></i>${order.senderAddress}</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header bg-light">
                                        <h6 class="mb-0">收件人信息</h6>
                                    </div>
                                    <div class="card-body">
                                        <p class="mb-1"><strong>${order.receiverName}</strong></p>
                                        <p class="mb-1"><i class="fas fa-phone me-2"></i>${order.receiverPhone}</p>
                                        <p class="mb-0"><i class="fas fa-map-marker-alt me-2"></i>${order.receiverAddress}</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 订单详情 -->
                        <div class="table-responsive mb-4">
                            <table class="table table-bordered">
                                <tr><th style="width: 20%">货物类型</th><td>${order.goodsType}</td></tr>
                                <tr><th>重量</th><td>${order.weight} kg</td></tr>
                                <tr><th>体积</th><td>${order.volume != null ? order.volume : '-'} m³</td></tr>
                                <tr><th>运费</th><td><strong class="text-primary">¥${order.freight}</strong></td></tr>
                                <tr><th>始发网点</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty order.startStation}">
                                                ${order.startStation.stationName}
                                            </c:when>
                                            <c:when test="${not empty order.startStationId}">
                                                网点ID: ${order.startStationId}
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr><th>当前网点</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty order.currentStation}">
                                                ${order.currentStation.stationName}
                                            </c:when>
                                            <c:when test="${not empty order.currentStationId}">
                                                网点ID: ${order.currentStationId}
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr><th>目的网点</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty order.endStation}">
                                                ${order.endStation.stationName}
                                            </c:when>
                                            <c:when test="${not empty order.endStationId}">
                                                网点ID: ${order.endStationId}
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr><th>分配车辆</th>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty order.vehicle}">
                                                ${order.vehicle.licensePlate} (${order.vehicle.vehicleType})
                                            </c:when>
                                            <c:otherwise>-</c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                                <tr><th>创建时间</th><td>${order.createTime}</td></tr>
                                <tr><th>更新时间</th><td>${order.updateTime}</td></tr>
                                <tr><th>预计到达</th><td>${order.expectedArrivalTime != null ? order.expectedArrivalTime : '-'}</td></tr>
                                <tr><th>实际到达</th><td>${order.actualArrivalTime != null ? order.actualArrivalTime : '-'}</td></tr>
                            </table>
                        </div>

                        <!-- 备注 -->
                        <c:if test="${not empty order.remark}">
                            <div class="card mb-4">
                                <div class="card-header bg-light">
                                    <h6 class="mb-0">备注</h6>
                                </div>
                                <div class="card-body">
                                    <p class="mb-0">${order.remark}</p>
                                </div>
                            </div>
                        </c:if>

                        <div class="d-grid gap-2 d-md-flex">
                            <a href="${pageContext.request.contextPath}/orders/${order.orderId}/edit"
                               class="btn btn-warning me-2">
                                <i class="fas fa-edit"></i> 编辑
                            </a>
                            <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary">
                                <i class="fas fa-arrow-left"></i> 返回列表
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-danger">
                            无法加载订单信息
                        </div>
                        <a href="${pageContext.request.contextPath}/orders" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> 返回列表
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <!-- 运输跟踪 -->
        <div class="card">
            <div class="card-header">
                <h6 class="mb-0">运输跟踪</h6>
            </div>
            <div class="card-body">
                <c:if test="${not empty order}">
                    <div class="timeline">
                        <div class="timeline-item ${order.status >= 1 ? 'completed' : ''} ${order.status == 1 ? 'current' : ''}">
                            <div class="timeline-content">
                                <div class="timeline-time">${order.createTime}</div>
                                <div class="timeline-title">订单已创建</div>
                                <div class="timeline-description">${order.createUser != null ? order.createUser.realName : '系统'}</div>
                            </div>
                        </div>

                        <div class="timeline-item ${order.status >= 2 ? 'completed' : ''} ${order.status == 2 ? 'current' : ''}">
                            <div class="timeline-content">
                                <div class="timeline-title">货物已揽收</div>
                                <div class="timeline-description">
                                    <c:if test="${not empty order.startStation}">
                                        在 ${order.startStation.stationName}
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <div class="timeline-item ${order.status >= 3 ? 'completed' : ''} ${order.status == 3 ? 'current' : ''}">
                            <div class="timeline-content">
                                <div class="timeline-title">运输中</div>
                                <div class="timeline-description">
                                    <c:if test="${not empty order.vehicle}">
                                        由 ${order.vehicle.licensePlate} 运输
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <div class="timeline-item ${order.status >= 4 ? 'completed' : ''} ${order.status == 4 ? 'current' : ''}">
                            <div class="timeline-content">
                                <div class="timeline-title">已到达</div>
                                <div class="timeline-description">
                                    <c:if test="${not empty order.endStation}">
                                        到达 ${order.endStation.stationName}
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <div class="timeline-item ${order.status == 5 ? 'completed' : ''}">
                            <div class="timeline-content">
                                <div class="timeline-title">已签收</div>
                                <div class="timeline-description">${order.receiverName}</div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<style>
    .timeline {
        position: relative;
        padding-left: 20px;
    }
    .timeline-item {
        position: relative;
        padding-bottom: 20px;
    }
    .timeline-item:before {
        content: '';
        position: absolute;
        left: -20px;
        top: 5px;
        width: 12px;
        height: 12px;
        border-radius: 50%;
        background-color: #dee2e6;
    }
    .timeline-item.completed:before {
        background-color: #28a745;
    }
    .timeline-item.current:before {
        background-color: #007bff;
    }
    .timeline-item:after {
        content: '';
        position: absolute;
        left: -15px;
        top: 5px;
        width: 2px;
        height: 100%;
        background-color: #dee2e6;
    }
    .timeline-item:last-child:after {
        display: none;
    }
    .timeline-content {
        padding-left: 10px;
    }
    .timeline-time {
        font-size: 0.875rem;
        color: #6c757d;
    }
    .timeline-title {
        font-weight: 600;
        margin-bottom: 5px;
    }
    .timeline-description {
        font-size: 0.875rem;
        color: #6c757d;
    }
</style>
