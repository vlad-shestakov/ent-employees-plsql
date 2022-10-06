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

--------------------------------------------------------------- 
-- Сотрудники 
select *
  from EMPLOYEES
 where 1=1
 order by 1
;/**/ 

select em.*
  from EMPLOYEES em
 where 1=1
   and em.employee_id in 107
 order by 1
;/**/ 

--------------------------------------------------------------- 
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

---------------------------------------------------------------
with
Q_EMPLOYEE as (-- Данные о вновьпринятом сотруднике и его руководителе
  select em.employee_id
        ,em.first_name
        ,em.last_name
        ,j.job_title
        ,d.department_name
        ,em.salary
        ,jmg.job_title   as mgr_job_title
        ,emg.first_name  as mgr_first_name
        ,emg.last_name   as mgr_last_name
        --,em.*
    from EMPLOYEES em
    left join JOBS j
      on j.job_id = em.job_id
    left join DEPARTMENTS d
      on d.department_id = em.department_id
    left join EMPLOYEES emg
      on emg.employee_id = em.manager_id
    left join JOBS jmg
      on jmg.job_id = em.job_id
   where 1=1
     and em.employee_id in 107
) -- Q_PARAMS
select p.*
      --,entEMPLOYEES.C_GREETING_EMP_TEXT
      /*,utl_lms.format_message(
         'Уважаемый %s %s! Вы приняты в качестве %s в подразделение %s. Ваш руководитель: %s %s %s.'
         , TO_CHAR(p.first_name)
         , TO_CHAR(p.last_name)
         , TO_CHAR(p.job_title)
         , TO_CHAR(p.department_name)
         , TO_CHAR(p.mgr_job_title)
         , TO_CHAR(p.mgr_first_name)
         , TO_CHAR(p.mgr_last_name)
       ) as calc_greeting_emp_text
       /**/
  from DUAL
 cross join Q_EMPLOYEE p -- Параметры запроса
;/**/ 
 order by 1
;/**/ 
v_msg := ;  
/* 

  -- Текст сообщения для вновь принятого работника
  C_GREETING_EMP_TEXT constant messages.msg_text%type :=  'Уважаемый %s %s! Вы приняты в качестве %s в подразделение %s. Ваш руководитель: %s %s %s.';
  -- Уважаемый < FIRST_NAME > < LAST_NAME >! Вы приняты в качестве < JOB_TITLE > в подразделение < DEPARTMENT_NAME >. 
  -- Ваш руководитель: < JOB_TITLE > < FIRST_NAME > < LAST_NAME >”.

  -- Текст сообщения для руководителя нового работника
  C_GREETING_MGR_TEXT constant messages.msg_text%type :=  'Уважаемый %s %s! В ваше подразделение принят новый сотрудник %s %s в должности %s с окладом %s';
  -- “Уважаемый < FIRST_NAME > < LAST_NAME >! В ваше подразделение принят новый сотрудник < FIRST_NAME > < LAST_NAME > в должности < JOB_TITLE > с окладом < SALARY >”.
  
/**/
