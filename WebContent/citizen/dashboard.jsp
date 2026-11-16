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
    <title>Citizen Dashboard – CityCare</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

    <div class="dashboard-layout">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="brand-icon"><i class="fa-solid fa-city"></i></div>
                <div>
                    <div class="sidebar-brand-name">City<span>Care</span></div>
                    <span class="sidebar-role-badge">Citizen Portal</span>
                </div>
            </div>

            <ul class="sidebar-nav">
                <li class="sidebar-section-title">Navigation</li>
                <li>
                    <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link active">
                        <span class="sidebar-icon"><i class="fa-solid fa-gauge-high"></i></span>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/citizen/submit-complaint" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-file-circle-plus"></i></span>
                        <span>Submit Complaint</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/citizen/my-complaints" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-list-check"></i></span>
                        <span>My Complaints</span>
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
                    <div class="user-avatar"><%= user.getFullName().substring(0, 1).toUpperCase() %></div>
                    <div class="user-details">
                        <div class="user-name"><%= user.getFullName() %></div>
                        <div class="user-email"><%= user.getEmail() %></div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Body -->
        <main class="main-content">
            <header class="topbar">
                <div class="topbar-left">
                    <h1 class="page-title">Citizen Dashboard</h1>
                </div>
                <div class="topbar-right">
                    <a href="<%= request.getContextPath() %>/citizen/submit-complaint" class="btn btn-primary btn-sm">
                        <i class="fa-solid fa-plus"></i> Report Issue
                    </a>
                    <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i> Logout
                    </a>
                </div>
            </header>

            <div class="content-body">

                <!-- Alert Banners -->
                <% 
                    String success = (String) session.getAttribute("successMessage");
                    if (success != null) {
                        session.removeAttribute("successMessage");
                    }
                    String error = (String) session.getAttribute("errorMessage");
                    if (error != null) {
                        session.removeAttribute("errorMessage");
                    }
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

                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon-wrapper stat-icon-primary">
                            <i class="fa-solid fa-file-invoice"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value"><%= stats != null ? stats.getTotalComplaints() : 0 %></div>
                            <div class="stat-label">Total Submitted</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon-wrapper stat-icon-warning">
                            <i class="fa-solid fa-hourglass-half"></i>
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
                            <div class="stat-label">In Progress</div>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-icon-wrapper stat-icon-success">
                            <i class="fa-solid fa-circle-check"></i>
                        </div>
                        <div class="stat-info">
                            <div class="stat-value"><%= stats != null ? stats.getResolvedComplaints() : 0 %></div>
                            <div class="stat-label">Resolved Issues</div>
                        </div>
                    </div>
                </div>

                <!-- Recent Complaints Table -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">
                            <i class="fa-solid fa-clock-rotate-left" style="color: var(--primary);"></i> My Recent Complaints
                        </h2>
                        <a href="<%= request.getContextPath() %>/citizen/my-complaints" class="btn btn-outline btn-sm">
                            View All My Complaints <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                    <div class="card-body" style="padding: 0;">
                        <div class="table-responsive">
                            <table class="custom-table">
                                <thead>
                                    <tr>
                                        <th>Tracking ID</th>
                                        <th>Title & Category</th>
                                        <th>Location</th>
                                        <th>Date</th>
                                        <th>Status</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% if (complaints != null && !complaints.isEmpty()) { 
                                        int count = 0;
                                        for (Complaint c : complaints) {
                                            if (count++ >= 6) break;
                                            String statusBadgeClass = "badge-submitted";
                                            String st = c.getStatus().toLowerCase();
                                            if (st.contains("review")) statusBadgeClass = "badge-under-review";
                                            else if (st.contains("assigned")) statusBadgeClass = "badge-assigned";
                                            else if (st.contains("progress")) statusBadgeClass = "badge-in-progress";
                                            else if (st.contains("resolved")) statusBadgeClass = "badge-resolved";
                                            else if (st.contains("rejected")) statusBadgeClass = "badge-rejected";
                                    %>
                                        <tr>
                                            <td>
                                                <span class="tracking-code"><%= c.getTrackingId() %></span>
                                            </td>
                                            <td>
                                                <div style="font-weight: 700; color: var(--slate-900);"><%= c.getTitle() %></div>
                                                <span style="font-size: 0.8rem; color: var(--slate-500);"><%= c.getCategory() %></span>
                                            </td>
                                            <td><i class="fa-solid fa-location-dot" style="color: var(--danger); font-size: 0.8rem;"></i> <%= c.getLocation() %></td>
                                            <td><%= sdf.format(c.getCreatedAt()) %></td>
                                            <td>
                                                <span class="badge <%= statusBadgeClass %>"><%= c.getStatus() %></span>
                                            </td>
                                            <td>
                                                <a href="<%= request.getContextPath() %>/citizen/complaint-details?id=<%= c.getComplaintId() %>" class="btn btn-outline btn-sm">
                                                    <i class="fa-solid fa-eye"></i> Details
                                                </a>
                                            </td>
                                        </tr>
                                    <%  } 
                                    } else { %>
                                        <tr>
                                            <td colspan="6" style="text-align: center; padding: 3rem; color: var(--slate-500);">
                                                <i class="fa-solid fa-inbox" style="font-size: 2.5rem; color: var(--slate-300); margin-bottom: 0.75rem; display: block;"></i>
                                                You haven't submitted any civic complaints yet.
                                                <div style="margin-top: 1rem;">
                                                    <a href="<%= request.getContextPath() %>/citizen/submit-complaint" class="btn btn-primary btn-sm">
                                                        <i class="fa-solid fa-plus"></i> Submit First Complaint
                                                    </a>
                                                </div>
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

