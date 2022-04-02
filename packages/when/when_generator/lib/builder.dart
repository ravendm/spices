library when_generator.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'when_generator.dart';

Builder when(BuilderOptions _) =>
    SharedPartBuilder([WhenGenerator()], 'when');
