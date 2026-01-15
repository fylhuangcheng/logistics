<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">订单列表</h5>
        <div>
            <button class="btn btn-primary btn-sm me-2" data-bs-toggle="modal" data-bs-target="#searchModal">
                <i class="fas fa-search"></i> 搜索
            </button>
            <a href="${pageContext.request.contextPath}/orders/add" class="btn btn-success btn-sm">
                <i class="fas fa-plus"></i> 新建订单
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

        <!-- 修改判断条件：检查 result.data.list -->
        <c:if test="${not empty result and result.code == 200 and not empty result.data.list}">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>订单号</th>
                        <th>寄件人</th>
                        <th>收件人</th>
                        <th>货物类型</th>
                        <th>重量(kg)</th>
                        <th>运费(¥)</th>
                        <th>状态</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${result.data.list}" var="order">
                        <tr>
                            <td>
                                <a href="${pageContext.request.contextPath}/orders/${order.orderId}">
                                    <strong>${order.orderNumber}</strong>
                                </a>
                            </td>
                            <td>
                                <div>${order.senderName}</div>
                                <small class="text-muted">${order.senderPhone}</small>
                            </td>
                            <td>
                                <div>${order.receiverName}</div>
                                <small class="text-muted">${order.receiverPhone}</small>
                            </td>
                            <td>${order.goodsType}</td>
                            <td>${order.weight}</td>
                            <td>
                                <strong class="text-primary">¥${order.freight}</strong>
                            </td>
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
                            <td>
                                <c:choose>
                                    <c:when test="${not empty order.createTime}">
                                        ${order.createTime}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <!-- 查看按钮 - 所有人都可以 -->
                                    <a href="${pageContext.request.contextPath}/orders/${order.orderId}"
                                       class="btn btn-info" title="查看">
                                        <i class="fas fa-eye"></i>
                                    </a>

                                    <!-- 编辑按钮 - 仅管理员和员工可见 -->
                                    <c:if test="${userType != 3}">
                                        <a href="${pageContext.request.contextPath}/orders/${order.orderId}/edit"
                                           class="btn btn-warning" title="编辑">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                    </c:if>

                                    <!-- 删除按钮 - 仅管理员和员工可见 -->
                                    <c:if test="${userType != 3}">
                                        <button onclick="deleteOrder(${order.orderId})" class="btn btn-danger" title="删除">
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
                <i class="fas fa-box-open fa-3x text-muted mb-3"></i>
                <h4>暂无订单数据</h4>
                <p class="text-muted">点击"新建订单"按钮创建第一个订单</p>
            </div>
        </c:if>
    </div>
</div>

