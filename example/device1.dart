import 'dart:async';

import 'package:dbus/dbus.dart';
import 'package:dbus_annotations/dbus_annotations.dart';

/// Document: bluez_src/doc/org.bluez.Device.rst
/// <p>
/// :Service:	org.bluez
/// :Interface:	org.bluez.Device1
/// :Object path:	[variable prefix]/{hci0,hci1,...}/dev_{BDADDR}
/// <p>
/// 代表远程蓝牙设备，用于管理设备的连接、配对和配置。
/// 此接口提供了控制蓝牙设备的方法，包括连接/断开设备、连接/断开特定配置文件、
/// 配对/取消配对设备，以及获取设备的服务记录等。
/// </p>
@DBusDocInterface("org.bluez.Device1", useLog: true, buildList: [DBusDocBuild.client])
abstract class Device1 {
  // =========================
  // 方法 (Methods)
  // =========================

  /// D-Bus Sign: Connect() -> ()
  /// <p>
  /// 连接远程设备支持的所有可自动连接的配置文件。如果只有部分配置文件已连接，
  /// 它将尝试连接当前断开的配置文件。
  /// <p>
  /// 如果至少一个配置文件连接成功，此方法将指示成功。
  /// <p>
  /// 对于双模设备，一次只连接一个承载，条件按以下顺序：
  /// <ol>
  ///   <li>如果已连接，则连接断开的承载。</li>
  ///   <li>首先连接绑定的承载。如果没有承载绑定或两者都绑定，则跳过并检查最新看到的承载。</li>
  ///   <li>连接最后使用的承载，如果时间戳相同，BR/EDR优先，或者如果**PreferredBearer**
  ///   已设置为特定承载，则使用该承载。</li>
  /// </ol>
  ///
  /// @throws org.bluez.Error.NotReady                 如果设备未准备好
  /// @throws org.bluez.Error.Failed                   如果连接失败
  /// @throws org.bluez.Error.InProgress               如果连接正在进行中
  /// @throws org.bluez.Error.AlreadyConnected         如果设备已经连接
  /// @throws org.bluez.Error.BREDR.ProfileUnavailable 如果BR/EDR配置文件不可用
  @DBusDocMethod("Connect")
  Future<void> connect();

  /// D-Bus Sign: Disconnect() -> ()
  /// <p>
  /// 断开所有连接的配置文件，然后终止低级ACL连接。
  /// <p>
  /// 即使某些配置文件未正确断开连接（例如由于设备行为异常），ACL连接也会终止。
  /// <p>
  /// 此方法还可用于在收到回复之前取消前面的Connect调用。
  /// <p>
  /// 对于通过LE承载连接的非受信任设备，调用此方法将禁用传入连接，直到再次调用Connect方法。
  ///
  /// @throws org.bluez.Error.NotConnected 如果设备未连接
  @DBusDocMethod("Disconnect")
  Future<void> disconnect();

  /// D-Bus Sign: ConnectProfile(s) -> ()
  /// <p>
  /// 连接此设备的特定配置文件。提供的UUID是配置文件的远程服务UUID。
  ///
  /// @param uuid 远程服务UUID
  /// @throws org.bluez.Error.Failed           如果连接失败
  /// @throws org.bluez.Error.InProgress       如果连接正在进行中
  /// @throws org.bluez.Error.InvalidArguments 如果参数无效
  /// @throws org.bluez.Error.NotAvailable     如果配置文件不可用
  /// @throws org.bluez.Error.NotReady         如果设备未准备好
  @DBusDocMethod("ConnectProfile", argList: ["s"])
  Future<void> connectProfile(String uuid);

  /// D-Bus Sign: DisconnectProfile(s) -> ()
  /// <p>
  /// 断开此设备的特定配置文件。该配置文件需要是已注册的客户端配置文件。
  /// <p>
  /// 没有配置文件的连接跟踪，因此只要配置文件已注册，这将始终成功。
  ///
  /// @param uuid 远程服务UUID
  /// @throws org.bluez.Error.Failed           如果断开连接失败
  /// @throws org.bluez.Error.InProgress       如果断开连接正在进行中
  /// @throws org.bluez.Error.InvalidArguments 如果参数无效
  /// @throws org.bluez.Error.NotSupported     如果不支持该配置文件
  @DBusDocMethod("DisconnectProfile", argList: ["s"])
  Future<void> disconnectProfile(String uuid);

