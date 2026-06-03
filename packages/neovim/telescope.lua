local telescope = require('telescope')
local actions = require('telescope.actions')

local builtin = require('telescope.builtin')

builtin.lsp_document_methods = function ()
    builtin.lsp_document_symbols({
            prompt_title = 'LSP Document Methods',
            symbols = { 'method' },
            symbol_width = 25,
            symbol_type_width = 0,
            show_line = true,
        })

end

builtin.laravel_picker = function ()
  builtin.find_files({
    prompt_title = 'Laravel Vendor Files',
    no_ignore = true,
    hidden = true,
    search_dirs = { 'vendor/laravel' },
  })
end

local custom_actions = {}
custom_actions.select_file_and_accept_method = function (prompt_bufnr)
  require('telescope.actions').select_default(prompt_bufnr)
  builtin.lsp_document_methods()
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")

local function open_fuzzy_from_picker(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)

  local results = {}
  for entry in picker.manager:iter() do
    table.insert(results, entry)
  end

  actions.close(prompt_bufnr)

  pickers.new({}, {
    prompt_title = "Live Grep Refinement",
    finder = finders.new_table({
      results = results,
      entry_maker = function(entry)
        return entry
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = conf.grep_previewer({}),
  }):find()
end

telescope.setup {
    defaults = {
        prompt_prefix = '  ',
        sorting_strategy = "ascending",
        layout_config = {
            prompt_position = "top",
        },
        mappings = {
            i = {
                ['<C-a>'] = actions.toggle_all,
                ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
                ["<C-/>"] = open_fuzzy_from_picker,
            },
            n = {
                ["<C-/>"] = open_fuzzy_from_picker,
            },
        },
        file_ignore_patterns = { 'node_modules', '.DS_Store', 'resources/dist', '.git/', 'storage/framework' },
        cache_picker = {
            num_pickers = -1,
        },
    },
    pickers = {
        find_files = {
            prompt_title = 'All Files',
            no_ignore = true,
            hidden = true,
        },
        git_files = {
            show_untracked = true,
            mappings = {
                i = {
                    ["@"] = custom_actions.select_file_and_accept_method,
                }
            }
        },
        current_buffer_fuzzy_find = {
            prompt_title = 'Current Buffer Lines',
        },
        oldfiles = {
            prompt_title = 'History',
        },
        buffers = {
            mappings = {
                i = {
                    ["@"] = custom_actions.select_file_and_accept_method,
                    ["<C-x>"] = "delete_buffer",
                }
            }
        },
    },
    extensions = {
        live_grep_args = {
            prompt_title = 'Live Ripgrep',
            mappings = {
                i = {
                    ["''"] = require('telescope-live-grep-args.actions').quote_prompt(),
                }
            }
        }
    },
}

telescope.load_extension('fzf')
telescope.load_extension('live_grep_args')
telescope.load_extension('ui-select')
