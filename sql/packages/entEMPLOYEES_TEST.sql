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
  procedure runall
  -- Все тесты
   is
  begin
    begin
      -- exception block
    
      dbms_output.put_line('');
      dbms_output.put_line('Тест - MSG_T');
      MSG_T;
    
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
