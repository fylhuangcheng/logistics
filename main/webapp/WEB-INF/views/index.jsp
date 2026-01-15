<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="row">
    <!-- 统计卡片 -->
    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-primary shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                            网点数量</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${stationStats.total}</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-warehouse fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-success shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                            车辆数量</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${vehicleStats.total}</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-truck fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-info shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                            用户数量</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${userStats.total}</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-users fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-warning shadow h-100 py-2">
            <div class="card-body">
                <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                            订单数量</div>
                        <div class="h5 mb-0 font-weight-bold text-gray-800">${orderStats.total}</div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-shipping-fast fa-2x text-gray-300"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <!-- 最近订单 -->
    <div class="col-xl-8 col-lg-7">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">最近订单</h6>
                <a href="${pageContext.request.contextPath}/orders" class="btn btn-sm btn-primary">
                    查看全部
                </a>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <th>订单号</th>
                            <th>寄件人</th>
                            <th>收件人</th>
                            <th>状态</th>
                            <th>创建时间</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${recentOrders}" var="order">
                            <tr>
                                <td>
                                    <a href="${pageContext.request.contextPath}/orders/${order.orderId}">
                                            ${order.orderNumber}
                                    </a>
                                </td>
                                <td>${order.senderName}</td>
                                <td>${order.receiverName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${order.status == 1}">
                                            <span class="badge bg-secondary">已下单</span>
                                        </c:when>
                                        <c:when test="${order.status == 2}">
                                            <span class="badge bg-info">已揽收</span>
                                        </c:when>
                                        <c:when test="${order.status == 3}">
                                            <span class="badge bg-warning">运输中</span>
                                        </c:when>
                                        <c:when test="${order.status == 4}">
                                            <span class="badge bg-success">已到达</span>
                                        </c:when>
                                        <c:when test="${order.status == 5}">
                                            <span class="badge bg-primary">已签收</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>${order.createTime}</td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- 系统状态 -->
    <div class="col-xl-4 col-lg-5">
        <div class="card shadow mb-4">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">系统状态</h6>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <h6 class="small font-weight-bold">订单状态分布</h6>
                    <div class="mb-2">
                        <span class="small">已下单</span>
                        <div class="progress mb-2">
                            <div class="progress-bar bg-secondary" role="progressbar"
                                 style="width: ${(orderStats.pending / orderStats.total) * 100}%">
                                ${orderStats.pending}
                            </div>
                        </div>
                    </div>
                    <div class="mb-2">
                        <span class="small">运输中</span>
                        <div class="progress mb-2">
                            <div class="progress-bar bg-warning" role="progressbar"
                                 style="width: ${(orderStats.transporting / orderStats.total) * 100}%">
                                ${orderStats.transporting}
                            </div>
                        </div>
                    </div>
                    <div class="mb-2">
                        <span class="small">已签收</span>
                        <div class="progress mb-2">
                            <div class="progress-bar bg-success" role="progressbar"
                                 style="width: ${(orderStats.signed / orderStats.total) * 100}%">
                                ${orderStats.signed}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <h6 class="small font-weight-bold">车辆状态</h6>
                    <div class="d-flex justify-content-between">
                        <span class="small">空闲: ${vehicleStats.available}</span>
                        <span class="small">运输中: ${vehicleStats.busy}</span>
                        <span class="small">维修中: ${vehicleStats.maintenance}</span>
                    </div>
                </div>

                <div>
                    <h6 class="small font-weight-bold">用户类型</h6>
                    <div class="d-flex justify-content-between">
                        <span class="small">管理员: ${userStats.admin}</span>
                        <span class="small">客户: ${userStats.customer}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 快捷操作 -->
        <div class="card shadow">
            <div class="card-header py-3">
                <h6 class="m-0 font-weight-bold text-primary">快捷操作</h6>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-6 mb-3">
                        <a href="${pageContext.request.contextPath}/orders/add" class="btn btn-primary btn-block">
                            <i class="fas fa-plus-circle"></i> 新建订单
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/vehicles/add" class="btn btn-success btn-block">
                            <i class="fas fa-truck"></i> 新增车辆
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="${pageContext.request.contextPath}/stations/add" class="btn btn-warning btn-block">
                            <i class="fas fa-warehouse"></i> 新增网点
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


