-- * KH_연습 문제 *
-- * 연습용 계정 생성 후 아래 문제를 풀어봅시다 *
-- * 계정 정보 : C##TEST / TEST *
-- * 테이블이 존재하지 않을 경우, [연습 문제 6]을 참고하여 생성해 주세요. *
-- 1. TB_DEPT 테이블에 아래 3개의 부서 데이터를 삽입하는 SQL을 작성하세요.
--    10번: '인사팀'
--    20번: '개발팀'
--    30번: '디자인팀'
INSERT INTO TB_DEPT VALUES (10, '인사팀');
INSERT INTO TB_DEPT VALUES (20, '개발팀');
INSERT INTO TB_DEPT VALUES (30, '디자인팀');

SELECT * FROM TB_DEPT;
COMMIT;

-- 2. TB_EMP 테이블에 아래의 사원 정보를 삽입하는 SQL을 작성하세요.
--    사원번호: 1001, 이름: '홍길동', 성별: (기본값 설정 적용), 부서코드: 10, 연락처: '010-1111-2222'
--    사원번호: 1002, 이름: '김철수', 성별: 'M', 부서코드: 20, 연락처: '010-3333-4444'
--    사원번호: 1003, 이름: '이영희', 성별: 'F', 부서코드: 20, 연락처: '010-5555-6666'
INSERT INTO TB_EMP (EMP_NO, EMP_NAME, DEPT_CD, CONTACT) VALUES (1001, '홍길동', 10, '010-1111-2222');
INSERT INTO TB_EMP VALUES (1002, '김철수', 'M', 20, '010-3333-4444');
INSERT INTO TB_EMP VALUES (1003, '이영희', 'F', 20, '010-5555-6666');

SELECT * FROM TB_EMP;
COMMIT;

-- 3. 아래의 SQL을 실행했을 때 에러가 발생하는 원인을 제약조건과 연결 지어 설명하고,
--      정상적으로 삽입되도록 SQL을 수정하세요.
--    INSERT INTO TB_EMP (EMP_NO, EMP_NAME, GENDER, DEPT_CD, CONTACT)
--    VALUES (1004, '박민수', 'X', 40, '010-1111-2222');

-- 원인 1 : 체크 제약 조건 -> 젠더에 M / F 만 입력 위반 
-- 원인 2 : 유니크 제약 조건 -> CONTACT에 중복 금지 입력 위반
-- 원인 3 : 외부키 제약 조건 -> 부모 키에 등록 되지 않은 값 입력
INSERT INTO TB_EMP (EMP_NO, EMP_NAME, GENDER, DEPT_CD, CONTACT)
VALUES (1004, '박민수', NULL, NULL, NULL);

SELECT * FROM TB_EMP;
COMMIT;
-- 4. '개발팀'의 부서코드(DEPT_CD)가 20번에서 50번으로 변경되어야 합니다. 아래 작업 항목에 따라 SQL문을 작성하세요.
--    * TB_DEPT 테이블에서 개발팀의 부서코드를 50으로 변경하는 SQL을 작성하세요.
--    * 부서코드가 변경됨에 따라 TB_EMP 테이블에서 
--      개발팀(기존 20번) 소속이었던 사원들의 부서코드도 50으로 일괄 변경하는 SQL을 작성하세요.

--> * 간단한 방법
--> 1) TB_DEPT 테이블에 데이터 추가 (50번 '개발팀')
INSERT INTO TB_DEPT VALUES (50, '개발팀');

SELECT * FROM TB_DEPT;

--> 2) TB_EMP 테이블에서 부서코드가 20번인 직원들의 코드를 50번으로 변경
UPDATE TB_EMP
SET DEPT_CD = 50
WHERE DEPT_CD = 20;

SELECT * FROM TB_EMP WHERE DEPT_CD = 20;

--> 3) TB_DEPT 테이블에서 데이터 삭제 (20번)
DELETE FROM TB_DEPT
WHERE DEPT_CD = 20;

SELECT * FROM TB_DEPT WHERE DEPT_CD = 20;

