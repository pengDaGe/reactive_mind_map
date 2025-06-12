# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2024-12-06

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

## [1.0.2] - 2024-12-06

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

## [1.0.1] - 2024-12-06

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

## [1.0.0] - 2024-12-06

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