import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/mind_map_node.dart';
import '../models/mind_map_style.dart';
import '../enums/mind_map_layout.dart';

/// 마인드맵 전체를 그리는 커스텀 페인터
class MindMapPainter extends CustomPainter {
  final MindMapNode rootNode;
  final MindMapStyle style;

  MindMapPainter(this.rootNode, this.style);

  @override
  void paint(Canvas canvas, Size size) {
    _drawConnections(canvas, rootNode);
  }

  /// 연결선을 그리는 메소드
  void _drawConnections(Canvas canvas, MindMapNode node) {
    if (!node.isExpanded || node.children.isEmpty) return;

    for (var child in node.children) {
      _drawConnection(canvas, node, child);
      _drawConnections(canvas, child);
    }
  }

  /// 두 노드 사이의 연결선을 그리는 메소드
  void _drawConnection(Canvas canvas, MindMapNode parent, MindMapNode child) {
    final paint =
        Paint()
          ..color = style.connectionColor.withValues(alpha: 0.6)
          ..strokeWidth = style.connectionWidth
          ..style = PaintingStyle.stroke;

    if (style.useCustomCurve) {
      _drawCurvedConnection(canvas, parent, child, paint);
    } else {
      _drawStraightConnection(canvas, parent, child, paint);
    }
  }

  /// 곡선 연결선 그리기
  void _drawCurvedConnection(
    Canvas canvas,
    MindMapNode parent,
    MindMapNode child,
    Paint paint,
  ) {
    final path = Path();

    // 레이아웃에 따라 연결점 계산
    final connectionPoints = _getConnectionPoints(parent, child);
    final startPoint = connectionPoints['start']!;
    final endPoint = connectionPoints['end']!;

    path.moveTo(startPoint.dx, startPoint.dy);

    // 레이아웃에 따른 제어점 계산
    final controlPoints = _getControlPoints(startPoint, endPoint);

    path.cubicTo(
      controlPoints['control1']!.dx,
      controlPoints['control1']!.dy,
      controlPoints['control2']!.dx,
      controlPoints['control2']!.dy,
      endPoint.dx,
      endPoint.dy,
    );

    canvas.drawPath(path, paint);
  }

  /// 직선 연결선 그리기
  void _drawStraightConnection(
    Canvas canvas,
    MindMapNode parent,
    MindMapNode child,
    Paint paint,
  ) {
    final connectionPoints = _getConnectionPoints(parent, child);
    final startPoint = connectionPoints['start']!;
    final endPoint = connectionPoints['end']!;

    canvas.drawLine(startPoint, endPoint, paint);
  }

  /// 레이아웃에 따른 연결점 계산
  Map<String, Offset> _getConnectionPoints(
    MindMapNode parent,
    MindMapNode child,
  ) {
    final parentSize = style.getNodeSize(parent.level);
    final childSize = style.getNodeSize(child.level);

    Offset startPoint;
    Offset endPoint;

    switch (style.layout) {
      case MindMapLayout.right:
        startPoint = Offset(
          parent.position.dx + parentSize / 2,
          parent.position.dy,
        );
        endPoint = Offset(child.position.dx - childSize / 2, child.position.dy);
        break;

      case MindMapLayout.left:
        startPoint = Offset(
          parent.position.dx - parentSize / 2,
          parent.position.dy,
        );
        endPoint = Offset(child.position.dx + childSize / 2, child.position.dy);
        break;

      case MindMapLayout.top:
        startPoint = Offset(
          parent.position.dx,
          parent.position.dy - parentSize / 2,
        );
        endPoint = Offset(child.position.dx, child.position.dy + childSize / 2);
        break;

      case MindMapLayout.bottom:
        startPoint = Offset(
          parent.position.dx,
          parent.position.dy + parentSize / 2,
        );
        endPoint = Offset(child.position.dx, child.position.dy - childSize / 2);
        break;

      case MindMapLayout.radial:
      case MindMapLayout.horizontal:
      case MindMapLayout.vertical:
        // 각도 기반 연결점 계산
        final angle = math.atan2(
          child.position.dy - parent.position.dy,
          child.position.dx - parent.position.dx,
        );
        startPoint = Offset(
          parent.position.dx + math.cos(angle) * parentSize / 2,
          parent.position.dy + math.sin(angle) * parentSize / 2,
        );
        endPoint = Offset(
          child.position.dx - math.cos(angle) * childSize / 2,
          child.position.dy - math.sin(angle) * childSize / 2,
        );
        break;
    }

    return {'start': startPoint, 'end': endPoint};
  }

  /// 베지어 곡선의 제어점 계산
  Map<String, Offset> _getControlPoints(Offset start, Offset end) {
    Offset control1, control2;

    switch (style.layout) {
      case MindMapLayout.right:
        control1 = Offset(start.dx + 120, start.dy);
        control2 = Offset(end.dx - 120, end.dy);
        break;

      case MindMapLayout.left:
        control1 = Offset(start.dx - 120, start.dy);
        control2 = Offset(end.dx + 120, end.dy);
        break;

      case MindMapLayout.top:
        control1 = Offset(start.dx, start.dy - 120);
        control2 = Offset(end.dx, end.dy + 120);
        break;

      case MindMapLayout.bottom:
        control1 = Offset(start.dx, start.dy + 120);
        control2 = Offset(end.dx, end.dy - 120);
        break;

      case MindMapLayout.radial:
      case MindMapLayout.horizontal:
      case MindMapLayout.vertical:
        // 중점 기반 제어점
        final midX = (start.dx + end.dx) / 2;
        final midY = (start.dy + end.dy) / 2;
        control1 = Offset(
          midX + (start.dx - midX) * 0.5,
          midY + (start.dy - midY) * 0.5,
        );
        control2 = Offset(
          midX + (end.dx - midX) * 0.5,
          midY + (end.dy - midY) * 0.5,
        );
        break;
    }

    return {'control1': control1, 'control2': control2};
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! MindMapPainter ||
        oldDelegate.rootNode != rootNode ||
        oldDelegate.style != style;
  }
}
