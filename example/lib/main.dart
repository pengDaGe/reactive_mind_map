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
      title: 'Camera Focus 테스트',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  CameraFocus currentFocus = CameraFocus.rootNode;
  String? targetNodeId;
  String lastAction = '시작';

  // 간단한 테스트 데이터
  final mindMapData = MindMapData(
    id: 'root',
    title: '🎯 메인',
    children: [
      MindMapData(
        id: 'node1',
        title: '📝 노드1',
        children: [
          MindMapData(id: 'sub1', title: '서브1'),
          MindMapData(id: 'sub2', title: '서브2'),
        ],
      ),
      MindMapData(id: 'node2', title: '🎨 노드2'),
      MindMapData(id: 'node3', title: '🔧 노드3'),
      MindMapData(
        id: 'node4',
        title: '🚀 노드4',
        children: [MindMapData(id: 'final', title: '마지막')],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카메라 포커스 테스트'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 간단한 버튼들
          Container(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              children: [
                _buildButton(
                  '🎯 루트',
                  () => _focusToNode(CameraFocus.rootNode, null),
                ),
                _buildButton(
                  '🔍 전체보기',
                  () => _focusToNode(CameraFocus.fitAll, null),
                ),
                _buildButton(
                  '📝 노드1',
                  () => _focusToNode(CameraFocus.custom, 'node1'),
                ),
                _buildButton(
                  '서브1',
                  () => _focusToNode(CameraFocus.custom, 'sub1'),
                ),
                _buildButton(
                  '마지막',
                  () => _focusToNode(CameraFocus.custom, 'final'),
                ),
                _buildButton(
                  '🍃 첫리프',
                  () => _focusToNode(CameraFocus.firstLeaf, null),
                ),
              ],
            ),
          ),

          // 상태 표시
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              children: [
                Text(
                  '현재: ${_getFocusName()} ${targetNodeId != null ? '→ $targetNodeId' : ''}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '마지막 액션: $lastAction',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 마인드맵
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue[300]!, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: MindMapWidget(
                  data: mindMapData,
                  style: const MindMapStyle(
                    backgroundColor: Color(0xFFF8F9FA),
                    defaultNodeColors: [
                      Color(0xFF4CAF50),
                      Color(0xFF2196F3),
                      Color(0xFFFF9800),
                      Color(0xFFE91E63),
                    ],
                    levelSpacing: 120,
                    nodeMargin: 15,
                  ),
                  cameraFocus: CameraFocus.fitAll,
                  focusNodeId: targetNodeId,
                  focusAnimation: const Duration(
                    milliseconds: 1000,
                  ), // 더 긴 애니메이션
                  isNodesCollapsed: false, // 모든 노드 펼쳐져 있음
                  onNodeTap: (node) {
                    print('탭된 노드: ${node.title} (${node.id})');
                    setState(() {
                      lastAction = '노드 탭: ${node.title}';
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  void _focusToNode(CameraFocus focus, String? nodeId) {
    setState(() {
      currentFocus = focus;
      targetNodeId = nodeId;
      lastAction =
          '${_getFocusName()} ${nodeId != null ? '→ $nodeId' : ''}로 이동';
    });
    print('포커스 변경: $focus ${nodeId != null ? '→ $nodeId' : ''}');
  }

  String _getFocusName() {
    switch (currentFocus) {
      case CameraFocus.rootNode:
        return '루트';
      case CameraFocus.fitAll:
        return '전체보기';
      case CameraFocus.custom:
        return '커스텀';
      case CameraFocus.firstLeaf:
        return '첫리프';
      case CameraFocus.center:
        return '중앙';
    }
  }
}
