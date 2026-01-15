package jmu.fyl.logistics.controller.web;

import jmu.fyl.logistics.entity.User;
import jmu.fyl.logistics.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class BaseController {

    @Autowired
    protected UserService userService;

    protected User currentUser;

    @ModelAttribute
    public void initCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            currentUser = (User) session.getAttribute("user");
        }
    }

    // 添加一个方法让子类可以访问currentUser
    public User getCurrentUser() {
        return currentUser;
    }

    public void setCurrentUser(User user) {
        this.currentUser = user;
    }
}