create or replace package tabEMPLOYEES is

  -- Author  : VSHESTAKOV
  -- Created : 06.10.2022 17:15:18
  -- Purpose : Обработка операций чтения/записи данных в таблицу EMPLOYEES

  -- 07.10.2022 USER - v01

  ---------------------------------------------------------------
  procedure sel
  (
    p_id        in EMPLOYEES.EMPLOYEE_ID%type
   ,p_row       out EMPLOYEES%rowtype
   ,p_forUpdate in boolean := false
   ,p_rase      in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
      p_row        - Возвращаемая запись EMPLOYEES
      p_forUpdate
        true     - выполняется SELECT … FOR UPDATE
        false    - обычный SELECT
      p_rase
        true     - происходит вызов исключений
        false    - исключения игнорируются

    /**/
  ;

  ---------------------------------------------------------------
  procedure ins
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
  procedure upd
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
  procedure del
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
  function exist
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
  procedure sel
  (
    p_id        in EMPLOYEES.EMPLOYEE_ID%type
   ,p_row       out EMPLOYEES%rowtype
   ,p_forUpdate in boolean := false
   ,p_rase      in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
      p_row        - Возвращаемая запись EMPLOYEES
      p_forUpdate
          true     - выполняется SELECT … FOR UPDATE
          false    - обычный SELECT
      p_rase
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

      -- Выборка для обновления FOR UPDATE
      /*select *
       into p_row
       from EMPLOYEES em
      where em.employee_id in p_id for update; */

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
      if p_rase then
        raise;
      end if;
      -- Иначе - нет
  end;


  ---------------------------------------------------------------
  procedure ins
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
  end ins;


  ---------------------------------------------------------------
  procedure upd
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

  end upd;


  ---------------------------------------------------------------
  procedure del
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

  end del;

  ---------------------------------------------------------------
  function exist
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

  end exist;

end tabEMPLOYEES;
/
