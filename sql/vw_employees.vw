create or replace force view vw_employees as
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

