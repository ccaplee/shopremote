# ShopRemote 수정 이력

RustDesk 1.4.6 오픈소스 기반으로 ShopRemote 브랜드로 커스터마이징한 내용입니다.

## 수정일: 2026-03-19

### 브랜드 변경
| 원본 | 변경 |
|------|------|
| RustDesk | ShopRemote |
| rustdesk | shopremote |
| carriez | ShopRemote Inc |
| info@rustdesk.com | support@shopcast.kr |
| https://rustdesk.com | https://ai.ilv.co.kr |
| com.carriez.RustDesk | com.shopremote.app |

### 수정된 파일
- `Cargo.toml` — 패키지명, 저자, 설명
- `src/main.rs` — 앱 저자 정보
- `src/client.rs` — 문서 URL
- `src/ui/*.tis` — UI URL
- `flutter/pubspec.yaml` — 앱 설명
- `flutter/lib/main.dart` — 앱 진입점 주석
- `flutter/lib/common.dart` — **기본 서버 ai.ilv.co.kr 설정**
- `flutter/lib/consts.dart` — 브랜드 URL
- `flutter/lib/**/*.dart` — 전체 브랜드명 교체
- `flutter/macos/Runner/Info.plist` — macOS 앱 정보
- `flutter/windows/runner/Runner.rc` — Windows 앱 정보
- `flutter/windows/runner/main.cpp` — Windows 타이틀
- `flutter/android/app/build.gradle` — Android 패키지명
- `README.md` — ShopRemote 소개로 교체

### 기본 서버 설정 위치
```
flutter/lib/common.dart, 약 2906라인
ServerConfig.fromOptions()
idServer 기본값: "ai.ilv.co.kr"
relayServer 기본값: "ai.ilv.co.kr"
Public Key: r8Mxm2lf9f5l9MGHufGp7aPiMEHcygeCPhcdps30b5w=
```
사용자가 설정 > 네트워크에서 변경 가능.

### 변경하지 않은 것
- `LICENCE` — AGPL-3.0 라이선스 원본 유지
- `libs/*/` 의존성 GitHub URL — 빌드에 필요하므로 유지
- 핵심 원격제어 로직 — 수정 없음

### 다음 작업
- [ ] 아이콘 교체 (ShopRemote 전용 아이콘)
- [ ] GitHub Actions 빌드 설정 (Windows .exe, macOS .dmg 자동 빌드)
- [ ] 서브모듈 포함 전체 클론 후 실제 컴파일 테스트
