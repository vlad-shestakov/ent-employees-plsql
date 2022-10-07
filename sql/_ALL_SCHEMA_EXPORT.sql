prompt PL/SQL Developer Export User Objects for user TST@169.254.218.131/XEPDB1
prompt Created by User on 7 Октябрь 2022 г.
set define off
spool _ALL_SCHEMA_EXPORT.log

prompt
prompt Creating table REGIONS
prompt ======================
prompt
create table REGIONS
(
  region_id   NUMBER,
  region_name VARCHAR2(25)
)
;
alter table REGIONS
  add constraint REG_ID_PK primary key (REGION_ID);
alter table REGIONS
  add constraint REGION_ID_NN
  check ("REGION_ID" IS NOT NULL);

prompt
prompt Creating table COUNTRIES
prompt ========================
prompt
create table COUNTRIES
(
  country_id   CHAR(2),
  country_name VARCHAR2(40),
  region_id    NUMBER,
  constraint COUNTRY_C_ID_PK primary key (COUNTRY_ID)
)
organization index;
comment on table COUNTRIES
  is 'country table. Contains 25 rows. References with locations table.';
comment on column COUNTRIES.country_id
  is 'Primary key of countries table.';
comment on column COUNTRIES.country_name
  is 'Country name';
comment on column COUNTRIES.region_id
  is 'Region ID for the country. Foreign key to region_id column in the departments table.';
alter table COUNTRIES
  add constraint COUNTR_REG_FK foreign key (REGION_ID)
  references REGIONS (REGION_ID);
alter table COUNTRIES
  add constraint COUNTRY_ID_NN
  check ("COUNTRY_ID" IS NOT NULL);

prompt
prompt Creating table JOBS
prompt ===================
prompt
create table JOBS
(
  job_id     VARCHAR2(10) not null,
  job_title  VARCHAR2(35),
  min_salary NUMBER(6),
  max_salary NUMBER(6)
)
;
comment on table JOBS
  is 'jobs table with job titles and salary ranges. Contains 19 rows.
References with employees and job_history table.';
comment on column JOBS.job_id
  is 'Primary key of jobs table.';
comment on column JOBS.job_title
  is 'A not null column that shows job title, e.g. AD_VP, FI_ACCOUNTANT';
comment on column JOBS.min_salary
  is 'Minimum salary for a job title.';
comment on column JOBS.max_salary
  is 'Maximum salary for a job title';
alter table JOBS
  add constraint JOB_ID_PK primary key (JOB_ID);
alter table JOBS
  add constraint JOB_TITLE_NN
  check ("JOB_TITLE" IS NOT NULL);

prompt
prompt Creating table DEPARTMENTS
prompt ==========================
prompt
create table DEPARTMENTS
(
  department_id   NUMBER(4) not null,
  department_name VARCHAR2(30),
  manager_id      NUMBER(6),
  location_id     NUMBER(4)
)
;
comment on table DEPARTMENTS
  is 'Departments table that shows details of departments where employees
work. Contains 27 rows; references with locations, employees, and job_history tables.';
comment on column DEPARTMENTS.department_id
  is 'Primary key column of departments table.';
comment on column DEPARTMENTS.department_name
  is 'A not null column that shows name of a department. Administration,
Marketing, Purchasing, Human Resources, Shipping, IT, Executive, Public
Relations, Sales, Finance, and Accounting. ';
comment on column DEPARTMENTS.manager_id
  is 'Manager_id of a department. Foreign key to employee_id column of employees table. The manager_id column of the employee table references this column.';
comment on column DEPARTMENTS.location_id
  is 'Location id where a department is located. Foreign key to location_id column of locations table.';
create index DEPT_LOCATION_IX on DEPARTMENTS (LOCATION_ID);
alter table DEPARTMENTS
  add constraint DEPT_ID_PK primary key (DEPARTMENT_ID);
alter table DEPARTMENTS
  add constraint DEPT_LOC_FK foreign key (LOCATION_ID)
  references LOCATIONS (LOCATION_ID);
alter table DEPARTMENTS
  add constraint DEPT_MGR_FK foreign key (MANAGER_ID)
  references EMPLOYEES (EMPLOYEE_ID);
alter table DEPARTMENTS
  add constraint DEPT_NAME_NN
  check ("DEPARTMENT_NAME" IS NOT NULL);

prompt
prompt Creating table EMPLOYEES
prompt ========================
prompt
create table EMPLOYEES
(
  employee_id    NUMBER(6) not null,
  first_name     VARCHAR2(20),
  last_name      VARCHAR2(25),
  email          VARCHAR2(25),
  phone_number   VARCHAR2(20),
  hire_date      DATE,
  job_id         VARCHAR2(10),
  salary         NUMBER(8,2),
  commission_pct NUMBER(2,2),
  manager_id     NUMBER(6),
  department_id  NUMBER(4),
  upd_counter    NUMBER not null,
  crt_user       VARCHAR2(64),
  crt_date       DATE,
  upd_user       VARCHAR2(64),
  upd_date       DATE
)
;
comment on table EMPLOYEES
  is 'employees table. Contains 107 rows. References with departments,
jobs, job_history tables. Contains a self reference.';
comment on column EMPLOYEES.employee_id
  is 'Primary key of employees table.';
comment on column EMPLOYEES.first_name
  is 'First name of the employee. A not null column.';
comment on column EMPLOYEES.last_name
  is 'Last name of the employee. A not null column.';
comment on column EMPLOYEES.email
  is 'Email id of the employee';
comment on column EMPLOYEES.phone_number
  is 'Phone number of the employee; includes country code and area code';
comment on column EMPLOYEES.hire_date
  is 'Date when the employee started on this job. A not null column.';
comment on column EMPLOYEES.job_id
  is 'Current job of the employee; foreign key to job_id column of the
jobs table. A not null column.';
comment on column EMPLOYEES.salary
  is 'Monthly salary of the employee. Must be greater
than zero (enforced by constraint emp_salary_min)';
comment on column EMPLOYEES.commission_pct
  is 'Commission percentage of the employee; Only employees in sales
department elgible for commission percentage';
comment on column EMPLOYEES.manager_id
  is 'Manager id of the employee; has same domain as manager_id in
departments table. Foreign key to employee_id column of employees table.
(useful for reflexive joins and CONNECT BY query)';
comment on column EMPLOYEES.department_id
  is 'Department id where employee works; foreign key to department_id
column of the departments table';
comment on column EMPLOYEES.upd_counter
  is 'Счетчик оптимистичной блокировки ';
comment on column EMPLOYEES.crt_user
  is 'Имя пользователя, создавшего запись';
comment on column EMPLOYEES.crt_date
  is 'Дата создания записи ';
comment on column EMPLOYEES.upd_user
  is 'Имя пользователя, обновившего запись ';
comment on column EMPLOYEES.upd_date
  is 'Дата обновления данных';
