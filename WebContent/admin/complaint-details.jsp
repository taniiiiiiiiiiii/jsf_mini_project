<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.citycare.model.User" %>
<%@ page import="com.citycare.model.Complaint" %>
<%@ page import="com.citycare.model.ComplaintHistory" %>
<%@ page import="com.citycare.model.Department" %>
<%@ page import="com.citycare.model.Officer" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    Complaint complaint = (Complaint) request.getAttribute("complaint");
    List<ComplaintHistory> history = (List<ComplaintHistory>) request.getAttribute("history");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    List<Officer> officers = (List<Officer>) request.getAttribute("officers");
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
    <title>Manage Complaint <%= complaint.getTrackingId() %> – CityCare Admin</title>
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
                    <a href="<%= request.getContextPath() %>/admin/dashboard" class="sidebar-link">
                        <span class="sidebar-icon"><i class="fa-solid fa-chart-pie"></i></span>
                        <span>Overview</span>
                    </a>
                </li>
                <li>
                    <a href="<%= request.getContextPath() %>/admin/complaints" class="sidebar-link active">
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
            </ul>

            <div class="sidebar-footer">
                <div class="user-profile-pill">
                    <div class="user-avatar" style="background: linear-gradient(135deg, #4f46e5, #7c3aed);">A</div>
                    <div class="user-details">
                        <div class="user-name"><%= user.getFullName() %></div>
                        <div class="user-email">Administrator</div>
                    </div>
                </div>
            </div>
        </aside>

        <!-- Main Body -->
        <main class="main-content">
            <header class="topbar">
                <div class="topbar-left">
                    <h1 class="page-title">Complaint Administration</h1>
                </div>
                <div class="topbar-right">
                    <a href="<%= request.getContextPath() %>/admin/complaints" class="btn btn-outline btn-sm">
                        <i class="fa-solid fa-arrow-left"></i> Back to Complaints
                    </a>
                </div>
            </header>

            <div class="content-body" style="max-width: 1080px;">

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

                <div style="display: grid; grid-template-columns: 1.3fr 0.9fr; gap: 1.5rem; align-items: start;">
                    
                    <!-- Left: Grievance Details & Citizen Info -->
                    <div>
                        <div class="card">
                            <div class="card-header">
                                <div>
                                    <span class="tracking-code"><%= complaint.getTrackingId() %></span>
                                    <h2 style="font-size: 1.25rem; font-weight: 800; margin-top: 0.35rem; color: var(--slate-900);"><%= complaint.getTitle() %></h2>
                                </div>
                                <span class="badge <%= statusBadgeClass %>" style="font-size: 0.88rem; padding: 0.4rem 0.8rem;">
                                    <%= complaint.getStatus() %>
                                </span>
                            </div>

                            <div class="card-body">
                                
                                <!-- Citizen Details -->
                                <div style="background: var(--slate-50); border: 1px solid var(--slate-200); border-radius: var(--radius); padding: 1rem 1.25rem; margin-bottom: 1.25rem;">
                                    <h4 style="font-size: 0.85rem; font-weight: 700; text-transform: uppercase; color: var(--slate-500); margin-bottom: 0.5rem;">
                                        <i class="fa-solid fa-user"></i> Citizen Information
                                    </h4>
                                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem; font-size: 0.9rem;">
                                        <div><strong>Name:</strong> <%= complaint.getCitizenName() %></div>
                                        <div><strong>Phone:</strong> <a href="tel:<%= complaint.getCitizenPhone() %>"><i class="fa-solid fa-phone"></i> <%= complaint.getCitizenPhone() %></a></div>
                                        <div><strong>Email:</strong> <%= complaint.getCitizenEmail() %></div>
                                        <div><strong>Location:</strong> <%= complaint.getLocation() %></div>
                                    </div>
                                </div>

                                <div style="margin-bottom: 1.25rem;">
                                    <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--slate-700); margin-bottom: 0.35rem;">Problem Description</h4>
                                    <p style="white-space: pre-line; background: #fff; border: 1px solid var(--slate-200); padding: 1rem; border-radius: var(--radius); font-size: 0.925rem; color: var(--slate-800);"><%= complaint.getDescription() %></p>
                                </div>

                                <% if (complaint.getImagePath() != null && !complaint.getImagePath().trim().isEmpty()) { %>
                                    <div style="margin-bottom: 1.5rem;">
                                        <h4 style="font-size: 0.9rem; font-weight: 700; color: var(--slate-700); margin-bottom: 0.35rem;">Photo Evidence</h4>
                                        <a href="<%= request.getContextPath() %>/view-image?file=<%= complaint.getImagePath() %>" target="_blank">
                                            <img src="<%= request.getContextPath() %>/view-image?file=<%= complaint.getImagePath() %>" alt="Evidence" style="max-width: 100%; max-height: 280px; border-radius: var(--radius); border: 1px solid var(--slate-300);">
                                        </a>
                                    </div>
                                <% } %>

                                <!-- Audit Trail -->
                                <h3 style="font-size: 1.1rem; font-weight: 800; border-bottom: 2px solid var(--slate-100); padding-bottom: 0.5rem; margin-top: 1.5rem;">
                                    <i class="fa-solid fa-clock-rotate-left"></i> Status Progress & Audit Log
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
                                                            <span style="font-size: 0.72rem; background: var(--slate-200); padding: 0.15rem 0.45rem; border-radius: var(--radius-sm); margin-left: 0.35rem; font-weight: 600;"><%= item.getUpdaterRole() %></span>
                                                            <span style="margin-left: 0.5rem; font-weight: 700; color: var(--primary);">→ <%= item.getNewStatus() %></span>
                                                        </div>
                                                        <span class="timeline-date"><%= sdf.format(item.getUpdatedAt()) %></span>
                                                    </div>
                                                    <div class="timeline-remarks"><%= item.getRemarks() %></div>
                                                </div>
                                            </div>
                                    <%  } 
                                    } %>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- Right: Admin Assignment & Control Box -->
                    <div>
                        <div class="card">
                            <div class="card-header" style="background: linear-gradient(135deg, #1e3a8a, #4338ca); color: #fff;">
                                <h3 class="card-title" style="color: #fff;">
                                    <i class="fa-solid fa-sliders"></i> Master Assignment & Control
                                </h3>
                            </div>
                            <div class="card-body">
                                <form action="<%= request.getContextPath() %>/admin/assign" method="post">
                                    <input type="hidden" name="complaintId" value="<%= complaint.getComplaintId() %>">

                                    <div class="form-group">
                                        <label class="form-label" for="departmentId">Assign Department</label>
                                        <select id="departmentId" name="departmentId" class="form-control" onchange="filterOfficersByDept()">
                                            <option value="">-- Select Department --</option>
                                            <% if (departments != null) { 
                                                for (Department d : departments) { %>
                                                    <option value="<%= d.getDepartmentId() %>" <%= (complaint.getDepartmentId() != null && complaint.getDepartmentId() == d.getDepartmentId()) ? "selected" : "" %>>
                                                        <%= d.getDepartmentName() %>
                                                    </option>
                                            <%  } 
                                            } %>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="officerUserId">Assign Municipal Officer</label>
                                        <select id="officerUserId" name="officerUserId" class="form-control">
                                            <option value="">-- Select Officer --</option>
                                            <% if (officers != null) { 
                                                for (Officer o : officers) { %>
                                                    <option value="<%= o.getUserId() %>" data-dept="<%= o.getDepartmentId() %>" <%= (complaint.getAssignedOfficerId() != null && complaint.getAssignedOfficerId() == o.getUserId()) ? "selected" : "" %>>
                                                        <%= o.getFullName() %> (<%= o.getDepartmentName() %>)
                                                    </option>
                                            <%  } 
                                            } %>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="adminStatus">Override Status</label>
                                        <select id="adminStatus" name="status" class="form-control">
                                            <option value="">-- Keep Current Status --</option>
                                            <option value="Submitted" <%= "Submitted".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>Submitted</option>
                                            <option value="Under Review" <%= "Under Review".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>Under Review</option>
                                            <option value="Assigned" <%= "Assigned".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>Assigned</option>
                                            <option value="In Progress" <%= "In Progress".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>In Progress</option>
                                            <option value="Resolved" <%= "Resolved".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>Resolved</option>
                                            <option value="Rejected" <%= "Rejected".equalsIgnoreCase(complaint.getStatus()) ? "selected" : "" %>>Rejected</option>
                                        </select>
                                    </div>

                                    <div class="form-group">
                                        <label class="form-label" for="remarks">Administrative Remarks / Directive</label>
                                        <textarea id="remarks" name="remarks" class="form-control" style="min-height: 80px;" placeholder="Directive for department or citizen feedback notes..."></textarea>
                                    </div>

                                    <button type="submit" class="btn btn-primary" style="width: 100%;">
                                        <i class="fa-solid fa-save"></i> Save Assignment & Status
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </main>
    </div>

    <script src="<%= request.getContextPath() %>/js/main.js"></script>
    <script>
        function filterOfficersByDept() {
            const deptId = document.getElementById('departmentId').value;
            const officerSelect = document.getElementById('officerUserId');
            const options = officerSelect.querySelectorAll('option');

            options.forEach(opt => {
                if (opt.value === "") return;
                const optDept = opt.getAttribute('data-dept');
                if (!deptId || optDept === deptId) {
                    opt.style.display = "";
                } else {
                    opt.style.display = "none";
                }
            });
        }
        document.addEventListener('DOMContentLoaded', filterOfficersByDept);
    </script>
</body>
</html>

