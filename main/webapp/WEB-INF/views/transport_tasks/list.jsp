<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">
            运输任务列表
            <c:if test="${isDriverView}">
                <small class="text-muted">（我的任务）</small>
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
                    <a href="${pageContext.request.contextPath}/transport_tasks/add" class="btn btn-success btn-sm">
                        <i class="fas fa-plus"></i> 新增任务
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
                        <th>任务编号</th>
                        <th>任务类型</th>
                        <th>始发网点</th>
                        <th>目的网点</th>
                        <th>分配车辆</th>
                        <th>计划时间</th>
                        <th>状态</th>
                        <c:if test="${currentUserType == 1}">
                            <th>分配司机</th>
                            <th>操作</th>
                        </c:if>
                        <c:if test="${currentUserType == 2}">
                            <th>操作</th>
                        </c:if>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${result.data.list}" var="task">
                        <tr>
                            <td>
                                <a href="${pageContext.request.contextPath}/transport_tasks/${task.taskId}">
                                    <strong>${task.taskNumber}</strong>
                                </a>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${task.taskType == 1}">
                                        <span class="badge bg-secondary">普通运输</span>
                                    </c:when>
                                    <c:when test="${task.taskType == 2}">
                                        <span class="badge bg-primary">加急运输</span>
                                    </c:when>
                                    <c:when test="${task.taskType == 3}">
                                        <span class="badge bg-info">冷链运输</span>
                                    </c:when>
                                    <c:when test="${task.taskType == 4}">
                                        <span class="badge bg-warning">危险品运输</span>
                                    </c:when>
                                    <c:when test="${task.taskType == 5}">
                                        <span class="badge bg-danger">特殊货物运输</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">未知</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${not empty task.startStation}">
                                    ${task.startStation.stationName}
                                </c:if>
                                <c:if test="${empty task.startStation}">
                                    <span class="text-muted">未设置</span>
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${not empty task.endStation}">
                                    ${task.endStation.stationName}
                                </c:if>
                                <c:if test="${empty task.endStation}">
                                    <span class="text-muted">未设置</span>
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${not empty task.vehicle}">
                                    ${task.vehicle.licensePlate}
                                </c:if>
                                <c:if test="${empty task.vehicle}">
                                    <span class="text-muted">未分配</span>
                                </c:if>
                            </td>
                            <td>
                                <div>${task.plannedDepartureTime}</div>
                                <small class="text-muted">至 ${task.plannedArrivalTime}</small>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${task.taskStatus == 1}">
                                        <span class="badge bg-secondary">待分配</span>
                                    </c:when>
                                    <c:when test="${task.taskStatus == 2}">
                                        <span class="badge bg-primary">已分配</span>
                                    </c:when>
                                    <c:when test="${task.taskStatus == 3}">
                                        <span class="badge bg-warning">运输中</span>
                                    </c:when>
                                    <c:when test="${task.taskStatus == 4}">
                                        <span class="badge bg-success">已完成</span>
                                    </c:when>
                                    <c:when test="${task.taskStatus == 5}">
                                        <span class="badge bg-danger">已取消</span>
                                    </c:when>
                                </c:choose>
                            </td>

                            <!-- 管理员视图显示司机信息 -->
                            <c:if test="${currentUserType == 1}">
                                <td>
                                    <c:if test="${not empty task.driver and not empty task.driver.user}">
                                        ${task.driver.user.realName}
                                    </c:if>
                                    <c:if test="${empty task.driver or empty task.driver.user}">
                                        <span class="text-muted">未分配</span>
                                    </c:if>
                                </td>
                            </c:if>

                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <!-- 所有用户都能查看详情 -->
                                    <a href="${pageContext.request.contextPath}/transport_tasks/${task.taskId}"
                                       class="btn btn-info" title="查看">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/transport_tasks/${task.taskId}/edit"
                                       class="btn btn-warning" title="编辑">
                                        <i class="fas fa-edit"></i>
                                    </a>

                                    <!-- 只有管理员能编辑和删除 -->
                                    <c:if test="${currentUserType == 1}">
                                        <button onclick="deleteTransportTask(${task.taskId})"
                                                class="btn btn-danger" title="删除">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </c:if>

                                    <!-- 司机只能查看，不能编辑删除 -->
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
                <i class="fas fa-truck-loading fa-3x text-muted mb-3"></i>
                <h4>
                    <c:choose>
                        <c:when test="${currentUserType == 2}">
                            暂无分配给您的任务
                        </c:when>
                        <c:otherwise>
                            暂无运输任务数据
                        </c:otherwise>
                    </c:choose>
                </h4>
                <p class="text-muted">
                    <c:if test="${currentUserType == 1}">
                        点击"新增任务"按钮添加第一个运输任务
                    </c:if>
                    <c:if test="${currentUserType == 2}">
                        请联系管理员为您分配任务
                    </c:if>
                </p>
            </div>
        </c:if>
    </div>
