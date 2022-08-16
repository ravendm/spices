import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spice_widgets/spice_widgets_method_channel.dart';

void main() {
  MethodChannelSpiceWidgets platform = MethodChannelSpiceWidgets();
  const MethodChannel channel = MethodChannel('spice_widgets');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
