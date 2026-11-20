package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DAO {
    public Connection getConnection() throws SQLException {
        String url = setting("DB_URL", "jdbc:mysql://127.0.0.1:3306/shopman?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh");
        String user = setting("DB_USER", "root");
        String password = setting("DB_PASSWORD", "Manh1234");
        return DriverManager.getConnection(url, user, password);
    }

    private String setting(String key, String fallback) {
        String value = System.getenv(key);
        return value == null || value.trim().isEmpty() ? fallback : value;
    }
}
