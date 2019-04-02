use game_studio;

-- -------------------------------------------
-- 1. Select all games that Richard Whitney has worked on
-- -------------------------------------------
select title
from game
join worksOn
on worksOn.gameId = game.gameId
join employee
on employee.employeeId = worksOn.employeeId
where employee.fName = 'Richard' and employee.lName = 'Whitney'
order by 1;

-- --------------------------------------------
-- 2. Select all employees that worked on XCOM: Enemy Unkown
-- --------------------------------------------
select concat(fname, ' ', lname) as Name
from employee
where exists (
	select * 
    from worksOn 
    join game
    on worksOn.gameId = game.gameId
    where worksOn.employeeId = employee.employeeId and game.title = 'XCOM: Enemy Unkown'
);

-- --------------------------------------------
-- 3. Select all games worked on in 2016
-- --------------------------------------------
select distinct title
from game
join worksOn
on worksOn.gameId = game.gameId
where worksOn.startDate < 01/01/2017 or 
	  worksOn.endDate >= 01/01/2016;
      
-- --------------------------------------------
-- 4. Select all employess and their current projects
-- --------------------------------------------
select concat(fname, ' ', lname) as Name, title
from employee
left outer join (
	select distinct worksOn.employeeId, game.title
    from worksOn
    join game
	on worksOn.gameId = game.gameId
    where worksOn.endDate is null) as a
on a.employeeId = employee.employeeId
order by employee.fname, employee.lname;

-- --------------------------------------------
-- 5. Select all employees and their current roles
-- --------------------------------------------
select concat(fname, ' ', lname) as Name, title
from employee
left outer join (
	select distinct worksOn.employeeId, role.title
    from worksOn
    join role
    on worksOn.roleId = role.roleId
    where worksOn.endDate is null) as a
on a.employeeId = employee.employeeId
order by employee.fname, employee.lname;

-- --------------------------------------------
-- 6. Select all employees and the department they currently work in
-- --------------------------------------------
select concat(fname, ' ', lname) as Name, name
from employee
join employeeMemberOfDepartment
on employeeMemberOfDepartment.employeeId = employee.employeeId
join department
on department.deptId = employeeMemberOfDepartment.deptId
where employeeMemberOfDepartment.endDate is null;

-- --------------------------------------------
-- 7. Select all employees that worked on Red Dead Redemption and their roles during the development
-- --------------------------------------------
select concat(fname, ' ', lname) as Name, role.title, startDate, endDate
from employee
join worksOn
on worksOn.employeeId = employee.employeeId
join role
on worksOn.roleId = role.roleId
join game
on worksOn.gameId = game.gameId
where game.title = 'Red Dead Redemption'
order by employee.fname, employee.lname;

-- --------------------------------------------
-- 8. Select the current game in development, the current phase it is in
--    and the date it entered the phase
-- --------------------------------------------
select distinct title, name, gameInPhase.startDate
from game
join worksOn
on worksOn.gameId = game.gameId
join gameInPhase
on game.gameId = gameInPhase.gameId
join phase
on gameInPhase.phaseId = phase.phaseId
where worksOn.endDate is null and gameInPhase.endDate is null;

-- -------------------------------------------
-- 9. Create phaseDetails view
--    Each record with have an employeeID, game title, role and role description
-- -------------------------------------------
drop view if exists phaseDetails;
create view phaseDetails as select distinct employeeId, name, description, title
from phase
join gameInPhase
on gameInPhase.phaseId = phase.phaseId
join game 
on gameInPhase.gameId = game.gameId
join worksOn
on game.gameId = worksOn.gameId;
-- --------------------------------------------
-- 9. Display the number of employees working on XCOM: Enemy Unkown during each phase of development
-- --------------------------------------------
select * from phaseDetails;
select name, description, count(*) as 'Nuber of Employees'
from phaseDetails
where title = 'XCOM: Enemy Unkown'
group by name;

-- --------------------------------------------
-- 10. Create view DevelopmentDetails
--     Stores the milestones for each game achieved, orderd by date
-- --------------------------------------------
drop view if exists developmentDetails;
create view developmentDetails as select title, name, date 
from game
join gameHasMetMilestone
on game.gameId = gameHasMetMilestone.gameId
join milestone
on gameHasMetMilestone.milestoneId = milestone.milestoneId
order by date;
-- --------------------------------------------
-- 10. Select all records
-- --------------------------------------------
select * from developmentDetails;
-- --------------------------------------------
-- 10. List how long each game was in development
--     Currently doesn't work for games that are still in development
-- --------------------------------------------
select title,
	   datediff(Max(date),
                Min(date))
				as 'Days of Development'
from developmentDetails
group by title;





    
    