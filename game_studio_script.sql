-- -------------------------------------------
-- Drop the 'game_studio database
-- -------------------------------------------
drop database if exists game_studio;

-- -------------------------------------------
-- Create the game_studio database and use it
-- -------------------------------------------
create database if not exists game_studio;
use game_studio;

-- -------------------------------------------
-- Create the employee table
-- -------------------------------------------
create table if not exists Employee
(
	employeeId int auto_increment not null,
    fname varchar(20) not null,
    lname varchar(20) not null,
    street varchar(30),
    city varchar(30),
    county varchar(30),
    primary key (employeeId)
);

-- -------------------------------------------
-- Create the department table
-- -------------------------------------------
create table if not exists Department
(
	deptId int auto_increment not null,
    name varchar(20) not null,
    description varchar(256),
    primary key (deptId)
);

-- -------------------------------------------
-- Create the role table
-- -------------------------------------------
create table if not exists Role
(
	roleId int not null,
    title varchar(20) not null,
    description varchar(256),
    parentId int,
    primary key (roleId),
    foreign key (parentId) references Role(roleId) on update cascade on delete cascade
);

-- -------------------------------------------
-- Create the genre table
-- -------------------------------------------
create table if not exists Genre
(
	genreId int not null,
    name varchar(32) not null unique,
    description varchar(256),
    parentId int,
    primary key (genreId),
    foreign key (parentId) references Genre(genreId) on update cascade on delete cascade
);

-- -------------------------------------------
-- Create the game table
-- -------------------------------------------
create table if not exists Game
(
	gameId int auto_increment not null,
    title varchar(100) not null,
    releaseDate date,
    genreId int not null,
    primary key (gameId),
    foreign key (genreId) references Genre(genreId) on update cascade on delete no action
);

-- -------------------------------------------
-- Create the phase table
-- -------------------------------------------
create table if not exists Phase
(
	phaseId int auto_increment not null,
    name varchar(20) not null unique,
    description varchar(256),
    primary key (phaseId)
);

-- -------------------------------------------
-- Create the milestone table
-- -------------------------------------------
create table if not exists Milestone
(
	milestoneId int auto_increment not null,
    name varchar(32) not null unique,
    description varchar(256),
    primary key (milestoneId)
);

-- -------------------------------------------
-- Create the platform table
-- -------------------------------------------
create table if not exists Platform
(
	platformId int auto_increment not null,
    name varchar(32) not null,
    type char(1),
    primary key (platformId)
);

-- -------------------------------------------
-- Create the pc table
-- -------------------------------------------
create table if not exists Pc
(
	platformId int not null,
    storeName varchar(32) not null unique,
    website varchar(50),
    primary key (platformId),
    foreign key (platformId) references Platform(platformId)
);

-- -------------------------------------------
--
-- -------------------------------------------
delimiter $$
create procedure insertPlatform(in name varchar(32), in type char(1), in storeName varchar(50), in website varchar(50))
begin
	declare newId int;
    insert into Platform(name, type) values (name, type);
    set newId = last_insert_id();
    if (type = 'P') then
		insert into Pc(platformId, storeName, website) values (newId, storeName, website);
	end if;
end$$
delimiter ;
    
-- -------------------------------------------
-- Create the employeeMemeberOfDepartment table
-- -------------------------------------------
create table if not exists EmployeeMemberOfDepartment
(
	employeeId int not null,
    deptId int not null,
    startDate date not null,
    endDate date,
    primary key (employeeId, deptId, startDate),
    foreign key (employeeId) references Employee(employeeId) on update cascade on delete cascade,
    foreign key (deptId) references Department(deptId) on update cascade on delete cascade,
    check (endDate >= startDate)
);

-- -------------------------------------------
-- Create the worksOn table
-- -------------------------------------------
create table if not exists WorksOn
(
	employeeId int not null,
    gameId int not null,
    roleId int not null,
    startDate date not null,
    endDate date,
    primary key (employeeId, gameId, RoleId),
    foreign key (employeeId) references Employee(employeeId) on update cascade on delete cascade,
    foreign key (gameId) references Game(gameId) on update cascade on delete cascade,
    foreign key (roleId) references Role(roleId) on update cascade on delete cascade,
    check (endDate >= startDate)
);

