# Part of the Carbon Language project, under the Apache License v2.0 with LLVM
# Exceptions. See /LICENSE for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "lscpp",
    hdrs = glob([
        "include/**/*.h",
        ]),
    srcs = glob([
        "src/*.cpp",
        "src/experimental/*.cpp",
        "src/**/*.h",
        "external/**/*.hpp",
        "external/**/*.cpp",
    ]),
    strip_include_prefix = "include",
    copts = [
                "-Iexternal/lscpp/external/loguru",
                "-Iexternal/lscpp/external", #TODO fix
                "-Wno-missing-field-initializers",
                "-Wno-unused-const-variable",
            ],
)