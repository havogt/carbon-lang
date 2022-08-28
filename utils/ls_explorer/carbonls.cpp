#include "carbonls.h"

#include <iostream>
#include <optional>

#include "common/error.h"
#include "explorer/ast/ast.h"
#include "explorer/common/arena.h"
#include "explorer/syntax/parse.h"
#include "lscpp/lsp_server.h"

namespace Carbon::LS {

std::optional<AST> parse(Arena& arena, std::string content) {
  auto error_or_ast = ParseFromString(&arena, "<filename>", content, false);
  if (error_or_ast.ok()) {
    return *error_or_ast;
  } else {
    return {};
  }
}

auto CarbonLS::initialize(const lscpp::protocol::InitializeParams& /*params*/)
    -> lscpp::protocol::InitializeResult {
  lscpp::protocol::ServerCapabilities capabilites;
  capabilites.hoverProvider = true;
  // capabilites.completionProvider = lscpp::protocol::CompletionOptions{};
  capabilites.definitionProvider = true;
  lscpp::protocol::TextDocumentSyncOptions sync;
  sync.openClose = true;
  sync.change = lscpp::protocol::TextDocumentSyncKind::Full;
  sync.save = {false};
  capabilites.textDocumentSync = sync;
  lscpp::protocol::InitializeResult result{capabilites};

  return result;
}

auto CarbonLS::getTextDocumentService() -> lscpp::TextDocumentService& {
  return *this;
}

auto CarbonLS::hover(lscpp::protocol::TextDocumentPositionParams position)
    -> lscpp::protocol::Hover {
  if (auto& ast = open_files_[position.textDocument.uri]) {
    return {"all good!", {}};
  } else {
    return {"error!", {}};
  }
}

auto CarbonLS::definition(
    lscpp::protocol::TextDocumentPositionParams /*position*/)
    -> lscpp::protocol::Location {
  return {};
}

auto CarbonLS::completion(lscpp::protocol::CompletionParams /*params*/)
    -> std::variant<std::vector<lscpp::protocol::CompletionItem>> {
  std::vector<lscpp::protocol::CompletionItem> result;
  return result;
}

void CarbonLS::didOpen(lscpp::protocol::DidOpenTextDocumentParams params) {
  open_files_.emplace(std::pair(params.textDocument.uri,
                                parse(arena_, params.textDocument.text)));
}
void CarbonLS::didChange(lscpp::protocol::DidChangeTextDocumentParams params) {
  open_files_.erase(params.textDocument.uri);
  open_files_.emplace(std::pair(params.textDocument.uri,
                                parse(arena_, params.contentChanges[0].text)));
}
void CarbonLS::didClose(lscpp::protocol::DidCloseTextDocumentParams params) {
  open_files_.erase(params.textDocument.uri);
}

void CarbonLS::didSave(lscpp::protocol::DidSaveTextDocumentParams /*params*/) {}

}  // namespace Carbon::LS