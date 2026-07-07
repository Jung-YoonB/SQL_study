/*
    * JOIN : 여러 개의 테이블을 연결(결합)하여 하나의 가상 테이블처럼 조회하는 구문
*/
-- * 직원 정보 조회 (직원 번호, 이름, 부서코드)
SELECT EMP_ID 직원번호, EMP_NAME 이름, DEPT_CODE 부서코드
FROM employee;

-- * 부서 정보 조회
SELECT DEPT_ID 부서코드, DEPT_TITLE 부서명
FROM department;

-- * 직원 정보 조회 (직원 번호, 이름, 부서명)
/*
    => 등가 조인 / 내부 조인 : 두 테이블의 조인 조건에 해당하는 값들만 결과로 표시
                            즉, 조건에 일치하지 않는 행은 결과에서 제외 됨!
*/
-- * 오라클 전용 구문
/*
    * FROM 절에 조회하고자 하는 테이블 나열 (, 로 구분)
    * WHERE 절에 조인 조건을 작성
*/
-- EMPLOYEE 테이블에서 부서코드(DEPT_CODE) 가 NULL인 직원은 결과에서 제외 됨!
-- DEPARTMENT 테이블에서 D3, D4, D7 부서코드에 해당하는 직원이 EMPLOYEE 테이블에 존재하지 않아 결과에서 제외 됨!
SELECT EMP_ID 직원번호, EMP_NAME 이름, DEPT_TITLE 부서명
FROM employee E, department D
WHERE E.DEPT_CODE = D.DEPT_ID;

-- * 직원 번호, 이름, 직급명 조회
SELECT JOB_CODE 직급코드, JOB_NAME 직급명
FROM JOB;

SELECT EMP_ID 직원번호, EMP_NAME 이름, JOB_CODE 직급코드
FROM employee;

-- 컬럼명이 동일 할 경우 테이블을 명시 해줘야 함!
-- 테이블에 별칭 부여
SELECT EMP_ID 직원번호, EMP_NAME 이름, JOB_NAME 직급명
FROM employee E, job J
WHERE E.JOB_CODE = J.JOB_CODE;

-- * ANSI 구문 *
/*
    * FROM 절에 기준이 되는 테이블을 작성
    * JOIN 절에 연결하고자 하는 테이블을 작성 + JOIN 조건을 작성
        - USING     : 컬럼명이 동일한 경우 
        - ON        : 컬럼명이 동일하거나 다른 경우
*/
-- * 직원 번호, 이름, 부서명 조회
SELECT EMP_ID 직원번호, EMP_NAME 이름, DEPT_TITLE 부서명
FROM employee E
    JOIN department D ON E.DEPT_CODE = D.DEPT_ID;
    
-- * 직원번호, 이름, 직급명 조회
SELECT EMP_ID 직원번호, EMP_NAME 이름, JOB_NAME 직급명
FROM employee
    JOIN job USING (JOB_CODE);
    
SELECT EMP_ID 직원번호, EMP_NAME 이름, JOB_NAME 직급명
FROM employee E
    JOIN job J ON E.JOB_CODE = J.JOB_CODE;
--------------------------------------------------------------------------------
/*
    * 포괄 조인 / 외부 조인 (OUTER JOIN)
        : 두 테이블을 조인할 때, 조인 조건에 맞지 않는 행도 결과에 포함하는 구문
        
        - LEFT OUTER JOIN   : 두 테이블 중 왼쪽에 작성 된 테이블을 기준으로 조인
                               (왼쪽 테이블의 모든 행 + 조건에 맞는 오른쪽 테이블 행)
                                    조건에 맞지 않으면 NULL 값 표시
        - RIGHT OUTER JOIN  : 두 테이블 중 오른쪽에 작성 된 테이블을 기준으로 조인
                                (오른쪽 테이블의 모든 행 + 조건에 맞는 왼쪽 테이블 행)
                                    조건에 맞지 않으면 NULL 값 표시
        - FULL OUTER JOIN   : 두 테이블이 가진 모든 행을 조회하는 구문 (오라클 전용 구문 X)
*/
-- ** LEFT JOIN **
-- * 오라클 구문 
-- => 추가로 연결되는 테이블에 해당하는 컬럼 옆에 (+) 기호를 붙여 표현
-- * 이름, 부서명, 급여 정보 조회 (모든 직원 정보를 조회)
SELECT EMP_NAME 이름, DEPT_TITLE 부서명, SALARY 급여
FROM employee E, department D
WHERE E.DEPT_CODE = D.DEPT_ID(+);

-- * ANSI 구문
SELECT EMP_NAME 이름, DEPT_TITLE 부서명, SALARY 급여
FROM employee E
    LEFT JOIN department D ON E.DEPT_CODE = D.DEPT_ID;

-- ** RIGHT JOIN
-- * 오라클 구문
-- 이름, 부서명, 급여 조회 (모든 부서 정보 조회)
SELECT EMP_NAME 이름, DEPT_TITLE 부서명, SALARY 급여
FROM employee E, department D
WHERE E.DEPT_CODE(+) = D.DEPT_ID;

-- * ANSI 구문
SELECT EMP_NAME 이름, DEPT_TITLE 부서명, SALARY 급여
FROM employee E
    RIGHT JOIN department D ON E.DEPT_CODE = D.DEPT_ID;

