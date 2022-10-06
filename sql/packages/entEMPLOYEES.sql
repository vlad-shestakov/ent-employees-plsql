create or replace package entEMPLOYEES is

  -- Created : 07.10.2022 2:12:18
  -- Purpose : Обработка бизнес-логики объектов из таблицы EMPLOYEES
  
  -- 07.10.2022 VSHESTAKOV - v01

  -- Текст сообщения для вновь принятого работника
  C_GREETING_EMP_TEXT constant messages.msg_text%type :=  'Уважаемый %s %s! Вы приняты в качестве %s в подразделение %s. Ваш руководитель: %s %s %s”.';
  -- Уважаемый < FIRST_NAME > < LAST_NAME >! Вы приняты в качестве < JOB_TITLE > в подразделение < DEPARTMENT_NAME >. 
  -- Ваш руководитель: < JOB_TITLE > < FIRST_NAME > < LAST_NAME >”.

  -- Текст сообщения для руководителя нового работника
  C_GREETING_MGR_TEXT constant messages.msg_text%type :=  'Уважаемый %s %s! В ваше подразделение принят новый сотрудник %s %s в должности %s с окладом %s';
  -- “Уважаемый < FIRST_NAME > < LAST_NAME >! В ваше подразделение принят новый сотрудник < FIRST_NAME > < LAST_NAME > в должности < JOB_TITLE > с окладом < SALARY >”.
  
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
