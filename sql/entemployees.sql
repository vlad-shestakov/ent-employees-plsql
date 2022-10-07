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
    C_MSG_PAYRISE_MGR_TXT constant messages.msg_text%type :=  'Уважаемый %s %s! Вашему сотруднику %s %s увеличен оклад с %s до %s.';
    -- Уважаемый < FIRST_NAME > < LAST_NAME >! Вашему сотруднику < FIRST_NAME > < LAST_NAME > увеличен оклад с < SALARY old > до < SALARY new >.

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
