create or replace package tabEMPLOYEES_TEST is

  -- Author  : VSHESTAKOV
  -- Created : 07.10.2022 0:21:02
  -- Purpose : Тестирование пакета tabEMPLOYEES
  
  
  -- 07.10.2022 VSHESTAKOV - v01

  --------------------------------------------------------------- 
  procedure sel_t
  -- Выборка работника
  ;
  
  --------------------------------------------------------------- 
  procedure ins_t
  -- Добавление карточки работника
  ;
  
  --------------------------------------------------------------- 
  procedure upd_t
  -- обновление карточки работника
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
  procedure sel_t
  -- Выборка работника
  is
    v_id        EMPLOYEES.EMPLOYEE_ID%type;
    v_row       EMPLOYEES%rowtype;
    v_forUpdate boolean := true;
    v_rase      boolean := true;
  begin

    v_id        := 108;
    v_rase      := true;
    v_forUpdate := false;

    tabEMPLOYEES.sel2(p_id        => v_id
                     ,p_row       => v_row
                     ,p_forUpdate => v_forUpdate
                     ,p_rase      => v_rase);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id); --< для отладки 
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name); --< для отладки 
    
  end;

  --------------------------------------------------------------- 
  procedure ins_t
  -- Добавление карточки работника
  is
    v_id        EMPLOYEES.EMPLOYEE_ID%type;
    v_row       EMPLOYEES%rowtype;
    v_forUpdate boolean := true;
    v_rase      boolean := true;
    v_update    boolean := true;
  begin

    v_id        := 108;
    v_rase      := true;
    v_forUpdate := false;

    tabEMPLOYEES.sel2(p_id        => v_id
                     ,p_row       => v_row
                     ,p_forUpdate => v_forUpdate
                     ,p_rase      => v_rase);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id); --< для отладки
    dbms_output.put_line('v_row.upd_counter = ' || v_row.upd_counter); --< для отладки
    
    v_update := false;
    --v_row.employee_id := v_row.employee_id + 1000;
    tabEMPLOYEES.ins(p_row => v_row, p_update => v_update);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id); --< для отладки 
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name); --< для отладки 
    dbms_output.put_line('v_row.upd_counter = ' || v_row.upd_counter); --< для отладки 
  end;

  --------------------------------------------------------------- 
  procedure upd_t
  -- обновление карточки работника
  is
    v_id        EMPLOYEES.EMPLOYEE_ID%type;
    v_row       EMPLOYEES%rowtype;
    v_forUpdate boolean := true;
    v_rase      boolean := true;
    v_insert    boolean := true;
  begin

    v_id        := 108;
    v_rase      := true;
    v_forUpdate := false;

    tabEMPLOYEES.sel2(p_id        => v_id
                     ,p_row       => v_row
                     ,p_forUpdate => v_forUpdate
                     ,p_rase      => v_rase);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id); --< для отладки
    dbms_output.put_line('v_row.upd_counter = ' || v_row.upd_counter); --< для отладки

    v_insert := false;
    v_row.upd_counter := v_row.upd_counter + 1;
    --v_row.employee_id := v_row.employee_id + 1000;
    tabEMPLOYEES.upd(p_row => v_row, p_insert => v_insert);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id); --< для отладки 
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name); --< для отладки 
    dbms_output.put_line('v_row.upd_counter = ' || v_row.upd_counter); --< для отладки 
  end;
  
  --------------------------------------------------------------- 
  procedure runall
  -- Все тесты
  is
  begin
    begin -- exception block
      dbms_output.put_line(''); --< Для отладки 
      dbms_output.put_line('Тест - SEL_T'); --< Для отладки 
      sel_t;
      dbms_output.put_line(''); --< Для отладки 
      dbms_output.put_line('Тест - INS_T'); --< Для отладки 
      ins_t;
      dbms_output.put_line(''); --< Для отладки 
      dbms_output.put_line('Тест - UPD_T'); --< Для отладки 
      upd_t;
    exception
      when others then
        dbms_output.put_line(utl_lms.format_message('ERROR - (%s): %s', TO_CHAR(sqlcode), TO_CHAR(sqlerrm))); --< Для отладки
        raise;
    end; 
  end;
  
  
--begin
  -- Initialization
  --<Statement>;
end tabEMPLOYEES_test;
/
