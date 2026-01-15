<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物流管理系统 - 用户注册</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .register-container {
            width: 90%;
            max-width: 450px;
        }

        .register-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            overflow: hidden;
        }

        .register-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            text-align: center;
        }

        .register-body {
            padding: 30px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }

        .form-control {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .btn {
            display: block;
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: opacity 0.3s;
        }

        .btn:hover {
            opacity: 0.9;
        }

        .btn-secondary {
            background: #6c757d;
        }

        .error-message {
            color: #dc3545;
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: none;
        }

        .success-message {
            color: #155724;
            background: #d4edda;
            border: 1px solid #c3e6cb;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            display: none;
        }

        .login-link {
            text-align: center;
            margin-top: 20px;
            color: #666;
        }

        .login-link a {
            color: #667eea;
            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .field-info {
            font-size: 12px;
            color: #666;
            margin-top: 4px;
        }
    </style>
</head>
<body>
<div class="register-container">
    <div class="register-card">
        <div class="register-header">
            <h1>物流管理系统</h1>
            <p>用户注册</p>
        </div>

        <div class="register-body">
            <!-- 错误提示 -->
            <div id="errorMessage" class="error-message">
                <c:if test="${not empty error}">
                    ${error}
                </c:if>
            </div>

            <!-- 成功提示 -->
            <div id="successMessage" class="success-message">
                <c:if test="${not empty success}">
                    ${success}
                </c:if>
            </div>

            <form id="registerForm" action="${pageContext.request.contextPath}/users/register" method="POST">
                <div class="form-group">
                    <label for="username">用户名 *</label>
                    <input type="text"
                           id="username"
                           name="username"
                           class="form-control"
                           placeholder="请输入用户名"
                           required
                           value="${user.username}"
                           autofocus>
                    <div class="field-info">用户名必须是唯一的，长度4-20个字符</div>
                </div>

                <div class="form-group">
                    <label for="password">密码 *</label>
                    <input type="password"
                           id="password"
                           name="password"
                           class="form-control"
                           placeholder="请输入密码"
                           required>
                    <div class="field-info">密码长度6-20个字符</div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">确认密码 *</label>
                    <input type="password"
                           id="confirmPassword"
                           name="confirmPassword"
                           class="form-control"
                           placeholder="请再次输入密码"
                           required>
                </div>

                <div class="form-group">
                    <label for="realName">真实姓名 *</label>
                    <input type="text"
                           id="realName"
                           name="realName"
                           class="form-control"
                           placeholder="请输入真实姓名"
                           required
                           value="${user.realName}">
                </div>

                <div class="form-group">
                    <label for="email">邮箱</label>
                    <input type="email"
                           id="email"
                           name="email"
                           class="form-control"
                           placeholder="请输入邮箱（可选）"
                           value="${user.email}">
                </div>

                <div class="form-group">
                    <label for="phone">手机号</label>
                    <input type="tel"
                           id="phone"
                           name="phone"
                           class="form-control"
                           placeholder="请输入手机号（可选）"
                           value="${user.phone}">
                </div>

                <button type="submit" class="btn" id="registerBtn">
                    注册
                </button>
            </form>

            <div class="login-link">
                已有账户？<a href="${pageContext.request.contextPath}/users/login">立即登录</a>
            </div>
        </div>
    </div>
</div>

<script>
    // 页面加载时检查是否有消息
    window.addEventListener('load', function() {
        const errorDiv = document.getElementById('errorMessage');
        const successDiv = document.getElementById('successMessage');

        if (errorDiv.textContent.trim().length > 0) {
            errorDiv.style.display = 'block';
        }
        if (successDiv.textContent.trim().length > 0) {
            successDiv.style.display = 'block';
        }
    });

    // 表单提交时的处理
    document.getElementById('registerForm').addEventListener('submit', function(e) {
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const realName = document.getElementById('realName').value.trim();

        // 隐藏错误信息
        document.getElementById('errorMessage').style.display = 'none';

        // 前端验证
        let errorMsg = '';

        if (username.length < 4 || username.length > 20) {
            errorMsg = '用户名长度必须在4-20个字符之间';
        } else if (password.length < 6 || password.length > 20) {
            errorMsg = '密码长度必须在6-20个字符之间';
        } else if (password !== confirmPassword) {
            errorMsg = '两次输入的密码不一致';
        } else if (!realName) {
            errorMsg = '真实姓名不能为空';
        }

        if (errorMsg) {
            e.preventDefault();
            showError(errorMsg);
            return false;
        }

        // 显示加载状态
        const btn = document.getElementById('registerBtn');
        btn.disabled = true;
        btn.innerHTML = '注册中...';
    });

    // 显示错误信息
    function showError(message) {
        const errorDiv = document.getElementById('errorMessage');
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        // 滚动到错误信息位置
        errorDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }

    // 实时检查用户名是否可用
    document.getElementById('username').addEventListener('blur', function() {
        const username = this.value.trim();
        if (username.length >= 4 && username.length <= 20) {
            checkUsernameAvailability(username);
        }
    });

    function checkUsernameAvailability(username) {
        fetch('${pageContext.request.contextPath}/api/users/check-username?username=' + encodeURIComponent(username))
            .then(response => response.json())
            .then(data => {
                if (data.code === 200 && data.data.exists) {
                    showError('用户名已存在，请换一个');
                }
            })
            .catch(error => {
                console.error('检查用户名失败:', error);
            });
    }

    // 按回车键自动提交
    document.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            const btn = document.getElementById('registerBtn');
            if (!btn.disabled) {
                document.getElementById('registerForm').dispatchEvent(new Event('submit'));
            }
        }
    });
</script>
</body>
</html>
