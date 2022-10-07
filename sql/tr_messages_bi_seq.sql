create or replace trigger TR_MESSAGES_BI_SEQ
  before insert
  on messages 
  for each row
declare
  -- local variables here
begin
  if :new.id is null then
    :new.id := MESSAGES_SEQ.nextval;
  end if;
end TR_MESSAGES_BI_SEQ;
/

