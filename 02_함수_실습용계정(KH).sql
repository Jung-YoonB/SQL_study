/*
    * 함수 (FUNCTION) : 전달된 값(컬럼값)을 실행한 결과를 반환
    
    - 단일 행 함수 : N 개의 값을 읽어서 N개의 결과값으로 반환
            => 행마다 함수의 실행한 결과를 반환
    - 그룹 함수   : N 개의 값을 읽어서 1개의 결과값으로 반환
            => 그룹을 지어 그룹 별로 함수의 결과를 반환
            
    => 함수식을 사용할 수 있는 위치 : SELECT 절, WHERE 절, ORDER BY 절, GROUP BY절, HAVING 절
    
    => SELECT 절에 단일 행 함수와 그룹 함수를 함께 사용할 수 없음!!
    
*/
-- ======================= 단일 행 함수 ======================= 
/*
    * 문자 타입의 데이터 처리 함수 *
        
        - 문자 타입 : CHAR, VARCHAR2
        
            * LENGTH(값) : 값의 길이를 반환 (글자수)
            * LENGTHB(값) : 값의 바이트수를 반환
            
            => 영문자, 숫자, 특수문자 글자당 1 BYTE, 한글은 3 BYTE
*/
-- 오라클 이라는 단어의 글자수, 바이트 수를 확인
SELECT LENGTH('오라클') 글자수, LENGTHB('오라클') 바이트수
FROM DUAL;

SELECT LENGTH('ORACLE') 글자수, LENGTHB('ORACLE') 바이트수
FROM DUAL;

-- 직원명, 직원명(글자수), 직원명(바이트순), 이메일, 이메일(글자수), 이메일(바이트수) 조회
SELECT EMP_NAME "직원명", LENGTH(EMP_NAME) "직원명(글자수)", LENGTHB(EMP_NAME) "직원명(바이트순)",
EMAIL "이메일", LENGTH(EMAIL) "이메일(글자수)", LENGTHB(EMAIL) "이메일(바이트수)"
FROM employee;
-- ===========================================================================
/*
    *INSTR : 문자열로부터 특정 문자의 시작 위치를 반환
        
        INSTR(문자열, '특정문자'[, 찾을 위치의 시작값, 순번]) => 결과는 숫자 타입
*/

-- 앞에서 부터 첫번째 B의 위치 : 3
SELECT INSTR('AABAACAABBAA', 'B')
FROM DUAL;

-- 찾을 위치의 시작값을 1로 지정 => 결과는 위와 동일
SELECT INSTR('AABAACAABBAA', 'B', 1)
FROM DUAL;

-- 시작값을 음수로 지정하면 뒤에서부터 찾음!
SELECT INSTR('AABAACAABBAA', 'B', -1)
FROM DUAL;

-- 앞에서부터 두번째로 찾은 위치
SELECT INSTR('AABAACAABBAA', 'B', 1, 2)
FROM DUAL;

-- 뒤에서부터 두번째로 찾은 위치
SELECT INSTR('AABAACAABBAA', 'B', -1, 2)
FROM DUAL;

-- 직원 정보 중 이메일의 '_'의 첫번째 위치, @의 첫번째 위치 조회
SELECT EMAIL 이메일, INSTR(EMAIL, '_') "_의 첫번째 위치", INSTR(EMAIL, '@') "@의 첫번째 위치"
FROM EMPLOYEE;
-- ============================================================================
/*
    SUBSTR : 문자열에서 특정 문자열을 추출해서 반환 => 결과는 문자 타입
    
        SUBSTR(문자열, 시작위치[, 길이])
            => 길이를 지정하지 않으면 문자열 끝까지 추출함!
*/

SELECT SUBSTR('ORACLE SQL DEVELOPER', 10)
FROM DUAL;

-- SQL 부분만 추출 // 8번위치부터 3글자
SELECT SUBSTR('ORACLE SQL DEVELOPER', 8, 3)
FROM DUAL;

-- 끝에서 3번째 위치부터 문자열 끝까지 추출!
SELECT SUBSTR('ORACLE SQL DEVELOPER', -3)
FROM DUAL;

-- 직원들의 이름, 주민번호 조회
SELECT EMP_NAME 이름, EMP_NO 주민번호
FROM EMPLOYEE;

-- 여직원 정보만 조회
SELECT EMP_NAME 이름, EMP_NO 주민번호
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

-- 남직원 정보만 조회 (이름 가나다 순으로 정렬)
SELECT EMP_NAME 이름, EMP_NO 주민번호
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3')
ORDER BY 이름;

-- 직원 정보를 조회(이름, 이메일, 아이디)
-- * 함수를 중첩해서 사용 *
-- [1] 이메일에서 @ 위치를 찾기 => INSTR
-- [2] 이메일에서 첫번째 위치부터 @ 위치까짐나 추출 => SUBSTR
SELECT EMP_NAME 이름, EMAIL 이메일, SUBSTR(EMAIL, 1,(INSTR(EMAIL, '@')-1)) 아이디
FROM EMPLOYEE;
-- ===========================================================================
/*
    *LPAD / RPAD : 문자열을 조회할 때 통일감있게 조회하고자 할 때 사용
        문자열에 덧붙이고자 하는 문자를 왼쪽 또는 오른쪽에 붙여서 최종 길이만큼 문자열을 반환
        => 결과는 문자 타입
        
        LPAD(문자열, 최종길이, 덧붙일 문자) -> 왼쪽에 덧붙일 문자를 채움
        RPAD(문자열, 최종길이, 덧붙일 문자) -> 오른쪽에 덧붙일 문자를 채움
            => 덧붙일 문자가 생략일 경우 공백으로 채움!
*/

SELECT EMP_NAME 이름, LPAD(EMP_NAME,20) "공백+이름"
FROM employee;

SELECT EMP_NAME 이름, RPAD(EMP_NAME,20) "이름+공백"
FROM employee;

-- 이메일
SELECT EMAIL 이메일, LPAD(EMAIL, 20) "공백+이메일"
FROM employee;

-- 주민번호 뒷자리를 숨겨서 조회
SELECT RPAD('050706-3', 14, '*')
FROM DUAL;

-- 직원 정보 중 주민번호 뒷자리흫 *로 표시하여 조회(이름, 주민번호)
-- [1] 주민번호에서 8자리를 추출 (XXXXXX-X)
-- [2] 나머지 길이만큼은 *로 채움
SELECT EMP_NAME 이름, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*') 주민번호
FROM employee;
-- ===========================================================================
/*
    * LTRIM / RTRIM : 문자열에서 특정 문자를 제거한 후 나머지 반환
                        => 결과는 문자 타입
        
        LTRIM(문자열[, 제거하고자 하는 문자들]) => 왼쪽에서 제거
        RTRIM(문자열[, 제거하고자 하는 문자들]) => 오른쪽에서 제거
            => 제거할 문자 생략 시 공백을 제거함!
*/
-- 왼쪽 공백들이 모두 제거!
SELECT LTRIM('       H I')
FROM DUAL;

-- 오른쪽 공백들이 모두 제거! 
SELECT RTRIM('       H I      ')
FROM DUAL;

SELECT LTRIM ('123123H123', '123') 
FROM DUAL;
SELECT LTRIM ('123123H123', '321') 
FROM DUAL;

SELECT RTRIM ('123123H123', '321') 
FROM DUAL;
SELECT RTRIM ('123123H123', '123') 
FROM DUAL;
SELECT RTRIM ('123123H123', '213') 
FROM DUAL;

/*
    * TRIM : 문자열 앞/뒤/양쪽에 있는 지정한 문자들을 제거한 후 반환
                => 결과는 문자타입
        
        TRIM([READIMG 또는 TRAILING 또는 BOTH] [제거할 문자 FROM] 문자열)
            => 제거할 문자 생략 시 공백 제거
            => 위치 옵션 생략 시 양쪽에서 제거
*/

SELECT TRIM('       H I      ') 값
FROM DUAL;

SELECT TRIM('L' FROM 'LLLLLHLLLLL')
FROM DUAL;

-- LTRIM 과 유사함!
SELECT TRIM(LEADING 'L' FROM 'LLLLLHLLLLL')
FROM DUAL;

-- RTRIM 과 유사함!
SELECT TRIM(TRAILING 'L' FROM 'LLLLLHLLLLL')
FROM DUAL;

SELECT TRIM(BOTH 'L' FROM 'LLLLLHLLLLL')
FROM DUAL;
--------------------------------------------------------------------------------
/*
    * LOWER / UPPER / INITCAP
    
        LOWER(문자열) : 알파벳을 모두 소문자로 변환
        UPPER(문자열) : 알파벳을 모두 대문자로 변환
        INITCAP(문자열) : 공백(띄어쓰기)를 기준으로 첫 글자마다 대문자로 변경해서 반환
*/
-- No pain, no Gain.
SELECT LOWER('No pain, no Gain.')
FROM DUAL;

SELECT UPPER('No pain, no Gain.')
FROM DUAL;

SELECT INITCAP('No pain, no Gain.')
FROM DUAL;
--------------------------------------------------------------------------------
/*
    * CONCAT : 문자열 두 개를 하나의 문자열로 합쳐서 반환
    
        CONCAT(문자열1, 문자열2)
*/
SELECT 'KH' || ' C 강의장'
FROM DUAL;

SELECT CONCAT('KH', ' C 강의장')
FROM DUAL;

SELECT CONCAT('2층 ', CONCAT('KH', ' C 강의장'))
FROM DUAL;

-- 직원 정보를 조회 (* 출력 형식 : (직원번호)(직원명)님)
SELECT CONCAT(EMP_ID, CONCAT(EMP_NAME, '님')) 직원정보
FROM employee;
--------------------------------------------------------------------------------
/*
    * REPLACE : 문자열에서 특정 부분을 다른 값으로 교체하여 반환
    
        REPLACE(문자열, 특정부분(문자열), 교체할 값(문자열))
*/
SELECT REPLACE('서울시 강남구 역삼동', '역삼동', '삼성동')
FROM DUAL;

-- 직원들의 이메일에서 '@kh.or.kr' 부분을 '@gmail.com' 으로 변경하여 조회(이메일, 변경 된 이메일)
SELECT EMAIL 이메일, REPLACE(EMAIL, SUBSTR(EMAIL, INSTR(EMAIL, '@')), '@gmail.com') "변경 된 이메일"
FROM employee;
--------------------------------------------------------------------------------
/*
    * 숫자 타입의 데이터 처리 함수 *
*/
/*
    * ABS : 숫자의 절대값을 반환
         ABS(숫자)
*/
SELECT ABS(-10)
FROM DUAL;

SELECT ABS(-12.34)
FROM DUAL;
SELECT ABS(12.34)
FROM DUAL;
--------------------------------------------------------------------------------
/*
    * MOD : 두 수를 나눈 나머지 값을 구해주는 함수
    
    MOD(숫자1, 숫자2) => 숫자1 % 숫자2
*/
SELECT MOD(10, 3)
FROM DUAL;

SELECT MOD(10.9, 3)
FROM DUAL;
--------------------------------------------------------------------------------
/*
    * ROUND : 반올림한 결과를 반환
    
        ROUND(숫자[, 위치]) 
            => 위치 생략 시 소수점 첫째 자리에서 반올림
*/
-- 123
SELECT ROUND(123.456)
FROM DUAL;

--123.5
SELECT ROUND(123.456, 1)
FROM DUAL;

-- 123.46
SELECT ROUND(123.456, 2)
FROM DUAL;

-- 120 일의 자리에서 반올림
SELECT ROUND(123.456, -1)
FROM DUAL;

-- 100 십의 자리에서 반올림
SELECT ROUND(123.456, -2)
FROM DUAL;
--------------------------------------------------------------------------------
/*
    * CEIL : 올림처리
    
        CEIL(숫자)
*/
SELECT CEIL(123.456)
FROM DUAL;

/*
    * FLOOR : 버림 처림
        
        FLOOR(숫자)
*/
SELECT FLOOR(123.456)
FROM DUAL;

/*
    TRUNC : 버림처리 (위치 지정 가능)
            
        TRUNC(숫자[, 위치])
*/
-- 123
SELECT FLOOR(123.456)
FROM DUAL;

