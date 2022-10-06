-- SqlLog PLSQL exmples HR system 2022-10-06 v01
---------------------------------------------------------------
----        2022-10-09 PLSQL exmples HR system
---------------------------------------------------------------

-- D:\R_STUDIO\PRG\DB projects\2022-10-09 PLSQL exmples HR system\res\SqlLog PLSQL exmples HR system 2022-10-06 v01
---------------------------------------------------------------

---------------------------------------------------------------
-- Регионы
select *
  from REGIONS r
 where 1=1
 order by 1
;/**/ 

-- Страны
select *
  from COUNTRIES c
 where 1=1
 order by 1
;/**/ 

-- Адреса
select *
  from LOCATIONS
 where 1=1
 order by 1
;/**/ 

-- Департаменты
select *
  from DEPARTMENTS
 where 1=1
 order by 1
;/**/


-- Должности
select *
  from JOBS
 where 1=1
 order by 1
;/**/ 

-- Сотрудники 
select *
  from EMPLOYEES
 where 1=1
 order by 1
;/**/ 

-- История должностей
select jh.employee_id
      ,e.first_name || ' ' || e.last_name as emp_name
      ,jh.start_date
      ,jh.end_date
      ,jh.job_id
      ,jh.department_id
  from JOB_HISTORY jh
  left join EMPLOYEES e
    on e.employee_id = jh.employee_id
 where 1=1
 order by e.employee_id, jh.start_date
;/**/
