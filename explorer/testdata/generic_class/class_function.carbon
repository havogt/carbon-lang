// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// NOAUTOUPDATE

package ExplorerTest api;

interface Number {
  fn Zero() -> Self;
  fn Add[self: Self](other: Self) -> Self;
}

class Point(T:! Number) {
  fn Origin() -> Point(T) {
    return {.x = T.Zero(), .y = T.Zero()};
  }
  fn SumXY(p: Point(T)) -> T {
    return p.x.Add(p.y);
  }
  fn SumFn() -> (__Fn(Point(T)) -> T) {
    return Point(T).SumXY;
  }
  var x: T;
  var y: T;
}

impl i32 as Number {
  fn Zero() -> i32 { return 0; }
  fn Add[self: i32](other: i32) -> i32 { return self + other; }
}

fn Main() -> i32 {
  var p: Point(i32) = Point(i32).Origin();
  return p.SumFn()(p);
}

// CHECK:STDOUT: result: 0
