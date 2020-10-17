#!/bin/sh -x

rm -rf coverage
package=grocery_brasil_app
file=test/coverage_test.dart

find lib -name \*.dart -and -not -name \*.g.dart -and -not -name \*_state.dart -and -not -name \*_event.dart| cut -c4- | awk -v package=$package '{printf "import '\''package:%s%s'\'';\n", package, $1}' > $file

cat << eom >> $file
import 'package:flutter_test/flutter_test.dart';
void main () {test('', () {});}
eom

flutter test --coverage
genhtml --o coverage/genhtml coverage/lcov.info
chromium coverage/genhtml/index.html






