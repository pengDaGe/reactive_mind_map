import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import '../models/mind_map_data.dart';
import '../models/mind_map_style.dart';
import '../models/mind_map_node.dart';
import '../enums/mind_map_layout.dart';
import '../enums/node_shape.dart';
import '../painters/mind_map_painter.dart';
import '../painters/node_painter.dart';

/// 커스터마이징 가능한 마인드맵 위젯
class MindMapWidget extends StatefulWidget {
  /// 마인드맵 데이터
  final MindMapData data;

  /// 마인드맵 스타일
  final MindMapStyle style;

  /// 노드 탭 콜백
  final Function(MindMapData node)? onNodeTap;

  /// 노드 길게 누르기 콜백
  final Function(MindMapData node)? onNodeLongPress;

  /// 노드 더블 탭 콜백
  final Function(MindMapData node)? onNodeDoubleTap;

  /// 확장/축소 상태 변경 콜백
  final Function(MindMapData node, bool isExpanded)? onNodeExpandChanged;

  /// 마인드맵 영역 크기 (null이면 자동 계산)
  final Size? canvasSize;

  /// 뷰어 설정
  final InteractiveViewerOptions? viewerOptions;

  const MindMapWidget({
    super.key,
    required this.data,
    this.style = const MindMapStyle(),
    this.onNodeTap,
    this.onNodeLongPress,
    this.onNodeDoubleTap,
    this.onNodeExpandChanged,
    this.canvasSize,
    this.viewerOptions,
  });

  @override
  State<MindMapWidget> createState() => _MindMapWidgetState();
}

/// 뷰어 옵션 설정
class InteractiveViewerOptions {
  final bool constrained;
  final EdgeInsets boundaryMargin;
  final double minScale;
  final double maxScale;
  final bool enablePanAndZoom;

  const InteractiveViewerOptions({
    this.constrained = false,
    this.boundaryMargin = const EdgeInsets.all(200),
    this.minScale = 0.1,
    this.maxScale = 3.0,
    this.enablePanAndZoom = true,
  });
}

