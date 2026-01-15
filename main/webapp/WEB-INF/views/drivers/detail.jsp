<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="row">
    <div class="col-12">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">司机详情</h6>
                <a href="${pageContext.request.contextPath}/drivers" class="btn btn-sm btn-secondary">返回列表</a>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty driver}">
                        <div class="row mb-4">
                            <div class="col-md-8">
                                <h4>
                                    <c:if test="${not empty driver.user and not empty driver.user.realName}">
                                        ${driver.user.realName}
                                    </c:if>
                                    <c:if test="${empty driver.user or empty driver.user.realName}">
                                        司机 ${driver.driverId}
                                    </c:if>
                                </h4>
                                <p class="text-muted mb-0">驾照号: ${driver.licenseNumber}</p>
                            </div>
                            <div class="col-md-4 text-end">
                                <c:choose>
                                    <c:when test="${driver.currentStatus == 1}">
                                        <span class="badge bg-success">空闲</span>
                                    </c:when>
                                    <c:when test="${driver.currentStatus == 2}">
                                        <span class="badge bg-warning">运输中</span>
                                    </c:when>
                                    <c:when test="${driver.currentStatus == 3}">
                                        <span class="badge bg-danger">休假</span>
                                    </c:when>
                                    <c:when test="${driver.currentStatus == 4}">
                                        <span class="badge bg-secondary">离职</span>
                                    </c:when>
                                </c:choose>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h6 class="mb-0">基本信息</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label class="form-label text-muted">司机ID</label>
                                            <input type="text" class="form-control" value="${driver.driverId}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">姓名</label>
                                            <input type="text" class="form-control"
                                                   value="${not empty driver.user ? driver.user.realName : '未关联用户'}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">驾照号</label>
                                            <input type="text" class="form-control" value="${driver.licenseNumber}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">驾照类型</label>
                                            <input type="text" class="form-control" value="${driver.licenseType}" readonly>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h6 class="mb-0">工作信息</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label class="form-label text-muted">驾龄(年)</label>
                                            <input type="text" class="form-control"
                                                   value="${driver.yearsExperience != null ? driver.yearsExperience : '未填写'}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">总里程(km)</label>
                                            <input type="text" class="form-control"
                                            <c:choose>
                                            <c:when test="${driver.totalMileage != null}">
                                                   value="${driver.totalMileage} km"
                                            </c:when>
                                            <c:otherwise>
                                                   value="未记录"
                                            </c:otherwise>
                                            </c:choose>
                                                   readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">安全评分</label>
                                            <input type="text" class="form-control"
                                            <c:choose>
                                            <c:when test="${driver.safetyScore != null}">
                                                   value="${driver.safetyScore} 分"
                                            </c:when>
                                            <c:otherwise>
                                                   value="未评分"
                                            </c:otherwise>
                                            </c:choose>
                                                   readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">健康状况</label>
                                            <input type="text" class="form-control"
                                                   value="${driver.healthStatus != null ? driver.healthStatus : '未记录'}" readonly>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h6 class="mb-0">联系信息</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label class="form-label text-muted">联系电话</label>
                                            <input type="text" class="form-control"
                                                   value="${not empty driver.user ? driver.user.phone : '未关联用户'}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">紧急联系人</label>
                                            <input type="text" class="form-control"
                                                   value="${driver.emergencyContact != null ? driver.emergencyContact : '未填写'}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">紧急联系电话</label>
                                            <input type="text" class="form-control"
                                                   value="${driver.emergencyPhone != null ? driver.emergencyPhone : '未填写'}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">邮箱</label>
                                            <input type="text" class="form-control"
                                                   value="${not empty driver.user ? driver.user.email : '未关联用户'}" readonly>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card mb-4">
                                    <div class="card-header">
                                        <h6 class="mb-0">其他信息</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <label class="form-label text-muted">驾照到期日期</label>
                                            <input type="text" class="form-control"
                                                   value="${driver.licenseExpiryDate != null ? driver.licenseExpiryDate : '未填写'}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">上次休息时间</label>
                                            <input type="text" class="form-control"
                                                   value="${driver.lastRestTime != null ? driver.lastRestTime : '未记录'}" readonly>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">分配车辆</label>
                                            <div class="input-group">
                                                <input type="text" class="form-control"
                                                       value="${not empty driver.assignedVehicle ? driver.assignedVehicle.licensePlate : '未分配'}" readonly>
                                                <c:if test="${not empty driver.assignedVehicle}">
                                                    <a href="${pageContext.request.contextPath}/vehicles/${driver.assignedVehicleId}"
                                                       class="btn btn-outline-info" target="_blank">查看</a>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <label class="form-label text-muted">用户账号</label>
                                            <input type="text" class="form-control"
                                                   value="${not empty driver.user ? driver.user.username : '未关联用户'}" readonly>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">创建时间</label>
                                    <input type="text" class="form-control" value="${driver.createTime}" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label class="form-label text-muted">更新时间</label>
                                    <input type="text" class="form-control" value="${driver.updateTime}" readonly>
                                </div>
                            </div>
                        </div>

                        <!-- 关联用户信息 -->
                        <c:if test="${not empty driver.user}">
                            <div class="card mt-4">
                                <div class="card-header">
                                    <h6 class="mb-0">关联用户信息</h6>
                                </div>
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="mb-3">
                                                <label class="form-label text-muted">用户名</label>
                                                <input type="text" class="form-control" value="${driver.user.username}" readonly>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="mb-3">
                                                <label class="form-label text-muted">真实姓名</label>
                                                <input type="text" class="form-control" value="${driver.user.realName}" readonly>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="mb-3">
                                                <label class="form-label text-muted">角色</label>
                                                <input type="text" class="form-control" value="${driver.user.role}" readonly>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/drivers/${driver.driverId}/edit"
                               class="btn btn-sm btn-primary me-2">
                                <i class="fas fa-edit"></i> 编辑
                            </a>
                            <button onclick="deleteDriver(${driver.driverId})"
                                    class="btn btn-sm btn-danger me-2">
                                <i class="fas fa-trash"></i> 删除
                            </button>
                            <c:if test="${driver.currentStatus != 4}">
                                <button onclick="updateDriverStatus(${driver.driverId}, 4)"
                                        class="btn btn-sm btn-secondary me-2">
                                    设为离职
                                </button>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-danger">无法加载司机信息</div>
                        <a href="${pageContext.request.contextPath}/drivers" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> 返回列表
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
    // 删除司机
    function deleteDriver(driverId) {
        Utils.confirm('确定要删除这个司机吗？<br><small class="text-muted">删除后将无法恢复</small>', function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/drivers/' + driverId,
                type: 'DELETE',
                success: function(response) {
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/drivers?success=' +
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

    // 更新司机状态
    function updateDriverStatus(driverId, status) {
        const statusText = getDriverStatusText(status);
        Utils.confirm(`确定要将司机设为"${statusText}"吗？`, function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/drivers/' + driverId + '/status',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify({ currentStatus: status }),
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

    function getDriverStatusText(status) {
        const statusMap = {
            1: '空闲',
            2: '运输中',
            3: '休假',
            4: '离职'
        };
        return statusMap[status] || '未知';
    }

    $(document).ready(function() {
        console.log('司机详情页加载完成');
    });
</script>