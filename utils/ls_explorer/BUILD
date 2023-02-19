# Part of the Carbon Language project, under the Apache License v2.0 with LLVM
# Exceptions. See /LICENSE for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

package(default_visibility = ["//visibility:public"])

# load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

# cmake(
#     name = "lscpp",
#     cache_entries = {
#     },
#     lib_source = "@lscpp//:lscpp",
#     out_static_libs = ["lscpp.a"],
# )

cc_library(
    name = "carbonlslib",
    srcs = ["carbonls.cpp"],
    hdrs = ["carbonls.h"],
    deps = [
        "//explorer/syntax:syntax",
        "//explorer/common:arena",
        "@lscpp//:lscpp",
        "@llvm-project//llvm:Support",
    ],
)

cc_binary(
    name = "carbonls",
    srcs = ["carbonls_main.cpp"],
    deps = [
        ":carbonlslib",
        "@llvm-project//llvm:Support",
    ],
)
