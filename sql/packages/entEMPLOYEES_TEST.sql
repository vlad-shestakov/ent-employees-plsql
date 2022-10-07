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
  
    select entEMPLOYEES.get_greeting_emp_text(v_id) as emp_msg
          ,entEMPLOYEES.get_greeting_mgr_text(v_id) as mgr_msg
      into v_emp_msg, v_mgr_msg
      from dual;
  
    dbms_output.put_line('v_emp_msg = ' || v_emp_msg);
    dbms_output.put_line('C_GREETING_EMP_TEXT = ' || entEMPLOYEES.C_GREETING_EMP_TEXT);
    
    dbms_output.put_line('');
    dbms_output.put_line('v_mgr_msg = ' || v_mgr_msg);
    dbms_output.put_line('C_GREETING_MGR_TEXT = ' || entEMPLOYEES.C_GREETING_MGR_TEXT);
  end;

  --------------------------------------------------------------- 
  procedure EMPLOYMENT_T
  -- Создаем сотрудника с ошибкой
  is
    v_id  EMPLOYEES.EMPLOYEE_ID%type;
    v_row EMPLOYEES%rowtype;
  begin
    begin -- exception block
      dbms_output.put_line('Create EMP'); --< Для отладки 
      entEmployees.employment(p_first_name     => 'John',
                              p_last_name      => 'Connor',
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
    v_msg_type    MESSAGES.msg_type%type := entEmployees.С_MSG_TYPE;
    v_dest_addr   MESSAGES.dest_addr%type;
    v_dest_addr2  MESSAGES.dest_addr%type;
  begin
    v_dest_addr  := 'abc@def.com2';
    v_dest_addr2 := 'NGREENBE';
    
    dbms_output.put_line('Create EMP'); --< Для отладки 
    entEmployees.employment(p_first_name     => 'John',
                            p_last_name      => 'Connor',
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
       and e.email = 'abc@def.com2'
    ;/**/                         
  
    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);
      
    dbms_output.put_line('v_id = ' || v_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);
    dbms_output.put_line('v_row.email = ' || v_row.email);
    
    
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
