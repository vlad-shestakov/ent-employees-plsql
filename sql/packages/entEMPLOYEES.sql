create or replace package entEMPLOYEES is

  -- Created : 07.10.2022 2:12:18
  -- Purpose : Обработка бизнес-логики объектов из таблицы EMPLOYEES
  
  -- 07.10.2022 VSHESTAKOV - v01

  --------------------------------------------------------------- 
  -- КОНСТАНТЫ
  -- Текст сообщения для вновь принятого работника
  C_GREETING_EMP_TEXT constant messages.msg_text%type :=  'Уважаемый %s %s! Вы приняты в качестве %s в подразделение %s. Ваш руководитель: %s %s %s.';
  -- Уважаемый < FIRST_NAME > < LAST_NAME >! Вы приняты в качестве < JOB_TITLE > в подразделение < DEPARTMENT_NAME >. 
  -- Ваш руководитель: < JOB_TITLE > < FIRST_NAME > < LAST_NAME >”.

  -- Текст сообщения для руководителя нового работника
  C_GREETING_MGR_TEXT constant messages.msg_text%type :=  'Уважаемый %s %s! В ваше подразделение принят новый сотрудник %s %s в должности %s с окладом %s.';
  -- Уважаемый < FIRST_NAME > < LAST_NAME >! В ваше подразделение принят новый сотрудник < FIRST_NAME > < LAST_NAME > в должности < JOB_TITLE > с окладом < SALARY >.
  
  ---------------------------------------------------------------
  -- ОШИБКИ
  -- Ошибка  -20101 Не заполнены обязательные параметры (%s)
  EX_EMPLOYMENT_WR_PARAMS     exception;
  EX_EMPLOYMENT_WR_PARAMS_MSG constant varchar2(400) := 'Не заполнены обязательные параметры (%s)';
  pragma exception_init(EX_EMPLOYMENT_WR_PARAMS, -20101); 
        
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
   ,p_manager_id             in employees.manager_id%type
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

  --------------------------------------------------------------- 
  -- Данные о вновьпринятом сотруднике и его руководителе
  cursor CUR_EMPLOYEE(c_employee_id in employees.employee_id%type) is
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
  -- Cредние зарплаты, комиссии по отделу
  cursor CUR_AVG_DEPT_SALARY(
    c_department_id in employees.department_id%type
   ,c_job_id        in employees.job_id%type
  ) 
  is
    select distinct 
           em.department_id
          ,em.job_id
          ,round(avg(em.salary) over ( partition by em.department_id, em.job_id), 2) as avg_dept_salary -- Средняя зарплата сотрудника по отделу
          ,round(avg(em.commission_pct) over ( partition by em.department_id, em.job_id), 2) as avg_dept_commission_pct -- Средняя комиссия сотрудника по отделу
        from EMPLOYEES em
       where 1=1
         and em.department_id = c_department_id
         and em.job_id = c_job_id
    ;/**/ 
    
    
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
   ,p_manager_id             in employees.manager_id%type
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
      ,p_manager_id
      ,p_salary           - не обязательны для заполнения
      ,p_commission_pct     Если они пустые, при добавлении записи эти данные заполняются средними значениями 
                            по подразделению и штатной должности (JOB_ID, DEPARTMENT_ID)
                         
    ИСКЛЮЧЕНИЯ     
      исключения при нарушении ограничений на данные таблицы.
  /**/
  is
    v_row EMPLOYEES%rowtype;
    v_err varchar2(250);
  begin
    
    -- Проверка на обязательные параметры
    select ltrim(decode(p_department_id, null, 'p_department_id') 
           || ', ' || decode(p_job_id, null, 'p_job_id')
           , ', ') 
      into v_err
      from dual;
    if v_err is not null then 
      RAISE_APPLICATION_ERROR(-20101, utl_lms.format_message(EX_EMPLOYMENT_WR_PARAMS_MSG, v_err)); 
    end if;
    
    --dbms_output.put_line('p_salary = ' || p_salary); --< Для отладки 
    --dbms_output.put_line('p_commission_pct = ' || p_commission_pct); --< Для отладки 
    
    v_row.first_name      := p_first_name;
    v_row.last_name       := p_last_name;
    v_row.email           := p_email;
    v_row.phone_number    := p_phone_number;
    v_row.hire_date       := trunc(sysdate);
    v_row.job_id          := p_job_id;
    v_row.department_id   := p_department_id;
    v_row.manager_id      := p_manager_id;
    v_row.salary          := p_salary;
    v_row.commission_pct  := p_commission_pct;
    
    
    -- Если не заполнен размер зп или комиссии
    if p_salary is null or p_commission_pct is null then 
      -- Получим размер зп, или комиссии из среднего по отделу и должности
      for rec in CUR_AVG_DEPT_SALARY(p_department_id, p_job_id)
      loop 
        --dbms_output.put_line('rec.avg_dept_salary = ' || rec.avg_dept_salary); --< Для отладки 
        --dbms_output.put_line('rec.avg_dept_commission_pct = ' || rec.avg_dept_commission_pct); --< Для отладки 
        v_row.salary          := nvl(p_salary, rec.avg_dept_salary);
        v_row.commission_pct  := nvl(p_commission_pct, rec.avg_dept_commission_pct);
      end loop; 
    end if;
    
    -- Создаем сотрудика
    tabEMPLOYEES.ins(p_row => v_row);
    
  end employment; 
  
end entEMPLOYEES;
/