  /// D-Bus Sign: Pair() -> ()
  /// <p>
  /// 连接到远程设备并启动配对过程，然后进行服务发现。
  /// <p>
  /// 如果应用程序已注册自己的代理，则将使用该特定代理。否则，它将使用默认代理。
  /// <p>
  /// 只有像配对向导这样的应用程序才有意义拥有自己的代理。在几乎所有其他情况下，默认代理将处理得很好。
  /// <p>
  /// 如果没有应用程序代理并且也没有默认代理存在，此方法将失败。
  ///
  /// @throws org.bluez.Error.InvalidArguments        如果参数无效
  /// @throws org.bluez.Error.Failed                  如果配对失败
  /// @throws org.bluez.Error.AlreadyExists           如果设备已经存在
  /// @throws org.bluez.Error.AuthenticationCanceled  如果认证被取消
  /// @throws org.bluez.Error.AuthenticationFailed    如果认证失败
  /// @throws org.bluez.Error.AuthenticationRejected  如果认证被拒绝
  /// @throws org.bluez.Error.AuthenticationTimeout   如果认证超时
  /// @throws org.bluez.Error.ConnectionAttemptFailed 如果连接尝试失败
  @DBusDocMethod("Pair")
  Future<void> pair();

  /// D-Bus Sign: CancelPairing() -> ()
  /// <p>
  /// 取消由Pair方法启动的配对操作。
  ///
  /// @throws org.bluez.Error.DoesNotExist 如果设备不存在
  /// @throws org.bluez.Error.Failed       如果取消配对失败
  @DBusDocMethod("CancelPairing")
  Future<void> cancelPairing();

  /// D-Bus Sign: GetServiceRecords() -> (aay)
  /// <p>
  /// 返回设备当前已知的所有BR/EDR服务记录。每个单独的字节数组代表一个原始SDP记录，
  /// 如蓝牙服务发现协议规范所定义。
  /// <p>
  /// 此方法仅用于需要提供对原始SDP记录的访问以支持外部蓝牙API的兼容性层（如Wine）。
  /// <p>
  /// 一般应用程序应使用Profile API进行与服务相关的功能。
  ///
  /// @return 其中每个字节数组都是一个原始 SDP 记录
  /// @throws org.bluez.Error.Failed       如果获取服务记录失败
  /// @throws org.bluez.Error.NotReady     如果设备未准备好
  /// @throws org.bluez.Error.NotConnected 如果设备未连接
  /// @throws org.bluez.Error.DoesNotExist 如果设备不存在
  /// @BluezExperimental
  @DBusDocMethod("GetServiceRecords", resultList: ["aay"])
  Future<List<List<int>>> getServiceRecords();

  // =========================
  // 信号 (Signals)
  // =========================

  /// D-Bus Sign: Disconnected(s, s) -> ()
  /// <p>
  /// 当设备断开连接时会触发此信号，并携带断开连接的原因。
  /// <p>
  /// 客户端应用程序可以根据自身的内部策略使用该信号，例如：
  /// 在发生超时或未知原因断开时尝试重新连接设备，
  /// 或者尝试连接到另一台设备。
  /// <p>
  /// 可能的断开原因包括：
  ///
  /// :org.bluez.Reason.Unknown:
  ///
  ///     未知原因。
  ///
  /// :org.bluez.Reason.Timeout:
  ///
  ///     连接超时。
  ///
  ///     连接的链路监督超时已到期，或者
  ///     广播同步的同步超时已到期。
  ///
  /// :org.bluez.Reason.Local:
  ///
  ///     由本地主机终止连接。
  ///
  ///     本地设备主动终止了连接，
  ///     终止了与广播源的同步，
  ///     或停止发送广播数据包。
  ///
  /// :org.bluez.Reason.Remote:
  ///
  ///     由远端主机终止连接。
  ///
  ///     该断开连接可能由于以下原因之一：
  ///
  ///     - 远端设备上的用户主动终止了连接，或
  ///       停止了广播数据包；
  ///
  ///     - 远端设备由于资源不足而终止连接；
  ///
  ///     - 远端设备因为即将关机而终止连接。
  ///
  /// :org.bluez.Reason.Authentication:
  ///
  ///     由于认证失败导致连接被终止。
  ///
  /// :org.bluez.Reason.Suspend:
  ///
  ///     本地主机因进入挂起（Suspend）状态而终止连接。
  @DBusDocSignal("Disconnected", argList: ["s", "s"])
  Future<void> disconnected(String reason, String message);