create index EMP_DEPARTMENT_IX on EMPLOYEES (DEPARTMENT_ID);
create index EMP_JOB_IX on EMPLOYEES (JOB_ID);
create index EMP_MANAGER_IX on EMPLOYEES (MANAGER_ID);
create index EMP_NAME_IX on EMPLOYEES (LAST_NAME, FIRST_NAME);
alter table EMPLOYEES
  add constraint EMP_EMP_ID_PK primary key (EMPLOYEE_ID);
alter table EMPLOYEES
  add constraint EMP_EMAIL_UK unique (EMAIL);
alter table EMPLOYEES
  add constraint EMP_DEPT_FK foreign key (DEPARTMENT_ID)
  references DEPARTMENTS (DEPARTMENT_ID);
alter table EMPLOYEES
  add constraint EMP_JOB_FK foreign key (JOB_ID)
  references JOBS (JOB_ID);
alter table EMPLOYEES
  add constraint EMP_MANAGER_FK foreign key (MANAGER_ID)
  references EMPLOYEES (EMPLOYEE_ID);
alter table EMPLOYEES
  add constraint EMP_EMAIL_NN
  check ("EMAIL" IS NOT NULL);
alter table EMPLOYEES
  add constraint EMP_HIRE_DATE_NN
  check ("HIRE_DATE" IS NOT NULL);
alter table EMPLOYEES
  add constraint EMP_JOB_NN
  check ("JOB_ID" IS NOT NULL);
alter table EMPLOYEES
  add constraint EMP_LAST_NAME_NN
  check ("LAST_NAME" IS NOT NULL);
alter table EMPLOYEES
  add constraint EMP_SALARY_MIN
  check (salary > 0);

prompt
prompt Creating table LOCATIONS
prompt ========================
prompt
create table LOCATIONS
(
  location_id    NUMBER(4) not null,
  street_address VARCHAR2(40),
  postal_code    VARCHAR2(12),
  city           VARCHAR2(30),
  state_province VARCHAR2(25),
  country_id     CHAR(2)
)
;
comment on table LOCATIONS
  is 'Locations table that contains specific address of a specific office,
warehouse, and/or production site of a company. Does not store addresses /
locations of customers. Contains 23 rows; references with the
departments and countries tables. ';
comment on column LOCATIONS.location_id
  is 'Primary key of locations table';
comment on column LOCATIONS.street_address
  is 'Street address of an office, warehouse, or production site of a company.
Contains building number and street name';
comment on column LOCATIONS.postal_code
  is 'Postal code of the location of an office, warehouse, or production site
of a company. ';
comment on column LOCATIONS.city
  is 'A not null column that shows city where an office, warehouse, or
production site of a company is located. ';
comment on column LOCATIONS.state_province
  is 'State or Province where an office, warehouse, or production site of a
company is located.';
comment on column LOCATIONS.country_id
  is 'Country where an office, warehouse, or production site of a company is
located. Foreign key to country_id column of the countries table.';
create index LOC_CITY_IX on LOCATIONS (CITY);
create index LOC_COUNTRY_IX on LOCATIONS (COUNTRY_ID);
create index LOC_STATE_PROVINCE_IX on LOCATIONS (STATE_PROVINCE);
alter table LOCATIONS
  add constraint LOC_ID_PK primary key (LOCATION_ID);
alter table LOCATIONS
  add constraint LOC_C_ID_FK foreign key (COUNTRY_ID)
  references COUNTRIES (COUNTRY_ID);
alter table LOCATIONS
  add constraint LOC_CITY_NN
  check ("CITY" IS NOT NULL);

prompt
prompt Creating table JOB_HISTORY
prompt ==========================
prompt
create table JOB_HISTORY
(
  employee_id   NUMBER(6),
  start_date    DATE,
  end_date      DATE,
  job_id        VARCHAR2(10),
  department_id NUMBER(4)
)
;
comment on table JOB_HISTORY
  is 'Table that stores job history of the employees. If an employee
changes departments within the job or changes jobs within the department,
new rows get inserted into this table with old job information of the
employee. Contains a complex primary key: employee_id+start_date.
Contains 25 rows. References with jobs, employees, and departments tables.';
comment on column JOB_HISTORY.employee_id
  is 'A not null column in the complex primary key employee_id+start_date.
Foreign key to employee_id column of the employee table';
comment on column JOB_HISTORY.start_date
  is 'A not null column in the complex primary key employee_id+start_date.
Must be less than the end_date of the job_history table. (enforced by
constraint jhist_date_interval)';
comment on column JOB_HISTORY.end_date
  is 'Last day of the employee in this job role. A not null column. Must be
greater than the start_date of the job_history table.
(enforced by constraint jhist_date_interval)';
comment on column JOB_HISTORY.job_id
  is 'Job role in which the employee worked in the past; foreign key to
job_id column in the jobs table. A not null column.';
comment on column JOB_HISTORY.department_id
  is 'Department id in which the employee worked in the past; foreign key to deparment_id column in the departments table';
create index JHIST_DEPARTMENT_IX on JOB_HISTORY (DEPARTMENT_ID);
create index JHIST_EMPLOYEE_IX on JOB_HISTORY (EMPLOYEE_ID);
create index JHIST_JOB_IX on JOB_HISTORY (JOB_ID);
alter table JOB_HISTORY
  add constraint JHIST_EMP_ID_ST_DATE_PK primary key (EMPLOYEE_ID, START_DATE);
alter table JOB_HISTORY
  add constraint JHIST_DEPT_FK foreign key (DEPARTMENT_ID)
  references DEPARTMENTS (DEPARTMENT_ID);
alter table JOB_HISTORY
  add constraint JHIST_EMP_FK foreign key (EMPLOYEE_ID)
  references EMPLOYEES (EMPLOYEE_ID);
alter table JOB_HISTORY
  add constraint JHIST_JOB_FK foreign key (JOB_ID)
  references JOBS (JOB_ID);
alter table JOB_HISTORY
  add constraint JHIST_DATE_INTERVAL
  check (end_date > start_date);
alter table JOB_HISTORY
  add constraint JHIST_EMPLOYEE_NN
  check ("EMPLOYEE_ID" IS NOT NULL);
alter table JOB_HISTORY
  add constraint JHIST_END_DATE_NN
  check ("END_DATE" IS NOT NULL);
alter table JOB_HISTORY
  add constraint JHIST_JOB_NN
  check ("JOB_ID" IS NOT NULL);
alter table JOB_HISTORY
  add constraint JHIST_START_DATE_NN
  check ("START_DATE" IS NOT NULL);

prompt
prompt Creating table MESSAGES
prompt =======================
prompt
create table MESSAGES
(
  id        NUMBER,
  msg_text  VARCHAR2(2000),
  msg_type  VARCHAR2(10),
  dest_addr VARCHAR2(150),
  msg_state NUMBER(4)
)
;
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

prompt
prompt Creating sequence DEPARTMENTS_SEQ
prompt =================================
prompt
create sequence DEPARTMENTS_SEQ
minvalue 1
maxvalue 9990
start with 280
increment by 10
nocache;

