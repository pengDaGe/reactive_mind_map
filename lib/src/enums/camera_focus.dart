/// 마인드맵 카메라 포커스 옵션 / Mind map camera focus options
enum CameraFocus {
  /// 루트 노드 중심 / Focus on root node
  rootNode,

  /// 캔버스 정중앙 / Focus on canvas center
  center,

  /// 모든 노드가 보이도록 자동 조정 / Auto-fit all nodes
  fitAll,

  /// 첫 번째 리프 노드 / Focus on first leaf node
  firstLeaf,

  /// 커스텀 위치 (focusNodeId와 함께 사용) / Custom position (use with focusNodeId)
  custom,
}