  // =========================
  // 属性 (Properties)
  // =========================

  /// D-Bus Sign: Address -> s
  /// <p>
  /// 获取远程设备的蓝牙设备地址。
  ///
  /// @return 蓝牙地址字符串
  @DBusDocProperty_Get("Address", "s")
  Future<String> getAddress();

  /// D-Bus Sign: AddressType -> s
  /// <p>
  /// 获取蓝牙设备地址类型。对于双模和仅BR/EDR设备，默认值为"public"。
  /// 单模LE设备可能有任一值。
  /// <p>
  /// 如果远程设备使用隐私，那么在配对前这表示用于连接的地址类型，配对后表示身份地址。
  /// <p>
  /// 可能的值：
  /// <ul>
  ///   <li>"public": 公共地址</li>
  ///   <li>"random": 随机地址</li>
  /// </ul>
  ///
  /// @return 地址类型字符串
  @DBusDocProperty_Get("AddressType", "s")
  Future<String> getAddressType();

  /// D-Bus Sign: Name -> s
  /// <p>
  /// 获取蓝牙远程名称。
  /// <p>
  /// 此值仅为完整性而存在。在显示设备名称时，最好始终使用Alias属性。
  /// <p>
  /// 如果Alias属性未设置，它将反映此值，这使其更方便。
  ///
  /// @return 设备名称字符串
  /// @BluezOptional
  @DBusDocProperty_Get("Name", "s")
  Future<String> getName();

  /// D-Bus Sign: Icon -> s
  /// <p>
  /// 根据freedesktop.org图标命名规范的建议图标名称。
  ///
  /// @return 图标名称字符串
  /// @BluezOptional
  @DBusDocProperty_Get("Icon", "s")
  Future<String> getIcon();

  /// D-Bus Sign: Class -> u
  /// <p>
  /// 获取远程设备的蓝牙设备类别。
  ///
  /// @return 设备类别值
  /// @BluezOptional
  @DBusDocProperty_Get("Class", "u")
  Future<int> getClass();

  /// D-Bus Sign: Appearance -> q
  /// <p>
  /// 设备的外观，如GAP服务中所示。
  ///
  /// @return 设备外观值
  /// @BluezOptional
  @DBusDocProperty_Get("Appearance", "q")
  Future<int> getAppearance();

  /// D-Bus Sign: UUIDs -> as
  /// <p>
  /// 获取表示可用远程服务的128位UUID列表。
  ///
  /// @return UUID字符串列表
  /// @BluezOptional
  @DBusDocProperty_Get("UUIDs", "as")
  Future<List<String>> getUUIDs();

  /// D-Bus Sign: Paired -> b
  /// <p>
  /// 指示远程设备是否已配对。配对意味着设备交换信息以建立加密连接的过程已完成。
  ///
  /// @return 如果设备已配对则返回true
  @DBusDocProperty_Get("Paired", "b")
  Future<bool> getPaired();

  /// D-Bus Sign: Bonded -> b
  /// <p>
  /// 指示远程设备是否已绑定。绑定意味着配对过程中交换的信息已存储并将被持久化。
  ///
  /// @return 如果设备已绑定则返回true
  @DBusDocProperty_Get("Bonded", "b")
  Future<bool> getBonded();

  /// D-Bus Sign: Connected -> b
  /// <p>
  /// 指示远程设备当前是否已连接。
  /// <p>
  /// PropertiesChanged信号指示此状态的变化。
  ///
  /// @return 如果设备已连接则返回true
  @DBusDocProperty_Get("Connected", "b")
  Future<bool> getConnected();

  /// D-Bus Sign: Trusted -> b
  /// <p>
  /// 指示远程设备是否被视为受信任。
  /// <p>
  /// 应用程序可以更改此设置。
  ///
  /// @return 如果设备受信任则返回true
  @DBusDocProperty_Get("Trusted", "b")
  Future<bool> getTrusted();

