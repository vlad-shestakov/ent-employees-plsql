create or replace package entEMPLOYEES is

  -- Created : 07.10.2022 2:12:18
  -- Purpose : Обработка бизнес-логики объектов из таблицы EMPLOYEES
  
  -- 07.10.2022 VSHESTAKOV - v01

  -- Текст сообщения для вновь принятого работника
  C_GREETING_EMP_TEXT constant messages.msg_text%type :=  'Уважаемый %s %s! Вы приняты в качестве %s в подразделение %s. Ваш руководитель: %s %s %s.';
  -- Уважаемый < FIRST_NAME > < LAST_NAME >! Вы приняты в качестве < JOB_TITLE > в подразделение < DEPARTMENT_NAME >. 
  -- Ваш руководитель: < JOB_TITLE > < FIRST_NAME > < LAST_NAME >”.

  -- Текст сообщения для руководителя нового работника
  C_GREETING_MGR_TEXT constant messages.msg_text%type :=  'Уважаемый %s %s! В ваше подразделение принят новый сотрудник %s %s в должности %s с окладом %s.';
  -- Уважаемый < FIRST_NAME > < LAST_NAME >! В ваше подразделение принят новый сотрудник < FIRST_NAME > < LAST_NAME > в должности < JOB_TITLE > с окладом < SALARY >.
  
  --------------------------------------------------------------- 
  function get_greeting_emp_text
  (
    p_id  in employees.employee_id%type
  )
  return messages.msg_text%type
  /* 
    Возвращяет текст сообщения для работника
    
    ПАРАМЕТРЫ
      p_id - Код сотрудника
  /**/
  ;
  
  --------------------------------------------------------------- 
  function get_greeting_mgr_text
  (
    p_id  in employees.employee_id%type
  )
  return messages.msg_text%type
  /* 
    Возвращяет текст сообщения для руководителя работника
    
    ПАРАМЕТРЫ
      p_id - Код сотрудника
  /**/
  ;
  
  --------------------------------------------------------------- 
  procedure employment
  (
    p_first_name             in employees.first_name%type
   ,p_last_name              in employees.last_name%type
   ,p_email                  in employees.email%type
   ,p_phone_number           in employees.phone_number%type
   ,p_job_id                 in employees.job_id%type
   ,p_department_id          in employees.department_id%type
   ,p_salary                 in employees.salary%type
   ,p_commission_pct         in employees.commission_pct%type
  )
  /* 
    Процедура реализует функционал приема на работу нового сотрудника.
    - Добавляет запись в EMPLOYEES
    - Создает сообщения типа email в таблице MESSAGES для работника и его руководителя
    
    ПАРАМЕТРЫ
       p_first_name       - Поля карточки EMPLOYEES
      ,p_last_name            
      ,p_email                
      ,p_phone_number         
      ,p_job_id               
      ,p_department_id
      ,p_salary           - не обязательны для заполнения
      ,p_commission_pct     Если они пустые, при добавлении записи эти данные заполняются средними значениями 
                            по подразделению и штатной должности (JOB_ID, DEPARTMENT_ID)
                         
    ИСКЛЮЧЕНИЯ     
      исключения при нарушении ограничений на данные таблицы.
  /**/
  ;

end entEMPLOYEES;
/
create or replace package body entEMPLOYEES is

 
  -- Данные о вновьпринятом сотруднике и его руководителе
  cursor CUR_EMPLOYEE(c_employee_id in number) is
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
       and em.employee_id = c_employee_id;
     
  --------------------------------------------------------------- 
  function get_greeting_mgr_text
  (
    p_id  in employees.employee_id%type
  )
  return messages.msg_text%type
  /* 
    Возвращяет текст сообщения для руководителя работника
    
    ПАРАМЕТРЫ
      p_id - Код сотрудника
  /**/
  is
    v_res messages.msg_text%type;
  begin
    for rec in CUR_EMPLOYEE(p_id)
    loop 
      v_res := utl_lms.format_message(
         entEMPLOYEES.C_GREETING_MGR_TEXT
         --'Уважаемый %s %s! В ваше подразделение принят новый сотрудник %s %s в должности %s с окладом %s'
         , TO_CHAR(rec.mgr_first_name)
         , TO_CHAR(rec.mgr_last_name)
         , TO_CHAR(rec.first_name)
         , TO_CHAR(rec.last_name)
         , TO_CHAR(rec.job_title)
         , TO_CHAR(rec.salary)
       );
    end loop; 
    return v_res;
  end;   
  
    --------------------------------------------------------------- 
  function get_greeting_emp_text
  (
    p_id  in employees.employee_id%type
  )
  return messages.msg_text%type
  /* 
    Возвращяет текст сообщения для работника
    
    ПАРАМЕТРЫ
      p_id - Код сотрудника
  /**/
  is
    v_res messages.msg_text%type;
  begin
    for rec in CUR_EMPLOYEE(p_id)
    loop 
      v_res := utl_lms.format_message(
         entEMPLOYEES.C_GREETING_EMP_TEXT
         --'Уважаемый %s %s! Вы приняты в качестве %s в подразделение %s. Ваш руководитель: %s %s %s.'
         , TO_CHAR(rec.first_name)
         , TO_CHAR(rec.last_name)
         , TO_CHAR(rec.job_title)
         , TO_CHAR(rec.department_name)
         , TO_CHAR(rec.mgr_job_title)
         , TO_CHAR(rec.mgr_first_name)
         , TO_CHAR(rec.mgr_last_name)
       );
    end loop; 
    return v_res;
  end;   
  
  --------------------------------------------------------------- 
  procedure employment
  (
    p_first_name             in employees.first_name%type
   ,p_last_name              in employees.last_name%type
   ,p_email                  in employees.email%type
   ,p_phone_number           in employees.phone_number%type
   ,p_job_id                 in employees.job_id%type
   ,p_department_id          in employees.department_id%type
   ,p_salary                 in employees.salary%type
   ,p_commission_pct         in employees.commission_pct%type
  )
  /* 
    Процедура реализует функционал приема на работу нового сотрудника.
    - Добавляет запись в EMPLOYEES
    - Создает сообщения типа email в таблице MESSAGES для работника и его руководителя
    
    ПАРАМЕТРЫ
       p_first_name       - Поля карточки EMPLOYEES
      ,p_last_name            
      ,p_email                
      ,p_phone_number         
      ,p_job_id               
      ,p_department_id
      ,p_salary           - не обязательны для заполнения
      ,p_commission_pct     Если они пустые, при добавлении записи эти данные заполняются средними значениями 
                            по подразделению и штатной должности (JOB_ID, DEPARTMENT_ID)
                         
    ИСКЛЮЧЕНИЯ     
      исключения при нарушении ограничений на данные таблицы.
  /**/
  is
  begin
    null;
  end employment; 
  
end entEMPLOYEES;
/
