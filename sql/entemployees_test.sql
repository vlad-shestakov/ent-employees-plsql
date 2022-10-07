create or replace package entEMPLOYEES_TEST is

  -- Author  : VSHESTAKOV
  -- Created : 07.10.2022 2:59:59
  -- Purpose : Тестирование пакета entEMPLOYEES


  -- 07.10.2022 VSHESTAKOV - v01

  /*
  begin
    rollback;
    -- Выполнить все тесты
    entEMPLOYEES_TEST.runall;
  end;
  /**/

  ---------------------------------------------------------------
  procedure runall
  -- Все тесты
  ;

end entEMPLOYEES_TEST;
/
create or replace package body entEMPLOYEES_TEST is

  ---------------------------------------------------------------
  procedure MSG_T
  -- Сообщения для работника, начальника
  is
    v_id      employees.employee_id%type := 108;
    v_emp_msg messages.msg_text%type;
    v_mgr_msg messages.msg_text%type;
  begin
    dbms_output.put_line('Тест сообщений для работника и начальника'); --< Для отладки

    select entEMPLOYEES.get_greeting_emp_text(v_id) as emp_msg
          ,entEMPLOYEES.get_greeting_mgr_text(v_id) as mgr_msg
      into v_emp_msg, v_mgr_msg
      from dual;

    dbms_output.put_line('v_emp_msg = ' || v_emp_msg);
    dbms_output.put_line('C_MSG_EMPLT_GREET_EMP_TXT = ' || entEMPLOYEES.C_MSG_EMPLT_GREET_EMP_TXT);
    dbms_output.put_line('C_MSG_EMPLT_GREET_EMP_TXT2 = ' || entEMPLOYEES.C_MSG_EMPLT_GREET_EMP_TXT2);

    dbms_output.put_line('');
    dbms_output.put_line('v_mgr_msg = ' || v_mgr_msg);
    dbms_output.put_line('C_MSG_EMPLT_GREET_MGR_TXT = ' || entEMPLOYEES.C_MSG_EMPLT_GREET_MGR_TXT);
  end;

  ---------------------------------------------------------------
  procedure EMPLOYMENT_T
  -- Создаем сотрудника с ошибкой
  is
    v_id  EMPLOYEES.EMPLOYEE_ID%type;
    v_row EMPLOYEES%rowtype;
  begin
    dbms_output.put_line('Создает сотрудника, возвращает ошибку, не указана должность и департамент'); --< Для отладки
    begin -- exception block
      dbms_output.put_line('Create EMP'); --< Для отладки
      entEmployees.employment(p_first_name     => 'John',
                              p_last_name      => 'employment_t',
                              p_email          => 'abc@def.com2',
                              p_phone_number   => '+7804650',
                              p_job_id         => '',
                              p_department_id  => '',
                              p_manager_id     => '',
                              p_salary         => '',
                              p_commission_pct => '');

      -- Найдем клиента
      select max(e.employee_id)
        into v_id
        from EMPLOYEES e
       where 1=1
         and e.email = 'abc@def.com2'
      ;/**/

      tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);

      dbms_output.put_line('v_id = ' || v_id);
      dbms_output.put_line('v_row.last_name = ' || v_row.last_name);
      dbms_output.put_line('v_row.email = ' || v_row.email);

    exception
      when entEMPLOYEES.EX_EMPLOYMENT_WR_PARAMS then
        dbms_output.put_line(utl_lms.format_message('OK ERROR - (%s): %s',TO_CHAR(sqlcode),TO_CHAR(sqlerrm)));
    end;
  end;

  ---------------------------------------------------------------
  procedure EMPLOYMENT_T2
  -- Создаем сотрудника
  is
    v_id          EMPLOYEES.EMPLOYEE_ID%type;
    v_row         EMPLOYEES%rowtype;
    v_msg_type    MESSAGES.msg_type%type := entEmployees.С_MSG_TYPE_DEF;
    v_dest_addr   MESSAGES.dest_addr%type;
    v_dest_addr2  MESSAGES.dest_addr%type;
  begin
    dbms_output.put_line('Создает сотрудника, со ссылкой на менеджера (отправит два сообщения на почту), оклад и процент не указаны (усредненные)'); --< Для отладки

    v_dest_addr  := 'employment_t2@def.com';
    v_dest_addr2 := 'NGREENBE';

    dbms_output.put_line('Create EMP'); --< Для отладки
    entEmployees.employment(p_first_name     => 'John',
                            p_last_name      => 'employment_t2',
                            p_email          => v_dest_addr,
                            p_phone_number   => '+7804650',
                            p_job_id         => 'SA_REP',
                            p_department_id  => 80,
                            p_manager_id     => 108,
                            p_salary         => '',
                            p_commission_pct => '');

    -- Найдем клиента
    select max(e.employee_id)
      into v_id
      from EMPLOYEES e
     where 1=1
       and e.email = v_dest_addr
    ;/**/

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);

    dbms_output.put_line('v_id = ' || v_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);
    dbms_output.put_line('v_row.email = ' || v_row.email);
    dbms_output.put_line('v_row.manager_id = ' || v_row.manager_id);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);
    dbms_output.put_line('v_row.commission_pct = ' || v_row.commission_pct);


    -- Найдем сообщение
    dbms_output.put_line('Find messages:'); --< Для отладки
    for rec in (--
                select m.*
                  from MESSAGES m
                 where 1=1
                   and m.msg_type = v_msg_type
                   and m.dest_addr in (v_dest_addr, v_dest_addr2)
                   --and rownum <= 1
                 order by 1 desc
               )
    loop
      dbms_output.put_line('  id = ' || rec.id);
      dbms_output.put_line('  rec.p_msg_text = ' || rec.msg_text);
      dbms_output.put_line('  rec.msg_type  = ' || rec.msg_type);
      dbms_output.put_line('  rec.msg_state  = ' || rec.msg_state);
    end loop; -- Конец перебора

  end;


  ---------------------------------------------------------------
  procedure EMPLOYMENT_T3
  -- Создаем сотрудника
  is
    v_id          EMPLOYEES.EMPLOYEE_ID%type;
    v_row         EMPLOYEES%rowtype;
    v_msg_type    MESSAGES.msg_type%type := entEmployees.С_MSG_TYPE_DEF;
    v_dest_addr   MESSAGES.dest_addr%type;
    v_dest_addr2  MESSAGES.dest_addr%type;
  begin
    dbms_output.put_line('Создает сотрудника, без ссылки на менеджера (отправит только одно сообщение на почту), с фиксированным окладом'); --< Для отладки

    v_dest_addr  := 'employment_t3@def.com';
    v_dest_addr2 := '';

    dbms_output.put_line('Create EMP'); --< Для отладки
    entEmployees.employment(p_first_name     => 'John',
                            p_last_name      => 'employment_t3',
                            p_email          => v_dest_addr,
                            p_phone_number   => '+7804650',
                            p_job_id         => 'SA_REP',
                            p_department_id  => 80,
                            p_manager_id     => null,
                            p_salary         => 110000,
                            p_commission_pct => 0.1);

    -- Найдем клиента
    select max(e.employee_id)
      into v_id
      from EMPLOYEES e
     where 1=1
       and e.email = v_dest_addr
    ;/**/

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);

    dbms_output.put_line('v_id = ' || v_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);
    dbms_output.put_line('v_row.email = ' || v_row.email);
    dbms_output.put_line('v_row.manager_id = ' || v_row.manager_id);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);
    dbms_output.put_line('v_row.commission_pct = ' || v_row.commission_pct);


    -- Найдем сообщение
    dbms_output.put_line('Find messages:'); --< Для отладки
    for rec in (--
                select m.*
                  from MESSAGES m
                 where 1=1
                   and m.msg_type = v_msg_type
                   and m.dest_addr in (v_dest_addr, v_dest_addr2)
                   --and rownum <= 1
                 order by 1 desc
               )
    loop
      dbms_output.put_line('  id = ' || rec.id);
      dbms_output.put_line('  rec.p_msg_text = ' || rec.msg_text);
      dbms_output.put_line('  rec.msg_type  = ' || rec.msg_type);
      dbms_output.put_line('  rec.msg_state  = ' || rec.msg_state);
    end loop; -- Конец перебора

  end;


  ---------------------------------------------------------------
  procedure EMPLOYMENT_T4
  -- Создаем сотрудника
  is
    v_id          EMPLOYEES.EMPLOYEE_ID%type;
    v_row         EMPLOYEES%rowtype;
    v_msg_type    MESSAGES.msg_type%type := entEmployees.С_MSG_TYPE_SMS;
    v_dest_addr   MESSAGES.dest_addr%type;
    v_dest_addr2  MESSAGES.dest_addr%type;
    v_dest_addr3  MESSAGES.dest_addr%type;
  begin
    dbms_output.put_line('Создает сотрудника со ссылкой на менеджера (отправит два сообщения SMS), с фиксированным окладом'); --< Для отладки

    v_dest_addr  := 'employment_t4@def.com';
    v_dest_addr2 := '515.124.4569'; -- NGREENBE
    v_dest_addr3  := '+7804650';

    dbms_output.put_line('Create EMP'); --< Для отладки
    entEmployees.employment(p_first_name     => 'John',
                            p_last_name      => 'employment_t4',
                            p_email          => v_dest_addr,
                            p_phone_number   => '+7804650',
                            p_job_id         => 'SA_REP',
                            p_department_id  => 80,
                            p_manager_id     => 108,
                            p_salary         => 110000,
                            p_commission_pct => 0.1,
                            p_msg_type       => v_msg_type);

    -- Найдем клиента
    select max(e.employee_id)
      into v_id
      from EMPLOYEES e
     where 1=1
       and e.email = v_dest_addr
    ;/**/

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);

    dbms_output.put_line('v_id = ' || v_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);
    dbms_output.put_line('v_row.email = ' || v_row.email);
    dbms_output.put_line('v_row.manager_id = ' || v_row.manager_id);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);
    dbms_output.put_line('v_row.commission_pct = ' || v_row.commission_pct);


    -- Найдем сообщение
    dbms_output.put_line('Find messages:'); --< Для отладки
    for rec in (--
                select m.*
                  from MESSAGES m
                 where 1=1
                   and m.msg_type = v_msg_type
                   and m.dest_addr in (v_dest_addr, v_dest_addr2, v_dest_addr3)
                   --and rownum <= 1
                 order by 1 desc
               )
    loop
      dbms_output.put_line('  id = ' || rec.id);
      dbms_output.put_line('  rec.p_msg_text = ' || rec.msg_text);
      dbms_output.put_line('  rec.msg_type  = ' || rec.msg_type);
      dbms_output.put_line('  rec.msg_state  = ' || rec.msg_state);
    end loop; -- Конец перебора

  end;
  
  
  ---------------------------------------------------------------
  procedure MESSAGE_INS_T
  -- Создаем сообщение в очереди
  is
    v_msg_type  MESSAGES.msg_type%type;
    v_dest_addr MESSAGES.dest_addr%type;
  begin
    v_msg_type := 'sms';
    v_dest_addr := 'abc@def.com3';

    entEMPLOYEES.message_ins(
        p_msg_text  => 'Уважаемый Neena Kochhar! В ваше подразделение принят новый сотрудник Nancy Greenberg в должности Finance Manager с окладом 12008.'
       ,p_msg_type  => v_msg_type
       ,p_dest_addr => v_dest_addr);

    -- Найдем сообщение
    for rec in (--
                select m.*
                  from MESSAGES m
                 where 1=1
                   and m.msg_type = v_msg_type
                   and m.dest_addr = v_dest_addr
                   and rownum <= 1
                 order by 1 desc
               )
    loop
      dbms_output.put_line('id = ' || rec.id);
      dbms_output.put_line('rec.p_msg_text = ' || rec.msg_text);
      dbms_output.put_line('rec.msg_state  = ' || rec.msg_state);
    end loop; -- Конец перебора

  end;


  ---------------------------------------------------------------
  procedure PAYRISE_T
  -- Повышаем оклад - ОШИБКА
  is
    v_id      employees.employee_id%type := 108;
  begin
    
    dbms_output.put_line('Повышает оклад сотрудника, возвращает ошибку, слишком большое повышение'); --< Для отладки
    dbms_output.put_line('Payrise EMP'); --< Для отладки
      
    begin -- exception block
      
      entEMPLOYEES.PAYRISE(p_employee_id => v_id
                          ,p_salary => entEMPLOYEES.С_EMP_MAX_SALARY + 10000);

    exception
      when entEMPLOYEES.EX_PAYRISE_EMP_SALARY_EXCCESS then
        dbms_output.put_line(utl_lms.format_message('OK ERROR - (%s): %s',TO_CHAR(sqlcode),TO_CHAR(sqlerrm)));
    end;

  end;
  
  ---------------------------------------------------------------
  procedure PAYRISE_T2
  -- Повышаем оклад
  is
    v_id      employees.employee_id%type := 108;
    v_row EMPLOYEES%rowtype;
  begin
    
    dbms_output.put_line('Повышает оклад сотрудника, + 10%'); --< Для отладки
    dbms_output.put_line('Payrise EMP'); --< Для отладки
      
    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);
    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);

    entEMPLOYEES.PAYRISE(p_employee_id => v_id
                        --,p_salary => entEMPLOYEES.С_EMP_MAX_SALARY + 10000
                        );

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);
    dbms_output.put_line('NEW v_row.salary = ' || v_row.salary);

  end;
  
  ---------------------------------------------------------------
  procedure PAYRISE_T3
  -- Повышаем оклад
  is
    v_id      employees.employee_id%type := 108;
    v_row EMPLOYEES%rowtype;
  begin
    
    dbms_output.put_line('Повышает оклад сотрудника - 150 000 '); --< Для отладки
    dbms_output.put_line('Payrise EMP'); --< Для отладки
      
    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);
    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);
    
    entEMPLOYEES.PAYRISE(p_employee_id => v_id
                        ,p_salary => 150000
                        );

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);
    dbms_output.put_line('NEW v_row.salary = ' || v_row.salary);

  end;
  
  ---------------------------------------------------------------
  procedure runall
  -- Все тесты
   is
  begin
    begin
      -- exception block

      dbms_output.put_line('');
      dbms_output.put_line('Тест - MSG_T');
      MSG_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - MESSAGE_INS_T');
      MESSAGE_INS_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - EMPLOYMENT_T');
      EMPLOYMENT_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - EMPLOYMENT_T2');
      EMPLOYMENT_T2;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - EMPLOYMENT_T3');
      EMPLOYMENT_T3;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - EMPLOYMENT_T4');
      EMPLOYMENT_T4;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - PAYRISE_T');
      PAYRISE_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - PAYRISE_T2');
      PAYRISE_T2;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - PAYRISE_T3');
      PAYRISE_T3;

    exception
      when others then
        dbms_output.put_line(utl_lms.format_message('ERROR - (%s): %s'
                                                   ,TO_CHAR(sqlcode)
                                                   ,TO_CHAR(sqlerrm)));
        raise;
    end;
  end;

end entEMPLOYEES_TEST;
/