<!-- 搜索模态框 -->
<div class="modal fade" id="searchModal" tabindex="-1" aria-labelledby="searchModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="searchModalLabel">高级搜索</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <!-- 使用GET方法，这样可以直接在URL中看到搜索参数 -->
                <form id="searchForm" action="${pageContext.request.contextPath}/orders" method="get">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="modalOrderNumber" class="form-label">订单号</label>
                            <input type="text" class="form-control" id="modalOrderNumber" name="orderNumber"
                                   placeholder="请输入订单号" value="${searchParams.orderNumber}">
                        </div>
                        <div class="col-md-6">
                            <label for="modalStatus" class="form-label">订单状态</label>
                            <select class="form-select" id="modalStatus" name="status">
                                <option value="">所有状态</option>
                                <option value="1" ${searchParams.status == 1 ? 'selected' : ''}>已下单</option>
                                <option value="2" ${searchParams.status == 2 ? 'selected' : ''}>已揽收</option>
                                <option value="3" ${searchParams.status == 3 ? 'selected' : ''}>运输中</option>
                                <option value="4" ${searchParams.status == 4 ? 'selected' : ''}>已到达</option>
                                <option value="5" ${searchParams.status == 5 ? 'selected' : ''}>已签收</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="modalSenderPhone" class="form-label">寄件人电话</label>
                            <input type="text" class="form-control" id="modalSenderPhone" name="senderPhone"
                                   placeholder="请输入寄件人电话" value="${searchParams.senderPhone}">
                        </div>
                        <div class="col-md-6">
                            <label for="modalReceiverPhone" class="form-label">收件人电话</label>
                            <input type="text" class="form-control" id="modalReceiverPhone" name="receiverPhone"
                                   placeholder="请输入收件人电话" value="${searchParams.receiverPhone}">
                        </div>

                        <div class="col-md-6">
                            <label for="modalStartStationId" class="form-label">始发网点</label>
                            <select class="form-select" id="modalStartStationId" name="startStationId">
                                <option value="">全部网点</option>
                                <c:forEach items="${stations}" var="station">
                                    <option value="${station.stationId}"
                                        ${searchParams.startStationId == station.stationId ? 'selected' : ''}>
                                            ${station.stationName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="modalEndStationId" class="form-label">目的网点</label>
                            <select class="form-select" id="modalEndStationId" name="endStationId">
                                <option value="">全部网点</option>
                                <c:forEach items="${stations}" var="station">
                                    <option value="${station.stationId}"
                                        ${searchParams.endStationId == station.stationId ? 'selected' : ''}>
                                            ${station.stationName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="modalStartTime" class="form-label">开始时间</label>
                            <input type="date" class="form-control" id="modalStartTime" name="startTime"
                                   value="${searchParams.startTime}">
                        </div>
                        <div class="col-md-6">
                            <label for="modalEndTime" class="form-label">结束时间</label>
                            <input type="date" class="form-control" id="modalEndTime" name="endTime"
                                   value="${searchParams.endTime}">
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
    // 修改 deleteOrder 函数
    function deleteOrder(orderId) {
        const userType = ${userType};

        if (userType === 3) {
            Utils.showError('对不起，客户用户无法删除订单');
            return;
        }

        Utils.confirm('确定要删除这个订单吗？<br><small class="text-muted">删除后将无法恢复</small>', function() {
            Utils.showLoading('正在删除...');

            $.ajax({
                url: '${pageContext.request.contextPath}/api/orders/' + orderId,
                type: 'DELETE',
                success: function(response) {
                    Utils.hideLoading();
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');

                        // 重新加载整个页面
                        setTimeout(() => {
                            window.location.reload();
                        }, 800);
                    } else {
                        Utils.showError(response.message || '删除失败');
                    }
                },
                error: function(xhr) {
                    Utils.hideLoading();

                    let errorMsg = '删除失败';
                    if (xhr.status === 403) {
                        errorMsg = '权限不足：客户用户无法删除订单';
                    } else if (xhr.responseJSON && xhr.responseJSON.message) {
                        errorMsg = xhr.responseJSON.message;
                    }

                    Utils.showError(errorMsg);
                }
            });
        });
    }


    // Ajax搜索功能
    function searchOrdersAjax() {
        const searchData = {
            orderNumber: $('#modalOrderNumber').val(),
            senderPhone: $('#modalSenderPhone').val(),
            receiverPhone: $('#modalReceiverPhone').val(),
            status: $('#modalStatus').val(),
            startStationId: $('#modalStartStationId').val(),
            endStationId: $('#modalEndStationId').val(),
            startTime: $('#modalStartTime').val(),
            endTime: $('#modalEndTime').val(),
            page: 1,
            size: 10
        };

        Utils.showLoading('正在搜索...');

        $.ajax({
            url: '${pageContext.request.contextPath}/api/orders/search',
            type: 'GET',
            data: searchData,
            success: function(response) {
                Utils.hideLoading();
                if (response.code === 200 && response.data) {
                    updateTableWithData(response.data);
                    // 关闭搜索模态框
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

    // 更新表格数据的函数
    function updateTableWithData(orders) {
        const $tbody = $('table tbody');
        $tbody.empty();

        if (orders.length === 0) {
            $tbody.append(`
                <tr>
                    <td colspan="9" class="text-center py-4">
                        <i class="fas fa-box-open fa-2x text-muted mb-2"></i>
                        <p>暂无数据</p>
                    </td>
                </tr>
            `);
            return;
        }

        orders.forEach(function(order) {
            const statusBadge = getStatusBadge(order.status);
            const userType = ${userType};
            const canEdit = userType !== 3;

            const row = `
                <tr>
                    <td>
                        <a href="${pageContext.request.contextPath}/orders/${order.orderId}" class="text-decoration-none">
                            <strong>${order.orderNumber}</strong>
                        </a>
                    </td>
                    <td>
                        <div>${order.senderName}</div>
                        <small class="text-muted">${order.senderPhone}</small>
                    </td>
                    <td>
                        <div>${order.receiverName}</div>
                        <small class="text-muted">${order.receiverPhone}</small>
                    </td>
                    <td>${order.goodsType}</td>
                    <td>${order.weight}</td>
                    <td><strong class="text-primary">¥${order.freight}</strong></td>
                    <td>${statusBadge}</td>
                    <td>
                        ${order.createTime ? order.createTime : '<span class="text-muted">-</span>'}
                    </td>
                    <td>
                        <div class="btn-group btn-group-sm" role="group">
                            <a href="${pageContext.request.contextPath}/orders/${order.orderId}"
                               class="btn btn-info" title="查看">
                                <i class="fas fa-eye"></i>
                            </a>
                            <c:if test="${canEdit}">
                                <a href="${pageContext.request.contextPath}/orders/${order.orderId}/edit"
                                    class="btn btn-warning" title="编辑">
                                  <i class="fas fa-edit"></i>
                                </a>
                                <button onclick="deleteOrder(${order.orderId})"
                                    class="btn btn-danger" title="删除">
                                <i class="fas fa-trash"></i>
                                </button>
                            </c:if>
                        </div>
                    </td>
                </tr>
            `;

            $tbody.append(row);
        });
    }

    function getStatusBadge(status) {
        const badges = {
            1: '<span class="badge bg-secondary">已下单</span>',
            2: '<span class="badge bg-info">已揽收</span>',
            3: '<span class="badge bg-warning">运输中</span>',
            4: '<span class="badge bg-success">已到达</span>',
            5: '<span class="badge bg-primary">已签收</span>'
        };
        return badges[status] || '<span class="badge bg-secondary">未知</span>';
    }


    // 更新分页
    function updatePagination(pageData) {
        const $pagination = $('.pagination');
        if (pageData.pages <= 1) {
            $pagination.hide();
            return;
        }

        $pagination.show();
        // 重新生成分页HTML...
    }

    // 修改提交搜索函数
    function submitSearch() {
        console.log("提交搜索");
        const form = document.getElementById('searchForm');
        if (form) {
            // 可以选择使用Ajax搜索或传统表单提交
            // searchOrdersAjax(); // 使用Ajax
            form.submit(); // 使用传统表单提交（保持当前行为）
        }
    }
</script>

