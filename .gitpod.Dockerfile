FROM gitpod/workspace-full:2022-05-08-14-31-53

RUN brew install bazelisk

RUN brew install llvm

ENV PATH="$(brew --prefix llvm)/bin:${PATH}"

# bazel cache directory
ENV TEST_TMPDIR=/workspace/.cache
