-- TestLog Результат тестирования PLSQL_ENT_EMPLOYEES

-- 2022-10-08 VSHESTAKOV 
--------------------------------------------------------------- 
Тест - SEL_T
Выбор работника 108
v_row.employee_id = 108
v_row.last_name = Greenberg

Тест - INS_T2
Вставка работника по данным
v_row.employee_id = 
v_row.last_name = Connor
v_row.email = abc

Тест - INS_T
Вставка работника из копии
v_row.employee_id = 108
Inserting...
v_row.employee_id = 837
v_row.email = NGREENBE_2

Тест - EXIST_T
Проверка, есть ли работник - Есть
v_id = 108
EMPLOYEE exists

Тест - EXIST_T2
Проверка, есть ли работник - Нет
v_id = -108
EMPLOYEE not exists

Тест - UPD_T
Обновление карточки работника, ЗП + 10 000
v_row.employee_id = 108
v_row.last_name = Greenberg
v_row.salary = 12008
Updating...
v_row.employee_id = 108
v_row.salary = 22008

Тест - DEL_T
Удаление карточки работника
v_row.employee_id = 838
v_row.last_name = Connor2
v_row.email = abc2
Deleting v_row.employee_id = 838
EMPLOYEE not exists

Тест - MESSAGE_INS_T
Find messages...
id = 684
rec.p_msg_text = Уважаемый Neena Kochhar! В ваше подразделение принят новый сотрудник Nancy Greenberg в должности Finance Manager с окладом 12008.
rec.msg_state  = 0

Тест - EMPLOYMENT_T
Создает сотрудника, возвращает ошибку, не указана должность и департамент
Create EMP
OK ERROR - (-20101): ORA-20101: Не заполнены обязательные параметры (p_department_id, p_job_id)

Тест - EMPLOYMENT_T2
Создает сотрудника, со ссылкой на менеджера (отправит два сообщения на почту), оклад и процент не указаны (усредненные)
Create EMP
v_id = 839
v_row.last_name = employment_t2
v_row.email = employment_t2
v_row.manager_id = 108
v_row.salary = 8396.55
v_row.commission_pct = .21
Find messages...
  id = 685
  rec.p_msg_text = Уважаемый Nancy Greenberg! В ваше подразделение принят новый сотрудник John employment_t2 в должности Sales Representative с окладом 8396.55.
  rec.msg_type  = email
  rec.msg_state  = 0
  id = 686
  rec.p_msg_text = Уважаемый John employment_t2! Вы приняты в качестве Sales Representative в подразделение Sales. Ваш руководитель: Finance Manager Nancy Greenberg.
  rec.msg_type  = email
  rec.msg_state  = 0

Тест - EMPLOYMENT_T3
Создает сотрудника, без ссылки на менеджера (отправит только одно сообщение на почту), с фиксированным окладом
Create EMP
v_id = 840
v_row.last_name = employment_t3
v_row.email = employment_t3
v_row.manager_id = 
v_row.salary = 110000
v_row.commission_pct = .1
Find messages...
  id = 687
  rec.p_msg_text = Уважаемый John employment_t3! Вы приняты в качестве Sales Representative в подразделение Sales.
  rec.msg_type  = email
  rec.msg_state  = 0

Тест - EMPLOYMENT_T4
Создает сотрудника со ссылкой на менеджера (отправит два сообщения SMS), с фиксированным окладом
Create EMP
v_id = 841
v_row.last_name = employment_t4
v_row.email = employment_t4
v_row.manager_id = 108
v_row.salary = 110000
v_row.commission_pct = .1
Find messages...
  id = 688
  rec.p_msg_text = Уважаемый Nancy Greenberg! В ваше подразделение принят новый сотрудник John employment_t4 в должности Sales Representative с окладом 110000.
  rec.msg_type  = sms
  rec.msg_state  = 0
  id = 689
  rec.p_msg_text = Уважаемый John employment_t4! Вы приняты в качестве Sales Representative в подразделение Sales. Ваш руководитель: Finance Manager Nancy Greenberg.
  rec.msg_type  = sms
  rec.msg_state  = 0

Тест - PAYRISE_T
Повышает оклад сотрудника, возвращает ошибку, слишком большое повышение
Payrise EMP
OK ERROR - (-20102): ORA-20102: Превышение максимального оклада сотрудника (108)

Тест - PAYRISE_T2
Повышает оклад сотрудника по-умолчанию (+10%)
Payrise EMP
v_row.employee_id = 108
v_row.salary = 22008
NEW v_row.salary = 24208.8
Find messages...
  id = 690
  rec.p_msg_text = Уважаемый Neena Kochhar! Вашему сотруднику Nancy Greenberg увеличен оклад с 22008 до 24208.8.
  rec.msg_state  = 0

Тест - PAYRISE_T3
Повышает оклад сотрудника фиксировано - 150 000
Payrise EMP
v_row.employee_id = 108
v_row.salary = 24208.8
NEW v_row.salary = 150000
Find messages...
  id = 691
  rec.p_msg_text = Уважаемый Neena Kochhar! Вашему сотруднику Nancy Greenberg увеличен оклад с 24208.8 до 150000.
  rec.msg_state  = 0

Тест - LEAVE_T
Увольняет сотрудника
Leave EMP
v_row.employee_id = 107
v_row.department_id = 60
NEW v_row.department_id = 
Find messages...
  id = 692
  rec.p_msg_text = Уважаемый Alexander Hunold! Из вашего подразделения уволен сотрудник Diana Lorentz с должности Programmer.
  rec.msg_state  = 0
