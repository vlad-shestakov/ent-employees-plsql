# PL/SQL проект PLSQL_ENT_EMPLOYEES

Тестовое задание PL/SQL

## Состав проекта
  
|             Объекты БД        |                                              |                        |
|-------------------------------|------------------------------------------------------------------------|--------------------------|
| Задача          | [_TASK.md                       ](./_TASK.md                    )|                          |
| Запросы по проекту      | <a href="./SqlLog Запросы по проекту PLSQL_ENT_EMPLOYEES.sql">SqlLog Запросы по проекту PLSQL_ENT_EMPLOYEES.sql</a>|  |
| Скрипт тестирования пакетов     | <a href="./TestLog Тестирование пакетов PLSQL_ENT_EMPLOYEES.sql">TestLog Тестирование пакетов PLSQL_ENT_EMPLOYEES.sql</a>|  |
| Объекты БД          | [sql/                       ](./sql/                      )|                          |
| Объекты схемы         | [sql/_ALL_SCHEMA_EXPORT.sql     ](./sql/_ALL_SCHEMA_EXPORT.sql    )| Все объекты схемы        |
| Данные схемы          | [sql/_ALL_SCHEMA_DATA.sql     ](./sql/_ALL_SCHEMA_DATA.sql    )| Все данные схемы         |
| Таблица EMPLOYEES       | [sql/employees.tab        ](./sql/employees.tab         )| Доработанная таблица EMPLOYEES    |
| Таблица MESSAGES        | [sql/messages.tab         ](./sql/messages.tab        )|                          |
| Вью VW_EMPLOYEES        | [sql/vw_employees.vw        ](./sql/vw_employees.vw       )| Вью EMPLOYEES      |
| Сиквенс MESSAGES_SEQ      | [sql/messages_seq.seq       ](./sql/messages_seq.seq      )|                          |
| Триггер TR_EMPLOYEES_BIU    | [sql/tr_employees_biu.sql     ](./sql/tr_employees_biu.sql    )|                          |
| Триггер TR_MESSAGES_BI_SEQ  | [sql/tr_messages_bi_seq.sql     ](./sql/tr_messages_bi_seq.sql    )|                          |
| Пакет tabEMPLOYEES      | [sql/tabemployees.sql       ](./sql/tabemployees.sql      )| Управление данными EMPLOYEES      |
| Пакет tabEMPLOYEES_TEST     | [sql/tabemployees_test.sql    ](./sql/tabemployees_test.sql     )| Тестирование пакета      |
| Пакет entEMPLOYEES      | [sql/entemployees.sql       ](./sql/entemployees.sql      )| Бизнес-функции      |
| Пакет entEMPLOYEES_TEST     | [sql/entemployees_test.sql    ](./sql/entemployees_test.sql     )| Тестирование пакета    |
 
## Инициализация

* Развернуть схему [sql/_ALL_SCHEMA_EXPORT.sql    ](./sql/_ALL_SCHEMA_EXPORT.sql    )
* Развернуть данные [sql/_ALL_SCHEMA_DATA.sql     ](./sql/_ALL_SCHEMA_DATA.sql    )
* Запустить пакет с тестами - <a href="./TestLog Тестирование пакетов PLSQL_ENT_EMPLOYEES.sql">TestLog Тестирование пакетов PLSQL_ENT_EMPLOYEES.sql</a>

## Задача

Разработать пакеты PL/SQL, которые будут обеспечивать интерфейс, скрывающий низкоуровневые функции работы с БД для внешнего приложения. 

За основу берем стандартную учебную схему Oracle - HR


### Создать новую таблицу MESSAGES
которая будет содержать очередь сообщений для обработки внешней системой. В таблицу добавить колонки: 
-  ID - первичный ключ, идентификатор сообщения в очереди, должен присваиваться автоматически 
-  MSG_TEXT - будет содержать текст сообщения 
-  MSG_TYPE – текстовое значение типа сообщения (email, sms и т.п.) 
-  DEST_ADDR – адрес получателя сообщения (email, номер телефона) 
-  MSG_STATE - числовой статус обработки сообщения внешней системой (0 - добавлено в очередь, 1 - успешно отправлено, -1 - отправлено с ошибкой) 
 

### В таблицу EMPLOYEES добавить дополнительные колонки:  
-  UPD_COUNTER числового типа для счетчика оптимистичной блокировки 
-  CRT_USER текстового типа для хранения имени пользователя, создавшего запись в таблице 
-  CRT_DATE для хранения даты создания записи 
-  UPD_USER текстового типа для хранения имени пользователя, обновившего запись 
-  UPD_DATE для хранения даты обновления данных 

