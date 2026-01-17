# WiseInvest

AI 투자 분석 플랫폼 - 워런 버핏의 가치투자 기준으로 한국 주식을 분석합니다.

## 개발 환경 설정

### 요구사항
- Ruby 3.x
- PostgreSQL
- Node.js

### 설치 및 실행

```bash
# 의존성 설치
bundle install
npm install

# 데이터베이스 설정
rails db:create db:migrate db:seed

# 개발 서버 실행
./bin/dev
```

## 개발용 계정 정보

| 구분 | 이메일 | 비밀번호 | 권한 |
|------|--------|----------|------|
| 관리자 | admin@wiseinvest.com | #password123 | Admin |

> **참고**: 첫 번째로 가입하는 사용자는 자동으로 관리자 권한이 부여됩니다.

## 관리자 기능

관리자 계정으로 로그인 후 `/admin` 경로에서 다음 기능을 사용할 수 있습니다:

- 사용자 목록 조회
- 사용자 상세 정보 확인
- 관리자 권한 부여/해제
- 계정 정지/활성화

## 테스트 실행

```bash
# 전체 테스트
rails test

# 특정 파일 테스트
rails test test/controllers/admin/users_controller_test.rb
```

## 주요 문서

- `CLAUDE.md` - Claude Code 개발 가이드
- `PRD.md` - 제품 요구사항
- `MVP_ARCHITECTURE.md` - 기술 설계 상세
