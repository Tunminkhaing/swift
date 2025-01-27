// RUN: %empty-directory(%t)
// RUN: %target-build-swift -Xfrontend -prespecialize-generic-metadata -target %module-target-future %S/Inputs/struct-public-nonfrozen-1argument-1constraint.swift %S/Inputs/protocol-public-empty.swift %S/Inputs/struct-public-nonfrozen-0argument.swift -emit-library -o %t/%target-library-name(Module) -emit-module -module-name Module -emit-module-path %t/Module.swiftmodule
// RUN: %target-build-swift -Xfrontend -prespecialize-generic-metadata -target %module-target-future %S/Inputs/struct-public-nonfrozen-0argument-conformance-empty.swift -emit-library -o %t/%target-library-name(Argument) -emit-module -module-name Argument -emit-module-path %t/Argument.swiftmodule -DIMPORT_MODULE -L %t -I %t -lModule
// RUN: %swift %use_no_opaque_pointers -prespecialize-generic-metadata -target %module-target-future -emit-ir %s -L %t -I %t -lModule -lArgument | %FileCheck %s -DINT=i%target-ptrsize -DALIGNMENT=%target-alignment 
// RUN: %swift -prespecialize-generic-metadata -target %module-target-future -emit-ir %s -L %t -I %t -lModule -lArgument

// REQUIRES: VENDOR=apple || OS=linux-gnu
// UNSUPPORTED: CPU=i386 && OS=ios
// UNSUPPORTED: CPU=armv7 && OS=ios
// UNSUPPORTED: CPU=armv7s && OS=ios

//      CHECK: @"$s6Module11OneArgumentVyAA7IntegerVAeA1P0C0yHCg_GMN" = linkonce_odr hidden constant <{
// CHECK-SAME:  i8**,
// CHECK-SAME:  [[INT]],
// CHECK-SAME:  %swift.type_descriptor*,
// CHECK-SAME:  %swift.type*,
// CHECK-SAME:  i8**,
// CHECK-SAME:  i32,
// CHECK-SAME:  i32,
// CHECK-SAME:  i64
// CHECK-SAME:}> <{
//           :  i8** getelementptr inbounds (
//           :    %swift.vwtable,
//           :    %swift.vwtable* @"
// CHECK-SAME:    $s6Module11OneArgumentVyAA7IntegerVAeA1P0C0yHCg_GWV
//           :    ",
//           :    i32 0,
//           :    i32 0
//           :  ),
// CHECK-SAME:  [[INT]] 512,
//           :  %swift.type_descriptor* @"
// CHECK-SAME:  $s6Module11OneArgumentVMn
//           :  ",
// CHECK-SAME:  %swift.type* @"$s6Module7IntegerVN",
// CHECK-SAME:  i8** @"$s6Module7IntegerVAA1P8ArgumentWP",
// CHECK-SAME:  i32 0,
// CHECK-SAME:  i32 {{4|8}},
// CHECK-SAME:  i64 1
// CHECK-SAME:}>,
// CHECK-SAME:align [[ALIGNMENT]]

@inline(never)
func consume<T>(_ t: T) {
  withExtendedLifetime(t) { t in
  }
}

import Module
import Argument

// CHECK: define hidden swiftcc void @"$s4main4doityyF"() #{{[0-9]+}} {
//      CHECK:   [[CANONICALIZED_METADATA_RESPONSE:%[0-9]+]] = call swiftcc %swift.metadata_response @swift_getCanonicalSpecializedMetadata(
// CHECK-SAME:     [[INT]] 0, 
// CHECK-SAME:     %swift.type* getelementptr inbounds (
// CHECK-SAME:       %swift.full_type,
// CHECK-SAME:       %swift.full_type* bitcast (
// CHECK-SAME:         <{
// CHECK-SAME:           i8*,
// CHECK-SAME:           i8**,
// CHECK-SAME:           [[INT]],
// CHECK-SAME:           %swift.type_descriptor*,
// CHECK-SAME:           %swift.type*,
// CHECK-SAME:           i32,
// CHECK-SAME:           i32,
// CHECK-SAME:           i64
// CHECK-SAME:         }>* @"$s6Module11OneArgumentVyAA7IntegerVAeA1P0C0yHCg_GMN" to %swift.full_type*
// CHECK-SAME:       ),
// CHECK-SAME:       i32 0,
// CHECK-SAME:       i32 2
// CHECK-SAME:     ),
// CHECK-SAME:   %swift.type** @"$s6Module11OneArgumentVyAA7IntegerVAeA1P0C0yHCg_GMJ"
// CHECK-SAME:   )
// CHECK-NEXT:   [[CANONICALIZED_METADATA:%[0-9]+]] = extractvalue %swift.metadata_response [[CANONICALIZED_METADATA_RESPONSE]], 0
// CHECK-NEXT:   call swiftcc void @"$s4main7consumeyyxlF"(
// CHECK-SAME:     %swift.opaque* noalias nocapture {{%[0-9]+}}, 
// CHECK-SAME:     %swift.type* [[CANONICALIZED_METADATA]]
// CHECK-SAME:   )
// CHECK: }
func doit() {
  consume( OneArgument(Integer(13)) )
}
doit()





