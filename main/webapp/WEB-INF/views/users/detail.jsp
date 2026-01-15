<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="row">
    <div class="col-md-8">
        <div class="card shadow mb-4">
            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                <h6 class="m-0 font-weight-bold text-primary">用户详情</h6>
                <a href="${pageContext.request.contextPath}/users" class="btn btn-sm btn-secondary">返回列表</a>
            </div>
            <div class="card-body">
                <div class="mb-3">
                    <label class="form-label text-muted">用户ID</label>
                    <input type="text" class="form-control" value="${user.userId}" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">用户名</label>
                    <input type="text" class="form-control" value="${user.username}" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">真实姓名</label>
                    <input type="text" class="form-control" value="${user.realName}" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">用户类型</label>
                    <input type="text" class="form-control"
                           value="${user.userType == 1 ? '管理员' : user.userType == 2 ? '司机' : '客户'}"
                           readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">状态</label>
                    <input type="text" class="form-control"
                           value="${user.status == 1 ? '启用' : '禁用'}"
                           readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">联系电话</label>
                    <input type="text" class="form-control"
                           value="${not empty user.phone ? user.phone : '未填写'}"
                           readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">邮箱</label>
                    <input type="text" class="form-control"
                           value="${not empty user.email ? user.email : '未填写'}"
                           readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">创建时间</label>
                    <input type="text" class="form-control"
                           value="${not empty user.createTime ? user.createTime : '未记录'}"
                           readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label text-muted">更新时间</label>
                    <input type="text" class="form-control"
                           value="${not empty user.updateTime ? user.updateTime : '未记录'}"
                           readonly>
                </div>

                <div class="mt-4">
                    <a href="${pageContext.request.contextPath}/users/${user.userId}/edit"
                       class="btn btn-sm btn-primary me-2">
                        <i class="fas fa-edit"></i> 编辑用户
                    </a>
                    <button onclick="deleteUser(${user.userId})"
                            class="btn btn-sm btn-danger me-2">
                        <i class="fas fa-trash"></i> 删除用户
                    </button>
                    <button onclick="toggleUserStatus(${user.userId}, ${user.status})"
                            class="btn btn-sm ${user.status == 1 ? 'btn-warning' : 'btn-success'}">
                        <i class="fas ${user.status == 1 ? 'fa-ban' : 'fa-check'}"></i>
                        ${user.status == 1 ? '禁用用户' : '启用用户'}
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- 侧边栏：快速操作和统计信息 -->
    <div class="col-md-4">
        <div class="card mb-3">
            <div class="card-header bg-light">
                <h6 class="mb-0">快速操作</h6>
            </div>
            <div class="card-body">
                <div class="d-grid gap-2">
                    <a href="${pageContext.request.contextPath}/users/${user.userId}/change-password"
                       class="btn btn-info">
                        <i class="fas fa-key"></i> 修改密码
                    </a>
                    <c:if test="${user.userType == 2 and not empty user.stationId}">
                        <a href="${pageContext.request.contextPath}/stations/${user.stationId}/employees"
                           class="btn btn-outline-primary">
                            <i class="fas fa-users"></i> 查看网点同事
                        </a>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- 统计信息 -->
        <div class="card">
            <div class="card-header bg-light">
                <h6 class="mb-0">统计信息</h6>
            </div>
            <div class="card-body">
                <div id="userStats" class="text-center">
                    <div class="spinner-border spinner-border-sm text-primary" role="status">
                        <span class="visually-hidden">加载中...</span>
                    </div>
                    加载统计信息...
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // 切换用户状态
    function toggleUserStatus(userId, currentStatus) {
        const newStatus = currentStatus == 1 ? 0 : 1;
        const action = newStatus == 1 ? '启用' : '禁用';

        Utils.confirm('确定要' + action + '这个用户吗？<br><small class="text-muted">' + action + '后用户将' + (newStatus == 1 ? '可以' : '无法') + '登录系统</small>', function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/users/' + userId + '/status',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify({ status: newStatus }),
                success: function(response) {
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || action + '成功');
                        setTimeout(() => {
                            window.location.reload();
                        }, 1000);
                    } else {
                        Utils.showError(response.message || action + '失败');
                    }
                },
                error: function(xhr) {
                    Utils.showError('操作失败: ' + (xhr.responseJSON?.message || xhr.statusText));
                }
            });
        });
    }

    // 删除用户
    function deleteUser(userId) {
        Utils.confirm('确定要删除这个用户吗？<br><small class="text-danger">删除后所有相关数据将无法恢复！</small>', function() {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/users/' + userId,
                type: 'DELETE',
                success: function(response) {
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');
                        setTimeout(() => {
                            window.location.href = '${pageContext.request.contextPath}/users?success=' +
                                encodeURIComponent(response.message || '删除成功');
                        }, 1000);
                    } else {
                        Utils.showError(response.message || '删除失败');
                    }
                },
                error: function(xhr) {
                    Utils.showError('删除失败: ' + (xhr.responseJSON?.message || xhr.statusText));
                }
            });
        });
    }

    $(document).ready(function() {
        console.log('用户详情页加载完成');

        // 安全地构建用户信息对象
        var userInfo = {
            id: ${not empty user.userId ? user.userId : 0},
            username: '${not empty user.username ? user.username : ""}',
            realName: '${not empty user.realName ? user.realName : ""}',
            userType: ${not empty user.userType ? user.userType : 3},
            status: ${not empty user.status ? user.status : 1}
        };

        // 安全添加可选属性
        <c:if test="${not empty user.phone}">
        userInfo.phone = '${user.phone}';
        </c:if>

        <c:if test="${not empty user.email}">
        userInfo.email = '${user.email}';
        </c:if>

        console.log('用户信息:', userInfo);

        // 加载用户统计
        loadUserStats();
    });

    function loadUserStats() {
        $.ajax({
            url: '${pageContext.request.contextPath}/api/users/stats',
            type: 'GET',
            success: function(response) {
                if (response.code === 200) {
                    const stats = response.data;
                    let html = `
                    <div class="row text-center">
                        <div class="col-6 mb-3">
                            <div class="h4 text-primary">\${stats.total || 0}</div>
                            <div class="text-muted small">总用户数</div>
                        </div>
                        <div class="col-6 mb-3">
                            <div class="h4 text-success">\${stats.active || 0}</div>
                            <div class="text-muted small">启用用户</div>
                        </div>
                        <div class="col-6">
                            <div class="h4 text-warning">\${stats.admin || 0}</div>
                            <div class="text-muted small">管理员</div>
                        </div>
                        <div class="col-6">
                            <div class="h4 text-info">\${stats.customer || 0}</div>
                            <div class="text-muted small">客户</div>
                        </div>
                    </div>
                `;
                    $('#userStats').html(html);
                } else {
                    showEmptyStats();
                }
            },
            error: function() {
                showEmptyStats();
            }
        });
    }

    function showEmptyStats() {
        $('#userStats').html(`
            <div class="text-center text-muted">
                <i class="fas fa-exclamation-circle mb-2 fa-2x"></i>
                <p class="mb-1">暂时无法获取统计信息</p>
            </div>
        `);
    }
</script>

<style>
    .table-borderless th {
        background-color: #f8f9fa;
        font-weight: 600;
    }
    .table-borderless td {
        vertical-align: middle;
    }
    .border-top {
        border-top: 1px solid #dee2e6 !important;
    }
</style>