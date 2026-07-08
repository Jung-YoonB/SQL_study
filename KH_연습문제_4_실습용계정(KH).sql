-- * KH 실습 문제 * --
-- 1. 인사관리부 부서의 사원들의 사번, 사원명, 보너스 조회
--- > 사원 (EMPLOYEE), 부서(DEPARTMENT)
-- * 오라클 구문 * --
SELECT DEPT_TITLE, EMP_ID, EMP_NAME, BONUS
FROM employee, department
WHERE DEPT_CODE = DEPT_ID
AND DEPT_TITLE = '인사관리부';
            
-- * ANSI 구문 * --
SELECT DEPT_TITLE, EMP_ID, EMP_NAME, BONUS
FROM employee
    JOIN department ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE = '인사관리부';


-- 2. 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회
-- * 부서(DEPARTMENT), 지역(LOCATION)
-- * 오라클 구문 * --
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM department, location
WHERE LOCATION_ID = LOCAL_CODE(+);

-- * ANSI 구문 * --
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM department
    LEFT JOIN location ON LOCATION_ID = LOCAL_CODE;

-- 3. 보너스를 받는 사원의 사번, 사원명, 보너스, 부서명 조회
-- * 사원(EMPLOYEE), 부서(DEPARTMENT)
-- * 오라클 구문 * --
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM employee, department
WHERE BONUS IS NOT NULL
    AND DEPT_CODE = DEPT_ID(+);

-- * ANSI 구문 * --
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM employee
    LEFT JOIN department ON DEPT_CODE = DEPT_ID
WHERE BONUS IS NOT NULL;


-- 4. 총무부가 아닌 사원들의 사원명, 급여 조회
-- * 사원(EMPLOYEE), 부서(DEPARTMENT)
-- * 오라클 구문 * --
SELECT DEPT_TITLE, EMP_NAME, SALARY
FROM employee, department
WHERE (DEPT_TITLE != '총무부' OR DEPT_CODE IS NULL)
    AND DEPT_CODE = DEPT_ID(+);

-- * ANSI 구문 * --
SELECT DEPT_TITLE, EMP_NAME, SALARY
FROM employee
    LEFT JOIN department ON DEPT_CODE = DEPT_ID
WHERE DEPT_TITLE != '총무부' OR DEPT_CODE IS NULL;


-- 5. 사번, 사원명, 부서명, 지역명, 국가명 조회
--- * 사원(employee), 부서(DEPARTMENT), 지역(LOCATION), 국가(NATIONAL)
-- ** 오라클 구문 ** --
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM employee, department, location L, national N
WHERE DEPT_CODE = DEPT_ID
    AND LOCATION_ID = LOCAL_CODE
    AND l.national_code = n.national_code;
    
-- ** ANSI 구문 ** --
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM employee
    JOIN department ON DEPT_CODE = DEPT_ID
    JOIN location ON LOCATION_ID = LOCAL_CODE
    JOIN national USING (national_code);


-- 6. 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회
-- * 사원(EMPLOYEE), 부서(DEPARTMENT), 직급(JOB), 지역(LOCATION), 국가(NATIONAL), 급여등급(SAL_GRADE)
-- ** 오라클 구문 ** --
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
FROM employee E, department, job J, location L, national N, sal_grade
WHERE DEPT_CODE = DEPT_ID
    AND E.JOB_CODE = J.JOB_CODE
    AND LOCATION_ID = LOCAL_CODE
    AND L.NATIONAL_CODE = N.NATIONAL_CODE
    AND SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- ** ANSI 구문 ** --
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
FROM employee
    JOIN department ON DEPT_CODE = DEPT_ID
    JOIN job USING (JOB_CODE)
    JOIN location ON LOCATION_ID = LOCAL_CODE
    JOIN national USING (NATIONAL_CODE)
    JOIN sal_grade ON SALARY BETWEEN MIN_SAL AND MAX_SAL;
        
