// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

base class C {
}

class D {
}

fn Main() -> i32 {
  var d: D = {};
  // CHECK:STDERR: COMPILATION ERROR: fail_invalid_subtyping.carbon:[[@LINE+1]]: type error in initializer of variable: 'class D*' is not implicitly convertible to 'class C*'
  var c: C* = &d;
  return 0;
}
