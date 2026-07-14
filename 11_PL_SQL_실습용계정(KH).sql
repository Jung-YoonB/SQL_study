/*
    * PL/SQL : PROCEDURE LANGUAGE EXTENSION TO SQL
    
    - 오라클 자체에 내장되어 있는 절차적 언어
    - SQL(PL/SQL) 문장 내에 변수 정의, 조건문, 반복문 등을 지원
    
    [구조]
        [선언부]    : DECLARE 로 시작, 변수나 상수를 선언하고 초기화 하는 부분 (생략 가능)
        실행부      : BEGIN 으로 시작, SQL문 또는 제어문(조건문, 반복문) 등의 로직을 작성하는 부분 (필수 항목) 
        [예외처리부] : EXCEPTION 으로 시작, 실행 중 예외(오류) 발생 시 해결하기 위한 부분(생략 가능)
*/

-- * 화면에 출력하기 위한 설정 (DBMS_OUTPUT) *
    --> 접속할 때마다, 새로운 워크시트 창을 열 때 실행해야 함!
SET SERVEROUTPUT ON;

-- * HELLO ORACLE 출력
BEGIN
    dbms_output.put_line('HELLO ORACLE');
END;
/
    --> 자바의 System.out.println() 과 같은 역할!
--------------------------------------------------------------------------------
/*
    * 선언부 (DECLARE) *
        : 변수 또는 상수를 선언하는 부분 (선언과 동시에 초기화도 가능)
*/

/*
    * 일반 타입 변수 *
    
        변수명 [CONSTANT] 데이터타입 [:= 값];
        
    * 자바와의 차이점
        1) 자바에서는 데이터타입 변수명; 이지만, PL/SQL 에서는 변수명 데이터타입; 이다.
        2) 자바에서는 대입 연사자가 = 이지만, PL/SQL 에서는 := 이다. (SQL 에서 = 는 비교 연산자!)
        3) 상수 성언 시 자바에서는 final 이지만, PL/SQL 에서는 CONSTANT 이다.
*/

DECLARE
    NAME VARCHAR2(10);
    AGE NUMBER;
    CLASS CONSTANT CHAR(1) := 'C';

BEGIN
    NAME := '쌀국수';
    AGE := 20;
    dbms_output.put_line('이름 : ' || NAME);
    dbms_output.put_line('나이 : ' || AGE);
    dbms_output.put_line('강의장 : ' || CLASS);
    
END;
/

-- 값을 입력 받아 변수에 대입
    --> &이름 과 같이 작성 시 값을 입력받을 수 있음
DECLARE
    EID NUMBER;
    ENAME VARCHAR2(10);
    
BEGIN
--    ENAME := '쌀국수';
--    EID := &직원번호;
    
    --> 만약 입력받을 값이 문자 타입의 변수에 저장된다면, '&이름' 처럼 작은 따옴표로 감싸주어야 함!
    ENAME := '&이름';
    EID := 999;

    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('직원번호 : ' || EID);
    
END;
/
--------------------------------------------------------------------------------
/*
    * 참조(REFFENCE) 타입 변수 
    [%TYPE]
        : 특정 테이블의 특정 컬럼 데이터 타입을 그대로 가져와서 변수로 선언
            => 컬럼 타입이 나중에 바뀌어도 코드 수정이 필요 없음!
            
            변수명 테이블명.컬럼명%TYPE
*/
-- EMPLOYEE 테이블의 EMP_ID, EMP_NAME, SALARY 컬럼을 참조하여
--                  EID,    ENAME,      SAL 변수 선언
DECLARE
    -- 정의 해보기 ***
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    
BEGIN

    SELECT EMP_ID, EMP_NAME, SALARY
        INTO EID, ENAME, SAL
    FROM employee
    WHERE EMP_ID = '&직원번호';
    
    DBMS_OUTPUT.PUT_LINE('직원 번호 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('직원 이름 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);

END;
/

-- [QUIZ] 직원 번호를 입벽 받아, 해당 직원의 직원번호, 이름, 직급코드, 급여, 부서명을 출력해보기
    --> 출력 형식 (210번 예) : 210, 윤은해, J7, 2000000, 해외영업1부
    --> 예외처리부 실습 전이므로, 직원 번호는 200 ~ 222 만 입력!

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;

