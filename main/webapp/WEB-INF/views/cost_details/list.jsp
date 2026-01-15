<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">费用列表</h5>
        <div>
            <button class="btn btn-primary btn-sm me-2" data-bs-toggle="modal" data-bs-target="#searchModal">
                <i class="fas fa-search"></i> 搜索
            </button>
            <a href="${pageContext.request.contextPath}/cost_details/add" class="btn btn-success btn-sm">
                <i class="fas fa-plus"></i> 新增费用
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
            <!-- 统计信息 -->
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>费用ID</th>
                        <th>订单号</th>
                        <th>费用类型</th>
                        <th>金额</th>
                        <th>状态</th>
                        <th>支付方式</th>
                        <th>费用时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${result.data.list}" var="cost">
                        <tr>
                            <td>${cost.costId}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/orders/${cost.orderId}">
                                        ${cost.order.orderNumber}
                                </a>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${cost.costType == 1}">运费</c:when>
                                    <c:when test="${cost.costType == 2}">包装费</c:when>
                                    <c:when test="${cost.costType == 3}">保险费</c:when>
                                    <c:when test="${cost.costType == 4}">仓储费</c:when>
                                    <c:when test="${cost.costType == 5}">装卸费</c:when>
                                    <c:when test="${cost.costType == 6}">其他</c:when>
                                    <c:otherwise>未知</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <strong class="${cost.paymentStatus == 2 ? 'text-success' : 'text-primary'}">
                                        ${cost.currency}${cost.amount}
                                </strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${cost.paymentStatus == 1}">
                                        <span class="badge bg-warning">未支付</span>
                                    </c:when>
                                    <c:when test="${cost.paymentStatus == 2}">
                                        <span class="badge bg-success">已支付</span>
                                    </c:when>
                                    <c:when test="${cost.paymentStatus == 3}">
                                        <span class="badge bg-danger">已取消</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>${cost.paymentMethod != null ? cost.paymentMethod : '-'}</td>
                            <td>${cost.costTime}</td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <a href="${pageContext.request.contextPath}/cost_details/${cost.costId}"
                                       class="btn btn-info" title="查看">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/cost_details/${cost.costId}/edit"
                                       class="btn btn-warning" title="编辑">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button onclick="deleteCostDetail(${cost.costId})"
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
                <i class="fas fa-money-bill-wave fa-3x text-muted mb-3"></i>
                <h4>暂无费用数据</h4>
                <p class="text-muted">点击"新增费用"按钮添加第一笔费用</p>
            </div>
        </c:if>
    </div>
</div>