  /// D-Bus Sign: Trusted = b
  /// <p>
  /// 设置远程设备是否被视为受信任。
  ///
  /// @param trusted 设置为true表示受信任
  @DBusDocProperty_Set("Trusted", "b")
  Future<void> setTrusted(bool trusted);

  /// D-Bus Sign: Blocked -> b
  /// <p>
  /// 如果设置为true，来自设备的任何传入连接将立即被拒绝。
  /// <p>
  /// 只要设备被阻止，任何设备驱动程序也将被移除，并且不会探测新的驱动程序。
  ///
  /// @return 如果设备被阻止则返回true
  @DBusDocProperty_Get("Blocked", "b")
  Future<bool> getBlocked();

  /// D-Bus Sign: Blocked = b
  /// <p>
  /// 设置是否阻止设备的任何传入连接。
  ///
  /// @param blocked 设置为true表示阻止设备
  @DBusDocProperty_Set("Blocked", "b")
  Future<void> setBlocked(bool blocked);

  /// D-Bus Sign: WakeAllowed -> b
  /// <p>
  /// 如果设置为true，此设备将被允许从系统挂起中唤醒主机。
  ///
  /// @return 如果允许设备唤醒主机则返回true
  @DBusDocProperty_Get("WakeAllowed", "b")
  Future<bool> getWakeAllowed();

  /// D-Bus Sign: WakeAllowed = b
  /// <p>
  /// 设置此设备是否被允许从系统挂起中唤醒主机。
  ///
  /// @param wakeAllowed 设置为true表示允许设备唤醒主机
  @DBusDocProperty_Set("WakeAllowed", "b")
  Future<void> setWakeAllowed(bool wakeAllowed);

  /// D-Bus Sign: Alias -> s
  /// <p>
  /// 远程设备的名称别名。别名可用于为远程设备提供不同的友好名称。
  /// <p>
  /// 如果未设置别名，它将返回远程设备名称。将空字符串设置为别名将使其转换回远程设备名称。
  /// <p>
  /// 当使用空字符串重置别名时，该属性将默认为远程名称。
  ///
  /// @return 别名字符串
  @DBusDocProperty_Get("Alias", "s")
  Future<String> getAlias();

  /// D-Bus Sign: Alias = s
  /// <p>
  /// 设置远程设备的名称别名。
  ///
  /// @param alias 别名字符串
  @DBusDocProperty_Set("Alias", "s")
  Future<void> setAlias(String alias);

  /// D-Bus Sign: Adapter -> o
  /// <p>
  /// 获取设备所属的适配器的对象路径。
  ///
  /// @return 适配器对象路径
  @DBusDocProperty_Get("Adapter", "o")
  Future<DBusObjectPath> getAdapter();

  /// D-Bus Sign: LegacyPairing -> b
  /// <p>
  /// 如果设备仅支持2.1之前的配对机制，则设置为true。
  /// <p>
  /// 此属性在设备发现期间很有用，可以预测如果启动配对，是否会发生传统配对或简单配对。
  /// <p>
  /// 请注意，在禁用扩展查询响应支持的蓝牙2.1（或更新版本）设备的情况下，此属性可能会显示误报。
  ///
  /// @return 如果设备仅支持传统配对则返回true
  @DBusDocProperty_Get("LegacyPairing", "b")
  Future<bool> getLegacyPairing();

  /// D-Bus Sign: CablePairing -> b
  /// <p>
  /// 如果设备是通过电缆配对的，并且不支持带加密的规范绑定，则设置为true，例如Sixaxis游戏手柄。
  /// <p>
  /// 如果为true，BlueZ将建立连接而不强制加密。
  ///
  /// @return 如果设备是通过电缆配对的则返回true
  @DBusDocProperty_Get("CablePairing", "b")
  Future<bool> getCablePairing();

  /// D-Bus Sign: Modalias -> s
  /// <p>
  /// 内核和udev使用的modalias格式的远程设备ID信息。
  ///
  /// @return modalias字符串
  /// @BluezOptional
  @DBusDocProperty_Get("Modalias", "s")
  Future<String> getModalias();

  /// D-Bus Sign: RSSI -> n
  /// <p>
  /// 远程设备的接收信号强度指示器（查询或广播）。
  ///
  /// @return RSSI值
  /// @BluezOptional
  @DBusDocProperty_Get("RSSI", "n")
  Future<int> getRSSI();