-- -------------------------------------------
-- Create the gameInPhase table
-- -------------------------------------------
create table if not exists GameInPhase
(
	gameId int not null,
    phaseId int not null,
    startDate date not null,
    endDate date,
    primary key (gameId, phaseId),
    foreign key (gameId) references Game(gameId) on update cascade on delete cascade,
    foreign key (phaseId) references Phase(phaseId) on update cascade on delete cascade,
    check (endDate >= startDate)
);

-- -------------------------------------------
-- Create the gameHasMetMilestone table
-- -------------------------------------------
create table if not exists GameHasMetMilestone
(
	gameId int not null,
    milestoneId int not null,
    date date not null,
    primary key (gameId, milestoneId),
    foreign key (gameId) references Game(gameId) on update cascade on delete cascade,
    foreign key (milestoneId) references Milestone(milestoneId) on update cascade on delete cascade
);

-- -------------------------------------------
-- Create the gameOnPlatform table
-- -------------------------------------------
create table if not exists GameOnPlatform
(
	gameId int not null,
    platformId int not null,
    dateReleased date,
    primary key (gameId, platformId),
    foreign key (gameId) references Game(gameId) on update cascade on delete cascade,
    foreign key (platformId) references Platform(platformId) on update cascade on delete cascade
);

-- -------------------------------------------
-- Populate table Employee
-- -------------------------------------------
insert into Employee (fName, lName, street, city, county) values
	('Richard', 'Whitney', '1 Main St.', 'Thomastown', 'Kilkenny'),
    ('Jennifer', 'Ryan', '10 Fairfield Rd.', 'Tramore', 'Waterford'),
    ('Jamie', 'Walshe', '742 Evergreen Terrace', 'Dublin', 'Dublin'),
    ('Lisa', 'Butler', '123 Fake St.', 'Clonmel', 'Tipperary'),
    ('Eamonn', 'Foley', 'Woodlands', 'Knockdrinna', 'Kilkenny'),
    ('Stephen', 'Long', '10 Market St.', 'Thurles', 'Tipperary'),
    ('James', 'Malone', '21 Main Street', 'Tramore', 'Waterford'),
    ('Marie', 'Ryan', 'Kylerue', 'New Ross', 'Wexford'),
    ('Philip', 'Walsh', 'Boherdrad', 'Cashel', 'Tipperary'),
    ('James', 'Ryan', 'Tinniscully', 'The Rower', 'Kilkenny'),
    ('Rose', 'Davis', '15 Main Street', 'New Ross', 'Wexford'),
    ('Kevin', 'Roche', 'Rathinure', 'Glenmore', 'Kilkenny'),
    ('Orla', 'Ryan', '5 Rose Lawn', 'Grace Dieu', 'Waterford'),
    ('Cathy', 'Brown', 'Kill and Mill', 'Cashel', 'Tipperary'),
    ('James', 'Smith', '123 Riverwalk', 'Thomastown', 'Kilkenny'),
    ('Claire', 'Kelly', '11 Church Road', 'Cashel', 'Tipperary'),
    ('Mairead', 'Walsh', '5 The Drive', 'Tramore', 'Waterford'),
    ('Anne', 'Ryan', '14 Fishermans Grove', 'Dunmore East', 'Waterford'),
    ('Eoin', 'Delaney', 'Lower South Street', 'New Ross', 'Wexford'),
    ('Cathal', 'Mooney', '1 School House Road', 'New Ross', 'Wexford'),
    ('Niall', 'Flynn', 'The Quay', 'Thomastown', 'Kilkenny'),
    ('Tom', 'Smith', 'Upper Rosemount', 'Inistioge', 'Kilkenny'),
    ('Martin', 'Roche', 'Belview', 'Slieverue', 'Kilkenny'),
    ('Molly', 'Doyle', '13 The Village', 'Clonroche', 'Wexford'),
    ('Steven', 'Ryan', '25 Upper Street', 'Clonmel', 'Tipperary'),
    ('Paul', 'Doyle', 'The Mews', 'Sycamores', 'Kilkenny'),
    ('Anne', 'Brown', '28 Main Street', 'Tramore', 'Waterford');

-- -------------------------------------------
-- Populate table Department
-- -------------------------------------------    
insert into Department (name, description) values
	('Art', 'This group creates all art for the games'),
    ('Sound', 'This group creates all music/sound effects for the games'),
    ('Game Programmers', 'This group writes the code for the games'),
    ('IT', null),
    ('Quaility Assurance', 'This group handles all testing for the games');
    
