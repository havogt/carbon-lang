#pragma once

#include <lscpp/lsp_server.h>

#include <string>
#include <unordered_map>

#include "common/error.h"
#include "explorer/ast/ast.h"

namespace Carbon::LS {

class CarbonLS : public lscpp::lsp_server, lscpp::TextDocumentService {
 public:
  auto initialize(const lscpp::protocol::InitializeParams& params)
      -> lscpp::protocol::InitializeResult override;
  auto getTextDocumentService() -> TextDocumentService& override;

  auto hover(lscpp::protocol::TextDocumentPositionParams position)
      -> lscpp::protocol::Hover override;

  auto definition(lscpp::protocol::TextDocumentPositionParams position)
      -> lscpp::protocol::Location override;

  auto completion(lscpp::protocol::CompletionParams params)
      -> std::variant<std::vector<lscpp::protocol::CompletionItem>> override;

  void didOpen(lscpp::protocol::DidOpenTextDocumentParams params) override;

  void didChange(lscpp::protocol::DidChangeTextDocumentParams params) override;

  void didClose(lscpp::protocol::DidCloseTextDocumentParams params) override;

  void didSave(lscpp::protocol::DidSaveTextDocumentParams params) override;

 private:
  std::unordered_map<std::string, std::optional<AST>> open_files_;
  Arena arena_;
};
}  // namespace Carbon::LS