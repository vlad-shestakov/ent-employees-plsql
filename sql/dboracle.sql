prompt PL/SQL Developer Export User Objects for user HR@169.254.218.131/XEPDB1
prompt Created by User on 7 Октябрь 2022 г.
set define off
spool dboracle.log

prompt
prompt Creating table REGIONS
prompt ======================
prompt
@@regions.tab
prompt
prompt Creating table COUNTRIES
prompt ========================
prompt
@@countries.tab
prompt
prompt Creating table JOBS
prompt ===================
prompt
@@jobs.tab
prompt
prompt Creating table DEPARTMENTS
prompt ==========================
prompt
@@departments.tab
prompt
prompt Creating table EMPLOYEES
prompt ========================
prompt
@@employees.tab
prompt
prompt Creating table LOCATIONS
prompt ========================
prompt
@@locations.tab
prompt
prompt Creating table JOB_HISTORY
prompt ==========================
prompt
@@job_history.tab
prompt
prompt Creating table MESSAGES
prompt =======================
prompt
@@messages.tab
prompt
prompt Creating sequence DEPARTMENTS_SEQ
prompt =================================
prompt
@@departments_seq.seq
prompt
prompt Creating sequence EMPLOYEES_SEQ
prompt ===============================
prompt
@@employees_seq.seq
prompt
prompt Creating sequence LOCATIONS_SEQ
prompt ===============================
prompt
@@locations_seq.seq
prompt
prompt Creating sequence MESSAGES_SEQ
prompt ==============================
prompt
@@messages_seq.seq
prompt
prompt Creating view EMP_DETAILS_VIEW
prompt ==============================
prompt
@@emp_details_view.vw
prompt
prompt Creating package ENTEMPLOYEES
prompt =============================
prompt
@@entemployees.sql
prompt
prompt Creating package ENTEMPLOYEES_TEST
prompt ==================================
prompt
@@entemployees_test.sql
prompt
prompt Creating package TABEMPLOYEES
prompt =============================
prompt
@@tabemployees.sql
prompt
prompt Creating package TABEMPLOYEES_TEST
prompt ==================================
prompt
@@tabemployees_test.sql
prompt
prompt Creating procedure ADD_JOB_HISTORY
prompt ==================================
prompt
@@add_job_history.sql
prompt
prompt Creating procedure SECURE_DML
prompt =============================
prompt
@@secure_dml.sql
prompt
prompt Creating trigger SECURE_EMPLOYEES
prompt =================================
prompt
@@secure_employees.sql
prompt
prompt Creating trigger TR_EMPLOYEES_BIU
prompt =================================
prompt
@@tr_employees_biu.sql
prompt
prompt Creating trigger TR_MESSAGES_BI_SEQ
prompt ===================================
prompt
@@tr_messages_bi_seq.sql
prompt
prompt Creating trigger UPDATE_JOB_HISTORY
prompt ===================================
prompt
@@update_job_history.sql

prompt Done
spool off
set define on
