import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:spice_widgets/spice_widgets.dart';
import 'package:spice_widgets/spice_widgets_method_channel.dart';
import 'package:spice_widgets/spice_widgets_platform_interface.dart';

class MockSpiceWidgetsPlatform with MockPlatformInterfaceMixin implements SpiceWidgetsPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SpiceWidgetsPlatform initialPlatform = SpiceWidgetsPlatform.instance;

  test('$MethodChannelSpiceWidgets is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSpiceWidgets>());
  });

  test('getPlatformVersion', () async {
    SpiceWidgets spiceWidgetsPlugin = SpiceWidgets();
    MockSpiceWidgetsPlatform fakePlatform = MockSpiceWidgetsPlatform();
    SpiceWidgetsPlatform.instance = fakePlatform;

    expect(await spiceWidgetsPlugin.getPlatformVersion(), '42');
  });
}
