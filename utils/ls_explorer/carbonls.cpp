#include "carbonls.h"

#include <iostream>

#include "common/error.h"
#include "explorer/ast/ast.h"
#include "explorer/common/arena.h"
#include "explorer/syntax/parse.h"
#include "lscpp/lsp_server.h"

void parse(std::string filename) {
  using namespace Carbon;

  Arena arena;
  auto error_or_ast = Parse(&arena, filename, false);
  if (!error_or_ast.ok()) {
    auto& error = error_or_ast.error();
    std::cout << error.message() << std::endl;
    auto& loc = error.location();
    std::cout << loc << std::endl;
    return;
  }
  AST ast = *error_or_ast;
}