/// Represents the arguments passed during navigation
///
/// This class demonstrates how to structure navigation data.
/// In a real app, you might have different data models for different routes.
class RouteArguments {
  final String? id;
  final String? title;
  final dynamic data;

  const RouteArguments({this.id, this.title, this.data});

  @override
  String toString() => 'RouteArguments(id: $id, title: $title, data: $data)';
}

/// Represents the result of a route operation
///
/// Tracks whether the navigation was successful and provides error info
class RouteResult {
  final bool success;
  final String? errorMessage;
  final dynamic result;

  const RouteResult({required this.success, this.errorMessage, this.result});

  @override
  String toString() =>
      'RouteResult(success: $success, error: $errorMessage, result: $result)';
}
