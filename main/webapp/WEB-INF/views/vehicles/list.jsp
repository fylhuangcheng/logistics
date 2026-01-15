<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">车辆列表</h5>
        <div>
            <button class="btn btn-primary btn-sm me-2" data-bs-toggle="modal" data-bs-target="#searchModal">
                <i class="fas fa-search"></i> 搜索
            </button>
            <a href="${pageContext.request.contextPath}/vehicles/add" class="btn btn-success btn-sm">
                <i class="fas fa-plus"></i> 新增车辆
            </a>
        </div>
    </div>

    <div class="card-body">
        <!-- 操作反馈 -->
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
                        <th>操作</th>
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
                                    <a href="${pageContext.request.contextPath}/vehicles/${vehicle.vehicleId}"
                                       class="btn btn-info" title="查看">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/vehicles/${vehicle.vehicleId}/edit"
                                       class="btn btn-warning" title="编辑">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button onclick="deleteVehicle(${vehicle.vehicleId})" class="btn btn-danger" title="删除">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- 搜索模态框 -->
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
            <div class="empty-state">
                <i class="fas fa-truck fa-3x text-muted mb-3"></i>
                <h4>暂无车辆数据</h4>
                <p class="text-muted">点击"新增车辆"按钮添加第一辆车</p>
            </div>
        </c:if>
    </div>
</div>


<script>
    let currentVehicleId = null;

    // 删除车辆（优化版）
    function deleteVehicle(vehicleId) {
        Utils.confirm('确定要删除这辆车吗？<br><small class="text-muted">删除后将无法恢复</small>', function() {
            Utils.showLoading('正在删除...');

            $.ajax({
                url: '${pageContext.request.contextPath}/api/vehicles/' + vehicleId,
                type: 'DELETE',
                success: function(response) {
                    Utils.hideLoading();
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');

                        // 方法1：直接刷新页面（最简单可靠）
                        setTimeout(() => {
                            window.location.reload();
                        }, 1000);

                        // 方法2：如果不想刷新整个页面，可以使用下面的Ajax重载
                        // reloadVehicleTable();

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

    // Ajax搜索车辆
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

    // 更新车辆表格
    function updateVehicleTable(vehicles) {
        const $tbody = $('table tbody');
        $tbody.empty();

        if (vehicles.length === 0) {
            $tbody.append(`
                <tr>
                    <td colspan="8" class="text-center py-4">
                        <i class="fas fa-truck fa-2x text-muted mb-2"></i>
                        <p>暂无数据</p>
                    </td>
                </tr>
            `);
            return;
        }

        vehicles.forEach(function(vehicle) {
            const statusBadge = getVehicleStatusBadge(vehicle.status);

            const row = `
                <tr>
                    <td><strong>${vehicle.licensePlate}</strong></td>
                    <td>${vehicle.vehicleType}</td>
                    <td>${vehicle.loadCapacity}</td>
                    <td>${vehicle.driverName || '-'}</td>
                    <td>${vehicle.driverPhone || '-'}</td>
                    <td>
                        ${vehicle.currentStation ? vehicle.currentStation.stationName : '-'}
                    </td>
                    <td>${statusBadge}</td>
                    <td>
                        <div class="btn-group btn-group-sm" role="group">
                            <a href="${pageContext.request.contextPath}/vehicles/${vehicle.vehicleId}"
                               class="btn btn-info" title="查看">
                                <i class="fas fa-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/vehicles/${vehicle.vehicleId}/edit"
                               class="btn btn-warning" title="编辑">
                                <i class="fas fa-edit"></i>
                            </a>
                            <button onclick="deleteVehicle(${vehicle.vehicleId})"
                                    class="btn btn-danger" title="删除">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            `;

            $tbody.append(row);
        });
    }

    function getVehicleStatusBadge(status) {
        const badges = {
            1: '<span class="badge bg-success">空闲</span>',
            2: '<span class="badge bg-warning">运输中</span>',
            3: '<span class="badge bg-danger">维修中</span>'
        };
        return badges[status] || '<span class="badge bg-secondary">未知</span>';
    }


    // 修改搜索提交函数
    function submitVehicleSearch() {
        console.log("提交车辆搜索");
        const form = document.getElementById('searchForm');
        if (form) {
            // searchVehiclesAjax(); // 使用Ajax搜索
            form.submit(); // 使用传统表单提交
        }
    }
</script>