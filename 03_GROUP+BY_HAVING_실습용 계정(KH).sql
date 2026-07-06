/*
    * GROUP BY 절 : 그룹 기준을 제시할 수 있는 부분
*/

-- * 전체 직원의 급여 총 합 조회
SELECT SUM(SALARY)
FROM employee;

-- * 부서별 급여 총 합 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM employee
GROUP BY DEPT_CODE;

-- * 부서별 직원 수 조회
SELECT DEPT_CODE, COUNT(*)
FROM employee
GROUP BY DEPT_CODE;

-- * 부서 코드가 D6, D9 ,D1인 각 부서별 급여 총합, 직원 수 조회
SELECT DEPT_CODE, SUM(SALARY), COUNT(*)
FROM employee
WHERE DEPT_CODE IN ('D1', 'D6', 'D9')
GROUP BY DEPT_CODE;

-- * 직급 별 총 직원수, 보너스를 받는 직원수, 급여 총합, 평균 급여, 최저 급여, 최고 급여 조회
--  (직급 코드 오름차순 정렬)
SELECT JOB_CODE, COUNT(*) "총 직원수", COUNT(BONUS) "보너스를 받는 직원 수",
        SUM(SALARY) "급여 총 합", ROUND(AVG(SALARY)) "평균 급여", 
        MIN(SALARY) "최저 급여", MAX(SALARY) "최고 급여"
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

-- * 부서 내 직급별로 직원 수, 급여 총합 조회
SELECT DEPT_CODE, JOB_CODE, COUNT(*) "직원 수", SUM(SALARY) "급여 총합"
FROM employee
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY DEPT_CODE, JOB_CODE;
--------------------------------------------------------------------------------
/*
    * HAVING : 그룹에 대한 조건을 제시할 때 사용하는 부분
*/
-- 각 부서별 평균 급여가 300만원 이상인 부서만 조회
-- 전 직원을 부서별로 묶어서 평균 급여가 300만원 이상인 데이터를 추려내서 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY)) "평균 급여"
FROM employee
GROUP BY DEPT_CODE
HAVING ROUND(AVG(SALARY)) >= 3000000;

-- 직원의 급여가 300만원 이상인 데이텀나 추려내서 조회
SELECT DEPT_CODE, ROUND(AVG(SALARY)) "평균 급여"
FROM employee
WHERE SALARY >= 3000000
GROUP BY DEPT_CODE;

-- 직급 별 급여 총합 조회 (급여 총합이 1000만원 이상인 직급만 조회)
SELECT JOB_CODE, SUM(SALARY) "급여 총 합"
FROM employee
GROUP BY JOB_CODE
HAVING SUM(SALARY) >= 10000000;

-- 부서 별 보너스를 받는 직원이 없는 부서 정보 조회
SELECT DEPT_CODE, COUNT(BONUS)
FROM employee
GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;    -- BONUS 값이 NULL 이면 카운트 안함
