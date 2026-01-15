<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">货物列表</h5>
        <div>
            <button class="btn btn-primary btn-sm me-2" data-bs-toggle="modal" data-bs-target="#searchModal">
                <i class="fas fa-search"></i> 搜索
            </button>
            <a href="${pageContext.request.contextPath}/cargo_items/add" class="btn btn-success btn-sm">
                <i class="fas fa-plus"></i> 新增货物
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
                        <th>货物ID</th>
                        <th>货物名称</th>
                        <th>所属订单</th>
                        <th>数量</th>
                        <th>重量(kg)</th>
                        <th>价值(¥)</th>
                        <th>状态</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${result.data.list}" var="cargo">
                        <tr>
                            <td>${cargo.cargoId}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/cargo_items/${cargo.cargoId}">
                                    <strong>${cargo.cargoName}</strong>
                                </a>
                                <br><small class="text-muted">${cargo.cargoType}</small>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/orders/${cargo.orderId}">
                                        ${cargo.orderNumber}
                                </a>
                            </td>
                            <td>${cargo.quantity} ${cargo.unit}</td>
                            <td>${cargo.totalWeight}</td>
                            <td>
                                <strong class="text-primary">¥${cargo.declaredValue}</strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${cargo.status == 1}">
                                        <span class="badge bg-success">正常</span>
                                    </c:when>
                                    <c:when test="${cargo.status == 2}">
                                        <span class="badge bg-warning">已破损</span>
                                    </c:when>
                                    <c:when test="${cargo.status == 3}">
                                        <span class="badge bg-danger">已丢失</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>${cargo.createTime}</td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <a href="${pageContext.request.contextPath}/cargo_items/${cargo.cargoId}"
                                       class="btn btn-info" title="查看">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/cargo_items/${cargo.cargoId}/edit"
                                       class="btn btn-warning" title="编辑">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button onclick="deleteCargoItem(${cargo.cargoId})"
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
                <i class="fas fa-box fa-3x text-muted mb-3"></i>
                <h4>暂无货物数据</h4>
                <p class="text-muted">点击"新增货物"按钮添加第一个货物</p>
            </div>
        </c:if>
    </div>
</div>

<!-- 搜索模态框 -->
<div class="modal fade" id="searchModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">高级搜索</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="searchForm" action="${pageContext.request.contextPath}/cargo_items" method="get">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="modalCargoName" class="form-label">货物名称</label>
                            <input type="text" class="form-control" id="modalCargoName" name="cargoName"
                                   placeholder="请输入货物名称" value="${searchParams.cargoName}">
                        </div>
                        <div class="col-md-6">
                            <label for="modalCargoType" class="form-label">货物类型</label>
                            <input type="text" class="form-control" id="modalCargoType" name="cargoType"
                                   placeholder="请输入货物类型" value="${searchParams.cargoType}">
                        </div>

                        <div class="col-md-6">
                            <label for="modalOrderId" class="form-label">订单ID</label>
                            <input type="number" class="form-control" id="modalOrderId" name="orderId"
                                   placeholder="请输入订单ID" value="${searchParams.orderId}">
                        </div>
                        <div class="col-md-6">
                            <label for="modalStatus" class="form-label">状态</label>
                            <select class="form-select" id="modalStatus" name="status">
                                <option value="">所有状态</option>
                                <option value="1" ${searchParams.status == 1 ? 'selected' : ''}>正常</option>
                                <option value="2" ${searchParams.status == 2 ? 'selected' : ''}>已破损</option>
                                <option value="3" ${searchParams.status == 3 ? 'selected' : ''}>已丢失</option>
                            </select>
                        </div>

                        <!-- 修改搜索表单 -->
                        <div class="col-md-6">
                            <label for="modalMinValue" class="form-label">最小价值</label>
                            <input type="number" class="form-control" id="modalMinValue" name="minDeclaredValue"
                                   placeholder="最小价值" value="${searchParams.minDeclaredValue}">
                        </div>
                        <div class="col-md-6">
                            <label for="modalMaxValue" class="form-label">最大价值</label>
                            <input type="number" class="form-control" id="modalMaxValue" name="maxDeclaredValue"
                                   placeholder="最大价值" value="${searchParams.maxDeclaredValue}">
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
    // 删除货物
    function deleteCargoItem(cargoId) {
        Utils.confirm('确定要删除这个货物吗？', function() {
            Utils.showLoading('正在删除...');

            $.ajax({
                url: '${pageContext.request.contextPath}/api/cargo_items/' + cargoId,
                type: 'DELETE',
                success: function(response) {
                    Utils.hideLoading();
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');

                        // 直接刷新整个页面
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


    function updateCargoTable(cargos) {
        const $tbody = $('table tbody');
        $tbody.empty();

        if (!cargos || cargos.length === 0) {
            $tbody.append(`
            <tr>
                <td colspan="9" class="text-center py-4">
                    <i class="fas fa-box fa-2x text-muted mb-2"></i>
                    <p>暂无数据</p>
                </td>
            </tr>
        `);
            return;
        }

        cargos.forEach(function(cargo) {
            const statusBadge = getCargoStatusBadge(cargo.status);

            const row = `
            <tr>
                <td>${cargo.cargoId}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/cargo_items/${cargo.cargoId}">
                        <strong>${cargo.cargoName}</strong>
                    </a>
                    <br><small class="text-muted">${cargo.cargoType}</small>
                </td>
                <td>
                    <a href="${pageContext.request.contextPath}/orders/${cargo.orderId}">
                        ${cargo.orderNumber}
                    </a>
                </td>
                <td>${cargo.quantity} ${cargo.unit}</td>
                <!-- 修改为 totalWeight -->
                <td>${cargo.totalWeight}</td>
                <!-- 修改为 declaredValue -->
                <td><strong class="text-primary">¥${cargo.declaredValue}</strong></td>
                <td>${statusBadge}</td>
                <td>${cargo.createTime}</td>
                <td>
                    <div class="btn-group btn-group-sm" role="group">
                        <a href="${pageContext.request.contextPath}/cargo_items/${cargo.cargoId}"
                           class="btn btn-info" title="查看">
                            <i class="fas fa-eye"></i>
                        </a>
                        <a href="${pageContext.request.contextPath}/cargo_items/${cargo.cargoId}/edit"
                           class="btn btn-warning" title="编辑">
                            <i class="fas fa-edit"></i>
                        </a>
                        <button onclick="deleteCargoItem(${cargo.cargoId})"
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

    function getCargoStatusBadge(status) {
        const badges = {
            1: '<span class="badge bg-success">正常</span>',
            2: '<span class="badge bg-warning">已破损</span>',
            3: '<span class="badge bg-danger">已丢失</span>'
        };
        return badges[status] || '<span class="badge bg-secondary">未知</span>';
    }

    // 提交搜索
    function submitSearch() {
        console.log("提交搜索");
        const form = document.getElementById('searchForm');
        if (form) {
            $('#searchModal').modal('hide');
            form.submit();
        }
    }
</script>
