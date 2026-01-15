<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">司机列表</h5>
        <div>
            <button class="btn btn-primary btn-sm me-2" data-bs-toggle="modal" data-bs-target="#searchModal">
                <i class="fas fa-search"></i> 搜索
            </button>
            <a href="${pageContext.request.contextPath}/drivers/add" class="btn btn-success btn-sm">
                <i class="fas fa-plus"></i> 新增司机
            </a>
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
                        <th>司机ID</th>
                        <th>姓名</th>
                        <th>驾照号</th>
                        <th>驾照类型</th>
                        <th>驾龄</th>
                        <th>健康状况</th>
                        <th>状态</th>
                        <th>分配车辆</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${result.data.list}" var="driver">
                        <tr>
                            <td>
                                <a href="${pageContext.request.contextPath}/drivers/${driver.driverId}">
                                    <strong>${driver.driverId}</strong>
                                </a>
                            </td>
                            <td>
                                <c:if test="${not empty driver.user}">
                                    ${driver.user.realName}
                                    <div><small class="text-muted">${driver.user.phone}</small></div>
                                </c:if>
                                <c:if test="${empty driver.user}">
                                    <span class="text-muted">未关联用户</span>
                                </c:if>
                            </td>
                            <td>${driver.licenseNumber}</td>
                            <td>${driver.licenseType}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty driver.yearsExperience}">
                                        ${driver.yearsExperience}年
                                    </c:when>
                                    <c:otherwise>
                                        -
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${driver.healthStatus == '良好'}">
                                        <span class="badge bg-success">良好</span>
                                    </c:when>
                                    <c:when test="${driver.healthStatus == '一般'}">
                                        <span class="badge bg-warning">一般</span>
                                    </c:when>
                                    <c:when test="${driver.healthStatus == '有病史'}">
                                        <span class="badge bg-danger">有病史</span>
                                    </c:when>
                                    <c:when test="${driver.healthStatus == '需关注'}">
                                        <span class="badge bg-info">需关注</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">未记录</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${driver.currentStatus == 1}">
                                        <span class="badge bg-success">空闲</span>
                                    </c:when>
                                    <c:when test="${driver.currentStatus == 2}">
                                        <span class="badge bg-warning">运输中</span>
                                    </c:when>
                                    <c:when test="${driver.currentStatus == 3}">
                                        <span class="badge bg-info">休假</span>
                                    </c:when>
                                    <c:when test="${driver.currentStatus == 4}">
                                        <span class="badge bg-secondary">离职</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${not empty driver.assignedVehicle}">
                                    ${driver.assignedVehicle.licensePlate}
                                </c:if>
                                <c:if test="${empty driver.assignedVehicle}">
                                    <span class="text-muted">未分配</span>
                                </c:if>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <a href="${pageContext.request.contextPath}/drivers/${driver.driverId}"
                                       class="btn btn-info" title="查看">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/drivers/${driver.driverId}/edit"
                                       class="btn btn-warning" title="编辑">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button onclick="deleteDriver(${driver.driverId})"
                                            class="btn btn-danger" title="删除">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
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

                        <c:forEach begin="1" end="${result.data.pages}" var="pageNum">
                            <li class="page-item ${pageNum == result.data.pageNum ? 'active' : ''}">
                                <a class="page-link" href="?page=${pageNum}">${pageNum}</a>
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
                <i class="fas fa-user-tie fa-3x text-muted mb-3"></i>
                <h4>暂无司机数据</h4>
                <p class="text-muted">点击"新增司机"按钮添加第一位司机</p>
            </div>
        </c:if>
    </div>
</div>

<!-- 搜索模态框 -->
<div class="modal fade" id="searchModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">司机搜索</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="searchForm" action="${pageContext.request.contextPath}/drivers" method="get">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="modalLicenseNumber" class="form-label">驾照号码</label>
                            <input type="text" class="form-control" id="modalLicenseNumber" name="licenseNumber"
                                   placeholder="请输入驾照号码" value="${searchParams.licenseNumber}">
                        </div>
                        <div class="col-md-6">
                            <label for="modalLicenseType" class="form-label">驾照类型</label>
                            <input type="text" class="form-control" id="modalLicenseType" name="licenseType"
                                   placeholder="请输入驾照类型" value="${searchParams.licenseType}">
                        </div>

                        <div class="col-md-6">
                            <label for="modalCurrentStatus" class="form-label">状态</label>
                            <select class="form-select" id="modalCurrentStatus" name="currentStatus">
                                <option value="">所有状态</option>
                                <option value="1" ${searchParams.currentStatus == 1 ? 'selected' : ''}>空闲</option>
                                <option value="2" ${searchParams.currentStatus == 2 ? 'selected' : ''}>运输中</option>
                                <option value="3" ${searchParams.currentStatus == 3 ? 'selected' : ''}>休假</option>
                                <option value="4" ${searchParams.currentStatus == 4 ? 'selected' : ''}>离职</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="modalHealthStatus" class="form-label">健康状况</label>
                            <select class="form-select" id="modalHealthStatus" name="healthStatus">
                                <option value="">所有状况</option>
                                <option value="良好" ${searchParams.healthStatus == '良好' ? 'selected' : ''}>良好</option>
                                <option value="一般" ${searchParams.healthStatus == '一般' ? 'selected' : ''}>一般</option>
                                <option value="有病史" ${searchParams.healthStatus == '有病史' ? 'selected' : ''}>有病史</option>
                                <option value="需关注" ${searchParams.healthStatus == '需关注' ? 'selected' : ''}>需关注</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="modalYearsExperienceMin" class="form-label">最小驾龄</label>
                            <input type="number" class="form-control" id="modalYearsExperienceMin" name="yearsExperienceMin"
                                   placeholder="最小驾龄" value="${searchParams.yearsExperienceMin}" min="0" max="50">
                        </div>
                        <div class="col-md-6">
                            <label for="modalYearsExperienceMax" class="form-label">最大驾龄</label>
                            <input type="number" class="form-control" id="modalYearsExperienceMax" name="yearsExperienceMax"
                                   placeholder="最大驾龄" value="${searchParams.yearsExperienceMax}" min="0" max="50">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" onclick="submitSearch()">搜索</button>
            </div>
        </div>
    </div>