-- -------------------------------------------
-- Populate table Role
-- -------------------------------------------
insert into Role (roleId, title, description, parentId) values
	(1, 'Lead Artist', null, null),
    (2,'3D Character Artist', null, 1),
    (3, 'Texture Artist', null, 1),
    (4, '3D Enviroment Artist', null, 1),
    (5, 'Concept Artist', null, 1),
    (6, 'Sprite Artist', null, 1),
    (7, 'Lead Sound Designer', null, null),
    (8, 'Sound Engineer', null, 7),
    (9, 'Lead Programmer', null, null),
    (10, 'AI Programmer', 'Rule-based decisions, scripting', 9),
    (11, 'UI Programmer', 'UI Design, Menus', 9),
    (12, 'Physics Programmer', 'Collision detection, Simulate physics', 9),
    (13, 'Lead QA', 'Responsible for the game working correctly', null),
    (14, 'Level Tester', null, 13),
    (15, 'Tester', 'General Tester', 13),
    (16, 'SDET', 'Software Development Engineer in Test. Builds automated tests', 13);
    
-- -------------------------------------------
-- Populate table Genre
-- -------------------------------------------
insert into Genre (genreId, name, description, parentId) values
	(1, 'Action', null, null),
    (2, 'Platform', 'Centred around jumping to navigate the environment', 1),
    (3, 'Shooter', 'Players use ranged weapons to participate in the action', 1),
    (4, 'Beat em up', 'Primarily involve close-range combat against large waves of enemies', 1),
    (5, 'Role-playing', null, null),
    (6, 'Action RPG', 'Incorporates elements from action games', 5),
    (7, 'MMORPG', 'Massively Multiplayer Role Playing Game', 5),
    (8, 'Roguelikes', 'Randomly generated 2-D dungeon crawl', 5),
    (9, 'Strategy', null, null),
    (10, '4X', 'Strategy with 4 primary goals: eXplore, eXpand, eXploit and eXterminate', 9),
    (11, 'Real-time strategy', null, 9),
    (12, 'Turn-based strategy', null, 9),
    (13, 'Grand strategy', 'Focuses on grand strategy: military strategy at the level of nation states', 9),
    (14, 'Sports', null, null),
    (15, 'Racing', null, 14),
    (16, 'Competitive', 'High competitive factor but does not represent any traditional sports', 14),
    (17, 'Adventure', null, null),
    (18, 'Text adventure', 'Player enters commands and game describes what happens with text', 17),
    (19, 'Graphic adventure', null, 17);
    
-- -------------------------------------------
-- Populate table Game
-- -------------------------------------------
insert into Game (title, releaseDate, genreId) values
    ('XCOM: Enemy Unkown', '2016-02-05', 12),
    ('Red Dead Redemption', '2018-10-15', 3),
    ('Half Life', '2021-03-03', 3);
    
-- -------------------------------------------
-- Populate the table Phase
-- -------------------------------------------
insert into Phase (name, description) values
	('Phase 1', 'Design only'),
    ('Phase 2', 'Programming + level creation'),
    ('Phase 3', 'Testing + bug fixing'),
    ('Released', null);
    
-- -------------------------------------------
-- Populate the table Milestone
-- -------------------------------------------
insert into Milestone (name, description) values
	('Approved for Production', null),
    ('Voice Work Complete', null),
    ('First Model Designed', null),
    ('First Level Designed', null),
    ('Concept Art Complete', null),
    ('First Playable', 'First version that is playable'),
    ('Alpha', 'Key gameplay implemented'),
    ('Beta', 'Only bugs are being worked on, no new code'),
    ('Code Release', 'Game is ready to ship'),
    ('Gold Master', 'Final build');
    
