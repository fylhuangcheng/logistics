<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="row justify-content-center">
    <div class="col-md-6">
        <div class="card">
            <div class="card-header">
                <h5 class="mb-0">修改密码</h5>
            </div>
            <div class="card-body">
                <!-- 错误提示 -->
                <c:if test="${not empty result and result.code != 200}">
                    <div class="alert alert-danger">${result.message}</div>
                </c:if>

                <form id="passwordForm" class="needs-validation" novalidate
                      action="${pageContext.request.contextPath}/users/password"
                      method="post">

                    <input type="hidden" name="userId" value="${sessionScope.user.userId}">

                    <div class="mb-3">
                        <label for="oldPassword" class="form-label required">原密码</label>
                        <input type="password" class="form-control" id="oldPassword" name="oldPassword"
                               required minlength="6" maxlength="20">
                        <div class="invalid-feedback">请输入原密码</div>
                    </div>

                    <div class="mb-3">
                        <label for="newPassword" class="form-label required">新密码</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword"
                               required minlength="6" maxlength="20">
                        <div class="invalid-feedback">请输入新密码（至少6位）</div>
                        <div class="form-text">密码至少6位，建议使用字母和数字组合</div>
                    </div>

                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label required">确认新密码</label>
                        <input type="password" class="form-control" id="confirmPassword"
                               name="confirmPassword" required minlength="6" maxlength="20">  <!-- 添加name属性 -->
                        <div class="invalid-feedback">两次密码输入不一致</div>
                    </div>

                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        为了账户安全，请定期修改密码，并使用包含字母和数字的组合密码。
                    </div>

                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="${pageContext.request.contextPath}/users/profile"
                           class="btn btn-secondary me-2">取消</a>
                        <button type="submit" class="btn btn-primary">确认修改</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        console.log('密码修改页面安全初始化');

        try {
            // 密码确认实时验证 - 不使用防抖
            $('#confirmPassword').on('keyup', function() {
                try {
                    var newPassword = $('#newPassword').val();
                    var confirmPassword = $(this).val();

                    if (newPassword !== confirmPassword) {
                        $(this).addClass('is-invalid');
                        $(this).next('.invalid-feedback').show().text('两次密码输入不一致');
                    } else {
                        $(this).removeClass('is-invalid');
                        $(this).next('.invalid-feedback').hide();
                    }
                } catch (err) {
                    console.log('密码验证出错:', err);
                }
            });

            // 新密码验证 - 不使用防抖
            $('#newPassword').on('keyup', function() {
                try {
                    var password = $(this).val();
                    if (password.length < 6) {
                        $(this).addClass('is-invalid');
                        $(this).next('.invalid-feedback').show().text('密码长度至少6位');
                    } else {
                        $(this).removeClass('is-invalid');
                        $(this).next('.invalid-feedback').hide();
                    }
                } catch (err) {
                    console.log('密码强度验证出错:', err);
                }
            });

            // 表单提交
            $('#passwordForm').on('submit', function(e) {
                console.log('表单提交开始');

                try {
                    // 基础验证
                    var oldPassword = $('#oldPassword').val();
                    var newPassword = $('#newPassword').val();
                    var confirmPassword = $('#confirmPassword').val();

                    // 清空之前的错误状态
                    $('.is-invalid').removeClass('is-invalid');
                    $('.invalid-feedback').hide();

                    // 验证原密码
                    if (!oldPassword || oldPassword.trim() === '') {
                        e.preventDefault();
                        $('#oldPassword').addClass('is-invalid');
                        $('#oldPassword').next('.invalid-feedback').show().text('请输入原密码');
                        return false;
                    }

                    // 验证新密码
                    if (!newPassword || newPassword.length < 6) {
                        e.preventDefault();
                        $('#newPassword').addClass('is-invalid');
                        $('#newPassword').next('.invalid-feedback').show().text('新密码至少6位');
                        return false;
                    }

                    // 验证确认密码
                    if (newPassword !== confirmPassword) {
                        e.preventDefault();
                        $('#confirmPassword').addClass('is-invalid');
                        $('#confirmPassword').next('.invalid-feedback').show().text('两次密码输入不一致');
                        return false;
                    }

                    // 验证新旧密码不同
                    if (newPassword === oldPassword) {
                        e.preventDefault();
                        $('#newPassword').addClass('is-invalid');
                        $('#newPassword').next('.invalid-feedback').show().text('新密码不能与原密码相同');
                        return false;
                    }

                    console.log('表单验证通过，准备提交');
                    // 显示简单的加载状态
                    $('button[type="submit"]').prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> 修改中...');

                } catch (err) {
                    console.error('表单提交错误:', err);
                    alert('表单提交出错，请刷新页面重试');
                    e.preventDefault();
                    return false;
                }
            });

        } catch (err) {
            console.error('页面初始化错误:', err);
        }
    });
</script>