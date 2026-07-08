/*
    * DDL(DATA DEFINITION LANGUAGE) : 데이터 정의어 *
    
    : 데이터베이스의 객체 (테이블, 사용자, 뷰, 인덱스 등)의 구조를 정의하거나 변경, 삭제하는 명령어(SQL)
    : 실제 데이터 값이 아닌 구조(규칙)를 정의
*/
--------------------------------------------------------------------------------
/*
    * 테이블 생성 : CREATE TABLE 
    
        CREATE TABLE 테이블명 (
            컬럼명 데이터타입,
            컬럼명 데이터타입 DEFAULT 기본값,
            컬럼명 데이터타입 제약조건
            컬럼명 데이터타입 DEFAULT 기본값 제약조건,
            ...);

    * 오라클 기본 자료형(데이터타입) *
        - 날짜    | DATE          | 날짜 및 시간 데이터
        - 숫자    | NUMBER        | 숫자 데이터 (정수, 실수)
        - 문자    | CHAR(크기)     | 고정 길이 문자열 (최대 2000바이트)
                -> 지정한 크기보다 작은 데이터 입력 시 공백으로 채워짐
                 | VARCHAR2(크기) | 가변 길이 문자열 (최대 4000바이트)
                -> 입력 된 데이터의 실제 크기만큼만 공간을 차지(효율적)
*/
-- 회원(MEMCER) : 회원번호(MEM_NO), 회원 아이디(MEM_ID), 회원 비밀번호(MEM_PWD), 회원이름(MEM_NAME),
--                    성별(GENDER), 연락처(PHONE), 이메일(EMAIL), 가입일시(ENROLLDATE)
CREATE TABLE MEMBER(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),     -- '남' 또는 '여' (오라클에서는 한글 1글자당 3BYTE)
    PHONE CHAR(13),  -- '010-XXXX-XXXX' (13BYTE 고정)
    EMAIL VARCHAR2(40),
    ENROLLDATE DATE);
    
-- * 컬럼에 주석 추가 *
--      : 테이블 구조의 각 컬럼이 무엇을 의미하는 지 설명 추가
--      COMMENT ON COLUMN 테이블명.컬럼명 IS '설명문구';
COMMENT ON COLUMN MEMBER.MEM_NO IS '회원 번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원 아이디';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.GENDER IS '성별';
COMMENT ON COLUMN MEMBER.PHONE IS '연락처';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
COMMENT ON COLUMN MEMBER.ENROLLDATE IS '가입 일시';

-- * 데이터 추가(테스트)
INSERT INTO MEMBER VALUES (1, 'asdf', 'qwer', '홍길동', '남', '010-1234-4567', 'asdf@gamil.com', SYSDATE);
INSERT INTO MEMBER VALUES (2, 'hdfwre', 'saxcdw', '고길동', '남', NULL, NULL, SYSDATE);

INSERT INTO MEMBER VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

COMMIT;     -- 변경 사항 적용

SELECT * FROM MEMBER;
--------------------------------------------------------------------------------
/*
    * 제약조건 : 테이블의 특정 컬럼에 부적절한 데이터가 들어오지 못하도록 설정하는 규칙
        데이터 무결성(정확성, 일관성, 신뢰성)을 보장하는 것이 목적임!
        - 설정 방식 종류 -
        [1] 컬럼 레벨 방식    : 컬럼 정의 바로 옆에 제약조선을 기술하는 방식 (모든 제약조건 설정 가능)
        [2] 테이블 레벨 방식   : 모든 컬럼 정의를 마친 후, 하단에 별도로 기술하는 방식 (NOT NULL 제외)
*/
--------------------------------------------------------------------------------
/*
    * NOR NULL 제약조건 *
        : 해당 컬럼에 NULL 값이 저장 될 수 없도록 제한
        : 필수적으로 입력되어야 하는 데이터 (아이디, 비밀번호, 연락처 등)에 지정
        
        => 컬럼 레벨 방식으로만 지정할 수 있음
*/
-- 회원(MEMBER_NOTNULL) : 회원번호(MEM_NO), 회원 아이디(MEM_ID), 회원 비밀번호(MEM_PWD), 회원이름(MEM_NAME),
--                    성별(GENDER), 연락처(PHONE), 이메일(EMAIL), 가입일시(ENROLLDATE)
-- 회원번호, 아이디, 비밀번호, 이름에 NOT NULL 제약조건 설정
CREATE TABLE MEMBER_NOTNULL (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE CHAR(13),
    EMAIL VARCHAR2(40),
    ENROLLDATE DATE);
    
