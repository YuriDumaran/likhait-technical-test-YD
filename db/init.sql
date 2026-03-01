CREATE DATABASE IF NOT EXISTS expense_system_development;
CREATE DATABASE IF NOT EXISTS expense_system_test;

GRANT ALL PRIVILEGES ON expense_system_development.* TO 'expense_user'@'%';
GRANT ALL PRIVILEGES ON expense_system_test.* TO 'expense_user'@'%';
FLUSH PRIVILEGES;