prompt PL/SQL Developer Export User Objects for user HR@169.254.218.131/XEPDB1
prompt Created by User on 10 Октябрь 2022 г.
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
  upd_counter    INTEGER not null,
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
  id        NUMBER not null,
  msg_text  VARCHAR2(2000),
  msg_type  VARCHAR2(10) not null,
  dest_addr VARCHAR2(150),
  msg_state NUMBER(4) default 0 not null
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
alter table MESSAGES
  add constraint CHK_MESSAGES_STATE
  check (MSG_STATE in (-1, 0, 1));
alter table MESSAGES
  add constraint CHK_MESSAGES_TYPE
  check (MSG_TYPE in ('email', 'sms'));

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
start with 947
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
start with 823
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
prompt Creating view VW_EMPLOYEES
prompt ==========================
prompt
create or replace force view vw_employees as
select -- Данные о сотруднике, руководителе
       em.employee_id
      ,em.first_name
      ,em.last_name
       --,em.first_name || ' ' || em.last_name as full_name
      ,em.job_id
      ,j.job_title
      ,em.department_id
      ,d.department_name
      ,em.salary
      ,em.commission_pct
      ,em.manager_id
      ,jmg.job_title     as mgr_job_title
      ,emg.first_name    as mgr_first_name
      ,emg.last_name     as mgr_last_name
       --,emg.first_name || ' ' || emg.last_name as mgr_full_name
      ,em.email
      ,em.phone_number
      ,emg.email         as mgr_email
      ,emg.phone_number  as mgr_phone_number
      ,em.hire_date
      ,em.upd_counter
      ,em.crt_user
      ,em.crt_date
      ,em.upd_user
      ,em.upd_date
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
   --and em.employee_id in 107
