package com.citycare.test;

import com.citycare.dao.ComplaintDAO;
import com.citycare.dao.DepartmentDAO;
import com.citycare.dao.OfficerDAO;
import com.citycare.dao.UserDAO;
import com.citycare.model.Complaint;
import com.citycare.model.DashboardStats;
import com.citycare.model.Officer;
import com.citycare.model.User;
import com.citycare.util.PasswordUtil;
import com.citycare.util.TrackingIdGenerator;

import java.util.List;

public class TestRunner {

    public static void main(String[] args) {
        System.out.println("=================================================");
        System.out.println("CITYCARE AUTOMATED SYSTEM INTEGRATION TEST SUITE");
        System.out.println("=================================================");

        UserDAO userDAO = new UserDAO();
        DepartmentDAO departmentDAO = new DepartmentDAO();
        OfficerDAO officerDAO = new OfficerDAO();
        ComplaintDAO complaintDAO = new ComplaintDAO();

        int passed = 0;
        int failed = 0;

        // Test 1: Authenticate Admin Demo Account
        try {
            User admin = userDAO.authenticate("admin@citycare.gov", "Admin@123");
            if (admin != null && "ADMIN".equalsIgnoreCase(admin.getRole())) {
                System.out.println(" [PASS] 1. Admin Authentication verified (" + admin.getFullName() + ")");
                passed++;
            } else {
                System.err.println(" [FAIL] 1. Admin Authentication failed");
                failed++;
            }
        } catch (Exception e) {
            System.err.println(" [FAIL] 1. " + e.getMessage());
            failed++;
        }

        // Test 2: Authenticate Officer Account
        try {
            User officer = userDAO.authenticate("officer.roads@citycare.gov", "Officer@123");
            if (officer != null && "OFFICER".equalsIgnoreCase(officer.getRole())) {
                System.out.println(" [PASS] 2. Officer Authentication verified (" + officer.getFullName() + ")");
                passed++;
            } else {
                System.err.println(" [FAIL] 2. Officer Authentication failed");
                failed++;
            }
        } catch (Exception e) {
            System.err.println(" [FAIL] 2. " + e.getMessage());
            failed++;
        }

        // Test 3: Authenticate Citizen Account
        try {
            User citizen = userDAO.authenticate("citizen@citycare.gov", "Citizen@123");
            if (citizen != null && "CITIZEN".equalsIgnoreCase(citizen.getRole())) {
                System.out.println(" [PASS] 3. Citizen Authentication verified (" + citizen.getFullName() + ")");
                passed++;
            } else {
                System.err.println(" [FAIL] 3. Citizen Authentication failed");
                failed++;
            }
        } catch (Exception e) {
            System.err.println(" [FAIL] 3. " + e.getMessage());
            failed++;
        }

        // Test 4: Citizen Registration with duplicate email prevention
        try {
            String testEmail = "testcitizen_" + System.currentTimeMillis() + "@citycare.gov";
            User newCitizen = new User();
            newCitizen.setFullName("Automated Test Citizen");
            newCitizen.setEmail(testEmail);
            newCitizen.setPhone("9988776655");
            newCitizen.setAddress("Test Ward 5, Block B");
            newCitizen.setPasswordHash(PasswordUtil.hashPassword("Citizen@123"));

            boolean regSuccess = userDAO.registerCitizen(newCitizen);
            boolean dupCheck = userDAO.emailExists(testEmail);

            if (regSuccess && dupCheck) {
                System.out.println(" [PASS] 4. Citizen registration and email lookup verified");
                passed++;
            } else {
                System.err.println(" [FAIL] 4. Citizen registration failed");
                failed++;
            }
        } catch (Exception e) {
            System.err.println(" [FAIL] 4. " + e.getMessage());
            failed++;
        }

        // Test 5: Verify Departments
        try {
            int deptCount = departmentDAO.countDepartments();
            if (deptCount >= 5) {
                System.out.println(" [PASS] 5. Departments verified (Count: " + deptCount + ")");
                passed++;
            } else {
                System.err.println(" [FAIL] 5. Expected at least 5 departments, found: " + deptCount);
                failed++;
            }
        } catch (Exception e) {
            System.err.println(" [FAIL] 5. " + e.getMessage());
            failed++;
        }

        // Test 6: Verify Officers
        try {
            List<Officer> officers = officerDAO.getAllOfficers();
            if (officers != null && officers.size() >= 5) {
                System.out.println(" [PASS] 6. Municipal Officers verified (Count: " + officers.size() + ")");
                passed++;
            } else {
                System.err.println(" [FAIL] 6. Expected at least 5 officers");
                failed++;
            }
        } catch (Exception e) {
            System.err.println(" [FAIL] 6. " + e.getMessage());
            failed++;
        }

        // Test 7: Complaint Creation with Unique Tracking ID
        Complaint testComplaint = new Complaint();
        String trackingId = TrackingIdGenerator.generateTrackingId();
        try {
            testComplaint.setTrackingId(trackingId);
            testComplaint.setCitizenId(7); // Tanisha Rao
            testComplaint.setTitle("Broken streetlight pole near park");
            testComplaint.setCategory("Damaged streetlights");
            testComplaint.setDescription("Electrical wiring is exposed on street pole #42.");
            testComplaint.setLocation("Near Community Park, 2nd Main");
            testComplaint.setPriority("Urgent");
            testComplaint.setDepartmentId(4); // Electricity

            boolean created = complaintDAO.createComplaint(testComplaint);
            if (created && testComplaint.getComplaintId() > 0) {
                System.out.println(" [PASS] 7. Complaint submitted successfully (Tracking ID: " + trackingId + ", ID: " + testComplaint.getComplaintId() + ")");
                passed++;
            } else {
                System.err.println(" [FAIL] 7. Complaint submission failed");
                failed++;
            }
        } catch (Exception e) {
            System.err.println(" [FAIL] 7. " + e.getMessage());
            failed++;
        }

        // Test 8: Complaint Tracking by Tracking ID
        try {
            Complaint fetched = complaintDAO.getComplaintByTrackingId(trackingId);
            if (fetched != null && fetched.getComplaintId() == testComplaint.getComplaintId()) {
                System.out.println(" [PASS] 8. Complaint tracking lookup verified (" + fetched.getTitle() + ")");
                passed++;
            } else {
                System.err.println(" [FAIL] 8. Tracking lookup failed");
                failed++;
            }
        } catch (Exception e) {
            System.err.println(" [FAIL] 8. " + e.getMessage());
            failed++;
        }

        // Test 9: Status Update and History Logging
        try {
            boolean updated = complaintDAO.updateStatus(testComplaint.getComplaintId(), "In Progress", 5, "Line repair team dispatched to replace circuit breaker.");
            Complaint updatedComplaint = complaintDAO.getComplaintById(testComplaint.getComplaintId());
            var history = complaintDAO.getComplaintHistory(testComplaint.getComplaintId());

            if (updated && "In Progress".equals(updatedComplaint.getStatus()) && history.size() >= 2) {
                System.out.println(" [PASS] 9. Status transition & audit history verified (History entries: " + history.size() + ")");
                passed++;
            } else {
                System.err.println(" [FAIL] 9. Status update or history logging failed");
                failed++;
            }
        } catch (Exception e) {
            System.err.println(" [FAIL] 9. " + e.getMessage());
            failed++;
        }

        // Test 10: Admin Dashboard Statistics calculation from actual DB records
        try {
            DashboardStats adminStats = complaintDAO.getAdminDashboardStats();
            if (adminStats.getTotalComplaints() >= 6 && adminStats.getTotalCitizens() >= 2 && adminStats.getTotalOfficers() >= 5) {
                System.out.println(" [PASS] 10. Admin dynamic statistics verified from MySQL (Total Complaints: " +
                        adminStats.getTotalComplaints() + ", Resolved: " + adminStats.getResolvedComplaints() + ", InProgress: " + adminStats.getInProgressComplaints() + ")");
                passed++;
            } else {
                System.err.println(" [FAIL] 10. Dashboard statistics unexpected: " + adminStats.getTotalComplaints());
                failed++;
            }
        } catch (Exception e) {
            System.err.println(" [FAIL] 10. " + e.getMessage());
            failed++;
        }

        System.out.println("=================================================");
        System.out.println("SUMMARY: " + passed + " PASSED, " + failed + " FAILED");
        System.out.println("=================================================");
        if (failed > 0) {
            System.exit(1);
        }
    }
}

