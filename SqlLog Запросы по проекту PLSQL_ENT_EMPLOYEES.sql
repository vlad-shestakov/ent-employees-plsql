-- SqlLog Запросы по проекту PLSQL_ENT_EMPLOYEES

---------------------------------------------------------------
/
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

select em.*, em.rowid
  from EMPLOYEES em
 where 1=1
   --and em.employee_id in 107
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

/* 
  -- Текст сообщения для вновь принятого работника
  C_GREETING_EMP_TEXT constant messages.msg_text%type :=  'Уважаемый %s %s! Вы приняты в качестве %s в подразделение %s. Ваш руководитель: %s %s %s.';
  -- Уважаемый < FIRST_NAME > < LAST_NAME >! Вы приняты в качестве < JOB_TITLE > в подразделение < DEPARTMENT_NAME >. 
  -- Ваш руководитель: < JOB_TITLE > < FIRST_NAME > < LAST_NAME >”.

  -- Текст сообщения для руководителя нового работника
  C_GREETING_MGR_TEXT constant messages.msg_text%type :=  'Уважаемый %s %s! В ваше подразделение принят новый сотрудник %s %s в должности %s с окладом %s';
  -- “Уважаемый < FIRST_NAME > < LAST_NAME >! В ваше подразделение принят новый сотрудник < FIRST_NAME > < LAST_NAME > в должности < JOB_TITLE > с окладом < SALARY >”.
  
/**/

select entEMPLOYEES.get_greeting_emp_text(108) as emp_msg
      ,entEMPLOYEES.get_greeting_mgr_text(108) as mgr_msg
  from dual; 

---------------------------------------------------------------
/* 

      ,p_salary           - не обязательны для заполнения
      ,p_commission_pct     Если они пустые, при добавлении записи эти данные заполняются средними значениями 
                            по подразделению и штатной должности (JOB_ID, DEPARTMENT_ID)
/**/

-- Данные о новом сотруднике и его руководителе
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
     
;


select -- Данные о сотруднике, руководителе
       em.employee_id
      ,em.first_name
      ,em.last_name
       --,em.first_name || ' ' || em.last_name as full_name
      ,em.job_id
      ,j.job_title
      ,em.department_id
      ,d.department_name
      ,em.salary
      ,em.commission_pct
      ,em.manager_id
      ,jmg.job_title     as mgr_job_title
      ,emg.first_name    as mgr_first_name
      ,emg.last_name     as mgr_last_name
       --,emg.first_name || ' ' || emg.last_name as mgr_full_name
      ,em.email
      ,em.phone_number
      ,em.hire_date
      ,em.upd_counter
      ,em.crt_user
      ,em.crt_date
      ,em.upd_user
      ,em.upd_date
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
   --and em.employee_id in 107
     
;

-- Данные сотрудника и работодателя
select em.employee_id
      ,em.first_name
      ,em.last_name
      ,em.salary 
      ,em.manager_id
      ,em.mgr_job_title
      ,em.mgr_first_name
      ,em.mgr_last_name
      ,em.email
      ,em.phone_number
      ,em.mgr_email
      ,em.mgr_phone_number
      --,em.*
  from VW_EMPLOYEES em
 where 1=1
   and em.employee_id in (108)
 order by 1
;/**/ 
-- 

--------------------------------------------------------------- 
-- Сотрудники и средние зарплаты по отделу
select --distinct 
       em.department_id
      ,em.job_id
      ,em.employee_id
      ,em.salary
      ,round(avg(em.salary) over ( partition by em.department_id, em.job_id), 2) as avg_dept_salary -- Средняя зарплата сотрудника по отделу
      --,round(AVG(em.salary) over ( partition by em.department_id, em.job_id order by em.department_id, em.job_id range between unbounded preceding and unbounded following), 2) as avg_dept_salary2
      --,em.*
    from EMPLOYEES em
   where 1=1
     and em.department_id = 50
     and em.job_id = 'ST_CLERK'
    -- and em.employee_id in 107
--order by em.department_id, em.job_id, em.salary
;/**/ 


--------------------------------------------------------------- 
-- Cредние зарплаты по отделу
select distinct 
       em.department_id
      ,em.job_id
      --,em.employee_id
      --,em.salary
      ,round(avg(em.salary) over ( partition by em.department_id, em.job_id), 2) as avg_dept_salary -- Средняя зарплата сотрудника по отделу
      --,round(AVG(em.salary) over ( partition by em.department_id, em.job_id order by em.department_id, em.job_id range between unbounded preceding and unbounded following), 2) as avg_dept_salary2
      --,em.*
    from EMPLOYEES em
   where 1=1
     and em.department_id = 50
     and em.job_id = 'ST_CLERK'
    -- and em.employee_id in 107
;/**/ 

---------------------------------------------------------------
-- События интеграции
select *
  from MESSAGES
 where 1=1
 order by 1 desc
;/**/ 


