# Reactive Mind Map

[![pub package](https://img.shields.io/pub/v/reactive_mind_map.svg)](https://pub.dev/packages/reactive_mind_map)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Flutter를 위한 완전히 커스터마이징 가능한 인터랙티브 마인드맵 위젯입니다.

## 특징

🎨 **완전한 커스터마이징**
- 노드 모양 선택 (둥근 사각형, 원형, 다이아몬드, 육각형 등)
- 색상, 텍스트 스타일, 그림자 효과 커스터마이징
- 연결선 스타일과 애니메이션 설정

🎯 **다양한 레이아웃**
- 오른쪽/왼쪽/위/아래 방향 레이아웃
- 원형(Radial) 레이아웃
- 좌우/상하 분할 레이아웃

⚡ **부드러운 애니메이션**
- 노드 확장/축소 애니메이션
- 커스터마이징 가능한 애니메이션 곡선과 지속시간

🖱️ **풍부한 인터랙션**
- 탭, 길게 누르기, 더블 탭 이벤트
- 확대/축소, 팬 기능
- 노드 확장/축소 상태 추적

## 설치

```yaml
dependencies:
  reactive_mind_map: ^1.0.0
```

## 기본 사용법

```dart
import 'package:flutter/material.dart';
import 'package:reactive_mind_map/reactive_mind_map.dart';

class MyMindMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mindMapData = MindMapData(
      id: 'root',
      title: 'Flutter',
      description: 'Flutter 앱 개발',
      children: [
        MindMapData(
          id: 'ui',
          title: 'UI & 위젯',
          children: [
            MindMapData(id: 'widgets', title: '위젯'),
            MindMapData(id: 'layouts', title: '레이아웃'),
          ],
        ),
        MindMapData(
          id: 'state',
          title: '상태 관리',
          children: [
            MindMapData(id: 'provider', title: 'Provider'),
            MindMapData(id: 'bloc', title: 'BLoC'),
          ],
        ),
      ],
    );

    return Scaffold(
      body: MindMapWidget(
        data: mindMapData,
        onNodeTap: (node) {
          print('탭: ${node.title}');
        },
      ),
    );
  }
}
```

## 고급 커스터마이징

### 스타일 커스터마이징

```dart
MindMapWidget(
  data: mindMapData,
  style: MindMapStyle(
    layout: MindMapLayout.radial,  // 원형 레이아웃
    nodeShape: NodeShape.circle,   // 원형 노드
    backgroundColor: Colors.black87,
    connectionColor: Colors.white54,
    defaultNodeColors: [
      Colors.blue[400]!,
      Colors.purple[400]!,
      Colors.green[400]!,
    ],
    animationDuration: Duration(milliseconds: 800),
    animationCurve: Curves.elasticOut,
  ),
)
```

### 다양한 레이아웃

```dart
// 오른쪽 방향 (기본)
MindMapStyle(layout: MindMapLayout.right)

// 원형 레이아웃
MindMapStyle(layout: MindMapLayout.radial)

// 상하 분할
MindMapStyle(layout: MindMapLayout.vertical)

// 좌우 분할
MindMapStyle(layout: MindMapLayout.horizontal)
```

### 노드 모양 변경

```dart
MindMapStyle(
  nodeShape: NodeShape.diamond,  // 다이아몬드
  // 또는
  nodeShape: NodeShape.hexagon,  // 육각형
  nodeShape: NodeShape.circle,   // 원형
)
```

### 개별 노드 커스터마이징

```dart
MindMapData(
  id: 'custom',
  title: '특별한 노드',
  color: Colors.red,
  textColor: Colors.white,
  borderColor: Colors.yellow,
  textStyle: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  size: Size(100, 100),
)
```

### 이벤트 처리

```dart
MindMapWidget(
  data: mindMapData,
  onNodeTap: (node) {
    // 노드 탭 이벤트
    print('탭: ${node.title}');
  },
  onNodeLongPress: (node) {
    // 노드 길게 누르기
    showDialog(/*...*/);
  },
  onNodeDoubleTap: (node) {
    // 노드 더블 탭
    print('더블 탭: ${node.title}');
  },
  onNodeExpandChanged: (node, isExpanded) {
    // 확장/축소 상태 변경
    print('${node.title} ${isExpanded ? '확장' : '축소'}');
  },
)
```

### 뷰어 옵션 설정

```dart
MindMapWidget(
  data: mindMapData,
  canvasSize: Size(3000, 2000),  // 캔버스 크기 설정
  viewerOptions: InteractiveViewerOptions(
    minScale: 0.1,
    maxScale: 5.0,
    enablePanAndZoom: true,
    boundaryMargin: EdgeInsets.all(100),
  ),
)
```

## 사용 가능한 레이아웃

| 레이아웃 | 설명 | 적합한 용도 |
|---------|------|------------|
| `right` | 오른쪽으로 확장 | 기본 마인드맵, 조직도 |
| `left` | 왼쪽으로 확장 | RTL 언어, 특별한 디자인 |
| `top` | 위쪽으로 확장 | 족보, 상향식 구조 |
| `bottom` | 아래쪽으로 확장 | 하향식 구조, 결정 트리 |
| `radial` | 원형으로 확장 | 브레인스토밍, 관계도 |
| `horizontal` | 좌우로 분할 | 대칭적 구조 |
| `vertical` | 상하로 분할 | 시간축, 프로세스 |

## 사용 가능한 노드 모양

| 모양 | 설명 | 시각적 특징 |
|------|------|------------|
| `roundedRectangle` | 둥근 사각형 (기본) | 현대적, 친근함 |
| `circle` | 원형 | 부드러움, 완전성 |
| `rectangle` | 사각형 | 정형성, 전문성 |
| `diamond` | 다이아몬드 | 결정점, 중요성 |
| `hexagon` | 육각형 | 기술적, 혁신적 |
| `ellipse` | 타원 | 자연스러움, 흐름 |

## 성능 최적화

- 대용량 데이터 처리를 위한 적응형 간격 조정
- 무한 재귀 방지 메커니즘
- 효율적인 애니메이션 관리
- 메모리 누수 방지

## 예제

더 많은 예제는 [example](example/) 폴더를 참조하세요.

## 기여하기

이슈 제기나 풀 리퀘스트는 언제나 환영합니다!

## 라이선스

MIT License. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 변경 이력

최신 변경사항은 [CHANGELOG.md](CHANGELOG.md)를 확인하세요.