prompt
prompt Creating sequence EMPLOYEES_SEQ
prompt ===============================
prompt
create sequence EMPLOYEES_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 320
increment by 1
nocache;

prompt
prompt Creating sequence LOCATIONS_SEQ
prompt ===============================
prompt
create sequence LOCATIONS_SEQ
minvalue 1
maxvalue 9900
start with 3300
increment by 100
nocache;

prompt
prompt Creating sequence MESSAGES_SEQ
prompt ==============================
prompt
create sequence MESSAGES_SEQ
minvalue 1
maxvalue 9990
start with 127
increment by 1
nocache;

prompt
prompt Creating view EMP_DETAILS_VIEW
prompt ==============================
prompt
CREATE OR REPLACE FORCE VIEW EMP_DETAILS_VIEW AS
SELECT
  e.employee_id,
  e.job_id,
  e.manager_id,
  e.department_id,
  d.location_id,
  l.country_id,
  e.first_name,
  e.last_name,
  e.salary,
  e.commission_pct,
  d.department_name,
  j.job_title,
  l.city,
  l.state_province,
  c.country_name,
  r.region_name
FROM
  employees e,
  departments d,
  jobs j,
  locations l,
  countries c,
  regions r
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND l.country_id = c.country_id
  AND c.region_id = r.region_id
  AND j.job_id = e.job_id
WITH READ ONLY;

prompt
prompt Creating package ENTEMPLOYEES
prompt =============================
prompt
create or replace package entEMPLOYEES is

  -- Created : 07.10.2022 2:12:18
  -- Purpose : Обработка бизнес-логики объектов из таблицы EMPLOYEES

  -- 07.10.2022 VSHESTAKOV - v01

  ---------------------------------------------------------------
  -- КОНСТАНТЫ

    -- Текст сообщения для нового работника
    C_GREETING_EMP_TEXT constant messages.msg_text%type :=  'Уважаемый %s %s! Вы приняты в качестве %s в подразделение %s.';
    C_GREETING_EMP_TEXT2 constant messages.msg_text%type :=  'Ваш руководитель: %s %s %s.';
    -- Уважаемый < FIRST_NAME > < LAST_NAME >! Вы приняты в качестве < JOB_TITLE > в подразделение < DEPARTMENT_NAME >.
    -- Ваш руководитель: < JOB_TITLE > < FIRST_NAME > < LAST_NAME >”.

    -- Текст сообщения для руководителя нового работника
    C_GREETING_MGR_TEXT constant messages.msg_text%type :=  'Уважаемый %s %s! В ваше подразделение принят новый сотрудник %s %s в должности %s с окладом %s.';
    -- Уважаемый < FIRST_NAME > < LAST_NAME >! В ваше подразделение принят новый сотрудник < FIRST_NAME > < LAST_NAME > в должности < JOB_TITLE > с окладом < SALARY >.

    С_MSG_TYPE_EMAIL   CONSTANT messages.msg_type%type := 'email';
    С_MSG_TYPE_SMS   CONSTANT messages.msg_type%type := 'sms';
    С_MSG_TYPE_DEF   CONSTANT messages.msg_type%type := С_MSG_TYPE_EMAIL
    -- Тип отправляемого сообщения по-умолчанию
    ;

  ---------------------------------------------------------------
  -- ОШИБКИ

    -- Ошибка  -20101 Не заполнены обязательные параметры (%s)
    EX_EMPLOYMENT_WR_PARAMS     exception;
    EX_EMPLOYMENT_WR_PARAMS_MSG constant varchar2(400) := 'Не заполнены обязательные параметры (%s)';
    pragma exception_init(EX_EMPLOYMENT_WR_PARAMS, -20101);



  ---------------------------------------------------------------
  function GET_GREETING_MGR_TEXT
  (
    p_id  in employees.employee_id%type
  )
  return messages.msg_text%type
  /*
    Возвращяет текст сообщения для руководителя работника

    ПАРАМЕТРЫ
      p_id - Код сотрудника
  /**/
  ;

  ---------------------------------------------------------------
  function GET_GREETING_EMP_TEXT
  (
    p_id  in employees.employee_id%type
  )
  return messages.msg_text%type
  /*
    Возвращяет текст сообщения для работника

    ПАРАМЕТРЫ
      p_id - Код сотрудника
  /**/
  ;

  ---------------------------------------------------------------
  procedure MESSAGE_INS
  (
    p_row    in MESSAGES%rowtype
   ,p_update in boolean := false
  )
  /*
    Выполняет вставку новой строки MESSAGES
    Перегрузка по строке

    ПАРАМЕТРЫ
      p_row        - Данные вставляемой записи MESSAGES
      p_update
        true       - если строка с таким индексом уже существует, выполняется обновление данных.
    ИСКЛЮЧЕНИЯ
        исключения при дублировании строк и нарушении других ограничений, наложенных на таблицу.
  /**/
  ;


  ---------------------------------------------------------------
  procedure MESSAGE_INS
  (
    p_msg_text  in messages.msg_text%type
   ,p_dest_addr in messages.dest_addr%type
   ,p_msg_type  in messages.msg_type%type := С_MSG_TYPE_DEF
   ,p_msg_state in messages.msg_state%type := 0
   ,p_update    in boolean := false
  )
  /*
    Выполняет вставку новой строки MESSAGES
    Перегрузка по фактическим полям

    ПАРАМЕТРЫ
      p_msg_text   - текст сообщения
     ,p_dest_addr  - адрес получателя сообщения (email, номер телефона)
     ,p_msg_type   - тип сообщения (email, sms и т.п.)
     ,p_msg_state  - статус обработки сообщения внешней системой (0 - добавлено в очередь, 1 - успешно отправлено, -1 - отправлено с ошибкой)
     ,p_update
        true       - если строка с таким индексом уже существует, выполняется обновление данных.
  /**/
  ;

  ---------------------------------------------------------------
  procedure EMPLOYMENT
  (
    p_first_name             in employees.first_name%type
   ,p_last_name              in employees.last_name%type
   ,p_email                  in employees.email%type
   ,p_phone_number           in employees.phone_number%type
   ,p_job_id                 in employees.job_id%type
   ,p_department_id          in employees.department_id%type
   ,p_manager_id             in employees.manager_id%type
   ,p_salary                 in employees.salary%type
   ,p_commission_pct         in employees.commission_pct%type
   ,p_msg_type               in messages.msg_type%type := С_MSG_TYPE_EMAIL -- Тип сообщения для отправки sms / email
  )
  /*
    Процедура реализует функционал приема на работу нового сотрудника.
    - Расчитывает оклад, если не указан
    - Добавляет запись в EMPLOYEES
    - Создает сообщения типа P_MSG_TYPE (email) в таблице MESSAGES для работника и его руководителя (если указан)

    ПАРАМЕТРЫ
       p_first_name       - Поля карточки EMPLOYEES
      ,p_last_name
      ,p_email
      ,p_phone_number
      ,p_job_id
      ,p_department_id
      ,p_manager_id
      ,p_salary           - не обязательны для заполнения
      ,p_commission_pct     Если они пустые, при добавлении записи эти данные заполняются средними значениями
                            по подразделению и штатной должности (JOB_ID, DEPARTMENT_ID)
      ,p_msg_type         - Тип сообщения для отправки sms / email

    ИСКЛЮЧЕНИЯ
      исключения при нарушении ограничений на данные таблицы.
  /**/
  ;

