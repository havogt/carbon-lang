// #include <lscpp/lsp_launcher.h>
#include <lscpp/stdio_transporter.h>

#include "carbonls.h"

auto main() -> int {
  lscpp::experimental::launch(Carbon::LS::CarbonLS{},
                              lscpp::stdio_transporter{false});
}