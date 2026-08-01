-- Helper: cari directory aktif (Oil-aware, fallback ke file dir, lalu getcwd)
local function shell_dir()
  local ok, oil = pcall(require, "oil")
  if ok then
    local dir = oil.get_current_dir()
    if dir then return dir end
  end
  local file = vim.fn.expand("%:p:h")
  if file and file ~= "" then return file end
  return vim.fn.getcwd()
end

local _shell_win -- track shell window biar yang lama ketutup

-- Shell command: prompt, jalankan streaming di terminal window (10 baris)
vim.keymap.set("n", "<leader>s", function()
  local cmd = vim.fn.input("Shell: ")
  if cmd == "" then return end

  -- Tutup shell window sebelumnya kalau masih ada (job-nya ikut mati)
  if _shell_win and vim.api.nvim_win_is_valid(_shell_win) then
    vim.api.nvim_win_close(_shell_win, true)
  end

  local dir = shell_dir()
  local full_cmd = "cd " .. vim.fn.shellescape(dir) .. " && " .. cmd

  -- Buka window di bawah, langsung streaming
  vim.cmd("belowright 10new")

  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  _shell_win = win

  vim.bo[buf].bufhidden = "wipe"

  -- Statusline: -- SHELL -- {command} @ {dir}
  local display = dir:match("[^/]+$") or dir
  vim.wo[win].statusline = "%#ModeMsg#-- SHELL --%* " .. cmd .. "  (" .. display .. ")"

  -- q → tutup
  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, nowait = true, silent = true })

  -- Refresh oil buffers (biar hasil git clone dll langsung muncul)
  local function refresh_oil()
    pcall(function()
      for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
          local b = vim.api.nvim_win_get_buf(w)
          if vim.bo[b].filetype == "oil" then
            vim.api.nvim_win_call(w, function()
              vim.cmd.edit({ bang = true })
            end)
          end
        end
      end
    end)
  end

  -- Jalankan streaming
  local job = vim.fn.termopen(full_cmd, {
    on_exit = function(_, code)
      refresh_oil()
      if vim.api.nvim_win_is_valid(win) then
        vim.wo[win].statusline =
          "%#ModeMsg#-- SHELL --%* " .. cmd .. "  (" .. display .. ")  [exit " .. code .. "]"
      end
    end,
  })

  if job == 0 then
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_err_writeln("Shell gagal dijalankan: " .. full_cmd)
  end
end, { desc = "Shell command (streaming below)" })

-- Exit terminal mode (ganti <C-\><C-n> yang ribet)
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Save file
vim.keymap.set({ "n", "i" }, "<A-s>", "<cmd>w<CR>", { desc = "Save file" })

-- LSP: navigasi
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })

-- Tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "New tab" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "Close tab" })
vim.keymap.set("n", "<leader>t]", "<cmd>tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "<leader>t[", "<cmd>tabprevious<CR>", { desc = "Previous tab" })

-- Quit
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })
