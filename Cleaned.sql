Select *
From working..Power_Bi
--------------------------------------------------------------------------
-- I tried using Substring to seperate the Column into Unique value by cutting it from where ( start but it doesn't work,
-- I don't know the reason, I guess I'll find out later.

Select 
Substring([Q1 - Which Title Best Fits your Current Role?], 1, CHARINDEX('(', [Q1 - Which Title Best Fits your Current Role?]) -1) as JobTitle
, Substring([Q1 - Which Title Best Fits your Current Role?], CHARINDEX('(', [Q1 - Which Title Best Fits your Current Role?]) +1, LEN([Q1 - Which Title Best Fits your Current Role?])) as Others
From working..Power_Bi

-----------------------------------------------------------------------------------
Select *
From working..Power_Bi
-- I had to do this because the Column name is too long
ALTER TABLE working..Power_Bi
Add Current_role nvarchar(255);

UPDATE working..Power_Bi
SET Current_role = [Q1 - Which Title Best Fits your Current Role?]


-- I have to apply the same strategy to some other columns
ALTER TABLE working..Power_Bi
Add CurrentIndustry nvarchar(255);

UPDATE working..Power_Bi
SET CurrentIndustry = [Q4 - What Industry do you work in?]

------------------------------------------------------------------

ALTER TABLE working..Power_Bi
Add FavProgramminglanguage nvarchar(255);

UPDATE working..Power_Bi
SET FavProgramminglanguage = [Q5 - Favorite Programming Language]

---------------------------------------------------------------------------------

ALTER TABLE working..Power_Bi
Add Country nvarchar(225);

UPDATE working..Power_Bi
SET Country = [Q11 - Which Country do you live in?]

-----------------------------------------------------------------------------------

ALTER TABLE working..Power_Bi
Add Salary nvarchar(225);

UPDATE working..Power_Bi
SET Salary = [Q3 - Current Yearly Salary (in USD)]

------------------------------------------------------------------------------------
--So, I decided to use PARSENAME instead of Substring
-- Guess what!
-- It works but not perfect.
Select 
PARSENAME(REPLACE(Current_role, ':', '.') , + 1)
,PARSENAME(REPLACE(Current_role, '(', '.') , 2)
From working..Power_Bi

ALTER TABLE working..Power_Bi
Add CurrentRoleSplit nvarchar(255);

UPDATE working..Power_Bi
SET CurrentRoleSplit = PARSENAME(REPLACE(Current_role, ':', '.') , + 1)

-----------------------------------------------------------------------------

Select 
PARSENAME(REPLACE(CurrentIndustry, ':', '.') ,  1)
,PARSENAME(REPLACE(CurrentIndustry, '(', '.') , 3)
,PARSENAME(REPLACE(CurrentIndustry, '(', '.') , 2)
From working..Power_Bi

ALTER TABLE working..Power_Bi
Add CurrentIndustrySplit nvarchar(255);

UPDATE working..Power_Bi
SET CurrentIndustrySplit = PARSENAME(REPLACE(CurrentIndustry, ':', '.') , 1)

-----------------------------------------------------------------------------------------
Select *
From working..Power_Bi

Select 
PARSENAME(REPLACE(FavProgramminglanguage, ':', '.') ,  1)
,PARSENAME(REPLACE(FavProgramminglanguage, '(', '.') , 2)
,PARSENAME(REPLACE(FavProgramminglanguage, ':', '.') , 3)
From working..Power_Bi

ALTER TABLE working..Power_Bi
Add FavProgramminglanguageSplit nvarchar(255);

UPDATE working..Power_Bi
SET FavProgramminglanguageSplit = PARSENAME(REPLACE(FavProgramminglanguage, ':', '.') ,  1)
----------------------------------------------------------------------------------------------------

Select 
PARSENAME(REPLACE(Country, ':', '.') ,  1)
,PARSENAME(REPLACE(Country, '(', '.') , 2)
,PARSENAME(REPLACE(Country, ':', '.') , 3)
From working..Power_Bi

ALTER TABLE working..Power_Bi
Add CountryeSplit nvarchar(255);

UPDATE working..Power_Bi
SET CountryeSplit = PARSENAME(REPLACE(Country, ':', '.') ,  1)

----------------------------------------------------------------------------------------

Select 
Substring(Salary, 1, CHARINDEX('k', Salary) -1) as Salary_Min
, Substring(Salary, CHARINDEX('-', Salary) +1, LEN(Salary)) as Salary_Max
--, Substring(Salary, CHARINDEX('k', Salary) -1) LEN(Salary))
From working..Power_Bi

-- So after using Substring Function to seperate them, I didnt get Perfect values that i want
-- e.g the minimum is still having values like 0-40, while the Max is still having k
-- I still habe to do some clear on it again after creating the columns

ALTER TABLE working..Power_Bi
Add SalaryMin nvarchar(255);


ALTER TABLE working..Power_Bi
Add SalaryMax nvarchar(255);


UPDATE working..Power_Bi
SET SalaryMin = Substring(Salary, 1, CHARINDEX('k', Salary) -1)


UPDATE working..Power_Bi
SET SalaryMax = Substring(Salary, CHARINDEX('-', Salary) +1, LEN(Salary))

-- Here is the final clean-up on the columns

Select 
Substring(SalaryMin, CHARINDEX('-', SalaryMin) +1, LEN(SalaryMin)) as Salary_Min
From working..Power_Bi

Select 
Substring(SalaryMax, 1, CHARINDEX('k', SalaryMax) -1) as Salary_Max
From working..Power_Bi


ALTER TABLE working..Power_Bi
Add SalaryMinF int;


ALTER TABLE working..Power_Bi
Add SalaryMaxF int;

UPDATE working..Power_Bi
SET SalaryMinF = Substring(SalaryMin, CHARINDEX('-', SalaryMin) +1, LEN(SalaryMin))


UPDATE working..Power_Bi
SET SalaryMaxF = Substring(SalaryMax, 1, CHARINDEX('k', SalaryMax) -1)





-- It's done perfectly at last Hurray!!!
----------------------------------------------------------------------------------------
Select *
From working..Power_Bi

-- I used this to remove all empty and irrelivant columns
ALTER TABLE working..Power_Bi
DROP COLUMN SalaryMin, SalaryMax, Country, Salary, [Q12 - Highest Level of Education]
, [Q11 - Which Country do you live in?], [Q3 - Current Yearly Salary (in USD)]