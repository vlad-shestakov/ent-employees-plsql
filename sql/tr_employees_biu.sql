create or replace trigger TR_EMPLOYEES_BIU
  before insert or update or delete on EMPLOYEES
  for each row
begin
  -- Обновление полей
  if INSERTING then
  
    if :new.employee_id is null then
      :new.employee_id := EMPLOYEES_SEQ.nextval;
    end if;
  
    :new.upd_counter := 0;
  
    :new.crt_user := upper(sys_context('USERENV', 'SESSION_USER'));
    :new.crt_date := sysdate;
  
  elsif UPDATING then
    
    :new.upd_user := upper(sys_context('USERENV', 'SESSION_USER'));
    :new.upd_date := sysdate;
  
  end if;

end TR_MESSAGES_BI_SEQ;
/

