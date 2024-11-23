# Vim packager

![preview-gif](https://i.imgur.com/KOTn843.gif)

Plugin manager for Vim/Neovim. It's written in pure vimscript and utilizes [jobs](https://neovim.io/doc/user/job_control.html) and [pack](https://neovim.io/doc/user/repeat.html#packages) features.

## Usage

Using `setup` function.

```vim
if &compatible
  set nocompatible
endif

function! s:packager_init(packager) abort
  call a:packager.add('kristijanhusak/vim-packager', { 'type': 'opt' })
  call a:packager.add('junegunn/fzf', { 'do': './install --all && ln -s $(pwd) ~/.fzf'})
  call a:packager.add('junegunn/fzf.vim')
  call a:packager.add('vimwiki/vimwiki', { 'type': 'opt' })
  call a:packager.add('Shougo/deoplete.nvim')
  call a:packager.add('autozimu/LanguageClient-neovim', { 'do': 'bash install.sh' })
  call a:packager.add('morhetz/gruvbox')
  call a:packager.add('lewis6991/gitsigns.nvim', {'requires': 'nvim-lua/plenary.nvim'})
  call a:packager.add('haorenW1025/completion-nvim', {'requires': [
  \ ['nvim-treesitter/completion-treesitter', {'requires': 'nvim-treesitter/nvim-treesitter'}],
  \ {'name': 'steelsojka/completion-buffers', 'opts': {'type': 'opt'}},
  \ 'kristijanhusak/completion-tags',
  \ ]})
  call a:packager.add('hrsh7th/vim-vsnip-integ', {'requires': ['hrsh7th/vim-vsnip'] })
  call a:packager.local('~/my_vim_plugins/my_awesome_plugin')

  "Provide full URL; useful if you want to clone from somewhere else than Github.
  call a:packager.add('https://my.other.public.git/tpope/vim-fugitive.git')

  "Provide SSH-based URL; useful if you have write access to a repository and wish to push to it
  call a:packager.add('git@github.com:mygithubid/myrepo.git')

  "Loaded only for specific filetypes on demand. Requires autocommands below.
  call a:packager.add('kristijanhusak/vim-js-file-import', { 'do': 'npm install', 'type': 'opt' })
  call a:packager.add('fatih/vim-go', { 'do': ':GoInstallBinaries', 'type': 'opt' })
  call a:packager.add('neoclide/coc.nvim', { 'do': function('InstallCoc') })
  call a:packager.add('sonph/onehalf', {'rtp': 'vim/'})
endfunction

packadd vim-packager
call packager#setup(function('s:packager_init'))
```

and run `PackagerInstall` or `PackagerUpdate`. See all available commands [here](#commands)

### Functions

#### packager#setup(callback_function, opts)

This is a small wrapper around functions explained below. It does this:

1. Adds all necessary commands. `PackagerInstall`, `PackagerUpdate`, `PackagerClean` and `PackagerStatus`
2. Running any of the command does this:

- Calls `packager#init(opts)`
- Calls provided `callback_function` with `packager` instance
- Calls proper function for the command

#### `packager#init(options)`

Available options:

- `depth` - `--depth` value to use when cloning. Default: `5`
- `jobs` - Maximum number of jobs that can run at same time. `0` is treated as unlimited. Default: `8`
- `dir` - Directory to use for installation. By default, uses `&packpath` value, which is `~/.vim/pack/packager` in Vim, and `~/.config/nvim/pack/packager` in Neovim.
- `window_cmd` - What command to use to open packager window. Default: `vertical topleft new`
- `default_plugin_type` - Default `type` option for plugins where it's not provided. More info below in `packager#add` options. Default: `start`
- `disable_default_mappings` - Disable all default mappings for packager buffer. Default: `0`

#### `packager#add(name, options)`

`name` - Url to the git directory, or only last part of it to use `github`.

Example: for GitHub repositories, `kristijanhusak/vim-packager` is enough, for something else, like `bitbucket`, use the full path `https://bitbucket.org/owner/package`

Options:

- `name` - Custom name of the plugin. If ommited, last part of url explained above is taken (example: `vim-packager`, in `kristijanhusak/vim-packager`)
- `type` - In which folder to install the plugin. Plugins that are loaded on demand (with `packadd`), goes to `opt` directory, where plugins that are autoloaded goes to `start` folder. Default: `start`
- `branch` - git branch to use. Default: '' (Uses the default from the repository, usually master)
- `tag` - git tag to use. Default: ''
- `rtp` - Used in case when subdirectory contains vim plugin. Creates a symbolink link from subdirectory to the packager folder. If `type` of package is `opt` use `packadd {packagename}__{rtp}` to load it (example: `packadd onehalf__vim`)
- `commit` - exact git commit to use. Default: '' (Check below for priority explanation)
- `do` - Hook to run after plugin is installed/updated: Default: ''. Examples below.
- `frozen` - When plugin is frozen, it is not being updated. Default: 0
- `requires` - Dependencies for the plugin. Can be
  - _string_ (ex. `'kristijanhusak/vim-packager'`)
  - _list_ (ex. `['kristijanhusak/vim-packager', {'type': 'opt'}]`)
  - _dict_ (ex. `{'name': 'kristijanhusak/vim-packager', 'opts': {'type': 'opt'} }`). See example vimrc above.

`branch`, `tag` and `commit` options go in certain priority:

- `commit`
- `tag`
- `branch`

Hooks can be defined in 3 ways:

1. As a string that **doesn't** start with `:`. This runs the command as it is a shell command, in the plugin directory. Example:
   ```vim
   call packager#add('junegunn/fzf', { 'do': './install --all'})
   call packager#add('kristijanhusak/vim-js-file-import', { 'do': 'npm install' })
   ```
2. As a string that starts with `:`. This executes the hook as a vim command. Example:
   ```vim
   call packager#add('fatih/vim-go', { 'do': ':GoInstallBinaries' })
   call packager#add('iamcco/markdown-preview.nvim' , { 'do': ':call mkdp#util#install()' })
   ```
3. As a `funcref` that gets the plugin info as an argument. Example:

   ```vim
   call packager#add('iamcco/markdown-preview.nvim' , { 'do': { -> mkdp#util#install() } })
   call packager#add('junegunn/fzf', { 'do': function('InstallFzf') })

   function! InstallFzf(plugin) abort
     execute a:plugin.dir.'/install.sh --all'
   endfunction
   ```

#### `packager#local(name, options)`

**Note**: This function only creates a symbolic link from provided path to the packager folder

`name` - Full path to the local folder
Example: `~/my_plugins/my_awesome_plugin`

Options:

- `name` - Custom name of the plugin. If ommited, last part of path is taken (example: `my_awesome_plugin`, in `~/my_plugins/my_awesome_plugin`)
- `type` - In which folder to install the plugin. Plugins that are loaded on demand (with `packadd`), goes to `opt` directory,
  where plugins that are autoloaded goes to `start` folder. Default: `start`
- `do` - Hook to run after plugin is installed/updated: Default: ''
- `frozen` - When plugin is frozen, it is not being updated. Default: 0

#### `packager#install(opts)`

This only installs plugins that are not installed

Available options:

- `on_finish` - Run command after installation finishes. For example to quit at the end: `call packager#install({ 'on_finish': 'quitall' })`
- `plugins` - Array of plugin names to install. Example: `call packager#install({'plugins': ['gruvbox', 'gitsigns.nvim']})`

When installation finishes, there are two mappings that can be used:

- `D` - Switches view from installation to status. This prints all plugins, and it's status (Installed, Updated, list of commits that were pulled with latest update)
- `E` - View stdout of the plugin on the current line. If something errored (From installation or post hook), it's printed in the preview window.

#### `packager#update(opts)`

This installs plugins that are not installed, and updates existing one to the latest (If it's not marked as frozen)

Available options:

- `on_finish` - Run command after update finishes. For example to quit at the end: `call packager#update({ 'on_finish': 'quitall' })`
- `force_hooks` - Force running post hooks for each package even if up to date. Useful when some hooks previously failed. Must be non-empty value: `call packager#update({ 'force_hooks': 1 })`
- `plugins` - Array of plugin names to update. Example: `call packager#update({'plugins': ['gruvbox', 'gitsigns.nvim']})`

When update finishes, there are two mappings that can be used:

- `D` - Switches view from installation to status. This prints all plugins, and it's status (Installed, Updated, list of commits that were pulled with latest update)
- `E` - View stdout of the plugin on the current line. If something errored (From installation or post hook), it's printed in the preview window.

#### packager#status()

This shows the status for each plugin added from vimrc.

You can come to this view from Install/Update screens by pressing `D`.

Each plugin can have several states:

- `Not installed` - Plugin directory does not exist. If something failed during the clone process, shows the error message that can be previewed with `E`
- `Install/update failed` - Something went wrong during installation/updating of the plugin. Press `E` on the plugin line to view stdout of the process.
- `Post hook failed` - Something went wrong with post hook. Press `E` on the plugin line to view stdout of the process.
- `OK` - Plugin is properly installed, and it doesn't have any update information.
- `Updated` - Plugin has some information about the last update.

#### packager#clean()

This removes unused plugins. It will ask for confirmation before proceeding. Confirmation allows selecting option to delete all folders from the list (default action), or ask for each folder if you want to delete it.

### Commands

Commands are added only when using `packager#setup` or Lua `require('packager').setup()`

- PackagerInstall - same as [packager#install(`<args>`)](https://github.com/kristijanhusak/vim-packager#packagerinstallopts).
- PackagerUpdate - same as [packager#update(`<args>`)](https://github.com/kristijanhusak/vim-packager#packagerupdateopts). Note that args are passed as they are written. For example, to force running hooks you would do `:PackagerUpdate {'force_hooks': 1}`
- PackagerClean - same as [packager#clean()](https://github.com/kristijanhusak/vim-packager#packagerclean)
- PackagerStatus - same as [packager#status()](https://github.com/kristijanhusak/vim-packager#packagerstatus)

## Configuration

Several buffer mappings are added for packager buffer by default:

- `q` - Close packager buffer (`<Plug>(PackagerQuit)`)
- `<CR>` - Preview commit under cursor (`<Plug>(PackagerOpenSha)`)
- `E` - Preview stdout of the installation process of plugin under cursor (`<Plug>(PackagerOpenStdout)`)
- `<C-j>` - Jump to next plugin (`<Plug>(PackagerGotoNextPlugin)`)
- `<C-k>` - Jump to previous plugin (`<Plug>(PackagerGotoPrevPlugin)`)
- `D` - Go to status page (`<Plug>(PackagerStatus)`)
- `O` - Open details of plugin under cursor (`<Plug>(PackagerPluginDetails)`)

To use different mapping for any of these, create filetype autocmd with different mapping.

For example, to use `<c-h>` instead of `<c-j>` for jumping to next item, add this to vimrc:

```vim
autocmd FileType packager nmap <buffer> <C-h> <Plug>(PackagerGotoNextPlugin)
```
