// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/deduce/int_float.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/deduce/int_float.carbon

// --- int.carbon

library "[[@TEST_NAME]]";

fn F[N:! Core.IntLiteral()](n: Core.Int(N)) -> Core.IntLiteral() {
  return N;
}

fn G(a: i64) -> Core.IntLiteral() {
  return F(a);
}

// --- fail_todo_float.carbon

library "[[@TEST_NAME]]";

// TODO: This should pass once we accept symbolic widths for Core.Float.
// CHECK:STDERR: fail_todo_float.carbon:[[@LINE+4]]:32: error: cannot evaluate type expression [TypeExprEvaluationFailure]
// CHECK:STDERR: fn F[N:! Core.IntLiteral()](n: Core.Float(N)) -> Core.IntLiteral() {
// CHECK:STDERR:                                ^~~~~~~~~~~~~
// CHECK:STDERR:
fn F[N:! Core.IntLiteral()](n: Core.Float(N)) -> Core.IntLiteral() {
  return N;
}

fn G(a: f64) -> Core.IntLiteral() {
  return F(a);
}

// CHECK:STDOUT: --- int.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %IntLiteral.type: type = fn_type @IntLiteral [template]
// CHECK:STDOUT:   %IntLiteral: %IntLiteral.type = struct_value () [template]
// CHECK:STDOUT:   %N: Core.IntLiteral = bind_symbolic_name N, 0 [symbolic]
// CHECK:STDOUT:   %N.patt: Core.IntLiteral = symbolic_binding_pattern N, 0 [symbolic]
// CHECK:STDOUT:   %Int.type: type = generic_class_type @Int [template]
// CHECK:STDOUT:   %Int.generic: %Int.type = struct_value () [template]
// CHECK:STDOUT:   %Int: type = class_type @Int, @Int(%N) [symbolic]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT:   %require_complete.b4f: <witness> = require_complete_type %Int [symbolic]
// CHECK:STDOUT:   %int_64: Core.IntLiteral = int_value 64 [template]
// CHECK:STDOUT:   %i64: type = class_type @Int, @Int(%int_64) [template]
// CHECK:STDOUT:   %G.type: type = fn_type @G [template]
// CHECK:STDOUT:   %G: %G.type = struct_value () [template]
// CHECK:STDOUT:   %i64.builtin: type = int_type signed, %int_64 [template]
// CHECK:STDOUT:   %complete_type.4a1: <witness> = complete_type_witness %i64.builtin [template]
// CHECK:STDOUT:   %F.specific_fn: <specific function> = specific_function %F, @F(%int_64) [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .IntLiteral = %Core.IntLiteral
// CHECK:STDOUT:     .Int = %Core.Int
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.IntLiteral: %IntLiteral.type = import_ref Core//prelude/types/int_literal, IntLiteral, loaded [template = constants.%IntLiteral]
// CHECK:STDOUT:   %Core.Int: %Int.type = import_ref Core//prelude/types/int, Int, loaded [template = constants.%Int.generic]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .F = %F.decl
// CHECK:STDOUT:     .G = %G.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %F.decl: %F.type = fn_decl @F [template = constants.%F] {
// CHECK:STDOUT:     %N.patt.loc4_6.1: Core.IntLiteral = symbolic_binding_pattern N, 0 [symbolic = %N.patt.loc4_6.2 (constants.%N.patt)]
// CHECK:STDOUT:     %N.param_patt: Core.IntLiteral = value_param_pattern %N.patt.loc4_6.1, runtime_param<none> [symbolic = %N.patt.loc4_6.2 (constants.%N.patt)]
// CHECK:STDOUT:     %n.patt: @F.%Int.loc4_42.2 (%Int) = binding_pattern n
// CHECK:STDOUT:     %n.param_patt: @F.%Int.loc4_42.2 (%Int) = value_param_pattern %n.patt, runtime_param0
// CHECK:STDOUT:     %return.patt: Core.IntLiteral = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: Core.IntLiteral = out_param_pattern %return.patt, runtime_param1
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %Core.ref.loc4_48: <namespace> = name_ref Core, imports.%Core [template = imports.%Core]
// CHECK:STDOUT:     %IntLiteral.ref.loc4_52: %IntLiteral.type = name_ref IntLiteral, imports.%Core.IntLiteral [template = constants.%IntLiteral]
// CHECK:STDOUT:     %int_literal.make_type.loc4_64: init type = call %IntLiteral.ref.loc4_52() [template = Core.IntLiteral]
// CHECK:STDOUT:     %.loc4_64.1: type = value_of_initializer %int_literal.make_type.loc4_64 [template = Core.IntLiteral]
// CHECK:STDOUT:     %.loc4_64.2: type = converted %int_literal.make_type.loc4_64, %.loc4_64.1 [template = Core.IntLiteral]
// CHECK:STDOUT:     %N.param: Core.IntLiteral = value_param runtime_param<none>
// CHECK:STDOUT:     %.loc4_26.1: type = splice_block %.loc4_26.3 [template = Core.IntLiteral] {
// CHECK:STDOUT:       %Core.ref.loc4_10: <namespace> = name_ref Core, imports.%Core [template = imports.%Core]
// CHECK:STDOUT:       %IntLiteral.ref.loc4_14: %IntLiteral.type = name_ref IntLiteral, imports.%Core.IntLiteral [template = constants.%IntLiteral]
// CHECK:STDOUT:       %int_literal.make_type.loc4_26: init type = call %IntLiteral.ref.loc4_14() [template = Core.IntLiteral]
// CHECK:STDOUT:       %.loc4_26.2: type = value_of_initializer %int_literal.make_type.loc4_26 [template = Core.IntLiteral]
// CHECK:STDOUT:       %.loc4_26.3: type = converted %int_literal.make_type.loc4_26, %.loc4_26.2 [template = Core.IntLiteral]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %N.loc4_6.1: Core.IntLiteral = bind_symbolic_name N, 0, %N.param [symbolic = %N.loc4_6.2 (constants.%N)]
// CHECK:STDOUT:     %n.param: @F.%Int.loc4_42.2 (%Int) = value_param runtime_param0
// CHECK:STDOUT:     %.loc4_42: type = splice_block %Int.loc4_42.1 [symbolic = %Int.loc4_42.2 (constants.%Int)] {
// CHECK:STDOUT:       %Core.ref.loc4_32: <namespace> = name_ref Core, imports.%Core [template = imports.%Core]
// CHECK:STDOUT:       %Int.ref: %Int.type = name_ref Int, imports.%Core.Int [template = constants.%Int.generic]
// CHECK:STDOUT:       %N.ref.loc4: Core.IntLiteral = name_ref N, %N.loc4_6.1 [symbolic = %N.loc4_6.2 (constants.%N)]
// CHECK:STDOUT:       %Int.loc4_42.1: type = class_type @Int, @Int(constants.%N) [symbolic = %Int.loc4_42.2 (constants.%Int)]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %n: @F.%Int.loc4_42.2 (%Int) = bind_name n, %n.param
// CHECK:STDOUT:     %return.param: ref Core.IntLiteral = out_param runtime_param1
// CHECK:STDOUT:     %return: ref Core.IntLiteral = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %G.decl: %G.type = fn_decl @G [template = constants.%G] {
// CHECK:STDOUT:     %a.patt: %i64 = binding_pattern a
// CHECK:STDOUT:     %a.param_patt: %i64 = value_param_pattern %a.patt, runtime_param0
// CHECK:STDOUT:     %return.patt: Core.IntLiteral = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: Core.IntLiteral = out_param_pattern %return.patt, runtime_param1
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %Core.ref: <namespace> = name_ref Core, imports.%Core [template = imports.%Core]
// CHECK:STDOUT:     %IntLiteral.ref: %IntLiteral.type = name_ref IntLiteral, imports.%Core.IntLiteral [template = constants.%IntLiteral]
// CHECK:STDOUT:     %int_literal.make_type: init type = call %IntLiteral.ref() [template = Core.IntLiteral]
// CHECK:STDOUT:     %.loc8_33.1: type = value_of_initializer %int_literal.make_type [template = Core.IntLiteral]
// CHECK:STDOUT:     %.loc8_33.2: type = converted %int_literal.make_type, %.loc8_33.1 [template = Core.IntLiteral]
// CHECK:STDOUT:     %a.param: %i64 = value_param runtime_param0
// CHECK:STDOUT:     %.loc8_9: type = splice_block %i64 [template = constants.%i64] {
// CHECK:STDOUT:       %int_64: Core.IntLiteral = int_value 64 [template = constants.%int_64]
// CHECK:STDOUT:       %i64: type = class_type @Int, @Int(constants.%int_64) [template = constants.%i64]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %a: %i64 = bind_name a, %a.param
// CHECK:STDOUT:     %return.param: ref Core.IntLiteral = out_param runtime_param1
// CHECK:STDOUT:     %return: ref Core.IntLiteral = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic fn @F(%N.loc4_6.1: Core.IntLiteral) {
// CHECK:STDOUT:   %N.loc4_6.2: Core.IntLiteral = bind_symbolic_name N, 0 [symbolic = %N.loc4_6.2 (constants.%N)]
// CHECK:STDOUT:   %N.patt.loc4_6.2: Core.IntLiteral = symbolic_binding_pattern N, 0 [symbolic = %N.patt.loc4_6.2 (constants.%N.patt)]
// CHECK:STDOUT:   %Int.loc4_42.2: type = class_type @Int, @Int(%N.loc4_6.2) [symbolic = %Int.loc4_42.2 (constants.%Int)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %require_complete: <witness> = require_complete_type @F.%Int.loc4_42.2 (%Int) [symbolic = %require_complete (constants.%require_complete.b4f)]
// CHECK:STDOUT:
// CHECK:STDOUT:   fn[%N.param_patt: Core.IntLiteral](%n.param_patt: @F.%Int.loc4_42.2 (%Int)) -> Core.IntLiteral {
// CHECK:STDOUT:   !entry:
// CHECK:STDOUT:     %N.ref.loc5: Core.IntLiteral = name_ref N, %N.loc4_6.1 [symbolic = %N.loc4_6.2 (constants.%N)]
// CHECK:STDOUT:     return %N.ref.loc5
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @G(%a.param_patt: %i64) -> Core.IntLiteral {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, file.%F.decl [template = constants.%F]
// CHECK:STDOUT:   %a.ref: %i64 = name_ref a, %a
// CHECK:STDOUT:   %F.specific_fn: <specific function> = specific_function %F.ref, @F(constants.%int_64) [template = constants.%F.specific_fn]
// CHECK:STDOUT:   %F.call: init Core.IntLiteral = call %F.specific_fn(%a.ref)
// CHECK:STDOUT:   %.loc9_14.1: Core.IntLiteral = value_of_initializer %F.call
// CHECK:STDOUT:   %.loc9_14.2: Core.IntLiteral = converted %F.call, %.loc9_14.1
// CHECK:STDOUT:   return %.loc9_14.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @F(constants.%N) {
// CHECK:STDOUT:   %N.loc4_6.2 => constants.%N
// CHECK:STDOUT:   %N.patt.loc4_6.2 => constants.%N
// CHECK:STDOUT:   %Int.loc4_42.2 => constants.%Int
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @F(constants.%int_64) {
// CHECK:STDOUT:   %N.loc4_6.2 => constants.%int_64
// CHECK:STDOUT:   %N.patt.loc4_6.2 => constants.%int_64
// CHECK:STDOUT:   %Int.loc4_42.2 => constants.%i64
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:   %require_complete => constants.%complete_type.4a1
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_todo_float.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %IntLiteral.type: type = fn_type @IntLiteral [template]
// CHECK:STDOUT:   %IntLiteral: %IntLiteral.type = struct_value () [template]
// CHECK:STDOUT:   %N: Core.IntLiteral = bind_symbolic_name N, 0 [symbolic]
// CHECK:STDOUT:   %N.patt: Core.IntLiteral = symbolic_binding_pattern N, 0 [symbolic]
// CHECK:STDOUT:   %Float.type: type = fn_type @Float [template]
// CHECK:STDOUT:   %Float: %Float.type = struct_value () [template]
// CHECK:STDOUT:   %F.type: type = fn_type @F [template]
// CHECK:STDOUT:   %F: %F.type = struct_value () [template]
// CHECK:STDOUT:   %int_64: Core.IntLiteral = int_value 64 [template]
// CHECK:STDOUT:   %G.type: type = fn_type @G [template]
// CHECK:STDOUT:   %G: %G.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .IntLiteral = %Core.IntLiteral
// CHECK:STDOUT:     .Float = %Core.Float
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.IntLiteral: %IntLiteral.type = import_ref Core//prelude/types/int_literal, IntLiteral, loaded [template = constants.%IntLiteral]
// CHECK:STDOUT:   %Core.Float: %Float.type = import_ref Core//prelude/types, Float, loaded [template = constants.%Float]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .F = %F.decl
// CHECK:STDOUT:     .G = %G.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %F.decl: %F.type = fn_decl @F [template = constants.%F] {
// CHECK:STDOUT:     %N.patt.loc9_6.1: Core.IntLiteral = symbolic_binding_pattern N, 0 [symbolic = %N.patt.loc9_6.2 (constants.%N.patt)]
// CHECK:STDOUT:     %N.param_patt: Core.IntLiteral = value_param_pattern %N.patt.loc9_6.1, runtime_param<none> [symbolic = %N.patt.loc9_6.2 (constants.%N.patt)]
// CHECK:STDOUT:     %n.patt: <error> = binding_pattern n
// CHECK:STDOUT:     %n.param_patt: <error> = value_param_pattern %n.patt, runtime_param0
// CHECK:STDOUT:     %return.patt: Core.IntLiteral = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: Core.IntLiteral = out_param_pattern %return.patt, runtime_param1
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %Core.ref.loc9_50: <namespace> = name_ref Core, imports.%Core [template = imports.%Core]
// CHECK:STDOUT:     %IntLiteral.ref.loc9_54: %IntLiteral.type = name_ref IntLiteral, imports.%Core.IntLiteral [template = constants.%IntLiteral]
// CHECK:STDOUT:     %int_literal.make_type.loc9_66: init type = call %IntLiteral.ref.loc9_54() [template = Core.IntLiteral]
// CHECK:STDOUT:     %.loc9_66.1: type = value_of_initializer %int_literal.make_type.loc9_66 [template = Core.IntLiteral]
// CHECK:STDOUT:     %.loc9_66.2: type = converted %int_literal.make_type.loc9_66, %.loc9_66.1 [template = Core.IntLiteral]
// CHECK:STDOUT:     %N.param: Core.IntLiteral = value_param runtime_param<none>
// CHECK:STDOUT:     %.loc9_26.1: type = splice_block %.loc9_26.3 [template = Core.IntLiteral] {
// CHECK:STDOUT:       %Core.ref.loc9_10: <namespace> = name_ref Core, imports.%Core [template = imports.%Core]
// CHECK:STDOUT:       %IntLiteral.ref.loc9_14: %IntLiteral.type = name_ref IntLiteral, imports.%Core.IntLiteral [template = constants.%IntLiteral]
// CHECK:STDOUT:       %int_literal.make_type.loc9_26: init type = call %IntLiteral.ref.loc9_14() [template = Core.IntLiteral]
// CHECK:STDOUT:       %.loc9_26.2: type = value_of_initializer %int_literal.make_type.loc9_26 [template = Core.IntLiteral]
// CHECK:STDOUT:       %.loc9_26.3: type = converted %int_literal.make_type.loc9_26, %.loc9_26.2 [template = Core.IntLiteral]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %N.loc9_6.1: Core.IntLiteral = bind_symbolic_name N, 0, %N.param [symbolic = %N.loc9_6.2 (constants.%N)]
// CHECK:STDOUT:     %n.param: <error> = value_param runtime_param0
// CHECK:STDOUT:     %.1: <error> = splice_block <error> [template = <error>] {
// CHECK:STDOUT:       %Core.ref.loc9_32: <namespace> = name_ref Core, imports.%Core [template = imports.%Core]
// CHECK:STDOUT:       %Float.ref: %Float.type = name_ref Float, imports.%Core.Float [template = constants.%Float]
// CHECK:STDOUT:       %N.ref.loc9: Core.IntLiteral = name_ref N, %N.loc9_6.1 [symbolic = %N.loc9_6.2 (constants.%N)]
// CHECK:STDOUT:       %float.make_type: init type = call %Float.ref(%N.ref.loc9)
// CHECK:STDOUT:       %.loc9_44.1: type = value_of_initializer %float.make_type
// CHECK:STDOUT:       %.loc9_44.2: type = converted %float.make_type, %.loc9_44.1
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %n: <error> = bind_name n, %n.param
// CHECK:STDOUT:     %return.param: ref Core.IntLiteral = out_param runtime_param1
// CHECK:STDOUT:     %return: ref Core.IntLiteral = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %G.decl: %G.type = fn_decl @G [template = constants.%G] {
// CHECK:STDOUT:     %a.patt: f64 = binding_pattern a
// CHECK:STDOUT:     %a.param_patt: f64 = value_param_pattern %a.patt, runtime_param0
// CHECK:STDOUT:     %return.patt: Core.IntLiteral = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: Core.IntLiteral = out_param_pattern %return.patt, runtime_param1
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %Core.ref: <namespace> = name_ref Core, imports.%Core [template = imports.%Core]
// CHECK:STDOUT:     %IntLiteral.ref: %IntLiteral.type = name_ref IntLiteral, imports.%Core.IntLiteral [template = constants.%IntLiteral]
// CHECK:STDOUT:     %int_literal.make_type: init type = call %IntLiteral.ref() [template = Core.IntLiteral]
// CHECK:STDOUT:     %.loc13_33.1: type = value_of_initializer %int_literal.make_type [template = Core.IntLiteral]
// CHECK:STDOUT:     %.loc13_33.2: type = converted %int_literal.make_type, %.loc13_33.1 [template = Core.IntLiteral]
// CHECK:STDOUT:     %a.param: f64 = value_param runtime_param0
// CHECK:STDOUT:     %.loc13_9.1: type = splice_block %.loc13_9.3 [template = f64] {
// CHECK:STDOUT:       %int_64: Core.IntLiteral = int_value 64 [template = constants.%int_64]
// CHECK:STDOUT:       %float.make_type: init type = call constants.%Float(%int_64) [template = f64]
// CHECK:STDOUT:       %.loc13_9.2: type = value_of_initializer %float.make_type [template = f64]
// CHECK:STDOUT:       %.loc13_9.3: type = converted %float.make_type, %.loc13_9.2 [template = f64]
// CHECK:STDOUT:     }
// CHECK:STDOUT:     %a: f64 = bind_name a, %a.param
// CHECK:STDOUT:     %return.param: ref Core.IntLiteral = out_param runtime_param1
// CHECK:STDOUT:     %return: ref Core.IntLiteral = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: generic fn @F(%N.loc9_6.1: Core.IntLiteral) {
// CHECK:STDOUT:   %N.loc9_6.2: Core.IntLiteral = bind_symbolic_name N, 0 [symbolic = %N.loc9_6.2 (constants.%N)]
// CHECK:STDOUT:   %N.patt.loc9_6.2: Core.IntLiteral = symbolic_binding_pattern N, 0 [symbolic = %N.patt.loc9_6.2 (constants.%N.patt)]
// CHECK:STDOUT:
// CHECK:STDOUT: !definition:
// CHECK:STDOUT:
// CHECK:STDOUT:   fn[%N.param_patt: Core.IntLiteral](%n.param_patt: <error>) -> Core.IntLiteral {
// CHECK:STDOUT:   !entry:
// CHECK:STDOUT:     %N.ref.loc10: Core.IntLiteral = name_ref N, %N.loc9_6.1 [symbolic = %N.loc9_6.2 (constants.%N)]
// CHECK:STDOUT:     return %N.ref.loc10
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @G(%a.param_patt: f64) -> Core.IntLiteral {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %F.ref: %F.type = name_ref F, file.%F.decl [template = constants.%F]
// CHECK:STDOUT:   %a.ref: f64 = name_ref a, %a
// CHECK:STDOUT:   return <error>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @F(constants.%N) {
// CHECK:STDOUT:   %N.loc9_6.2 => constants.%N
// CHECK:STDOUT:   %N.patt.loc9_6.2 => constants.%N
// CHECK:STDOUT: }
// CHECK:STDOUT:
