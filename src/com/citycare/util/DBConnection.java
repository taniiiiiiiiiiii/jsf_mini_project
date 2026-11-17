
package com.citycare.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String JDBC_URL =
            System.getenv("JDBC_URL");

    private static final String JDBC_USER =
            System.getenv("DB_USER");

    private static final String JDBC_PASSWORD =
            System.getenv("DB_PASSWORD");

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(
                    "MySQL JDBC Driver not found!", e);
        }
    }

    public static Connection getConnection() throws SQLException {

        if (JDBC_URL == null || JDBC_URL.isBlank()
                || JDBC_USER == null || JDBC_USER.isBlank()
                || JDBC_PASSWORD == null || JDBC_PASSWORD.isBlank()) {

            throw new SQLException(
                    "Missing database environment variables.");
        }

        return DriverManager.getConnection(
                JDBC_URL,
                JDBC_USER,
                JDBC_PASSWORD
        );
    }
}
