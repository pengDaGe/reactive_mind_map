import 'package:flutter/material.dart';

/// 마인드맵 노드 데이터를 나타내는 클래스
class MindMapData {
  final String id;
  final String title;
  final String description;
  List<MindMapData> children = [];
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final TextStyle? textStyle;
  final Size? size;
  final Map<String, dynamic>? customData;

  // 构造函数中，默认将 children 初始化为可变的空列表
  MindMapData({
    required this.id,
    required this.title,
    this.description = '',
    List<MindMapData>? children, // 允许传入可变列表
    this.color,
    this.textColor,
    this.borderColor,
    this.textStyle,
    this.size,
    this.customData,
  }) : children = children ?? []; // 如果没有传入 children，则默认为可变的空列表

  // 数据复制方法
  MindMapData copyWith({
    String? id,
    String? title,
    String? description,
    List<MindMapData>? children,
    Color? color,
    Color? textColor,
    Color? borderColor,
    TextStyle? textStyle,
    Size? size,
    Map<String, dynamic>? customData,
  }) {
    return MindMapData(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      children: children ?? this.children,
      color: color ?? this.color,
      textColor: textColor ?? this.textColor,
      borderColor: borderColor ?? this.borderColor,
      textStyle: textStyle ?? this.textStyle,
      size: size ?? this.size,
      customData: customData ?? this.customData,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MindMapData &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.children == children &&
        other.color == color &&
        other.textColor == textColor &&
        other.borderColor == borderColor &&
        other.textStyle == textStyle &&
        other.size == size &&
        other.customData == customData;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      children,
      color,
      textColor,
      borderColor,
      textStyle,
      size,
      customData,
    );
  }

  @override
  String toString() {
    return 'MindMapData(id: $id, title: $title, children: ${children.length})';
  }
}