BEGIN
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
        INTO EID, ENAME, JCODE, SAL, DTITLE
    FROM EMPLOYEE
        LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    WHERE EMP_ID = '&직원번호';
    
    DBMS_OUTPUT.PUT_LINE(EID || ', ' || ENAME || ', ' || JCODE || ', ' || SAL || ', ' || DTITLE);  
    
END;
/
--------------------------------------------------------------------------------
/*
    * ROW 타입 변수 *
    [%ROWTYPE]
        : 테이블의 한 행 전체를 통째로 담을 수 있는 변수 (자바의 참조변수와 유사)
        변수명 테이블명%ROWTYPE
*/
DECLARE
    E EMPLOYEE%ROWTYPE;

BEGIN
    SELECT *
        INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = '&직원번호';
 
    DBMS_OUTPUT.PUT_LINE('이름: ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여: ' || E.SALARY);
    
    DBMS_OUTPUT.PUT_LINE('보너스: ' || NVL(E.BONUS, 0));
END;
/
--------------------------------------------------------------------------------
/*
    * 실행부 (BEGIN) *
    
    * 제어문 - 조건문 *
        - 단일 IF문
            : IF 조건식 THEN 실행_할_내용;
              END IF;
              
        - IF / ELSE문
            : IF 조건식 THEN 만족할_때_실행_할_내용; 
              ELSE 만족하지_않을때_실행;
              END IF;
              
        - IF / ELSIF문
            : IF 조건식 THEN 실행1;
              ELSIF 조건식2 THEN 실행2;
              ELSE 실행3;
              END IF;
              => 자바에서는 else if (조건식) 이었지만, 오라클에서는 ELSIF 이다.
*/

DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
    
BEGIN 
    SCORE := &점수;
    
    -- 90점 이상이면 'A'
    IF SCORE >= 90 THEN GRADE := 'A';
    -- 80점 이상이면 'B'
    ELSIF SCORE >= 80 THEN GRADE := 'B';
    -- 70점 이상이면 'C'
    ELSIF SCORE >= 70 THEN GRADE := 'C';
    -- 60점 이상이면 'D'
    ELSIF SCORE >= 60 THEN GRADE := 'D';
    -- 그 미만이면 F
    ELSE GRADE := 'F';
    END IF;
    
    -- 점수는 XXX이고, 등급은 X 입니다. (출력)
    DBMS_OUTPUT.PUT_LINE('점수는 ' || SCORE || '이고, 등급은 ' || GRADE || ' 입니다.');
    
    IF GRADE = 'F' THEN dbms_output.put_line('F 등급은 재평가 대상입니다.');
    END IF;
    
END;
/
-- 직원 번호, 이름, 급여, 보너스 정보를 출력
    --> 보너스를 받지 않는 경우 보너스를 받지 않는 직원입니다. 출력
    --> 보너스를 받는 경우 해당 값을 출력
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
    
    E EMPLOYEE%ROWTYPE;
    
BEGIN
    -- 직원 번호를 입력 받아, 해당 직원 정보를 조회하여 변수에 저장
--    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    SELECT EMP_ID, EMP_NAME, SALARY, BONUS
        INTO EID, ENAME, SAL, BONUS
    FROM employee
    WHERE EMP_ID = '&직원번호';
    
    -- 저장 된 값을 출력
    dbms_output.put_line('직원 번호: ' || EID);
    dbms_output.put_line('이름: ' || ENAME);
    dbms_output.put_line('급여: ' || SAL);
    
--    IF BONUS = 0 THEN dbms_output.put_line('보너스를 받지 않는 직원입니다.');
    IF BONUS IS NOT NULL THEN dbms_output.put_line('보너스: ' || BONUS);
    ELSE dbms_output.put_line('보너스를 받지 않는 직원입니다.');
    END IF;
    
