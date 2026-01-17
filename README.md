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

## 배포 (Render)

### 자동 배포 (Blueprint)

1. [Render Dashboard](https://dashboard.render.com) 접속
2. **New → Blueprint** 선택
3. GitHub 저장소 `wiseinvest` 연결
4. `render.yaml` 자동 감지 → **Apply** 클릭
5. Environment Variables에서 `RAILS_MASTER_KEY` 설정:
   ```bash
   # 로컬에서 master.key 값 확인
   cat config/master.key
   ```
6. 배포 완료 후 자동 생성된 URL로 접속

### 수동 배포

1. **New → Web Service** → GitHub 연결
2. 설정:
   - **Runtime**: Docker
   - **Region**: Singapore
   - **Plan**: Free (또는 Starter $7/월)
3. **New → PostgreSQL** → 데이터베이스 생성
4. Environment Variables 설정:
   - `DATABASE_URL`: PostgreSQL 연결 문자열 (Internal URL)
   - `RAILS_MASTER_KEY`: `config/master.key` 값
5. Deploy

### 배포 후 초기 관리자 생성

Render Shell에서 실행:
```bash
rails runner "User.create!(email_address: 'admin@wiseinvest.com', name: 'Admin', password: '#password123', is_admin: true)"
```

## 주요 문서

- `CLAUDE.md` - Claude Code 개발 가이드
- `PRD.md` - 제품 요구사항
- `MVP_ARCHITECTURE.md` - 기술 설계 상세
- `render.yaml` - Render 배포 설정
