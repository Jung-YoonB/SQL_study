/*
    * DCL (DATE CONTROL LANGUAGE, 데이터 제어어)
        : 사용자 계정에 시스템 권한/ 객체 권한을 부여(GRANT) 하거나,
            회수(REVOKE) 하는 구문
    
        - 시스템 권한 : DB에 접근하는 권한, 객체를 생성하는 권한
        - 객체 권한 : 특정 객체들을 조작할 수 있는 권한
*/
--------------------------------------------------------------------------------
/*
    * 사용자 계정 생성 *
        CREATE USER 사용자명 IDENTIFIED BY 비밀번호;
        
            - 사용자명 : ORACLE 12C 버전 이후로 C##이 앞에 붙어야 함!
            - 비밀번호 : 대소문자를 구분하므로 잘 작성해줘야 함!

    * 권한 부여*
        GRANT 권한_또는_역할 TO 사용자명;
        
        - 권한 종류 -
        * CREATE SESSION    : 접속 권한
        * CREATE TABLE      : 테이블 생성 권한
        * CREATE VIEW       : 뷰 생성 권한
        * CREATE SEQUENCE   : 시퀀스 생성 권한
            ... ETC
*/
-- 사용자 계성 생성 : SAMPLE / SAMPLE
CREATE USER C##SAMPLE IDENTIFIED BY SAMPLE;
    --> 현재 계정(KH)은 사용자 생성 권한이 없으므로, 관리자 계정으로 생성해야 함!

--> 접속 시도 시 권한이 부여되어 있지 않아, CREATE SESSION 권한이 없다고 오류 발생!
GRANT CREATE SESSION TO C##SAMPLE;

--> 접속 성공 후 테이블을 생성하려고 했으나, 권한이 불충분하다고 실패 (오류 발생!)
        --> SAMPLE 계정에 CREATE TABLE 권한 부여
GRANT CREATE TABLE TO C##SAMPLE;

--> 테이블 생성 후 데이터를 추가하려고 했으나, 테이블 스페이스 관련 권한이 없다고 실패 (오류 발생!)
        --> SAMPLE 계정에 테이블 스페이스 할당
ALTER USER C##SAMPLE QUOTA 2M ON USERS;     --> 2M 정도 테이블 스페이스 공간 할당
--------------------------------------------------------------------------------
/*
    * 객체 권한 *
    종류         | 접근 객체
    =====================================
    SELECT      | TABLE, VIEW, SEQUENCE     -- 조회
    INSERT      | TABLE, VIEW               -- 추가
    UPDATE      | TABLE, VIEW               -- 수정
    DELETE      | TABLE, VIEW               -- 삭제
    
    * 권한 부여 *
    GRANT 권한종유 ON 특정객체 TO 사용자명;
    
    예) TEST 계정에 KH 계정의 EMPLOYEE 테이블을 조회할 수 있도록 권한 부여
        GRANT SELECT ON KH.EMPLOYEE TO TEST          -- Oracle 12c 이전 버전
        GRANT SELECT ON C##KH.EMPLOYEE TO C##TEST;
*/

