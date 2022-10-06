-- WorkLog Тестирование пакетов 2022-10-06


/
declare
  v_cnt  number;
  v_res  varchar2(255) := '';
  v_str  varchar2(4000) := '';
  v_clob clob := '';

  --v_id        EMPLOYEES.EMPLOYEE_ID%type;
  v_id        varchar2(256) := '';
  v_row       EMPLOYEES%rowtype;
  v_forUpdate boolean := true;
  v_rase      boolean := true;
  v_update    boolean := true;
  v_insert    boolean := true;
begin

  v_id        := '108';
  v_rase      := true;
  v_forUpdate := false;

  tabEMPLOYEES.sel2(p_id        => v_id
                   ,p_row       => v_row
                   ,p_forUpdate => v_forUpdate
                   ,p_rase      => v_rase);

  --v_row.email := v_row.email || '2';

  dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id); --< ��� ������� 
  dbms_output.put_line('v_row.last_name = ' || v_row.last_name); --< ��� ������� 
  dbms_output.put_line('v_row.upd_counter = ' || v_row.upd_counter); --< ��� ������� 

  --------------------------------------------------------------- 
  --v_update := false;
  --v_row.employee_id := v_row.employee_id + 1000;
  --tabEMPLOYEES.ins(p_row => v_row, p_update => v_update);

  v_insert := false;
  v_row.upd_counter := v_row.upd_counter + 1;
  v_row.employee_id := v_row.employee_id + 1000;
  tabEMPLOYEES.upd(p_row => v_row, p_insert => v_insert);

  dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id); --< ��� ������� 
  dbms_output.put_line('v_row.last_name = ' || v_row.last_name); --< ��� ������� 
  dbms_output.put_line('v_row.upd_counter = ' || v_row.upd_counter); --< ��� ������� 
end;

/
select e.*, e.rowid
  from EMPLOYEES e
 where 1=1
  and e.employee_id in (108, 1108)
 order by 1
;/**/ 
