// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

fn F() -> () {
  // CHECK:STDERR: COMPILATION ERROR: fail_explicit_with_plain_return.carbon:[[@LINE+1]]: return; should provide a return value, to match the function's signature.
  return;
}

fn Main() -> i32 {
  F();
  return 0;
}