</div>

<script>
    // 删除司机
    function deleteDriver(driverId) {
        Utils.confirm('确定要删除这个司机吗？<br><small class="text-muted">删除后将无法恢复</small>', function() {
            Utils.showLoading('正在删除...');

            $.ajax({
                url: '${pageContext.request.contextPath}/api/drivers/' + driverId,
                type: 'DELETE',
                success: function(response) {
                    Utils.hideLoading();
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');

                        // 方法1：延迟后直接刷新页面
                        setTimeout(function() {
                            location.reload();
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


    function updateDriverTable(drivers) {
        const $tbody = $('table tbody');
        $tbody.empty();

        if (!drivers || drivers.length === 0) {
            $tbody.append(`
                <tr>
                    <td colspan="9" class="text-center py-4">
                        <i class="fas fa-user-tie fa-2x text-muted mb-2"></i>
                        <p>暂无数据</p>
                    </td>
                </tr>
            `);
            return;
        }

        drivers.forEach(function(driver) {
            const statusBadge = getDriverStatusBadge(driver.currentStatus);
            const healthBadge = getHealthStatusBadge(driver.healthStatus);

            const row = `
                <tr>
                    <td>
                        <a href="${pageContext.request.contextPath}/drivers/${driver.driverId}">
                            <strong>${driver.driverId}</strong>
                        </a>
                    </td>
                    <td>
                        ${driver.user ? driver.user.realName : '<span class="text-muted">未关联用户</span>'}
                        ${driver.user && driver.user.phone ? '<div><small class="text-muted">' + driver.user.phone + '</small></div>' : ''}
                    </td>
                    <td>${driver.licenseNumber}</td>
                    <td>${driver.licenseType}</td>
                    <td>${driver.yearsExperience ? driver.yearsExperience + (driver.yearsExperience ? '年' : '') : '-'}</td>
                    <td>${healthBadge}</td>
                    <td>${statusBadge}</td>
                    <td>
                        ${driver.assignedVehicle ? driver.assignedVehicle.licensePlate : '<span class="text-muted">未分配</span>'}
                    </td>
                    <td>
                        <div class="btn-group btn-group-sm" role="group">
                            <a href="${pageContext.request.contextPath}/drivers/${driver.driverId}"
                               class="btn btn-info" title="查看">
                                <i class="fas fa-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/drivers/${driver.driverId}/edit"
                               class="btn btn-warning" title="编辑">
                                <i class="fas fa-edit"></i>
                            </a>
                            <button onclick="deleteDriver(${driver.driverId})"
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

    function getDriverStatusBadge(status) {
        const badges = {
            1: '<span class="badge bg-success">空闲</span>',
            2: '<span class="badge bg-warning">运输中</span>',
            3: '<span class="badge bg-info">休假</span>',
            4: '<span class="badge bg-secondary">离职</span>'
        };
        return badges[status] || '<span class="badge bg-secondary">未知</span>';
    }

    function getHealthStatusBadge(healthStatus) {
        if (!healthStatus) {
            return '<span class="text-muted">未记录</span>';
        }

        const badges = {
            '良好': '<span class="badge bg-success">良好</span>',
            '一般': '<span class="badge bg-warning">一般</span>',
            '有病史': '<span class="badge bg-danger">有病史</span>',
            '需关注': '<span class="badge bg-info">需关注</span>'
        };
        return badges[healthStatus] || `<span class="text-muted">${healthStatus}</span>`;
    }

    // 提交搜索
    function submitSearch() {
        const form = document.getElementById('searchForm');
        if (form) {
            $('#searchModal').modal('hide');
            form.submit();
        }
    }
</script>