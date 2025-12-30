import 'package:dbus/dbus.dart';

///
abstract class DBusClientHelper {
  ///
  final String interfaceName;

  ///
  final DBusRemoteObject remoteObject;

  ///
  DBusClientHelper(this.remoteObject, {required this.interfaceName});

  ///
  Future<DBusMethodSuccessResponse> callMethod(String name, Iterable<DBusValue> values, {DBusSignature? replySignature, bool noReplyExpected = false, bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    return await remoteObject.callMethod(interfaceName, name, values, replySignature: replySignature);
  }

  ///
  DBusSignalStream buildSignal(String name, {DBusSignature? signature}) {
    return DBusRemoteObjectSignalStream(object: remoteObject, interface: interfaceName, name: 'Disconnected', signature: signature);
  }

  ///
  Future<void> setProperty(String name, DBusValue value) async {
    await remoteObject.setProperty(interfaceName, name, value);
  }

  ///
  Future<DBusValue> getProperty(String name, {DBusSignature? signature}) async {
    return await remoteObject.getProperty(interfaceName, name, signature: signature);
  }

  ///
  Future<Map<String, DBusValue>> getAllProperty() async {
    return await remoteObject.getAllProperties(interfaceName);
  }

  ///
  Future<void> fillAllProperties() async {
    final allProperties = await getAllProperty();

    for (final kv in allProperties.entries) {
      setValue(kv.key, kv.value);
    }
  }

  ///
  Future<void> onPropertiesChangedSingle(DBusPropertiesChangedSignal signal) async {
    if (signal.propertiesInterface != interfaceName) {
      return;
    }

    for (final kv in signal.changedProperties.entries) {
      setValue(kv.key, kv.value);
    }

    for (final key in signal.invalidatedProperties) {
      final value = await remoteObject.getProperty(interfaceName, key);
      setValue(key, value);
    }
  }

  ///
  void setValue(String key, DBusValue value) {
    throw UnsupportedError("can't find key: $key -> ${value.toString()}");
  }
}
