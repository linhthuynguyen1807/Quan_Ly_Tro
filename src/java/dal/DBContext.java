package dal;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Base DAO context providing JDBC connection management.
 * Implements AutoCloseable for proper resource cleanup.
 */
public class DBContext implements AutoCloseable {

    protected Connection connection;

    public DBContext() {
        try {
            // Priority 1: Environment variables (for production/deployment)
            String url = System.getenv("DB_URL");
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASSWORD");

            // Priority 2: Fallback to properties file (for local development)
            if (url == null || url.isEmpty()) {
                Properties properties = new Properties();
                InputStream inputStream = getClass().getClassLoader()
                        .getResourceAsStream("../ConnectDB.properties");
                if (inputStream != null) {
                    try {
                        properties.load(inputStream);
                    } catch (IOException ex) {
                        Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE,
                                "Failed to load ConnectDB.properties", ex);
                    }
                }
                user = properties.getProperty("userID");
                pass = properties.getProperty("password");
                url = properties.getProperty("url");
            }

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE,
                    "Database connection failed", ex);
        }
    }

    /**
     * Closes the underlying JDBC connection if it is open.
     * Call this when the DAO is no longer needed.
     */
    @Override
    public void close() {
        if (connection != null) {
            try {
                if (!connection.isClosed()) {
                    connection.close();
                }
            } catch (SQLException ex) {
                Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
