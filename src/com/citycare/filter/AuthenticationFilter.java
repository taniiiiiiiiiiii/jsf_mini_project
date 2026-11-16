package com.citycare.filter;

import com.citycare.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {"/citizen/*", "/officer/*", "/admin/*"})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // Prevent client-side caching of secured dashboard pages
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        String path = req.getRequestURI();
        String contextPath = req.getContextPath();
        String relativePath = path.substring(contextPath.length());

        if (user == null) {
            req.getSession(true).setAttribute("errorMessage", "Please log in to access this page.");
            res.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        if ("INACTIVE".equalsIgnoreCase(user.getStatus())) {
            session.invalidate();
            req.getSession(true).setAttribute("errorMessage", "Your account has been deactivated. Please contact administration.");
            res.sendRedirect(contextPath + "/login.jsp");
            return;
        }

        String role = user.getRole();

        if (relativePath.startsWith("/citizen/")) {
            if (!"CITIZEN".equalsIgnoreCase(role)) {
                redirectToRoleDashboard(res, contextPath, role);
                return;
            }
        } else if (relativePath.startsWith("/officer/")) {
            if (!"OFFICER".equalsIgnoreCase(role)) {
                redirectToRoleDashboard(res, contextPath, role);
                return;
            }
        } else if (relativePath.startsWith("/admin/")) {
            if (!"ADMIN".equalsIgnoreCase(role)) {
                redirectToRoleDashboard(res, contextPath, role);
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private void redirectToRoleDashboard(HttpServletResponse res, String contextPath, String role) throws IOException {
        if ("ADMIN".equalsIgnoreCase(role)) {
            res.sendRedirect(contextPath + "/admin/dashboard");
        } else if ("OFFICER".equalsIgnoreCase(role)) {
            res.sendRedirect(contextPath + "/officer/dashboard");
        } else {
            res.sendRedirect(contextPath + "/citizen/dashboard");
        }
    }

    @Override
    public void destroy() {
    }
}