-- 123.4
SELECT TRUNC(123.456, 1)
FROM DUAL;

-- 120
SELECT TRUNC(123.456, -1)
FROM DUAL;
--------------------------------------------------------------------------------
/*
    * 날짜 타입의 데이터 처리 함수 *
*/

-- 시스템 기준 현재 날짜 시간 정보
SELECT SYSDATE
FROM DUAL;

/*
    * MONTHS_BETWEEN : 두 날짜의 개월 수를 반환
    
    MONTHS_BETWEEN(날짜1, 날짜2) : 날짜1 - 날짜2 => 개월 수
*/
-- * 직원의 근속 개월 수 조회 (이름, 입사일, 근속 개월 수)
SELECT EMP_NAME 이름, HIRE_DATE 입사일, CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), ' 개월차') "근속 개월 수"
FROM employee;

-- * 공부 시작한 지 몇 개월차? '26/06/11'
SELECT CEIL(MONTHS_BETWEEN(SYSDATE, '26/06/11'))
FROM DUAL;

-- * 수료까지 몇 개월 남았는지? '26/12/16'
SELECT FLOOR(MONTHS_BETWEEN('26/12/16', SYSDATE))
FROM DUAL;
--------------------------------------------------------------------------------
/*
    * ADD_MONTHS : 특정 날짜에 N 개월 수를 더해서 반환
        
        ADD_MONTHS(날짜, 더할 개월 수)
*/

-- * 현재 날짜 기준으로 3개월 후 조회
SELECT ADD_MONTHS(SYSDATE, 3)
FROM DUAL;

-- * 직원들의 "수습 종료일" 조회 (이름, 입사일, 입사일+3개월)
SELECT EMP_NAME 이름, HIRE_DATE 입사일, ADD_MONTHS(HIRE_DATE, 3) "수습 종료일"
FROM employee;
--------------------------------------------------------------------------------
/*
    * NEXT_DAY : 특정 날짜 이후로 지정한 요일의 가장 가까운 날짜를 반환
        
        NEXT_DAY(날짜, 요일)
            => 요일 : 문자 또는 숫자
                        1 : 일, 2: 월, ... 7 : 토
*/
-- 현재 날짜 기준으로 가장 가까운 금요일의 날짜 조회
SELECT SYSDATE 오늘날짜, NEXT_DAY(SYSDATE, 6)
FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = KOREAN;
SELECT SYSDATE 오늘날짜, NEXT_DAY(SYSDATE, '금요일')
FROM DUAL;
SELECT SYSDATE 오늘날짜, NEXT_DAY(SYSDATE, '금')
FROM DUAL;

ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE 오늘날짜, NEXT_DAY(SYSDATE, 'FRIDAY')
FROM DUAL;
SELECT SYSDATE 오늘날짜, NEXT_DAY(SYSDATE, 'FRI')
FROM DUAL;
--------------------------------------------------------------------------------
/*
    * LAST_DAY : 해당 월의 마지막 날짜를 구해주는 함수
        
        LAST_DAY(날짜)
*/
-- 이번 달의 마지막 날짜 조회
SELECT LAST_DAY(SYSDATE)
FROM DUAL;

-- 직원 정보 조회 (이름, 입사일, 입사한 달의 마지막 날짜, 입사한 달의 근무일수)
SELECT EMP_NAME 이름, HIRE_DATE 입사일, LAST_DAY(HIRE_DATE) "입사한 달의 마지막 날짜"
FROM employee;

SELECT EMP_NAME 이름, HIRE_DATE 입사일, LAST_DAY(HIRE_DATE) "입사한 달의 마지막 날짜"
    , (LAST_DAY(HIRE_DATE) - HIRE_DATE + 1) "입사한 달의 근무일수"
