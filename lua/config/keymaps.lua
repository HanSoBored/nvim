vim.keymap.set("n", "<leader>t", "<cmd>belowright terminal<CR>", {
	desc = "Open terminal below",
})

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

-- Shell command: prompt, capture output, tampilkan di window dinamis (max 10 baris)
vim.keymap.set("n", "<leader>s", function()
  local cmd = vim.fn.input("Shell: ")
  if cmd == "" then return end

  -- Tutup shell window sebelumnya kalau masih ada
  if _shell_win and vim.api.nvim_win_is_valid(_shell_win) then
    vim.api.nvim_win_close(_shell_win, true)
  end

  local dir = shell_dir()
  local full_cmd = "cd " .. vim.fn.shellescape(dir) .. " && " .. cmd

  -- Capture output
  local output = vim.fn.system(full_cmd)
  if vim.v.shell_error ~= 0 then
    output = output .. "\n[Exit code: " .. vim.v.shell_error .. "]"
  end

  -- Refresh oil buffers (biar hasil git clone dll langsung muncul)
  pcall(function()
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "oil" then
          vim.api.nvim_win_call(win, function()
            vim.cmd.edit({ bang = true })
          end)
        end
      end
    end
  end)

  -- Split & hitung baris
  local lines = vim.split(output, "\n", { plain = true })
  if #lines > 0 and lines[#lines] == "" then
    table.remove(lines)
  end
  local nlines = math.max(#lines, 1)
  local max_height = 10
  local height = math.min(nlines, max_height)

  -- Buka window di bawah
  vim.cmd("belowright " .. height .. "new")

  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  _shell_win = win

  -- Config buffer
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].modifiable = true

  -- Isi output
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  -- Statusline: -- SHELL -- {command} @ {dir}
  local display = dir:match("[^/]+$") or dir
  vim.wo[win].statusline = "%#ModeMsg#-- SHELL --%* " .. cmd .. "  (" .. display .. ")"

  -- q → tutup
  vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, nowait = true, silent = true })
end, { desc = "Shell command (output below)" })

-- Exit terminal mode (ganti <C-\><C-n> yang ribet)
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Save file
vim.keymap.set({ "n", "i" }, "<A-s>", "<cmd>w<CR>", { desc = "Save file" })

-- LSP: navigasi
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
