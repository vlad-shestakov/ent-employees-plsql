create or replace package entEMPLOYEES is

  -- Created : 07.10.2022 2:12:18
  -- Purpose : Обработка бизнес-логики объектов из таблицы EMPLOYEES

  -- 07.10.2022 VSHESTAKOV - v01

  ---------------------------------------------------------------
  -- КОНСТАНТЫ


    С_EMP_MAX_SALARY   CONSTANT employees.salary%type := 350000
    -- Максимальный оклад сотрудника
    ;

    -- Текст сообщения для нового работника
    C_MSG_EMPLT_GREET_EMP_TXT constant messages.msg_text%type :=  'Уважаемый %s %s! Вы приняты в качестве %s в подразделение %s.';
    C_MSG_EMPLT_GREET_EMP_TXT2 constant messages.msg_text%type :=  'Ваш руководитель: %s %s %s.';
    -- Уважаемый < FIRST_NAME > < LAST_NAME >! Вы приняты в качестве < JOB_TITLE > в подразделение < DEPARTMENT_NAME >.
    -- Ваш руководитель: < JOB_TITLE > < FIRST_NAME > < LAST_NAME >”.

    -- Текст сообщения для руководителя нового работника
    C_MSG_EMPLT_GREET_MGR_TXT constant messages.msg_text%type :=  'Уважаемый %s %s! В ваше подразделение принят новый сотрудник %s %s в должности %s с окладом %s.';
    -- Уважаемый < FIRST_NAME > < LAST_NAME >! В ваше подразделение принят новый сотрудник < FIRST_NAME > < LAST_NAME > в должности < JOB_TITLE > с окладом < SALARY >.

    -- Текст сообщения. Повышение зп сотрудника для руководителя
    C_MSG_PAYRISE_MGR_TXT constant messages.msg_text%type :=  'Уважаемый %s %s! Вашему сотруднику %s %s увеличен оклад с %s до %s.';
    -- Уважаемый < FIRST_NAME > < LAST_NAME >! Вашему сотруднику < FIRST_NAME > < LAST_NAME > увеличен оклад с < SALARY old > до < SALARY new >.

    С_MSG_TYPE_EMAIL   CONSTANT messages.msg_type%type := 'email';
    С_MSG_TYPE_SMS   CONSTANT messages.msg_type%type := 'sms';
    С_MSG_TYPE_DEF   CONSTANT messages.msg_type%type := С_MSG_TYPE_EMAIL
    -- Тип отправляемого сообщения по-умолчанию
    ;

  ---------------------------------------------------------------
  -- ОШИБКИ

    -- Ошибка  -20101 Не заполнены обязательные параметры (%s)
    EX_EMPLOYMENT_WR_PARAMS     exception;
    EX_EMPLOYMENT_WR_PARAMS_MSG constant varchar2(400) := 'Не заполнены обязательные параметры (%s)';
    pragma exception_init(EX_EMPLOYMENT_WR_PARAMS, -20101);


    -- Ошибка  -20102 Превышение максимального оклада сотрудника
    EX_PAYRISE_EMP_SALARY_EXCCESS     exception;
    EX_PAYRISE_EMP_SALARY_EXCCESS_MSG constant varchar2(400) := 'Превышение максимального оклада сотрудника';
    pragma exception_init(EX_PAYRISE_EMP_SALARY_EXCCESS, -20102);

  ---------------------------------------------------------------
  function GET_GREETING_MGR_TEXT
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
  function GET_GREETING_EMP_TEXT
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
  procedure MESSAGE_INS
  (
    p_row    in MESSAGES%rowtype
   ,p_update in boolean := false
  )
  /*
    Выполняет вставку новой строки MESSAGES
    Перегрузка по строке

    ПАРАМЕТРЫ
      p_row        - Данные вставляемой записи MESSAGES
      p_update
        true       - если строка с таким индексом уже существует, выполняется обновление данных.
    ИСКЛЮЧЕНИЯ
        исключения при дублировании строк и нарушении других ограничений, наложенных на таблицу.
  /**/
  ;


  ---------------------------------------------------------------
  procedure MESSAGE_INS
  (
    p_msg_text  in messages.msg_text%type
   ,p_dest_addr in messages.dest_addr%type
   ,p_msg_type  in messages.msg_type%type := С_MSG_TYPE_DEF
   ,p_msg_state in messages.msg_state%type := 0
   ,p_update    in boolean := false
  )
  /*
    Выполняет вставку новой строки MESSAGES
    Перегрузка по фактическим полям

    ПАРАМЕТРЫ
      p_msg_text   - текст сообщения
     ,p_dest_addr  - адрес получателя сообщения (email, номер телефона)
     ,p_msg_type   - тип сообщения (email, sms и т.п.)
     ,p_msg_state  - статус обработки сообщения внешней системой (0 - добавлено в очередь, 1 - успешно отправлено, -1 - отправлено с ошибкой)
     ,p_update
        true       - если строка с таким индексом уже существует, выполняется обновление данных.
  /**/
  ;

  ---------------------------------------------------------------
  procedure EMPLOYMENT
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
   ,p_msg_type               in messages.msg_type%type := С_MSG_TYPE_EMAIL -- Тип сообщения для отправки sms / email
  )
  /*
    Процедура реализует функционал приема на работу нового сотрудника.
    - Расчитывает оклад, если не указан
    - Добавляет запись в EMPLOYEES
    - Создает сообщения типа P_MSG_TYPE (email) в таблице MESSAGES для работника и его руководителя (если указан)

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
      ,p_msg_type         - Тип сообщения для отправки sms / email

    ИСКЛЮЧЕНИЯ
      исключения при нарушении ограничений на данные таблицы.
  /**/
  ;

  ---------------------------------------------------------------
  procedure PAYRISE
  (
    p_employee_id            in employees.employee_id%type
   ,p_salary                 in employees.salary%type
  )
  /*
    Процедура реализует повышение оклада сотруднику

    - Если SALARY пусто, необходимо повысить оклад на 10%
    - Создать новое сообщение для руководителя сотрудника
    ПАРАМЕТРЫ
       p_employee_id      - Код сотрудника
      ,p_salary           - Новый оклад (не обязательно)

    ИСКЛЮЧЕНИЯ
      В случае превышения максимального оклада по должности (MAX_SALARY)
  /**/
  ;