FROM employee;
--------------------------------------------------------------------------------
/*
    * EXTRACT : 특정 날짜로부터 연도/월/일 값을 추출해서 반환
    
        EXTRACT(YEAR FROM 날짜) : 연도 추출
        EXTRACT(MONTH FORM 날짜) : 월 추출
        EXTRACT(DAY FROM 날짜) : 일 추출
*/
-- * 현재 날짜를 기준으로 연도/월/일 추출
SELECT EXTRACT(YEAR FROM SYSDATE) 연도,
        EXTRACT(MONTH FROM SYSDATE) 월,
        EXTRACT(DAY FROM SYSDATE) 일
FROM DUAL;

-- 직원 정보 조회 (이름, 입사년도, 입사월, 입사일) 정렬 오름차순 - 입사년도 > 입사월 > 입사일
SELECT EMP_NAME 이름, EXTRACT(YEAR FROM HIRE_DATE) 입사년도,
        EXTRACT(MONTH FROM HIRE_DATE) 입사월,
        EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM employee
ORDER BY 입사년도, 입사월, 입사일;
--------------------------------------------------------------------------------
/*
    * 형변환 함수 : 데이터 타입을 변환해주는 함수
                    - 문자 / 숫자 / 날짜
*/

/*
    * TO CHAR : 숫자 또는 날짜 타입의 값을 문자 타입으로 변환해주는 함수
    
        TO CHAE(데이터[, 포맷])
*/
-- 숫자 => 문자
SELECT 1234 "숫자 타입 데이터", TO_CHAR(1234) "문자 타입 데이터"
FROM DUAL;

-- '9' : 개수만큼 자릿수를 확보, 빈칸은 공백으로 채움!
SELECT TO_CHAR(1234), TO_CHAR(1234, '999999')
FROM DUAL;

-- '0' : 개수만큼 자릿수를 확보, 빈칸은 0으로 채움!
SELECT TO_CHAR(1234), TO_CHAR(1234, '000000')
FROM DUAL;

-- 'L' : 화폐단위 표시
SELECT TO_CHAR(1234,'L999999')
FROM DUAL;

-- * 직원 정보 조회 (이름, 급여, 연봉) 화폐단위 표시
SELECT EMP_NAME 이름, TO_CHAR(SALARY, 'L9,999,999,999') 급여, 
        TO_CHAR(SALARY*12, 'L9,999,999,999') 연봉
FROM employee;
--------------------------------------------------------------------------------
-- * 날짜 => 문자
SELECT SYSDATE, TO_CHAR(SYSDATE)
FROM DUAL;

/*
    * YYYY : 연도 4글자로 표현
        YY : 연도 2글자로 표현
    
    *   MM : 월

    *   DD : 일

    *   HH : 시 정보 (HOUR) => 12시간제
      HH24 :               => 24시간제
    
    *   MI : 분 (MINUTES)
    
    *   SS : 초 (SECONDS)
*/
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS')
FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
FROM DUAL;

/*
    * DAY : 요일 정보 (X요일)
       DY : 요일 정보 (X)
*/
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD DAY DY')
FROM DUAL;

/*
    * MONTH, MON : 월 정보 (X월)
*/
SELECT TO_CHAR(SYSDATE, 'MONTH MON')
FROM DUAL;

-- * 직원 정보 조회 (이름, 입사일) (입사일 : XXXX년 XX월 XX일 형식)
-- 표시할 문자(값 자체)는 큰 따옴표("") 로 묶어서 형식ㅇ르 지정해야 함!
SELECT EMP_NAME 이름, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일"') 입사일
FROM employee;
--------------------------------------------------------------------------------
/*
    * TO_NUMBER : 문자 타입의 데이터를 숫자 타입으로 변환
    
        TO_NUMBER(데이터[, 포맷])
            => 포맷을 지정하는 경우는 기호가 포함되거나, 화폐 단위가 포함 된 경우
*/
SELECT TO_NUMBER('0123456789')
FROM DUAL;

-- 10000500 (X) 10000 + 500 자동 숫자 형변환
SELECT '10000' + '500'
FROM DUAL;

-- 오류 발생
SELECT '10,000' + '500'
FROM DUAL;

SELECT TO_NUMBER('10,000','99,999') + TO_CHAR('500', '999')
FROM DUAL;
--------------------------------------------------------------------------------
/*
    * TO_DATE : 숫자 타입 또는 문자 타입을 날짜 타입으로 변환
        
        TO_DATE(데이터[, 포맷])
*/
-- YYYYMMDD
SELECT TO_DATE(20260706)
FROM DUAL;

