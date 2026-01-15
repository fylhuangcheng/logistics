<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>403 - 禁止访问</title>
    <style>
        .error-container {
            max-width: 500px;
            margin: 100px auto;
            text-align: center;
        }
        .error-code {
            font-size: 72px;
            color: #dc3545;
        }
        .error-message {
            font-size: 24px;
            margin: 20px 0;
        }
        .error-detail {
            color: #666;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-code">403</div>
    <div class="error-message">禁止访问</div>
    <div class="error-detail">
        ${empty error ? '您没有权限访问此页面' : error}
    </div>
    <a href="${pageContext.request.contextPath}/orders" class="btn btn-primary">
        返回订单列表
    </a>
</div>
</body>
</html>