-- ** FULL OUTER JOIN
-- * 오라클 구문 없음!!
-- * ANSI 구문
-- 이름, 부서명, 급여 조회 (모든 직원, 모든 부서 조회)
SELECT EMP_NAME 이름, DEPT_TITLE 부서명, SALARY 급여
FROM employee E
    FULL JOIN department D ON E.DEPT_CODE = D.DEPT_ID;
--------------------------------------------------------------------------------
/*
    * 비등가 조인 (NON EQUAL JOIN)
        : 조인 조건에 '=' EOTLS, >, <, BETWEEN, LIKE 등의 비교 연산자를 사용하여 매칭하는 조인
            (주로, 범위 조건으로 매칭할 때 사용)
            
    * ANSI 구문에서는 JOIN ON만 사용 가능!
*/
-- 직원에 대한 급여 등급 조회 (이름, 급여, 등급)
-- * 오라클 구문
SELECT EMP_NAME 이름, SALARY 급여, SAL_LEVEL 등급
FROM employee E, sal_grade SG
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- * ANSI 구문
SELECT EMP_NAME 이름, SALARY 급여, SAL_LEVEL 등급
FROM employee E
    JOIN sal_grade SG ON SALARY BETWEEN MIN_SAL AND MAX_SAL;
--------------------------------------------------------------------------------
/*
    * 자체 조인 / 셀프 조인
        : 하나의 테이블을 마치 서로 다른 테이블처럼 별칠을 주어 조인하는 구문
*/
-- * 전체 직원의 직원번호, 이름, 부서코드, 사수 직원번호, 사수명, 사수 부서코드 조회
-- 직원 정보 => EMPLOYEE / 사수 직원 정보 => EMPLOYEE
-- * 오라클 구문
SELECT E.EMP_ID 직원번호, E.EMP_NAME 이름, E.DEPT_CODE 부서코드,
        M.EMP_ID "사수 직원번호", M.EMP_NAME 사수명, M.DEPT_CODE "사수 부서코드"
FROM employee E, employee M
WHERE E.MANAGER_ID = M.EMP_ID;

-- * ANSI 구문
SELECT E.EMP_ID 직원번호, E.EMP_NAME 이름, E.DEPT_CODE 부서코드,
        M.EMP_ID "사수 직원번호", M.EMP_NAME 사수명, M.DEPT_CODE "사수 부서코드"
FROM employee E
   JOIN employee M ON E.MANAGER_ID = M.EMP_ID;
   
-- ** 사수가 없는 직원도 조회 (결과 행: 23)
-- * 오라클 구문
SELECT E.EMP_ID 직원번호, E.EMP_NAME 이름, E.DEPT_CODE 부서코드,
        M.EMP_ID "사수 직원번호", M.EMP_NAME 사수명, M.DEPT_CODE "사수 부서코드"
FROM employee E, employee M
WHERE E.MANAGER_ID = M.EMP_ID(+);

-- * ANSI 구문
SELECT E.EMP_ID 직원번호, E.EMP_NAME 이름, E.DEPT_CODE 부서코드,
        M.EMP_ID "사수 직원번호", M.EMP_NAME 사수명, M.DEPT_CODE "사수 부서코드"
FROM employee E
   LEFT JOIN employee M ON E.MANAGER_ID = M.EMP_ID;
--------------------------------------------------------------------------------
/*
    * 다중 조인 : 2개 이상의 테이블을 조인하는 것
*/
-- * 직원 번호, 직원명, 부서명, 직급명 조회
-- * 오라클 구문
SELECT EMP_ID 직원번호, EMP_NAME 직원명, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM employee E, department D, job J
WHERE E.DEPT_CODE = D.DEPT_ID
    AND E.JOB_CODE = J.JOB_CODE
ORDER BY 직원번호;

-- * ANSI 구문
SELECT EMP_ID 직원번호, EMP_NAME 직원명, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM employee E
    JOIN department D ON E.DEPT_CODE = D.DEPT_ID
    JOIN job J ON E.JOB_CODE = J.JOB_CODE
ORDER BY 직원번호;

SELECT EMP_ID 직원번호, EMP_NAME 직원명, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM employee
    JOIN department ON DEPT_CODE = DEPT_ID
    JOIN job USING (JOB_CODE)
ORDER BY 직원번호;

-- * 직원번호, 직원명, 부서명, 지역명 조회
-- * 오라클 구문
SELECT EMP_ID 직원번호, EMP_NAME 이름, DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM employee E, department D, location L
WHERE D.LOCATION_ID = L.LOCAL_CODE
    AND E.DEPT_CODE = D.DEPT_ID(+);

-- * ANSI 구문
SELECT EMP_ID 직원번호, EMP_NAME 이름, DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM department
    JOIN location ON LOCATION_ID = LOCAL_CODE
    RIGHT JOIN employee ON DEPT_CODE = DEPT_ID;
    
SELECT EMP_ID 직원번호, EMP_NAME 이름, DEPT_TITLE 부서명, LOCAL_NAME 지역명
FROM employee
    LEFT JOIN department ON DEPT_CODE = DEPT_ID
    LEFT JOIN location ON LOCATION_ID = LOCAL_CODE;
