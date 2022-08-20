# Part of the Carbon Language project, under the Apache License v2.0 with LLVM
# Exceptions. See /LICENSE for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "carbonlslib",
    srcs = ["carbonls.cpp"],
    hdrs = ["carbonls.h"],
    deps = [
        "//toolchain/lexer:tokenized_buffer",
        "//toolchain/parser:parse_tree",
        "//toolchain/source:source_buffer",
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
