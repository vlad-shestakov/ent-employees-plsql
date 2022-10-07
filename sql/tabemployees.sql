create or replace package tabEMPLOYEES is

  -- Author  : VSHESTAKOV
  -- Created : 06.10.2022 17:15:18
  -- Purpose : Обработка операций чтения/записи данных в таблицу EMPLOYEES

  -- 07.10.2022 USER - v01

  ---------------------------------------------------------------
  -- КОНСТАНТЫ

    С_MSG_TYPE_EMAIL   CONSTANT messages.msg_type%type := 'email';
    С_MSG_TYPE_SMS   CONSTANT messages.msg_type%type := 'sms';
    С_MSG_TYPE_DEF   CONSTANT messages.msg_type%type := С_MSG_TYPE_EMAIL
    -- Тип отправляемого сообщения по-умолчанию
    ;


  ---------------------------------------------------------------
  -- КУРСОРЫ


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

  ---------------------------------------------------------------
  procedure JOB_SEL
  (
    p_job_id    in  JOBS.job_id %type
   ,p_row       out JOBS%rowtype
   ,p_raise     in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы JOBS

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы JOBS
      p_row        - Возвращаемая запись JOBS
      p_raise
        true       - происходит вызов исключений
        false      - исключения игнорируются

  /**/
  ;

  ---------------------------------------------------------------
  procedure DEPARTMENTS_SEL
  (
    p_department_id  in  DEPARTMENTS.department_id%type
   ,p_row            out DEPARTMENTS%rowtype
   ,p_raise          in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы DEPARTMENTS

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы DEPARTMENTS
      p_row        - Возвращаемая запись DEPARTMENTS
      p_raise
        true       - происходит вызов исключений
        false      - исключения игнорируются

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
  procedure SEL
  (
    p_id        in EMPLOYEES.EMPLOYEE_ID%type
   ,p_row       out EMPLOYEES%rowtype
   ,p_forUpdate in boolean := false
   ,p_raise     in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
      p_row        - Возвращаемая запись EMPLOYEES
      p_forUpdate
        true     - выполняется SELECT … FOR UPDATE
        false    - обычный SELECT
      p_raise
        true     - происходит вызов исключений
        false    - исключения игнорируются

    /**/
  ;

  ---------------------------------------------------------------
  procedure INS
  (
    p_row    in EMPLOYEES%rowtype
   ,p_update in boolean := false
  )
  /*
    Выполняет вставку новой строки EMPLOYEES

    ПАРАМЕТРЫ
      p_row        - Данные вставляемой записи EMPLOYEES
      p_update
        true       - если строка с таким индексом уже существует, выполняется обновление данных.
    ИСКЛЮЧЕНИЯ
        исключения при дублировании строк и нарушении других ограничений, наложенных на таблицу.
    /**/
  ;


  ---------------------------------------------------------------
  procedure UPD
  (
    p_row    in EMPLOYEES%rowtype
   ,p_insert in boolean := false
  )
  /*
    Процедура выполняет обновление данных в строке (кроме первичного ключа) EMPLOYEES

    ПАРАМЕТРЫ
      p_row        - Данные записи EMPLOYEES
      p_insert
        true     - если строка с таким индексом не существует, выполняется вставка новой строки.
    ИСКЛЮЧЕНИЯ
        исключения при дублировании строк и нарушении других ограничений, наложенных на таблицу.
    /**/
  ;

  ---------------------------------------------------------------
  procedure DEL
  (
    p_id in EMPLOYEES.employee_id%type
  )
  /*
    Процедура выполняет удаление строки данных EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
    /**/
  ;

  ---------------------------------------------------------------
  function EXIST
  (
    p_id in EMPLOYEES.employee_id%type
  )
  return boolean
  /*
    Функция возвращает истину, если строка с указанным ключом существует в таблице EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
    /**/
  ;

end tabEMPLOYEES;
/
create or replace package body tabEMPLOYEES is

  ---------------------------------------------------------------
  procedure JOB_SEL
  (
    p_job_id    in  JOBS.job_id %type
   ,p_row       out JOBS%rowtype
   ,p_raise     in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы JOBS

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы JOBS
      p_row        - Возвращаемая запись JOBS
      p_raise
        true       - происходит вызов исключений
        false      - исключения игнорируются

  /**/
  is
  begin

    for rec in (--
                select j.*
                  from JOBS j
                 where j.job_id in p_job_id
                )
    loop
      p_row := rec;
    end loop;

  exception
    when others then
      -- Если флаг обработки исключений включен - обрабатываем
      if p_raise then
        raise;
      end if;
      -- Иначе - нет
  end JOB_SEL;

  ---------------------------------------------------------------
  procedure DEPARTMENTS_SEL
  (
    p_department_id  in  DEPARTMENTS.department_id%type
   ,p_row            out DEPARTMENTS%rowtype
   ,p_raise          in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы DEPARTMENTS

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы DEPARTMENTS
      p_row        - Возвращаемая запись DEPARTMENTS
      p_raise
        true       - происходит вызов исключений
        false      - исключения игнорируются

  /**/
  is
  begin

    for rec in (--
                select d.*
                  from DEPARTMENTS d
                 where d.department_id in p_department_id
                )
    loop
      p_row := rec;
    end loop;

  exception
    when others then
      -- Если флаг обработки исключений включен - обрабатываем
      if p_raise then
        raise;
      end if;
      -- Иначе - нет
  end DEPARTMENTS_SEL;

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
  procedure SEL
  (
    p_id        in EMPLOYEES.EMPLOYEE_ID%type
   ,p_row       out EMPLOYEES%rowtype
   ,p_forUpdate in boolean := false
   ,p_raise     in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
      p_row        - Возвращаемая запись EMPLOYEES
      p_forUpdate
          true     - выполняется SELECT … FOR UPDATE
          false    - обычный SELECT
      p_raise
          true     - происходит вызов исключений
          false    - исключения игнорируются

    /**/
   is
    -- Выборка сотрудника для обновления
    cursor CUR_EMPLOYEES(c_employee_id in number) is
      select em.*
        from EMPLOYEES em
       where em.employee_id in c_employee_id;

    -- Выборка сотрудника без обновления
    cursor CUR_EMPLOYEES_FU(c_employee_id in number) is
      select em.*
        from EMPLOYEES em
       where em.employee_id in c_employee_id
         for update;

  begin

    if p_forUpdate then

      for rec in CUR_EMPLOYEES_FU(p_id)
      loop
        p_row := rec;
      end loop;

    else
      -- Выборка без обновления
      for rec in CUR_EMPLOYEES(p_id)
      loop
        p_row := rec;
      end loop;
    end if;

  exception
    when others then
      -- Если флаг обработки исключений включен - обрабатываем
      if p_raise then
        raise;
      end if;
      -- Иначе - нет
  end SEL;


  ---------------------------------------------------------------
  procedure INS
  (
    p_row    in EMPLOYEES%rowtype
   ,p_update in boolean := false
  )
  /*
    Выполняет вставку новой строки EMPLOYEES

    ПАРАМЕТРЫ
      p_row        - Данные вставляемой записи EMPLOYEES
      p_update
        true       - если строка с таким индексом уже существует, выполняется обновление данных.
    ИСКЛЮЧЕНИЯ
        исключения при дублировании строк и нарушении других ограничений, наложенных на таблицу.
    /**/
   is
  begin

    -- Попытка добавить данные
    begin
      insert into EMPLOYEES
      values p_row;
    exception
      when dup_val_on_index then
        --dbms_output.put_line('dup_val_on_index'); --< для отладки
        -- Если не удалось по дублю
        -- пробуем обновить
        if p_update then
          update EMPLOYEES emp
             set row = p_row
           where emp.employee_id = p_row.employee_id;
        else
          raise;
        end if;
    end;
  end INS;


  ---------------------------------------------------------------
  procedure UPD
  (
    p_row    in EMPLOYEES%rowtype
   ,p_insert in boolean := false
  )
  /*
    Процедура выполняет обновление данных в строке (кроме первичного ключа) EMPLOYEES

    p_row        - Данные записи EMPLOYEES
    p_insert
        true     - если строка с таким индексом не существует, выполняется вставка новой строки.
    ИСКЛЮЧЕНИЯ
        исключения при дублировании строк и нарушении других ограничений, наложенных на таблицу.
    /**/
   is
  begin

    -- Обновим данные
    update EMPLOYEES emp
       set row = p_row
     where emp.employee_id = p_row.employee_id;

    -- Если режим вставки и не обновилось
    if p_insert
       and sql%rowcount = 0 then
      -- Вставляем
      insert into EMPLOYEES
      values p_row;
    end if;

  end UPD;


  ---------------------------------------------------------------
  procedure DEL
  (
    p_id in EMPLOYEES.employee_id%type
  )
  /*
    Процедура выполняет удаление строки данных EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
  /**/
  is
  begin

    delete from EMPLOYEES emp
     where emp.employee_id = p_id;

  end DEL;

  ---------------------------------------------------------------
  function EXIST
  (
    p_id in EMPLOYEES.employee_id%type
  )
  return boolean
  /*
    Функция возвращает истину, если строка с указанным ключом существует в таблице EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
    /**/
  is
    v_res number := 0;
  begin
    select count(*) as cnt
      into v_res
      from EMPLOYEES emp
     where emp.employee_id = p_id;

    if v_res = 1 then
      return true;
    else
      return false;
    end if;

  end EXIST;

end tabEMPLOYEES;
/
