#include "carbonls.h"

#include <iostream>
#include <optional>

#include "common/error.h"
#include "explorer/ast/ast.h"
#include "explorer/common/arena.h"
#include "explorer/syntax/parse.h"
#include "lscpp/lsp_server.h"

namespace Carbon::LS {

auto parse(Arena& arena, std::string content) {
  return ParseFromString(&arena, "<filename>", content, false);
}

auto parse_error_location(std::string const& loc) -> lscpp::protocol::Range {
  // close your eyes
  auto split_fname = loc.find(':');
  auto pos = loc.substr(split_fname + 1);
  auto split = pos.find('-');
  auto start = pos.substr(0, split);
  std::cerr << start << std::endl;
  auto end = pos.substr(split + 1);
  std::cerr << end << std::endl;
  auto split_s = start.find(':');
  auto s = lscpp::protocol::Position{std::stoi(start.substr(0, split_s)) - 1,
                                     std::stoi(start.substr(split_s + 1)) - 1};
  auto split_e = end.find(':');
  auto e = lscpp::protocol::Position{std::stoi(end.substr(0, split_e)) - 1,
                                     std::stoi(end.substr(split_e + 1)) - 1};

  return {s, e};
}

auto lscpp_handle_hover(CarbonLS& server,
                        lscpp::protocol::TextDocumentPositionParams position)
    -> lscpp::protocol::Hover {
  auto& ast = server.open_files_.at(position.textDocument.uri);
  if (ast.ok()) {
    return {"all good!", {}};
  } else {
    return {ast.error().message() + " at " + ast.error().location(),
            parse_error_location(ast.error().location())};
  }
}

void lscpp_handle_did_open(CarbonLS& server,
                           lscpp::protocol::DidOpenTextDocumentParams params) {
  server.open_files_.emplace(std::pair(
      params.textDocument.uri, parse(server.arena_, params.textDocument.text)));
}
void lscpp_handle_did_change(
    CarbonLS& server, lscpp::protocol::DidChangeTextDocumentParams params) {
  server.open_files_.erase(params.textDocument.uri);
  server.open_files_.emplace(
      std::pair(params.textDocument.uri,
                parse(server.arena_, params.contentChanges[0].text)));
}
void lscpp_handle_did_close(
    CarbonLS& server, lscpp::protocol::DidCloseTextDocumentParams params) {
  server.open_files_.erase(params.textDocument.uri);
}

void lscpp_handle_did_save(
    CarbonLS& /* unused */,
    lscpp::protocol::DidSaveTextDocumentParams /*unused*/){};
}  // namespace Carbon::LS