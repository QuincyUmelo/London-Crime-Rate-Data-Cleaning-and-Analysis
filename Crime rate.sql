SELECT * FROM crime_reports.crime;
SELECT * FROM crime_person;


-- What are the most widespread crime types in London?
select count(crime.Crime_Type_ID) as Occurence, crime_type.Crime
from crime
join crime_type
on crime.Crime_Type_ID=crime_type.Crime_Type_ID
group by crime_type.Crime
Order by count(Crime_Type_ID) desc;

-- Are there any spikes in crime rate at specific months or days?
select count(Crime_ID) as Frequency, monthname(Crime_Date) as Month, month(Crime_Date)
from crime
group by monthname(Crime_Date), month(Crime_Date)
order by month(Crime_Date);

-- crime rate by day
select count(Crime_ID) as Frequency, dayname(Crime_Date) as Day
from crime
group by dayname(Crime_Date)
order by count(Crime_ID) desc;

-- crime rate by month and day
select count(Crime_ID) as Frequency, monthname(Crime_Date) as Month, dayname(Crime_Date) as Day
from crime
group by monthname(Crime_Date), dayname(Crime_Date)
order by monthname(Crime_Date), count(Crime_ID)desc;

-- Which London areas are potential hotspots for a specific crime type?
select Longitude, latitude, crime.Crime_Type_ID, count(crime.Crime_Type_ID) as Occurence, crime_type.Crime
from crime
join crime_type
on crime.Crime_Type_ID=crime_type.Crime_Type_ID
group by Crime_Type_ID, crime_type.Crime, Latitude, Longitude
Order by count(Crime_Type_ID) desc;

-- Which crime types have the highest (and lowest) clearance rates?
select Resolved_1, crime.Crime_Type_ID, count(crime.Crime_Type_ID) as Occurence, crime_type.Crime
from crime
join crime_type
on crime.Crime_Type_ID=crime_type.Crime_Type_ID
group by crime_type.Crime, Resolved_1, Crime_Type_ID
Order by Resolved_1, count(crime.Crime_Type_ID), Crime;

-- Crime type each year and their count
select crime.Crime_Type_ID, count(crime.Crime_Type_ID) as Total, crime_type.Crime, year(Crime_Date) as Year
from crime
join crime_type
on crime.Crime_Type_ID=crime_type.Crime_Type_ID
Group by crime_type.Crime, year(Crime_Date), crime.Crime_Type_ID
order by year(Crime_Date), count(crime.Crime_Type_ID) desc;

-- Number of crimes per year
select count(Crime_Type_ID) as "Crime count", Year(Crime_Date) as Year
from crime
group by Year(Crime_Date)
order by count(Crime_Type_ID) desc;

-- Resolved status for crimes each year
select count(Crime_Type_ID) as Count, Year(Crime_Date) as Year, Resolved_1 as "Resolved Status"
from crime
group by Year(Crime_Date), Resolved_1
order by Year(Crime_Date) desc;

-- Individuals involved in a crime, role played and number of times
select count(distinct crime_person.Crime_ID) as Count, Crime, year(Crime_Date) as Year, Role_, Name_
from crime
join crime_type
on crime.Crime_Type_ID=crime_type.Crime_Type_ID
join crime_person
on crime.Crime_ID=crime_person.Crime_ID
join crime_role
on crime_role.Crime_Role_ID=crime_person.Crime_Role_ID
join people
on people.Person_ID=crime_person.Person_ID
Group by Crime, year(Crime_Date), Role_, Name_
order by year(Crime_Date), Crime desc, count(distinct crime_person.Crime_ID) desc;

-- individuals involed in a crime, number of times and their role
select Crime, Role_, Name_, Year(Crime_Date) as Year, count(crime.Crime_Type_ID) as "Number of Times"
from crime
join crime_person
on crime_person.Crime_ID=crime.Crime_ID
join crime_type
on crime_type.Crime_Type_ID=crime.Crime_Type_ID
join crime_role
on crime_role.Crime_Role_ID=crime_person.Crime_Role_ID
join people
on people.Person_ID=crime_person.Person_ID
where Year(Crime_Date)="2021"
group by Crime, Role_, Name_, Year(Crime_Date)
order by Year(Crime_Date), count(crime.Crime_Type_ID) desc;

-- Offenders in each year for each crime
select Crime, Role_, Year(Crime_Date) as Year, count(crime_person.Crime_ID) as "Number of Individuals"
from crime
join crime_person
on crime_person.Crime_ID=crime.Crime_ID
join crime_type
on crime_type.Crime_Type_ID=crime.Crime_Type_ID
join crime_role
on crime_role.Crime_Role_ID=crime_person.Crime_Role_ID
where Role_=("Victim")
group by Crime, Role_, Year(Crime_Date)
order by Year(Crime_Date), count(crime_person.Crime_ID) desc;

-- individuals, number of times and role as acomplices or offenders
select count(distinct crime_person.Crime_ID) as count, Name_, Role_
from crime_person
join people
on crime_person.Person_ID=people.Person_ID
join crime_role
on crime_role.Crime_Role_ID=crime_person.Crime_Role_ID
where (not Role_ in ("Victim","Witness","Informant")) 
group by Name_, Role_
order by count(distinct crime_person.Crime_ID) desc, Role_ asc;

-- Number of crimes roles each year
select Year(Crime_Date) as Year, Role_, Count(crime_person.Crime_ID) as count
from crime
join crime_person
on crime.Crime_ID=crime_person.Crime_ID
join crime_role
on crime_role.Crime_Role_ID=crime_person.Crime_Role_ID
group by Year(Crime_Date), Role_
order by Year(Crime_Date);

-- Crime rate by ethnicity
select Ethnicity, count(distinct crime_person.Crime_ID) as count
from crime_person
join people
on crime_person.Person_ID=people.Person_ID
group by Ethnicity;

