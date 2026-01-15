<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物流管理系统</title>
    <script>
        // 直接跳转到登录页面
        window.location.href = "${pageContext.request.contextPath}/users/login";
    </script>
</head>
<body>
<div style="text-align: center; margin-top: 100px;">
    <h2>正在跳转到登录页面...</h2>
    <p>如果长时间没有跳转，请点击 <a href="${pageContext.request.contextPath}/users/login">这里</a></p>
</div>
</body>
</html>