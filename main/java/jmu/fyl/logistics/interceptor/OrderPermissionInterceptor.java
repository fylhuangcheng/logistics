package jmu.fyl.logistics.interceptor;

import jmu.fyl.logistics.entity.User;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 订单权限拦截器
 * 限制客户用户（userType == 3）不能删除和编辑订单
 */
@Component
public class OrderPermissionInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 获取请求路径
        String requestURI = request.getRequestURI();
        System.out.println("订单权限拦截器拦截路径: " + requestURI);

        // 检查是否是订单相关的删除或编辑操作
        if (isOrderEditOrDeleteRequest(requestURI)) {
            // 获取会话中的用户信息
            HttpSession session = request.getSession(false);
            if (session == null) {
                // 未登录，跳转到登录页
                response.sendRedirect(request.getContextPath() + "/login");
                return false;
            }

            // 获取用户信息
            User user = (User) session.getAttribute("user");
            Integer userType = (Integer) session.getAttribute("userType");

            // 如果无法从user对象获取，尝试从session直接获取
            if (userType == null && user != null) {
                userType = user.getUserType();
            }

            System.out.println("当前用户类型: " + userType);
            System.out.println("当前用户: " + (user != null ? user.getUsername() : "null"));

            // 检查是否是客户用户（userType == 3）
            if (userType != null && userType == 3) {
                // 客户用户，禁止删除和编辑订单
                System.out.println("客户用户尝试操作订单，已被拦截");

                // 设置错误信息
                request.setAttribute("errorMessage", "对不起，客户用户无法执行此操作");

                // 如果是AJAX请求，返回JSON错误
                if (isAjaxRequest(request)) {
                    response.setContentType("application/json;charset=UTF-8");
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.getWriter().write("{\"code\":403,\"message\":\"客户用户无法执行此操作\"}");
                    return false;
                }

                // 如果是普通请求，重定向到订单列表并显示错误
                response.sendRedirect(request.getContextPath() + "/orders?error=客户用户无法执行此操作");
                return false;
            }
        }

        return true; // 放行请求
    }

    /**
     * 判断是否是订单的编辑或删除请求
     */
    private boolean isOrderEditOrDeleteRequest(String requestURI) {
        // 匹配以下模式：
        // 1. /orders/{id}/edit (编辑订单页面)
        // 2. POST /orders/{id}/edit (提交编辑)
        // 3. PUT /orders/{id} (API更新订单)
        // 4. POST /orders/{id}/delete (删除订单)
        // 5. DELETE /api/orders/{id} (API删除订单)
        // 6. /orders/{id}/update-status (更新状态)
        // 7. /orders/{id}/assign-vehicle (分配车辆)

        return requestURI.matches(".*/orders/\\d+/edit($|/.*)") ||  // 编辑页面
                requestURI.matches(".*/api/orders/\\d+$") &&         // API操作单个订单
                        ("PUT".equalsIgnoreCase(getCurrentMethod()) || "DELETE".equalsIgnoreCase(getCurrentMethod())) || // PUT/DELETE操作
                requestURI.matches(".*/orders/\\d+/delete.*") ||      // 删除操作
                requestURI.matches(".*/orders/\\d+/update-status.*") || // 更新状态
                requestURI.matches(".*/orders/\\d+/assign-vehicle.*");   // 分配车辆
    }

    /**
     * 判断是否是AJAX请求
     */
    private boolean isAjaxRequest(HttpServletRequest request) {
        return "XMLHttpRequest".equals(request.getHeader("X-Requested-With")) ||
                "application/json".equals(request.getHeader("Content-Type")) ||
                request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json");
    }

    /**
     * 获取当前请求方法（需要从请求中获取）
     * 注意：这个方法需要在配置中配合HiddenHttpMethodFilter使用
     */
    private String getCurrentMethod() {
        // 实际使用时，这个方法应该从ThreadLocal或Request中获取
        // 这里简化处理，实际项目需要更复杂的逻辑
        return org.springframework.web.context.request.RequestContextHolder
                .getRequestAttributes() != null ?
                ((org.springframework.web.context.request.ServletRequestAttributes)
                        org.springframework.web.context.request.RequestContextHolder
                                .getRequestAttributes()).getRequest().getMethod() : "GET";
    }
}