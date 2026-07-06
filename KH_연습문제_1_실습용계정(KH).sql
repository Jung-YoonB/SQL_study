-- ** KH_연습문제 **
-- 1. JOB 테이블의 모든 정보 조회
SELECT *
FROM job;

-- 2. JOB 테이블의 직급 이름 조회
SELECT JOB_NAME "직급 이름"
FROM job;

-- 3. DEPARTMENT 테이블의 모든 정보 조회
SELECT *
FROM department;

-- 4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회
SELECT EMP_NAME 직원명, EMAIL 이메일, PHONE 전화번호, HIRE_DATE 고용일
FROM employee;

-- 5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
SELECT HIRE_DATE 고용일, EMP_NAME "사원 이름", SALARY 월급
FROM employee;

-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회
SELECT EMP_NAME 이름, SALARY*12 연봉, (SALARY+SALARY*BONUS)*12 "총수령액(보너스포함)",
(SALARY+SALARY*BONUS)*12 - SALARY*12*0.03 실수령액
FROM employee;
            
-- 7. EMPLOYEE테이블에서 급여가 600만원 이상 1000만원 이하인 사원의 이름, 월급, 고용일, 연락처 조회
SELECT EMP_NAME 이름, SALARY 월급, HIRE_DATE 고용일, PHONE 연락처
FROM employee
WHERE SALARY BETWEEN 6000000 AND 10000000;

-- 8. EMPLOYEE테이블에서 실수령액(6번 참고)이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
SELECT EMP_NAME 이름, SALARY 월급, (SALARY+SALARY*BONUS)*12 - SALARY*12*0.03 실수령액,
HIRE_DATE 고용일
FROM employee
WHERE (SALARY+SALARY*BONUS)*12 - SALARY*12*0.03 >= 50000000;

-- 9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
SELECT *
FROM employee
WHERE SALARY >= 4000000 AND JOB_CODE = 'J2';

-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 
--     고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
SELECT EMP_NAME 이름, DEPT_CODE 부서코드, HIRE_DATE 고용일
FROM employee
WHERE DEPT_CODE IN ('D5', 'D9') AND HIRE_DATE < '02/01/01';

-- 11. EMPLOYEE테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용을 조회
SELECT *
FROM employee
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';

-- 12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
SELECT EMP_NAME 이름
FROM employee
WHERE EMP_NAME LIKE '%연';

-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
SELECT EMP_NAME 이름, PHONE 전화번호
FROM employee
WHERE NOT PHONE LIKE '010%';

-- 14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 
--     고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회
SELECT *
FROM employee
WHERE EMAIL LIKE '____#_%' ESCAPE '#'
	AND DEPT_CODE IN ('D6', 'D9')
	AND HIRE_DATE BETWEEN '90/01/01' AND '00/12/01'
	AND SALARY >= 2700000; 