end entEMPLOYEES;
/

prompt
prompt Creating package ENTEMPLOYEES_TEST
prompt ==================================
prompt
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

prompt
prompt Creating package TABEMPLOYEES
prompt =============================
prompt
create or replace package tabEMPLOYEES is

  -- Author  : VSHESTAKOV
  -- Created : 06.10.2022 17:15:18
  -- Purpose : Обработка операций чтения/записи данных в таблицу EMPLOYEES

  -- 07.10.2022 USER - v01

  ---------------------------------------------------------------
  procedure sel
  (
    p_id        in EMPLOYEES.EMPLOYEE_ID%type
   ,p_row       out EMPLOYEES%rowtype
   ,p_forUpdate in boolean := false
   ,p_rase      in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
      p_row        - Возвращаемая запись EMPLOYEES
      p_forUpdate
        true     - выполняется SELECT … FOR UPDATE
        false    - обычный SELECT
      p_rase
        true     - происходит вызов исключений
        false    - исключения игнорируются

    /**/
  ;

  ---------------------------------------------------------------
  procedure ins
  (
    p_row    in EMPLOYEES%rowtype
   ,p_update in boolean := false
  )
  /*
    Выполняет вставку новой строки EMPLOYEES

    ПАРАМЕТРЫ
      p_row        - Данные вставляемой записи EMPLOYEES
      p_update
        true       - если строка с таким индексом уже существует, выполняется обновление данных.
    ИСКЛЮЧЕНИЯ
        исключения при дублировании строк и нарушении других ограничений, наложенных на таблицу.
    /**/
  ;


  ---------------------------------------------------------------
  procedure upd
  (
    p_row    in EMPLOYEES%rowtype
   ,p_insert in boolean := false
  )
  /*
    Процедура выполняет обновление данных в строке (кроме первичного ключа) EMPLOYEES

    ПАРАМЕТРЫ
      p_row        - Данные записи EMPLOYEES
      p_insert
        true     - если строка с таким индексом не существует, выполняется вставка новой строки.
    ИСКЛЮЧЕНИЯ
        исключения при дублировании строк и нарушении других ограничений, наложенных на таблицу.
    /**/
  ;

  ---------------------------------------------------------------
  procedure del
  (
    p_id in EMPLOYEES.employee_id%type
  )
  /*
    Процедура выполняет удаление строки данных EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
    /**/
  ;

  ---------------------------------------------------------------
  function exist
  (
    p_id in EMPLOYEES.employee_id%type
  )
  return boolean
  /*
    Функция возвращает истину, если строка с указанным ключом существует в таблице EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
    /**/
  ;

end tabEMPLOYEES;
/

prompt
prompt Creating package TABEMPLOYEES_TEST
prompt ==================================
prompt
create or replace package tabEMPLOYEES_TEST is

  -- Author  : VSHESTAKOV
  -- Created : 07.10.2022 0:21:02
  -- Purpose : Тестирование пакета tabEMPLOYEES


  -- 07.10.2022 VSHESTAKOV - v01

  /*
  begin
    rollback;
    -- Выполнить все тесты
    tabEMPLOYEES_TEST.runall;
  end;
  /**/

  ---------------------------------------------------------------
  procedure runall
  -- Все тесты
  ;

end tabEMPLOYEES_TEST;
/

prompt
prompt Creating procedure ADD_JOB_HISTORY
prompt ==================================
prompt
CREATE OR REPLACE PROCEDURE add_job_history
  (  p_emp_id          job_history.employee_id%type
   , p_start_date      job_history.start_date%type
   , p_end_date        job_history.end_date%type
   , p_job_id          job_history.job_id%type
   , p_department_id   job_history.department_id%type
   )
IS
BEGIN
  INSERT INTO job_history (employee_id, start_date, end_date,
                           job_id, department_id)
    VALUES(p_emp_id, p_start_date, p_end_date, p_job_id, p_department_id);
END add_job_history;
/

prompt
prompt Creating procedure SECURE_DML
prompt =============================
prompt
CREATE OR REPLACE PROCEDURE secure_dml
IS
BEGIN
  IF TO_CHAR (SYSDATE, 'HH24:MI') NOT BETWEEN '08:00' AND '18:00'
        OR TO_CHAR (SYSDATE, 'DY') IN ('SAT', 'SUN') THEN
	RAISE_APPLICATION_ERROR (-20205,
		'You may only make changes during normal office hours');
  END IF;
END secure_dml;
/

prompt
prompt Creating package body ENTEMPLOYEES
prompt ==================================
prompt
create or replace package body entEMPLOYEES is

  ---------------------------------------------------------------
  -- Данные о сотруднике и его руководителе
  cursor CUR_EMPLOYEE(c_employee_id in employees.employee_id%type) is
    select em.employee_id
          ,em.first_name
          ,em.last_name
          ,j.job_title
          ,d.department_name
          ,em.salary
          ,jmg.job_title   as mgr_job_title
          ,emg.first_name  as mgr_first_name
          ,emg.last_name   as mgr_last_name
          --,em.*
      from EMPLOYEES em
      left join JOBS j
        on j.job_id = em.job_id
      left join DEPARTMENTS d
        on d.department_id = em.department_id
      left join EMPLOYEES emg
        on emg.employee_id = em.manager_id
      left join JOBS jmg
        on jmg.job_id = em.job_id
     where 1=1
       and em.employee_id = C_EMPLOYEE_ID;

  ---------------------------------------------------------------
  -- Cредние зарплаты, комиссии по отделу и должности
  cursor CUR_AVG_DEPT_SALARY(
    c_department_id in employees.department_id%type
   ,c_job_id        in employees.job_id%type
  )
  is
    select distinct
           em.department_id
          ,em.job_id
          ,round(avg(em.salary) over ( partition by em.department_id, em.job_id), 2) as avg_dept_salary -- Средняя зарплата сотрудника по отделу
          ,round(avg(em.commission_pct) over ( partition by em.department_id, em.job_id), 2) as avg_dept_commission_pct -- Средняя комиссия сотрудника по отделу
        from EMPLOYEES em
       where 1=1
         and em.department_id = C_DEPARTMENT_ID
         and em.job_id = C_JOB_ID
    ;/**/


  ---------------------------------------------------------------
  function GET_GREETING_MGR_TEXT
  (
    p_id  in employees.employee_id%type
  )
  return messages.msg_text%type
  /*
    Возвращяет текст сообщения для руководителя работника

    ПАРАМЕТРЫ
      p_id - Код сотрудника
  /**/
  is
    v_res messages.msg_text%type;
  begin
    for rec in CUR_EMPLOYEE(p_id)
    loop
      v_res := utl_lms.format_message(
         entEMPLOYEES.C_GREETING_MGR_TEXT
         --'Уважаемый %s %s! В ваше подразделение принят новый сотрудник %s %s в должности %s с окладом %s'
         , TO_CHAR(rec.mgr_first_name)
         , TO_CHAR(rec.mgr_last_name)
         , TO_CHAR(rec.first_name)
         , TO_CHAR(rec.last_name)
         , TO_CHAR(rec.job_title)
         , TO_CHAR(rec.salary)
       );
    end loop;
    return v_res;
  end;

  ---------------------------------------------------------------
  function GET_GREETING_EMP_TEXT
  (
    p_id  in employees.employee_id%type
  )
  return messages.msg_text%type
  /*
    Возвращяет текст сообщения для работника

    ПАРАМЕТРЫ
      p_id - Код сотрудника
  /**/
  is
    v_res messages.msg_text%type;
  begin
    for rec in CUR_EMPLOYEE(p_id)
    loop
      v_res := utl_lms.format_message(
         entEMPLOYEES.C_GREETING_EMP_TEXT
         --'Уважаемый %s %s! Вы приняты в качестве %s в подразделение %s.'
         , TO_CHAR(rec.first_name)
         , TO_CHAR(rec.last_name)
         , TO_CHAR(rec.job_title)
         , TO_CHAR(rec.department_name)
       );

       -- Если есть руководитель, ссылка на него
       if rec.mgr_last_name is not null then
         v_res := v_res || ' ' || utl_lms.format_message(
           entEMPLOYEES.C_GREETING_EMP_TEXT2
           --'Ваш руководитель: %s %s %s.'
           , TO_CHAR(rec.mgr_job_title)
           , TO_CHAR(rec.mgr_first_name)
           , TO_CHAR(rec.mgr_last_name)
         );
       end if;

    end loop;
    return v_res;
  end;


  ---------------------------------------------------------------
  procedure MESSAGE_INS
  (
    p_row    in MESSAGES%rowtype
   ,p_update in boolean := false
  )
  /*
    Выполняет вставку новой строки MESSAGES
    Перегрузка по строке

    ПАРАМЕТРЫ
      p_row        - Данные вставляемой записи MESSAGES
      p_update
        true       - если строка с таким индексом уже существует, выполняется обновление данных.
    ИСКЛЮЧЕНИЯ
        исключения при дублировании строк и нарушении других ограничений, наложенных на таблицу.
    /**/
  is
  begin
    -- Попытка добавить данные
    begin
      insert into MESSAGES
      values p_row;
    exception
      when dup_val_on_index then
        -- Если не удалось по дублю
        -- пробуем обновить
        if p_update then
          update MESSAGES m
             set row = p_row
           where m.id = p_row.id;
        else
          raise;
        end if;
    end;
  end message_ins;

  ---------------------------------------------------------------
  procedure MESSAGE_INS
  (
    p_msg_text  in messages.msg_text%type
   ,p_dest_addr in messages.dest_addr%type
   ,p_msg_type  in messages.msg_type%type := С_MSG_TYPE_DEF
   ,p_msg_state in messages.msg_state%type := 0
   ,p_update    in boolean := false
  )
  /*
    Выполняет вставку новой строки MESSAGES
    Перегрузка по фактическим полям

    ПАРАМЕТРЫ
      p_msg_text   - текст сообщения
     ,p_dest_addr  - адрес получателя сообщения (email, номер телефона)
     ,p_msg_type   - тип сообщения (email, sms и т.п.)
     ,p_msg_state  - статус обработки сообщения внешней системой (0 - добавлено в очередь, 1 - успешно отправлено, -1 - отправлено с ошибкой)
     ,p_update
        true       - если строка с таким индексом уже существует, выполняется обновление данных.
  /**/
  is
    v_row    MESSAGES%rowtype;
  begin

    v_row.msg_text  := p_msg_text;
    v_row.msg_type  := p_msg_type;
    v_row.dest_addr := p_dest_addr;
    v_row.msg_state := p_msg_state;

    message_ins(p_row => v_row, p_update => p_update);

  end message_ins;

  ---------------------------------------------------------------
  procedure EMPLOYMENT
  (
    p_first_name             in employees.first_name%type
   ,p_last_name              in employees.last_name%type
   ,p_email                  in employees.email%type
   ,p_phone_number           in employees.phone_number%type
   ,p_job_id                 in employees.job_id%type
   ,p_department_id          in employees.department_id%type
   ,p_manager_id             in employees.manager_id%type
   ,p_salary                 in employees.salary%type
   ,p_commission_pct         in employees.commission_pct%type
   ,p_msg_type               in messages.msg_type%type := С_MSG_TYPE_EMAIL -- Тип сообщения для отправки sms / email
  )
  /*
    Процедура реализует функционал приема на работу нового сотрудника.
    - Расчитывает оклад, если не указан
    - Добавляет запись в EMPLOYEES
    - Создает сообщения типа P_MSG_TYPE (email) в таблице MESSAGES для работника и его руководителя (если указан)

    ПАРАМЕТРЫ
       p_first_name       - Поля карточки EMPLOYEES
      ,p_last_name
      ,p_email
      ,p_phone_number
      ,p_job_id
      ,p_department_id
      ,p_manager_id
      ,p_salary           - не обязательны для заполнения
      ,p_commission_pct     Если они пустые, при добавлении записи эти данные заполняются средними значениями
                            по подразделению и штатной должности (JOB_ID, DEPARTMENT_ID)
      ,p_msg_type         - Тип сообщения для отправки sms / email

    ИСКЛЮЧЕНИЯ
      исключения при нарушении ограничений на данные таблицы.
  /**/
  is
    v_row        EMPLOYEES%rowtype;
    v_err        varchar2(250);
    v_emp_msg    messages.msg_text%type;
    v_mgr_msg    messages.msg_text%type;
    v_mgr_addr   messages.dest_addr%type;
    v_emp_addr   messages.dest_addr%type;
  begin

    -- Проверка на обязательные параметры
    select ltrim(decode(p_department_id, null, 'p_department_id')
           || ', ' || decode(p_job_id, null, 'p_job_id')
           , ', ')
      into v_err
      from dual;
    if v_err is not null then
      RAISE_APPLICATION_ERROR(-20101, utl_lms.format_message(EX_EMPLOYMENT_WR_PARAMS_MSG, v_err));
    end if;

    v_row.employee_id     := EMPLOYEES_SEQ.Nextval;
    v_row.first_name      := p_first_name;
    v_row.last_name       := p_last_name;
    v_row.email           := p_email;
    v_row.phone_number    := p_phone_number;
    v_row.hire_date       := trunc(sysdate);
    v_row.job_id          := p_job_id;
    v_row.department_id   := p_department_id;
    v_row.manager_id      := p_manager_id;
    v_row.salary          := p_salary;
    v_row.commission_pct  := p_commission_pct;


    -- Если не заполнен размер зп или комиссии
    if p_salary is null or p_commission_pct is null then
      -- Получим размер зп, или комиссии из среднего по отделу и должности
      for rec in CUR_AVG_DEPT_SALARY(p_department_id, p_job_id)
      loop
        v_row.salary          := nvl(p_salary, rec.avg_dept_salary);
        v_row.commission_pct  := nvl(p_commission_pct, rec.avg_dept_commission_pct);
      end loop;
    end if;

    -- Создаем сотрудика
    tabEMPLOYEES.ins(p_row => v_row);

    -- Получим тексты сообщений и, адрес руководителя и сотрудника
    select entEMPLOYEES.get_greeting_emp_text(v_row.employee_id) as emp_msg
          ,entEMPLOYEES.get_greeting_mgr_text(v_row.employee_id) as mgr_msg
          ,decode(p_msg_type, С_MSG_TYPE_EMAIL, emg.email, emg.phone_number) -- телефон или email руководителя
          ,decode(p_msg_type, С_MSG_TYPE_EMAIL, v_row.email, v_row.phone_number) -- телефон или email сотрудника
      into v_emp_msg, v_mgr_msg, v_mgr_addr, v_emp_addr
      from dual
      left join EMPLOYEES em
        on em.employee_id = v_row.employee_id
      left join EMPLOYEES emg
        on emg.employee_id = em.manager_id;

    dbms_output.put_line('  v_mgr_addr = ' || v_mgr_addr); --< Для отладки
    dbms_output.put_line('  v_emp_addr = ' || v_emp_addr); --< Для отладки

    if v_mgr_addr is not null then
      -- Отправляем почту руководителю сотрудника
      entEMPLOYEES.message_ins(
          p_msg_text  => v_mgr_msg
         ,p_msg_type  => p_msg_type
         ,p_dest_addr => v_mgr_addr);
    end if;

    -- Отправляем почту новому сотруднику
    entEMPLOYEES.message_ins(
        p_msg_text  => v_emp_msg
       ,p_msg_type  => p_msg_type
       ,p_dest_addr => v_emp_addr);

  end EMPLOYMENT;

end entEMPLOYEES;
/

prompt
prompt Creating package body ENTEMPLOYEES_TEST
prompt =======================================
prompt
create or replace package body entEMPLOYEES_TEST is

  ---------------------------------------------------------------
  procedure MSG_T
  -- Сообщения для работника, начальника
  is
    v_id      employees.employee_id%type := 108;
    v_emp_msg messages.msg_text%type;
    v_mgr_msg messages.msg_text%type;
  begin
    dbms_output.put_line('Тест сообщений для работника и начальника'); --< Для отладки

    select entEMPLOYEES.get_greeting_emp_text(v_id) as emp_msg
          ,entEMPLOYEES.get_greeting_mgr_text(v_id) as mgr_msg
      into v_emp_msg, v_mgr_msg
      from dual;

    dbms_output.put_line('v_emp_msg = ' || v_emp_msg);
    dbms_output.put_line('C_GREETING_EMP_TEXT = ' || entEMPLOYEES.C_GREETING_EMP_TEXT);
    dbms_output.put_line('C_GREETING_EMP_TEXT2 = ' || entEMPLOYEES.C_GREETING_EMP_TEXT2);

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
    dbms_output.put_line('Создает сотрудника, возвращает ошибку, не указана должность и департамент'); --< Для отладки
    begin -- exception block
      dbms_output.put_line('Create EMP'); --< Для отладки
      entEmployees.employment(p_first_name     => 'John',
                              p_last_name      => 'employment_t',
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
    v_msg_type    MESSAGES.msg_type%type := entEmployees.С_MSG_TYPE_DEF;
    v_dest_addr   MESSAGES.dest_addr%type;
    v_dest_addr2  MESSAGES.dest_addr%type;
  begin
    dbms_output.put_line('Создает сотрудника, со ссылкой на менеджера (отправит два сообщения на почту), оклад и процент не указаны (усредненные)'); --< Для отладки

    v_dest_addr  := 'employment_t2@def.com';
    v_dest_addr2 := 'NGREENBE';

    dbms_output.put_line('Create EMP'); --< Для отладки
    entEmployees.employment(p_first_name     => 'John',
                            p_last_name      => 'employment_t2',
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
       and e.email = v_dest_addr
    ;/**/

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);

    dbms_output.put_line('v_id = ' || v_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);
    dbms_output.put_line('v_row.email = ' || v_row.email);
    dbms_output.put_line('v_row.manager_id = ' || v_row.manager_id);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);
    dbms_output.put_line('v_row.commission_pct = ' || v_row.commission_pct);


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
      dbms_output.put_line('  rec.msg_type  = ' || rec.msg_type);
      dbms_output.put_line('  rec.msg_state  = ' || rec.msg_state);
    end loop; -- Конец перебора

  end;


  ---------------------------------------------------------------
  procedure EMPLOYMENT_T3
  -- Создаем сотрудника
  is
    v_id          EMPLOYEES.EMPLOYEE_ID%type;
    v_row         EMPLOYEES%rowtype;
    v_msg_type    MESSAGES.msg_type%type := entEmployees.С_MSG_TYPE_DEF;
    v_dest_addr   MESSAGES.dest_addr%type;
    v_dest_addr2  MESSAGES.dest_addr%type;
  begin
    dbms_output.put_line('Создает сотрудника, без ссылки на менеджера (отправит только одно сообщение на почту), с фиксированным окладом'); --< Для отладки

    v_dest_addr  := 'employment_t3@def.com';
    v_dest_addr2 := '';

    dbms_output.put_line('Create EMP'); --< Для отладки
    entEmployees.employment(p_first_name     => 'John',
                            p_last_name      => 'employment_t3',
                            p_email          => v_dest_addr,
                            p_phone_number   => '+7804650',
                            p_job_id         => 'SA_REP',
                            p_department_id  => 80,
                            p_manager_id     => null,
                            p_salary         => 110000,
                            p_commission_pct => 0.1);

    -- Найдем клиента
    select max(e.employee_id)
      into v_id
      from EMPLOYEES e
     where 1=1
       and e.email = v_dest_addr
    ;/**/

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);

    dbms_output.put_line('v_id = ' || v_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);
    dbms_output.put_line('v_row.email = ' || v_row.email);
    dbms_output.put_line('v_row.manager_id = ' || v_row.manager_id);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);
    dbms_output.put_line('v_row.commission_pct = ' || v_row.commission_pct);


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
      dbms_output.put_line('  rec.msg_type  = ' || rec.msg_type);
      dbms_output.put_line('  rec.msg_state  = ' || rec.msg_state);
    end loop; -- Конец перебора

  end;


  ---------------------------------------------------------------
  procedure EMPLOYMENT_T4
  -- Создаем сотрудника
  is
    v_id          EMPLOYEES.EMPLOYEE_ID%type;
    v_row         EMPLOYEES%rowtype;
    v_msg_type    MESSAGES.msg_type%type := entEmployees.С_MSG_TYPE_SMS;
    v_dest_addr   MESSAGES.dest_addr%type;
    v_dest_addr2  MESSAGES.dest_addr%type;
    v_dest_addr3  MESSAGES.dest_addr%type;
  begin
    dbms_output.put_line('Создает сотрудника со ссылкой на менеджера (отправит два сообщения SMS), с фиксированным окладом'); --< Для отладки

    v_dest_addr  := 'employment_t4@def.com';
    v_dest_addr2 := '515.124.4569'; -- NGREENBE
    v_dest_addr3  := '+7804650';

    dbms_output.put_line('Create EMP'); --< Для отладки
    entEmployees.employment(p_first_name     => 'John',
                            p_last_name      => 'employment_t4',
                            p_email          => v_dest_addr,
                            p_phone_number   => '+7804650',
                            p_job_id         => 'SA_REP',
                            p_department_id  => 80,
                            p_manager_id     => 108,
                            p_salary         => 110000,
                            p_commission_pct => 0.1,
                            p_msg_type       => v_msg_type);

    -- Найдем клиента
    select max(e.employee_id)
      into v_id
      from EMPLOYEES e
     where 1=1
       and e.email = v_dest_addr
    ;/**/

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);

    dbms_output.put_line('v_id = ' || v_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);
    dbms_output.put_line('v_row.email = ' || v_row.email);
    dbms_output.put_line('v_row.manager_id = ' || v_row.manager_id);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);
    dbms_output.put_line('v_row.commission_pct = ' || v_row.commission_pct);


    -- Найдем сообщение
    dbms_output.put_line('Find messages:'); --< Для отладки
    for rec in (--
                select m.*
                  from MESSAGES m
                 where 1=1
                   and m.msg_type = v_msg_type
                   and m.dest_addr in (v_dest_addr, v_dest_addr2, v_dest_addr3)
                   --and rownum <= 1
                 order by 1 desc
               )
    loop
      dbms_output.put_line('  id = ' || rec.id);
      dbms_output.put_line('  rec.p_msg_text = ' || rec.msg_text);
      dbms_output.put_line('  rec.msg_type  = ' || rec.msg_type);
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

      dbms_output.put_line('');
      dbms_output.put_line('Тест - EMPLOYMENT_T3');
      EMPLOYMENT_T3;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - EMPLOYMENT_T4');
      EMPLOYMENT_T4;

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

