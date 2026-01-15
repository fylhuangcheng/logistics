<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center">
        <h5 class="mb-0">用户列表</h5>
        <div>
            <button class="btn btn-primary btn-sm me-2" data-bs-toggle="modal" data-bs-target="#searchModal">
                <i class="fas fa-search"></i> 搜索
            </button>
            <a href="${pageContext.request.contextPath}/users/add" class="btn btn-success btn-sm">
                <i class="fas fa-plus"></i> 新增用户
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
                        <th>用户名</th>
                        <th>真实姓名</th>
                        <th>用户类型</th>
                        <th>联系方式</th>
                        <th>状态</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${result.data.list}" var="user">
                        <tr>
                            <td><strong>${user.username}</strong></td>
                            <td>${user.realName}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.userType == 1}">
                                        <span class="badge bg-danger">管理员</span>
                                    </c:when>
                                    <c:when test="${user.userType == 2}">
                                        <span class="badge bg-primary">司机</span>
                                    </c:when>
                                    <c:when test="${user.userType == 3}">
                                        <span class="badge bg-success">客户</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>
                                <div>${user.phone}</div>
                                <small class="text-muted">${user.email}</small>
                            </td>
                            <td>
                                <span class="badge ${user.status == 1 ? 'bg-success' : 'bg-danger'}">
                                        ${user.status == 1 ? '启用' : '禁用'}
                                </span>
                            </td>
                            <td>${user.createTime}</td>
                            <td>
                                <div class="btn-group btn-group-sm" role="group">
                                    <a href="${pageContext.request.contextPath}/users/${user.userId}"
                                       class="btn btn-info" title="查看">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="${pageContext.request.contextPath}/users/${user.userId}/edit"
                                       class="btn btn-warning" title="编辑">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                    <button onclick="deleteUser(${user.userId})" class="btn btn-danger" title="删除">
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
                            <h5 class="modal-title">搜索用户</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <form id="searchForm" action="${pageContext.request.contextPath}/users" method="get">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="modalUsername" class="form-label">用户名</label>
                                        <input type="text" class="form-control" id="modalUsername" name="username"
                                               placeholder="请输入用户名" value="${param.username}">
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="modalRealName" class="form-label">真实姓名</label>
                                        <input type="text" class="form-control" id="modalRealName" name="realName"
                                               placeholder="请输入真实姓名" value="${param.realName}">
                                    </div>

                                    <div class="col-md-6 mb-3">
                                        <label for="modalUserType" class="form-label">用户类型</label>
                                        <select class="form-select" id="modalUserType" name="userType">
                                            <option value="">所有类型</option>
                                            <option value="1" ${param.userType == '1' ? 'selected' : ''}>管理员</option>
                                            <option value="2" ${param.userType == '2' ? 'selected' : ''}>司机</option>
                                            <option value="3" ${param.userType == '3' ? 'selected' : ''}>客户</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="modalStatus" class="form-label">状态</label>
                                        <select class="form-select" id="modalStatus" name="status">
                                            <option value="">所有状态</option>
                                            <option value="1" ${param.status == '1' ? 'selected' : ''}>启用</option>
                                            <option value="0" ${param.status == '0' ? 'selected' : ''}>禁用</option>
                                        </select>
                                    </div>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                            <button type="button" class="btn btn-primary" onclick="submitUserSearch()">搜索</button>
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
                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                <h4>暂无用户数据</h4>
                <p class="text-muted">点击"新增用户"按钮添加第一个用户</p>
            </div>
        </c:if>
    </div>
</div>

<script>
    function submitUserSearch() {
        console.log("提交用户搜索");
        const form = document.getElementById('searchForm');
        if (form) {
            // 关闭模态框
            const modalEl = document.getElementById('searchModal');
            const modal = bootstrap.Modal.getInstance(modalEl);
            if (modal) {
                modal.hide();
            }
            // 提交表单
            form.submit();
        }
    }

    function deleteUser(userId) {
        Utils.confirm('确定要删除这个用户吗？<br><small class="text-muted">删除后将无法恢复</small>', function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/users/' + userId,
                type: 'DELETE',
                success: function(response) {
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');
                        // 刷新当前页面
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