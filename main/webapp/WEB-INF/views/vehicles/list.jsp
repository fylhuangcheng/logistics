<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">
            车辆列表
            <c:if test="${isDriverView}">
                <small class="text-muted">（我驾驶的车辆）</small>
            </c:if>
        </h5>
        <div>
            <!-- 根据用户类型显示不同按钮 -->
            <c:choose>
                <c:when test="${currentUserType == 1}">
                    <!-- 管理员：显示搜索和新增按钮 -->
                    <button class="btn btn-primary btn-sm me-2" data-bs-toggle="modal" data-bs-target="#searchModal">
                        <i class="fas fa-search"></i> 搜索
                    </button>
                    <a href="${pageContext.request.contextPath}/vehicles/add" class="btn btn-success btn-sm">
                        <i class="fas fa-plus"></i> 新增车辆
                    </a>
                </c:when>
                <c:when test="${currentUserType == 2}">
                    <!-- 司机：只显示刷新按钮 -->
                    <button class="btn btn-secondary btn-sm" onclick="window.location.reload()">
                        <i class="fas fa-sync-alt"></i> 刷新
                    </button>
                </c:when>
                <c:otherwise>
                    <!-- 其他用户：无操作按钮 -->
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="card-body">

        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show">
                操作成功！
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty result and result.code == 200 and not empty result.data.list}">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>车牌号</th>
                        <th>车辆类型</th>
                        <th>载重量(吨)</th>
                        <th>驾驶员</th>
                        <th>联系电话</th>
                        <th>当前位置</th>
                        <th>状态</th>
                        <c:if test="${currentUserType == 1}">
                            <!-- 管理员才显示操作列 -->
                            <th>操作</th>
                        </c:if>
                        <c:if test="${currentUserType == 2}">
                            <!-- 司机只显示查看按钮 -->
                            <th>操作</th>
                        </c:if>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${result.data.list}" var="vehicle">
                        <tr>
                            <td><strong>${vehicle.licensePlate}</strong></td>
                            <td>${vehicle.vehicleType}</td>
                            <td>${vehicle.loadCapacity}</td>
                            <td>${vehicle.driverName}</td>
                            <td>${vehicle.driverPhone}</td>
                            <td>
                                <c:if test="${not empty vehicle.currentStation}">
                                    ${vehicle.currentStation.stationName}
                                </c:if>
                                <c:if test="${empty vehicle.currentStation}">
                                    <span class="text-muted">未设置</span>
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${vehicle.status == 1}">
                                        <span class="badge bg-success">空闲</span>
                                    </c:when>
                                    <c:when test="${vehicle.status == 2}">
                                        <span class="badge bg-warning">运输中</span>
                                    </c:when>
                                    <c:when test="${vehicle.status == 3}">
                                        <span class="badge bg-danger">维修中</span>
                                    </c:when>
                                </c:choose>
                            </td>

                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <!-- 所有用户都能查看详情 -->
                                    <a href="${pageContext.request.contextPath}/vehicles/${vehicle.vehicleId}"
                                       class="btn btn-info" title="查看">
                                        <i class="fas fa-eye"></i>
                                    </a>

                                    <!-- 只有管理员能编辑和删除 -->
                                    <c:if test="${currentUserType == 1}">
                                        <a href="${pageContext.request.contextPath}/vehicles/${vehicle.vehicleId}/edit"
                                           class="btn btn-warning" title="编辑">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <button onclick="deleteVehicle(${vehicle.vehicleId})" class="btn btn-danger" title="删除">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- 搜索模态框 - 只有管理员能看到 -->
            <c:if test="${currentUserType == 1}">
                <div class="modal fade" id="searchModal" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">搜索车辆</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <!-- 简化搜索表单 -->
                                <form id="searchForm" action="${pageContext.request.contextPath}/vehicles" method="get">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label for="modalLicense" class="form-label">车牌号</label>
                                            <input type="text" class="form-control" id="modalLicense" name="licensePlate"
                                                   placeholder="请输入车牌号" value="${param.licensePlate}">
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label for="modalVehicleType" class="form-label">车辆类型</label>
                                            <select class="form-select" id="modalVehicleType" name="vehicleType">
                                                <option value="">所有类型</option>
                                                <option value="重型货车" ${param.vehicleType == '重型货车' ? 'selected' : ''}>重型货车</option>
                                                <option value="中型货车" ${param.vehicleType == '中型货车' ? 'selected' : ''}>中型货车</option>
                                                <option value="厢式货车" ${param.vehicleType == '厢式货车' ? 'selected' : ''}>厢式货车</option>
                                                <option value="冷藏车" ${param.vehicleType == '冷藏车' ? 'selected' : ''}>冷藏车</option>
                                            </select>
                                        </div>

                                        <div class="col-md-6 mb-3">
                                            <label for="modalStatus" class="form-label">状态</label>
                                            <select class="form-select" id="modalStatus" name="status">
                                                <option value="">所有状态</option>
                                                <option value="1" ${param.status == '1' ? 'selected' : ''}>空闲</option>
                                                <option value="2" ${param.status == '2' ? 'selected' : ''}>运输中</option>
                                                <option value="3" ${param.status == '3' ? 'selected' : ''}>维修中</option>
                                            </select>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                                <button type="button" class="btn btn-primary" onclick="submitVehicleSearch()">搜索</button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- 分页 -->
            <c:if test="${result.data.pages > 1}">
                <nav aria-label="分页导航">
                    <ul class="pagination justify-content-center">
                        <c:if test="${result.data.pageNum > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${result.data.pageNum - 1}">上一页</a>
                            </li>
                        </c:if>

                        <c:forEach begin="1" end="${result.data.pages}" var="page">
                            <li class="page-item ${page == result.data.pageNum ? 'active' : ''}">
                                <a class="page-link" href="?page=${page}">${page}</a>
                            </li>
                        </c:forEach>

                        <c:if test="${result.data.pageNum < result.data.pages}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${result.data.pageNum + 1}">下一页</a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </c:if>

        <c:if test="${empty result or result.code != 200 or empty result.data.list}">
            <div class="empty-state text-center py-5">
                <i class="fas fa-truck fa-3x text-muted mb-3"></i>
                <h4>
                    <c:choose>
                        <c:when test="${currentUserType == 2}">
                            暂无您驾驶的车辆
                        </c:when>
                        <c:when test="${currentUserType == 1}">
                            暂无车辆数据
                        </c:when>
                        <c:otherwise>
                            您没有查看车辆的权限
                        </c:otherwise>
                    </c:choose>
                </h4>
                <p class="text-muted">
                    <c:if test="${currentUserType == 1}">
                        点击"新增车辆"按钮添加第一辆车
                    </c:if>
                    <c:if test="${currentUserType == 2}">
                        请联系管理员为您分配车辆
                    </c:if>
                    <c:if test="${currentUserType == null or currentUserType == 0}">
                        请登录后查看
                    </c:if>
                </p>
            </div>
        </c:if>
    </div>
