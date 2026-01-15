<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="row">
    <div class="col-12">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">车辆详情</h6>
                <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-sm btn-secondary">返回列表</a>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label class="form-label text-muted">车辆ID</label>
                    <input type="text" class="form-control" value="${vehicle.vehicleId}" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">车牌号</label>
                    <input type="text" class="form-control" value="${vehicle.licensePlate}" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">车辆类型</label>
                    <input type="text" class="form-control" value="${vehicle.vehicleType}" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">载重(吨)</label>
                    <input type="text" class="form-control" value="${vehicle.loadCapacity}" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">车辆状态</label>
                    <input type="text" class="form-control"
                           value="${vehicle.status == 1 ? '空闲' : vehicle.status == 2 ? '运输中' : '维修中'}"
                           readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">所属网点ID</label>
                    <input type="text" class="form-control"
                           value="${not empty vehicle.currentStationId ? vehicle.currentStationId : '未分配'}"
                           readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">驾驶员姓名</label>
                    <input type="text" class="form-control"
                           value="${not empty vehicle.driverName ? vehicle.driverName : '未分配'}"
                           readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">驾驶员电话</label>
                    <input type="text" class="form-control"
                           value="${not empty vehicle.driverPhone ? vehicle.driverPhone : '未填写'}"
                           readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">创建时间</label>
                    <input type="text" class="form-control"
                           value="${not empty vehicle.createTime ? vehicle.createTime : '未记录'}"
                           readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">更新时间</label>
                    <input type="text" class="form-control"
                           value="${not empty vehicle.updateTime ? vehicle.updateTime : '未记录'}"
                           readonly>
                </div>

                <!-- 显示网点详情（如果有关联的网点对象） -->
                <c:if test="${not empty vehicle.currentStation}">
                    <div class="card mt-3">
                        <div class="card-header">
                            <h6 class="mb-0">当前所在网点信息</h6>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <p><strong>网点名称：</strong>${vehicle.currentStation.stationName}</p>
                                    <p><strong>网点编码：</strong>${vehicle.currentStation.stationCode}</p>
                                </div>
                                <div class="col-md-6">
                                    <p><strong>地址：</strong>${vehicle.currentStation.address}</p>
                                    <p><strong>联系电话：</strong>${vehicle.currentStation.phone}</p>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/stations/${vehicle.currentStationId}"
                               class="btn btn-sm btn-outline-info mt-2">
                                查看网点详情
                            </a>
                        </div>
                    </div>
                </c:if>

                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/vehicles/${vehicle.vehicleId}/edit"
                       class="btn btn-sm btn-primary me-2">
                        <i class="fas fa-edit"></i> 编辑车辆
                    </a>
                    <button onclick="deleteVehicle(${vehicle.vehicleId})"
                            class="btn btn-sm btn-danger me-2">
                        <i class="fas fa-trash"></i> 删除车辆
                    </button>
                    <c:if test="${vehicle.status != 2}">
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // 删除车辆
    function deleteVehicle(vehicleId) {
        Utils.confirm('确定要删除这辆车吗？<br><small class="text-muted">删除后将无法恢复</small>', function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/vehicles/' + vehicleId,
                type: 'DELETE',
                success: function(response) {
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/vehicles?success=' +
                                encodeURIComponent(response.message || '删除成功');
                        }, 1000);
                    } else {
                        Utils.showError(response.message || '删除失败');
                    }
                },
                error: function(xhr) {
                    Utils.showError('请求失败: ' + xhr.statusText);
                }
            });
        });
    }

    // 分配任务
    function assignVehicle(vehicleId) {
        alert('分配车辆任务功能待实现，车辆ID: ' + vehicleId);
    }

    $(document).ready(function() {
        console.log('车辆详情页加载完成');

        // 安全地构建车辆信息对象
        var vehicleInfo = {
            id: ${not empty vehicle.vehicleId ? vehicle.vehicleId : 0},
            licensePlate: '${not empty vehicle.licensePlate ? vehicle.licensePlate : ""}',
            type: '${not empty vehicle.vehicleType ? vehicle.vehicleType : ""}',
            loadCapacity: ${not empty vehicle.loadCapacity ? vehicle.loadCapacity : 0},
            status: ${not empty vehicle.status ? vehicle.status : 1}
        };

        // 安全添加可选属性
        <c:if test="${not empty vehicle.currentStationId}">
        vehicleInfo.currentStationId = ${vehicle.currentStationId};
        </c:if>

        <c:if test="${not empty vehicle.driverName}">
        vehicleInfo.driverName = '${vehicle.driverName}';
        </c:if>

        <c:if test="${not empty vehicle.driverPhone}">
        vehicleInfo.driverPhone = '${vehicle.driverPhone}';
        </c:if>

        console.log('车辆信息:', vehicleInfo);
    });
</script>