import 'package:flutter/material.dart';
import 'package:reactive_mind_map/reactive_mind_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reactive Mind Map Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MindMapLayout _selectedLayout = MindMapLayout.right;
  NodeShape _selectedShape = NodeShape.roundedRectangle;

  final MindMapData _demoData = const MindMapData(
    id: 'root',
    title: 'Reactive\nMind Map',
    description: '커스터마이징 가능한 마인드맵 위젯',
    color: Color(0xFF2563EB),
    children: [
      MindMapData(
        id: 'layouts',
        title: '다양한 레이아웃',
        description: '7가지 레이아웃 지원',
        color: Color(0xFF7C3AED),
        children: [
          MindMapData(
            id: 'directional',
            title: '방향성 레이아웃',
            description: '상하좌우',
            color: Color(0xFF9333EA),
          ),
          MindMapData(
            id: 'radial',
            title: '원형 레이아웃',
            description: '모든 방향으로',
            color: Color(0xFF9333EA),
          ),
        ],
      ),
      MindMapData(
        id: 'shapes',
        title: '노드 모양',
        description: '6가지 모양 지원',
        color: Color(0xFF059669),
        children: [
          MindMapData(
            id: 'basic',
            title: '기본 모양',
            description: '사각형, 원형',
            color: Color(0xFF10B981),
          ),
          MindMapData(
            id: 'special',
            title: '특수 모양',
            description: '다이아몬드, 육각형',
            color: Color(0xFF10B981),
          ),
        ],
      ),
      MindMapData(
        id: 'features',
        title: '주요 기능',
        description: '풍부한 인터랙션',
        color: Color(0xFFDC2626),
        children: [
          MindMapData(
            id: 'animation',
            title: '애니메이션',
            description: '부드러운 전환',
            color: Color(0xFFEF4444),
          ),
          MindMapData(
            id: 'customization',
            title: '커스터마이징',
            description: '완전한 제어',
            color: Color(0xFFEF4444),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reactive Mind Map Package'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          PopupMenuButton<MindMapLayout>(
            icon: const Icon(Icons.view_quilt),
            tooltip: '레이아웃 변경',
            onSelected: (layout) {
              setState(() {
                _selectedLayout = layout;
              });
            },
            itemBuilder:
                (context) =>
                    MindMapLayout.values.map((layout) {
                      return PopupMenuItem(
                        value: layout,
                        child: Text(_getLayoutName(layout)),
                      );
                    }).toList(),
          ),
          PopupMenuButton<NodeShape>(
            icon: const Icon(Icons.category),
            tooltip: '모양 변경',
            onSelected: (shape) {
              setState(() {
                _selectedShape = shape;
              });
            },
            itemBuilder:
                (context) =>
                    NodeShape.values.map((shape) {
                      return PopupMenuItem(
                        value: shape,
                        child: Text(_getShapeName(shape)),
                      );
                    }).toList(),
          ),
        ],
      ),
      body: MindMapWidget(
        data: _demoData,
        style: MindMapStyle(
          layout: _selectedLayout,
          nodeShape: _selectedShape,
          animationDuration: const Duration(milliseconds: 600),
          animationCurve: Curves.easeOutCubic,
        ),
        onNodeTap: (node) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('탭: ${node.title.replaceAll('\n', ' ')}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        onNodeLongPress: (node) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text(node.title.replaceAll('\n', ' ')),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${node.id}'),
                      const SizedBox(height: 8),
                      Text('설명: ${node.description}'),
                      const SizedBox(height: 8),
                      Text('자식 수: ${node.children.length}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('닫기'),
                    ),
                  ],
                ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Reactive Mind Map Package'),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🎨 완전한 커스터마이징'),
                      Text('🎯 다양한 레이아웃'),
                      Text('⚡ 부드러운 애니메이션'),
                      Text('🖱️ 풍부한 인터랙션'),
                      SizedBox(height: 16),
                      Text('상단 메뉴에서 레이아웃과 모양을 변경해보세요!'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('확인'),
                    ),
                  ],
                ),
          );
        },
        child: const Icon(Icons.info),
      ),
    );
  }

  String _getLayoutName(MindMapLayout layout) {
    switch (layout) {
      case MindMapLayout.right:
        return '오른쪽';
      case MindMapLayout.left:
        return '왼쪽';
      case MindMapLayout.top:
        return '위쪽';
      case MindMapLayout.bottom:
        return '아래쪽';
      case MindMapLayout.radial:
        return '원형';
      case MindMapLayout.horizontal:
        return '좌우 분할';
      case MindMapLayout.vertical:
        return '상하 분할';
    }
  }

  String _getShapeName(NodeShape shape) {
    switch (shape) {
      case NodeShape.roundedRectangle:
        return '둥근 사각형';
      case NodeShape.circle:
        return '원형';
      case NodeShape.rectangle:
        return '사각형';
      case NodeShape.diamond:
        return '다이아몬드';
      case NodeShape.hexagon:
        return '육각형';
      case NodeShape.ellipse:
        return '타원';
    }
  }
}
