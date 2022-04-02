library copy_with_generator.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'copy_with_generator.dart';

Builder copyWith(BuilderOptions _) =>
    SharedPartBuilder([CopyWithGenerator()], 'copyWith');
