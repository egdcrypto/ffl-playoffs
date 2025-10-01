-- NFL Teams Seed Data
-- All 32 NFL teams with conference and division information
-- Format: abbreviation, city, nickname, conference, division

-- AFC EAST
INSERT INTO nfl_teams (id, abbreviation, city, nickname, name, conference, division, created_at, updated_at)
VALUES
    ('BUF', 'BUF', 'Buffalo', 'Bills', 'Buffalo Bills', 'AFC', 'EAST', NOW(), NOW()),
    ('MIA', 'MIA', 'Miami', 'Dolphins', 'Miami Dolphins', 'AFC', 'EAST', NOW(), NOW()),
    ('NE', 'NE', 'New England', 'Patriots', 'New England Patriots', 'AFC', 'EAST', NOW(), NOW()),
    ('NYJ', 'NYJ', 'New York', 'Jets', 'New York Jets', 'AFC', 'EAST', NOW(), NOW());

-- AFC NORTH
INSERT INTO nfl_teams (id, abbreviation, city, nickname, name, conference, division, created_at, updated_at)
VALUES
    ('BAL', 'BAL', 'Baltimore', 'Ravens', 'Baltimore Ravens', 'AFC', 'NORTH', NOW(), NOW()),
    ('CIN', 'CIN', 'Cincinnati', 'Bengals', 'Cincinnati Bengals', 'AFC', 'NORTH', NOW(), NOW()),
    ('CLE', 'CLE', 'Cleveland', 'Browns', 'Cleveland Browns', 'AFC', 'NORTH', NOW(), NOW()),
    ('PIT', 'PIT', 'Pittsburgh', 'Steelers', 'Pittsburgh Steelers', 'AFC', 'NORTH', NOW(), NOW());

-- AFC SOUTH
INSERT INTO nfl_teams (id, abbreviation, city, nickname, name, conference, division, created_at, updated_at)
VALUES
    ('HOU', 'HOU', 'Houston', 'Texans', 'Houston Texans', 'AFC', 'SOUTH', NOW(), NOW()),
    ('IND', 'IND', 'Indianapolis', 'Colts', 'Indianapolis Colts', 'AFC', 'SOUTH', NOW(), NOW()),
    ('JAX', 'JAX', 'Jacksonville', 'Jaguars', 'Jacksonville Jaguars', 'AFC', 'SOUTH', NOW(), NOW()),
    ('TEN', 'TEN', 'Tennessee', 'Titans', 'Tennessee Titans', 'AFC', 'SOUTH', NOW(), NOW());

-- AFC WEST
INSERT INTO nfl_teams (id, abbreviation, city, nickname, name, conference, division, created_at, updated_at)
VALUES
    ('DEN', 'DEN', 'Denver', 'Broncos', 'Denver Broncos', 'AFC', 'WEST', NOW(), NOW()),
    ('KC', 'KC', 'Kansas City', 'Chiefs', 'Kansas City Chiefs', 'AFC', 'WEST', NOW(), NOW()),
    ('LV', 'LV', 'Las Vegas', 'Raiders', 'Las Vegas Raiders', 'AFC', 'WEST', NOW(), NOW()),
    ('LAC', 'LAC', 'Los Angeles', 'Chargers', 'Los Angeles Chargers', 'AFC', 'WEST', NOW(), NOW());

-- NFC EAST
INSERT INTO nfl_teams (id, abbreviation, city, nickname, name, conference, division, created_at, updated_at)
VALUES
    ('DAL', 'DAL', 'Dallas', 'Cowboys', 'Dallas Cowboys', 'NFC', 'EAST', NOW(), NOW()),
    ('NYG', 'NYG', 'New York', 'Giants', 'New York Giants', 'NFC', 'EAST', NOW(), NOW()),
    ('PHI', 'PHI', 'Philadelphia', 'Eagles', 'Philadelphia Eagles', 'NFC', 'EAST', NOW(), NOW()),
    ('WAS', 'WAS', 'Washington', 'Commanders', 'Washington Commanders', 'NFC', 'EAST', NOW(), NOW());

-- NFC NORTH
INSERT INTO nfl_teams (id, abbreviation, city, nickname, name, conference, division, created_at, updated_at)
VALUES
    ('CHI', 'CHI', 'Chicago', 'Bears', 'Chicago Bears', 'NFC', 'NORTH', NOW(), NOW()),
    ('DET', 'DET', 'Detroit', 'Lions', 'Detroit Lions', 'NFC', 'NORTH', NOW(), NOW()),
    ('GB', 'GB', 'Green Bay', 'Packers', 'Green Bay Packers', 'NFC', 'NORTH', NOW(), NOW()),
    ('MIN', 'MIN', 'Minnesota', 'Vikings', 'Minnesota Vikings', 'NFC', 'NORTH', NOW(), NOW());

-- NFC SOUTH
INSERT INTO nfl_teams (id, abbreviation, city, nickname, name, conference, division, created_at, updated_at)
VALUES
    ('ATL', 'ATL', 'Atlanta', 'Falcons', 'Atlanta Falcons', 'NFC', 'SOUTH', NOW(), NOW()),
    ('CAR', 'CAR', 'Carolina', 'Panthers', 'Carolina Panthers', 'NFC', 'SOUTH', NOW(), NOW()),
    ('NO', 'NO', 'New Orleans', 'Saints', 'New Orleans Saints', 'NFC', 'SOUTH', NOW(), NOW()),
    ('TB', 'TB', 'Tampa Bay', 'Buccaneers', 'Tampa Bay Buccaneers', 'NFC', 'SOUTH', NOW(), NOW());

-- NFC WEST
INSERT INTO nfl_teams (id, abbreviation, city, nickname, name, conference, division, created_at, updated_at)
VALUES
    ('ARI', 'ARI', 'Arizona', 'Cardinals', 'Arizona Cardinals', 'NFC', 'WEST', NOW(), NOW()),
    ('LAR', 'LAR', 'Los Angeles', 'Rams', 'Los Angeles Rams', 'NFC', 'WEST', NOW(), NOW()),
    ('SF', 'SF', 'San Francisco', '49ers', 'San Francisco 49ers', 'NFC', 'WEST', NOW(), NOW()),
    ('SEA', 'SEA', 'Seattle', 'Seahawks', 'Seattle Seahawks', 'NFC', 'WEST', NOW(), NOW());
