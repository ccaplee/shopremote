# ShopRemote

ShopRemote는 매장 및 사무실 환경을 위한 원격 데스크탑 솔루션입니다.  
빠르고 안전한 원격 제어로 어디서든 내 PC에 접속하세요.

## 주요 기능

- 🖥️ **원격 제어** — Windows, macOS, Linux 지원
- 🔒 **보안 연결** — 자체 서버로 데이터 외부 유출 없음
- 📱 **모바일 지원** — Android, iOS 앱 제공
- ⚡ **빠른 속도** — P2P 직접 연결 우선
- 🌐 **한국어 지원** — UI 완전 한국어 지원

## 시작하기

### 서버 설치

```bash
docker run -d --name hbbs -p 21115-21116:21115-21116 -p 21116:21116/udp rustdesk/rustdesk-server hbbs
docker run -d --name hbbr -p 21117:21117 rustdesk/rustdesk-server hbbr
```

### 클라이언트 설정

1. ShopRemote 실행
2. 설정 → 네트워크
3. ID 서버: `your-server-ip`
4. Key: `your-server-key`

## 사용법

### 원격 제어 받기 (피제어)
1. ShopRemote 실행
2. 화면에 표시된 **ID**와 **비밀번호** 확인
3. 상대방에게 전달

### 원격 제어 하기 (제어)
1. ShopRemote 실행
2. 상대방 ID 입력 → 연결
3. 비밀번호 입력

## 기술 스택

- **코어**: Rust + Flutter
- **프로토콜**: P2P / TCP relay
- **암호화**: TLS + NaCl

## 라이선스

AGPL-3.0 — 소스코드 공개 의무 라이선스

---

© 2024 ShopRemote Inc. support@shopremote.kr
