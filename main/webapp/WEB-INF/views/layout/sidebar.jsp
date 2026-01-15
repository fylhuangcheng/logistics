<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="position-sticky pt-4 mt-4">
    <ul class="nav flex-column">
        <li class="nav-item">
            <a class="nav-link ${activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard">
                <i class="fas fa-tachometer-alt me-2"></i> 仪表盘
            </a>
        </li>

        <!-- 管理员功能 -->
        <c:if test="${sessionScope.user.userType == 1}">
            <!-- 订单管理 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu == 'orders' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/orders">
                    <i class="fas fa-shipping-fast me-2"></i> 订单管理
                </a>
                <ul class="nav flex-column ms-4">
                    <li>
                        <a class="nav-link ${subMenu == 'order_list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/orders">
                            <i class="fas fa-list me-1"></i> 订单列表
                        </a>
                    </li>
                    <li>
                        <a class="nav-link ${subMenu == 'order_add' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/orders/add">
                            <i class="fas fa-plus-circle me-1"></i> 新增订单
                        </a>
                    </li>
                </ul>
            </li>

            <!-- 运输任务管理 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu == 'transport_tasks' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/transport_tasks">
                    <i class="fas fa-tasks me-2"></i> 运输任务管理
                </a>
                <ul class="nav flex-column ms-4">
                    <li>
                        <a class="nav-link ${subMenu == 'transport_task_list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/transport_tasks">
                            <i class="fas fa-list me-1"></i> 任务列表
                        </a>
                    </li>
                    <li>
                        <a class="nav-link ${subMenu == 'transport_task_add' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/transport_tasks/add">
                            <i class="fas fa-plus-circle me-1"></i> 新增任务
                        </a>
                    </li>
                </ul>
            </li>

            <!-- 车辆管理 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu == 'vehicles' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/vehicles">
                    <i class="fas fa-truck me-2"></i> 车辆管理
                </a>
                <ul class="nav flex-column ms-4">
                    <li>
                        <a class="nav-link ${subMenu == 'vehicle_list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/vehicles">
                            <i class="fas fa-list me-1"></i> 车辆列表
                        </a>
                    </li>
                    <li>
                        <a class="nav-link ${subMenu == 'vehicle_add' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/vehicles/add">
                            <i class="fas fa-plus-circle me-1"></i> 新增车辆
                        </a>
                    </li>
                </ul>
            </li>

            <!-- 司机管理 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu == 'drivers' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/drivers">
                    <i class="fas fa-id-card me-2"></i> 司机管理
                </a>
                <ul class="nav flex-column ms-4">
                    <li>
                        <a class="nav-link ${subMenu == 'driver_list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/drivers">
                            <i class="fas fa-list me-1"></i> 司机列表
                        </a>
                    </li>
                    <li>
                        <a class="nav-link ${subMenu == 'driver_add' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/drivers/add">
                            <i class="fas fa-user-plus me-1"></i> 新增司机
                        </a>
                    </li>
                </ul>
            </li>

            <!-- 货物管理 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu == 'cargo_items' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/cargo_items">
                    <i class="fas fa-box me-2"></i> 货物管理
                </a>
                <ul class="nav flex-column ms-4">
                    <li>
                        <a class="nav-link ${subMenu == 'cargo_items_list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/cargo_items">
                            <i class="fas fa-list me-1"></i> 货物列表
                        </a>
                    </li>
                    <li>
                        <a class="nav-link ${subMenu == 'cargo_items_add' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/cargo_items/add">
                            <i class="fas fa-plus-circle me-1"></i> 新增货物
                        </a>
                    </li>
                </ul>
            </li>

            <!-- 网点管理 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu == 'stations' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/stations">
                    <i class="fas fa-warehouse me-2"></i> 网点管理
                </a>
                <ul class="nav flex-column ms-4">
                    <li>
                        <a class="nav-link ${subMenu == 'station_list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/stations">
                            <i class="fas fa-list me-1"></i> 网点列表
                        </a>
                    </li>
                    <li>
                        <a class="nav-link ${subMenu == 'station_add' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/stations/add">
                            <i class="fas fa-plus-circle me-1"></i> 新增网点
                        </a>
                    </li>
                </ul>
            </li>

            <!-- 费用管理 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu == 'cost_details' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/cost_details">
                    <i class="fas fa-money-bill-wave me-2"></i> 费用管理
                </a>
                <ul class="nav flex-column ms-4">
                    <li>
                        <a class="nav-link ${subMenu == 'cost_details_list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/cost_details">
                            <i class="fas fa-list me-1"></i> 费用列表
                        </a>
                    </li>
                    <li>
                        <a class="nav-link ${subMenu == 'cost_details_add' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/cost_details/add">
                            <i class="fas fa-plus-circle me-1"></i> 新增费用
                        </a>
                    </li>
                </ul>
            </li>

            <!-- 用户管理 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu == 'users' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/users">
                    <i class="fas fa-users me-2"></i> 用户管理
                </a>
                <ul class="nav flex-column ms-4">
                    <li>
                        <a class="nav-link ${subMenu == 'user_list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/users">
                            <i class="fas fa-list me-1"></i> 用户列表
                        </a>
                    </li>
                    <li>
                        <a class="nav-link ${subMenu == 'user_add' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/users/add">
                            <i class="fas fa-user-plus me-1"></i> 新增用户
                        </a>
                    </li>
                </ul>
            </li>
        </c:if>

        <!-- 司机用户专属菜单 -->
        <c:if test="${sessionScope.user.userType == 2}">
            <!-- 运输任务管理 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu == 'transport_tasks' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/transport_tasks">
                    <i class="fas fa-tasks me-2"></i> 我的任务
                </a>
                <ul class="nav flex-column ms-4">
                    <li>
                        <a class="nav-link ${subMenu == 'transport_task_list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/transport_tasks">
                            <i class="fas fa-list me-1"></i> 任务列表
                        </a>
                    </li>
                </ul>
            </li>

            <!-- 车辆管理 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu == 'vehicles' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/vehicles">
                    <i class="fas fa-truck me-2"></i> 我的车辆
                </a>
                <ul class="nav flex-column ms-4">
                    <li>
                        <a class="nav-link ${subMenu == 'vehicle_list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/vehicles">
                            <i class="fas fa-list me-1"></i> 车辆列表
                        </a>
                    </li>
                </ul>
            </li>

            <!-- 货物管理 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu == 'cargo_items' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/cargo_items">
                    <i class="fas fa-box me-2"></i> 货物管理
                </a>
                <ul class="nav flex-column ms-4">
                    <li>
                        <a class="nav-link ${subMenu == 'cargo_items_list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/cargo_items">
                            <i class="fas fa-list me-1"></i> 货物列表
                        </a>
                    </li>
                </ul>
            </li>
        </c:if>

        <!-- 客户用户专属菜单 -->
        <c:if test="${sessionScope.user.userType == 3}">
            <!-- 订单管理 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu == 'orders' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/orders">
                    <i class="fas fa-shipping-fast me-2"></i> 我的订单
                </a>
                <ul class="nav flex-column ms-4">
                    <li>
                        <a class="nav-link ${subMenu == 'order_list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/orders">
                            <i class="fas fa-list me-1"></i> 订单列表
                        </a>
                    </li>
                    <li>
                        <a class="nav-link ${subMenu == 'order_add' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/orders/add">
                            <i class="fas fa-plus-circle me-1"></i> 新增订单
                        </a>
                    </li>
                </ul>
            </li>

            <!-- 货物管理 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu == 'cargo_items' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/cargo_items">
                    <i class="fas fa-box me-2"></i> 货物追踪
                </a>
                <ul class="nav flex-column ms-4">
                    <li>
                        <a class="nav-link ${subMenu == 'cargo_items_list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/cargo_items">
                            <i class="fas fa-list me-1"></i> 货物列表
                        </a>
                    </li>
                </ul>
            </li>
            <!-- 费用管理 -->
            <li class="nav-item">
                <a class="nav-link ${activeMenu == 'costs' ? 'active' : ''}"
                   href="${pageContext.request.contextPath}/cost_details">
                    <i class="fas fa-money-bill-wave me-2"></i> 费用查询
                </a>
                <ul class="nav flex-column ms-4">
                    <li>
                        <a class="nav-link ${subMenu == 'cost_list' ? 'active' : ''}"
                           href="${pageContext.request.contextPath}/cost_details">
                            <i class="fas fa-list me-1"></i> 费用列表
                        </a>
                    </li>
                </ul>
            </li>
        </c:if>

        <!-- 通用菜单（所有登录用户） -->
        <li class="nav-item">
            <a class="nav-link ${activeMenu == 'profile' ? 'active' : ''}"
               href="${pageContext.request.contextPath}/users/profile">
                <i class="fas fa-user me-2"></i> 个人中心
            </a>
            <ul class="nav flex-column ms-4">
                <li>
                    <a class="nav-link ${subMenu == 'user_profile' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/users/profile">
                        <i class="fas fa-id-card me-1"></i> 个人资料
                    </a>
                </li>
                <li>
                    <a class="nav-link ${subMenu == 'password' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/users/password">
                        <i class="fas fa-key me-1"></i> 修改密码
                    </a>
                </li>
            </ul>
        </li>
    </ul>
</div>

