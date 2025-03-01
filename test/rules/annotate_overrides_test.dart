// Copyright (c) 2022, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test_reflective_loader/test_reflective_loader.dart';

import '../rule_test_support.dart';

main() {
  defineReflectiveSuite(() {
    defineReflectiveTests(AnnotateOverridesTest);
  });
}

@reflectiveTest
class AnnotateOverridesTest extends LintRuleTest {
  @override
  String get lintRule => 'annotate_overrides';

  test_field() async {
    await assertDiagnostics(r'''
class O {
  int get x => 0;
}
    
enum A implements O {
  a,b,c;
  int get x => 0;
}
''', [
      lint(76, 1),
    ]);
  }

  test_method() async {
    await assertDiagnostics(r'''
enum A {
  a,b,c;
  String toString() => '';
}
''', [
      lint(27, 8),
    ]);
  }

  test_ok() async {
    await assertNoDiagnostics(r'''
class O {
  int get x => 0;
}
    
enum A implements O {    
  a,b,c;
  @override
  int get x => 0;
  @override
  String toString() => '';
}
''');
  }
}
