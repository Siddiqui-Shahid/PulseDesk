/// Data model for error banner component
class ErrorBannerDataModel {
  final String? errorMessage;
  final bool isVisible;

  const ErrorBannerDataModel({this.errorMessage, required this.isVisible});

  ErrorBannerDataModel copyWith({String? errorMessage, bool? isVisible}) {
    return ErrorBannerDataModel(
      errorMessage: errorMessage ?? this.errorMessage,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorBannerDataModel &&
          runtimeType == other.runtimeType &&
          errorMessage == other.errorMessage &&
          isVisible == other.isVisible;

  @override
  int get hashCode => errorMessage.hashCode ^ isVisible.hashCode;
}
