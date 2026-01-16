# WiseInvest - AI 기반 주식 투자 분석 플랫폼

전문적이고 반응형 웹 디자인의 주식 투자 분석 및 습관 교정 플랫폼 프론트엔드 템플릿

## 🎯 프로젝트 개요

WiseInvest는 한/미 상장 주식에 대한 전문가 관점 분석을 제공하고, 사용자의 실제 투자 결과와 설문 답변을 비교 분석하여 잘못된 투자 습관을 교정하고 최적의 투자 전략을 제안하는 플랫폼입니다.

## ✨ 완성된 기능

### 페이지 구성 (8개)
1. ✅ **index.html** - 로그인 리다이렉트
2. ✅ **login.html** - 로그인 페이지
3. ✅ **register.html** - 회원가입 페이지
4. ✅ **dashboard.html** - 대시보드 메인
5. ✅ **stocks.html** - 종목 분석 페이지
6. ✅ **records.html** - 투자 기록 관리
7. ✅ **profile.html** - 성향 리포트
8. ✅ **survey.html** - 투자 성향 설문

### 핵심 UI 컴포넌트
- ✅ 반응형 사이드바 (데스크탑) & 하단 네비게이션 (모바일)
- ✅ 6가지 투자 지표 스코어바 (버핏 스타일 분석)
- ✅ 별점 평가 시스템 (1-5점)
- ✅ 투자 근거 태그 시스템
- ✅ Radar 차트 (설문 vs 실제 비교)
- ✅ 편향 감지 카드 (과잉 확신, 손실 회피, 뇌동 매매)
- ✅ AI 맞춤형 조언 섹션
- ✅ CSV 업로드 모달 (드래그 앤 드롭)
- ✅ 10단계 설문 시스템 (진행률 표시)

### 레이아웃 수정 사항 (최신)
- ✅ **콘텐츠 영역 수정**: 사이드바와 콘텐츠가 겹치지 않도록 margin-left 적용
- ✅ **데스크탑**: main-content에 margin-left: 16rem (사이드바 너비)
- ✅ **모바일**: main-content에 margin-left: 0, 상하단 여백 추가
- ✅ **테이블 오버플로우 방지**: table-wrapper 추가
- ✅ **반응형 패딩**: 화면 크기별 적절한 여백 설정

## 🎨 디자인 특징

### 색상 시스템
```css
--primary: #2563eb (블루 - 신뢰)
--success: #10b981 (그린 - 수익)
--danger: #ef4444 (레드 - 손실)
--warning: #f59e0b (옐로우 - 주의)
--navy: #0f172a (네이비 - 안정)
```

### 등급 색상
- **A등급**: 그린 (85-100점)
- **B등급**: 블루 (70-84점)
- **C등급**: 옐로우 (55-69점)
- **D등급**: 레드 (54점 이하)

### 반응형 브레이크포인트
- **데스크탑**: > 1024px (사이드바 고정)
- **태블릿**: 768-1024px (적응형 레이아웃)
- **모바일**: < 768px (하단 네비게이션)

## 🛠️ 기술 스택

| 카테고리 | 기술 |
|---------|------|
| **HTML** | HTML5 Semantic |
| **CSS** | Tailwind CSS 3.x (CDN) + Custom CSS |
| **JavaScript** | Vanilla JS (ES6+) |
| **차트** | Chart.js 4.x |
| **아이콘** | Font Awesome 6.4 |
| **폰트** | Noto Sans KR, Inter |

## 📁 파일 구조

```
wiseinvest/
├── css/
│   └── style.css                 # 커스텀 스타일 (7.6KB)
├── js/
│   ├── main.js                   # 공통 JavaScript (6.1KB)
│   └── survey.js                 # 설문 전용 로직 (10.4KB)
├── index.html                    # 메인 (리다이렉트)
├── login.html                    # 로그인
├── register.html                 # 회원가입
├── dashboard.html                # 대시보드
├── stocks.html                   # 종목 분석
├── records.html                  # 투자 기록
├── profile.html                  # 성향 리포트
├── survey.html                   # 투자 설문
└── README.md                     # 프로젝트 문서
```

## 🚀 사용 방법

### 1. 로컬에서 실행
```bash
# 간단한 웹 서버 실행
python -m http.server 8000

# 브라우저에서 접속
# http://localhost:8000/login.html
```

### 2. 배포
프로젝트 페이지의 **Publish** 탭에서 한 번의 클릭으로 배포 가능

## 📊 페이지별 기능

### 🏠 Dashboard (dashboard.html)
- 4개 요약 카드 (투자금, 수익률, 승률, 성향)
- 최근 분석 종목 3개
- 최근 투자 기록 테이블
- 빠른 실행 버튼
- AI 오늘의 조언

### 🔍 Stocks (stocks.html)
- 실시간 종목 검색
- 버핏 스타일 6가지 지표 분석
  - ROE (자기자본이익률)
  - 부채비율
  - 영업이익률
  - 이익 증가 지속성
  - PER (주가수익비율)
  - PBR (주가순자산비율)
