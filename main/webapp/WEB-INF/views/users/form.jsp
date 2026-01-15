<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="card">
    <div class="card-header">
        <h5 class="mb-0">${empty user ? '新增用户' : '编辑用户'}</h5>
    </div>
    <div class="card-body">
        <!-- 错误提示 -->
        <c:if test="${not empty result and result.code != 200}">
            <div class="alert alert-danger">${result.message}</div>
        </c:if>

        <form id="userForm" class="needs-validation" novalidate>
            <c:if test="${not empty user}">
                <input type="hidden" name="userId" value="${user.userId}">
            </c:if>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="username" class="form-label required">用户名</label>
                    <input type="text" class="form-control" id="username" name="username"
                           value="${user.username}" required maxlength="50">
                    <div class="invalid-feedback">请输入用户名</div>
                </div>

                <div class="col-md-6 mb-3">
                    <label for="realName" class="form-label required">真实姓名</label>
                    <input type="text" class="form-control" id="realName" name="realName"
                           value="${user.realName}" required maxlength="50">
                    <div class="invalid-feedback">请输入真实姓名</div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="password" class="form-label ${empty user ? 'required' : ''}">密码</label>
                    <input type="password" class="form-control" id="password" name="password"
                    ${empty user ? 'required' : ''} minlength="6" maxlength="20">
                    <div class="invalid-feedback">
                        ${empty user ? '请输入密码' : '密码至少6位，留空表示不修改'}
                    </div>
                    <div class="form-text">${empty user ? '请输入6-20位密码' : '留空表示不修改密码'}</div>
                </div>

                <div class="col-md-6 mb-3">
                    <label for="confirmPassword" class="form-label ${empty user ? 'required' : ''}">确认密码</label>
                    <input type="password" class="form-control" id="confirmPassword"
                    ${empty user ? 'required' : ''} minlength="6" maxlength="20">
                    <div class="invalid-feedback">两次密码输入不一致</div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="userType" class="form-label required">用户类型</label>
                    <select class="form-select" id="userType" name="userType" required>
                        <option value="">请选择用户类型</option>
                        <option value="1" ${user.userType == 1 ? 'selected' : ''}>管理员</option>
                        <option value="2" ${user.userType == 2 ? 'selected' : ''}>司机</option>
                        <option value="3" ${user.userType == 3 ? 'selected' : ''}>客户</option>
                    </select>
                    <div class="invalid-feedback">请选择用户类型</div>
                </div>

                <div class="col-md-6 mb-3">
                    <label for="phone" class="form-label">联系电话</label>
                    <input type="tel" class="form-control" id="phone" name="phone"
                           value="${user.phone}" maxlength="20">
                </div>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="email" class="form-label">邮箱</label>
                    <input type="email" class="form-control" id="email" name="email"
                           value="${user.email}" maxlength="100">
                </div>

                <div class="col-md-6 mb-3">
                    <label for="status" class="form-label">状态</label>
                    <select class="form-select" id="status" name="status">
                        <option value="1" ${empty user or user.status == 1 ? 'selected' : ''}>启用</option>
                        <option value="0" ${user.status == 0 ? 'selected' : ''}>禁用</option>
                    </select>
                </div>
            </div>

            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                <a href="${pageContext.request.contextPath}/users" class="btn btn-secondary me-2">取消</a>
                <button type="button" class="btn btn-primary" onclick="submitForm()">
                    ${empty user ? '创建' : '更新'}
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    $(document).ready(function() {
        // 实时检查用户名是否重复
        $('#username').on('blur', function() {
            const username = $(this).val();
            if (username.trim() === '') return;

            $.ajax({
                url: '${pageContext.request.contextPath}/api/users/check-username?username=' + encodeURIComponent(username),
                type: 'GET',
                success: function(response) {
                    if (response.code === 200 && response.data && response.data.exists) {
                        $('#username').addClass('is-invalid');
                        $('#username').next('.invalid-feedback').text('用户名已存在');
                    } else {
                        $('#username').removeClass('is-invalid');
                    }
                }
            });
        });

        // 密码确认验证
        $('#confirmPassword').on('keyup', function() {
            const password = $('#password').val();
            const confirmPassword = $(this).val();

            if (password !== confirmPassword) {
                this.setCustomValidity('两次密码输入不一致');
            } else {
                this.setCustomValidity('');
            }
        });
    });

    function submitForm() {
        const form = document.getElementById('userForm');
        if (!Utils.validateForm(form)) {
            return;
        }

        // 收集表单数据
        const formData = {
            username: $('#username').val().trim(),
            realName: $('#realName').val().trim(),
            userType: parseInt($('#userType').val()),
            status: parseInt($('#status').val())
        };

        // 验证必填字段
        if (formData.username === '') {
            $('#username').addClass('is-invalid');
            return;
        }

        if (!formData.realName) {
            $('#realName').addClass('is-invalid');
            return;
        }

        if (!formData.userType) {
            $('#userType').addClass('is-invalid');
            return;
        }

        // 密码处理
        const password = $('#password').val().trim();
        const confirmPassword = $('#confirmPassword').val().trim();

        if (!<c:out value="${empty user}"/> && password === '' && confirmPassword === '') {
            // 编辑模式且密码为空，不修改密码
        } else {
            if (password.length < 6) {
                $('#password').addClass('is-invalid');
                return;
            }
            if (password !== confirmPassword) {
                $('#confirmPassword').addClass('is-invalid');
                return;
            }
            formData.password = password;
        }

        // 可选字段
        const phone = $('#phone').val().trim();
        if (phone) {
            formData.phone = phone;
        }

        const email = $('#email').val().trim();
        if (email) {
            formData.email = email;
        }

        // 如果是编辑，添加userId
        const userId = $('input[name="userId"]').val();
        if (userId) {
            formData.userId = parseInt(userId);
        }

        // 确定URL和方法
        const url = userId
            ? '${pageContext.request.contextPath}/api/users/' + userId
            : '${pageContext.request.contextPath}/api/users';
        const method = userId ? 'PUT' : 'POST';

        Utils.showLoading();

        // 提交到API
        $.ajax({
            url: url,
            type: method,
            contentType: 'application/json',
            data: JSON.stringify(formData),
            dataType: 'json',
            success: function(response) {
                Utils.hideLoading();
                if (response.code === 200) {
                    Utils.showSuccess(response.message || '操作成功');
                    setTimeout(() => {
                        // 重定向到列表页
                        window.location.href = '${pageContext.request.contextPath}/users?success=' +
                            encodeURIComponent(response.message || '操作成功');
                    }, 1000);
                } else {
                    Utils.showError(response.message || '操作失败');

                    // 如果是用户名重复的错误，高亮显示
                    if (response.message && response.message.includes('用户名')) {
                        $('#username').addClass('is-invalid');
                        $('#username').next('.invalid-feedback').text(response.message);
                    }
                }
            },
            error: function(xhr) {
                Utils.hideLoading();
                let errorMsg = '请求失败';
                if (xhr.responseJSON && xhr.responseJSON.message) {
                    errorMsg = xhr.responseJSON.message;
                } else if (xhr.statusText) {
                    errorMsg = xhr.statusText;
                }
                Utils.showError(errorMsg);
            }
        });
    }
</script>