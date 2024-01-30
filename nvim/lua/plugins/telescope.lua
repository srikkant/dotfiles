return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  keys = {
      { 
        "<leader>b", 
        function() 
          require("telescope.builtin").buffers() 
        end, 
        { 
          desc = 'List [b]uffers' 
        }
      },
      { 
        "<leader>f", 
        function() 
          require("telescope.builtin").find_files() 
        end, 
        { 
          desc = 'List [f]iles' 
        }
      },
      { 
        "<leader>'", 
        function() 
          require("telescope.builtin").resume() 
        end, 
        { 
          desc = 'Reopen last picker' 
        }
      }
  }
}
