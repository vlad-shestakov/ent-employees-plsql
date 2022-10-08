-- TestLog Тестирование пакетов PLSQL_ENT_EMPLOYEES

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
-- Тестирование блокировки
/
-- Выполнить в двух разных сессиях обновление без коммита
begin
  tabEMPLOYEES_TEST.UPD_T;
end; 
-- Вторая сессия зависнет в ожидания коммита первой
-- В первой сессии сделать коммит
-- Во второй сессии появится ошибка
-- ORA-20000: Ошибка обновления записи по блокировке

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
