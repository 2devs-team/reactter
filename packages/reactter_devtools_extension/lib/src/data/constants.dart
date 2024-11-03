enum NodeType {
  dependency('dependency'),
  state('state'),
  instance('instance');

  final String value;

  const NodeType(this.value);

  factory NodeType.fromString(String value) {
    return NodeType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => NodeType.instance,
    );
  }
}
