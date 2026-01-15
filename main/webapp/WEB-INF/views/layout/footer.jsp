<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<footer class="footer mt-auto py-3 border-top">
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-6">
                <span class="text-muted">© 2026 物流管理系统 v1.0</span>
            </div>
            <div class="col-md-6 text-end">
                <span class="text-muted">
                    <i class="fas fa-user me-1"></i> ${sessionScope.user.realName}
                    <c:choose>
                        <c:when test="${sessionScope.user.userType == 1}">(系统管理员)</c:when>
                        <c:when test="${sessionScope.user.userType == 2}">(司机)</c:when>
                        <c:when test="${sessionScope.user.userType == 3}">(客户)</c:when>
                    </c:choose>
                </span>
                <span class="text-muted ms-3">
                    <i class="fas fa-clock me-1"></i> <span class="current-time"></span>
                </span>
            </div>
        </div>
    </div>
</footer>