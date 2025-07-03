CREATE DATABASE IF NOT EXISTS blogdb;

USE blogdb;

CREATE TABLE IF NOT EXISTS blogs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255),
  description TEXT
);

INSERT INTO blogs (title, description)
VALUES
  ('First Blog Post', 'This is the description of the first blog post.'),
  ('Second Blog Post', 'This is the description of the second blog post.');