-- YYMMDD
SELECT TO_DATE(260706)
FROM DUAL;
-- 현재 연도 기준으로 (50년 미만) 자동으로 50년 미만 데이터는 20XX으로 변환
--                                    50년 이상 데이터는 19XX으로 변환
SELECT TO_DATE(960706)
FROM DUAL;

-- 060706 => 60706 (X)
SELECT TO_DATE(060706)
FROM DUAL;
-- 0 으로 시작하는 날짜는 문자 타입으로 제시!
SELECT TO_DATE('060706')
FROM DUAL;

-- TO_DATE 기본 포맷 : YYYYMMDD 또는 YYMMDD 일것임!
-- 오류!
SELECT TO_DATE('260706 143940')
FROM DUAL;

SELECT TO_DATE('260706 143940', 'YYMMDD HH24MISS')
FROM DUAL;
--------------------------------------------------------------------------------
/*
    * NULL 처리 함수 *
*/

/*
    * NVL : 해당 컬럼의 값이 NULL인 경우 다른 값으로 대체 해주는 함수
        
        NVL(컬럼명, 대체할 값)
            => 대체할 값 : 해당 컬럼의 값이 NULL인 경우 사용!
*/
-- 직원 정보 조회 (이름, 보너스)
SELECT EMP_NAME 이름, NVL(BONUS, 0) 보너스
FROM employee;

-- 직원 정보 조회 (이름, 보너스 포함 연봉)
-- (급여 + 급여*보너스)*12
SELECT EMP_NAME 이름, (SALARY + SALARY*NVL(BONUS, 0))*12 "보너스 포함 연봉"
FROM employee;

/*
    * NVL2 : 해당 컬럼이 NULL일 경우 표시할 값을 지정하고, 
                       NULL이 아닐 경우 표시할 값도 지정할 수 있는 함수

        NVL2(컬럼명, NULL이 아닐 경우 대체할 값, NULL일 경우 대체할 값)
*/
-- * 직원 정보 조회(이름, 보너스, 보너스 유무)
SELECT EMP_NAME 이름, BONUS 보너스, NVL2(BONUS, 'O', 'X') "보너스 유무"
FROM employee;

-- * 이름, 부서코드. 부서배치 여부(배정완료/미배정) 조회
SELECT EMP_NAME 이름, DEPT_CODE, NVL2(DEPT_CODE, '배정완료', '미배정') "부서배치 여부"
FROM employee;

/*
    * NULLIF : 두 값이 일치하면 NULL, 일치하지 않으면 비교대상1 값을 반환
        
        NULLIF(비교대상1, 비교대상2)
*/

-- NULL
SELECT NULLIF('999', '999')
FROM DUAL;

-- 999
SELECT NULLIF('999', '777')
FROM DUAL;
--------------------------------------------------------------------------------
/*
    * 선택 함수
        DECODE(비교대상, 비교값1, 결과값1, 비교값2, 결과값2, ...)
            => 비교대상 : 컬럼, 연산식, 함수식, ...
        
        => 자바에서 SWITCH 문과 유사!
        switch(비교대상) {
        case 비교값1:
            결과값1;
            break;
        case 비교값2:
            결과값2
            break;
        }
*/
-- 직원 정보 조회(직원번호, 이름, 주민번호, 성별)
SELECT EMP_ID 직원번호, EMP_NAME 이름, EMP_NO 주민번호, 
        SUBSTR(EMP_NO, 8, 1) 성별
FROM employee;

SELECT EMP_ID 직원번호, EMP_NAME 이름, EMP_NO 주민번호, 
        DECODE(SUBSTR(EMP_NO, 8, 1),'1', '남', '2', '여') 성별
FROM employee;

-- 이름, 급여, 인상 될 급여 조회
/*
    직급이 J7 : 10% 인상
          J6 : 15% 인상
          J5 : 20% 인상
        그 외에는 5% 인상
*/
SELECT EMP_NAME 이름, SALARY 급여,
        DECODE(JOB_CODE, 'J7', SALARY*1.1, 'J6', SALARY*1.15, 'J5', SALARY*1.2, SALARY*1.05) "인상 예정 급여"