</div>

<script>
    // 删除车辆（只对管理员有效）
    function deleteVehicle(vehicleId) {
        // 添加权限检查
        <c:if test="${currentUserType != 1}">
        Utils.showError('您没有权限执行此操作');
        return;
        </c:if>

        Utils.confirm('确定要删除这辆车吗？<br><small class="text-muted">删除后将无法恢复</small>', function() {
            Utils.showLoading('正在删除...');

            $.ajax({
                url: '${pageContext.request.contextPath}/api/vehicles/' + vehicleId,
                type: 'DELETE',
                success: function(response) {
                    Utils.hideLoading();
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');
                        setTimeout(() => {
                            window.location.reload();
                        }, 1000);
                    } else {
                        Utils.showError(response.message || '删除失败');
                    }
                },
                error: function(xhr) {
                    Utils.hideLoading();
                    let errorMsg = '删除失败';
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        errorMsg = xhr.responseJSON.message;
                    }
                    Utils.showError(errorMsg);
                }
            });
        });
    }

    // 只有当用户是管理员时才加载Ajax搜索功能
    <c:if test="${currentUserType == 1}">
    function searchVehiclesAjax() {
        const searchData = {
            licensePlate: $('#modalLicense').val(),
            vehicleType: $('#modalVehicleType').val(),
            status: $('#modalStatus').val(),
            page: 1,
            size: 10
        };

        Utils.showLoading('正在搜索...');

        $.ajax({
            url: '${pageContext.request.contextPath}/api/vehicles/search',
            type: 'GET',
            data: searchData,
            success: function(response) {
                Utils.hideLoading();
                if (response.code === 200 && response.data) {
                    updateVehicleTable(response.data);
                    $('#searchModal').modal('hide');
                } else {
                    Utils.showError('搜索失败：' + (response.message || '未知错误'));
                }
            },
            error: function(xhr) {
                Utils.hideLoading();
                Utils.showError('搜索请求失败');
            }
        });
    }
    </c:if>

    // 提交搜索
    function submitVehicleSearch() {
        const form = document.getElementById('searchForm');
        if (form) {
            $('#searchModal').modal('hide');
            form.submit();
        }
    }
</script>