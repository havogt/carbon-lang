// Part of the Carbon Language project, under the Apache License v2.0 with LLVM
// Exceptions. See /LICENSE for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// AUTOUPDATE
// TIP: To test this file alone, run:
// TIP:   bazel test //toolchain/testing:file_test --test_arg=--file_tests=toolchain/check/testdata/impl/no_prelude/basic.carbon
// TIP: To dump output, run:
// TIP:   bazel run //toolchain/testing:file_test -- --dump_output --file_tests=toolchain/check/testdata/impl/no_prelude/basic.carbon

interface Simple {
  fn F();
}

class C {}

impl C as Simple {
  fn F() {}
}

// CHECK:STDOUT: --- basic.carbon
// CHECK:STDOUT:
// CHECK:STDOUT: constants {
// CHECK:STDOUT:   %Simple.type: type = facet_type <@Simple> [template]
// CHECK:STDOUT:   %Self: %Simple.type = bind_symbolic_name Self, 0 [symbolic]
// CHECK:STDOUT:   %F.type.e2e: type = fn_type @F.1 [template]
// CHECK:STDOUT:   %F.df8: %F.type.e2e = struct_value () [template]
// CHECK:STDOUT:   %Simple.assoc_type: type = assoc_entity_type %Simple.type [template]
// CHECK:STDOUT:   %assoc0: %Simple.assoc_type = assoc_entity element0, @Simple.%F.decl [template]
// CHECK:STDOUT:   %C: type = class_type @C [template]
// CHECK:STDOUT:   %empty_struct_type: type = struct_type {} [template]
// CHECK:STDOUT:   %complete_type: <witness> = complete_type_witness %empty_struct_type [template]
// CHECK:STDOUT:   %impl_witness: <witness> = impl_witness (@impl.%F.decl) [template]
// CHECK:STDOUT:   %F.type.f9e: type = fn_type @F.2 [template]
// CHECK:STDOUT:   %F.f50: %F.type.f9e = struct_value () [template]
// CHECK:STDOUT:   %Simple.facet: %Simple.type = facet_value %C, %impl_witness [template]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: file {
// CHECK:STDOUT:   package: <namespace> = namespace [template] {
// CHECK:STDOUT:     .Simple = %Simple.decl
// CHECK:STDOUT:     .C = %C.decl
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %Simple.decl: type = interface_decl @Simple [template = constants.%Simple.type] {} {}
// CHECK:STDOUT:   %C.decl: type = class_decl @C [template = constants.%C] {} {}
// CHECK:STDOUT:   impl_decl @impl [template] {} {
// CHECK:STDOUT:     %C.ref: type = name_ref C, file.%C.decl [template = constants.%C]
// CHECK:STDOUT:     %Simple.ref: type = name_ref Simple, file.%Simple.decl [template = constants.%Simple.type]
// CHECK:STDOUT:   }
// CHECK:STDOUT:   %impl_witness: <witness> = impl_witness (@impl.%F.decl) [template = constants.%impl_witness]
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: interface @Simple {
// CHECK:STDOUT:   %Self: %Simple.type = bind_symbolic_name Self, 0 [symbolic = constants.%Self]
// CHECK:STDOUT:   %F.decl: %F.type.e2e = fn_decl @F.1 [template = constants.%F.df8] {} {}
// CHECK:STDOUT:   %assoc0: %Simple.assoc_type = assoc_entity element0, %F.decl [template = constants.%assoc0]
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .Self = %Self
// CHECK:STDOUT:   .F = %assoc0
// CHECK:STDOUT:   witness = (%F.decl)
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: impl @impl: %C.ref as %Simple.ref {
// CHECK:STDOUT:   %F.decl: %F.type.f9e = fn_decl @F.2 [template = constants.%F.f50] {} {}
// CHECK:STDOUT:
// CHECK:STDOUT: !members:
// CHECK:STDOUT:   .F = %F.decl
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
// CHECK:STDOUT: generic fn @F.1(@Simple.%Self: %Simple.type) {
// CHECK:STDOUT:   fn();
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: fn @F.2() {
// CHECK:STDOUT: !entry:
// CHECK:STDOUT:   return
// CHECK:STDOUT: }
// CHECK:STDOUT:
// CHECK:STDOUT: specific @F.1(constants.%Self) {}
// CHECK:STDOUT:
// CHECK:STDOUT: specific @F.1(constants.%Simple.facet) {}
// CHECK:STDOUT:
