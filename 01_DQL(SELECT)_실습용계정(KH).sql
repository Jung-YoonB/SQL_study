/*
    * SELECT : 데이터 조회(추출)
    
    SELECT 조회하고자 하는 정보(컬럼)
    FROM 테이블명;
*/

-- EMPLOYEE : 직원 테이블
-- * 모든 직원의 정보를 조회
SELECT *
FROM employee;

-- JOB : 직급 테이블
-- * 모든 직급 정보를 조회
SELECT *
FROM job;

-- DEPARTMENT : 부서 테이블
-- * 모든 부서 정보를 조회
SELECT *
FROM department;


-- 모든 직원의 이름, 주민번호, 연락처를 조회
SELECT EMP_NAME 이름, EMP_NO 주민번호, PHONE 연락처
FROM employee;

-- 모든 직원의 이름, 이메일, 연락처, 입사일, 급여 정보를 조회
SELECT EMP_NAME 이름, EMAIL 이메일, PHONE 연락처, HIRE_DATE 입사일, SALARY 급여
FROM employee;
-- ==========================================================================
/*
    컬럼 값에 산술 연산을 적용하여 조회
*/
-- 직원 정보 중 직원명, 급여 정보를 조회
SELECT EMP_NAME 직원명, SALARY 급여
FROM employee;

-- 직원명, 연봉 정보를 조회
-- 연봉 => 급여 * 12
SELECT EMP_NAME 직원명, SALARY*12 연봉
FROM employee;

-- 직원명, 급여, 보너스, 연봉, 보너스 포함 연봉 정보 조회
--      보너스 포함 연봉 => (급여 + (보너스*급여)) * 12
SELECT EMP_NAME 직원명, SALARY 급여, BONUS 보너스, SALARY*12 연봉,
(SALARY + (SALARY*BONUS))*12 "보너스 포함 연봉"
FROM employee;
-- ===========================================================================
/*
     현재 날짜 시간 정보 : SYSDATE
     임시 테이블 : DUAL
*/
SELECT SYSDATE
FROM DUAL;
-- ===========================================================================

-- 근무 일수 조회
SELECT EMP_NAME 직원명, HIRE_DATE 입사일, SYSDATE-HIRE_DATE+1 근무일수
FROM employee;
-- => 날짜데이터 - 날짜데이터 : 일(DAY)로 계산됨!

--============================================================================
/*
    리터럴 : 값 자체
    - 문자 데이터 => 작은 따옴표로 표시 ('값')
    - 숫자 데이터 => 숫자만 표시

    => SELECT 절에서 사용할 경우 조회 된 결과(RESULT SET)에 반복적으로 표시 됨
*/
-- 직원명, 급여 조회( 급여를 'XXXX원' 형식으로 조회)
SELECT EMP_NAME 직원명, SALARY || '원' 급여
FROM employee;

-- 직원 정보 조회 ( (직원번호)(직원명)(급여) 형식으로 조회)
SELECT EMP_ID || EMP_NAME || SALARY "(직원번호)(직원명)(급여)"
FROM employee;

-- (직원명)의 급여는 (급여)원 입니다. 형식으로 조회
SELECT EMP_NAME || '의 급여는 ' || SALARY || '원 입니다.'
FROM employee;

-- ===========================================================================
-- 직원 정보 중 직급 코드를 조회
SELECT JOB_CODE 직급코드
FROM employee;

/* 중복 데이터 제거 : DISTINCT
    => 중복되는 데이터가 있을 경우 중복을 제거하여 결과로 표시해줌
*/
SELECT DISTINCT JOB_CODE 직급코드
FROM employee;

-- 부서 코드, 직급 코드를 중복 제거한 상태로 조회 (부서별 직급 현황)
SELECT DISTINCT DEPT_CODE 부서코드, JOB_CODE 직급코드
FROM employee;
-- => (DEPT_CODE, JOB_CODE) 한 쌍으로 해서 중복을 제거해줌!
/*
SELECT DISTINCT DEPT_CODE 부서코드, DISTINCT JOB_CODE 직급코드
FROM employee;

*/ -- => DISTINCT 는 한 번만 사용 가능!!
-- ===========================================================================
/*
    * 조건절 => WHERE 
                  : 조회하고자 하는 데이터를 특정 조건에 따라 추출하여 조회할 때 사용
    
    SELECT 컬럼정보, 연산식
    FROM 테이블명
    WHERE 조건;
*/

/*
    * 비교 연산자 : 동등 비교 / 대소 비교
        - 동등 비교 : 같은지 (=), 다른지 (!= , <>)
        - 대소 비교 : >, <, >=, <=
*/
-- 직원 중 부서코드가 D1인 직원들의 직원명, 급여, 부서코드 조회
SELECT EMP_NAME 직원명, SALARY 급여, DEPT_CODE 부서코드
FROM employee
WHERE DEPT_CODE = 'D1';

-- 직원 중 부서코드가 D1이 아닌 직원들의 정보 조회 (이름, 급여, 부서코드)
SELECT EMP_NAME 직원명, SALARY 급여, DEPT_CODE 부서코드
FROM employee
WHERE DEPT_CODE != 'D1'
-- WHETE DEPT_CODE <> 'D1';
ORDER BY DEPT_CODE, SALARY DESC;

-- 급여가 400만원 이상인 직원의 직원명, 부서코드, 급여 조회
SELECT EMP_NAME 직원명, DEPT_CODE 부서코드, SALARY 급여
FROM employee
WHERE SALARY >= 4000000
ORDER BY SALARY DESC;

-- 연봉이 3000만원 이상인 직원의 직원명, 부서코드, 급여, 연봉 조회
SELECT EMP_NAME AS "직원명", DEPT_CODE "부서코드", SALARY AS 급여, SALARY*12 연봉
FROM employee
WHERE (SALARY*12) >= 30000000
ORDER BY 연봉 DESC;

-- ===========================================================================
-- /* -------------- 실습 문제 -------------- */ --
-- * 연봉 계산 시 보너스 제외 *
-- * 별칭 반드시 적용 *

-- 1. 급여가 300만원 이상인 직원들의 직원명, 급여, 입사일, 연봉 조회
SELECT EMP_NAME 직원명, SALARY 급여, HIRE_DATE 입사일, SALARY*12 연봉
FROM employee
WHERE SALARY >= 3000000
ORDER BY HIRE_DATE, SALARY DESC;

-- 2. 연봉이 5000만원 이상인 직원들의 직원명, 급여, 연봉, 부서코드 조회
SELECT EMP_NAME 직원명, SALARY 급여, SALARY*12 연봉, DEPT_CODE 부서코드
FROM employee
WHERE (SALARY*12) >= 50000000;

-- 3. 직급코드가 J3이 아닌 직원들의 직원번호, 직원명, 직급코드, 퇴사여부 조회
SELECT EMP_ID 직원번호, EMP_NAME 직원명, JOB_CODE 직급코드, ENT_YN 퇴사여부
FROM employee
WHERE JOB_CODE != 'J3'
ORDER BY JOB_CODE;

-- 4. 급여가 350만원 이상이고 600만원 이하인 모든 직원의 직원번호, 직원명, 급여 조회
-- * 논리 연산자 : AND OR
SELECT EMP_ID 직원번호, EMP_NAME 직원명, SALARY 급여
FROM employee
WHERE SALARY BETWEEN 3500000 AND 6000000
-- WHERE (SALARY >= 3500000) AND (SALARY <= 6000000);
ORDER BY SALARY DESC; 
-- ===========================================================================
/*
    BETWEEN A AND B : A 이상 B 이하 범위의 조건을 제시할 때 사용
    
        비교대상_컬럼 BETWEEN 최소값 AND 최대값
        => 비교대상_컬럼 >= 최소값 AND 비교대상_컬럼 <= 최대값
*/

/*
    NOT : 논리 부정 연산자
*/

-- 급여가 350 미만 또는 600만원 초과인 직원의 정보 조회 (직원번호, 직원명, 급여)
SELECT EMP_ID 직원번호, EMP_NAME 직원명, SALARY 급여
FROM employee
WHERE NOT SALARY BETWEEN 3500000 AND 6000000
ORDER BY SALARY DESC;
-- WHERE SALARY < 3500000 OR SALARY 6000000;

/*
    IN : 제시한 값들 중에 일치하는 값이 하나라도 있는 경우 선택(조회)
    
        비교대상_컬럼 IN (값1, 값2, 값3, ...)
*/

-- 부서코드가 D6 이거나, D8 이거나, D5 인 직원 정보 조회 (직원명, 부서코드, 급여)
SELECT EMP_NAME 직원명, DEPT_CODE 부서코드, SALARY 급여
FROM employee
WHERE DEPT_CODE IN ('D5', 'D6', 'D8')
-- WHERE DEPT_CODE = 'D5' OR DEPT_CODE = 'D6' OR DEPT_CODE = 'D8'
ORDER BY DEPT_CODE, SALARY DESC;
-- ===========================================================================
/*
    LIKE : 제시한 특정 패턴을 만족하는 경우 선택(조회)
    
        비교대상_컬럼 LIKE '패턴'
        
        => '패턴' 내에 와일드 카드(%, _) 사용
        
        * % : 0글자 이상
            EX) 비교대상_컬럼 LIKE '문자%' : '문자'로 "시작" 되는 것을 조회
                비교대상_컬럼 LIKE '%문자' : '문자'로 "끝" 나는 것을 조회
                비교대상_컬럼 LIKE '%문자%' : '문자'가 "포함"되는 것을 조회 (키워드 검색)
                
        * _ : 1글자
            EX) 비교대상_컬럼 LIKE '_문자' : '문자' 앞에 무조건 한글자가 있는 경우 조회
                비교대상_컬럼 LIKE '__문자' : '문자' 앞에 무조건 두글자가 있는 경우 조회
                비교대상_컬럼 LIKE '_문자_' : '문자' 앞, 뒤로 무조건 한글자씩 있는 경우 조회
*/
-- * 직원들 중 성이 전씨인 직원의 이름과 급여 조회
SELECT EMP_NAME 이름, SALARY 급여
FROM employee
WHERE EMP_NAME LIKE '전%';

-- * 직원 이름에 '하'가 포함된 직원의 이름, 연락처 조회
SELECT EMP_NAME 이름, PHONE 연락처
FROM employee
WHERE EMP_NAME LIKE '%하%';

-- * 직원의 연락처 정보에서 세번째 자리가 1인 직원 정보 조회 (이름, 연락처)
SELECT EMP_NAME 이름, PHONE 연락처
FROM employee
WHERE PHONE LIKE '__1%';

-- * 직원 이메일 정보에서 4번째 자리가 _인 직원 정보 조회(직원번호, 이름, 이메일)
SELECT EMP_ID 직원번호, EMP_NAME 이름, EMAIL 이메일
FROM employee
WHERE EMAIL LIKE '___#_%' ESCAPE '#';
-- ===========================================================================
/*
    IS NULL / IS NOT NULL
        : 컬럼 값에 NULL이 있을 경우 NULL 값을 비교할 때 사용하는 연산자
        
        대상컬럼 IS NULL => 컬럼의 값이 NULL인 행을 선택(조회)
        대상컬럼 IS NOT NULL => 컬럼의 값이 NULL이 아닌 행만 선택(조회)
*/
-- 보너스(BONUS) 를 받는 직원 조회 => NULL 값이 아닌 직원만 조회
SELECT EMP_NAME 이름, BONUS 보너스
FROM employee
WHERE BONUS IS NOT NULL;

-- 보너스를 받지 않는 직원 조회
SELECT EMP_NAME 이름, BONUS 보너스
FROM employee
WHERE BONUS IS NULL;

-- 사수(MANAGER_ID) 가 없는 직원 조회 (직원번호, 이름, 사수번호)
SELECT EMP_ID 직원번호, EMP_NAME 이름, MANAGER_ID 사수번호
FROM employee
WHERE MANAGER_ID IS NULL;

-- 부서 배치를 받지는 않았지만, 보너스를 받고 있는 직원 조회 (직원명, 보너스, 부서코드)
SELECT EMP_NAME 이름, BONUS 보너스, DEPT_CODE 부서코드
FROM employee
WHERE BONUS IS NOT NULL AND DEPT_CODE IS NULL;
-- ===========================================================================
/*
    * 연산자 우선순위 *
    [0] ( )
    [1] 산술 연산자 : *, /, +, -
    [2] 연결 연산자 : ||
    [3] 비교 연산자 : >, <, >=, <=, =, !=, <>
    [4] IS NULL / LIKE '패턴' / IN
    [5] BETWEEN A AND B
    [6] NOT
    [7] AND
    [8] OR
*/
--* 직급 코드가 J7 이거나 J2 인 직원들 중 급여가 200만원 이상인 직원 조회(모든 정보)
SELECT *
FROM employee
WHERE SALARY >= 2000000 AND JOB_CODE IN('J2' , 'J7');
-- ===========================================================================
/*
    ORDER bY : SELECT 문의 가장 마지막 부분에 작성, 실행 순서도 마지막에 실행!
    
    SELECT 조회할 컬럼, ... 
    FROM 테이블명
    WHERE 조건
    ORDER BY 정렬_기준이_되는_컬럼 정렬_방식 NULL에_대한_옵션
    
    * 정렬 기준이 되는 컬럼 : 컬럼명, 별칭, 컬럼 순번(SELECT 절에 나열한 순서번호)
    * 정렬 방식 : 
            - ASC : 오름차순 정렬 (기본값)
            - DESC : 내림차순 정렬
    * NULL에 대한 옵션 : 
            - NULLS FIRST : 
                    정렬하고자 하는 컬럼의 값이 NULL인 경우 해당 데이터를 맨 앞에 위치 (DESC인 경우 기본값)
            - NULLS LAST : 
                    정렬하고자 하는 컬럼의 값이 NULL인 경우 해당 데이터를 맨 뒤에 위치 (ASC인 경우 기본값)
            
*/
-- 모든 직원의 직원명, 연봉 조회 (연봉 내림차순 정렬)
SELECT EMP_NAME 직원명, SALARY*12 연봉
FROM employee
-- ORDER BY SALARY*12 DESC;     -- 연산식(컬럼)
-- ORDER BY 연봉 DESC;            -- 별칭
ORDER BY 2 DESC;                -- 컬럼 순번

-- 보너스 내림차순 정렬 (모든 정보)
SELECT *
FROM employee
-- ORDER BY BONUS DESC; -- DESC => NULL 에 대한 처리 : NULLS FIRST
ORDER BY BONUS DESC NULLS LAST, SALARY DESC;
-- => 보너스율이 높은 순서로 조회하되, 동일한 값이면 급여 기준으로 내림차순 정렬
