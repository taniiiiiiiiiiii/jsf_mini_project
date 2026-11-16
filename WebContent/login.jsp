<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – CityCare Smart City Portal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

    <div class="auth-wrapper">
        <div class="auth-card">
            <div class="auth-header">
                <div class="brand-icon" style="margin: 0 auto 0.75rem;"><i class="fa-solid fa-city"></i></div>
                <h2>CityCare Portal Login</h2>
                <p>Select your user role and enter credentials to proceed</p>
            </div>

            <div class="auth-body">

                <!-- Alert Messages -->
                <% 
                    String error = (String) request.getAttribute("errorMessage");
                    if (error == null) {
                        error = (String) session.getAttribute("errorMessage");
                        session.removeAttribute("errorMessage");
                    }
                    String success = (String) session.getAttribute("successMessage");
                    if (success != null) {
                        session.removeAttribute("successMessage");
                    }
                %>

                <% if (error != null) { %>
                    <div class="alert alert-danger">
                        <span><i class="fa-solid fa-circle-exclamation"></i> <%= error %></span>
                        <button type="button" class="alert-close">&times;</button>
                    </div>
                <% } %>

                <% if (success != null) { %>
                    <div class="alert alert-success">
                        <span><i class="fa-solid fa-circle-check"></i> <%= success %></span>
                        <button type="button" class="alert-close">&times;</button>
                    </div>
                <% } %>

                <% if ("true".equals(request.getParameter("logout"))) { %>
                    <div class="alert alert-info">
                        <span><i class="fa-solid fa-info-circle"></i> You have logged out successfully.</span>
                        <button type="button" class="alert-close">&times;</button>
                    </div>
                <% } %>

                <!-- Role Switcher Tabs -->
                <div class="role-switcher-tabs">
                    <button type="button" class="role-tab-btn active" data-role="CITIZEN" onclick="selectRole('CITIZEN')">
                        <i class="fa-solid fa-user"></i> Citizen
                    </button>
                    <button type="button" class="role-tab-btn" data-role="OFFICER" onclick="selectRole('OFFICER')">
                        <i class="fa-solid fa-user-shield"></i> Officer
                    </button>
                    <button type="button" class="role-tab-btn" data-role="ADMIN" onclick="selectRole('ADMIN')">
                        <i class="fa-solid fa-user-gear"></i> Administrator
                    </button>
                </div>

                <form action="<%= request.getContextPath() %>/login" method="post">
                    <input type="hidden" name="role" id="role" value="CITIZEN">

                    <div class="form-group">
                        <label class="form-label" for="email">Email Address <span class="required">*</span></label>
                        <input type="email" id="email" name="email" class="form-control" placeholder="name@example.com" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required autofocus>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="password">Password <span class="required">*</span></label>
                        <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; padding: 0.75rem; font-size: 1rem; margin-top: 0.5rem;">
                        <i class="fa-solid fa-right-to-bracket"></i> Sign In to CityCare
                    </button>
                </form>

                <div style="margin-top: 1.25rem; text-align: center; font-size: 0.9rem;">
                    Don't have a citizen account? <a href="<%= request.getContextPath() %>/register.jsp" style="font-weight: 700;">Register as Citizen</a>
                </div>

                <!-- One-Click Demo Account Login Helper -->
                <div class="demo-account-chips">
                    <div class="demo-chips-title"><i class="fa-solid fa-flask"></i> Quick Demo Logins (Evaluation)</div>
                    <div class="chips-container">
                        <button type="button" class="chip-btn" onclick="fillDemoAccount('ADMIN', 'admin@citycare.gov', 'Admin@123')">
                            👑 Admin Demo
                        </button>
                        <button type="button" class="chip-btn" onclick="fillDemoAccount('OFFICER', 'officer.roads@citycare.gov', 'Officer@123')">
                            🚧 Roads Officer
                        </button>
                        <button type="button" class="chip-btn" onclick="fillDemoAccount('OFFICER', 'officer.sanitation@citycare.gov', 'Officer@123')">
                            🧹 Sanitation Officer
                        </button>
                        <button type="button" class="chip-btn" onclick="fillDemoAccount('CITIZEN', 'citizen@citycare.gov', 'Citizen@123')">
                            👤 Citizen Demo
                        </button>
                    </div>
                </div>

                <div style="text-align: center; margin-top: 1.5rem;">
                    <a href="<%= request.getContextPath() %>/" style="font-size: 0.85rem; color: var(--slate-500);">
                        <i class="fa-solid fa-arrow-left"></i> Back to Homepage
                    </a>
                </div>

            </div>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
    <script>
        function selectRole(role) {
            document.getElementById('role').value = role;
            const tabs = document.querySelectorAll('.role-tab-btn');
            tabs.forEach(tab => {
                if (tab.getAttribute('data-role') === role) {
                    tab.classList.add('active');
                } else {
                    tab.classList.remove('active');
                }
            });
        }
    </script>
</body>
</html>

