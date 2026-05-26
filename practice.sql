CREATE DATABASE IF NOT EXISTS sport; -- creates a new databse if not present initially
USE sport; -- urges to make the use of the created database
-- tables creation
CREATE TABLE IF NOT EXISTS league (
    league_id INT  AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    sport VARCHAR(50) NOT NULL DEFAULT 'Football' ,
    season_year INT
);
-- the sql creation now requires the addidtion of queries and joins

CREATE TABLE IF NOT EXISTS team (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    league_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    home_ground VARCHAR(100),
    captain_name VARCHAR(100),
    FOREIGN KEY (league_id) REFERENCES league(league_id) ON DELETE CASCADE
    -- says that league_id is the foreign key whose actual values must correspond to the table referenced which is league ani if delete command is brought through cascade must be triggered.
);

CREATE TABLE IF NOT EXISTS player (
    player_id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(100),
    date_of_birth DATE,
    status ENUM ('active','injured','suspended') DEFAULT 'active',
    FOREIGN KEY (team_id) REFERENCES team(team_id) ON DELETE CASCADE
    -- says that league_id is the foreign key whose actual values must correspond to the table referenced which is league ani if delete command is brought through cascade must be triggered.
);

CREATE TABLE  IF NOT EXISTS fixture (
    fixture_id   INT AUTO_INCREMENT PRIMARY KEY,
    league_id    INT  NOT NULL,
    home_team_id INT  NOT NULL,
    away_team_id INT  NOT NULL,
    match_date   DATE NOT NULL,
    venue        VARCHAR(100),
    status       ENUM('scheduled','completed','postponed') DEFAULT 'scheduled',
    FOREIGN KEY (league_id)    REFERENCES league(league_id),
    FOREIGN KEY (home_team_id) REFERENCES team(team_id),
    FOREIGN KEY (away_team_id) REFERENCES team(team_id),
    CHECK (home_team_id <> away_team_id)   -- a team can't play itself
);

CREATE TABLE IF NOT EXISTS match_result (
    result_id  INT AUTO_INCREMENT PRIMARY KEY,
    fixture_id INT NOT NULL UNIQUE,
    home_goals INT NOT NULL DEFAULT 0,
    away_goals INT NOT NULL DEFAULT 0,
    referee    VARCHAR(100),
    FOREIGN KEY (fixture_id) REFERENCES fixture(fixture_id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS player_stats (
    stat_id        INT AUTO_INCREMENT PRIMARY KEY,
    fixture_id     INT NOT NULL,
    player_id      INT NOT NULL,
    goals          INT DEFAULT 0,
    assists        INT DEFAULT 0,
    yellow_cards   INT DEFAULT 0,
    red_cards      INT DEFAULT 0,
    minutes_played INT DEFAULT 90,
    FOREIGN KEY (fixture_id) REFERENCES fixture(fixture_id) ON DELETE CASCADE,
    FOREIGN KEY (player_id)  REFERENCES player(player_id)  ON DELETE CASCADE,
    UNIQUE (fixture_id, player_id)   -- one stat row per player per match
);

SELECT * FROM league;
SELECT t.name, t.home_ground
FROM team t
JOIN league l ON t.league_id = l.league_id
WHERE l.name = 'Premier League';
SELECT p.name, p.position, p.status
FROM player p
JOIN team t ON p.team_id = t.team_id
WHERE t.name = 'FC Barcelona';
