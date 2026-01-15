
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-md navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/">
            <i class="fas fa-shipping-fast me-2"></i>
            物流管理系统
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarCollapse">
            <ul class="navbar-nav me-auto mb-2 mb-md-0">
                <li class="nav-item">
                    <a class="nav-link ${activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard">
                        <i class="fas fa-home"></i> 首页
                    </a>
                </li>
                <c:if test="${not empty sessionScope.user}">
                    <c:if test="${sessionScope.user.userType == 1}">
                        <li class="nav-item">
                            <a class="nav-link ${activeMenu == 'orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/orders">
                                <i class="fas fa-shipping-fast"></i> 订单
                            </a>
                        </li>
                        <!-- 运输任务模块 -->
                        <li class="nav-item">
                            <a class="nav-link ${activeMenu == 'transport_tasks' ? 'active' : ''}" href="${pageContext.request.contextPath}/transport_tasks">
                                <i class="fas fa-tasks"></i> 运输任务
                            </a>
                        </li>
                        <!-- 车辆模块 -->
                        <li class="nav-item">
                            <a class="nav-link ${activeMenu == 'vehicles' ? 'active' : ''}" href="${pageContext.request.contextPath}/vehicles">
                                <i class="fas fa-truck"></i> 车辆
                            </a>
                        </li>
                        <!-- 司机模块 -->
                        <li class="nav-item">
                            <a class="nav-link ${activeMenu == 'drivers' ? 'active' : ''}" href="${pageContext.request.contextPath}/drivers">
                                <i class="fas fa-id-card"></i> 司机
                            </a>
                        </li>
                        <!-- 货物模块 -->
                        <li class="nav-item">
                            <a class="nav-link ${activeMenu == 'cargo_items' ? 'active' : ''}" href="${pageContext.request.contextPath}/cargo_items">
                                <i class="fas fa-box"></i> 货物
                            </a>
                        </li>
                        <!-- 网点模块 -->
                        <li class="nav-item">
                            <a class="nav-link ${activeMenu == 'stations' ? 'active' : ''}" href="${pageContext.request.contextPath}/stations">
                                <i class="fas fa-warehouse"></i> 网点
                            </a>
                        </li>
                        <!-- 费用模块 -->
                        <li class="nav-item">
                            <a class="nav-link ${activeMenu == 'costs_details' ? 'active' : ''}" href="${pageContext.request.contextPath}/cost_details">
                                <i class="fas fa-money-bill-wave"></i> 费用
                            </a>
                        </li>
                        <!-- 用户模块 -->
                        <li class="nav-item">
                            <a class="nav-link ${activeMenu == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/users">
                                <i class="fas fa-users"></i> 用户
                            </a>
                        </li>
                    </c:if>
                    <!-- 司机用户专属菜单 -->
                    <c:if test="${sessionScope.user.userType == 2}">
                        <li class="nav-item">
                            <a class="nav-link ${activeMenu == 'driver_tasks' ? 'active' : ''}" href="${pageContext.request.contextPath}/transport_tasks">
                                <i class="fas fa-clipboard-list"></i> 我的任务
                            </a>
                        </li>
                        <!-- 车辆模块 -->
                        <li class="nav-item">
                            <a class="nav-link ${activeMenu == 'vehicles' ? 'active' : ''}" href="${pageContext.request.contextPath}/vehicles">
                                <i class="fas fa-truck"></i> 我的车辆
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${activeMenu == 'driver_cargo' ? 'active' : ''}" href="${pageContext.request.contextPath}/cargo_items">
                                <i class="fas fa-box"></i> 货物管理
                            </a>
                        </li>
                    </c:if>
                    <!-- 客户用户专属菜单 -->
                    <c:if test="${sessionScope.user.userType == 3}">
                        <li class="nav-item">
                            <a class="nav-link ${activeMenu == 'customer_orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/orders">
                                <i class="fas fa-boxes"></i> 我的订单
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${activeMenu == 'driver_cargo' ? 'active' : ''}" href="${pageContext.request.contextPath}/cargo_items">
                                <i class="fas fa-box"></i> 货物追踪
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link ${activeMenu == 'customer_costs' ? 'active' : ''}" href="${pageContext.request.contextPath}/cost_details">
                                <i class="fas fa-file-invoice-dollar"></i> 费用查询
                            </a>
                        </li>
                    </c:if>
                </c:if>
            </ul>

            <div class="d-flex">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="dropdown">
                            <a href="#" class="d-block link-light text-decoration-none dropdown-toggle" id="userDropdown" data-bs-toggle="dropdown">
                                <img src="https://ui-avatars.com/api/?name=${sessionScope.user.realName}&background=0D8ABC&color=fff"
                                     alt="用户头像" width="32" height="32" class="rounded-circle">
                                <span class="ms-2">${sessionScope.user.realName}
                                    <c:choose>
                                        <c:when test="${sessionScope.user.userType == 1}"><small>(管理员)</small></c:when>
                                        <c:when test="${sessionScope.user.userType == 2}"><small>(司机)</small></c:when>
                                        <c:when test="${sessionScope.user.userType == 3}"><small>(客户)</small></c:when>
                                    </c:choose>
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/users/profile">
                                        <i class="fas fa-user-circle"></i> 个人资料
                                        <c:if test="${sessionScope.user.userType == 2}">
                                            <span class="badge bg-info ms-1">含司机信息</span>
                                        </c:if>
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/users/password">
                                        <i class="fas fa-key"></i> 修改密码
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item" href="#" onclick="logout()">
                                        <i class="fas fa-sign-out-alt"></i> 退出登录
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/users/login" class="btn btn-outline-light">
                            <i class="fas fa-sign-in-alt"></i> 登录
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>

<script>
    // 退出登录函数
    function logout() {
        console.log('退出登录按钮被点击');

        // 获取context path
        var contextPath = '${pageContext.request.contextPath}';
        console.log('Context Path:', contextPath);

        if (confirm('确定要退出登录吗？')) {
            // 方案1：使用fetch API（现代方式）
            fetch(contextPath + '/api/users/logout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                credentials: 'include' // 包含cookie
            })
                .then(response => {
                    console.log('退出响应状态:', response.status);
                    // 跳转到登录页
                    window.location.href = contextPath + '/login';
                })
                .catch(error => {
                    console.error('退出失败:', error);
                    window.location.href = contextPath + '/login';
                });
        }
    }
</script>