end entEMPLOYEES;
/
create or replace package body entEMPLOYEES is

  ---------------------------------------------------------------
  function GET_GREETING_MGR_TEXT
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
    -- Получим сотрудника
    for rec in (--
                select *
                  from VW_EMPLOYEES em
                 where 1=1
                   and em.employee_id = p_id
               )
    loop
      v_res := utl_lms.format_message(
         entEMPLOYEES.C_MSG_EMPLT_GREET_MGR_TXT
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
  function GET_GREETING_EMP_TEXT
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
    -- Получим сотрудника
    for rec in (--
                select *
                  from VW_EMPLOYEES em
                 where 1=1
                   and em.employee_id = p_id
               )
    loop
      v_res := utl_lms.format_message(
         entEMPLOYEES.C_MSG_EMPLT_GREET_EMP_TXT
         --'Уважаемый %s %s! Вы приняты в качестве %s в подразделение %s.'
         , TO_CHAR(rec.first_name)
         , TO_CHAR(rec.last_name)
         , TO_CHAR(rec.job_title)
         , TO_CHAR(rec.department_name)
       );

       -- Если есть руководитель, ссылка на него
       if rec.mgr_last_name is not null then
         v_res := v_res || ' ' || utl_lms.format_message(
           entEMPLOYEES.C_MSG_EMPLT_GREET_EMP_TXT2
           --'Ваш руководитель: %s %s %s.'
           , TO_CHAR(rec.mgr_job_title)
           , TO_CHAR(rec.mgr_first_name)
           , TO_CHAR(rec.mgr_last_name)
         );
       end if;

    end loop;
    return v_res;
  end;


  ---------------------------------------------------------------
  procedure MESSAGE_INS
  (
    p_row    in MESSAGES%rowtype
   ,p_update in boolean := false
  )
  /*
    Выполняет вставку новой строки MESSAGES
    Перегрузка по строке

    ПАРАМЕТРЫ
      p_row        - Данные вставляемой записи MESSAGES
      p_update
        true       - если строка с таким индексом уже существует, выполняется обновление данных.
    ИСКЛЮЧЕНИЯ
        исключения при дублировании строк и нарушении других ограничений, наложенных на таблицу.
    /**/
  is
  begin
    -- Попытка добавить данные
    begin
      insert into MESSAGES
      values p_row;
    exception
      when dup_val_on_index then
        -- Если не удалось по дублю
        -- пробуем обновить
        if p_update then
          update MESSAGES m
             set row = p_row
           where m.id = p_row.id;
        else
          raise;
        end if;
    end;
  end message_ins;

  ---------------------------------------------------------------
  procedure MESSAGE_INS
  (
    p_msg_text  in messages.msg_text%type
   ,p_dest_addr in messages.dest_addr%type
   ,p_msg_type  in messages.msg_type%type := С_MSG_TYPE_DEF
   ,p_msg_state in messages.msg_state%type := 0
   ,p_update    in boolean := false
  )
  /*
    Выполняет вставку новой строки MESSAGES
    Перегрузка по фактическим полям

    ПАРАМЕТРЫ
      p_msg_text   - текст сообщения
     ,p_dest_addr  - адрес получателя сообщения (email, номер телефона)
     ,p_msg_type   - тип сообщения (email, sms и т.п.)
     ,p_msg_state  - статус обработки сообщения внешней системой (0 - добавлено в очередь, 1 - успешно отправлено, -1 - отправлено с ошибкой)
     ,p_update
        true       - если строка с таким индексом уже существует, выполняется обновление данных.
  /**/
  is
    v_row    MESSAGES%rowtype;
  begin

    v_row.msg_text  := p_msg_text;
    v_row.msg_type  := p_msg_type;
    v_row.dest_addr := p_dest_addr;
    v_row.msg_state := p_msg_state;

    message_ins(p_row => v_row, p_update => p_update);

  end message_ins;

  ---------------------------------------------------------------
  procedure EMPLOYMENT
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
   ,p_msg_type               in messages.msg_type%type := С_MSG_TYPE_EMAIL -- Тип сообщения для отправки sms / email
  )
  /*
    Процедура реализует функционал приема на работу нового сотрудника.
    - Расчитывает оклад, если не указан
    - Добавляет запись в EMPLOYEES
    - Создает сообщения типа P_MSG_TYPE (email) в таблице MESSAGES для работника и его руководителя (если указан)

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
      ,p_msg_type         - Тип сообщения для отправки sms / email

    ИСКЛЮЧЕНИЯ
      исключения при нарушении ограничений на данные таблицы.
  /**/
  is
  
      
      -- Cредние зарплаты, комиссии по отделу и должности
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
             and em.department_id = C_DEPARTMENT_ID
             and em.job_id = C_JOB_ID
        ;/**/
        
    v_row        EMPLOYEES%rowtype;
    v_err        varchar2(250);
    v_emp_msg    messages.msg_text%type;
    v_mgr_msg    messages.msg_text%type;
    v_mgr_addr   messages.dest_addr%type;
    v_emp_addr   messages.dest_addr%type;
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

    v_row.employee_id     := EMPLOYEES_SEQ.Nextval;
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
        v_row.salary          := nvl(p_salary, rec.avg_dept_salary);
        v_row.commission_pct  := nvl(p_commission_pct, rec.avg_dept_commission_pct);
      end loop;
    end if;

    -- Создаем сотрудика
    tabEMPLOYEES.ins(p_row => v_row);

    -- Получим тексты сообщений и, адрес руководителя и сотрудника
    select entEMPLOYEES.get_greeting_emp_text(v_row.employee_id) as emp_msg
          ,entEMPLOYEES.get_greeting_mgr_text(v_row.employee_id) as mgr_msg
          ,decode(p_msg_type, С_MSG_TYPE_EMAIL, emg.email, emg.phone_number) -- телефон или email руководителя
          ,decode(p_msg_type, С_MSG_TYPE_EMAIL, v_row.email, v_row.phone_number) -- телефон или email сотрудника
      into v_emp_msg, v_mgr_msg, v_mgr_addr, v_emp_addr
      from dual
      left join EMPLOYEES em
        on em.employee_id = v_row.employee_id
      left join EMPLOYEES emg
        on emg.employee_id = em.manager_id;

    dbms_output.put_line('  v_mgr_addr = ' || v_mgr_addr); --< Для отладки
    dbms_output.put_line('  v_emp_addr = ' || v_emp_addr); --< Для отладки

    if v_mgr_addr is not null then
      -- Отправляем почту руководителю сотрудника
      entEMPLOYEES.message_ins(
          p_msg_text  => v_mgr_msg
         ,p_msg_type  => p_msg_type
         ,p_dest_addr => v_mgr_addr);
    end if;

    -- Отправляем почту новому сотруднику
    entEMPLOYEES.message_ins(
        p_msg_text  => v_emp_msg
       ,p_msg_type  => p_msg_type
       ,p_dest_addr => v_emp_addr);

  end EMPLOYMENT;


  ---------------------------------------------------------------
  procedure PAYRISE
  (
    p_employee_id            in employees.employee_id%type
   ,p_salary                 in employees.salary%type
  )
  /*
    Процедура реализует повышение оклада сотруднику

    - Если SALARY пусто, необходимо повысить оклад на 10%
    - Создать новое сообщение для руководителя сотрудника
    ПАРАМЕТРЫ
       p_employee_id      - Код сотрудника
      ,p_salary           - Новый оклад (не обязательно)

    ИСКЛЮЧЕНИЯ
      В случае превышения максимального оклада по должности (MAX_SALARY)
  /**/
  is
  begin
    null;
  end PAYRISE; 
  
end entEMPLOYEES;
/
