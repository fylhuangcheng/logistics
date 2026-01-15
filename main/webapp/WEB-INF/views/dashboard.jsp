<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>物流管理系统 - 控制面板</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f5f5f5;
            min-height: 100vh;
        }

        .header {
            background: white;
            padding: 0 20px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            border-bottom: 1px solid #dee2e6;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .logo {
            font-size: 20px;
            font-weight: bold;
            color: #333;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-name {
            font-weight: 500;
            color: #333;
        }

        .logout-btn {
            padding: 6px 12px;
            background: #dc3545;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }

        .logout-btn:hover {
            background: #c82333;
        }

        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .welcome-card {
            background: white;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .welcome-title {
            font-size: 24px;
            color: #333;
            margin-bottom: 10px;
        }

        .welcome-text {
            color: #666;
            margin-bottom: 20px;
        }

        /* 轮播图样式 */
        .carousel-container {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .carousel {
            position: relative;
            width: 100%;
            height: 400px;
            border-radius: 6px;
            overflow: hidden;
        }

        .carousel-inner {
            position: relative;
            width: 100%;
            height: 100%;
        }

        .carousel-item {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            transition: opacity 1s ease-in-out;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .carousel-item.active {
            opacity: 1;
        }

        .carousel-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .carousel-caption {
            position: absolute;
            bottom: 20px;
            left: 0;
            right: 0;
            text-align: center;
            color: white;
            background: rgba(0, 0, 0, 0.5);
            padding: 15px;
        }

        .carousel-caption h3 {
            margin-bottom: 5px;
            font-size: 24px;
        }

        .carousel-caption p {
            font-size: 16px;
            opacity: 0.9;
        }

        .carousel-control {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255, 255, 255, 0.7);
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            font-size: 20px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.3s;
        }

        .carousel-control:hover {
            background: rgba(255, 255, 255, 0.9);
        }

        .carousel-control.prev {
            left: 15px;
        }

        .carousel-control.next {
            right: 15px;
        }

        .carousel-indicators {
            position: absolute;
            bottom: 10px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 10px;
            z-index: 10;
        }

        .carousel-indicator {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.5);
            border: none;
            cursor: pointer;
            transition: background 0.3s;
        }

        .carousel-indicator.active {
            background: white;
        }

        .quick-actions {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .section-title {
            font-size: 18px;
            color: #333;
            margin-bottom: 20px;
        }

        .action-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(200px, 1fr));
            gap: 15px;
        }

        .action-btn {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            color: #333;
            text-decoration: none;
            transition: all 0.3s;
        }

        .action-btn:hover {
            background: #e9ecef;
            border-color: #ced4da;
            transform: translateY(-2px);
        }

        .action-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
        }

        .action-text {
            flex: 1;
        }

        .action-name {
            font-weight: 500;
            margin-bottom: 5px;
        }

        .action-desc {
            font-size: 12px;
            color: #666;
        }

        .user-type-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            margin-left: 10px;
        }

        .badge-admin {
            background: #dc3545;
            color: white;
        }

        .badge-driver {
            background: #007bff;
            color: white;
        }

        .badge-customer {
            background: #20c997;
            color: white;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .stat-icon {
            width: 60px;
            height: 60px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
        }

        .icon-order {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        .icon-vehicle {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }

        .icon-driver {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }

        .icon-cargo {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }

        .stat-content h3 {
            font-size: 24px;
            color: #333;
            margin-bottom: 5px;
        }

        .stat-content p {
            font-size: 14px;
            color: #666;
        }
    </style>
</head>
<body>
<!-- 头部 -->
<div class="header">
    <div class="logo">物流管理系统</div>
    <div class="user-info">
            <span class="user-name">
                欢迎，${user.realName}
                <c:choose>
                    <c:when test="${userType == 1}">
                        <span class="user-type-badge badge-admin">管理员</span>
                    </c:when>
                    <c:when test="${userType == 2}">
                        <span class="user-type-badge badge-driver">司机</span>
                    </c:when>
                    <c:when test="${userType == 3}">
                        <span class="user-type-badge badge-customer">客户</span>
                    </c:when>
                </c:choose>
            </span>
        <button class="logout-btn" onclick="logout()">退出登录</button>
    </div>
</div>

<!-- 主内容 -->
<div class="container">
    <!-- 欢迎卡片 -->
    <div class="welcome-card">
        <h1 class="welcome-title">欢迎使用物流管理系统</h1>
        <p class="welcome-text">今天是 <span></span></p>
    </div>

    <!-- 统计卡片（只对管理员显示） -->
    <c:if test="${userType == 1}">
        <div class="stats-container">
            <div class="stat-card">
                <div class="stat-icon icon-order">
                    📦
                </div>
                <div class="stat-content">
                    <h3 id="orderCount">0</h3>
                    <p>订单总数</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-vehicle">
                    🚚
                </div>
                <div class="stat-content">
                    <h3 id="vehicleCount">0</h3>
                    <p>车辆总数</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-driver">
                    👨‍✈️
                </div>
                <div class="stat-content">
                    <h3 id="driverCount">0</h3>
                    <p>司机总数</p>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon icon-cargo">
                    📦
                </div>
                <div class="stat-content">
                    <h3 id="cargoCount">0</h3>
                    <p>货物总数</p>
                </div>
            </div>
        </div>
    </c:if>

    <!-- 轮播图 -->
    <div class="carousel-container">
        <h2 class="section-title">物流风采展示</h2>
        <div class="carousel">
            <div class="carousel-inner">
                <!-- 轮播项1 -->
                <div class="carousel-item active">
                    <img src="${pageContext.request.contextPath}/static/img/1.png"
                         alt="物流运输" class="carousel-img">
                    <div class="carousel-caption">
                        <h3>高效物流运输</h3>
                        <p>专业团队，安全准时送达</p>
                    </div>
                </div>
                <!-- 轮播项2 -->
                <div class="carousel-item">
                    <img src="${pageContext.request.contextPath}/static/img/2.png"
                         alt="仓储管理" class="carousel-img">
                    <div class="carousel-caption">
                        <h3>智能仓储管理</h3>
                        <p>现代化仓储，高效管理您的货物</p>
                    </div>
                </div>
                <!-- 轮播项3 -->
                <div class="carousel-item">
                    <img src="${pageContext.request.contextPath}/static/img/3.png"
                         alt="客户服务" class="carousel-img">
                    <div class="carousel-caption">
                        <h3>优质客户服务</h3>
                        <p>24小时在线，全程跟踪</p>
                    </div>
                </div>
            </div>

            <!-- 控制按钮 -->
            <button class="carousel-control prev" onclick="prevSlide()">❮</button>
            <button class="carousel-control next" onclick="nextSlide()">❯</button>

            <!-- 指示器 -->
            <div class="carousel-indicators">
                <button class="carousel-indicator active" onclick="goToSlide(0)"></button>
                <button class="carousel-indicator" onclick="goToSlide(1)"></button>
                <button class="carousel-indicator" onclick="goToSlide(2)"></button>
            </div>
        </div>
    </div>

    <!-- 快速操作 -->
    <div class="quick-actions">
        <h2 class="section-title">快速操作</h2>
        <div class="action-grid">
            <c:choose>
                <c:when test="${userType == 1}">
                    <!-- 管理员操作（根据SQL表结构） -->
                    <a href="${pageContext.request.contextPath}/orders" class="action-btn">
                        <div class="action-icon">📦</div>
                        <div class="action-text">
                            <div class="action-name">订单管理</div>
                            <div class="action-desc">管理所有物流订单</div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/transport_tasks" class="action-btn">
                        <div class="action-icon">🚛</div>
                        <div class="action-text">
                            <div class="action-name">运输任务</div>
                            <div class="action-desc">调度和管理运输任务</div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/vehicles" class="action-btn">
                        <div class="action-icon">🚚</div>
                        <div class="action-text">
                            <div class="action-name">车辆管理</div>
                            <div class="action-desc">管理运输车辆信息</div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/drivers" class="action-btn">
                        <div class="action-icon">👨‍✈️</div>
                        <div class="action-text">
                            <div class="action-name">司机管理</div>
                            <div class="action-desc">管理司机信息</div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/cargo_items" class="action-btn">
                        <div class="action-icon">📦</div>
                        <div class="action-text">
                            <div class="action-name">货物管理</div>
                            <div class="action-desc">查看和管理货物明细</div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/stations" class="action-btn">
                        <div class="action-icon">📍</div>
                        <div class="action-text">
                            <div class="action-name">网点管理</div>
                            <div class="action-desc">管理物流网点信息</div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/cost_details" class="action-btn">
                        <div class="action-icon">💰</div>
                        <div class="action-text">
                            <div class="action-name">费用管理</div>
                            <div class="action-desc">管理收入和支出费用</div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/users" class="action-btn">
                        <div class="action-icon">👥</div>
                        <div class="action-text">
                            <div class="action-name">用户管理</div>
                            <div class="action-desc">管理系统用户账户</div>
                        </div>
                    </a>
                </c:when>
                <c:when test="${userType == 2}">
                    <!-- 司机操作 -->
                    <a href="${pageContext.request.contextPath}/transport_tasks" class="action-btn">
                        <div class="action-icon">📋</div>
                        <div class="action-text">
                            <div class="action-name">我的任务</div>
                            <div class="action-desc">查看和接收运输任务</div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/vehicles" class="action-btn">
                        <div class="action-icon">🚛</div>
                        <div class="action-text">
                            <div class="action-name">我的车辆</div>
                            <div class="action-desc">查看分配车辆信息</div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/cargo_items" class="action-btn">
                        <div class="action-icon">📦</div>
                        <div class="action-text">
                            <div class="action-name">货物管理</div>
                            <div class="action-desc">扫描和管理货物</div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/users/profile" class="action-btn">
                        <div class="action-icon">👤</div>
                        <div class="action-text">
                            <div class="action-name">个人信息</div>
                            <div class="action-desc">查看和更新个人资料</div>
                        </div>
                    </a>
                </c:when>
                <c:when test="${userType == 3}">
                    <!-- 客户操作 -->
                    <a href="${pageContext.request.contextPath}/orders" class="action-btn">
                        <div class="action-icon">📦</div>
                        <div class="action-text">
                            <div class="action-name">我的订单</div>
                            <div class="action-desc">查看我的物流订单</div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/orders/add" class="action-btn">
                        <div class="action-icon">➕</div>
                        <div class="action-text">
                            <div class="action-name">我要寄件</div>
                            <div class="action-desc">创建新的寄件订单</div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/cargo_items" class="action-btn">
                        <div class="action-icon">📦</div>
                        <div class="action-text">
                            <div class="action-name">货物追踪</div>
                            <div class="action-desc">追踪货物运输状态</div>
                        </div>
                    </a>
                    <a href="${pageContext.request.contextPath}/cost_details" class="action-btn">
                        <div class="action-icon">💰</div>
                        <div class="action-text">
                            <div class="action-name">费用查询</div>
                            <div class="action-desc">查询订单费用明细</div>
                        </div>
                    </a>
                </c:when>
            </c:choose>
        </div>
    </div>
</div>

<script>
    // 格式化日期
    function formatDate() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const weekDays = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
        const weekDay = weekDays[now.getDay()];
        return year + '年' + month + '月' + day + '日 ' + weekDay;
    }

    // 退出登录函数
    function logout() {
        console.log('退出登录按钮被点击');
        var contextPath = '${pageContext.request.contextPath}';

        if (confirm('确定要退出登录吗？')) {
            fetch(contextPath + '/api/users/logout', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                credentials: 'include'
            })
                .then(response => {
                    window.location.href = contextPath + '/login';
                })
                .catch(error => {
                    window.location.href = contextPath + '/login';
                });
        }
    }

    // 轮播图功能
    let currentSlide = 0;
    const slides = document.querySelectorAll('.carousel-item');
    const indicators = document.querySelectorAll('.carousel-indicator');
    let slideInterval;

    // 初始化轮播图
    function initCarousel() {
        // 自动轮播
        slideInterval = setInterval(nextSlide, 5000);

        // 鼠标悬停时暂停轮播
        const carousel = document.querySelector('.carousel');
        carousel.addEventListener('mouseenter', () => {
            clearInterval(slideInterval);
        });

        carousel.addEventListener('mouseleave', () => {
            slideInterval = setInterval(nextSlide, 5000);
        });
    }

    // 切换到指定幻灯片
    function goToSlide(n) {
        // 移除当前激活状态
        slides[currentSlide].classList.remove('active');
        indicators[currentSlide].classList.remove('active');

        // 更新当前索引
        currentSlide = (n + slides.length) % slides.length;

        // 添加新的激活状态
        slides[currentSlide].classList.add('active');
        indicators[currentSlide].classList.add('active');

        // 重置自动轮播计时器
        clearInterval(slideInterval);
        slideInterval = setInterval(nextSlide, 5000);
    }

    // 下一张幻灯片
    function nextSlide() {
        goToSlide(currentSlide + 1);
    }

    // 上一张幻灯片
    function prevSlide() {
        goToSlide(currentSlide - 1);
    }

    // 加载统计数据的函数（管理员专用）
    function loadStatistics() {
        // 这里应该从后端API获取真实数据
        // 现在先用模拟数据
        document.getElementById('orderCount').textContent = '25';
        document.getElementById('vehicleCount').textContent = '12';
        document.getElementById('driverCount').textContent = '8';
        document.getElementById('cargoCount').textContent = '156';
    }

    // 页面加载完成后执行
    window.onload = function() {
        // 设置日期
        document.querySelector('.welcome-text span').textContent = formatDate();

        // 初始化轮播图
        initCarousel();

        // 如果是管理员，加载统计数据
        <c:if test="${userType == 1}">
        loadStatistics();
        </c:if>

        // 图片加载失败时显示备用内容
        const images = document.querySelectorAll('.carousel-img');
        images.forEach((img, index) => {
            img.onerror = function() {
                console.log('图片加载失败:', this.src);
                const colors = ['#667eea', '#764ba2', '#f5576c'];
                const titles = ['高效物流运输', '智能仓储管理', '优质客户服务'];
                const descs = [
                    '专业团队，安全准时送达',
                    '现代化仓储，高效管理您的货物',
                    '24小时在线，全程跟踪'
                ];

                this.style.backgroundColor = colors[index];
                this.style.display = 'flex';
                this.style.alignItems = 'center';
                this.style.justifyContent = 'center';
                this.style.color = 'white';
                this.style.fontSize = '24px';
                this.style.fontWeight = 'bold';
                this.innerHTML = titles[index];

                // 更新标题
                const caption = this.parentElement.querySelector('.carousel-caption');
                if (caption) {
                    caption.querySelector('h3').textContent = titles[index];
                    caption.querySelector('p').textContent = descs[index];
                }
            };
        });
    };
</script>
</body>
</html>
