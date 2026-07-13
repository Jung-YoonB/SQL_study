/*
    * SEQUENCE (시퀀스) *
        : 자동으로 번호를 발생 시켜주는 객체
            점수를 순차적으로 일정한 값마다 증가 시키면서 생성
            
        EX)사원번호, 회원번호, 도서번호, ... => 중복 되면 안 되는 기본키(PK) 컬럼에 주로 사용
*/
--------------------------------------------------------------------------------
/*
    * 시퀀스 생성 *
    
        CREATE SEQUENCE 시퀀스명
        [START WITH 시작번호]         --> 처음 발생 시킬 시작 값 지정 (생략 시 기본 값 1)
        [INCREMENT BY 증가값]         --> 얼마만큼씩 증가시킬 것인지에 대한 값 지정 (생략 시 기본값 1)
        [MAXVALUE 최대값]             --> 최대값 (생략 시 기본값 엄청 큰 수)
        [MINCALUE 최소값]             --> 최소값 (생략 시 기본값 1 / 증가 시퀀스 기준)
        [CYCLE / NOCYCLE]            --> 값의 순환 여부 (기본값 NOCYCLE)
            => CYCLE : 최대값에 도달하면 최소값부터 다시 시작
            => NOCTCLE : 최대값에 도달하면 더 이상 증가되지 않고 오류 발생!
        [NOCACHE / CACHE 숫자]        --> 캐시 메모리 할당 여부 (기본값 CACHE 20)
            => CACHE : 번호를 미리 메모리에 "숫자"만큼 만들어 둠 (속도가 빠름)
                    --> ! 주의 ! : 컴퓨터가 갑자기 꺼지면 메모리에 있던 번호가 날라가서 건너뛰는 현상이 발생 할 수 있음.
            => NOCACHE : 필요할 때마다 그때그때 번호를 생성 ( 결제, 주문 번호 등에 사용 )

        [참고] 이름 규칙 (관례)
            - 테이블   : TB_XXXX
            - 뷰      : VW_XXXX
            - 시퀀스   : SEQ_XXXX
            - 트리거   : TRG_XXXX
*/
-- 기본값으로 시퀀스를 생성 : SEQ_TEST
CREATE SEQUENCE SEQ_TEST;

-- * 현재 계정에 생성 된 시퀀스 목록 조회
SELECT * FROM user_sequences;

-- SEQ_EMPNO 시퀀스 생성
    --> 시작번호 300, 증가값 5, 최댓값 310, 순환X, 캐시메모리X
CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;
--------------------------------------------------------------------------------
/*
    * 시퀀스 사용 *
        - 시퀀스명.NEXTVAL : 다음 시퀀스 값 가져오기 (호출할 때마다 값 증가)
        - 시퀀스명.CURRVAL : 현재 시퀀스 값 확인 (마지막으로 성공한 NEXTVAL의 결과값)
*/
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;
    -->NEXTVAL 을 한 번도 수행하지 않은 상태에서 CURRVAL 을 사용하면 에러 발생!

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
    --> 300
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;
    --> 300

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
    --> 300 + 5 => 305
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
    --> 305 + 5 => 310

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
    --> 오류 발생!! 최댓값(310)을 초과할 수 없음!! (NOCYCLE 옵션으로 생성했기 때문에)
--------------------------------------------------------------------------------
/*
    * 시퀀스 변경 *
        ALTER SEQUENCE 시퀀스명
        [INCREMENT BY 증가값]
        [MAXVALUE 최댓값]
        [MINVALUE 최솟값]
        [CYCLE / NOCTCLE]
        [NOCACHE / CACHE 숫자]
            => START WITH (시작값)은 변경할 수 없음!!
                변경하고자 한다면, 제거(DROP)한 후 다시 생성(CREATE)해야 함.
*/
-- * SEQ_EMPNO 시퀀스의 증가값을 10, 최대값은 400으로 변경
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400;

SELECT * FROM user_sequences;

SELECT SEQ_EMPNO.CURRVAL FROM DUAL;
    --> 현재값 확인 (310)
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
    --> 310 + 10 => 320
--------------------------------------------------------------------------------
/*
    * 시퀀스 삭제 *
        DROP SEQUENCE 시퀀스명
*/
-- SEQ_EMPNO 시퀀스 삭제
DROP SEQUENCE SEQ_EMPNO;
SELECT * FROM USER_SEQUENCES;
--------------------------------------------------------------------------------
-- 직원번호용 시퀀스 생성 (300번부터 시작, 1씩 증가, 캐시 사용 안함) SEQ_ENO
CREATE SEQUENCE SEQ_ENO
START WITH 300
-- INCREMENT BY 1
NOCACHE;

SELECT * FROM user_sequences;

-- * 데이터 추가 시 사용 --> 직원 번호 컬럼에 사용
INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
    VALUES (SEQ_ENO.NEXTVAL, '박아지', '060713-4000000', 'J6', SYSDATE);
        --> 300번 직원 번호가 저장 됨

INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
    VALUES (SEQ_ENO.NEXTVAL, '강얼지', '050713-4000000', 'J6', SYSDATE);
        --> 301번 직원 번호가 저장 됨

SELECT * FROM employee;
ROLLBACK;
    --> 300, 301번 직원 정보가 지워짐 (취소)


INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
    VALUES (SEQ_ENO.NEXTVAL, '망아지', '040713-4000000', 'J6', SYSDATE);
        --> 롤백과 상관 없이 시퀀스 번호는 증가 됨! 302번 직원 번호가 저장 됨
ROLLBACK;
