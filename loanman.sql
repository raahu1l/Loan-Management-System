CREATE DATABASE loan_db;
USE loan_db;

CREATE TABLE loans (
id INT PRIMARY KEY AUTO_INCREMENT,
borrower_name VARCHAR(100),
amount DOUBLE,
interest DOUBLE ,
duration INT ,
status VARCHAR(100)
);

CREATE TABLE payments (
id INT PRIMARY KEY AUTO_INCREMENT ,
loan_id INT ,
amount_paid DOUBLE ,
payment_date  DATE ,
FOREIGN KEY (loan_id) REFERENCES loans(id)
);
SELECT * FROM loans;