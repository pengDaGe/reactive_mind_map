import 'package:flutter/material.dart';
import '../enums/mind_map_layout.dart';
import '../enums/node_shape.dart';

/// 마인드맵의 전체적인 스타일을 정의하는 클래스
class MindMapStyle {
  /// 마인드맵 레이아웃 방향
  final MindMapLayout layout;

  /// 노드 모양
  final NodeShape nodeShape;

  /// 배경색
  final Color backgroundColor;

  /// 노드 간 수평 간격
  final double levelSpacing;

  /// 노드 간 수직 여백
  final double nodeMargin;

  /// 연결선 색상
  final Color connectionColor;

  /// 연결선 두께
  final double connectionWidth;

  /// 연결선 스타일 (직선 또는 곡선)
  final bool useCustomCurve;

  /// 기본 노드 색상들 (레벨별로 사용)
  final List<Color> defaultNodeColors;

  /// 기본 텍스트 스타일
  final TextStyle defaultTextStyle;

  /// 루트 노드 크기
  final double rootNodeSize;

  /// 1차 자식 노드 크기
  final double primaryNodeSize;

  /// 리프 노드 크기
  final double leafNodeSize;

  /// 노드 선택 시 테두리 색상
  final Color selectionBorderColor;

  /// 노드 선택 시 테두리 두께
  final double selectionBorderWidth;

  /// 노드 애니메이션 지속 시간
  final Duration animationDuration;

  /// 노드 애니메이션 곡선
  final Curve animationCurve;

  /// 노드 그림자 활성화 여부
  final bool enableNodeShadow;

  /// 노드 그림자 색상
  final Color nodeShadowColor;

  /// 노드 그림자 번짐 정도
  final double nodeShadowBlurRadius;

  /// 노드 그림자 퍼짐 정도
  final double nodeShadowSpreadRadius;

  /// 노드 그림자 오프셋
  final Offset nodeShadowOffset;

  const MindMapStyle({
    this.layout = MindMapLayout.right,
    this.nodeShape = NodeShape.roundedRectangle,
    this.backgroundColor = const Color(0xFFF8FAFC),
    this.levelSpacing = 240.0,
    this.nodeMargin = 20.0,
    this.connectionColor = Colors.grey,
    this.connectionWidth = 2.5,
    this.useCustomCurve = true,
    this.defaultNodeColors = const [
      Color(0xFF2563EB),
      Color(0xFF7C3AED),
      Color(0xFF059669),
      Color(0xFFDC2626),
      Color(0xFFF59E0B),
      Color(0xFF7C2D12),
      Color(0xFF6B21A8),
      Color(0xFF0EA5E9),
      Color(0xFF10B981),
      Color(0xFF8B5CF6),
      Color(0xFF06B6D4),
      Color(0xFFF97316),
    ],
    this.defaultTextStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      height: 1.1,
    ),
    this.rootNodeSize = 80.0,
    this.primaryNodeSize = 60.0,
    this.leafNodeSize = 45.0,
    this.selectionBorderColor = Colors.yellow,
    this.selectionBorderWidth = 3.0,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.easeOutCubic,
    this.enableNodeShadow = true,
    this.nodeShadowColor = Colors.black26,
    this.nodeShadowBlurRadius = 8.0,
    this.nodeShadowSpreadRadius = 1.0,
    this.nodeShadowOffset = const Offset(2, 2),
  });

  /// 스타일 복사를 위한 copyWith 메소드
  MindMapStyle copyWith({
    MindMapLayout? layout,
    NodeShape? nodeShape,
    Color? backgroundColor,
    double? levelSpacing,
    double? nodeMargin,
    Color? connectionColor,
    double? connectionWidth,
    bool? useCustomCurve,
    List<Color>? defaultNodeColors,
    TextStyle? defaultTextStyle,
    double? rootNodeSize,
    double? primaryNodeSize,
    double? leafNodeSize,
    Color? selectionBorderColor,
    double? selectionBorderWidth,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? enableNodeShadow,
    Color? nodeShadowColor,
    double? nodeShadowBlurRadius,
    double? nodeShadowSpreadRadius,
    Offset? nodeShadowOffset,
  }) {
    return MindMapStyle(
      layout: layout ?? this.layout,
      nodeShape: nodeShape ?? this.nodeShape,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      levelSpacing: levelSpacing ?? this.levelSpacing,
      nodeMargin: nodeMargin ?? this.nodeMargin,
      connectionColor: connectionColor ?? this.connectionColor,
      connectionWidth: connectionWidth ?? this.connectionWidth,
      useCustomCurve: useCustomCurve ?? this.useCustomCurve,
      defaultNodeColors: defaultNodeColors ?? this.defaultNodeColors,
      defaultTextStyle: defaultTextStyle ?? this.defaultTextStyle,
      rootNodeSize: rootNodeSize ?? this.rootNodeSize,
      primaryNodeSize: primaryNodeSize ?? this.primaryNodeSize,
      leafNodeSize: leafNodeSize ?? this.leafNodeSize,
      selectionBorderColor: selectionBorderColor ?? this.selectionBorderColor,
      selectionBorderWidth: selectionBorderWidth ?? this.selectionBorderWidth,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      enableNodeShadow: enableNodeShadow ?? this.enableNodeShadow,
      nodeShadowColor: nodeShadowColor ?? this.nodeShadowColor,
      nodeShadowBlurRadius: nodeShadowBlurRadius ?? this.nodeShadowBlurRadius,
      nodeShadowSpreadRadius:
          nodeShadowSpreadRadius ?? this.nodeShadowSpreadRadius,
      nodeShadowOffset: nodeShadowOffset ?? this.nodeShadowOffset,
    );
  }

  /// 노드 레벨에 따른 크기를 반환
  double getNodeSize(int level) {
    if (level == 0) return rootNodeSize;
    if (level == 1) return primaryNodeSize;
    return leafNodeSize;
  }

  /// 노드 레벨에 따른 기본 색상을 반환
  Color getDefaultNodeColor(int level) {
    return defaultNodeColors[level % defaultNodeColors.length];
  }

  /// 노드 레벨에 따른 텍스트 크기를 반환
  double getTextSize(int level) {
    if (level == 0) return 14.0;
    if (level == 1) return 12.0;
    return 10.0;
  }
}
