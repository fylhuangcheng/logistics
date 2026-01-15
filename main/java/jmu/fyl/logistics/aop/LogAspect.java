package jmu.fyl.logistics.aop;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Arrays;



@Aspect //切面类
@Component
public class LogAspect {

    private static final Logger logger = LoggerFactory.getLogger(LogAspect.class);

    @Pointcut("execution(* jmu.fyl.logistics.controller..*.*(..))")
    public void controllerLog() {}

    @Before("controllerLog()")
    public void doBefore(JoinPoint joinPoint) {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes != null) {
            HttpServletRequest request = attributes.getRequest();

            // 记录请求内容
            logger.info("========== 请求开始 ==========");
            logger.info("URL: {}", request.getRequestURL().toString());
            logger.info("HTTP方法: {}", request.getMethod());
            logger.info("IP地址: {}", request.getRemoteAddr());
            logger.info("类方法: {}.{}",
                    joinPoint.getSignature().getDeclaringTypeName(),
                    joinPoint.getSignature().getName());
            logger.info("请求参数: {}", Arrays.toString(joinPoint.getArgs()));

            // 记录用户信息
            HttpSession session = request.getSession(false);  // 改为false，不自动创建session
            if (session != null) {
                Object user = session.getAttribute("user");
                if (user != null) {
                    logger.info("操作用户: {}", user);
                }
            }
        }
    }

    @AfterReturning(pointcut = "controllerLog()", returning = "result")
    public void doAfterReturning(Object result) {
        logger.info("返回结果: {}", result);
        logger.info("========== 请求结束 ==========");
    }

    @AfterThrowing(pointcut = "controllerLog()", throwing = "exception")
    public void doAfterThrowing(Throwable exception) {
        logger.error("发生异常: {}", exception.getMessage());
        logger.error("异常堆栈: ", exception);
        logger.info("========== 请求异常结束 ==========");
    }
}