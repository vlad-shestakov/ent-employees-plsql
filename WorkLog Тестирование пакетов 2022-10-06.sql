-- WorkLog Тестирование пакетов 2022-10-06


/
declare
  v_cnt   number;
  v_res   varchar2(255) := '';
  v_str   varchar2(4000) := '';
  v_clob  clob := '';
  
v_id        EMPLOYEES.EMPLOYEE_ID%type;
v_row       EMPLOYEES%rowtype;
v_forUpdate boolean := true;
v_rase      boolean := true;
begin
    
  v_id := 1;
  v_rase := false;
  
  tabEMPLOYEES.sel2(p_id        => v_id,
                    p_row       => v_row,
                    p_forUpdate => v_forUpdate ,
                    p_rase      => v_rase);
                    
            
end; 