/*
    * 권한 회수 *
    REVOKE 회수할권한 FROM 사용자명;             -- 시스템 권한
    REVOKE 종류 ON 객체정보 FROM 사용자명;        -- 객체 접근 권한

    예) TEST 계정에 부여했던 KH계정의 EMPLOYEE 테이블 조회 권한 회수
        REVOKE SELECT ON C##KH.EMPLOYEE FROM C##TEST;
*/
--------------------------------------------------------------------------------
/*
    * 역할(ROLE, 규칙) : 특정 권한들을 하나의 집합으로 모아놓은 것
    
        - CONNECT   : 접속 권한 (CREATE SESSION)
        - RESOURCE  : 자원(객체) 관리, 특정 객체 생성 권한
                        (CREATE TABLE, CREATE SEQUENCE, ...)
*/
-- 역할(ROLE) 조회
SELECT * FROM ROLE_SYS_PRIVS;
SELECT * FROM ROLE_SYS_PRIVS WHERE ROLE IN ('CONNECT', 'RESOURCE');
--------------------------------------------------------------------------------
/*
    * TCL (TRANSCATION CONTROL LANGUAGE, 트랜잭션 제어어)
    
    - 트랜잭션 : 데이터베이스의 논리적 연상 단위
                데이터의 변경 사항(DML 사용 시)을 하나의 묶음처럼 트랜잭션에 모아둠
                COMMIT 사용하기 전까지의 변경사항들을 하나의 트랜잭션으로 담게 됨
                -> 트랜잭션에 추가되는 SQL(DML) : INSERT / UPDATE / DELETE / MERGE???
                
    - 종류
        * COMMIT (적용)   : 트랜잭션에 담겨져 있는 변경 사항들을 실제 DB에 적용하겠다
        * ROLLBACK (취소) : 트랜잭션에 담겨져 있는 변경 사항들을 삭제(취소)하겠다
                            마지막 커밋 시점(위치)로 돌아간다.
        * SAVEPOINT 포인트명(시점 저장)
                : 현재 시점에 변경 사항들을 임시로 저장해두는 것을 의미한다
                    ROLLBACK 시 시점 이름을 같이 입력하면, 전체 변경 사항을 모두 삭제하지 않고,
                    해당 위치까지만 삭제한다
                    => ROLLBACK TO 포인트명
*/

-- * KH 계정으로 접속 * --

-- 테이블 복제 : EMPLOYEE 테이블에서 EMP_ID, EMP_NAME, DEPT_TITLE 조회한 결과를 EMP01 테이블에 복제
DROP TABLE EMP01;
CREATE TABLE EMP01
AS (SELECT EMP_ID, EMP_NAME, DEPT_TITLE FROM employee JOIN department ON DEPT_CODE = DEPT_ID);

SELECT * FROM EMP01;

-- 직원 번호가 217, 214 인 직원 삭제
DELETE FROM EMP01 WHERE EMP_ID IN ('217', '214');
    --> 트랜잭션 시작...
ROLLBACK;
    --> 변경사항 취소(삭제 전으로 돌아감), 트랜잭션 종료(삭제)
--------------------------------------------------------------------------------
DELETE FROM EMP01 WHERE EMP_ID = '217';
    --> 트랜잭션 시작...
DELETE FROM EMP01 WHERE EMP_ID = '214';
    
COMMIT;
    --> 변경사항 적용, 디스크에 반영 됨, 트랜잭션 종료
--------------------------------------------------------------------------------
ROLLBACK;
    --> 변경사항 취소 => 마지막 커밋 시점으로 돌아감.
--------------------------------------------------------------------------------
DELETE FROM EMP01 WHERE EMP_ID IN ('208', '209', '210');
    --> 트랜잭션 시작...
SELECT *FROM EMP01 ORDER BY EMP_ID;

SAVEPOINT SP;
    --> 임시 저장, SP라는 이름으로 시점을 저장.

INSERT INTO EMP01 VALUES ('500', '무지개', '인사관리부');

DELETE FROM EMP01 WHERE EMP_ID = '215';

ROLLBACK TO SP;
    --> SP 저장 위치까지만 작업 취소.
COMMIT;
    --> SAVEPOINT 위치로 롤백했기 때문에, DELETE 208, 209, 210 변경사항만 DB에 적용 됨!
--------------------------------------------------------------------------------

-- 212번 직원 삭제
DELETE FROM EMP01 WHERE EMP_ID = '212';
    --> 트랜잭션 시작...

CREATE TABLE TEST (
    TID NUMBER
);
    --> DDL (테이블 생성)
    
ROLLBACK;
SELECT * FROM EMP01 WHERE EMP_ID = '212';
    --> DDL(CREATE, ALTE, DROP)을 사용하게 되면 기준 트랜잭션에 저장 된 변경 사항들은 무조건 반영 됨)COMMIT
    -- DDL을 사용하기 전에는 DML(INSERT, UPDATE, DELETE)로 작성 된 쿼리문이 있다면
    -- 확실하게 트랜잭션 처리(COMMIT, ROLLBACK)한 후에 DDL을 실행해야 함!!
