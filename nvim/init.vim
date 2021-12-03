syntax on
filetype plugin indent on
filetype on
filetype indent on
au BufWrite * :Neoformat

" Sets
set relativenumber
set nu
set autoindent
set nohlsearch
set hidden
set noerrorbells
set nowrap
set noswapfile
set incsearch
set scrolloff=8
set signcolumn=yes
set cursorline
set splitright
set smartindent
set clipboard=unnamedplus

" Leader
let mapleader=' '

" identation
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType eruby setlocal expandtab shiftwidth=2 tabstop=2

" Plugins
call plug#begin()
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'scrooloose/nerdtree'
Plug 'morhetz/gruvbox'
Plug 'jdsimcoe/abstract.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'sbdchd/neoformat'
Plug 'nvim-telescope/telescope.nvim'
Plug 'tpope/vim-commentary'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-endwise'
Plug 'andrewradev/splitjoin.vim'
Plug 'andrewradev/switch.vim'
Plug 'cocopon/pgmnt.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'arzg/vim-colors-xcode'
Plug 'vim-test/vim-test'
Plug 'nvim-lua/completion-nvim'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
Plug 'cseelus/vim-colors-lucid'
call plug#end()

" Useful remaps
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ? ?<c-g>u
inoremap ! !<c-g>u
" Airline config
let g:airline_section_x=''
let g:airline_section_z=''
let g:airline_section_y=''
" Telescope
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <C-f> <cmd>Telescope live_grep<cr>
nnoremap <C-b> <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Nerdtree
nnoremap <silent> <expr> <Leader>n g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"

" " Git
nnoremap <Leader>gs :G <CR>
nnoremap <Leader>gc :Git commit -v<CR>
nnoremap <Leader>gb :Git branch<CR>
nnoremap <Leader>gca :Git commit --amend -v<CR>
nnoremap <Leader>gw :Gwrite<CR>
nnoremap <Leader>gp :Git push<CR>
nnoremap <Leader>gfp :Git push -f<CR>
nnoremap <Leader>gu :Git pull<CR>
nnoremap <Leader>gd :Gvdiff<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>

" Navigation
map <C-J> <C-^> <CR>
" Theme
colorscheme abstract
set termguicolors
hi Visual  ctermbg=236 guibg=#1c1c1c gui=none
hi CursorLine ctermbg=236 cterm=NONE guifg=none guibg=#1c1c1c gui=NONE


inoremap <silent><expr> <TAB>
			\ pumvisible() ? coc#_select_confirm() :
			\ coc#expandableOrJumpable() ?
			\ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ coc#refresh()

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'
let g:coc_global_extensions = ['coc-solargraph']
nmap <F2> <Plug>(coc-rename)

" Formatter
let g:formatters_ruby = ['rubocop']

" RSpec
let test#strategy = {
			\ 'nearest': 'neovim',
			\ 'file':    'basic',
			\ 'suite':   'basic',
			\}
if has('nvim')
	tmap <C-o> <C-\><C-n>
endif
map <Leader>rt :TestNearest<CR>
map <Leader>rtt :TestFile<CR>
map <Leader>rl :TestLast<CR>
map <Leader>ra :TestSuite<CR>
lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

--Enable completion triggered by <c-x><c-o>
buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

-- Mappings.
local opts = { noremap=true, silent=true }

-- See `:help vim.lsp.*` for documentation on any of the below functions
buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end
require('telescope').setup{
defaults = {
	-- ...
	},
pickers = {
	find_files = {
		theme = "ivy",
		},
	live_grep = {
		theme = "ivy",
		},
	buffers = {
		theme = "ivy",
		}
	},
extensions = {
	-- ...
	}
}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "solargraph" }
for _, lsp in ipairs(servers) do
	nvim_lsp[lsp].setup {
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 150,
			}
		}
end
EOF
