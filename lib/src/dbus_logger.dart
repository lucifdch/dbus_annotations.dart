///
typedef PrintLog = void Function(String level, Object? message, [Object? error, StackTrace? stackTrace]);

///
class DBusLogger {
  ///
  final String tag;

  ///
  PrintLog? _print;

  ///
  DBusLogger(this.tag);

  set print(PrintLog? print) => _print = print;

  void _log(String level, Object? message, [Object? error, StackTrace? stackTrace]) {
    _print?.call(level, message, error, stackTrace);
  }

  void trace(Object? message, [Object? error, StackTrace? stackTrace]) => _log("trace", message, error, stackTrace);

  void debug(Object? message, [Object? error, StackTrace? stackTrace]) => _log("debug", message, error, stackTrace);

  void info(Object? message, [Object? error, StackTrace? stackTrace]) => _log("info", message, error, stackTrace);

  void warning(Object? message, [Object? error, StackTrace? stackTrace]) => _log("waring", message, error, stackTrace);

  void error(Object? message, [Object? error, StackTrace? stackTrace]) => _log("error", message, error, stackTrace);
}
