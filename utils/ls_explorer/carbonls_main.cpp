#include <lscpp/lsp_launcher.h>
#include <lscpp/stdio_transporter.h>

#include "carbonls.h"

auto main() -> int {
  lscpp::launch(Carbon::LS::CarbonLS{},
                lscpp::launch_config{0, {lscpp::Verbosity_MAX, "carbonls.log"}},
                lscpp::stdio_transporter{false});
}