prompt
prompt Creating package body TABEMPLOYEES
prompt ==================================
prompt
create or replace package body tabEMPLOYEES is

  ---------------------------------------------------------------
  procedure sel
  (
    p_id        in EMPLOYEES.EMPLOYEE_ID%type
   ,p_row       out EMPLOYEES%rowtype
   ,p_forUpdate in boolean := false
   ,p_rase      in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
      p_row        - Возвращаемая запись EMPLOYEES
      p_forUpdate
          true     - выполняется SELECT … FOR UPDATE
          false    - обычный SELECT
      p_rase
          true     - происходит вызов исключений
          false    - исключения игнорируются

    /**/
   is
    -- Выборка сотрудника для обновления
    cursor CUR_EMPLOYEES(c_employee_id in number) is
      select em.*
        from EMPLOYEES em
       where em.employee_id in c_employee_id;

    -- Выборка сотрудника без обновления
    cursor CUR_EMPLOYEES_FU(c_employee_id in number) is
      select em.*
        from EMPLOYEES em
       where em.employee_id in c_employee_id
         for update;

  begin

    if p_forUpdate then

      -- Выборка для обновления FOR UPDATE
      /*select *
       into p_row
       from EMPLOYEES em
      where em.employee_id in p_id for update; */

      for rec in CUR_EMPLOYEES_FU(p_id)
      loop
        p_row := rec;
      end loop;

    else
      -- Выборка без обновления
      for rec in CUR_EMPLOYEES(p_id)
      loop
        p_row := rec;
      end loop;
    end if;

  exception
    when others then
      -- Если флаг обработки исключений включен - обрабатываем
      if p_rase then
        raise;
      end if;
      -- Иначе - нет
  end;


  ---------------------------------------------------------------
  procedure ins
  (
    p_row    in EMPLOYEES%rowtype
   ,p_update in boolean := false
  )
  /*
    Выполняет вставку новой строки EMPLOYEES

    ПАРАМЕТРЫ
      p_row        - Данные вставляемой записи EMPLOYEES
      p_update
        true       - если строка с таким индексом уже существует, выполняется обновление данных.
    ИСКЛЮЧЕНИЯ
        исключения при дублировании строк и нарушении других ограничений, наложенных на таблицу.
    /**/
   is
  begin

    -- Попытка добавить данные
    begin
      insert into EMPLOYEES
      values p_row;
    exception
      when dup_val_on_index then
        --dbms_output.put_line('dup_val_on_index'); --< для отладки
        -- Если не удалось по дублю
        -- пробуем обновить
        if p_update then
          update EMPLOYEES emp
             set row = p_row
           where emp.employee_id = p_row.employee_id;
        else
          raise;
        end if;
    end;
  end ins;


  ---------------------------------------------------------------
  procedure upd
  (
    p_row    in EMPLOYEES%rowtype
   ,p_insert in boolean := false
  )
  /*
    Процедура выполняет обновление данных в строке (кроме первичного ключа) EMPLOYEES

    p_row        - Данные записи EMPLOYEES
    p_insert
        true     - если строка с таким индексом не существует, выполняется вставка новой строки.
    ИСКЛЮЧЕНИЯ
        исключения при дублировании строк и нарушении других ограничений, наложенных на таблицу.
    /**/
   is
  begin

    -- Обновим данные
    update EMPLOYEES emp
       set row = p_row
     where emp.employee_id = p_row.employee_id;

    -- Если режим вставки и не обновилось
    if p_insert
       and sql%rowcount = 0 then
      -- Вставляем
      insert into EMPLOYEES
      values p_row;
    end if;

  end upd;


  ---------------------------------------------------------------
  procedure del
  (
    p_id in EMPLOYEES.employee_id%type
  )
  /*
    Процедура выполняет удаление строки данных EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
  /**/
  is
  begin

    delete from EMPLOYEES emp
     where emp.employee_id = p_id;

  end del;

  ---------------------------------------------------------------
  function exist
  (
    p_id in EMPLOYEES.employee_id%type
  )
  return boolean
  /*
    Функция возвращает истину, если строка с указанным ключом существует в таблице EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
    /**/
  is
    v_res number := 0;
  begin
    select count(*) as cnt
      into v_res
      from EMPLOYEES emp
     where emp.employee_id = p_id;

    if v_res = 1 then
      return true;
    else
      return false;
    end if;

  end exist;

end tabEMPLOYEES;
/

prompt
prompt Creating package body TABEMPLOYEES_TEST
prompt =======================================
prompt
create or replace package body tabEMPLOYEES_TEST is


  ---------------------------------------------------------------
  procedure SEL_T
  -- Выборка работника
   is
    v_id        EMPLOYEES.EMPLOYEE_ID%type;
    v_row       EMPLOYEES%rowtype;
    v_forUpdate boolean := true;
    v_rase      boolean := true;
  begin
    dbms_output.put_line('Выбор работника 108'); --< Для отладки

    v_id        := 108;
    v_rase      := true;
    v_forUpdate := false;

    tabEMPLOYEES.sel(p_id        => v_id
                    ,p_row       => v_row
                    ,p_forUpdate => v_forUpdate
                    ,p_rase      => v_rase);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);

  end;

  ---------------------------------------------------------------
  procedure INS_T
  -- Добавление карточки работника
   is
    v_id  EMPLOYEES.EMPLOYEE_ID%type;
    v_row EMPLOYEES%rowtype;
  begin
    dbms_output.put_line('Вставка работника из копии'); --< Для отладки

    v_id := 108;

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);

    v_row.employee_id := EMPLOYEES_SEQ.nextval;
    v_row.email       := v_row.email || '_2';

    dbms_output.put_line('Inserting...'); --< Для отладки
    tabEMPLOYEES.ins(p_row => v_row, p_update => false);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.email = ' || v_row.email);
  end;


  ---------------------------------------------------------------
  procedure INS_T2
  -- Добавление карточки работника 2
   is
    v_row EMPLOYEES%rowtype;
  begin
    dbms_output.put_line('Вставка работника по данным'); --< Для отладки

    --v_row.employee_id     := '';
    --v_row.employee_id := EMPLOYEES_SEQ.nextval;
    v_row.first_name      := 'John';
    v_row.last_name       := 'Connor';
    v_row.email           := 'abc@def.com';
    v_row.phone_number    := '+79502096411';
    v_row.hire_date       := trunc(sysdate);
    v_row.job_id          := 'FI_MGR';
    v_row.salary          := '12008';
    v_row.commission_pct  := '';
    v_row.manager_id      := '101';
    v_row.department_id   := '100';

    tabEMPLOYEES.ins(p_row => v_row, p_update => false);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);
    dbms_output.put_line('v_row.email = ' || v_row.email);
  end;

  ---------------------------------------------------------------
  procedure UPD_T
  -- обновление карточки работника
   is
    v_id  EMPLOYEES.EMPLOYEE_ID%type;
    v_row EMPLOYEES%rowtype;
  begin
    dbms_output.put_line('Обновление карточки работника, ЗП + 10 000'); --< Для отладки

    v_id := 108;
    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);

    v_row.salary       := v_row.salary + 10000;

    dbms_output.put_line('Updating...'); --< Для отладки
    tabEMPLOYEES.upd(p_row => v_row, p_insert => false);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);
  end;


  ---------------------------------------------------------------
  procedure EXIST_T
  -- Есть ли работник
   is
    v_id  EMPLOYEES.EMPLOYEE_ID%type;
    v_res boolean;
  begin
    dbms_output.put_line('Проверка, есть ли работник - Есть'); --< Для отладки

    v_id := 108;
    v_res := tabEMPLOYEES.exist(p_id => v_id);

    dbms_output.put_line('v_id = ' || v_id);
    dbms_output.put_line('EMPLOYEE ' || case when v_res then 'exists' else 'not exists' end);
  end;

  ---------------------------------------------------------------
  procedure EXIST_T2
  -- Есть ли работник 2
   is
    v_id  EMPLOYEES.EMPLOYEE_ID%type;
    v_res boolean;
  begin
    dbms_output.put_line('Проверка, есть ли работник - Нет'); --< Для отладки

    v_id := -108;
    v_res := tabEMPLOYEES.exist(p_id => v_id);

    dbms_output.put_line('v_id = ' || v_id);
    dbms_output.put_line('EMPLOYEE ' || case when v_res then 'exists' else 'not exists' end);
  end;


  ---------------------------------------------------------------
  procedure DEL_T
  -- Удаление карточки работника
   is
    v_row EMPLOYEES%rowtype;
  begin
    dbms_output.put_line('Удаление карточки работника'); --< Для отладки

    v_row.employee_id := EMPLOYEES_SEQ.nextval;
    v_row.first_name      := 'John';
    v_row.last_name       := 'Connor2';
    v_row.email           := 'abc2@def.com';
    v_row.phone_number    := '+79502096411';
    v_row.hire_date       := trunc(sysdate);
    v_row.job_id          := 'FI_MGR';
    v_row.salary          := '12008';
    v_row.commission_pct  := '';
    v_row.manager_id      := '101';
    v_row.department_id   := '100';

    tabEMPLOYEES.ins(p_row => v_row, p_update => false);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.last_name = ' || v_row.last_name);
    dbms_output.put_line('v_row.email = ' || v_row.email);


    tabEMPLOYEES.del(p_id => v_row.employee_id);
    dbms_output.put_line('Deleting v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('EMPLOYEE ' || case when tabEMPLOYEES.exist(p_id => v_row.employee_id) then 'exists' else 'not exists' end);

  end;



  ---------------------------------------------------------------
  procedure runall
  -- Все тесты
   is
  begin
    begin
      -- exception block


      dbms_output.put_line('');
      dbms_output.put_line('Тест - INS_T2');
      INS_T2;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - EXIST_T');
      EXIST_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - EXIST_T2');
      EXIST_T2;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - SEL_T');
      SEL_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - UPD_T');
      UPD_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - INS_T');
      INS_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - DEL_T');
      DEL_T;

    exception
      when others then
        dbms_output.put_line(utl_lms.format_message('ERROR - (%s): %s'
                                                   ,TO_CHAR(sqlcode)
                                                   ,TO_CHAR(sqlerrm)));
        raise;
    end;
  end;

end tabEMPLOYEES_test;
/

prompt
prompt Creating trigger SECURE_EMPLOYEES
prompt =================================
prompt
CREATE OR REPLACE TRIGGER secure_employees
  BEFORE INSERT OR UPDATE OR DELETE ON employees
BEGIN
  --secure_dml;
  null;
END secure_employees;
/

prompt
prompt Creating trigger TR_EMPLOYEES_BIU
prompt =================================
prompt
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

prompt
prompt Creating trigger TR_MESSAGES_BI_SEQ
prompt ===================================
prompt
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

prompt
prompt Creating trigger UPDATE_JOB_HISTORY
prompt ===================================
prompt
CREATE OR REPLACE TRIGGER update_job_history
  AFTER UPDATE OF job_id, department_id ON employees
  FOR EACH ROW
BEGIN
  /*add_job_history(:old.employee_id, :old.hire_date, sysdate,
                  :old.job_id, :old.department_id);
                  /**/
  null;
END;
/


prompt Done
spool off
set define on
