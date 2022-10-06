-- Create table
create table MESSAGES
(
  id        NUMBER,
  msg_text  VARCHAR2(2000),
  msg_type  VARCHAR2(10),
  dest_addr VARCHAR2(150),
  msg_state NUMBER(4)
)
tablespace SYSAUX
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column MESSAGES.id
  is 'идентификатор сообщения в очереди';
comment on column MESSAGES.msg_text
  is 'текст сообщения ';
comment on column MESSAGES.msg_type
  is 'тип сообщения (email, sms и т.п.) ';
comment on column MESSAGES.dest_addr
  is 'адрес получателя сообщения (email, номер телефона) ';
comment on column MESSAGES.msg_state
  is 'статус обработки сообщения внешней системой (0 - добавлено в очередь, 1 - успешно отправлено, -1 - отправлено с ошибкой) ';
