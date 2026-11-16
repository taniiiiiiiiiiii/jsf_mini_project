<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.citycare.model.User" %>
<%@ page import="com.citycare.model.DashboardStats" %>
<%@ page import="com.citycare.model.Complaint" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
    List<Complaint> complaints = (List<Complaint>) request.getAttribute("complaints");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Command Center – CityCare</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

    <div class="dashboard-layout">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="brand-icon" style="background: linear-gradient(135deg, #1e3a8a, #7c3aed);"><i class="fa-solid fa-shield-halved"></i></div>
                <div>
                    <div class="sidebar-brand-name">City<span>Care</span></div>
                    <span class="sidebar-role-badge" style="background: #4c1d95; color: #e9d5ff;">Admin Command</span>
                </div>
            </div>

            <ul class="sidebar-nav">
                <li class="sidebar-section-title">Administration</li>
                <li>
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="sidebar-link active">
                        <span class="sidebar-icon"><i class="fa-solid fa-chart-pie"></i></span>
                        <span>Overview</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/admin/complaints" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-list-check"></i></span>
                        <span>All Complaints</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/admin/citizens" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-users"></i></span>
                        <span>Registered Citizens</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/admin/officers" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-user-tie"></i></span>
                        <span>Municipal Officers</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/track" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-magnifying-glass"></i></span>
                        <span>Track Reference</span>
                    </a>
                </li>
            </ul>

            <div class="sidebar-footer">
                <div class="user-profile-pill">
                    <div class="user-avatar" style="background: linear-gradient(135deg, #4f46e5, #7c3aed);">
                        A
                    </div>
                    <div class="user-details">
                        <div class="user-name"><%= user.getFullName() %></div>
                        <div class="user-email">System Administrator</div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Body -->
        <main class="main-content">
            <header class="topbar">
                <div class="topbar-left">
                    <h1 class="page-title">City-Wide Grievance Command Center</h1>
                </div>
                <div class="topbar-right">
                    <a href="<%= request.getContextPath() %>/admin/complaints" class="btn btn-primary btn-sm">
                        <i class="fa-solid fa-sliders"></i> Manage All Complaints
                    </a>
                    <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
                    </a>
                </div>
            </header>

            <div class="content-body">

                <!-- Alert Messages -->
                <% 
                    String success = (String) session.getAttribute("successMessage");
                    if (success != null) session.removeAttribute("successMessage");
                    String error = (String) session.getAttribute("errorMessage");
                    if (error != null) session.removeAttribute("errorMessage");
                %>
                <% if (success != null) { %>
                    <div class="alert alert-success">
                        <span><i class="fa-solid fa-circle-check"></i> <%= success %></span>
                        <button type="button" class="alert-close">&times;</button>
                    </div>
                <% } %>
                <% if (error != null) { %>
                    <div class="alert alert-danger">
                        <span><i class="fa-solid fa-circle-exclamation"></i> <%= error %></span>
                        <button type="button" class="alert-close">&times;</button>
                    </div>
                <% } %>

                <!-- 8 High-Visibility Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon-wrapper stat-icon-primary">
                            <i class="fa-solid fa-bullhorn"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value"><%= stats != null ? stats.getTotalComplaints() : 0 %></div>
                            <div class="stat-label">Total Complaints</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon-wrapper stat-icon-warning">
                            <i class="fa-solid fa-clock"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value"><%= stats != null ? stats.getPendingComplaints() : 0 %></div>
                            <div class="stat-label">Pending Review</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon-wrapper stat-icon-info">
                            <i class="fa-solid fa-screwdriver-wrench"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value"><%= stats != null ? (stats.getAssignedComplaints() + stats.getInProgressComplaints()) : 0 %></div>
                            <div class="stat-label">Active Remediation</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon-wrapper stat-icon-success">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value"><%= stats != null ? stats.getResolvedComplaints() : 0 %></div>
                            <div class="stat-label">Resolved Grievances</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon-wrapper stat-icon-danger">
                            <i class="fa-solid fa-circle-xmark"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value"><%= stats != null ? stats.getRejectedComplaints() : 0 %></div>
                            <div class="stat-label">Rejected / Invalid</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon-wrapper" style="background: #fdf2f8; color: #db2777;">
                            <i class="fa-solid fa-users"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value"><%= stats != null ? stats.getTotalCitizens() : 0 %></div>
                            <div class="stat-label">Registered Citizens</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon-wrapper" style="background: #f5f3ff; color: #7c3aed;">
                            <i class="fa-solid fa-user-tie"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value"><%= stats != null ? stats.getTotalOfficers() : 0 %></div>
                            <div class="stat-label">Municipal Officers</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon-wrapper" style="background: #ecfdf5; color: #059669;">
                            <i class="fa-solid fa-building-columns"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value"><%= stats != null ? stats.getTotalDepartments() : 5 %></div>
                            <div class="stat-label">Active Departments</div>
                        </div>
                    </div>
                </div>

                <!-- Recent City Complaints Feed -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fa-solid fa-wave-square" style="color: var(--primary);"></i> Live Municipal Complaint Feed
                        </h2>
                        <a href="<%= request.getContextPath() %>/admin/complaints" class="btn btn-outline btn-sm">
                            Inspect All Records <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="table-responsive">
                            <table class="custom-table">
                                <thead>
                                    <tr>
                                        <th>Tracking ID</th>
                                        <th>Title & Category</th>
                                        <th>Citizen</th>
                                        <th>Department</th>
                                        <th>Assigned Officer</th>
                                        <th>Priority</th>
                                        <th>Status</th>
                                        <th>Date</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (complaints != null && !complaints.isEmpty()) { 
                                        int count = 0;
                                        for (Complaint c : complaints) {
                                            if (count++ >= 8) break;
                                            String statusBadgeClass = "badge-submitted";
                                            String st = c.getStatus().toLowerCase();
                                            if (st.contains("review")) statusBadgeClass = "badge-under-review";
                                            else if (st.contains("assigned")) statusBadgeClass = "badge-assigned";
                                            else if (st.contains("progress")) statusBadgeClass = "badge-in-progress";
                                            else if (st.contains("resolved")) statusBadgeClass = "badge-resolved";
                                            else if (st.contains("rejected")) statusBadgeClass = "badge-rejected";

                                            String priorityClass = "priority-medium";
                                            if ("Low".equalsIgnoreCase(c.getPriority())) priorityClass = "priority-low";
                                            else if ("High".equalsIgnoreCase(c.getPriority())) priorityClass = "priority-high";
                                            else if ("Urgent".equalsIgnoreCase(c.getPriority())) priorityClass = "priority-urgent";
                                    %>
                                        <tr>
                                            <td>
                                                <span class="tracking-code"><%= c.getTrackingId() %></span>
                                            </td>
                                            <td>
                                                <div style="font-weight: 700; color: var(--slate-900);"><%= c.getTitle() %></div>
                                                <span style="font-size: 0.8rem; color: var(--slate-500);"><%= c.getCategory() %></span>
                                            </td>
                                            <td>
                                                <div style="font-weight: 600;"><%= c.getCitizenName() %></div>
                                                <span style="font-size: 0.75rem; color: var(--slate-500);"><%= c.getCitizenPhone() %></span>
                                            </td>
                                            <td><%= c.getDepartmentName() != null ? c.getDepartmentName() : "<span style='color: var(--warning); font-weight:600;'>Pending Dept</span>" %></td>
                                            <td><%= c.getAssignedOfficerName() != null ? c.getAssignedOfficerName() : "<span style='color: var(--slate-400);'>Unassigned</span>" %></td>
                                            <td>
                                                <span class="priority-pill <%= priorityClass %>"><%= c.getPriority() %></span>
                                            </td>
                                            <td>
                                                <span class="badge <%= statusBadgeClass %>"><%= c.getStatus() %></span>
                                            </td>
                                            <td><%= sdf.format(c.getCreatedAt()) %></td>
                                            <td>
                                                <a href="<%= request.getContextPath() %>/admin/complaint-details?id=<%= c.getComplaintId() %>" class="btn btn-outline btn-sm">
                                                    <i class="fa-solid fa-sliders"></i> Manage
                                                </a>
                                            </td>
                                        </tr>
                                    <%  } 
                                    } else { %>
                                        <tr>
                                            <td colspan="9" style="text-align: center; padding: 3rem; color: var(--slate-500);">
                                                No complaints registered in the database.
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>

