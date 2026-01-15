<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="row">
    <div class="col-md-4">
        <!-- 个人信息卡片 -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">个人信息</h5>
            </div>
            <div class="card-body text-center">
                <!-- 头像 -->
                <div class="mb-3">
                    <img src="https://ui-avatars.com/api/?name=${user.realName}&background=0D8ABC&color=fff&size=128"
                         alt="头像" class="rounded-circle" style="width: 128px; height: 128px;">
                </div>

                <h4 class="mb-1">${user.realName}</h4>
                <p class="text-muted mb-2">${user.username}</p>

                <div class="mb-3">
                    <c:choose>
                        <c:when test="${user.userType == 1}">
                            <span class="badge bg-danger">管理员</span>
                        </c:when>
                        <c:when test="${user.userType == 2}">
                            <span class="badge bg-primary">司机</span>
                        </c:when>
                        <c:when test="${user.userType == 3}">
                            <span class="badge bg-success">用户</span>
                        </c:when>
                    </c:choose>
                    <span class="badge ${user.status == 1 ? 'bg-success' : 'bg-danger'} ms-2">
                        ${user.status == 1 ? '启用' : '禁用'}
                    </span>
                </div>

                <p class="text-muted mb-0">注册时间: ${user.createTime}</p>
            </div>
        </div>
    </div>

    <div class="col-md-8">
        <!-- 详细信息 -->
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">详细信息</h5>
            </div>
            <div class="card-body">
                <form id="profileForm" class="needs-validation" novalidate
                      action="${pageContext.request.contextPath}/users/profile"
                      method="post">

                    <input type="hidden" name="userId" value="${user.userId}">

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="realName" class="form-label required">真实姓名</label>
                            <input type="text" class="form-control" id="realName" name="realName"
                                   value="${user.realName}" required maxlength="50">
                            <div class="invalid-feedback">请输入真实姓名</div>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">用户名</label>
                            <input type="text" class="form-control" value="${user.username}" readonly>
                            <div class="form-text">用户名不可修改</div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="phone" class="form-label">联系电话</label>
                            <input type="tel" class="form-control" id="phone" name="phone"
                                   value="${user.phone}" maxlength="20">
                        </div>

                        <div class="col-md-6 mb-3">
                            <label for="email" class="form-label">邮箱</label>
                            <input type="email" class="form-control" id="email" name="email"
                                   value="${user.email}" maxlength="100">
                        </div>
                    </div>

                </form>
            </div>
        </div>


    </div>
</div>

<script>
    $(document).ready(function() {
        $('#profileForm').on('submit', function(e) {
            if (!Utils.validateForm(this)) {
                e.preventDefault();
                return;
            }
            Utils.showLoading();
        });
    });
</script>