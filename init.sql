CREATE DATABASE IF NOT EXISTS guestbook;
USE guestbook;

CREATE TABLE IF NOT EXISTS guest_entries (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) DEFAULT NULL,
    message VARCHAR(500) NOT NULL,
    mood VARCHAR(10) DEFAULT '😊',
    likes INT DEFAULT 0,
    pinned BOOLEAN DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

INSERT INTO guest_entries (name, email, message, mood, likes, pinned) VALUES
('Admin', 'admin@guestbook.app', 'Welcome to the Guestbook! Feel free to leave a message.', '👋', 5, TRUE),
('Jane Doe', 'jane@example.com', 'Great application, love the design!', '😍', 3, FALSE),
('John Smith', 'john@example.com', 'Just discovered this app. Really cool!', '🎉', 1, FALSE);
