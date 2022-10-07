-- TestSql PLSQL_ENT_EMPLOYEES

---------------------------------------------------------------
-- Инициализация схемы
alter trigger SECURE_EMPLOYEES disable;
alter trigger UPDATE_JOB_HISTORY disable;


--------------------------------------------------------------- 
-- Тесты для всех задач 
/
begin
  rollback;
  -- Все тесты
  tabEMPLOYEES_TEST.runall;
  entEMPLOYEES_TEST.runall;
end; 
/

--------------------------------------------------------------- 
/
select t.*, rowid
  from MESSAGES t
 where 1 = 1
 order by 1 desc
;/**/ 

select *
  from EMPLOYEES
 where 1=1
 order by 1 desc
;/**/ 
