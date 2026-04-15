# Claude Code 가이드: Bastion 개발 환경

이 문서는 Claude Code가 Bastion 환경을 유지보수하고 개발하는 데 필요한 지침을 제공합니다.

## 🚀 프로젝트 개요
Bastion 프로젝트는 Kasm Workspaces 기반의 커스텀 Ubuntu 개발 환경입니다. 주요 목표는 사전 설정된 도구와 최적화된 한국어 지원을 통해 브라우저로 접속 가능한 일관된 개발 서버를 제공하는 것입니다.

## 🛠️ 기술 스택
- **베이스 이미지**: `kasmweb/core-ubuntu-noble:1.18.0`
- **OS**: Ubuntu Noble
- **핵심 도구**: Docker CLI, VS Code, Google Chrome, Firefox, DBeaver, Antigravity
- **쉘**: Zsh + Oh My Zsh (autosuggestions & syntax-highlighting 플러그인 포함)
- **입력기**: Fcitx-Hangul (한국어)
- **자동화**: Makefile, Docker Compose

## 📋 개발 가이드라인

### Dockerfile 유지보수
- **레이어 최적화**: 이미지 크기를 최소화하기 위해 `apt-get` 작업은 하나의 `RUN` 명령어로 통합하여 유지합니다.
- **Electron 앱**: 컨테이너 내부에서 VS Code와 Chrome이 정상 작동하도록 항상 `--no-sandbox` 및 `--password-store=basic` 옵션을 사용합니다.
- **권한 설정**: `kasm-user`를 기본 사용자로 유지하며, `sudo`는 암호 없이 사용할 수 있도록 설정합니다.

### 한국어 입력 설정
- Fcitx 설정은 `Dockerfile`(설치 및 스켈레톤 생성)과 `custom_startup.sh`(런타임 초기화)로 나뉘어 있습니다.
- `XMODIFIERS`, `GTK_IM_MODULE`, `QT_IM_MODULE` 환경 변수가 `Dockerfile`과 `compose.yml` 모두에서 `fcitx`로 설정되어 있는지 항상 확인합니다.

### 환경 설정
- `VNC_PW`와 같은 민감한 정보는 `.env` 파일을 통해 관리합니다.
- **중요 제약 사항**: Kasm 내부 검증 로직으로 인해 `VNC_PW`는 **반드시 6자 이상**이어야 합니다. 이보다 짧을 경우 컨테이너 실행이 실패합니다.

## 📂 주요 파일 맵
- `compose.yml`: 서비스 정의 및 환경 변수 매핑.
- `docker/Dockerfile`: 시스템 패키지, 애플리케이션 설치 및 사용자 설정.
- `docker/custom_startup.sh`: Fcitx 초기화를 위한 런타임 훅.
- `Makefile`: 빌드, 실행, 중지 작업을 위한 표준 진입점.

## 🧪 일반적인 작업 워크플로우
1. **설정 수정**: `Dockerfile` 또는 `custom_startup.sh` 수정.
2. **빌드**: `make build` 실행.
3. **배포**: `make up` 실행.
4. **검증**: `https://localhost:6901`에 접속하여 특정 기능(예: 한글 입력, 도구 실행)이 정상 작동하는지 테스트.
