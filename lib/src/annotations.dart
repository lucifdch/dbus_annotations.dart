///
enum DBusDocBuild { service, client }

///
class DBusDocInterface {
  ///
  final String interfaceName;

  ///
  final bool useLog;

  /// 是否开启local_X响应式获取
  /// 如果使用则需要flutter项目
  final bool useValueNotifier;

  ///
  final List<DBusDocBuild> buildList;

  const DBusDocInterface(this.interfaceName, {this.useLog = true, this.useValueNotifier = false, this.buildList = const [DBusDocBuild.client, DBusDocBuild.service]});
}

///
class DBusDocMethod {
  ///
  final String methodName;

  ///
  final List<String> argList;

  ///
  final List<String> resultList;

  const DBusDocMethod(this.methodName, {this.argList = const [], this.resultList = const []});
}

///
class DBusDocSignal {
  ///
  final String signalName;

  ///
  final List<String> argList;

  const DBusDocSignal(this.signalName, {this.argList = const []});
}

///
class DBusDocProperty_Get {
  ///
  final String propertyName;

  ///
  final String signature;

  const DBusDocProperty_Get(this.propertyName, this.signature);
}

///
class DBusDocProperty_Set {
  ///
  final String propertyName;

  ///
  final String signature;

  const DBusDocProperty_Set(this.propertyName, this.signature);
}