;

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
  -- КОНСТАНТЫ

    С_MSG_TYPE_EMAIL   CONSTANT messages.msg_type%type := 'email';
    С_MSG_TYPE_SMS     CONSTANT messages.msg_type%type := 'sms';
    С_MSG_TYPE_DEF     CONSTANT messages.msg_type%type := С_MSG_TYPE_EMAIL
    -- Тип отправляемого сообщения по-умолчанию
    ;


  ---------------------------------------------------------------
  -- КУРСОРЫ


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
  procedure JOB_SEL
  (
    p_job_id    in  JOBS.job_id %type
   ,p_row       out JOBS%rowtype
   ,p_raise     in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы JOBS

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы JOBS
      p_row        - Возвращаемая запись JOBS
      p_raise
        true       - происходит вызов исключений
        false      - исключения игнорируются

  /**/
  ;

  ---------------------------------------------------------------
  procedure DEPARTMENTS_SEL
  (
    p_department_id  in  DEPARTMENTS.department_id%type
   ,p_row            out DEPARTMENTS%rowtype
   ,p_raise          in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы DEPARTMENTS

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы DEPARTMENTS
      p_row        - Возвращаемая запись DEPARTMENTS
      p_raise
        true       - происходит вызов исключений
        false      - исключения игнорируются

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
  procedure SEL
  (
    p_id        in  employees.employee_id%type
   ,p_row       out employees%rowtype
   ,p_forUpdate in  boolean := false
   ,p_raise     in  boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
      p_row        - Возвращаемая запись EMPLOYEES
      p_forUpdate
        true     - выполняется SELECT … FOR UPDATE
        false    - обычный SELECT
      p_raise
        true     - происходит вызов исключений
        false    - исключения игнорируются

    /**/
  ;

  ---------------------------------------------------------------
  procedure INS
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
  procedure UPD
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
  procedure DEL
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
  function EXIST
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
prompt Creating package ENTEMPLOYEES
prompt =============================
prompt
create or replace package entEMPLOYEES is

  -- Created : 07.10.2022 2:12:18
  -- Purpose : Обработка бизнес-логики объектов из таблицы EMPLOYEES

  -- 07.10.2022 VSHESTAKOV - v01

  ---------------------------------------------------------------
  -- КОНСТАНТЫ


    С_EMP_SALARY_PAYRISE_KOEFF   CONSTANT number(8,2) := 1.1
    -- Коэффициент повышения оклада сотрудника
    ;
    С_EMP_MAX_SALARY   CONSTANT employees.salary%type := 350000
    -- Максимальный оклад сотрудника
    ;

    -- Текст сообщения для нового работника
    C_MSG_EMPLT_GREET_EMP_TXT constant messages.msg_text%type :=  'Уважаемый %s %s! Вы приняты в качестве %s в подразделение %s.';
    C_MSG_EMPLT_GREET_EMP_TXT2 constant messages.msg_text%type :=  'Ваш руководитель: %s %s %s.';
    -- Уважаемый < FIRST_NAME > < LAST_NAME >! Вы приняты в качестве < JOB_TITLE > в подразделение < DEPARTMENT_NAME >.
    -- Ваш руководитель: < JOB_TITLE > < FIRST_NAME > < LAST_NAME >”.


    -- Текст сообщения для руководителя нового работника
    C_MSG_EMPLT_GREET_MGR_TXT constant messages.msg_text%type :=  'Уважаемый %s %s! В ваше подразделение принят новый сотрудник %s %s в должности %s с окладом %s.';
    -- Уважаемый < FIRST_NAME > < LAST_NAME >! В ваше подразделение принят новый сотрудник < FIRST_NAME > < LAST_NAME > в должности < JOB_TITLE > с окладом < SALARY >.


    -- Текст сообщения для руководителя нового работника
    C_MSG_LEAVE_MGR_TXT constant messages.msg_text%type :=  'Уважаемый %s %s! Из вашего подразделения уволен сотрудник %s %s с должности %s.';
    -- Уважаемый < FIRST_NAME > < LAST_NAME >! Из вашего подразделения уволен сотрудник < FIRST_NAME > < LAST_NAME > с должности < JOB_TITLE >.”


    -- Текст сообщения. Повышение зп сотрудника для руководителя
    C_MSG_PAYRISE_MGR_TXT constant messages.msg_text%type :=  'Уважаемый %s %s! Вашему сотруднику %s %s изменен оклад с %s до %s.';
    -- Уважаемый < FIRST_NAME > < LAST_NAME >! Вашему сотруднику < FIRST_NAME > < LAST_NAME > изменен оклад с < SALARY old > до < SALARY new >.

  ---------------------------------------------------------------
  -- ОШИБКИ

    -- Ошибка  -20101 Не заполнены обязательные параметры (%s)
    EX_EMPLOYMENT_WR_PARAMS     exception;
    EX_EMPLOYMENT_WR_PARAMS_MSG constant varchar2(400) := 'Не заполнены обязательные параметры (%s)';
    pragma exception_init(EX_EMPLOYMENT_WR_PARAMS, -20101);


    -- Ошибка  -20102 Превышение максимального оклада сотрудника
    EX_PAYRISE_EMP_SALARY_EXCCESS     exception;
    EX_PAYRISE_EMP_SALARY_EXCCESS_MSG constant varchar2(400) := 'Превышение максимального оклада сотрудника (%s)';
    pragma exception_init(EX_PAYRISE_EMP_SALARY_EXCCESS, -20102);


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
   ,p_salary                 in employees.salary%type         default null
   ,p_commission_pct         in employees.commission_pct%type default null
   ,p_msg_type               in messages.msg_type%type        default tabEMPLOYEES.С_MSG_TYPE_EMAIL -- Тип сообщения для отправки sms / email
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

  ---------------------------------------------------------------
  procedure PAYRISE
  (
    p_employee_id            in employees.employee_id%type
   ,p_salary                 in employees.salary%type default null
   ,p_msg_type               in messages.msg_type%type := tabEMPLOYEES.С_MSG_TYPE_EMAIL -- Тип сообщения для отправки sms / email
  )
  /*
    Процедура реализует повышение оклада сотруднику

    - Если SALARY пусто, необходимо повысить оклад на 10%
    - Создать новое сообщение для руководителя сотрудника
    ПАРАМЕТРЫ
       p_employee_id      - Код сотрудника
      ,p_salary           - Новый оклад (не обязательно)
      ,p_msg_type         - Тип сообщения для отправки sms / email

    ИСКЛЮЧЕНИЯ
      В случае превышения максимального оклада по должности (MAX_SALARY)
  /**/
  ;

  ---------------------------------------------------------------
  procedure LEAVE
  (
    p_employee_id            in employees.employee_id%type
   ,p_msg_type               in messages.msg_type%type      := tabEMPLOYEES.С_MSG_TYPE_EMAIL -- Тип сообщения для отправки sms / email
  )
  /*
    Процедура реализует увольнение сотрудника
    - Для увольнения в таблице EMPLOYEES чистим значение поля DEPARTMENT_ID.
    - Создать новое сообщение для руководителя сотрудника

    ПАРАМЕТРЫ
       p_employee_id      - Код сотрудника
      ,p_msg_type         - Тип сообщения для отправки sms / email

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
  procedure UPD_T
  -- обновление карточки работника
  ;
  
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
  procedure EMPLOYMENT
  (
    p_first_name             in employees.first_name%type
   ,p_last_name              in employees.last_name%type
   ,p_email                  in employees.email%type
   ,p_phone_number           in employees.phone_number%type
   ,p_job_id                 in employees.job_id%type
   ,p_department_id          in employees.department_id%type
   ,p_manager_id             in employees.manager_id%type
   ,p_salary                 in employees.salary%type         default null
   ,p_commission_pct         in employees.commission_pct%type default null
   ,p_msg_type               in messages.msg_type%type        default tabEMPLOYEES.С_MSG_TYPE_EMAIL -- Тип сообщения для отправки sms / email
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
    v_row_mgr    EMPLOYEES%rowtype;
    v_job        JOBS%rowtype;
    v_job_mgr    JOBS%rowtype;
    v_department DEPARTMENTS%rowtype;
    v_err        varchar2(250) := '';
    v_message    messages.msg_text%type;
    v_msg_addr   messages.dest_addr%type;
  begin

    -- Проверка на обязательные параметры
    if p_department_id is null then
       v_err := 'p_department_id';
    end if;
    if p_department_id is null then
       v_err := v_err || ', p_job_id';
    end if;
    v_err := ltrim(v_err, ', ');

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
      for rec in tabEMPLOYEES.CUR_AVG_DEPT_SALARY(p_department_id, p_job_id)
      loop
        v_row.salary          := nvl(p_salary, rec.avg_dept_salary);
        v_row.commission_pct  := nvl(p_commission_pct, rec.avg_dept_commission_pct);
      end loop;
    end if;

    -- Создаем сотрудика
    tabEMPLOYEES.INS(p_row => v_row);

    -- Должность сотрудника
    tabEMPLOYEES.JOB_SEL(p_job_id => v_row.job_id,
                         p_row    => v_job,
                         p_raise  => false);

    -- Отдел сотрудника
    tabEMPLOYEES.DEPARTMENTS_SEL(p_department_id => v_row.department_id,
                                 p_row           => v_department,
                                 p_raise         => false);

    -- Получаем данные руководителя
    tabEMPLOYEES.SEL(p_id   => v_row.manager_id,
                     p_row  => v_row_mgr);

    -- Отправляем почту руководителю сотрудника
    if v_row.manager_id is not null then
      v_message := utl_lms.format_message(
                           entEMPLOYEES.C_MSG_EMPLT_GREET_MGR_TXT
                           --'Уважаемый %s %s! В ваше подразделение принят новый сотрудник %s %s в должности %s с окладом %s'
                           , TO_CHAR(v_row_mgr.first_name)
                           , TO_CHAR(v_row_mgr.last_name)
                           , TO_CHAR(v_row.first_name)
                           , TO_CHAR(v_row.last_name)
                           , TO_CHAR(v_job.job_title)
                           , TO_CHAR(v_row.salary)
                         );
      case p_msg_type
        when tabEMPLOYEES.С_MSG_TYPE_EMAIL
        then v_msg_addr := v_row_mgr.email;
        else v_msg_addr := v_row_mgr.phone_number;
      end case;

      tabEMPLOYEES.MESSAGE_INS(
          p_msg_text  => v_message
         ,p_msg_type  => p_msg_type
         ,p_dest_addr => v_msg_addr);


    end if;

    -- Отправляем почту новому сотруднику
    v_message := utl_lms.format_message(
                         entEMPLOYEES.C_MSG_EMPLT_GREET_EMP_TXT
                         --'Уважаемый %s %s! Вы приняты в качестве %s в подразделение %s.'
                         , TO_CHAR(v_row.first_name)
                         , TO_CHAR(v_row.last_name)
                         , TO_CHAR(v_job.job_title)
                         , TO_CHAR(v_department.department_name)
                       ) ;

    -- Если есть руководитель
    if v_row.manager_id is not null then
      -- Должность руководителя
      tabEMPLOYEES.JOB_SEL(p_job_id => v_row_mgr.job_id,
                           p_row    => v_job_mgr,
                           p_raise  => false);

      v_message := v_message || ' ' || utl_lms.format_message(
                             entEMPLOYEES.C_MSG_EMPLT_GREET_EMP_TXT2
                             --'Ваш руководитель: %s %s %s.'
                             , TO_CHAR(v_job_mgr.job_title)
                             , TO_CHAR(v_row_mgr.first_name)
                             , TO_CHAR(v_row_mgr.last_name)
                           );
    end if;

    case p_msg_type
      when tabEMPLOYEES.С_MSG_TYPE_EMAIL
      then v_msg_addr := v_row.email;
      else v_msg_addr := v_row.phone_number;
    end case;

    tabEMPLOYEES.MESSAGE_INS(
        p_msg_text  => v_message
       ,p_msg_type  => p_msg_type
       ,p_dest_addr => v_msg_addr);

  end EMPLOYMENT;


  ---------------------------------------------------------------
  procedure PAYRISE
  (
    p_employee_id            in employees.employee_id%type
   ,p_salary                 in employees.salary%type default null
   ,p_msg_type               in messages.msg_type%type := tabEMPLOYEES.С_MSG_TYPE_EMAIL -- Тип сообщения для отправки sms / email
  )
  /*
    Процедура реализует повышение оклада сотруднику

    - Если SALARY пусто, необходимо повысить оклад на 10%
    - Создать новое сообщение для руководителя сотрудника
    ПАРАМЕТРЫ
       p_employee_id      - Код сотрудника
      ,p_salary           - Новый оклад (не обязательно)
      ,p_msg_type         - Тип сообщения для отправки sms / email

    ИСКЛЮЧЕНИЯ
      В случае превышения максимального оклада по должности (MAX_SALARY)
  /**/
  is
    v_salary_old  employees.salary%type;
    v_salary      employees.salary%type;
    v_row         employees%rowtype;
    v_row_mgr     employees%rowtype;
    v_job         jobs%rowtype;
    v_message     messages.msg_text%type;
    v_msg_addr    messages.dest_addr%type;
  begin

    -- Получаем данные сотрудника / Для обновления
    tabEMPLOYEES.SEL(p_id   => p_employee_id,
                     p_row  => v_row,
                     p_forUpdate => true);

    -- Должность сотрудника
    tabEMPLOYEES.JOB_SEL(p_job_id => v_row.job_id,
                         p_row    => v_job,
                         p_raise  => false);

    -- Получаем данные руководителя
    tabEMPLOYEES.SEL(p_id   => v_row.manager_id,
                     p_row  => v_row_mgr);


      case p_msg_type
        when tabEMPLOYEES.С_MSG_TYPE_EMAIL
        then v_msg_addr := v_row_mgr.email;
        else v_msg_addr := v_row_mgr.phone_number;
      end case;


    v_salary_old := v_row.salary;
    v_salary := round(nvl(p_salary, v_row.salary * entEMPLOYEES.С_EMP_SALARY_PAYRISE_KOEFF), 2);

    if v_salary > entEMPLOYEES.С_EMP_MAX_SALARY then
      RAISE_APPLICATION_ERROR(-20102, utl_lms.format_message(EX_PAYRISE_EMP_SALARY_EXCCESS_MSG, to_char(p_employee_id)));
    end if;

    -- Обновляем данные
    v_row.salary := v_salary;
    tabEMPLOYEES.UPD(p_row => v_row);

    -- Отправляем почту руководителю сотрудника
    if v_msg_addr is not null then

      v_message := utl_lms.format_message(
         entEMPLOYEES.C_MSG_PAYRISE_MGR_TXT
         --'Уважаемый %s %s! Вашему сотруднику %s %s увеличен оклад с %s до %s.'
         , TO_CHAR(v_row_mgr.first_name)
         , TO_CHAR(v_row_mgr.last_name)
         , TO_CHAR(v_row.first_name)
         , TO_CHAR(v_row.last_name)
         , TO_CHAR(v_salary_old)
         , TO_CHAR(v_salary)
       );

      tabEMPLOYEES.MESSAGE_INS(
          p_msg_text  => v_message
         ,p_msg_type  => p_msg_type
         ,p_dest_addr => v_msg_addr);

    end if;


  end PAYRISE;


  ---------------------------------------------------------------
  procedure LEAVE
  (
    p_employee_id            in employees.employee_id%type
   ,p_msg_type               in messages.msg_type%type      := tabEMPLOYEES.С_MSG_TYPE_EMAIL -- Тип сообщения для отправки sms / email
  )
  /*
    Процедура реализует увольнение сотрудника
    - Для увольнения в таблице EMPLOYEES чистим значение поля DEPARTMENT_ID.
    - Создать новое сообщение для руководителя сотрудника

    ПАРАМЕТРЫ
       p_employee_id      - Код сотрудника
      ,p_msg_type         - Тип сообщения для отправки sms / email

  /**/
  is
    v_row         employees%rowtype;
    v_row_mgr    EMPLOYEES%rowtype;
    v_job        JOBS%rowtype;
    v_message     messages.msg_text%type;
    v_mgr_addr     employees.email%type;
  begin


    -- Получаем данные сотрудника для обновления
    tabEMPLOYEES.SEL(p_id   => p_employee_id,
                     p_row  => v_row,
                     p_forUpdate => true);

    -- Должность сотрудника
    tabEMPLOYEES.JOB_SEL(p_job_id => v_row.job_id,
                         p_row    => v_job,
                         p_raise  => false);

    -- Получаем данные руководителя
    tabEMPLOYEES.SEL(p_id   => v_row.manager_id,
                     p_row  => v_row_mgr);

    v_message := utl_lms.format_message(
       entEMPLOYEES.C_MSG_LEAVE_MGR_TXT
       --'Уважаемый %s %s! Из вашего подразделения уволен сотрудник %s %s с должности %s.'
       , TO_CHAR(v_row_mgr.first_name)
       , TO_CHAR(v_row_mgr.last_name)
       , TO_CHAR(v_row.first_name)
       , TO_CHAR(v_row.last_name)
       , TO_CHAR(v_job.job_title)
     );

    case p_msg_type
      when tabEMPLOYEES.С_MSG_TYPE_EMAIL
      then v_mgr_addr := v_row_mgr.email;
      else v_mgr_addr := v_row_mgr.phone_number;
    end case;

    -- Увольняем сотрудника
    -- Обновляем данные
    v_row.department_id       := null;
    tabEMPLOYEES.UPD(p_row => v_row);

    -- Отправляем почту руководителю сотрудника
    if v_mgr_addr is not null then
      tabEMPLOYEES.MESSAGE_INS(
          p_msg_text  => v_message
         ,p_msg_type  => p_msg_type
         ,p_dest_addr => v_mgr_addr);
    end if;

  end LEAVE;

end entEMPLOYEES;
/

prompt
prompt Creating package body ENTEMPLOYEES_TEST
prompt =======================================
prompt
create or replace package body entEMPLOYEES_TEST is


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
                              p_email          => 'abc3',
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
         and e.email = 'abc3'
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
    v_msg_type    MESSAGES.msg_type%type := tabEMPLOYEES.С_MSG_TYPE_DEF;
    v_dest_addr   MESSAGES.dest_addr%type;
    v_dest_addr2  MESSAGES.dest_addr%type;
  begin
    dbms_output.put_line('Создает сотрудника, со ссылкой на менеджера (отправит два сообщения на почту), оклад и процент не указаны (усредненные)'); --< Для отладки

    v_dest_addr  := 'employment_t2_' || to_char(trunc(dbms_random.value(1,10000+1)));
    v_dest_addr2 := 'NGREENBE';

    dbms_output.put_line('Create EMP'); --< Для отладки
    entEmployees.employment(p_first_name     => 'John',
                            p_last_name      => 'employment_t2',
                            p_email          => v_dest_addr,
                            p_phone_number   => '+7804650',
                            p_job_id         => 'SA_REP',
                            p_department_id  => 80,
                            p_manager_id     => 108
                           --,p_salary         => ''
                           --,p_commission_pct => ''
                            );

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
    dbms_output.put_line('Find messages...'); --< Для отладки
    for rec in (--
                select m2.*
                  from MESSAGES m2
                 where 1=1
                   and (m2.msg_type, m2.dest_addr, m2.id) in (--
                                select m.msg_type, m.dest_addr, max(m.id)
                                  from MESSAGES m
                                 where 1=1
                                   and m.msg_type = v_msg_type
                                   and m.dest_addr in (v_dest_addr, v_dest_addr2)
                                 group by m.msg_type, m.dest_addr
                       )
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
    v_msg_type    MESSAGES.msg_type%type := tabEMPLOYEES.С_MSG_TYPE_DEF;
    v_dest_addr   MESSAGES.dest_addr%type;
    v_dest_addr2  MESSAGES.dest_addr%type;
  begin
    dbms_output.put_line('Создает сотрудника, без ссылки на менеджера (отправит только одно сообщение на почту), с фиксированным окладом'); --< Для отладки

    v_dest_addr  := 'employment_t3_' || to_char(trunc(dbms_random.value(1,10000+1)));
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
    dbms_output.put_line('Find messages...'); --< Для отладки
    for rec in (--
                select m2.*
                  from MESSAGES m2
                 where 1=1
                   and (m2.msg_type, m2.dest_addr, m2.id) in (--
                                select m.msg_type, m.dest_addr, max(m.id)
                                  from MESSAGES m
                                 where 1=1
                                   and m.msg_type = v_msg_type
                                   and m.dest_addr in (v_dest_addr, v_dest_addr2)
                                 group by m.msg_type, m.dest_addr
                       )
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
    v_msg_type    MESSAGES.msg_type%type := tabEMPLOYEES.С_MSG_TYPE_SMS;
    v_dest_addr   MESSAGES.dest_addr%type;
    v_dest_addr2  MESSAGES.dest_addr%type;
    v_dest_addr3  MESSAGES.dest_addr%type;
  begin
    dbms_output.put_line('Создает сотрудника со ссылкой на менеджера (отправит два сообщения SMS), с фиксированным окладом'); --< Для отладки

    v_dest_addr  := 'employment_t4_' || to_char(trunc(dbms_random.value(1,10000+1)));
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
    dbms_output.put_line('Find messages...'); --< Для отладки
    for rec in (--
                select m2.*
                  from MESSAGES m2
                 where 1=1
                   and (m2.msg_type, m2.dest_addr, m2.id) in (--
                                select m.msg_type, m.dest_addr, max(m.id)
                                  from MESSAGES m
                                 where 1=1
                                   and m.msg_type = v_msg_type
                                   and m.dest_addr in (v_dest_addr, v_dest_addr2, v_dest_addr3)
                                 group by m.msg_type, m.dest_addr
                       )
               )
    loop
      dbms_output.put_line('  id = ' || rec.id);
      dbms_output.put_line('  rec.p_msg_text = ' || rec.msg_text);
      dbms_output.put_line('  rec.msg_type  = ' || rec.msg_type);
      dbms_output.put_line('  rec.msg_state  = ' || rec.msg_state);
    end loop; -- Конец перебора

  end;


  ---------------------------------------------------------------
  procedure PAYRISE_T
  -- Повышаем оклад - ОШИБКА
  is
    v_id      employees.employee_id%type := 108;
  begin

    dbms_output.put_line('Повышает оклад сотрудника, возвращает ошибку, слишком большое повышение'); --< Для отладки
    dbms_output.put_line('Payrise EMP'); --< Для отладки

    begin -- exception block

      entEMPLOYEES.PAYRISE(p_employee_id => v_id
                          ,p_salary => entEMPLOYEES.С_EMP_MAX_SALARY + 10000);

    exception
      when entEMPLOYEES.EX_PAYRISE_EMP_SALARY_EXCCESS then
        dbms_output.put_line(utl_lms.format_message('OK ERROR - (%s): %s',TO_CHAR(sqlcode),TO_CHAR(sqlerrm)));
    end;

  end;

  ---------------------------------------------------------------
  procedure PAYRISE_T2
  -- Повышаем оклад
  is
    v_id        employees.employee_id%type := 108;
    v_row       EMPLOYEES%rowtype;
    v_msg_type  MESSAGES.msg_type%type     := 'email';
    v_dest_addr MESSAGES.dest_addr%type    := 'NKOCHHAR';
  begin

    dbms_output.put_line('Повышает оклад сотрудника по-умолчанию (+10%)'); --< Для отладки
    dbms_output.put_line('Payrise EMP'); --< Для отладки

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);
    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);

    entEMPLOYEES.PAYRISE(p_employee_id => v_id
                        --,p_salary => entEMPLOYEES.С_EMP_MAX_SALARY + 10000
                        );

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);
    dbms_output.put_line('NEW v_row.salary = ' || v_row.salary);

    -- Найдем сообщение
    dbms_output.put_line('Find messages...'); --< Для отладки
    for rec in (--
                select m2.*
                  from MESSAGES m2
                 where 1=1
                   and (m2.msg_type, m2.dest_addr, m2.id) in (--
                                select m.msg_type, m.dest_addr, max(m.id)
                                  from MESSAGES m
                                 where 1=1
                                   and m.msg_type = v_msg_type
                                   and m.dest_addr = v_dest_addr
                                 group by m.msg_type, m.dest_addr
                       )
               )
    loop
      dbms_output.put_line('  id = ' || rec.id);
      dbms_output.put_line('  rec.p_msg_text = ' || rec.msg_text);
      dbms_output.put_line('  rec.msg_state  = ' || rec.msg_state);
    end loop; -- Конец перебора

  end;

  ---------------------------------------------------------------
  procedure PAYRISE_T3
  -- Повышаем оклад
  is
    v_id        EMPLOYEES.employee_id%type := 108;
    v_row       EMPLOYEES%rowtype;
    v_msg_type  MESSAGES.msg_type%type     := 'email';
    v_dest_addr MESSAGES.dest_addr%type    := 'NKOCHHAR';
  begin

    dbms_output.put_line('Повышает оклад сотрудника фиксировано - 150 000'); --< Для отладки
    dbms_output.put_line('Payrise EMP'); --< Для отладки

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);
    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);

    entEMPLOYEES.PAYRISE(p_employee_id => v_id
                        ,p_salary => 150000
                        );

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);
    dbms_output.put_line('NEW v_row.salary = ' || v_row.salary);


    -- Найдем сообщение
    dbms_output.put_line('Find messages...'); --< Для отладки
    for rec in (--
                select m2.*
                  from MESSAGES m2
                 where 1=1
                   and (m2.msg_type, m2.dest_addr, m2.id) in (--
                                select m.msg_type, m.dest_addr, max(m.id)
                                  from MESSAGES m
                                 where 1=1
                                   and m.msg_type = v_msg_type
                                   and m.dest_addr = v_dest_addr
                                 group by m.msg_type, m.dest_addr
                       )
               )
    loop
      dbms_output.put_line('  id = ' || rec.id);
      dbms_output.put_line('  rec.p_msg_text = ' || rec.msg_text);
      dbms_output.put_line('  rec.msg_state  = ' || rec.msg_state);
    end loop; -- Конец перебора


  end;

  ---------------------------------------------------------------
  procedure LEAVE_T
  -- Увольняем сотрудника
  is
    v_id        EMPLOYEES.employee_id%type := 107;
    v_row       EMPLOYEES%rowtype;
    v_msg_type  MESSAGES.msg_type%type     := 'email';
    v_dest_addr MESSAGES.dest_addr%type    := 'AHUNOLD';
  begin


    dbms_output.put_line('Увольняет сотрудника'); --< Для отладки
    dbms_output.put_line('Leave EMP'); --< Для отладки

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);
    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.department_id = ' || v_row.department_id);

    entEMPLOYEES.LEAVE(p_employee_id => v_id);

    tabEMPLOYEES.sel(p_id => v_id, p_row => v_row);
    dbms_output.put_line('NEW v_row.department_id = ' || v_row.department_id);


    -- Найдем сообщение
    dbms_output.put_line('Find messages...'); --< Для отладки
    for rec in (--
                select m2.*
                  from MESSAGES m2
                 where 1=1
                   and (m2.msg_type, m2.dest_addr, m2.id) in (--
                                select m.msg_type, m.dest_addr, max(m.id)
                                  from MESSAGES m
                                 where 1=1
                                   and m.msg_type = v_msg_type
                                   and m.dest_addr = v_dest_addr
                                 group by m.msg_type, m.dest_addr
                       )
               )
    loop
      dbms_output.put_line('  id = ' || rec.id);
      dbms_output.put_line('  rec.p_msg_text = ' || rec.msg_text);
      dbms_output.put_line('  rec.msg_state  = ' || rec.msg_state);
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

      dbms_output.put_line('');
      dbms_output.put_line('Тест - PAYRISE_T');
      PAYRISE_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - PAYRISE_T2');
      PAYRISE_T2;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - PAYRISE_T3');
      PAYRISE_T3;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - LEAVE_T');
      LEAVE_T;

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
  procedure JOB_SEL
  (
    p_job_id    in  JOBS.job_id %type
   ,p_row       out JOBS%rowtype
   ,p_raise     in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы JOBS

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы JOBS
      p_row        - Возвращаемая запись JOBS
      p_raise
        true       - происходит вызов исключений
        false      - исключения игнорируются

  /**/
  is
  begin

    for rec in (--
                select j.*
                  from JOBS j
                 where j.job_id in p_job_id
                )
    loop
      p_row := rec;
    end loop;

  exception
    when others then
      -- Если флаг обработки исключений включен - обрабатываем
      if p_raise then
        raise;
      end if;
      -- Иначе - нет
  end JOB_SEL;

  ---------------------------------------------------------------
  procedure DEPARTMENTS_SEL
  (
    p_department_id  in  DEPARTMENTS.department_id%type
   ,p_row            out DEPARTMENTS%rowtype
   ,p_raise          in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы DEPARTMENTS

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы DEPARTMENTS
      p_row        - Возвращаемая запись DEPARTMENTS
      p_raise
        true       - происходит вызов исключений
        false      - исключения игнорируются

  /**/
  is
  begin

    for rec in (--
                select d.*
                  from DEPARTMENTS d
                 where d.department_id in p_department_id
                )
    loop
      p_row := rec;
    end loop;

  exception
    when others then
      -- Если флаг обработки исключений включен - обрабатываем
      if p_raise then
        raise;
      end if;
      -- Иначе - нет
  end DEPARTMENTS_SEL;

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
  procedure SEL
  (
    p_id        in EMPLOYEES.EMPLOYEE_ID%type
   ,p_row       out EMPLOYEES%rowtype
   ,p_forUpdate in boolean := false
   ,p_raise     in boolean := true
  )
  /*
    Процедура выполняет извлечение записи по ключу из таблицы EMPLOYEES

    ПАРАМЕТРЫ
      p_id         - Код записи для таблицы EMPLOYEES
      p_row        - Возвращаемая запись EMPLOYEES
      p_forUpdate
          true     - выполняется SELECT … FOR UPDATE
          false    - обычный SELECT
      p_raise
          true     - происходит вызов исключений
          false    - исключения игнорируются

    /**/
   is
    -- Выборка сотрудника без обновления
    cursor CUR_EMPLOYEES(c_employee_id in employees.employee_id%type) is
      select em.*
        from EMPLOYEES em
       where em.employee_id in c_employee_id;

    -- Выборка сотрудника для обновления
    cursor CUR_EMPLOYEES_FU(c_employee_id in employees.employee_id%type) is
      select em.*
        from EMPLOYEES em
       where em.employee_id in c_employee_id
         for update;

  begin

    if p_forUpdate then

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
      if p_raise then
        raise;
      end if;
      -- Иначе - нет
  end SEL;


  ---------------------------------------------------------------
  procedure INS
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
  end INS;


  ---------------------------------------------------------------
  procedure UPD
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

  end UPD;


  ---------------------------------------------------------------
  procedure DEL
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

  end DEL;

  ---------------------------------------------------------------
  function EXIST
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
    v_res number;
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

  end EXIST;

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
                    ,p_raise     => v_rase);

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
    v_row.email       := substr(v_row.email, 1, 20) || to_char(trunc(dbms_random.value(1,1000+1)));
    
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
    v_row.email           := 'mail'||to_char(trunc(dbms_random.value(1,100500+1)));
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
    dbms_output.put_line('v_row.upd_counter = ' || v_row.upd_counter);

    v_row.salary       := v_row.salary + 10000;

    dbms_output.put_line('Updating...'); --< Для отладки
    tabEMPLOYEES.upd(p_row => v_row, p_insert => false);

    dbms_output.put_line('v_row.employee_id = ' || v_row.employee_id);
    dbms_output.put_line('v_row.salary = ' || v_row.salary);
    dbms_output.put_line('v_row.upd_counter = ' || v_row.upd_counter);
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
    v_row.email           := 'abc2';
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
  procedure MESSAGE_INS_T
  -- Создаем сообщение в очереди
  is
    v_msg_type  MESSAGES.msg_type%type  := 'sms';
    v_dest_addr MESSAGES.dest_addr%type := 'message_ins_t';
  begin

    tabEMPLOYEES.MESSAGE_INS(
        p_msg_text  => 'Уважаемый Neena Kochhar! В ваше подразделение принят новый сотрудник Nancy Greenberg в должности Finance Manager с окладом 12008.'
       ,p_msg_type  => v_msg_type
       ,p_dest_addr => v_dest_addr);

    -- Найдем сообщение
    dbms_output.put_line('Find messages...'); --< Для отладки
    for rec in (--
                select m2.*
                  from MESSAGES m2
                 where 1=1
                   and m2.id in (--
                                select max(m.id)
                                  from MESSAGES m
                                 where 1=1
                                   and m.msg_type = v_msg_type
                                   and m.dest_addr = v_dest_addr
                       )
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
      dbms_output.put_line('Тест - SEL_T');
      SEL_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - INS_T2');
      INS_T2;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - INS_T');
      INS_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - EXIST_T');
      EXIST_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - EXIST_T2');
      EXIST_T2;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - UPD_T');
      UPD_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - DEL_T');
      DEL_T;

      dbms_output.put_line('');
      dbms_output.put_line('Тест - MESSAGE_INS_T');
      MESSAGE_INS_T;

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
  secure_dml;
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
  add_job_history(:old.employee_id, :old.hire_date, sysdate,
                  :old.job_id, :old.department_id);
END;
/


prompt Done
spool off
set define on
