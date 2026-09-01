local logo = [[
|
|
|     ▗▄                                                       |
|      █▖                                                      |
|      ▐▙                                                      |
|      ▝█                                                      |
|       █▌                                                     |
|       ▜▌                                                     |
|       ▐▌                                                     |
|      ▄▄▄▄▄▄▄▄▄▄▄▄▄▄                                          |
|    ▟▛▀           ▀▀▀█▄       ▄                               |
|    ▜▙▄▟▙            ▗▟█▄▄▟▛▀▀▘            ██▌                |
|      ▀█▛▀▀▀▀▀▀▀▀▀▀▀▀▀▀▝█        ▄▄▖    ▄▄▖▄▄▖ ▄▄ ▄▄▄  ▗▄▄▄   |
|       █▘               █▌       ▝██▖  ▗█▛ ██▌ ██▛▀▀▜█▟▛▀▀██▖ |
|      ▐█               ▗█         ▐█▙ ▗██▘ ██▌ ██▌  ▐██   ██▌ |
|  ▄█▀▜█▙▖             ▗█▘          ▜█▌▟█▘  ██▌ ██▌  ▐██   ██▌ |
| ▐█  ▗▛ ▀▀▜▄▄▄▄    ▄▄█▀             ▜██▌   ██▌ ██▌  ▐██   ██▌ |
|  ▀▀▀▀       ▝▀▀▀ ▝▀                 ▀▀    ▀▀▘ ▀▀▘  ▝▀▀   ▀▀▘ |
|
|
]]

local header = vim.split(logo, "\n")
for i, line in ipairs(header) do
  header[i] = string.sub(line, (string.find(line, "|") or 0) + 1, #line - 1)
end

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
  {
    "snacks.nvim",
    opts = {
      dashboard = { preset = { header = table.concat(header, "\n") } },
      picker = {
        sources = {
          files = {
            hidden = true,
          },
          grep = {
            hidden = true,
          },
          explorer = {
            auto_close = true,
            layout = {
              layout = { position = "right" },
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>G",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git Status Files",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        css = { "prettier" },
        jinja = { "prettier" },
        python = { "isort", "black" },
        yaml = { "prettier" },
        toml = { "taplo" },
        astro = { "prettier" },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      highlight = {
        -- Pattern to match TODO (<author>):
        pattern = [[.*<((KEYWORDS)\s*(\(.+\))?):]],
      },
      search = {
        pattern = [[\b(KEYWORDS)\b]],
      },
    },
  },
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = {
          enabled = false,
        },
      },
    },
    keys = {
      { "<c-Space>", mode = { "n", "o", "x" }, false },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "<c-k>", mode = { "i" }, false },
          },
        },
        verible = {},
        yamlls = {
          before_init = function(_, new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas({
                replace = {
                  -- stock fileMatch globs treat every yaml file under any "playbooks/"
                  -- dir as a playbook: yamlls compiles "*" to match across path
                  -- separators, so "**/playbooks/*.yaml" also catches
                  -- playbooks/roles/*/tasks/*.yaml. Drop those globs; use a
                  -- `# yaml-language-server: $schema=...` modeline in playbook files
                  -- that aren't named site.yaml/playbook.yaml instead.
                  ["Ansible Playbook"] = {
                    name = "Ansible Playbook",
                    description = "Ansible playbook files",
                    fileMatch = { "playbook.yml", "playbook.yaml", "site.yml", "site.yaml" },
                    url = "https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook",
                  },
                },
              })
            )
          end,
        },
      },
      inlay_hints = { enabled = false },
    },
  },
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        "yamlfmt",
        "yamllint",
        "prettier",
        "basedpyright",
        "verible",
        "vtsls",
      },
    },
  },
  {
    "tigion/nvim-asciidoc-preview",
    ft = { "asciidoc" },
    build = "cd server && npm install --omit=dev --no-save",
    opts = {},
  },
}
