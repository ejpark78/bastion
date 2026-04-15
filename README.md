# Bastion 개발 환경 (Bastion Development Environment)

이 프로젝트는 Kasm Workspaces를 기반으로 구축된 웹 접속 가능 리눅스 개발 환경입니다. 일관된 개발 도구 세트와 최적화된 한국어 환경을 제공하는 "Bastion" 서버 역할을 하도록 설계되었습니다.

## 🚀 주요 기능

- **웹 기반 접속**: 브라우저를 통해 6901 포트로 Ubuntu 데스크탑 전체 환경에 접속할 수 있습니다.
- **한국어 환경 최적화**:
  - `fcitx-hangul` 설정을 통해 원활한 한글 입력 지원.
  - 시스템 로케일을 `ko_KR.UTF-8`로 설정.
  - 나눔 폰트(Nanum Fonts) 설치로 깔끔한 한글 타이포그래피 제공.
- **사전 설치된 개발 도구**:
  - **에디터**: Visual Studio Code (샌드박스 비활성화 옵션 최적화)
  - **브라우저**: Google Chrome, Firefox
  - **데이터베이스**: DBeaver Community Edition
  - **쉘**: Zsh 및 Oh My Zsh (autosuggestions, syntax-highlighting 플러그인 포함)
  - **기타**: Docker CLI, Antigravity, Tilix, Alacritty
- **Docker-out-of-Docker (DooD)**: Bastion 환경 내부에서 호스트의 Docker 컨테이너를 제어할 수 있는 기능 제공.
- **데이터 영속성**: 홈 디렉토리 및 프로젝트 데이터 저장소 볼륨 매핑으로 데이터 보존.

## 🛠️ 시작하기

### 사전 요구 사항
- 호스트 머신에 Docker 및 Docker Compose가 설치되어 있어야 합니다.

### 설치 및 설정

1. **이미지 빌드**:
   ```bash
   make build
   ```

2. **환경 실행**:
   ```bash
   make up
   ```

3. **Bastion 접속**:
   브라우저를 열고 다음 주소로 접속하세요: `https://localhost:6901`
   - **사용자**: `kasm-user`
   - **비밀번호**: `VNC_PW` 환경 변수에 정의된 비밀번호

## 📖 사용 가이드

### 주요 명령어
제공되는 `Makefile`을 통해 환경 관리를 간편하게 수행할 수 있습니다.

| 명령어 | 설명 |
| :--- | :--- |
| `make build` | Bastion 이미지 빌드 |
| `make up` | 백그라운드에서 환경 실행 |
| `make down` | 컨테이너 중지 및 제거 |
| `make restart` | 환경 재시작 |
| `make logs` | 컨테이너 로그 실시간 확인 |
| `make ps` | 컨테이너 상태 확인 |

### 한글 입력 (Fcitx)
본 환경은 한글 입력이 사전 설정되어 있습니다. 만약 입력이 되지 않는다면:
1. `fcitx` 데몬이 실행 중인지 확인하세요 (`custom_startup.sh`에서 자동 처리됨).
2. 표준 Fcitx 전환 키(보통 `Ctrl+Space` 또는 `한영` 키)를 사용하여 언어를 전환하세요.

## 📂 프로젝트 구조

- `compose.yml`: Docker Compose 설정 파일.
- `Makefile`: 빌드 및 런타임 제어를 위한 자동화 스크립트.
- `docker/`:
  - `Dockerfile`: 이미지 정의 및 패키지 설치 설정.
  - `custom_startup.sh`: Fcitx 초기화를 위한 시작 스크립트.
- `volumes/`: 영속 데이터 저장소 (실행 시 생성됨).

## ⚙️ 설정 변경

`compose.yml` 파일이나 `.env` 파일을 통해 다음 환경 변수를 수정하여 환경을 커스텀할 수 있습니다:
- `KASM_USER`: 사용자 계정 이름 (기본값: `kasm-user`).
- `VNC_PW`: VNC/웹 접속 비밀번호.
- `IMAGE_TAG`: 빌드될 Docker 이미지의 태그.
