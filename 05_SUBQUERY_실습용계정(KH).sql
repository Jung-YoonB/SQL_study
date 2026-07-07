/*
    * 서브쿼리 : 하나의 쿼리문 내에서 사용되는 또 다른 쿼리문
                메인 쿼리문의 조건이나 결과를 위해 먼저 실행되어 값을 제공 (보조 역할)
*/

-- 노옹철 직원과 같은 부서에 속한 직원 정보를 조회

-- 1) 노옹철 직원의 부서코드를 조회
SELECT DEPT_CODE
FROM employee
WHERE EMP_NAME = '노옹철';

-- 2) 부서코드가 D9인 직원들의 정보 조회
SELECT *
FROM employee
WHERE DEPT_CODE = 'D9';

-- 1), 2) 하나로 합쳐보기! => 서브쿼리 적용!
SELECT *
FROM employee
WHERE DEPT_CODE = (
    SELECT DEPT_CODE
    FROM employee
    WHERE EMP_NAME = '노옹철');

-- 전체 직원의 평균 급여보다 더 많은 급여를 받는 직원 정보를 조회

-- 1) 전체직원의 평균 급여 조회
SELECT ROUND(AVG(SALARY))
FROM employee;

-- 2) 평균 급여보다 더 많이 받는 직원 조회
SELECT *
FROM employee
WHERE SALARY > 3047663;

-- 1), 2) 쿼리문을 하나로 합치기!!
SELECT *
FROM employee
WHERE SALARY > (
    SELECT AVG(SALARY)
    FROM employee);
--------------------------------------------------------------------------------
/*
    * 서브 쿼리의 종류 *
        : 서브쿼리를 수행한 결과의 "행"과 "열" 수에 따라 분류
        
        - 단일행 서브쿼리       : 수행 결과가 오로지 1개일 때 (1행 1열)
        - 다중행 서브쿼리       : 수행 결과가 여러 행일 때 (N행 1열)
        - 다중열 서브쿼리       : 수행 결과가 한 행이고, 여러 개의 컬럼일 때 (1행 N열)
        - 다중행 다중열 서브쿼리 : 수행 결과가 여러 행이고, 여러 컬럼일 때 (N행 N열)
        
            => 종류에 따라 서브쿼리 앞에 사용되는 연산자가 달라 질 수 있음!
            
*/

/*
    * 단일행 서브쿼리 => 비교연산자 사용 가능! (=, !=, >, < , >=, <=, ...)
*/
-- 최저 급여를 받는 직원의 이름, 급여, 입사일 조회
-- 1) 최저 급여 조회
SELECT MIN(SALARY)
FROM employee;

-- 2) 최저 급여를 받는 직원 정보 조회
SELECT *
FROM employee
WHERE SALARY = 1380000;

-- * 서브쿼리 적용
SELECT EMP_NAME 이름, SALARY 급여, HIRE_DATE 입사일
FROM employee
WHERE salary = (
    SELECT MIN(SALARY)
    FROM employee);

-- 노옹철 직원보다 급여를 더 많이 받는 직원 정보 조회 (이름, 부서코드, 급여)
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM employee
WHERE SALARY > (
    SELECT SALARY
    FROM employee
    WHERE EMP_NAME = '노옹철');
    
-- -> 부서 코드가 아닌 부서명으로 조회
SELECT EMP_NAME, DEPT_TITLE, SALARY
FROM employee
    JOIN department ON DEPT_CODE = DEPT_ID
WHERE SALARY > (
    SELECT SALARY
    FROM employee
    WHERE EMP_NAME = '노옹철');

-- 부서 별 총 급여 기준으로 가장 큰 부서의 부서코드, 총 급여 조회
-- 1) 부서 별 총 급여가 가장 큰 부서
-- 1-1) 부서별 급여 합
SELECT DEPT_CODE, SUM(SALARY)
FROM employee
GROUP BY DEPT_CODE;

-- 1-2) 급여 합들 중 가장 큰 값
SELECT MAX(SUM(SALARY))
FROM employee
GROUP BY DEPT_CODE;

-- 2) 급여 합이 가장 큰 값인 부서의 부서코드, 급여 합을 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM employee
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17700000;

SELECT DEPT_CODE, SUM(SALARY)
FROM employee
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (
    SELECT MAX(SUM(SALARY))
    FROM employee
    GROUP BY DEPT_CODE);
    
-- 전지연 직원과 같은 부서인 직원들의 직원번호, 직원명, 연락처, 입사일, 부서명을 조회
--    (단, 조회 결과에서 전지연 직원 정보는 제외!)
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
FROM employee
    JOIN department ON DEPT_CODE = DEPT_ID
WHERE DEPT_CODE = (
    SELECT DEPT_CODE
    FROM employee
    WHERE EMP_NAME = '전지연')
    AND EMP_NAME != '전지연';

--------------------------------------------------------------------------------
