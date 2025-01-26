CREATE DATABASE journal_db;

CREATE TABLE users (
    userId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
    userName VARCHAR(30),
    p_word VARCHAR(16),
    e_mail VARCHAR(320)
);

CREATE TABLE entries (
    entry_id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWSEQUENTIALID(),
    userId UNIQUEIDENTIFIER,
    title VARCHAR(50),
    content VARCHAR(1000),
    time_stamp DATETIME,
    mood VARCHAR(30),
    FOREIGN KEY (userId) REFERENCES users(userId)
);

drop table users
drop table entries