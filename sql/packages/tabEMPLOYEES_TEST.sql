create or replace package tabEMPLOYEES_TEST is

  -- Author  : VSHESTAKOV
  -- Created : 07.10.2022 0:21:02
  -- Purpose : Тестирование пакета tabEMPLOYEES
  
  
  -- 07.10.2022 VSHESTAKOV - v01

  --------------------------------------------------------------- 
  procedure sel2
  -- Выборка работника
  ;
  
  --------------------------------------------------------------- 
  procedure runall
  -- Все тесты
  ;
  
end tabEMPLOYEES_TEST;
/
create or replace package body tabEMPLOYEES_TEST is

  /* 
  begin
    -- Все тесты
    tabEMPLOYEES_TEST.runall;
  end; 
  /**/
  --------------------------------------------------------------- 
  procedure sel2
  -- Выборка работника
  is
    v_cnt  number;
    v_res  varchar2(255) := '';
    v_str  varchar2(4000) := '';
    v_clob clob := '';

    v_id        EMPLOYEES.EMPLOYEE_ID%type;
    v_row       EMPLOYEES%rowtype;
    v_forUpdate boolean := true;
    v_rase      boolean := true;
    v_update    boolean := true;
    v_insert    boolean := true;
  begin

    v_id        := 108;
    v_rase      := true;
    v_forUpdate := false;

    tabEMPLOYEES.sel2(p_id        => v_id
                     ,p_row       => v_row
                     ,p_forUpdate => v_forUpdate
                     ,p_rase      => v_rase);

    --v_row.email := v_row.email || '2';

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id); --< для отладки 
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name); --< для отладки 
    dbms_output.put_line('v_row.upd_counter = ' || v_row.upd_counter); --< для отладки 

    --------------------------------------------------------------- 
    --v_update := false;
    --v_row.employee_id := v_row.employee_id + 1000;
    --tabEMPLOYEES.ins(p_row => v_row, p_update => v_update);

    v_insert := false;
    v_row.upd_counter := v_row.upd_counter + 1;
    v_row.employee_id := v_row.employee_id + 1000;
    tabEMPLOYEES.upd(p_row => v_row, p_insert => v_insert);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id); --< для отладки 
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name); --< для отладки 
    dbms_output.put_line('v_row.upd_counter = ' || v_row.upd_counter); --< для отладки 
  end;

  
  --------------------------------------------------------------- 
  procedure runall
  -- Все тесты
  is
    v_cnt  number;
    v_res  varchar2(255) := '';
    v_str  varchar2(4000) := '';
    v_clob clob := '';

    v_id        EMPLOYEES.EMPLOYEE_ID%type;
    v_row       EMPLOYEES%rowtype;
    v_forUpdate boolean := true;
    v_rase      boolean := true;
    v_update    boolean := true;
    v_insert    boolean := true;
  begin
    dbms_output.put_line('Тест - SEL2'); --< Для отладки 
    sel2;
  end;
  
  
--begin
  -- Initialization
  --<Statement>;
end tabEMPLOYEES_test;
/