END;
/
--------------------------------------------------------------------------------
/*
    * 반복문 *
    
    - FOR LOOP 문 (자바의 FOR문과 유사)
    
        FOR 변수명 IN [REVERSE] 초기값..끝값
        LOOP
            반복할 내용;
        END LOOP;
*/
-- TEST 테이블, SEQ_TNO 시퀀스 생성(* 기존에 존재하는 경우 제거 후 생성)
    --> TEST 테이블 : TNO(PK, 숫자), TDAET(날짜)
    --> SEQ_TNO 시퀀스 : 1부터 시작, 1000까지만 증가, 2씩 증가, 순환X, 캐시X
DROP TABLE TEST;
CREATE TABLE TEST (
    TNO NUMBER CONSTRAINT PK_TEST_TNO PRIMARY KEY,
    TDATE DATE
);
--DROP SEQUENCE SEQ_TNO;
CREATE SEQUENCE SEQ_TNO
INCREMENT BY 2
MAXVALUE 1000
NOCYCLE
NOCACHE;

SELECT * FROM TEST;
SELECT * FROM user_sequences; 

-- * TEST 테이블의 100개의 데이터를 추가
BEGIN
    
    FOR I IN 1..100
    LOOP
        -- 데이터 추가(INSERT)
        INSERT INTO TEST VALUES (SEQ_TNO.NEXTVAL, SYSDATE);
    END LOOP;
    
    COMMIT;
        --> 100 개의 데이터 추가 완료 후 적용 (COMMIT)
END;
/

SELECT COUNT(*) FROM TEST;
--------------------------------------------------------------------------------
/*
    * 예외처리부 (EXCEPTION) *
        : 자바의 try - catch 블록과 유사한 부분
    
    EXCEPTION
        WHEN 예외명1 THEN 처리구문1;
        WHEN 예외명2 THEN 처리구문2;
        WHEN OTHERS THEN 그 외의 모든 예외에 대한 처리 구문;

    * 자주 만나는 예외들 *
        - NO_DATA_FOUND : SELECT INTO 결과가 단 한 행도 없을 경우 발생
        - TOO_MANY_ROWS : SELECT INTO 결과가 여러 행일 때 발생
        - ZERO_DIVIDE   : 0으로 숫자를 나누려고 할 때 발생 (ArithmeticException)
        - DUP_VAL_ON_INDEX  : 기본키(PK), UNIQUE 등 컬럼에 중복 된 값을 저장하려고 할 때 발생
*/
-- * 직원번호를 입력받아, 노옹철 직원의 번호를 변경
BEGIN
    UPDATE employee
    SET EMP_ID = '&변경할직원번호'
    WHERE EMP_NAME = '노옹철';

EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('ERROR! 이미 존재하는 번호입니다. 다른 번호를 입력하세요.');
    
END;
/

SELECT EMP_ID FROM EMPLOYEE WHERE EMP_NAME = '노옹철';
ROLLBACK;
--------------------------------------------------------------------------------
/*
    * PL/SQL 프로시저
        : 특정 비즈니스 로직을 처리하는 PL/SQL 코드를 DB에 저장해 둘 수 있는 객체
    
    - 매개변수 종류 -
        * IN : 자바 메소드의 매개변수처럼, 외부에서 프로시저 내부로 값을 가지고 올 때 사용
        * OUT : 반환값처럼 프로시저가 처리한 결과를 외부로 줄 때 사용
*/
--* INSERT_TEST_DATA 라는 이름의 프로시저 객체 생성 
    -- => 전달 된 개수(DCOUNT)만큼 TEST 테이블에 데이터 추가
CREATE OR REPLACE PROCEDURE INSERT_TEST_DATA
(
    DCOUNT IN NUMBER
)
IS
BEGIN
    
    FOR I IN 1..DCOUNT
    LOOP
        -- 데이터 추가(INSERT)
        INSERT INTO TEST VALUES (SEQ_TNO.NEXTVAL, SYSDATE);
    END LOOP;
    
    COMMIT;
        --> 100 개의 데이터 추가 완료 후 적용 (COMMIT)
        
    dbms_output.put_line(DCOUNT || '개의 데이터가 추가되었습니다.');
END;
/


-- * 생성 된 프로시저를 사용(실행)
CALL insert_test_data(50);

BEGIN
    insert_test_data(20);
END;
/

SELECT COUNT(*) FROM TEST;
SELECT * FROM TEST;
