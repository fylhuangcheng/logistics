<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">网点列表</h5>
        <div>
            <button class="btn btn-primary btn-sm me-2" data-bs-toggle="modal" data-bs-target="#searchModal">
                <i class="fas fa-search"></i> 搜索
            </button>
            <a href="${pageContext.request.contextPath}/stations/add" class="btn btn-success btn-sm">
                <i class="fas fa-plus"></i> 新增网点
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
                        <th>网点编码</th>
                        <th>网点名称</th>
                        <th>地址</th>
                        <th>联系电话</th>
                        <th>状态</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${result.data.list}" var="station">
                        <tr>
                            <td><strong>${station.stationCode}</strong></td>
                            <td>${station.stationName}</td>
                            <td>${station.address}</td>
                            <td>${station.phone}</td>
                            <td>
                                <span class="badge ${station.status == 1 ? 'bg-success' : 'bg-danger'}">
                                        ${station.status == 1 ? '启用' : '停用'}
                                </span>
                            </td>
                            <td>${station.createTime}</td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <a href="${pageContext.request.contextPath}/stations/${station.stationId}"
                                       class="btn btn-info" title="查看">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/stations/${station.stationId}/edit"
                                       class="btn btn-warning" title="编辑">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button onclick="deleteStation(${station.stationId})" class="btn btn-danger" title="删除">
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
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">搜索网点</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <form id="searchForm" action="${pageContext.request.contextPath}/stations" method="get">
                                <div class="mb-3">
                                    <label for="modalStationCode" class="form-label">网点编码</label>
                                    <input type="text" class="form-control" id="modalStationCode" name="stationCode"
                                           placeholder="请输入网点编码" value="${param.stationCode}">
                                </div>
                                <div class="mb-3">
                                    <label for="modalStationName" class="form-label">网点名称</label>
                                    <input type="text" class="form-control" id="modalStationName" name="stationName"
                                           placeholder="请输入网点名称" value="${param.stationName}">
                                </div>
                                <div class="mb-3">
                                    <label for="modalStatus" class="form-label">状态</label>
                                    <select class="form-select" id="modalStatus" name="status">
                                        <option value="">所有状态</option>
                                        <option value="1" ${param.status == '1' ? 'selected' : ''}>启用</option>
                                        <option value="0" ${param.status == '0' ? 'selected' : ''}>停用</option>
                                    </select>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                            <button type="button" class="btn btn-primary" onclick="submitStationSearch()">搜索</button>
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
                <i class="fas fa-warehouse fa-3x text-muted mb-3"></i>
                <h4>暂无网点数据</h4>
                <p class="text-muted">点击"新增网点"按钮添加第一个网点</p>
            </div>
        </c:if>
    </div>
</div>

<script>
    function submitStationSearch() {
        const form = document.getElementById('searchForm');
        if (form) {
            const modalEl = document.getElementById('searchModal');
            const modal = bootstrap.Modal.getInstance(modalEl);
            if (modal) {
                modal.hide();
            }
            form.submit();
        }
    }

    function deleteStation(stationId) {
        Utils.confirm('确定要删除这个网点吗？<br><small class="text-muted">删除后将无法恢复</small>', function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/stations/' + stationId,
                type: 'DELETE',
                success: function(response) {
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
                    let errorMsg = '删除失败';
                    if (xhr.responseJSON && xhr.responseJSON.message) {
                        errorMsg = xhr.responseJSON.message;
                    } else if (xhr.statusText) {
                        errorMsg = xhr.statusText;
                    }
                    Utils.showError(errorMsg);
                }
            });
        });
    }
</script>