-- * 데이터 추가
INSERT INTO MEMBER_NOTNULL VALUES (1, 'asdf', 'qwer', '홍길동', '남', '010-1234-4567', 'asdf@gamil.com', SYSDATE);

INSERT INTO MEMBER_NOTNULL VALUES (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
-- => 추가 X : NOT NULL 제약조건이 설정된 컬럼에 NULL 값을 입력함!
INSERT INTO MEMBER_NOTNULL VALUES (2, 'ferq', '0000', '갈비탕', NULL, NULL, NULL, NULL);
INSERT INTO MEMBER_NOTNULL VALUES (3, 'ferq', 0000, '갈비탕', NULL, NULL, NULL, NULL);


SELECT * FROM MEMBER_NOTNULL;
--------------------------------------------------------------------------------
/*
    * UNIQUE 제약 조건 : 해당 컬럼에 중복 된 데이터 값이 들어오는 것을 제한
                        고유해야 하는 데이터(주민번호, 아이디, 이메일 등)에 적용
                -> NULL 은 값이 없는 상태를 의미하므로, UNIQUE 조건이 있어도 여러 개 저장 될 수 있음!
                
    * 보통 제약조건명을 지정하여 설정 : 에러 발생 시 어떤 제약조건을 위배했는지 명확하게 파악하기 위해! *
*/
-- 회원(MEMBER_UNIQUE) : 회원 아이디(MEM_ID) UNIQUE 제약 조건 설정
DROP TABLE MEMBER_UNIQUE;

CREATE TABLE MEMBER_UNIQUE (
    -- 컬럼 레벨 방식 : NOT NULL (회원번호, 아이디, 비밀번호, 이름)
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE CHAR(13),
    EMAIL VARCHAR2(40),
    ENROLLDATE DATE,
    -- 테이블 레벨 방식 : UNIQUE (아이디)
    CONSTRAINT UQ_MEM_ID UNIQUE(MEM_ID)
    );

-- * 데이터 추가
INSERT INTO MEMBER_UNIQUE VALUES (1, 'asdf', 'qwer', '홍길동', '남', '010-1234-4567', NULL, NULL);

INSERT INTO MEMBER_UNIQUE VALUES (2, 'asdf', '1234', '갈비찜', '남', '010-1234-4567', NULL, NULL);

SELECT * FROM MEMBER_UNIQUE;
--------------------------------------------------------------------------------
/*
    * CHECK 제약 조건 : 해당 컬럼에 저장 될 수 있는 값의 범위나 특정 조건식을 지정해주는 규칙
                        조건식의 결과가 TRUE(만족)인 데이터만 저장할 수 있으며, NULL 값도 저장
*/
-- * 회원 (MEMBER_CHECK) : 성별(GENDER) '남' 또는 '여' 값만 저장되도록 조건 지정
CREATE TABLE MEMBER_CHECK (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CONSTRAINT CK_GENDER CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(40),
    ENROLLDATE DATE,

    CONSTRAINT UQ2_MEM_ID UNIQUE(MEM_ID)
    );

-- * 데이터 추가
INSERT INTO MEMBER_CHECK VALUES (1, 'asdf', 'qwer', '홍길동', '남', '010-1234-4567', NULL, NULL);

INSERT INTO MEMBER_CHECK VALUES (2, 'etwy', '1234', '갈비찜', NULL, '010-1234-4567', NULL, NULL);

INSERT INTO MEMBER_CHECK VALUES (2, 'etwy', '1234', '갈비찜', '논', '010-1234-4567', NULL, NULL);

SELECT * FROM MEMBER_CHECK;
--------------------------------------------------------------------------------
/*
    * PRIMARY KEY (기본키) 제약조건 *
        : 테이블 내에서 각 행을 고유하게 식별하기 위해 사용하는 대표 컬럼을 지정
        NOT NULL + UNIQUE (NULL 값을 허용하지 않고, 중복 불가능!)
        테이블당 오직 1개만 지정하여 설정할 수 있음!
*/
-- 회원(MEMBER_PRI) : 회원번호(MEM_NO) 컬럼을 기본키로 지정
CREATE TABLE MEMBER_PRI (
    MEM_NO NUMBER CONSTRAINT PRI_MEM_NO PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CONSTRAINT CK2_GENDER CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(40),
    ENROLLDATE DATE,

    CONSTRAINT UQ3_MEM_ID UNIQUE(MEM_ID)
    );
    
-- * 데이터 추가
INSERT INTO MEMBER_PRI VALUES (1, 'asdf', 'qwer', '홍길동', NULL, NULL, NULL, NULL);

INSERT INTO MEMBER_PRI VALUES (1, 'wqrT', 'qwer', '홍길동', NULL, NULL, NULL, NULL);
INSERT INTO MEMBER_PRI VALUES (NULL, 'wqrT', 'qwer', '홍길동', NULL, NULL, NULL, NULL);

INSERT INTO MEMBER_PRI VALUES (2, 'wqrT', 'qwer', '홍길동', NULL, NULL, NULL, NULL);

SELECT * FROM MEMBER_PRI;
--------------------------------------------------------------------------------
/*
    * 복합키 : 단일 컬럼만으로는 기본키 역할을 부여하기 애매할 때, 
                두 개 이상의 컬럼을 병합하여 하나의 기본키로 지정
        => 테이블 레벨 방식으로만 설정 가능!
*/
CREATE TABLE MEMBER_PRI2 (
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    PHONE CHAR(13),
    EMAIL VARCHAR2(40),
    ENROLLDATE DATE,

    UNIQUE(MEM_ID),
    CONSTRAINT PRI2_PK_IDPHONE PRIMARY KEY (MEM_ID, PHONE)
    );

INSERT INTO MEMBER_PRI2 VALUES (1, 'asdf', 'qwer', '홍길동', '남', '010-1234-1234', NULL, NULL);
INSERT INTO MEMBER_PRI2 VALUES (2, 'qwesd', 'qwer', '홍길동', '남', '010-1234-1234', NULL, NULL);

INSERT INTO MEMBER_PRI2 VALUES (2, 'qwesd', 'qwer', '홍길동', '남', '010-1234-1234', NULL, NULL);

SELECT * FROM MEMBER_PRI2;
--------------------------------------------------------------------------------
/*
    * FOREIGN KEY (외래키) 제약 조건 *
        : 다른 테이블에 존재하는 데이터 범위에서만 값을 저장하고자 할 때 설정
            테이블 간의 관계에 따라 지정
            
        - 부모 테이블 (참조 대상) : 테이블 내 PK 또는 UNIQUE 컬럼만 자식에게 제공할 수 있음
        - 자식 테이블 (참조 주체) : 외래키 제약조건을 가지고 부모 컬럼을 가리키는 역할
*/
-- 부모 테이블 : 회원 등급(MEMBER_GRADE) - 등급번호(GRADE_NO), 등급명(GRADE_NAME)
CREATE TABLE MEMBER_GRADE (
    GRADE_NO NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(20) NOT NULL
    );

INSERT INTO MEMBER_GRADE VALUES(100, '일반회원');
INSERT INTO MEMBER_GRADE VALUES(200, 'VIP회원');
INSERT INTO MEMBER_GRADE VALUES(300, 'VVIP회원');

SELECT * FROM MEMBER_GRADE;

-- 자식 테이블 : 회원(MEMBER_FRK)
CREATE TABLE MEMBER_FRK (
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남', '여')),
    ENROLLDATE DATE,
    GRADE_ID NUMBER REFERENCES MEMBER_GRADE(GRADE_NO)
    );
    
INSERT INTO MEMBER_FRK VALUES (1, 'qwert', '1234', '홍길동', '남', SYSDATE, 100);
INSERT INTO MEMBER_FRK VALUES (2, 'qwert12', '1234', '김길동', '남', SYSDATE, 300);
INSERT INTO MEMBER_FRK VALUES (3, 'qwe234', '1234', '왕길동', '남', SYSDATE, NULL);

INSERT INTO MEMBER_FRK VALUES (4, 'qwe4', '1234', '고길동', '남', SYSDATE, 400);

SELECT * FROM MEMBER_FRK;