<!-- 搜索模态框 -->
<div class="modal fade" id="searchModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">费用搜索</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="searchForm" action="${pageContext.request.contextPath}/cost_details" method="get">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="modalOrderId" class="form-label">订单ID</label>
                            <input type="number" class="form-control" id="modalOrderId" name="orderId"
                                   placeholder="请输入订单ID" value="${searchParams.orderId}" min="1">
                        </div>
                        <div class="col-md-6">
                            <label for="modalCostType" class="form-label">费用类型</label>
                            <select class="form-select" id="modalCostType" name="costType">
                                <option value="">所有类型</option>
                                <option value="1" ${searchParams.costType == '1' ? 'selected' : ''}>运费</option>
                                <option value="2" ${searchParams.costType == '2' ? 'selected' : ''}>包装费</option>
                                <option value="3" ${searchParams.costType == '3' ? 'selected' : ''}>保险费</option>
                                <option value="4" ${searchParams.costType == '4' ? 'selected' : ''}>仓储费</option>
                                <option value="5" ${searchParams.costType == '5' ? 'selected' : ''}>装卸费</option>
                                <option value="6" ${searchParams.costType == '6' ? 'selected' : ''}>其他</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="modalPaymentStatus" class="form-label">支付状态</label>
                            <select class="form-select" id="modalPaymentStatus" name="paymentStatus">
                                <option value="">所有状态</option>
                                <option value="1" ${searchParams.paymentStatus == 1 ? 'selected' : ''}>未支付</option>
                                <option value="2" ${searchParams.paymentStatus == 2 ? 'selected' : ''}>已支付</option>
                                <option value="3" ${searchParams.paymentStatus == 3 ? 'selected' : ''}>已取消</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="modalPaymentMethod" class="form-label">支付方式</label>
                            <select class="form-select" id="modalPaymentMethod" name="paymentMethod">
                                <option value="">所有方式</option>
                                <option value="现金" ${searchParams.paymentMethod == '现金' ? 'selected' : ''}>现金</option>
                                <option value="银行卡" ${searchParams.paymentMethod == '银行卡' ? 'selected' : ''}>银行卡</option>
                                <option value="在线支付" ${searchParams.paymentMethod == '在线支付' ? 'selected' : ''}>在线支付</option>
                                <option value="微信" ${searchParams.paymentMethod == '微信' ? 'selected' : ''}>微信</option>
                                <option value="支付宝" ${searchParams.paymentMethod == '支付宝' ? 'selected' : ''}>支付宝</option>
                            </select>
                        </div>

                        <div class="col-md-6">
                            <label for="modalMinAmount" class="form-label">最小金额</label>
                            <input type="number" class="form-control" id="modalMinAmount" name="minAmount"
                                   placeholder="最小金额" value="${searchParams.minAmount}" min="0" step="0.01">
                        </div>
                        <div class="col-md-6">
                            <label for="modalMaxAmount" class="form-label">最大金额</label>
                            <input type="number" class="form-control" id="modalMaxAmount" name="maxAmount"
                                   placeholder="最大金额" value="${searchParams.maxAmount}" min="0" step="0.01">
                        </div>

                        <div class="col-md-6">
                            <label for="modalCurrency" class="form-label">货币</label>
                            <select class="form-select" id="modalCurrency" name="currency">
                                <option value="">所有货币</option>
                                <option value="CNY" ${searchParams.currency == 'CNY' ? 'selected' : ''}>人民币</option>
                                <option value="USD" ${searchParams.currency == 'USD' ? 'selected' : ''}>美元</option>
                                <option value="EUR" ${searchParams.currency == 'EUR' ? 'selected' : ''}>欧元</option>
                                <option value="JPY" ${searchParams.currency == 'JPY' ? 'selected' : ''}>日元</option>
                            </select>
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
    // 删除费用
    // 删除费用
    function deleteCostDetail(costId) {
        Utils.confirm('确定要删除这个费用记录吗？<br><small class="text-muted">删除后将无法恢复</small>', function() {
            Utils.showLoading('正在删除...');

            $.ajax({
                url: '${pageContext.request.contextPath}/api/cost_details/' + costId,
                type: 'DELETE',
                success: function(response) {
                    Utils.hideLoading();
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');
                        // 延迟1秒后刷新页面
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


    function updateCostTable(costs) {
        const $tbody = $('table tbody');
        $tbody.empty();

        if (!costs || costs.length === 0) {
            $tbody.append(`
                <tr>
                    <td colspan="8" class="text-center py-4">
                        <i class="fas fa-money-bill-wave fa-2x text-muted mb-2"></i>
                        <p>暂无数据</p>
                    </td>
                </tr>
            `);
            return;
        }

        costs.forEach(function(cost) {
            const statusBadge = getPaymentStatusBadge(cost.paymentStatus);
            const textClass = cost.paymentStatus == 2 ? 'text-success' : 'text-primary';

            const row = `
                <tr>
                    <td>${cost.costId}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/orders/${cost.orderId}">
                            ${cost.order ? cost.order.orderNumber : cost.orderId}
                        </a>
                    </td>
                    <td>${cost.costType}</td>
                    <td><strong class="${textClass}">${cost.currency}${cost.amount}</strong></td>
                    <td>${statusBadge}</td>
                    <td>${cost.paymentMethod || '-'}</td>
                    <td>${cost.costTime}</td>
                    <td>
                        <div class="btn-group btn-group-sm" role="group">
                            <a href="${pageContext.request.contextPath}/cost_details/${cost.costId}"
                               class="btn btn-info" title="查看">
                                <i class="fas fa-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/cost_details/${cost.costId}/edit"
                               class="btn btn-warning" title="编辑">
                                <i class="fas fa-edit"></i>
                            </a>
                            <button onclick="deleteCostDetail(${cost.costId})"
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

    function getPaymentStatusBadge(status) {
        const badges = {
            1: '<span class="badge bg-warning">未支付</span>',
            2: '<span class="badge bg-success">已支付</span>',
            3: '<span class="badge bg-danger">已取消</span>'
        };
        return badges[status] || '<span class="badge bg-secondary">未知</span>';
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