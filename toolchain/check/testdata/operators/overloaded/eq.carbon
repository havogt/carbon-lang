// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/operators/overloaded/eq.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/operators/overloaded/eq.carbon

// --- user.carbon

package User;

class C {};

impl C as Core.Eq {
  fn Equal[self: C](other: C) -> bool;
  fn NotEqual[self: C](other: C) -> bool;
}

fn TestEqual(a: C, b: C) -> bool {
  return a == b;
}

fn TestNotEqual(a: C, b: C) -> bool {
  return a != b;
}

// --- fail_no_impl.carbon

package FailNoImpl;

class D {};

fn TestEqual(a: D, b: D) -> bool {
  // CHECK:STDERR: fail_no_impl.carbon:[[@LINE+4]]:10: error: cannot access member of interface `Core.Eq` in type `D` that does not implement that interface [MissingImplInMemberAccess]
  // CHECK:STDERR:   return a == b;
  // CHECK:STDERR:          ^~~~~~
  // CHECK:STDERR:
  return a == b;
}

fn TestNotEqual(a: D, b: D) -> bool {
  // CHECK:STDERR: fail_no_impl.carbon:[[@LINE+4]]:10: error: cannot access member of interface `Core.Eq` in type `D` that does not implement that interface [MissingImplInMemberAccess]
  // CHECK:STDERR:   return a != b;
  // CHECK:STDERR:          ^~~~~~
  // CHECK:STDERR:
  return a != b;
}

// --- fail_no_impl_for_args.carbon

package FailNoImplForArgs;

class C {};
class D {};

impl C as Core.Eq {
  fn Equal[self: C](other: C) -> bool;
  fn NotEqual[self: C](other: C) -> bool;
}

fn TestRhsBad(a: C, b: D) -> bool {
  // CHECK:STDERR: fail_no_impl_for_args.carbon:[[@LINE+10]]:15: error: cannot implicitly convert from `D` to `C` [ImplicitAsConversionFailure]
  // CHECK:STDERR:   return a == b;
  // CHECK:STDERR:               ^
  // CHECK:STDERR: fail_no_impl_for_args.carbon:[[@LINE+7]]:15: note: type `D` does not implement interface `Core.ImplicitAs(C)` [MissingImplInMemberAccessNote]
  // CHECK:STDERR:   return a == b;
  // CHECK:STDERR:               ^
  // CHECK:STDERR: fail_no_impl_for_args.carbon:[[@LINE-11]]:21: note: initializing function parameter [InCallToFunctionParam]
  // CHECK:STDERR:   fn Equal[self: C](other: C) -> bool;
  // CHECK:STDERR:                     ^~~~~~~~
  // CHECK:STDERR:
  return a == b;
}

fn TestLhsBad(a: D, b: C) -> bool {
  // CHECK:STDERR: fail_no_impl_for_args.carbon:[[@LINE+4]]:10: error: cannot access member of interface `Core.Eq` in type `D` that does not implement that interface [MissingImplInMemberAccess]
  // CHECK:STDERR:   return a != b;
  // CHECK:STDERR:          ^~~~~~
  // CHECK:STDERR:
  return a != b;
}

