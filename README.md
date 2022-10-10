# PL/SQL проект PLSQL_ENT_EMPLOYEES

Тестовое задание PL/SQL

## Задача

- [_TASK.md                       ](./_TASK.md                    )

## Результат тестирования

- <a href="./TestLog Результат тестирования PLSQL_ENT_EMPLOYEES.sql">TestLog Результат тестирования PLSQL_ENT_EMPLOYEES.sql</a>

## Инициализация

* Развернуть схему [sql/_ALL_SCHEMA_EXPORT.sql    ](./sql/_ALL_SCHEMA_EXPORT.sql    )
* Развернуть данные [sql/_ALL_SCHEMA_DATA.sql     ](./sql/_ALL_SCHEMA_DATA.sql    )
* Запустить пакет с тестами - <a href="./TestLog Тестирование пакетов PLSQL_ENT_EMPLOYEES.sql">TestLog Тестирование пакетов PLSQL_ENT_EMPLOYEES.sql</a>


## Состав проекта
  
|             Объекты БД        |                                              |                        |
|-------------------------------|------------------------------------------------------------------------|--------------------------|
| **Задача**          | [_TASK.md                       ](./_TASK.md                    )|                          |                |
| Запросы по проекту      | <a href="./SqlLog Запросы по проекту PLSQL_ENT_EMPLOYEES.sql">SqlLog Запросы по проекту PLSQL_ENT_EMPLOYEES.sql</a>|  |
| **Скрипт тестирования пакетов**     | <a href="./TestLog Тестирование пакетов PLSQL_ENT_EMPLOYEES.sql">TestLog Тестирование пакетов PLSQL_ENT_EMPLOYEES.sql</a>|  |
| Результат тестирования          | <a href="./TestLog Результат тестирования PLSQL_ENT_EMPLOYEES.sql">TestLog Результат тестирования PLSQL_ENT_EMPLOYEES.sql</a>|          
| Объекты БД          | [sql/                       ](./sql/                      )|                          |
| Объекты схемы         | [sql/_ALL_SCHEMA_EXPORT.sql     ](./sql/_ALL_SCHEMA_EXPORT.sql    )| Все объекты схемы        |
| Данные схемы          | [sql/_ALL_SCHEMA_DATA.sql     ](./sql/_ALL_SCHEMA_DATA.sql    )| Все данные схемы         |
| **Таблица EMPLOYEES**       | [sql/employees.tab        ](./sql/employees.tab         )| Доработанная таблица EMPLOYEES    |
| **Таблица MESSAGES**        | [sql/messages.tab         ](./sql/messages.tab        )|                          |
| Вью VW_EMPLOYEES        | [sql/vw_employees.vw        ](./sql/vw_employees.vw       )| Вью EMPLOYEES      |
| Сиквенс MESSAGES_SEQ      | [sql/messages_seq.seq       ](./sql/messages_seq.seq      )|                          |
| **Триггер TR_EMPLOYEES_BIU**    | [sql/tr_employees_biu.sql     ](./sql/tr_employees_biu.sql    )|                          |
| Триггер TR_MESSAGES_BI_SEQ  | [sql/tr_messages_bi_seq.sql     ](./sql/tr_messages_bi_seq.sql    )|                          |
| **Пакет tabEMPLOYEES**      | [sql/tabemployees.sql       ](./sql/tabemployees.sql      )| Управление данными EMPLOYEES      |
| Пакет tabEMPLOYEES_TEST     | [sql/tabemployees_test.sql    ](./sql/tabemployees_test.sql     )| Тестирование пакета      |
| **Пакет entEMPLOYEES**      | [sql/entemployees.sql       ](./sql/entemployees.sql      )| Бизнес-функции      |
| Пакет entEMPLOYEES_TEST     | [sql/entemployees_test.sql    ](./sql/entemployees_test.sql     )| Тестирование пакета    |
 
