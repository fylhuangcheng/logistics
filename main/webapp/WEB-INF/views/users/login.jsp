<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物流管理系统 - 登录</title>

    <style>
        /* 保持原有样式不变 */
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

        .login-container {
            width: 90%;
            max-width: 400px;
        }

        .login-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            overflow: hidden;
        }

        .login-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }

        .login-body {
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

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .test-accounts {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }

        .test-buttons {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .test-btn {
            flex: 1;
            padding: 8px;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }

        .test-btn:hover {
            background: #e9ecef;
        }

        .spinner {
            display: inline-block;
            width: 16px;
            height: 16px;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 50%;
            border-top-color: white;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
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
    </style>
</head>
<body>
<div class="login-container">
    <div class="login-card">
        <div class="login-header">
            <h1>物流管理系统</h1>
            <p>用户登录</p>
        </div>

        <div class="login-body">
            <!-- 错误提示 -->
            <div id="errorMessage" class="error-message">
                <!-- 这里显示后端返回的错误信息 -->
                <c:if test="${not empty error}">
                    ${error}
                </c:if>
            </div>

            <!-- 修改表单：使用action属性，method为POST -->
            <form id="loginForm" action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-group">
                    <label for="username">用户名</label>
                    <input type="text"
                           id="username"
                           name="username"
                           class="form-control"
                           placeholder="请输入用户名"
                           required
                           autofocus>
                </div>

                <div class="form-group">
                    <label for="password">密码</label>
                    <input type="password"
                           id="password"
                           name="password"
                           class="form-control"
                           placeholder="请输入密码"
                           required>
                </div>

                <button type="submit" class="btn" id="loginBtn">
                    登录
                </button>
            </form>

            <!-- 测试账户 -->
            <div class="test-accounts">
                <p style="color: #666; font-size: 14px; margin-bottom: 10px;">测试账户：</p>
                <div class="test-buttons">
                    <button type="button" class="test-btn" onclick="fillCredentials('admin', '123456')">
                        管理员
                    </button>
                    <button type="button" class="test-btn" onclick="fillCredentials('driver1', '123456')">
                        司机
                    </button>
                    <button type="button" class="test-btn" onclick="fillCredentials('customer1', '123456')">
                        客户
                    </button>
                </div>
            </div>
            <div class="register-link" style="text-align: center; margin-top: 20px; color: #666;">
                还没有账户？<a href="${pageContext.request.contextPath}/users/register" style="color: #667eea; text-decoration: none;">立即注册</a>
            </div>
        </div>
    </div>
</div>

<script>
    // 页面加载时检查是否有错误信息
    window.addEventListener('load', function() {
        const errorDiv = document.getElementById('errorMessage');
        const errorText = errorDiv.textContent.trim();

        if (errorText && errorText.length > 0) {
            errorDiv.style.display = 'block';
        }
    });

    // 填充测试账户
    function fillCredentials(username, password) {
        document.getElementById('username').value = username;
        document.getElementById('password').value = password;
        document.getElementById('errorMessage').style.display = 'none';
    }


    // 表单提交时的处理
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value;

        // 前端验证
        if (!username || !password) {
            e.preventDefault(); // 阻止表单提交
            showError('请输入用户名和密码');
            return;
        }

        // 显示加载状态
        const btn = document.getElementById('loginBtn');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner"></span> 登录中...';
    });

    // 显示错误信息
    function showError(message) {
        const errorDiv = document.getElementById('errorMessage');
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
    }

    // 按回车键自动提交
    document.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            const btn = document.getElementById('loginBtn');
            if (!btn.disabled) {
                document.getElementById('loginForm').dispatchEvent(new Event('submit'));
            }
        }
    });
</script>
</body>
</html>