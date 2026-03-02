# Multi-Agent 사용 가이드

## 목차
1. [멀티 에이전트란?](#1-멀티-에이전트란)
2. [설치](#2-설치)
3. [기본 사용법](#3-기본-사용법)
4. [14개 에이전트 한눈에 보기](#4-14개-에이전트-한눈에-보기)
5. [실전 예시](#5-실전-예시)
6. [복합 작업](#6-복합-작업)
7. [커스터마이징](#7-커스터마이징)
8. [FAQ](#8-faq)

---

## 1. 멀티 에이전트란?

Claude Code에서 **에이전트**란, 특정 전문 분야의 지식과 도구를 갖춘 **전문가 역할**입니다.

```
일반 Claude = 만능 인턴 (뭐든 가능하지만 매번 맥락 설명 필요)
멀티 에이전트 = 전문 팀 (각자 분야가 있어서 바로 실행)
```

### 구조

```
당신 (사용자)
  │
  ▼
Orchestrator (메인 Claude) ← 항상 대화하는 상대
  │
  ├→ bsp-engineer       (커널/빌드 전문)
  ├→ firmware-engineer   (MCU/FPGA 전문)
  ├→ web-developer      (웹 풀스택)
  ├→ ... (총 14개)
  └→ 요청에 따라 자동 선택
```

**핵심**: 평소처럼 대화하면 됩니다. 적절한 에이전트가 자동으로 활용됩니다.

---

## 2. 설치

### 방법 1: 셋업 스크립트 (추천)

```bash
# 리포 클론
git clone https://github.com/issacs83/claude-multi-agent.git

# 프로젝트에 복사 설치
./claude-multi-agent/setup.sh /path/to/your/project

# 또는 심링크 설치 (소스와 동기화)
./claude-multi-agent/setup.sh --symlink /path/to/your/project
```

### 방법 2: 수동 복사

```bash
# 프로젝트의 .claude/agents/ 디렉토리에 복사
mkdir -p /your/project/.claude/agents
cp claude-multi-agent/.claude/agents/*.md /your/project/.claude/agents/
```

### 방법 3: 리포에서 직접 사용

```bash
cd claude-multi-agent
claude   # 바로 14개 에이전트 사용 가능
```

설치 후 Claude Code를 실행하면 `.claude/agents/` 폴더의 에이전트가 자동 로드됩니다.

---

## 3. 기본 사용법

### 방법 A: 자연어로 요청 (가장 쉬움)

```
사용자: "커널에 새 GPIO 드라이버 패치 추가해줘"
→ bsp-engineer 자동 활용

사용자: "REST API 설계해줘"
→ web-developer 자동 활용

사용자: "FDA 510(k) 전략 수립"
→ regulatory-specialist 자동 활용
```

### 방법 B: 에이전트 이름 지정

```
사용자: "firmware-engineer로 SPI 드라이버 분석해줘"
사용자: "circuit-engineer한테 전원 회로 검토 맡겨"
```

### 방법 C: 복합 작업

```
사용자: "알고리즘 설계하고 테스트까지 해줘"
→ algorithm-researcher → qa-tester 순차 실행
```

---

## 4. 14개 에이전트 한눈에 보기

### 전략/기획

| Agent | 모델 | 핵심 키워드 |
|-------|------|------------|
| **product-strategist** | opus | 로드맵, 경쟁분석, 마일스톤, PRD |
| **regulatory-specialist** | opus | FDA, CE, ISO, IEC, 인증, 위험분석 |

### 하드웨어

| Agent | 모델 | 핵심 키워드 |
|-------|------|------------|
| **hardware-engineer** | opus | 광학, 센서, 카메라, 열관리, 기구 |
| **circuit-engineer** | opus | 회로, PCB, 전원, 임피던스, EMC |

### 임베디드

| Agent | 모델 | 핵심 키워드 |
|-------|------|------------|
| **bsp-engineer** | sonnet | Yocto, 커널, DTS, U-Boot, 패치 |
| **firmware-engineer** | opus | MCU, FPGA, Cortex-M, RTOS, RTL |

### 알고리즘/3D

| Agent | 모델 | 핵심 키워드 |
|-------|------|------------|
| **algorithm-researcher** | opus | 영상처리, ML, 컴퓨터비전, 최적화 |
| **graphics-engineer** | opus | 렌더링, Metal, Vulkan, WebGL, 셰이더 |

### 소프트웨어

| Agent | 모델 | 핵심 키워드 |
|-------|------|------------|
| **sdk-developer** | opus | SDK, API, 드라이버래핑, 크로스플랫폼 |
| **web-developer** | sonnet | React, API, DB, 대시보드, 풀스택 |

### 품질/운영

| Agent | 모델 | 핵심 키워드 |
|-------|------|------------|
| **qa-tester** | sonnet | 테스트, QA, V&V, 벤치마크 |
| **devops-engineer** | sonnet | CI/CD, 빌드, 릴리즈, Docker |
| **doc-writer** | sonnet | 문서, 매뉴얼, DHF, 릴리즈노트 |
| **maintenance-engineer** | sonnet | 크래시, 진단, OTA, RMA |

### 모델 선택 기준
- **opus** (8개): 깊은 분석, 설계, 연구 — 복잡한 추론 필요
- **sonnet** (6개): 구현, 빌드, 문서 — 빠른 실행 우선

---

## 5. 실전 예시

### 단일 에이전트

```
# 임베디드
"커널 CONFIG_SPI_IMX 활성화 패치 만들어줘"           → bsp-engineer
"FreeRTOS 태스크 우선순위 설계해줘"                  → firmware-engineer

# 하드웨어
"100Ω 차동 임피던스 스택업 계산"                    → circuit-engineer
"CMOS 이미지 센서 비교 (IMX296 vs AR0234)"         → hardware-engineer

# 소프트웨어
"디바이스 연결 SDK API 설계"                        → sdk-developer
"Next.js로 관리 대시보드 만들기"                    → web-developer

# 3D/알고리즘
"포인트 클라우드 노이즈 제거 알고리즘"              → algorithm-researcher
"Three.js 3D 뷰어 구현"                           → graphics-engineer

# 품질/운영
"pytest로 유닛 테스트 작성"                        → qa-tester
"GitHub Actions CI 파이프라인 설정"                → devops-engineer
"API 문서 Doxygen으로 생성"                        → doc-writer
"커널 패닉 로그 분석"                              → maintenance-engineer

# 전략/규제
"제품 로드맵 수립"                                → product-strategist
"IEC 62304 소프트웨어 분류"                        → regulatory-specialist
```

### 복합 에이전트 (자동 조합)

```
# 기능 개발 (순차)
"새 센서 드라이버 요구사항부터 테스트까지 전체 진행"
→ product-strategist → bsp-engineer → qa-tester → doc-writer

# 릴리즈 (순차)
"v2.0.0 릴리즈 준비"
→ devops-engineer → qa-tester → maintenance-engineer → doc-writer

# 코드 리뷰 (병렬)
"이 PR 종합 리뷰"
→ qa-tester + algorithm-researcher + regulatory-specialist 동시

# 플랫폼 이주 (순차)
"알고리즘을 FPGA로 이주"
→ algorithm-researcher → firmware-engineer → bsp-engineer → qa-tester
```

---

## 6. 복합 작업

### 미리 정의된 워크플로우 패턴

| 패턴 | 작업 유형 | 에이전트 조합 | 실행 |
|------|----------|-------------|------|
| **A** | 기능 개발 | strategist → 구현 → qa → doc | 순차 |
| **B** | 코드 리뷰 | qa + domain expert + regulatory | 병렬 |
| **C** | 릴리즈 | devops → qa → maintenance → doc | 순차 |
| **D** | 인증 | regulatory → (qa + doc + circuit) | 팬아웃 |
| **E** | 플랫폼 이주 | algorithm → firmware → bsp → qa | 순차 |
| **F** | 클라이언트 앱 | sdk → (graphics + web) → qa | 혼합 |
| **G** | 유지보수 | web → (sdk + maintenance + devops) | 팬아웃 |

패턴을 외울 필요 없이 자연어로 요청하면 자동 적용됩니다.

---

## 7. 커스터마이징

### 에이전트 파일 구조

```markdown
---
name: my-agent           # ID (kebab-case)
description: |           # 용도 + 예시
  Use this agent for ...
  <example>
  Context: ...
  user: "..."
  assistant: "..."
  </example>
model: opus              # opus 또는 sonnet
color: red               # UI 색상
tools: ["Read", ...]     # 사용 도구
---

시스템 프롬프트 (에이전트의 전문 지식)
```

### 프로젝트에 맞게 수정

1. **에이전트 수정**: `.claude/agents/해당-agent.md` 파일 직접 편집
2. **에이전트 추가**: 새 `.md` 파일 생성 → 즉시 인식
3. **에이전트 제거**: 파일 삭제 또는 다른 폴더로 이동
4. **전략 수정**: `STRATEGY-TEMPLATE.md`를 프로젝트에 맞게 작성

### 새 에이전트 추가 예시

```markdown
---
name: data-analyst
description: |
  Use this agent for data analysis and visualization.
model: sonnet
color: pink
tools: ["Read", "Grep", "Glob", "Bash", "Write", "TodoWrite"]
---

You are a data analyst specializing in ...
```

### 사용 가능한 도구

| 도구 | 용도 |
|------|------|
| Read | 파일 읽기 |
| Write | 파일 생성 |
| Edit | 파일 수정 |
| Glob | 파일 패턴 검색 |
| Grep | 내용 검색 |
| Bash | 터미널 명령 |
| WebFetch | 웹 내용 가져오기 |
| WebSearch | 웹 검색 |
| TodoWrite | 작업 목록 |

---

## 8. FAQ

### Q: 어떤 에이전트가 호출됐는지 알 수 있나요?
**A**: Orchestrator가 에이전트를 호출하면 어떤 에이전트를 사용하는지 알려줍니다.

### Q: 전체 14개 다 있어야 하나요?
**A**: 아닙니다. 필요한 에이전트만 `.claude/agents/`에 두면 됩니다.

### Q: opus vs sonnet 차이?
**A**: opus = 복잡한 분석/설계 (느리지만 정확), sonnet = 구현/실행 (빠름)

### Q: 에이전트를 수정하면 바로 적용되나요?
**A**: 네, 파일 저장 즉시 다음 호출부터 적용됩니다.

### Q: 심링크 vs 복사?
**A**:
- **심링크**: 원본 리포 `git pull` 하면 모든 프로젝트 자동 업데이트
- **복사**: 프로젝트별 독립 수정 가능, 수동 업데이트 필요

### Q: MCP 서버 필요?
**A**: 선택사항입니다. 에이전트만으로 충분히 동작합니다.

---

## 빠른 참조

```
┌─────────────────────────────────────────────┐
│          Multi-Agent Quick Reference         │
├─────────────────────────────────────────────┤
│  커널/빌드       → bsp-engineer             │
│  MCU/FPGA        → firmware-engineer         │
│  광학/센서/기구   → hardware-engineer         │
│  회로/PCB/전원   → circuit-engineer           │
│  알고리즘/CV/ML  → algorithm-researcher       │
│  3D 렌더링       → graphics-engineer          │
│  SDK/드라이버    → sdk-developer              │
│  웹 풀스택       → web-developer              │
│  테스트/QA       → qa-tester                  │
│  CI/CD           → devops-engineer            │
│  문서            → doc-writer                 │
│  인증/규제       → regulatory-specialist       │
│  유지보수        → maintenance-engineer        │
│  제품 전략       → product-strategist          │
│                                               │
│  그냥 자연어로 요청하면 자동 선택됩니다!        │
└─────────────────────────────────────────────┘
```
