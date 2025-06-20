# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.5] - 2024-12-16

### 🆕 새로운 기능 / New Features
- **CameraFocus 기능 추가**: 마인드맵의 카메라 포커스를 다양한 방식으로 제어할 수 있는 기능
  - `CameraFocus.rootNode`: 루트 노드 중심으로 포커스
  - `CameraFocus.center`: 캔버스 정중앙으로 포커스  
  - `CameraFocus.fitAll`: 모든 노드가 보이도록 자동 조정 (스마트 스케일링)
  - `CameraFocus.firstLeaf`: 첫 번째 리프 노드로 포커스
  - `CameraFocus.custom`: 특정 노드 ID로 포커스 (`focusNodeId`와 함께 사용)
- **포커스 애니메이션**: `focusAnimation` 속성으로 부드러운 포커스 이동 애니메이션 지원
- **포커스 여백**: `focusMargin` 속성으로 포커스 시 여백 조정 가능
- **작은 Container 환경 최적화**: 제한된 공간에서도 마인드맵이 잘 보이도록 개선

### 🛠️ 개선사항 / Improvements  
- 카메라 포커스 로직을 분리하여 더 유연한 뷰 제어 가능
- `fitAll` 모드에서 스마트 스케일링으로 모든 노드를 효율적으로 표시
- 트랜스폼 애니메이션 성능 최적화
- 작은 Container에서의 UX 대폭 개선

### 📦 새로운 API
- `cameraFocus`: 카메라 포커스 옵션 설정
- `focusNodeId`: 포커스할 특정 노드 ID
- `focusAnimation`: 포커스 애니메이션 지속시간
- `focusMargin`: 포커스 시 여백 설정

### 🎯 사용 사례
작은 위젯이나 제한된 공간에서 마인드맵을 사용할 때 특히 유용합니다:
```dart
Container(
  height: 200,
  child: MindMapWidget(
    data: data,
    cameraFocus: CameraFocus.fitAll,
    focusAnimation: Duration(milliseconds: 500),
    focusMargin: EdgeInsets.all(10),
  ),
)
```

## [1.0.4] - 2025-06-19

### Added
- 🎯 **자동 중앙 정렬 기능**: 초기 로드 시 루트 노드가 자동으로 화면 중앙에 위치 / **Auto-centering**: Root node automatically centers on initial load
- 📏 **초기 줌 스케일 설정**: `initialScale` 속성으로 기본 확대/축소 레벨 조정 가능 / **Initial zoom scale**: `initialScale` property for default zoom level control
- 📂 **노드 기본 확장 상태**: `isNodesCollapsed` 속성으로 노드 초기 상태 제어 / **Default node expansion**: `isNodesCollapsed` property for initial node state control
- 📸 **이미지 캡처 기능**: `captureKey` 속성으로 마인드맵을 이미지로 저장 가능 / **Image capture**: `captureKey` property for saving mind map as image
- 🔄 **TransformationController 지원**: 뷰포트 위치 및 줌 레벨 프로그래밍 제어 / **TransformationController support**: Programmatic viewport and zoom control

### Improved
- 🔧 **텍스트 렌더링 품질**: `softWrap: true` 적용으로 텍스트 오버플로우 방지 / **Text rendering quality**: `softWrap: true` prevents text overflow
- ⚡ **초기 로딩 성능**: 자동 중앙 정렬로 사용자 경험 개선 / **Initial loading performance**: Auto-centering improves user experience
- 🎨 **InteractiveViewer 최적화**: 더 부드러운 팬/줌 인터랙션 / **InteractiveViewer optimization**: Smoother pan/zoom interactions
- 📱 **반응형 개선**: 다양한 화면 크기에서 더 나은 적응성 / **Responsive improvements**: Better adaptation to various screen sizes

### Fixed
- ❌ **초기 뷰포트 문제**: 루트 노드가 화면 밖에 위치하는 문제 해결 / **Initial viewport issue**: Fixed root node appearing outside viewport
- 🔤 **텍스트 잘림 문제**: 긴 텍스트의 표시 오류 해결 / **Text clipping issue**: Fixed display errors with long text
- 🎯 **노드 포커스 문제**: 사용자가 마인드맵을 찾기 어려운 문제 해결 / **Node focus issue**: Fixed difficulty finding mind map content

### Breaking Changes
- None - 이 업데이트는 모든 기존 API와 호환됩니다 / This update is fully compatible with existing APIs