- 종합 점수 및 등급 (A/B/C/D)
- 사전 별점 평가 시스템
- 투자 근거 태그 선택
- 다른 투자자 통계

### 📋 Records (records.html)
- 투자 기록 테이블 (10개 컬럼)
- 수동 입력 모달
- CSV 드래그 앤 드롭 업로드
- 검색 및 필터링 (종목, 구분, 기간)
- 페이지네이션
- 엑셀 다운로드
- 요약 통계 (총 건수, 보유 기간, 승률, 손익)

### 📈 Profile (profile.html)
- 설문 점수 vs 실제 점수 비교
- 인지 부조화 갭 분석 (14점 차이)
- Radar 차트 (5가지 성향 비교)
- 3가지 편향 감지 카드
  - 과잉 확신 (Overconfidence)
  - 손실 회피 편향
  - 뇌동 매매 (Herding)
- AI 맞춤형 투자 조언 4가지
- 리포트 인쇄 기능

### 📝 Survey (survey.html)
- 10개 질문 (5점 척도)
- 진행률 표시 바
- 단계별 네비게이션
- 자동 점수 계산
- 결과 모달 (성향 분석)
- 맞춤형 조언 제공

## 🎯 샘플 데이터

### 종목
- **삼성전자** (005930) - B등급 (72점)
- **SK하이닉스** (000660) - A등급 (85점)
- **NAVER** (035420) - C등급 (56점)
- **카카오** (035720) - 매도 기록

### 투자 성향
- **설문 점수**: 72점 (보수적)
- **실제 점수**: 58점 (중립적)
- **갭**: 14점 (인지 부조화)

## 🔧 커스터마이징 가이드

### 색상 변경
`css/style.css` 파일의 `:root` 변수 수정:
```css
:root {
  --primary: #2563eb;
  --success: #10b981;
  --danger: #ef4444;
}
```

### 사이드바 너비 변경
```css
:root {
  --sidebar-width: 16rem; /* 원하는 크기로 조정 */
}
```

### 로고 변경
각 HTML 파일의 사이드바 섹션에서:
```html
<h1 class="text-2xl font-bold">
    <i class="fas fa-chart-line mr-2"></i>
    WiseInvest <!-- 여기를 <img> 태그로 교체 -->
</h1>
```

## 📱 반응형 동작

### 데스크탑 (> 1024px)
- 좌측 고정 사이드바 (256px)
- 메인 콘텐츠 margin-left: 16rem
- 테이블 전체 너비 표시

### 모바일 (< 1024px)
- 사이드바 숨김 (햄버거 메뉴로 토글)
- 메인 콘텐츠 margin-left: 0
- 상단 헤더 표시
- 하단 네비게이션 표시
- 테이블 가로 스크롤

## ⚠️ 알려진 제한사항

### 현재 구현됨 (프론트엔드 Only)
- ✅ 모든 UI/UX 컴포넌트
- ✅ 별점 평가 시스템
- ✅ 태그 선택 시스템
- ✅ 설문 진행 및 결과 계산
- ✅ 반응형 레이아웃

### 백엔드 연동 필요
- ⏳ 실제 종목 데이터 API 연동
- ⏳ 사용자 인증 (JWT)
- ⏳ 투자 기록 CRUD
- ⏳ 설문 결과 저장
- ⏳ AI 조언 생성 (OpenAI API)
- ⏳ CSV 파일 파싱 및 저장

## 🔜 다음 단계 (Rails 8 연동)

1. **인증 시스템**
   - Rails 8 Built-in Authentication
   - Session 관리
   - 비밀번호 암호화

2. **데이터베이스 연동**
   - PostgreSQL 스키마 구축
   - ActiveRecord 모델 생성
   - RESTful API 엔드포인트

3. **Hotwire 통합**
   - Turbo Frames로 페이지 래핑
   - Stimulus 컨트롤러 변환
   - 실시간 업데이트

4. **외부 API 연동**
   - KIS Developers API (한국 주식)
   - OpenDart API (재무 정보)
   - OpenAI API (AI 조언)

5. **배포**
   - Kamal 2 컨테이너 배포
   - Thruster HTTP/2 프록시
   - Solid Queue 백그라운드 작업

## 📖 페이지 이동 플로우

```
1. login.html (로그인)
   ↓
2. register.html (회원가입) → survey.html (설문)
   ↓
3. dashboard.html (대시보드)
   ↓
4. stocks.html (종목 분석) → 별점 평가
   ↓
5. records.html (투자 기록 추가)
   ↓
6. profile.html (성향 리포트) → AI 조언
```

## 💻 브라우저 지원

- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+
- ✅ Mobile Safari (iOS 14+)
- ✅ Chrome Mobile (Android 10+)

## 📝 라이센스

이 프로젝트는 교육 및 포트폴리오 목적으로 제작되었습니다.

## 🙋 문의 및 지원

프로젝트에 대한 질문이나 버그 리포트는 이슈로 등록해주세요.

---

**Made with ❤️ for smarter investors**

마지막 업데이트: 2024-01-16