### Триггеры 
Для обработки событий DML таблицы EMPLOYEES создать триггер (или обновить существующий в учебной схеме HR), который должен добавлять/обновлять указанные выше поля в таблице. В качестве имени пользователя использовать имя текущего пользователя БД. 

При необходимости, создать триггер для определения новых значений первичного ключа в таблице MESSAGES. 

### Создать пакет tabEMPLOYEES 
обработки операций чтения/записи данных в таблицу EMPLOYEES 

Пакет должен содержать следующие процедуры: 

#### PROCEDURE sel (p_id IN EMPLOYEES.EMPLOYEE_ID%TYPE, p_row OUT EMPLOYEES%ROWTYPE, p_forUpdate IN BOOLEAN := FALSE, p_raise IN BOOLEAN := TRUE) 

Процедура выполняет извлечение записи по ключу из таблицы EMPLOYEES 

Если параметр p_forUpdate истина, то выполняется SELECT … FOR UPDATE, в противном случае обычный SELECT 

При значении истина в параметре p_raise происходит вызов исключений, в противном случае исключения игнорируются 

#### PROCEDURE ins (p_row IN EMPLOYEES%ROWTYPE, p_update IN BOOLEAN := FALSE) 
Выполняет вставку новой строки 

При истинном значении параметра p_update, если строка с таким индексом уже существует, выполняется обновление данных. 

Процедура выбрасывает исключения при дублировании строк и нарушении других ограничений, наложенных на таблицу. 

#### PROCEDURE upd (p_row IN EMPLOYEES%ROWTYPE, p_insert IN BOOLEAN := FALSE) 
Процедура выполняет обновление данных в строке (кроме первичного ключа). 

При истинном значении параметра p_ insert, если строка с таким индексом не существует, выполняется вставка новой строки. 

#### PROCEDURE del (p_id IN EMPLOYEES.EMPLOYEE_ID%TYPE) 
Процедура выполняет удаление строки данных 

#### FUNCTION exist (p_id IN EMPLOYEES.EMPLOYEE_ID%TYPE) RETURN BOOLEAN 
Возвращает истину, если строка с указанным ключом существует в таблице 
 
### Создать пакет entEMPLOYEES 
обработки бизнес-логики объектов из таблицы EMPLOYEES 

Пакет должен содержать следующие процедуры: 

#### PROCEDURE employment (FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, JOB_ID, DEPARTMENT_ID, SALARY, COMMISSION_PCT) 

Процедура реализует функционал приема на работу нового сотрудника. 

Параметры SALARY, COMMISSION_PCT не обязательны для заполнения. Если они пустые, при добавлении записи эти данные заполняются средними значениями по подразделению и штатной должности (JOB_ID, DEPARTMENT_ID) 

Процедура выбрасывает исключения при нарушении ограничений на данные таблицы. 

В случае успешного добавления записи в таблицу EMPLOYEES необходимо создать новые сообщения типа email в таблице MESSAGES: 
- Для вновь принятого работника: “Уважаемый < FIRST_NAME > < LAST_NAME >! Вы приняты в качестве < JOB_TITLE > в подразделение < DEPARTMENT_NAME >. Ваш руководитель: < JOB_TITLE > < FIRST_NAME > < LAST_NAME >”. Имя и должность руководителя определить из соответствующих таблиц по DEPARTMENT_ID и MANAGER_ID 
- Для его руководителя: “Уважаемый < FIRST_NAME > < LAST_NAME >! В ваше подразделение принят новый сотрудник < FIRST_NAME > < LAST_NAME > в должности < JOB_TITLE > с окладом < SALARY >”. Значение полей извлечь из соответствующих таблиц по DEPARTMENT_ID и MANAGER_ID  
 
#### PROCEDURE payrise (EMPLOYEE_ID, SALARY) 
Процедура реализует повышение оклада сотруднику 

Если SALARY пусто, необходимо повысить оклад на 10% 

В случае превышения максимального оклада по должности (MAX_SALARY) необходимо выбросить исключение 

В случае успешного обновления данных в таблице EMPLOYEES создать новое сообщение для руководителя сотрудника следующего вида: “Уважаемый < FIRST_NAME > < LAST_NAME >! Вашему сотруднику < FIRST_NAME > < LAST_NAME > увеличен оклад с < SALARY old > до < SALARY new >” 
 
#### PROCEDURE leave (EMPLOYEE_ID) 
Процедура реализует увольнение сотрудника. 

Для увольнения необходимо в таблице EMPLOYEES очистить значение поля DEPARTMENT_ID. 

В случае успешного обновления создать сообщение руководителю уволенного сотрудника следующего вида: “Уважаемый < FIRST_NAME > < LAST_NAME >! Из вашего подразделения уволен сотрудник < FIRST_NAME > < LAST_NAME > с должности < JOB_TITLE >.”