FROM employee;

/*
    * CASE WHEN THEN : 조건식에 따라 결과값을 반환해주는 구문
        
        CASE
            WHEN 조건식1 THEN 결과값1
            WHEN 조건식2 THEN 결과값2
            WHEN 조건식3 THEN 결과값3
            ...
            ELSE 조건에 해당하지 않는 나머지 결과값
        END
*/
-- 이름, 급여, 급여에 따른 등급 조회
/*
    급여가 500만원 이상 '고급'
    급여가 350만원 이상 '중급'
    그 외에는 '초급'
*/
SELECT EMP_NAME 이름, SALARY 급여,
        CASE
            WHEN SALARY >= 5000000 THEN '고급'
            WHEN SALARY >= 3500000 THEN '중급'
            ELSE '초급'
        END "급여에 따른 등급"
FROM employee;
--------------------------------------------------------------------------------
-- ==================== 그룹 함수 ======================
/*
    * SUM : 해당 컬럼 값들의 총 합을 반환
    
        SUM(데이터)
            => 데이터는 숫자 타입
*/
-- * 전체 직원들의 총 급여 조회
SELECT SUM(SALARY) "총 급여"
FROM employee;

-- * \70,096,240  형식으로 조회
SELECT TO_CHAR(SUM(SALARY),'L9,999,999,999') "총 급여"
FROM employee;

-- * 남직원들의 총 급여 조회
SELECT TO_CHAR(SUM(SALARY),'L9,999,999,999') "남직원 총 급여"
FROM employee
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3');


SELECT TO_CHAR(SUM(SALARY),'L9,999,999,999') "여직원 총 급여"
FROM employee
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

-- * 부서코드가 D5 인 직원들의 총 급여
SELECT TO_CHAR(SUM(SALARY),'L9,999,999,999') "D5 부서 총 급여"
FROM employee
WHERE DEPT_CODE = 'D5';

-- D5 부서 직원들의 총 연봉
SELECT TO_CHAR(SUM(SALARY*12),'L9,999,999,999') "D5 부서 총 연봉"
FROM employee
WHERE DEPT_CODE = 'D5';
--------------------------------------------------------------------------------
/*
    * AVG : 해당 컬럼의 값들의 평균을 반환
        
        AVG(데이터)
            => 데이터는 숫자 타입
*/
-- 직원들의 평균 급여 조회
SELECT ROUND(AVG(SALARY)) "평균 급여"
FROM employee;

/*
    * MIN / MAX : 가장 작은 값 / 가장 큰 값 반환
    
        MIN(데이터) / MAX(데이터)
            => 데이터 모든 타입(숫자, 날짜, 문자)
*/
SELECT MIN(EMP_NAME) "문자 타입 최소값", MIN(SALARY) " 숫자 타입 최소값",
        MIN(HIRE_DATE) " 날짜 타입 최소값"
FROM employee;

SELECT MAX(EMP_NAME) "문자 타입 최대값", MAX(SALARY) " 숫자 타입 최대값",
        MAX(HIRE_DATE) " 날짜 타입 최대값"
FROM employee;

/*
    * COUNT : 행의 개수를 반환 (단, 조건이 있을 경우 해당 조건에 맞는 행의 개수 반환)
        
        COUNT(*) : 조회 된 결과의 모든 행 개수 반환
        COUNT(컬럼) : 해당 컬럼값이 NULL이 아닌 것만 세어서 개수를 반환
        COUNT(DISTINCT 컬럼) : 해당 컬럼값의 중복을 제거한 후의 개수 반환
                                => 중복 제거 시 NULL은 포함하지 않고 세어짐!
*/
-- 전체 직원 수 조회
SELECT COUNT(*) "전체 직원 수"
FROM employee;

-- 남직원 수 조회
SELECT COUNT(*) "남직원 수"
FROM employee
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3');

-- 보너스를 받는 직원 수 조회
SELECT COUNT(BONUS) "보너스 받는 직원 수"
FROM employee;
