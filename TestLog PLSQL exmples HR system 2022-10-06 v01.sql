-- TestLog PLSQL exmples HR system 2022-10-06 v01

-- Тесты для задачи


begin
  rollback;
  -- Все тесты
  tabEMPLOYEES_TEST.runall;
end; 

/


begin
  rollback;
  -- Выполнить все тесты
  entEMPLOYEES_TEST.runall;
end; 

--------------------------------------------------------------- 
/
select *
  from MESSAGES
 where 1=1
 order by 1 desc
;/**/ 


select *
  from EMPLOYEES
 where 1=1
 order by 1 desc
;/**/ 
