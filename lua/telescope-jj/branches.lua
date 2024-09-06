local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local make_entry = require("telescope.make_entry")
local utils = require("telescope-jj.utils")

local branches = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or utils.get_jj_root()
  if opts.cwd == nil then
    return
  end

  local cmd = { "jj", "branch", "list", "-T", "self.name() ++ '\n'" }

  pickers
      .new(opts, {
        prompt_title = "Jujutsu Branches",
        --__locations_input = true,
        finder = finders.new_table({
          results = utils.get_os_command_output(cmd, opts.cwd),
          entry_maker = function(entry)
            return make_entry.set_default_entry_mt({
              value = entry,
              display = entry,
              ordinal = entry,
            }, opts)
          end,
        }),
        --previewer = conf.file_previewer(opts),
        sorter = conf.file_sorter(opts),
        attach_mappings = function()
          actions.select_default:replace(function(prompt_bufnr)
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            local cmd = { "jj", "new", selection.value }
            utils.get_os_command_output(cmd, opts.cwd)
          end)
          return true
        end,
      })
      :find()
end

branches()
