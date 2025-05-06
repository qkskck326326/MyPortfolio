CREATE TABLE User (
                      user_pid INT AUTO_INCREMENT PRIMARY KEY,
                      user_Id VARCHAR(50) NOT NULL UNIQUE,
                      email VARCHAR(100),
                      github VARCHAR(100),
                      password VARCHAR(100) NOT NULL,
                      user_thumbnail VARCHAR(100),
                      nickname VARCHAR(100) NOT NULL UNIQUE,
                      birth DATE NOT NULL,
                      introduce VARCHAR(1000)
);

CREATE TABLE Portfolio (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           user_pid INT NOT NULL,
                           like_count INT,
                           user_nickname VARCHAR(100) NOT NULL,
                           thumbnail VARCHAR(100),
                           title VARCHAR(255) NOT NULL,
                           content TEXT NOT NULL,
                           created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                           updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                           FOREIGN KEY (user_pid) REFERENCES User(user_pid) ON DELETE CASCADE
);

CREATE TABLE Portfolio_Tags (
                                id INT AUTO_INCREMENT PRIMARY KEY,
                                portfolio_id INT NOT NULL,
                                tag VARCHAR(50) NOT NULL,
                                FOREIGN KEY (portfolio_id) REFERENCES Portfolio(id) ON DELETE CASCADE
);

CREATE TABLE User_Portfolio_Like (
                                     user_pid INT NOT NULL,
                                     portfolio_id INT NOT NULL,
                                     PRIMARY KEY (user_pid, portfolio_id),
                                     FOREIGN KEY (user_pid) REFERENCES User(user_pid) ON DELETE CASCADE,
                                     FOREIGN KEY (portfolio_id) REFERENCES Portfolio(id) ON DELETE CASCADE
);

commit;