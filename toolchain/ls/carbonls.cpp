#include "carbonls.h"

#include <iostream>

#include "toolchain/diagnostics/diagnostic_emitter.h"
#include "toolchain/lexer/tokenized_buffer.h"
#include "toolchain/parser/parse_tree.h"
#include "toolchain/source/source_buffer.h"

class LSDiagnosticConsumer : public Carbon::DiagnosticConsumer {
 public:
  auto HandleDiagnostic(const Carbon::Diagnostic& diagnostic) -> void override {
    diagnostics_.push_back(diagnostic);
    std::cout << diagnostic.format_fn(diagnostic) << std::endl;
  }

  void Flush() override {}

 private:
  llvm::SmallVector<Carbon::Diagnostic, 0> diagnostics_;
};

void parse(std::string filename) {
  using namespace Carbon;

  auto source = SourceBuffer::CreateFromFile(filename);
  //   if (!source) {
  //     error_stream_ << "ERROR: Unable to open input source file: ";
  //     llvm::handleAllErrors(source.takeError(),
  //                           [&](const llvm::ErrorInfoBase& ei) {
  //                             ei.log(error_stream_);
  //                             error_stream_ << "\n";
  //                           });
  //     return false;
  //   }
  LSDiagnosticConsumer consumer;
  auto tokenized_source = TokenizedBuffer::Lex(*source, consumer);
}