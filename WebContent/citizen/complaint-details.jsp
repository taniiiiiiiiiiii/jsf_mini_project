<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.citycare.model.User" %>
<%@ page import="com.citycare.model.Complaint" %>
<%@ page import="com.citycare.model.ComplaintHistory" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    Complaint complaint = (Complaint) request.getAttribute("complaint");
    List<ComplaintHistory> history = (List<ComplaintHistory>) request.getAttribute("history");
    SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy, hh:mm a");

    String statusBadgeClass = "badge-submitted";
    String st = complaint.getStatus().toLowerCase();
    if (st.contains("review")) statusBadgeClass = "badge-under-review";
    else if (st.contains("assigned")) statusBadgeClass = "badge-assigned";
    else if (st.contains("progress")) statusBadgeClass = "badge-in-progress";
    else if (st.contains("resolved")) statusBadgeClass = "badge-resolved";
    else if (st.contains("rejected")) statusBadgeClass = "badge-rejected";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint <%= complaint.getTrackingId() %> – CityCare</title>
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
                    <a href="<%= request.getContextPath() %>/citizen/dashboard" class="sidebar-link">
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
                    <a href="<%= request.getContextPath() %>/citizen/my-complaints" class="sidebar-link active">
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
                    <h1 class="page-title">Complaint Overview</h1>
                </div>
                <div class="topbar-right">
                    <a href="<%= request.getContextPath() %>/citizen/my-complaints" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-arrow-left"></i> Back to List
                    </a>
                </div>
            </header>

            <div class="content-body" style="max-width: 960px;">

                <% 
                    String success = (String) session.getAttribute("successMessage");
                    if (success != null) {
                        session.removeAttribute("successMessage");
                    }
                %>
                <% if (success != null) { %>
                    <div class="alert alert-success">
                        <span><i class="fa-solid fa-circle-check"></i> <%= success %></span>
                        <button type="button" class="alert-close">&times;</button>
                    </div>
                <% } %>

                <div class="card">
                    <div class="card-header">
                        <div>
                            <span class="tracking-code" style="font-size: 0.95rem;"><%= complaint.getTrackingId() %></span>
                            <h2 style="font-size: 1.35rem; font-weight: 800; margin-top: 0.35rem; color: var(--slate-900);"><%= complaint.getTitle() %></h2>
                        </div>
                        <div>
                            <span class="badge <%= statusBadgeClass %>" style="font-size: 0.9rem; padding: 0.4rem 0.85rem;">
                                <%= complaint.getStatus() %>
                            </span>
                        </div>
                    </div>

                    <div class="card-body">
                        <!-- Key Metadata Grid -->
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-bottom: 1.5rem; background: var(--slate-50); padding: 1.25rem; border-radius: var(--radius); border: 1px solid var(--slate-200);">
                            <div>
                                <span style="font-size: 0.78rem; text-transform: uppercase; color: var(--slate-400); font-weight: 700;">Category</span>
                                <div style="font-weight: 700; color: var(--slate-800);"><%= complaint.getCategory() %></div>
                            </div>
                            <div>
                                <span style="font-size: 0.78rem; text-transform: uppercase; color: var(--slate-400); font-weight: 700;">Department</span>
                                <div style="font-weight: 700; color: var(--slate-800);"><%= complaint.getDepartmentName() != null ? complaint.getDepartmentName() : "Under Review" %></div>
                            </div>
                            <div>
                                <span style="font-size: 0.78rem; text-transform: uppercase; color: var(--slate-400); font-weight: 700;">Assigned Officer</span>
                                <div style="font-weight: 600; color: var(--slate-800);"><%= complaint.getAssignedOfficerName() != null ? complaint.getAssignedOfficerName() : "<span style='color: var(--slate-400);'>Unassigned</span>" %></div>
                            </div>
                            <div>
                                <span style="font-size: 0.78rem; text-transform: uppercase; color: var(--slate-400); font-weight: 700;">Location</span>
                                <div style="font-weight: 600; color: var(--slate-800);"><i class="fa-solid fa-location-dot" style="color: var(--danger);"></i> <%= complaint.getLocation() %></div>
                            </div>
                            <div>
                                <span style="font-size: 0.78rem; text-transform: uppercase; color: var(--slate-400); font-weight: 700;">Submitted On</span>
                                <div style="font-weight: 600; color: var(--slate-700);"><%= sdf.format(complaint.getCreatedAt()) %></div>
                            </div>
                            <div>
                                <span style="font-size: 0.78rem; text-transform: uppercase; color: var(--slate-400); font-weight: 700;">Urgency</span>
                                <div style="font-weight: 600; color: var(--slate-700);"><%= complaint.getPriority() %></div>
                            </div>
                        </div>

                        <!-- Description Box -->
                        <div style="margin-bottom: 1.5rem;">
                            <h4 style="font-size: 0.95rem; font-weight: 700; margin-bottom: 0.4rem; color: var(--slate-800);">Grievance Description</h4>
                            <div style="color: var(--slate-700); white-space: pre-line; background: #fff; border: 1px solid var(--slate-200); padding: 1rem; border-radius: var(--radius);"><%= complaint.getDescription() %></div>
                        </div>

                        <!-- Evidence Photo (if available) -->
                        <% if (complaint.getImagePath() != null && !complaint.getImagePath().trim().isEmpty()) { %>
                            <div style="margin-bottom: 1.75rem;">
                                <h4 style="font-size: 0.95rem; font-weight: 700; margin-bottom: 0.5rem; color: var(--slate-800);">Attached Photo Evidence</h4>
                                <a href="<%= request.getContextPath() %>/view-image?file=<%= complaint.getImagePath() %>" target="_blank">
                                    <img src="<%= request.getContextPath() %>/view-image?file=<%= complaint.getImagePath() %>" alt="Photo Evidence" style="max-width: 100%; max-height: 350px; border-radius: var(--radius); border: 1px solid var(--slate-300); box-shadow: var(--shadow-sm);">
                                </a>
                                <span class="form-hint">Click image to view in full resolution.</span>
                            </div>
                        <% } %>

                        <!-- Status History Trail -->
                        <h3 style="font-size: 1.15rem; font-weight: 800; border-bottom: 2px solid var(--slate-100); padding-bottom: 0.5rem; margin-top: 2rem;">
                            <i class="fa-solid fa-clock-rotate-left"></i> Status Progress & Remarks
                        </h3>

                        <div class="timeline">
                            <% if (history != null && !history.isEmpty()) { 
                                for (ComplaintHistory item : history) { %>
                                    <div class="timeline-item">
                                        <div class="timeline-dot"></div>
                                        <div class="timeline-content">
                                            <div class="timeline-header">
                                                <div>
                                                    <span class="timeline-updater"><%= item.getUpdaterName() %></span>
                                                    <span style="font-size: 0.75rem; background: var(--slate-200); padding: 0.15rem 0.45rem; border-radius: var(--radius-sm); margin-left: 0.35rem; font-weight: 600;"><%= item.getUpdaterRole() %></span>
                                                    <span style="margin-left: 0.5rem; font-weight: 700; color: var(--primary);">→ <%= item.getNewStatus() %></span>
                                                </div>
                                                <span class="timeline-date"><i class="fa-regular fa-clock"></i> <%= sdf.format(item.getUpdatedAt()) %></span>
                                            </div>
                                            <div class="timeline-remarks"><%= item.getRemarks() %></div>
                                        </div>
                                    </div>
                            <%  } 
                            } else { %>
                                <p style="color: var(--slate-500);">No updates recorded yet.</p>
                            <% } %>
                        </div>

                    </div>
                </div>

            </div>
        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
</body>
</html>