  /// D-Bus Sign: TxPower -> n
  /// <p>
  /// 广播的发射功率水平（查询或广播）。
  ///
  /// @return 发射功率值
  /// @BluezOptional
  @DBusDocProperty_Get("TxPower", "n")
  Future<int> getTxPower();

  /// D-Bus Sign: ManufacturerData -> a{qv}
  /// <p>
  /// 制造商特定的广播数据。键是16位制造商ID，后跟其字节数组值。
  ///
  /// @return 制造商数据映射
  /// @BluezOptional
  @DBusDocProperty_Get("ManufacturerData", "a{qv}")
  Future<Map<int, DBusValue>> getManufacturerData();

  /// D-Bus Sign: ServiceData -> a{sv}
  /// <p>
  /// 服务广播数据。键是字符串格式的UUID，后跟其字节数组值。
  ///
  /// @return 服务数据映射
  /// @BluezOptional
  @DBusDocProperty_Get("ServiceData", "a{sv}")
  Future<Map<String, DBusValue>> getServiceData();

  /// D-Bus Sign: ServicesResolved -> b
  /// <p>
  /// 指示服务发现是否已解析。
  ///
  /// @return 如果服务发现已解析则返回true
  @DBusDocProperty_Get("ServicesResolved", "b")
  Future<bool> getServicesResolved();

  /// D-Bus Sign: AdvertisingFlags -> ay
  /// <p>
  /// 远程设备的广播数据（Advertising Data）标志位。
  /// </ul>
  ///
  /// @return 广播数据（Advertising Data）标志位
  @DBusDocProperty_Get("AdvertisingFlags", "ay")
  Future<List<int>> getAdvertisingFlags();

  /// D-Bus Sign: AdvertisingData -> a{yv}
  /// <p>
  /// 远程设备的广播数据。键是1字节的AD类型，后跟数据作为字节数组。
  /// <p>
  /// 注意：仅公开被认为可以安全地由应用程序处理的类型。
  ///
  /// @return 映射：键为 AD Type (Byte)，值为对应的 AD 数据 (List<int>)。
  @DBusDocProperty_Get("AdvertisingData", "a{yv}")
  Future<Map<int, DBusValue>> getAdvertisingData();

  /// D-Bus Sign: Sets -> a{oa{sv}}
  /// <p>
  /// 远程设备所属的 Set 列表。
  /// 每个元素包含一个 Set 的对象路径及其属性字典。
  /// <ul>
  ///   <li> Rank (byte)：设备在该 Set 中的排序等级。</li>
  /// </ul>
  ///
  /// @return 设备所属的集合列表
  /// @BluezExperimental
  @DBusDocProperty_Get("Sets", "a{oa{sv}}")
  Future<Map<DBusObjectPath, Map<String, DBusValue>>> getSets();

  /// D-Bus Sign: PreferredBearer -> s
  /// <p>
  /// 指示启动连接时的首选承载，仅适用于双模设备。
  /// <p>
  /// 当从"bredr"更改为"le"时，设备将从"自动连接"列表中移除，因此在广播时不会自动连接。
  /// <p>
  /// 注意：只有当设备断开连接时，更改才会生效。
  /// <p>
  /// 可能的值：
  /// <ul>
  ///   <li>"last-used": 首先连接到最后使用的承载。默认值。</li>
  ///   <li>"bredr": 首先连接到BR/EDR。</li>
  ///   <li>"le": 首先连接到LE。</li>
  ///   <li>"last-seen": 首先连接到最后看到的承载。</li>
  /// </ul>
  ///
  /// @return 首选承载
  /// @BluezOptional
  /// @BluezExperimental
  @DBusDocProperty_Get("PreferredBearer", "s")
  Future<String> getPreferredBearer();

  /// D-Bus Sign: PreferredBearer = s
  /// <p>
  /// 设置启动连接时的首选承载，仅适用于双模设备。
  ///
  /// @param preferredBearer 首选承载
  /// @BluezOptional
  /// @BluezExperimental
  @DBusDocProperty_Set("PreferredBearer", "s")
  Future<void> setPreferredBearer(String preferredBearer);
}