ROLLBACK;

SELECT * FROM TB_DEPT WHERE DEPT_NAME = '개발팀';
SELECT * FROM TB_EMP WHERE DEPT_CD = 20;

INSERT INTO TB_DEPT VALUES (9999, '변경예정');
SELECT * FROM TB_DEPT;

UPDATE TB_EMP
SET DEPT_CD = 9999
WHERE DEPT_CD = 20;

SELECT * FROM TB_EMP;

UPDATE TB_DEPT
SET DEPT_CD = 50
WHERE DEPT_NAME = '개발팀';

UPDATE TB_EMP
SET DEPT_CD = 50
WHERE DEPT_CD = 9999;

DELETE FROM TB_DEPT
WHERE DEPT_CD = 9999;

SELECT * FROM TB_EMP;
SELECT * FROM TB_DEPT;

ROLLBACK;
--> * 복잡한 방법 * 만약 TB_DEPT 테이블의 DEPT_NAME 칼럼에 UNIQUE가 설정되어 있다면..?
ALTER TABLE TB_DEPT ADD CONSTRAINT UQ_TD_DNAME UNIQUE(DEPT_NAME);

-- 1) 테이블 복제 --> 구조 + NOT NULL 제약 조건만 복제 (다른 제약 조건은 복제 되지 않음!)
SELECT * FROM TB_EMP WHERE DEPT_CD = 20;

CREATE TABLE TB_EMP_20
AS (SELECT * FROM TB_EMP WHERE DEPT_CD = 20);

SELECT * FROM TB_EMP_20;

-- 2) 해당 직원 데이터를 삭제
DELETE FROM TB_EMP WHERE DEPT_CD =20;

SELECT * FROM TB_EMP_20;

-- 3) 부서 코드 변경
UPDATE TB_DEPT
SET DEPT_CD = 50
WHERE DEPT_CD = 20;

SELECT * FROM TB_DEPT;

-- 4) 백업해둔 직원 정보 복원(추가)
--> 4-1) 직원 정보 중 20 -> 50 변경
UPDATE TB_EMP_20
SET DEPT_CD = 50
WHERE DEPT_CD = 20;

SELECT * FROM TB_EMP_20;

--> 4-2) 정보 복원
INSERT INTO TB_EMP (EMP_NO, EMP_NAME, GENDER, DEPT_CD, CONTACT)
    (SELECT * FROM TB_EMP_20);

SELECT * FROM TB_EMP;

COMMIT;
DROP TABLE TB_EMP_20;

-- 5. TB_DEPT 테이블에서 10번 부서('인사팀')를 삭제하려고 합니다. 
-- 하지만 현재 10번 부서에는 '홍길동' 사원이 소속되어 있어 외래키 무결성 에러가 발생합니다. 
-- 에러를 내지 않고 10번 부서를 안전하게 삭제하기 위한 SQL을 작성하세요.
--> 1) CASCADE (전체 삭제 -> 부모 테이블 / 자식 테이블)
--> 2) NULL (부모 테이블에서만 삭제하고, 자식 테이블에서는 해당 값을 NULL로 변경)
--      => ON DELETE SET NULL
-- * 외래키 설정 변경 (삭제 -> 생성)
--      1) 삭제
ALTER TABLE TB_EMP DROP CONSTRAINT FK_TE_DCD;
--      2) 생성
ALTER TABLE TB_EMP ADD CONSTRAINT FK_TE_DCD FOREIGN KEY(DEPT_CD) REFERENCES TB_DEPT(DEPT_CD) ON DELETE SET NULL;
--      3) 해당 부서 삭제
DELETE FROM TB_DEPT
WHERE DEPT_CD = 10;


-- 제약 조건 안건들기
UPDATE TB_EMP
SET DEPT_CD = NULL
WHERE DEPT_CD = 10;

DELETE FROM TB_DEPT
WHERE DEPT_CD = 10;

SELECT * FROM TB_EMP;
SELECT * FROM TB_DEPT;

COMMIT;