class _MindMapWidgetState extends State<MindMapWidget>
    with TickerProviderStateMixin {
  late MindMapNode _rootNode;
  final List<AnimationController> _activeAnimations = [];
  String? _selectedNodeId;

  // 레이아웃 계산용 변수들
  final double _calculatedCanvasWidth = 2400;
  final double _calculatedCanvasHeight = 1600;
  late Offset _rootPosition;

  @override
  void initState() {
    super.initState();
    _initializeMindMap();
    _calculateRootPosition();
    _calculateLayout();
  }

  @override
  void didUpdateWidget(MindMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data || oldWidget.style != widget.style) {
      _initializeMindMap();
      _calculateRootPosition();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _calculateLayout();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _activeAnimations) {
      controller.dispose();
    }
    super.dispose();
  }

  /// 마인드맵 초기화
  void _initializeMindMap() {
    _rootNode = MindMapNode.fromData(
      widget.data,
      0,
      defaultColors: widget.style.defaultNodeColors,
    );
  }

  /// 루트 노드 위치 계산
  void _calculateRootPosition() {
    final canvasSize =
        widget.canvasSize ??
        Size(_calculatedCanvasWidth, _calculatedCanvasHeight);

    switch (widget.style.layout) {
      case MindMapLayout.right:
        _rootPosition = Offset(150, canvasSize.height / 2);
        break;
      case MindMapLayout.left:
        _rootPosition = Offset(canvasSize.width - 150, canvasSize.height / 2);
        break;
      case MindMapLayout.top:
        _rootPosition = Offset(canvasSize.width / 2, canvasSize.height - 150);
        break;
      case MindMapLayout.bottom:
        _rootPosition = Offset(canvasSize.width / 2, 150);
        break;
      case MindMapLayout.radial:
      case MindMapLayout.horizontal:
      case MindMapLayout.vertical:
        _rootPosition = Offset(canvasSize.width / 2, canvasSize.height / 2);
        break;
    }

    _rootNode.position = _rootPosition;
    _rootNode.targetPosition = _rootPosition;
    _rootNode.hasFixedPosition = true;
  }

  /// 전체 레이아웃 계산
  void _calculateLayout() {
    if (!mounted) return;

    try {
      _calculateSubtreeHeights(_rootNode);
      _assignPositions(_rootNode, 0);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('레이아웃 계산 오류: $e');
      _resetToBasicLayout();
    }
  }

  /// 기본 레이아웃으로 복원
  void _resetToBasicLayout() {
    _rootNode.position = _rootPosition;
    _rootNode.targetPosition = _rootPosition;
    if (mounted) {
      setState(() {});
    }
  }

  /// 서브트리 높이 계산
  double _calculateSubtreeHeights(MindMapNode node, {Set<String>? visited}) {
    visited ??= <String>{};

    if (visited.contains(node.id)) {
      return widget.style.getNodeSize(node.level) + widget.style.nodeMargin;
    }
    visited.add(node.id);

    if (node.children.isEmpty) {
      node.subtreeHeight =
          widget.style.getNodeSize(node.level) + widget.style.nodeMargin;
      return node.subtreeHeight;
    }

    double totalChildHeight = 0;
    for (var child in node.children) {
      totalChildHeight += _calculateSubtreeHeights(
        child,
        visited: Set.from(visited),
      );
    }

    node.subtreeHeight = math.max(
      totalChildHeight,
      widget.style.getNodeSize(node.level) + widget.style.nodeMargin,
    );

    return node.subtreeHeight;
  }

  /// 노드 위치 할당
  void _assignPositions(MindMapNode parent, int level, {Set<String>? visited}) {
    visited ??= <String>{};

    if (visited.contains(parent.id) || parent.children.isEmpty) return;
    visited.add(parent.id);

    switch (widget.style.layout) {
      case MindMapLayout.right:
        _assignRightLayout(parent, level);
        break;
      case MindMapLayout.left:
        _assignLeftLayout(parent, level);
        break;
      case MindMapLayout.top:
        _assignTopLayout(parent, level);
        break;
      case MindMapLayout.bottom:
        _assignBottomLayout(parent, level);
        break;
      case MindMapLayout.radial:
        _assignRadialLayout(parent, level);
        break;
      case MindMapLayout.horizontal:
        _assignHorizontalLayout(parent, level);
        break;
      case MindMapLayout.vertical:
        _assignVerticalLayout(parent, level);
        break;
    }

    for (var child in parent.children) {
      _assignPositions(child, level + 1, visited: Set.from(visited));
    }
  }

  /// 오른쪽 방향 레이아웃
  void _assignRightLayout(MindMapNode parent, int level) {
    final x = _rootPosition.dx + (level + 1) * widget.style.levelSpacing;
    double totalHeight = parent.children.fold(
      0.0,
      (sum, child) => sum + child.subtreeHeight,
    );
    double currentY = parent.targetPosition.dy - totalHeight / 2;

    for (var child in parent.children) {
      if (!child.hasFixedPosition) {
        final childCenterY = currentY + child.subtreeHeight / 2;
        child.targetPosition = Offset(x, childCenterY);
        child.position = child.targetPosition;
        child.hasFixedPosition = true;
      }
      currentY += child.subtreeHeight;
    }
  }

  /// 왼쪽 방향 레이아웃
  void _assignLeftLayout(MindMapNode parent, int level) {
    final x = _rootPosition.dx - (level + 1) * widget.style.levelSpacing;
    double totalHeight = parent.children.fold(
      0.0,
      (sum, child) => sum + child.subtreeHeight,
    );
    double currentY = parent.targetPosition.dy - totalHeight / 2;

    for (var child in parent.children) {
      if (!child.hasFixedPosition) {
        final childCenterY = currentY + child.subtreeHeight / 2;
        child.targetPosition = Offset(x, childCenterY);
        child.position = child.targetPosition;
        child.hasFixedPosition = true;
      }
      currentY += child.subtreeHeight;
    }
  }

  /// 위쪽 방향 레이아웃
  void _assignTopLayout(MindMapNode parent, int level) {
    final y = _rootPosition.dy - (level + 1) * widget.style.levelSpacing;
    double totalWidth = parent.children.fold(
      0.0,
      (sum, child) =>
          sum + widget.style.getNodeSize(child.level) + widget.style.nodeMargin,
    );
    double currentX = parent.targetPosition.dx - totalWidth / 2;

    for (var child in parent.children) {
      if (!child.hasFixedPosition) {
        final childSize = widget.style.getNodeSize(child.level);
        final childCenterX = currentX + childSize / 2;
        child.targetPosition = Offset(childCenterX, y);
        child.position = child.targetPosition;
        child.hasFixedPosition = true;
        currentX += childSize + widget.style.nodeMargin;
      }
    }
  }

  /// 아래쪽 방향 레이아웃
  void _assignBottomLayout(MindMapNode parent, int level) {
    final y = _rootPosition.dy + (level + 1) * widget.style.levelSpacing;
    double totalWidth = parent.children.fold(
      0.0,
      (sum, child) =>
          sum + widget.style.getNodeSize(child.level) + widget.style.nodeMargin,
    );
    double currentX = parent.targetPosition.dx - totalWidth / 2;

    for (var child in parent.children) {
      if (!child.hasFixedPosition) {
        final childSize = widget.style.getNodeSize(child.level);
        final childCenterX = currentX + childSize / 2;
        child.targetPosition = Offset(childCenterX, y);
        child.position = child.targetPosition;
        child.hasFixedPosition = true;
        currentX += childSize + widget.style.nodeMargin;
      }
    }
  }

  /// 원형 방향 레이아웃
  void _assignRadialLayout(MindMapNode parent, int level) {
    final radius = (level + 1) * widget.style.levelSpacing;
    final angleStep = (2 * math.pi) / parent.children.length;

    for (int i = 0; i < parent.children.length; i++) {
      final child = parent.children[i];
      if (!child.hasFixedPosition) {
        final angle = i * angleStep;
        final x = parent.targetPosition.dx + radius * math.cos(angle);
        final y = parent.targetPosition.dy + radius * math.sin(angle);
        child.targetPosition = Offset(x, y);
        child.position = child.targetPosition;
        child.hasFixedPosition = true;
      }
    }
  }

  /// 수평 방향 레이아웃 (좌우로 분할)
  void _assignHorizontalLayout(MindMapNode parent, int level) {
    final leftChildren =
        parent.children.take((parent.children.length / 2).ceil()).toList();
    final rightChildren = parent.children.skip(leftChildren.length).toList();

    // 왼쪽 자식들
    _assignChildrenToSide(leftChildren, parent, level, -1);
    // 오른쪽 자식들
    _assignChildrenToSide(rightChildren, parent, level, 1);
  }

  /// 수직 방향 레이아웃 (위아래로 분할)
  void _assignVerticalLayout(MindMapNode parent, int level) {
    final topChildren =
        parent.children.take((parent.children.length / 2).ceil()).toList();
    final bottomChildren = parent.children.skip(topChildren.length).toList();

    // 위쪽 자식들
    _assignChildrenVertically(topChildren, parent, level, -1);
    // 아래쪽 자식들
    _assignChildrenVertically(bottomChildren, parent, level, 1);
  }

  /// 한쪽으로 자식 노드들 배치
  void _assignChildrenToSide(
    List<MindMapNode> children,
    MindMapNode parent,
    int level,
    int direction,
  ) {
    final x =
        parent.targetPosition.dx +
        direction * (level + 1) * widget.style.levelSpacing;
    double totalHeight = children.fold(
      0.0,
      (sum, child) => sum + child.subtreeHeight,
    );
    double currentY = parent.targetPosition.dy - totalHeight / 2;

    for (var child in children) {
      if (!child.hasFixedPosition) {
        final childCenterY = currentY + child.subtreeHeight / 2;
        child.targetPosition = Offset(x, childCenterY);
        child.position = child.targetPosition;
        child.hasFixedPosition = true;
      }
      currentY += child.subtreeHeight;
    }
  }

  /// 위아래로 자식 노드들 배치
  void _assignChildrenVertically(
    List<MindMapNode> children,
    MindMapNode parent,
    int level,
    int direction,
  ) {
    final y =
        parent.targetPosition.dy +
        direction * (level + 1) * widget.style.levelSpacing;
    double totalWidth = children.fold(
      0.0,
      (sum, child) =>
          sum + widget.style.getNodeSize(child.level) + widget.style.nodeMargin,
    );
    double currentX = parent.targetPosition.dx - totalWidth / 2;

    for (var child in children) {
      if (!child.hasFixedPosition) {
        final childSize = widget.style.getNodeSize(child.level);
        final childCenterX = currentX + childSize / 2;
        child.targetPosition = Offset(childCenterX, y);
        child.position = child.targetPosition;
        child.hasFixedPosition = true;
        currentX += childSize + widget.style.nodeMargin;
      }
    }
  }

  /// 노드 토글
  void _toggleNode(MindMapNode node) {
    if (node.children.isEmpty || !mounted) return;

    HapticFeedback.lightImpact();

    setState(() {
      node.isExpanded = !node.isExpanded;

      if (node.isExpanded) {
        try {
          _calculateLayout();

          for (var child in node.children) {
            child.position = node.position;
            child.isAnimating = true;
          }

          _animateChildren(node);
        } catch (e) {
          debugPrint('토글 오류: $e');
          node.isExpanded = false;
        }
      } else {
        _calculateLayout();
      }
    });

    // 콜백 호출
    final originalData = _findOriginalData(node.id);
    if (originalData != null) {
      widget.onNodeExpandChanged?.call(originalData, node.isExpanded);
    }
  }

  /// 자식 노드 애니메이션
  void _animateChildren(MindMapNode node) {
    if (!mounted || node.children.isEmpty) return;

    final controller = AnimationController(
      duration: widget.style.animationDuration,
      vsync: this,
    );

    _activeAnimations.add(controller);

    final animation = CurvedAnimation(
      parent: controller,
      curve: widget.style.animationCurve,
    );

    final startPositions = <String, Offset>{};
    for (var child in node.children) {
      startPositions[child.id] = child.position;
    }

    controller.addListener(() {
      if (!mounted) return;

      final progress = animation.value;

      try {
        for (var child in node.children) {
          if (child.isAnimating) {
            final startPos = startPositions[child.id];
            if (startPos != null) {
              child.position =
                  Offset.lerp(startPos, child.targetPosition, progress)!;
            }
          }
        }

        if (progress >= 1.0) {
          for (var child in node.children) {
            child.isAnimating = false;
            child.position = child.targetPosition;
          }
          _activeAnimations.remove(controller);
          controller.dispose();
        }

        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        debugPrint('애니메이션 오류: $e');
        for (var child in node.children) {
          child.isAnimating = false;
          child.position = child.targetPosition;
        }
        _activeAnimations.remove(controller);
        controller.dispose();
      }
    });

    controller.forward().catchError((error) {
      debugPrint('애니메이션 시작 오류: $error');
      _activeAnimations.remove(controller);
      controller.dispose();
    });
  }

  /// 노드 선택
  void _selectNode(MindMapNode node) {
    setState(() {
      _selectedNodeId = node.id;
    });

    final originalData = _findOriginalData(node.id);
    if (originalData != null) {
      widget.onNodeTap?.call(originalData);
    }
  }

  /// 원본 데이터 찾기
  MindMapData? _findOriginalData(String nodeId) {
    return _searchData(widget.data, nodeId);
  }

  MindMapData? _searchData(MindMapData data, String targetId) {
    if (data.id == targetId) return data;

    for (var child in data.children) {
      final result = _searchData(child, targetId);
      if (result != null) return result;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final canvasSize =
        widget.canvasSize ??
        Size(_calculatedCanvasWidth, _calculatedCanvasHeight);
    final viewerOptions =
        widget.viewerOptions ?? const InteractiveViewerOptions();

    final mindMapContent = Container(
      width: canvasSize.width,
      height: canvasSize.height,
      color: widget.style.backgroundColor,
      child: CustomPaint(
        painter: MindMapPainter(_rootNode, widget.style),
        child: Stack(children: _buildAllNodes(_rootNode)),
      ),
    );

    if (viewerOptions.enablePanAndZoom) {
      return InteractiveViewer(
        constrained: viewerOptions.constrained,
        boundaryMargin: viewerOptions.boundaryMargin,
        minScale: viewerOptions.minScale,
        maxScale: viewerOptions.maxScale,
        child: mindMapContent,
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: mindMapContent,
        ),
      );
    }
  }

  /// 모든 노드 위젯 빌드
  List<Widget> _buildAllNodes(MindMapNode node, {Set<String>? visited}) {
    visited ??= <String>{};

    if (visited.contains(node.id)) return [];
    visited.add(node.id);

    List<Widget> widgets = [];
    widgets.add(_buildNodeWidget(node));

    if (node.isExpanded && node.children.isNotEmpty) {
      for (var child in node.children) {
        widgets.addAll(_buildAllNodes(child, visited: Set.from(visited)));
      }
    }

    return widgets;
  }

  /// 개별 노드 위젯 빌드
  Widget _buildNodeWidget(MindMapNode node) {
    final isSelected = _selectedNodeId == node.id;
    final nodeSize = widget.style.getNodeSize(node.level);
    final textSize = widget.style.getTextSize(node.level);

    // 색상 결정
    final nodeColor = node.color;
    final textColor = node.textColor ?? widget.style.defaultTextStyle.color;
    final borderColor =
        node.borderColor ??
        (isSelected ? widget.style.selectionBorderColor : Colors.white);

    return Positioned(
      key: ValueKey('positioned_${node.id}'),
      left: node.position.dx - nodeSize / 2,
      top: node.position.dy - nodeSize / 2,
      child: GestureDetector(
        onTap: () {
          if (node.hasChildren) {
            _toggleNode(node);
          } else {
            _selectNode(node);
          }
        },
        onLongPress: () {
          final originalData = _findOriginalData(node.id);
          if (originalData != null) {
            widget.onNodeLongPress?.call(originalData);
          }
        },
        onDoubleTap: () {
          final originalData = _findOriginalData(node.id);
          if (originalData != null) {
            widget.onNodeDoubleTap?.call(originalData);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: nodeSize,
          height: nodeSize,
          child: CustomPaint(
            painter: _NodeWidgetPainter(
              shape: widget.style.nodeShape,
              fillColor: nodeColor,
              borderColor: borderColor,
              borderWidth: isSelected ? widget.style.selectionBorderWidth : 2.0,
              shadowEnabled: widget.style.enableNodeShadow,
              shadowColor: widget.style.nodeShadowColor,
              shadowBlurRadius: widget.style.nodeShadowBlurRadius,
              shadowSpreadRadius: widget.style.nodeShadowSpreadRadius,
              shadowOffset: widget.style.nodeShadowOffset,
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      node.title,
                      textAlign: TextAlign.center,
                      style: (node.textStyle ?? widget.style.defaultTextStyle)
                          .copyWith(color: textColor, fontSize: textSize),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (node.hasChildren)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        node.isExpanded ? Icons.remove : Icons.add,
                        size: 12,
                        color: nodeColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 노드 위젯을 그리는 커스텀 페인터
class _NodeWidgetPainter extends CustomPainter {
  final NodeShape shape;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final bool shadowEnabled;
  final Color shadowColor;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;
  final Offset shadowOffset;

  _NodeWidgetPainter({
    required this.shape,
    required this.fillColor,
    required this.borderColor,
    required this.borderWidth,
    required this.shadowEnabled,
    required this.shadowColor,
    required this.shadowBlurRadius,
    required this.shadowSpreadRadius,
    required this.shadowOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final fillPaint =
        Paint()
          ..color = fillColor
          ..style = PaintingStyle.fill;

    final borderPaint =
        Paint()
          ..color = borderColor
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke;

    // 그림자 그리기
    if (shadowEnabled) {
      final shadowPaint =
          Paint()
            ..color = shadowColor
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlurRadius)
            ..style = PaintingStyle.fill;

      final shadowRect = rect.shift(shadowOffset);
      NodePainter.paintNode(
        canvas: canvas,
        rect: shadowRect,
        shape: shape,
        fillPaint: shadowPaint,
      );
    }

    // 메인 노드 그리기
    NodePainter.paintNode(
      canvas: canvas,
      rect: rect,
      shape: shape,
      fillPaint: fillPaint,
      borderPaint: borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