### Usage Examples
```dart
MindMapWidget(
  data: yourMindMapData,
  initialScale: 0.8,           // 초기 80% 줌 레벨
  isNodesCollapsed: false,     // 모든 노드 기본 확장
  captureKey: GlobalKey(),     // 이미지 캡처용 키
  style: MindMapStyle(
    // ... 기존 스타일 설정
  ),
)
```

### Contributors
- Special thanks to @TOZXII for the major contributions including auto-centering, initial scale, and image capture features

## [1.0.3] - 2025-06-06

### Added
- 실제 노드 위치 기반 동적 캔버스 크기 계산 시스템 / Dynamic canvas sizing system based on actual node positions
- 콘텐츠 경계 박스 계산으로 정확한 캔버스 크기 결정 / Accurate canvas sizing through content bounding box calculation
- 스마트 패딩 시스템으로 최적화된 여백 관리 / Smart padding system for optimized margin management

### Improved
- 텍스트 라인 수 제한 해제 (무제한 텍스트 표시 가능) / Unlimited text lines support (removed maxLines restriction)
- 한국어/영어 주석 순서 표준화 (한국어 먼저, 영어 나중) / Standardized Korean/English comment order
- 비대칭 트리 구조에서도 정확한 레이아웃 계산 / Accurate layout calculation even for asymmetric tree structures
- 노드 크기에 따른 동적 여백 조정 / Dynamic margin adjustment based on node sizes
- InteractiveViewer 기본 설정 개선 (constrained: true, 경계 마진 축소) / Improved InteractiveViewer defaults

### Fixed
- 큰 마인드맵에서 노드가 캔버스 경계를 벗어나는 문제 해결 / Fixed nodes exceeding canvas boundaries in large mind maps
- 콘텐츠 크기와 캔버스 크기 불일치 문제 해결 / Resolved content size and canvas size mismatch issues
- 루트 노드 위치 계산 정확도 향상 / Improved root node positioning accuracy
- MindMapWidget이 Expanded 위젯 안에서 화면을 벗어나는 문제 해결 / Fixed MindMapWidget exceeding screen boundaries inside Expanded widget

### Technical Details
- 2단계 레이아웃 시스템: 임시 계산 → 실제 크기 계산 → 재조정 / Two-stage layout system: temporary calculation → actual size calculation → readjustment
- `_calculateRequiredCanvasSize()` 메서드로 정확한 캔버스 크기 계산 / Precise canvas size calculation with `_calculateRequiredCanvasSize()` method
- `_collectAllVisibleNodes()` 메서드로 효율적인 노드 수집 / Efficient node collection with `_collectAllVisibleNodes()` method
- README에 중요한 사용법 주의사항 추가 / Added important usage notes to README

## [1.0.2] - 2025-06-13

### Added
- Screenshots and demo GIF in README
- GitHub raw links for images to ensure pub.dev compatibility
- Improved README readability with emojis and cleaner formatting
- Bilingual documentation (Korean/English)

### Improved
- Dynamic spacing calculation based on node sizes
- Better curve control points for connections
- Code comments with English translations
- Documentation structure and visual presentation

### Fixed
- Image display issues on pub.dev by using GitHub raw URLs
- Code formatting and removed unnecessary comments

## [1.0.1] - 2025-06-13

### Added
- Dynamic node sizing based on text content
- Enhanced spacing calculations for better layout
- Improved connection line rendering
- Auto-sizing configuration options

### Improved
- Node overlap prevention
- Curve connection quality
- Layout consistency across all directions
- Performance optimizations

### Fixed
- Connection point calculations for variable node sizes
- Layout issues in split arrangements
- Animation smoothness

## [1.0.0] - 2025-06-13

### Added
- Initial release of Reactive Mind Map package
- Multiple layout options (right, left, top, bottom, radial, horizontal, vertical)
- Six node shapes (rounded rectangle, circle, rectangle, diamond, hexagon, ellipse)
- Comprehensive styling system with MindMapStyle
- Interactive features (tap, long press, double tap, expand/collapse)
- Smooth animations with customizable curves and duration
- Pan and zoom functionality
- Rich customization options for colors, fonts, and effects
- Shadow effects for nodes
- Connection line customization
- Comprehensive test suite
- Example application demonstrating all features
- MIT License
- Complete documentation

### 기술적 특징
- Flutter 3.0+ 지원
- 반응형 디자인
- 접근성 고려
- 타입 안전성

### 지원 플랫폼
- Android
- iOS  
- Web
- Windows
- macOS
- Linux 