// CHECK:STDOUT: --- user.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT:   %Eq.type: type = facet_type <@Eq> [template]
// CHECK:STDOUT:   %Equal.type.79c: type = fn_type @Equal.1 [template]
// CHECK:STDOUT:   %NotEqual.type.e6c: type = fn_type @NotEqual.1 [template]
// CHECK:STDOUT:   %impl_witness: <witness> = impl_witness (@impl.1.%Equal.decl, @impl.1.%NotEqual.decl) [template]
// CHECK:STDOUT:   %Bool.type: type = fn_type @Bool [template]
// CHECK:STDOUT:   %Bool: %Bool.type = struct_value () [template]
// CHECK:STDOUT:   %Equal.type.b4a: type = fn_type @Equal.2 [template]
// CHECK:STDOUT:   %Equal.f96: %Equal.type.b4a = struct_value () [template]
// CHECK:STDOUT:   %NotEqual.type.a7d: type = fn_type @NotEqual.2 [template]
// CHECK:STDOUT:   %NotEqual.c3f: %NotEqual.type.a7d = struct_value () [template]
// CHECK:STDOUT:   %Eq.facet: %Eq.type = facet_value %C, %impl_witness [template]
// CHECK:STDOUT:   %TestEqual.type: type = fn_type @TestEqual [template]
// CHECK:STDOUT:   %TestEqual: %TestEqual.type = struct_value () [template]
// CHECK:STDOUT:   %.dad: type = fn_type_with_self_type %Equal.type.79c, %Eq.facet [template]
// CHECK:STDOUT:   %TestNotEqual.type: type = fn_type @TestNotEqual [template]
// CHECK:STDOUT:   %TestNotEqual: %TestNotEqual.type = struct_value () [template]
// CHECK:STDOUT:   %.d23: type = fn_type_with_self_type %NotEqual.type.e6c, %Eq.facet [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Eq = %Core.Eq
// CHECK:STDOUT:     .Bool = %Core.Bool
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.Eq: type = import_ref Core//prelude/operators/comparison, Eq, loaded [template = constants.%Eq.type]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .C = %C.decl
// CHECK:STDOUT:     .TestEqual = %TestEqual.decl
// CHECK:STDOUT:     .TestNotEqual = %TestNotEqual.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %C.decl: type = class_decl @C [template = constants.%C] {} {}
// CHECK:STDOUT:   impl_decl @impl.1 [template] {} {
// CHECK:STDOUT:     %C.ref: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %Core.ref: <namespace> = name_ref Core, imports.%Core [template = imports.%Core]
// CHECK:STDOUT:     %Eq.ref: type = name_ref Eq, imports.%Core.Eq [template = constants.%Eq.type]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %impl_witness: <witness> = impl_witness (@impl.1.%Equal.decl, @impl.1.%NotEqual.decl) [template = constants.%impl_witness]
// CHECK:STDOUT:   %TestEqual.decl: %TestEqual.type = fn_decl @TestEqual [template = constants.%TestEqual] {
// CHECK:STDOUT:     %a.patt: %C = binding_pattern a
// CHECK:STDOUT:     %a.param_patt: %C = value_param_pattern %a.patt, runtime_param0
// CHECK:STDOUT:     %b.patt: %C = binding_pattern b
// CHECK:STDOUT:     %b.param_patt: %C = value_param_pattern %b.patt, runtime_param1
// CHECK:STDOUT:     %return.patt: bool = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: bool = out_param_pattern %return.patt, runtime_param2
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %bool.make_type: init type = call constants.%Bool() [template = bool]
// CHECK:STDOUT:     %.loc11_29.1: type = value_of_initializer %bool.make_type [template = bool]
// CHECK:STDOUT:     %.loc11_29.2: type = converted %bool.make_type, %.loc11_29.1 [template = bool]
// CHECK:STDOUT:     %a.param: %C = value_param runtime_param0
// CHECK:STDOUT:     %C.ref.loc11_17: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %a: %C = bind_name a, %a.param
// CHECK:STDOUT:     %b.param: %C = value_param runtime_param1
// CHECK:STDOUT:     %C.ref.loc11_23: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %b: %C = bind_name b, %b.param
// CHECK:STDOUT:     %return.param: ref bool = out_param runtime_param2
// CHECK:STDOUT:     %return: ref bool = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %TestNotEqual.decl: %TestNotEqual.type = fn_decl @TestNotEqual [template = constants.%TestNotEqual] {
// CHECK:STDOUT:     %a.patt: %C = binding_pattern a
// CHECK:STDOUT:     %a.param_patt: %C = value_param_pattern %a.patt, runtime_param0
// CHECK:STDOUT:     %b.patt: %C = binding_pattern b
// CHECK:STDOUT:     %b.param_patt: %C = value_param_pattern %b.patt, runtime_param1
// CHECK:STDOUT:     %return.patt: bool = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: bool = out_param_pattern %return.patt, runtime_param2
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %bool.make_type: init type = call constants.%Bool() [template = bool]
// CHECK:STDOUT:     %.loc15_32.1: type = value_of_initializer %bool.make_type [template = bool]
// CHECK:STDOUT:     %.loc15_32.2: type = converted %bool.make_type, %.loc15_32.1 [template = bool]
// CHECK:STDOUT:     %a.param: %C = value_param runtime_param0
// CHECK:STDOUT:     %C.ref.loc15_20: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %a: %C = bind_name a, %a.param
// CHECK:STDOUT:     %b.param: %C = value_param runtime_param1
// CHECK:STDOUT:     %C.ref.loc15_26: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %b: %C = bind_name b, %b.param
// CHECK:STDOUT:     %return.param: ref bool = out_param runtime_param2
// CHECK:STDOUT:     %return: ref bool = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: impl @impl.1: %C.ref as %Eq.ref {
// CHECK:STDOUT:   %Equal.decl: %Equal.type.b4a = fn_decl @Equal.2 [template = constants.%Equal.f96] {
// CHECK:STDOUT:     %self.patt: %C = binding_pattern self
// CHECK:STDOUT:     %self.param_patt: %C = value_param_pattern %self.patt, runtime_param0
// CHECK:STDOUT:     %other.patt: %C = binding_pattern other
// CHECK:STDOUT:     %other.param_patt: %C = value_param_pattern %other.patt, runtime_param1
// CHECK:STDOUT:     %return.patt: bool = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: bool = out_param_pattern %return.patt, runtime_param2
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %bool.make_type: init type = call constants.%Bool() [template = bool]
// CHECK:STDOUT:     %.loc7_34.1: type = value_of_initializer %bool.make_type [template = bool]
// CHECK:STDOUT:     %.loc7_34.2: type = converted %bool.make_type, %.loc7_34.1 [template = bool]
// CHECK:STDOUT:     %self.param: %C = value_param runtime_param0
// CHECK:STDOUT:     %C.ref.loc7_18: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %self: %C = bind_name self, %self.param
// CHECK:STDOUT:     %other.param: %C = value_param runtime_param1
// CHECK:STDOUT:     %C.ref.loc7_28: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %other: %C = bind_name other, %other.param
// CHECK:STDOUT:     %return.param: ref bool = out_param runtime_param2
// CHECK:STDOUT:     %return: ref bool = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %NotEqual.decl: %NotEqual.type.a7d = fn_decl @NotEqual.2 [template = constants.%NotEqual.c3f] {
// CHECK:STDOUT:     %self.patt: %C = binding_pattern self
// CHECK:STDOUT:     %self.param_patt: %C = value_param_pattern %self.patt, runtime_param0
// CHECK:STDOUT:     %other.patt: %C = binding_pattern other
// CHECK:STDOUT:     %other.param_patt: %C = value_param_pattern %other.patt, runtime_param1
// CHECK:STDOUT:     %return.patt: bool = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: bool = out_param_pattern %return.patt, runtime_param2
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %bool.make_type: init type = call constants.%Bool() [template = bool]
// CHECK:STDOUT:     %.loc8_37.1: type = value_of_initializer %bool.make_type [template = bool]
// CHECK:STDOUT:     %.loc8_37.2: type = converted %bool.make_type, %.loc8_37.1 [template = bool]
// CHECK:STDOUT:     %self.param: %C = value_param runtime_param0
// CHECK:STDOUT:     %C.ref.loc8_21: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %self: %C = bind_name self, %self.param
// CHECK:STDOUT:     %other.param: %C = value_param runtime_param1
// CHECK:STDOUT:     %C.ref.loc8_31: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %other: %C = bind_name other, %other.param
// CHECK:STDOUT:     %return.param: ref bool = out_param runtime_param2
// CHECK:STDOUT:     %return: ref bool = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Equal = %Equal.decl
// CHECK:STDOUT:   .NotEqual = %NotEqual.decl
// CHECK:STDOUT:   witness = file.%impl_witness
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C {
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template = constants.%complete_type]
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%C
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Equal.2[%self.param_patt: %C](%other.param_patt: %C) -> bool;
// CHECK:STDOUT:
// CHECK:STDOUT: fn @NotEqual.2[%self.param_patt: %C](%other.param_patt: %C) -> bool;
// CHECK:STDOUT:
// CHECK:STDOUT: fn @TestEqual(%a.param_patt: %C, %b.param_patt: %C) -> bool {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %a.ref: %C = name_ref a, %a
// CHECK:STDOUT:   %b.ref: %C = name_ref b, %b
// CHECK:STDOUT:   %impl.elem0: %.dad = impl_witness_access constants.%impl_witness, element0 [template = constants.%Equal.f96]
// CHECK:STDOUT:   %bound_method: <bound method> = bound_method %a.ref, %impl.elem0
// CHECK:STDOUT:   %Equal.call: init bool = call %bound_method(%a.ref, %b.ref)
// CHECK:STDOUT:   %.loc12_16.1: bool = value_of_initializer %Equal.call
// CHECK:STDOUT:   %.loc12_16.2: bool = converted %Equal.call, %.loc12_16.1
// CHECK:STDOUT:   return %.loc12_16.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @TestNotEqual(%a.param_patt: %C, %b.param_patt: %C) -> bool {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %a.ref: %C = name_ref a, %a
// CHECK:STDOUT:   %b.ref: %C = name_ref b, %b
// CHECK:STDOUT:   %impl.elem1: %.d23 = impl_witness_access constants.%impl_witness, element1 [template = constants.%NotEqual.c3f]
// CHECK:STDOUT:   %bound_method: <bound method> = bound_method %a.ref, %impl.elem1
// CHECK:STDOUT:   %NotEqual.call: init bool = call %bound_method(%a.ref, %b.ref)
// CHECK:STDOUT:   %.loc16_16.1: bool = value_of_initializer %NotEqual.call
// CHECK:STDOUT:   %.loc16_16.2: bool = converted %NotEqual.call, %.loc16_16.1
// CHECK:STDOUT:   return %.loc16_16.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_no_impl.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %D: type = class_type @D [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT:   %Bool.type: type = fn_type @Bool [template]
// CHECK:STDOUT:   %Bool: %Bool.type = struct_value () [template]
// CHECK:STDOUT:   %TestEqual.type: type = fn_type @TestEqual [template]
// CHECK:STDOUT:   %TestEqual: %TestEqual.type = struct_value () [template]
// CHECK:STDOUT:   %TestNotEqual.type: type = fn_type @TestNotEqual [template]
// CHECK:STDOUT:   %TestNotEqual: %TestNotEqual.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Bool = %Core.Bool
// CHECK:STDOUT:     .Eq = %Core.Eq
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .D = %D.decl
// CHECK:STDOUT:     .TestEqual = %TestEqual.decl
// CHECK:STDOUT:     .TestNotEqual = %TestNotEqual.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %D.decl: type = class_decl @D [template = constants.%D] {} {}
// CHECK:STDOUT:   %TestEqual.decl: %TestEqual.type = fn_decl @TestEqual [template = constants.%TestEqual] {
// CHECK:STDOUT:     %a.patt: %D = binding_pattern a
// CHECK:STDOUT:     %a.param_patt: %D = value_param_pattern %a.patt, runtime_param0
// CHECK:STDOUT:     %b.patt: %D = binding_pattern b
// CHECK:STDOUT:     %b.param_patt: %D = value_param_pattern %b.patt, runtime_param1
// CHECK:STDOUT:     %return.patt: bool = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: bool = out_param_pattern %return.patt, runtime_param2
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %bool.make_type: init type = call constants.%Bool() [template = bool]
// CHECK:STDOUT:     %.loc6_29.1: type = value_of_initializer %bool.make_type [template = bool]
// CHECK:STDOUT:     %.loc6_29.2: type = converted %bool.make_type, %.loc6_29.1 [template = bool]
// CHECK:STDOUT:     %a.param: %D = value_param runtime_param0
// CHECK:STDOUT:     %D.ref.loc6_17: type = name_ref D, file.%D.decl [template = constants.%D]
// CHECK:STDOUT:     %a: %D = bind_name a, %a.param
// CHECK:STDOUT:     %b.param: %D = value_param runtime_param1
// CHECK:STDOUT:     %D.ref.loc6_23: type = name_ref D, file.%D.decl [template = constants.%D]
// CHECK:STDOUT:     %b: %D = bind_name b, %b.param
// CHECK:STDOUT:     %return.param: ref bool = out_param runtime_param2
// CHECK:STDOUT:     %return: ref bool = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %TestNotEqual.decl: %TestNotEqual.type = fn_decl @TestNotEqual [template = constants.%TestNotEqual] {
// CHECK:STDOUT:     %a.patt: %D = binding_pattern a
// CHECK:STDOUT:     %a.param_patt: %D = value_param_pattern %a.patt, runtime_param0
// CHECK:STDOUT:     %b.patt: %D = binding_pattern b
// CHECK:STDOUT:     %b.param_patt: %D = value_param_pattern %b.patt, runtime_param1
// CHECK:STDOUT:     %return.patt: bool = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: bool = out_param_pattern %return.patt, runtime_param2
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %bool.make_type: init type = call constants.%Bool() [template = bool]
// CHECK:STDOUT:     %.loc14_32.1: type = value_of_initializer %bool.make_type [template = bool]
// CHECK:STDOUT:     %.loc14_32.2: type = converted %bool.make_type, %.loc14_32.1 [template = bool]
// CHECK:STDOUT:     %a.param: %D = value_param runtime_param0
// CHECK:STDOUT:     %D.ref.loc14_20: type = name_ref D, file.%D.decl [template = constants.%D]
// CHECK:STDOUT:     %a: %D = bind_name a, %a.param
// CHECK:STDOUT:     %b.param: %D = value_param runtime_param1
// CHECK:STDOUT:     %D.ref.loc14_26: type = name_ref D, file.%D.decl [template = constants.%D]
// CHECK:STDOUT:     %b: %D = bind_name b, %b.param
// CHECK:STDOUT:     %return.param: ref bool = out_param runtime_param2
// CHECK:STDOUT:     %return: ref bool = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @D {
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template = constants.%complete_type]
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%D
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @TestEqual(%a.param_patt: %D, %b.param_patt: %D) -> bool {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %a.ref: %D = name_ref a, %a
// CHECK:STDOUT:   %b.ref: %D = name_ref b, %b
// CHECK:STDOUT:   return <error>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @TestNotEqual(%a.param_patt: %D, %b.param_patt: %D) -> bool {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %a.ref: %D = name_ref a, %a
// CHECK:STDOUT:   %b.ref: %D = name_ref b, %b
// CHECK:STDOUT:   return <error>
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: --- fail_no_impl_for_args.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT:   %D: type = class_type @D [template]
// CHECK:STDOUT:   %Eq.type: type = facet_type <@Eq> [template]
// CHECK:STDOUT:   %Equal.type.79c: type = fn_type @Equal.1 [template]
// CHECK:STDOUT:   %impl_witness: <witness> = impl_witness (@impl.1.%Equal.decl, @impl.1.%NotEqual.decl) [template]
// CHECK:STDOUT:   %Bool.type: type = fn_type @Bool [template]
// CHECK:STDOUT:   %Bool: %Bool.type = struct_value () [template]
// CHECK:STDOUT:   %Equal.type.b4a: type = fn_type @Equal.2 [template]
// CHECK:STDOUT:   %Equal.f96: %Equal.type.b4a = struct_value () [template]
// CHECK:STDOUT:   %NotEqual.type.a7d: type = fn_type @NotEqual.2 [template]
// CHECK:STDOUT:   %NotEqual.c3f: %NotEqual.type.a7d = struct_value () [template]
// CHECK:STDOUT:   %Eq.facet: %Eq.type = facet_value %C, %impl_witness [template]
// CHECK:STDOUT:   %TestRhsBad.type: type = fn_type @TestRhsBad [template]
// CHECK:STDOUT:   %TestRhsBad: %TestRhsBad.type = struct_value () [template]
// CHECK:STDOUT:   %.dad: type = fn_type_with_self_type %Equal.type.79c, %Eq.facet [template]
// CHECK:STDOUT:   %TestLhsBad.type: type = fn_type @TestLhsBad [template]
// CHECK:STDOUT:   %TestLhsBad: %TestLhsBad.type = struct_value () [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: imports {
// CHECK:STDOUT:   %Core: <namespace> = namespace file.%Core.import, [template] {
// CHECK:STDOUT:     .Eq = %Core.Eq
// CHECK:STDOUT:     .Bool = %Core.Bool
// CHECK:STDOUT:     .ImplicitAs = %Core.ImplicitAs
// CHECK:STDOUT:     import Core//prelude
// CHECK:STDOUT:     import Core//prelude/...
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.Eq: type = import_ref Core//prelude/operators/comparison, Eq, loaded [template = constants.%Eq.type]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Core = imports.%Core
// CHECK:STDOUT:     .C = %C.decl
// CHECK:STDOUT:     .D = %D.decl
// CHECK:STDOUT:     .TestRhsBad = %TestRhsBad.decl
// CHECK:STDOUT:     .TestLhsBad = %TestLhsBad.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Core.import = import Core
// CHECK:STDOUT:   %C.decl: type = class_decl @C [template = constants.%C] {} {}
// CHECK:STDOUT:   %D.decl: type = class_decl @D [template = constants.%D] {} {}
// CHECK:STDOUT:   impl_decl @impl.1 [template] {} {
// CHECK:STDOUT:     %C.ref: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %Core.ref: <namespace> = name_ref Core, imports.%Core [template = imports.%Core]
// CHECK:STDOUT:     %Eq.ref: type = name_ref Eq, imports.%Core.Eq [template = constants.%Eq.type]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %impl_witness: <witness> = impl_witness (@impl.1.%Equal.decl, @impl.1.%NotEqual.decl) [template = constants.%impl_witness]
// CHECK:STDOUT:   %TestRhsBad.decl: %TestRhsBad.type = fn_decl @TestRhsBad [template = constants.%TestRhsBad] {
// CHECK:STDOUT:     %a.patt: %C = binding_pattern a
// CHECK:STDOUT:     %a.param_patt: %C = value_param_pattern %a.patt, runtime_param0
// CHECK:STDOUT:     %b.patt: %D = binding_pattern b
// CHECK:STDOUT:     %b.param_patt: %D = value_param_pattern %b.patt, runtime_param1
// CHECK:STDOUT:     %return.patt: bool = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: bool = out_param_pattern %return.patt, runtime_param2
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %bool.make_type: init type = call constants.%Bool() [template = bool]
// CHECK:STDOUT:     %.loc12_30.1: type = value_of_initializer %bool.make_type [template = bool]
// CHECK:STDOUT:     %.loc12_30.2: type = converted %bool.make_type, %.loc12_30.1 [template = bool]
// CHECK:STDOUT:     %a.param: %C = value_param runtime_param0
// CHECK:STDOUT:     %C.ref: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %a: %C = bind_name a, %a.param
// CHECK:STDOUT:     %b.param: %D = value_param runtime_param1
// CHECK:STDOUT:     %D.ref: type = name_ref D, file.%D.decl [template = constants.%D]
// CHECK:STDOUT:     %b: %D = bind_name b, %b.param
// CHECK:STDOUT:     %return.param: ref bool = out_param runtime_param2
// CHECK:STDOUT:     %return: ref bool = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %TestLhsBad.decl: %TestLhsBad.type = fn_decl @TestLhsBad [template = constants.%TestLhsBad] {
// CHECK:STDOUT:     %a.patt: %D = binding_pattern a
// CHECK:STDOUT:     %a.param_patt: %D = value_param_pattern %a.patt, runtime_param0
// CHECK:STDOUT:     %b.patt: %C = binding_pattern b
// CHECK:STDOUT:     %b.param_patt: %C = value_param_pattern %b.patt, runtime_param1
// CHECK:STDOUT:     %return.patt: bool = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: bool = out_param_pattern %return.patt, runtime_param2
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %bool.make_type: init type = call constants.%Bool() [template = bool]
// CHECK:STDOUT:     %.loc26_30.1: type = value_of_initializer %bool.make_type [template = bool]
// CHECK:STDOUT:     %.loc26_30.2: type = converted %bool.make_type, %.loc26_30.1 [template = bool]
// CHECK:STDOUT:     %a.param: %D = value_param runtime_param0
// CHECK:STDOUT:     %D.ref: type = name_ref D, file.%D.decl [template = constants.%D]
// CHECK:STDOUT:     %a: %D = bind_name a, %a.param
// CHECK:STDOUT:     %b.param: %C = value_param runtime_param1
// CHECK:STDOUT:     %C.ref: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %b: %C = bind_name b, %b.param
// CHECK:STDOUT:     %return.param: ref bool = out_param runtime_param2
// CHECK:STDOUT:     %return: ref bool = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: impl @impl.1: %C.ref as %Eq.ref {
// CHECK:STDOUT:   %Equal.decl: %Equal.type.b4a = fn_decl @Equal.2 [template = constants.%Equal.f96] {
// CHECK:STDOUT:     %self.patt: %C = binding_pattern self
// CHECK:STDOUT:     %self.param_patt: %C = value_param_pattern %self.patt, runtime_param0
// CHECK:STDOUT:     %other.patt: %C = binding_pattern other
// CHECK:STDOUT:     %other.param_patt: %C = value_param_pattern %other.patt, runtime_param1
// CHECK:STDOUT:     %return.patt: bool = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: bool = out_param_pattern %return.patt, runtime_param2
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %bool.make_type: init type = call constants.%Bool() [template = bool]
// CHECK:STDOUT:     %.loc8_34.1: type = value_of_initializer %bool.make_type [template = bool]
// CHECK:STDOUT:     %.loc8_34.2: type = converted %bool.make_type, %.loc8_34.1 [template = bool]
// CHECK:STDOUT:     %self.param: %C = value_param runtime_param0
// CHECK:STDOUT:     %C.ref.loc8_18: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %self: %C = bind_name self, %self.param
// CHECK:STDOUT:     %other.param: %C = value_param runtime_param1
// CHECK:STDOUT:     %C.ref.loc8_28: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %other: %C = bind_name other, %other.param
// CHECK:STDOUT:     %return.param: ref bool = out_param runtime_param2
// CHECK:STDOUT:     %return: ref bool = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %NotEqual.decl: %NotEqual.type.a7d = fn_decl @NotEqual.2 [template = constants.%NotEqual.c3f] {
// CHECK:STDOUT:     %self.patt: %C = binding_pattern self
// CHECK:STDOUT:     %self.param_patt: %C = value_param_pattern %self.patt, runtime_param0
// CHECK:STDOUT:     %other.patt: %C = binding_pattern other
// CHECK:STDOUT:     %other.param_patt: %C = value_param_pattern %other.patt, runtime_param1
// CHECK:STDOUT:     %return.patt: bool = return_slot_pattern
// CHECK:STDOUT:     %return.param_patt: bool = out_param_pattern %return.patt, runtime_param2
// CHECK:STDOUT:   } {
// CHECK:STDOUT:     %bool.make_type: init type = call constants.%Bool() [template = bool]
// CHECK:STDOUT:     %.loc9_37.1: type = value_of_initializer %bool.make_type [template = bool]
// CHECK:STDOUT:     %.loc9_37.2: type = converted %bool.make_type, %.loc9_37.1 [template = bool]
// CHECK:STDOUT:     %self.param: %C = value_param runtime_param0
// CHECK:STDOUT:     %C.ref.loc9_21: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %self: %C = bind_name self, %self.param
// CHECK:STDOUT:     %other.param: %C = value_param runtime_param1
// CHECK:STDOUT:     %C.ref.loc9_31: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %other: %C = bind_name other, %other.param
// CHECK:STDOUT:     %return.param: ref bool = out_param runtime_param2
// CHECK:STDOUT:     %return: ref bool = return_slot %return.param
// CHECK:STDOUT:   }
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Equal = %Equal.decl
// CHECK:STDOUT:   .NotEqual = %NotEqual.decl
// CHECK:STDOUT:   witness = file.%impl_witness
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @C {
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template = constants.%complete_type]
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%C
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: class @D {
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template = constants.%complete_type]
// CHECK:STDOUT:   complete_type_witness = %complete_type
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = constants.%D
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @Equal.2[%self.param_patt: %C](%other.param_patt: %C) -> bool;
// CHECK:STDOUT:
// CHECK:STDOUT: fn @NotEqual.2[%self.param_patt: %C](%other.param_patt: %C) -> bool;
// CHECK:STDOUT:
// CHECK:STDOUT: fn @TestRhsBad(%a.param_patt: %C, %b.param_patt: %D) -> bool {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %a.ref: %C = name_ref a, %a
// CHECK:STDOUT:   %b.ref: %D = name_ref b, %b
// CHECK:STDOUT:   %impl.elem0: %.dad = impl_witness_access constants.%impl_witness, element0 [template = constants.%Equal.f96]
// CHECK:STDOUT:   %bound_method: <bound method> = bound_method %a.ref, %impl.elem0
// CHECK:STDOUT:   %.loc23_15: %C = converted %b.ref, <error> [template = <error>]
// CHECK:STDOUT:   %Equal.call: init bool = call %bound_method(%a.ref, <error>)
// CHECK:STDOUT:   %.loc23_16.1: bool = value_of_initializer %Equal.call
// CHECK:STDOUT:   %.loc23_16.2: bool = converted %Equal.call, %.loc23_16.1
// CHECK:STDOUT:   return %.loc23_16.2
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @TestLhsBad(%a.param_patt: %D, %b.param_patt: %C) -> bool {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   %a.ref: %D = name_ref a, %a
// CHECK:STDOUT:   %b.ref: %C = name_ref b, %b
// CHECK:STDOUT:   return <error>
// CHECK:STDOUT: }
// CHECK:STDOUT:
