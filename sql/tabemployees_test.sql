create or replace package tabEMPLOYEES_TEST is

  -- Author  : VSHESTAKOV
  -- Created : 07.10.2022 0:21:02
  -- Purpose : Тестирование пакета tabEMPLOYEES


  -- 07.10.2022 VSHESTAKOV - v01

  /*
  begin
    rollback;
    -- Выполнить все тесты
    tabEMPLOYEES_TEST.runall;
  end;
  /**/

  ---------------------------------------------------------------
  procedure runall
  -- Все тесты
  ;

end tabEMPLOYEES_TEST;
/
create or replace package body tabEMPLOYEES_TEST is


  ---------------------------------------------------------------
  procedure SEL_T
  -- Выборка работника
   is
    v_id        EMPLOYEES.EMPLOYEE_ID%type;
    v_row       EMPLOYEES%rowtype;
    v_forUpdate boolean := true;
    v_rase      boolean := true;
  begin
    dbms_output.put_line('Выбор работника 108'); --< Для отладки

    v_id        := 108;
    v_rase      := true;
    v_forUpdate := false;

    tabEMPLOYEES.sel(p_id        => v_id
                    ,p_row       => v_row
                    ,p_forUpdate => v_forUpdate
                    ,p_rase      => v_rase);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);

  end;

  ---------------------------------------------------------------
  procedure INS_T
  -- Добавление карточки работника
   is
    v_id  EMPLOYEES.EMPLOYEE_ID%type;
    v_row EMPLOYEES%rowtype;
  begin
    dbms_output.put_line('Вставка работника из копии'); --< Для отладки

    v_id := 108;

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);

    v_row.employee_id := EMPLOYEES_SEQ.nextval;
    v_row.email       := v_row.email || '_2';

    dbms_output.put_line('Inserting...'); --< Для отладки
    tabEMPLOYEES.ins(p_row => v_row, p_update => false);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.email = ' || v_row.email);
  end;


  ---------------------------------------------------------------
  procedure INS_T2
  -- Добавление карточки работника 2
   is
    v_row EMPLOYEES%rowtype;
  begin
    dbms_output.put_line('Вставка работника по данным'); --< Для отладки

    --v_row.employee_id     := '';
    --v_row.employee_id := EMPLOYEES_SEQ.nextval;
    v_row.first_name      := 'John';
    v_row.last_name       := 'Connor';
    v_row.email           := 'abc';
    v_row.phone_number    := '+79502096411';
    v_row.hire_date       := trunc(sysdate);
    v_row.job_id          := 'FI_MGR';
    v_row.salary          := '12008';
    v_row.commission_pct  := '';
    v_row.manager_id      := '101';
    v_row.department_id   := '100';

    tabEMPLOYEES.ins(p_row => v_row, p_update => false);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);
    dbms_output.put_line('v_row.email = ' || v_row.email);
  end;

  ---------------------------------------------------------------
  procedure UPD_T
  -- обновление карточки работника
   is
    v_id  EMPLOYEES.EMPLOYEE_ID%type;
    v_row EMPLOYEES%rowtype;
  begin
    dbms_output.put_line('Обновление карточки работника, ЗП + 10 000'); --< Для отладки

    v_id := 108;
    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);

    v_row.salary       := v_row.salary + 10000;

    dbms_output.put_line('Updating...'); --< Для отладки
    tabEMPLOYEES.upd(p_row => v_row, p_insert => false);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);
  end;


  ---------------------------------------------------------------
  procedure EXIST_T
  -- Есть ли работник
   is
    v_id  EMPLOYEES.EMPLOYEE_ID%type;
    v_res boolean;
  begin
    dbms_output.put_line('Проверка, есть ли работник - Есть'); --< Для отладки

    v_id := 108;
    v_res := tabEMPLOYEES.exist(p_id => v_id);

    dbms_output.put_line('v_id = ' || v_id);
    dbms_output.put_line('EMPLOYEE ' || case when v_res then 'exists' else 'not exists' end);
  end;

  ---------------------------------------------------------------
  procedure EXIST_T2
  -- Есть ли работник 2
   is
    v_id  EMPLOYEES.EMPLOYEE_ID%type;
    v_res boolean;
  begin
    dbms_output.put_line('Проверка, есть ли работник - Нет'); --< Для отладки

    v_id := -108;
    v_res := tabEMPLOYEES.exist(p_id => v_id);

    dbms_output.put_line('v_id = ' || v_id);
    dbms_output.put_line('EMPLOYEE ' || case when v_res then 'exists' else 'not exists' end);
  end;


  ---------------------------------------------------------------
  procedure DEL_T
  -- Удаление карточки работника
   is
    v_row EMPLOYEES%rowtype;
  begin
    dbms_output.put_line('Удаление карточки работника'); --< Для отладки

    v_row.employee_id := EMPLOYEES_SEQ.nextval;
    v_row.first_name      := 'John';
    v_row.last_name       := 'Connor2';
    v_row.email           := 'abc2';
    v_row.phone_number    := '+79502096411';
    v_row.hire_date       := trunc(sysdate);
    v_row.job_id          := 'FI_MGR';
    v_row.salary          := '12008';
    v_row.commission_pct  := '';
    v_row.manager_id      := '101';
    v_row.department_id   := '100';

    tabEMPLOYEES.ins(p_row => v_row, p_update => false);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);
    dbms_output.put_line('v_row.email = ' || v_row.email);


    tabEMPLOYEES.del(p_id => v_row.employee_id);
    dbms_output.put_line('Deleting v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('EMPLOYEE ' || case when tabEMPLOYEES.exist(p_id => v_row.employee_id) then 'exists' else 'not exists' end);

  end;


  ---------------------------------------------------------------
  procedure MESSAGE_INS_T
  -- Создаем сообщение в очереди
  is
    v_msg_type  MESSAGES.msg_type%type  := 'sms';
    v_dest_addr MESSAGES.dest_addr%type := 'message_ins_t';
  begin

    tabEMPLOYEES.MESSAGE_INS(
        p_msg_text  => 'Уважаемый Neena Kochhar! В ваше подразделение принят новый сотрудник Nancy Greenberg в должности Finance Manager с окладом 12008.'
       ,p_msg_type  => v_msg_type
       ,p_dest_addr => v_dest_addr);

    -- Найдем сообщение
    dbms_output.put_line('Find messages...'); --< Для отладки
    for rec in (--
                select m2.*
                  from MESSAGES m2
                 where 1=1
                   and m2.id in (--
                                select max(m.id)
                                  from MESSAGES m
                                 where 1=1
                                   and m.msg_type = v_msg_type
                                   and m.dest_addr = v_dest_addr
                       )
               )
    loop
      dbms_output.put_line('id = ' || rec.id);
      dbms_output.put_line('rec.p_msg_text = ' || rec.msg_text);
      dbms_output.put_line('rec.msg_state  = ' || rec.msg_state);
    end loop; -- Конец перебора

  end;

  ---------------------------------------------------------------
  procedure runall
  -- Все тесты
   is
  begin
    begin
      -- exception block


      dbms_output.put_line('');
      dbms_output.put_line('Тест - INS_T2');
      INS_T2;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - EXIST_T');
      EXIST_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - EXIST_T2');
      EXIST_T2;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - SEL_T');
      SEL_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - UPD_T');
      UPD_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - INS_T');
      INS_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - DEL_T');
      DEL_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - MESSAGE_INS_T');
      MESSAGE_INS_T;

    exception
      when others then
        dbms_output.put_line(utl_lms.format_message('ERROR - (%s): %s'
                                                   ,TO_CHAR(sqlcode)
                                                   ,TO_CHAR(sqlerrm)));
        raise;
    end;
  end;

end tabEMPLOYEES_test;
/
