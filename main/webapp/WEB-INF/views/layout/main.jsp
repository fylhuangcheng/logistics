<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>物流管理系统 - ${pageTitle}</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <!-- 自定义样式 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- 自定义JS -->
    <script src="${pageContext.request.contextPath}/static/js/utils.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/main.js"></script>

    <script>
        const CONTEXT_PATH = "${pageContext.request.contextPath}";
    </script>
</head>
<body>
<!-- 导航栏 -->
<%@ include file="header.jsp" %>

<!-- 修改后的侧边栏和主内容区域 -->
<div class="container-fluid">
    <div class="row flex-nowrap"> <!-- 添加 flex-nowrap 防止换行 -->
        <!-- 侧边栏 -->
        <c:if test="${not empty sessionScope.user}">
            <div class="col-auto col-md-3 col-lg-2 px-0">
                <div class="sidebar">
                    <%@ include file="sidebar.jsp" %>
                </div>
            </div>
        </c:if>

        <!-- 主内容区 -->
        <main class="${not empty sessionScope.user ? 'col-md-9 col-lg-10' : 'col-12'} p-4">
            <!-- 面包屑导航 -->
            <c:if test="${not empty sessionScope.user and not empty breadcrumb}">
                <nav aria-label="breadcrumb" class="mb-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">首页</a></li>
                        <c:forEach items="${breadcrumb}" var="item">
                            <c:choose>
                                <c:when test="${not empty item.url}">
                                    <li class="breadcrumb-item"><a href="${item.url}">${item.name}</a></li>
                                </c:when>
                                <c:otherwise>
                                    <li class="breadcrumb-item active" aria-current="page">${item.name}</li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </ol>
                </nav>
            </c:if>

            <!-- 页面标题 -->
            <c:if test="${not empty sessionScope.user}">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">${pageTitle}</h1>
                    <c:if test="${not empty pageActions}">
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <c:forEach items="${pageActions}" var="action">
                                <a href="${action.url}" class="btn btn-sm ${action.cssClass} me-2">
                                    <i class="${action.icon}"></i> ${action.text}
                                </a>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </c:if>

            <!-- 内容区域 -->
            <div id="content">
                <jsp:include page="/WEB-INF/views/${contentPage}" />
            </div>

            <!-- 页脚 -->
            <c:if test="${not empty sessionScope.user}">
                <%@ include file="footer.jsp" %>
            </c:if>
        </main>
    </div>
</div>

<!-- 全局消息提示框 -->
<div class="toast-container position-fixed bottom-0 end-0 p-3">
    <div id="globalToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header">
            <strong class="me-auto">系统提示</strong>
            <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body"></div>
    </div>
</div>

<!-- 加载遮罩 -->
<div id="loadingOverlay" class="d-none position-fixed top-0 left-0 w-100 h-100 bg-dark bg-opacity-50 d-flex justify-content-center align-items-center" style="z-index: 9999;">
    <div class="spinner-border text-primary" role="status">
        <span class="visually-hidden">加载中...</span>
    </div>
    <span class="ms-3 text-white">加载中...</span>
</div>
</body>
</html>