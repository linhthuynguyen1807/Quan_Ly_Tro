package model;

import java.util.Date;

public class Notification {
    private int notification_id;
    private int user_id;
    private String title;
    private String message;
    private String type;
    private boolean isRead;
    private Date createdAt;

    public Notification() {}

    public int getNotification_id() { return notification_id; }
    public void setNotification_id(int notification_id) { this.notification_id = notification_id; }

    public int getUser_id() { return user_id; }
    public void setUser_id(int user_id) { this.user_id = user_id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean isRead) { this.isRead = isRead; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
