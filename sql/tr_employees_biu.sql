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
    --dbms_utility.get_time; -- счетчик для оптимистичной блокировки

    :new.crt_user := upper(sys_context('USERENV', 'SESSION_USER'));
    :new.crt_date := sysdate;

  elsif UPDATING then

    -- Если старая версия в базе и обновляемая изменились
    if (:new.upd_counter != :old.upd_counter ) then
      -- Мы пытаемся обновить обновленную версию строки
      raise_application_error(-20000, 'Ошибка обновления записи по блокировке');
    end if;
    /**/

    :new.upd_user := upper(sys_context('USERENV', 'SESSION_USER'));
    :new.upd_date := sysdate;

    :new.upd_counter := :old.upd_counter + 1;
    --dbms_utility.get_time; -- счетчик для оптимистичной блокировки

  end if;

end TR_MESSAGES_BI_SEQ;
/