</div>

<!-- 搜索模态框 -->
<div class="modal fade" id="searchModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">运输任务搜索</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="searchForm" action="${pageContext.request.contextPath}/transport_tasks" method="get">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="modalTaskNumber" class="form-label">任务编号</label>
                            <input type="text" class="form-control" id="modalTaskNumber" name="taskNumber"
                                   placeholder="请输入任务编号" value="${searchParams.taskNumber}">
                        </div>
                        <div class="col-md-6">
                            <label for="modalTaskType" class="form-label">任务类型</label>
                            <select class="form-select" id="modalTaskType" name="taskType">
                                <option value="">所有类型</option>
                                <option value="1" ${searchParams.taskType == 1 ? 'selected' : ''}>普通运输</option>
                                <option value="2" ${searchParams.taskType == 2 ? 'selected' : ''}>加急运输</option>
                                <option value="3" ${searchParams.taskType == 3 ? 'selected' : ''}>冷链运输</option>
                                <option value="4" ${searchParams.taskType == 4 ? 'selected' : ''}>危险品运输</option>
                                <option value="5" ${searchParams.taskType == 5 ? 'selected' : ''}>特殊货物运输</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="modalTaskStatus" class="form-label">任务状态</label>
                            <select class="form-select" id="modalTaskStatus" name="taskStatus">
                                <option value="">所有状态</option>
                                <option value="1" ${searchParams.taskStatus == 1 ? 'selected' : ''}>待分配</option>
                                <option value="2" ${searchParams.taskStatus == 2 ? 'selected' : ''}>已分配</option>
                                <option value="3" ${searchParams.taskStatus == 3 ? 'selected' : ''}>运输中</option>
                                <option value="4" ${searchParams.taskStatus == 4 ? 'selected' : ''}>已完成</option>
                                <option value="5" ${searchParams.taskStatus == 5 ? 'selected' : ''}>已取消</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="modalTaskPriority" class="form-label">优先级</label>
                            <select class="form-select" id="modalTaskPriority" name="taskPriority">
                                <option value="">所有优先级</option>
                                <option value="1" ${searchParams.taskPriority == 1 ? 'selected' : ''}>高</option>
                                <option value="2" ${searchParams.taskPriority == 2 ? 'selected' : ''}>中</option>
                                <option value="3" ${searchParams.taskPriority == 3 ? 'selected' : ''}>低</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="modalStartStationId" class="form-label">始发网点</label>
                            <select class="form-select" id="modalStartStationId" name="startStationId">
                                <option value="">所有网点</option>
                                <c:if test="${not empty stations}">
                                    <c:forEach items="${stations}" var="station">
                                        <option value="${station.stationId}"
                                            ${searchParams.startStationId == station.stationId ? 'selected' : ''}>
                                                ${station.stationName}
                                        </option>
                                    </c:forEach>
                                </c:if>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="modalEndStationId" class="form-label">目的网点</label>
                            <select class="form-select" id="modalEndStationId" name="endStationId">
                                <option value="">所有网点</option>
                                <c:if test="${not empty stations}">
                                    <c:forEach items="${stations}" var="station">
                                        <option value="${station.stationId}"
                                            ${searchParams.endStationId == station.stationId ? 'selected' : ''}>
                                                ${station.stationName}
                                        </option>
                                    </c:forEach>
                                </c:if>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="modalPlannedDepartureTimeFrom" class="form-label">计划出发时间从</label>
                            <input type="date" class="form-control" id="modalPlannedDepartureTimeFrom" name="plannedDepartureTimeFrom"
                                   value="${searchParams.plannedDepartureTimeFrom}">
                        </div>
                        <div class="col-md-6">
                            <label for="modalPlannedDepartureTimeTo" class="form-label">计划出发时间至</label>
                            <input type="date" class="form-control" id="modalPlannedDepartureTimeTo" name="plannedDepartureTimeTo"
                                   value="${searchParams.plannedDepartureTimeTo}">
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
    // 删除运输任务
    function deleteTransportTask(taskId) {
        Utils.confirm('确定要删除这个运输任务吗？', function() {
            Utils.showLoading('正在删除...');

            $.ajax({
                url: '${pageContext.request.contextPath}/api/transport_tasks/' + taskId,
                type: 'DELETE',
                success: function(response) {
                    Utils.hideLoading();
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');
                        // 删除成功后刷新整个页面
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

    // Ajax加载运输任务列表
    function loadTransportTasksAjax() {
        const params = {
            page: ${not empty result.data.pageNum ? result.data.pageNum : 1},
            size: ${not empty result.data.pageSize ? result.data.pageSize : 10},
            taskNumber: '${searchParams.taskNumber}',
            taskStatus: '${searchParams.taskStatus}',
            taskType: '${searchParams.taskType}',
            taskPriority: '${searchParams.taskPriority}',
            startStationId: '${searchParams.startStationId}',
            endStationId: '${searchParams.endStationId}',
            plannedDepartureTimeFrom: '${searchParams.plannedDepartureTimeFrom}',
            plannedDepartureTimeTo: '${searchParams.plannedDepartureTimeTo}'
        };

        Utils.showLoading('正在加载...');

        $.ajax({
            url: '${pageContext.request.contextPath}/api/transport_tasks/search',
            type: 'GET',
            data: params,
            success: function(response) {
                Utils.hideLoading();
                if (response.code === 200 && response.data) {
                    updateTransportTaskTable(response.data.list);
                }
            },
            error: function() {
                Utils.hideLoading();
                Utils.showError('加载失败');
            }
        });
    }

    function updateTransportTaskTable(tasks) {
        const $tbody = $('table tbody');
        $tbody.empty();

        if (!tasks || tasks.length === 0) {
            $tbody.append(`
                <tr>
                    <td colspan="8" class="text-center py-4">
                        <i class="fas fa-truck-loading fa-2x text-muted mb-2"></i>
                        <p>暂无数据</p>
                    </td>
                </tr>
            `);
            return;
        }

        tasks.forEach(function(task) {
            const statusBadge = getTransportTaskStatusBadge(task.taskStatus);
            const typeBadge = getTransportTaskTypeBadge(task.taskType);

            const row = `
                <tr>
                    <td>
                        <a href="${pageContext.request.contextPath}/transport_tasks/${task.taskId}">
                            <strong>${task.taskNumber}</strong>
                        </a>
                    </td>
                    <td>${typeBadge}</td>
                    <td>
                        ${task.startStation ? task.startStation.stationName : '<span class="text-muted">未设置</span>'}
                    </td>
                    <td>
                        ${task.endStation ? task.endStation.stationName : '<span class="text-muted">未设置</span>'}
                    </td>
                    <td>
                        ${task.vehicle ? task.vehicle.licensePlate : '<span class="text-muted">未分配</span>'}
                    </td>
                    <td>
                        <div>${task.plannedDepartureTime}</div>
                        <small class="text-muted">至 ${task.plannedArrivalTime}</small>
                    </td>
                    <td>${statusBadge}</td>
                    <td>
                        <div class="btn-group btn-group-sm" role="group">
                            <a href="${pageContext.request.contextPath}/transport_tasks/${task.taskId}"
                               class="btn btn-info" title="查看">
                                <i class="fas fa-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/transport_tasks/${task.taskId}/edit"
                               class="btn btn-warning" title="编辑">
                                <i class="fas fa-edit"></i>
                            </a>
                            <button onclick="deleteTransportTask(${task.taskId})"
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

    function getTransportTaskStatusBadge(status) {
        const badges = {
            1: '<span class="badge bg-secondary">待分配</span>',
            2: '<span class="badge bg-primary">已分配</span>',
            3: '<span class="badge bg-warning">运输中</span>',
            4: '<span class="badge bg-success">已完成</span>',
            5: '<span class="badge bg-danger">已取消</span>'
        };
        return badges[status] || '<span class="badge bg-secondary">未知</span>';
    }

    function getTransportTaskTypeBadge(type) {
        const badges = {
            1: '<span class="badge bg-secondary">普通运输</span>',
            2: '<span class="badge bg-primary">加急运输</span>',
            3: '<span class="badge bg-info">冷链运输</span>',
            4: '<span class="badge bg-warning">危险品运输</span>',
            5: '<span class="badge bg-danger">特殊货物运输</span>'
        };
        return badges[type] || '<span class="badge bg-secondary">未知</span>';
    }

    // 提交搜索
    function submitSearch() {
        const form = document.getElementById('searchForm');
        if (form) {
            $('#searchModal').modal('hide');
            form.submit();
        }
    }

    // 快速操作函数
    function updateTaskStatus(taskId, status) {
        const statusMap = {
            2: '已分配',
            3: '运输中',
            4: '已完成',
            5: '已取消'
        };
        const statusText = statusMap[status] || '未知状态';

        Utils.confirm(`确定要将任务状态改为"${statusText}"吗？`, function() {
            Utils.showLoading('正在更新...');

            $.ajax({
                url: '${pageContext.request.contextPath}/api/transport_tasks/' + taskId + '/status',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify({ taskStatus: status }),
                success: function(response) {
                    Utils.hideLoading();
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '状态更新成功');
                        loadTransportTasksAjax();
                    } else {
                        Utils.showError(response.message || '状态更新失败');
                    }
                },
                error: function() {
                    Utils.hideLoading();
                    Utils.showError('状态更新失败');
                }
            });
        });
    }
</script>