-- -------------------------------------------
-- Populate the table Platform and PC where necessary
-- -------------------------------------------
call insertPlatform('PlayStation 1', null, null, null);
call insertPlatform('PlayStation 2', null, null, null);
call insertPlatform('PlayStation 3', null, null, null);
call insertPlatform('PlayStation 4', null, null, null);
call insertPlatform('Xbox', null, null, null);
call insertPlatform('Xbox 360', null, null, null);
call insertPlatform('Xbox One', null, null, null);
call insertPlatform('GameCube', null, null, null);
call insertPlatform('Wii', null, null, null);
call insertPlatform('PC', 'P', 'Steam', 'https://store.steampowered.com');
call insertPlatform('PC', 'P', 'GOG', 'https://www.gog.com');
call insertPlatform('PC', 'P', 'Origin', 'https://www.origin.com');
call insertPlatform('PC', 'P', 'Uplay', 'https://uplay.ubi.com');

    
-- -------------------------------------------
-- Populate EmployeeMemberOfDepartment
-- -------------------------------------------
insert into EmployeeMemberOfDepartment (employeeId, deptId, startDate, endDate) values
	(1, 5, '2014-01-01', '2016-05-13'),
    (1, 3, '2016-05-14', null),
    (2, 3, '2014-01-01', null),
    (3, 1, '2014-01-01', null),
    (4, 2, '2014-01-01', null),
    (5, 5, '2014-01-01', '2015-08-30'),
    (5, 3, '2015-08-31', null),
    (6, 4, '2014-02-10', null),
    (7, 2, '2014-10-20', null),
    (8, 1, '2014-01-01', null),
    (9, 2, '2014-01-01', null),
    (10, 5, '2014-01-01', '2016-01-01'),
    (10, 4, '2016-01-02', '2017-01-02'),
    (10, 3, '2017-01-03', null),
    (11, 3, '2014-01-01', null),
    (12, 4, '2014-01-01', null),
    (13, 5, '2014-01-01', null),
    (14, 1, '2016-01-01', null),
    (15, 2, '2016-01-01', null),
    (16, 3, '2016-01-01', null),
    (17, 4, '2016-01-01', null),
    (18, 5, '2016-01-01', null),
    (19, 1, '2016-01-01', null),
    (20, 2, '2016-01-01', null),
    (21, 3, '2016-01-01', null),
    (22, 5, '2016-01-01', null),
    (23, 1, '2016-01-01', null),
    (24, 2, '2016-01-01', null),
    (25, 4, '2016-01-01', '2018-07-02'),
    (25, 3, '2018-07-03', null),
    (26, 3, '2016-01-01', null),
    (27, 3, '2016-01-01', null);
    
-- -------------------------------------------
-- Populate the table WorksOn
-- -------------------------------------------
insert into WorksOn (employeeId, gameId, roleId, startDate, endDate) values
	(1, 1, 13, '2014-01-01', '2016-02-05'),
    (5, 1, 15, '2014-03-01', '2016-02-05'),
    (10, 1, 15, '2014-03-01', '2015-01-01'),
    (10, 1, 14, '2015-01-02', '2016-02-05'),
    (13, 1, 16, '2014-03-01', '2016-02-05'),
    (3, 1, 1, '2014-01-01', '2016-02-05'),
    (8, 1, 5, '2014-01-01', '2014-03-01'),
    (8, 1, 2, '2014-03-02', '2014-12-02'),
    (8, 1, 4, '2014-12-03', '2015-06-03'),
    (8, 1, 3, '2015-06-04', '2016-02-05'),
    (4, 1, 7, '2014-01-01', '2016-02-05'),
    (7, 1, 8, '2014-01-01', '2016-02-05'),
    (9, 1, 8, '2014-01-01', '2016-02-05'),
    (2, 1, 9, '2014-01-01', '2016-02-05'),
    (11, 1, 10, '2014-01-01', '2015-08-01'),
    (11, 1, 11, '2015-08-02', '2016-02-05'),
    (3, 2, 1, '2016-01-01', '2018-10-15'),
    (8, 2, 5, '2016-01-01', '2016-04-01'),
    (14, 2, 5, '2016-01-01', '2016-04-01'),
    (19, 2, 5, '2016-01-01', '2016-04-01'),
    (23, 2, 5, '2016-01-01', '2016-04-01'),
    (8, 2, 2, '2016-04-02', '2018-10-15'),
    (14, 2, 2, '2016-04-02', '2018-10-15'),
    (19, 2, 4, '2016-04-02', '2018-10-15'),
    (23, 2, 4, '2016-04-02', '2018-10-15'),
    (4, 2, 7, '2016-01-01', '2018-10-15'),
    (7, 2, 8, '2016-01-01', '2018-10-15'),
    (9, 2, 8, '2016-01-01', '2018-10-15'),
    (15, 2, 8, '2016-01-01', '2018-10-15'),
    (20, 2, 8, '2016-01-01', '2018-10-15'),
    (24, 2, 8, '2016-01-01', '2018-10-15'),
    (1, 2, 10, '2016-01-01', '2018-10-15'),
    (2, 2, 9, '2016-01-01', '2018-10-15'),
    (5, 2, 10, '2016-01-01', '2018-10-15'),
    (11, 2, 10, '2016-01-01', '2018-10-15'),
    (16, 2, 10, '2016-01-01', '2018-10-15'),
    (21, 2, 10, '2016-01-01', '2018-10-15'),
    (26, 2, 11, '2016-01-01', '2018-10-15'),
    (27, 2, 11, '2016-01-01', '2018-10-15'),
    (13, 2, 13, '2016-01-01', '2018-10-15'),
    (18, 2, 15, '2016-01-01', '2018-10-15'),
    (22, 2, 14, '2016-01-01', '2017-01-01'),
    (22, 2, 16, '2016-01-02', '2018-10-15'),
    (3, 3, 1, '2018-11-01', null),
    (8, 3, 5, '2018-11-01', null),
    (14, 3, 5, '2018-11-01', null),
    (19, 3, 5, '2018-11-01', null),
    (23, 3 ,5, '2018-11-01', null),
    (4, 3, 8, '2018-11-01', null),
    (7, 3, 9, '2018-11-01', null),
    (9, 3, 9, '2018-11-01', null),
    (15, 3, 9, '2018-11-01', null),
    (20, 3, 9, '2018-11-01', null),
    (24, 3, 9, '2018-11-01', null),
    (1, 3, 9, '2018-11-01', null),
    (2, 3, 10, '2018-11-01', null),
    (5, 3, 10, '2018-11-01', null),
    (11, 3, 10, '2018-11-01', null),
    (16, 3, 10, '2018-11-01', null),
    (21, 3, 10, '2018-11-01', null),
    (26, 3, 11, '2018-11-01', null),
    (27, 3, 11, '2018-11-01', null),
    (13, 3, 13, '2018-11-01', null),
    (18, 3, 15, '2018-11-01', null),
    (22, 3, 15, '2018-11-01', null);

    
    

