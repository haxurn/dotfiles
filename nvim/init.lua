-- haxurn's neovim config (based on BreadOnPenguins/nvim)
-- keymaps are in lua/config/mappings.lua, plugins in lua/plugins/<group>/
-- install a patched font & ensure your terminal supports glyphs
-- enjoy :D

-- macOS, Command Line Tools only: xcrun resolves to the highest-numbered SDK
-- installed, and a newer stray SDK (e.g. MacOSX27.0.sdk) declares arm64e.x1-*
-- architectures that the CLT linker rejects, failing every parser build:
--   ld: tapi error: malformed file .../libSystem.B.tbd: unknown architecture
-- Pin to the CLT default SDK in that case only. A full Xcode ships a matching
-- linker and needs no pin -- forcing the older CLT SDK under it would be wrong.
if vim.fn.has("mac") == 1 and not vim.env.SDKROOT then
	local dev = vim.fn.system({ "xcode-select", "-p" })
	if vim.v.shell_error == 0 and dev:match("CommandLineTools") then
		local sdk = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
		if vim.uv.fs_stat(sdk) then vim.env.SDKROOT = sdk end
	end
end

vim.loader.enable() --  SPEEEEEEEEEEED

-- disable netrw so nvim-tree owns directory opening (e.g. `nvim .`)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- order matters: leader is set in mappings, before lazy reads any `keys` spec
require("config.options")
require("config.mappings")
require("config.autocmd")
require("config.theme")
require("config.lazy")

load_theme()
