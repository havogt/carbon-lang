// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

// CHECK:STDERR: COMPILATION ERROR: fail_parameter_type_only.carbon:[[@LINE+1]]: An irrefutable pattern is required, but `i32` is refutable.
fn f(x: i32, i32) {}

fn Main() -> i32 {
  return 0;
}