-- -------------------------------------------
-- Populate the table GameInPhase
-- -------------------------------------------
insert into GameInPhase (gameId, phaseId, startDate, endDate) values
	(1, 1, '2014-01-01', '2014-07-01'),
    (1, 2, '2014-07-02', '2015-05-02'),
    (1, 3, '2015-05-03', '2016-02-03'),
    (1, 4, '2016-02-04', null),
    (2, 1, '2016-01-01', '2016-08-01'),
    (2, 2, '2016-08-02', '2018-04-02'),
    (2, 3, '2018-04-03', '2018-10-03'),
    (2, 4, '2018-10-04', null),
    (3, 1, '2018-12-01', null);
    
-- -------------------------------------------
-- Populate the table GameHasMetMilestone
-- -------------------------------------------
insert into GameHasMetMileStone (gameId, MilestoneId, date) values
	(1, 1, '2014-01-01'),
    (1, 5, '2014-03-01'),
    (1, 3, '2014-06-14'),
    (1, 4, '2014-08-23'),
    (1, 2, '2015-05-10'),
    (1, 6, '2015-08-20'),
    (1, 7, '2015-10-07'),
    (1, 8, '2015-12-25'),
    (1, 9, '2016-01-07'),
    (1, 10, '2016-02-03'),
    (2, 1, '2016-01-01'),
    (2, 5, '2016-04-01'),
    (2, 3, '2016-06-30'),
    (2, 4, '2016-10-05'),
    (2, 2, '2017-01-01'),
    (2, 6, '2017-10-01'),
    (2, 7, '2018-06-01'),
    (2, 8, '2018-09-30'),
    (2, 9, '2018-10-05'),
    (2, 10, '2018-10-11'),
    (3, 1, '2018-10-20');
    
-- -------------------------------------------
-- Populate the table GameOnPlatform
-- -------------------------------------------
insert into GameOnPlatform (gameId, platformId, dateReleased) values
	(1, 3, '2016-02-20'),
    (1, 6, '2016-02-20'),
    (1, 10, '2016-02-20'),
    (1, 11, '2017-03-07'),
	(2, 4, '2018-10-26'),
    (2, 7, '2018-10-26'),
    (3, 10, null);

drop user if exists ItManager;    
create user ItManager identified by 'boss';
grant all on game_studio.* to ItManager with grant option;

drop user if exists ItSupport;
create user ItSupport identified by 'support';
grant all on game_studio.* to ItSupport;

drop user if exists Employee;
create user Employee identified by 'employee';
grant select on game_studio.* to Employee;
