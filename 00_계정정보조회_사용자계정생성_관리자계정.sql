-- 한줄 주석(* 자바에서는 // 와 같은 주석!)
/*
    여러 줄 주석 (* 자바와 동일!)
    1234567
*/

-- 현재 모든 계정 정보 조회
SELECT * FROM DBA_USERS;
-- * 명령문 실행 : 상단의 재생 버튼 또는 ctrl + enter !

-- 사용자 계정 추가(생성)
-- * C33KH / KH 계정 생성
CREATE USER C##KH IDENTIFIED BY KH;

-- 사용자 계정 생성 후 권한 부여 (최소한의 권한 : 접속, 데이터 관리)
GRANT CONNECT, RESOURCE TO C##KH;
-- * CONNECT : 연결 권한
-- * RESOURCE : DB에서 객체(테이블, 시퀀스, 프로시저 ...) 생성 권한

-- 테이블 스페이스 설정
ALTER USER C##KH DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
