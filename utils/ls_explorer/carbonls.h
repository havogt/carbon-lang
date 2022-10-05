#pragma once

#include <lscpp/experimental/adl_lsp_server.h>
#include <lscpp/protocol/Hover.h>

#include <string>
#include <unordered_map>

#include "common/error.h"
#include "explorer/ast/ast.h"

namespace Carbon::LS {
struct CarbonLS : lscpp::experimental::server_with_default_handler {
  friend void lscpp_handle_did_save(
      CarbonLS& /* unused */,
      lscpp::protocol::DidSaveTextDocumentParams /*unused*/);
  friend void lscpp_handle_did_open(
      CarbonLS& server, lscpp::protocol::DidOpenTextDocumentParams params);
  friend void lscpp_handle_did_change(
      CarbonLS& server, lscpp::protocol::DidChangeTextDocumentParams params);
  friend void lscpp_handle_did_close(
      CarbonLS& server, lscpp::protocol::DidCloseTextDocumentParams params);
  friend auto lscpp_handle_hover(
      CarbonLS& server, lscpp::protocol::TextDocumentPositionParams position)
      -> lscpp::protocol::Hover;

 private:
  std::unordered_map<std::string, ErrorOr<AST>> open_files_;
  Arena arena_;
};

}  // namespace Carbon::LS