" =============================================================================
" 1. CORE VIM SETTINGS
" =============================================================================
syntax on
filetype plugin indent on
set encoding=utf-8
set mouse=a
set ttyfast
set laststatus=2
set belloff=all
set backspace=indent,eol,start

" --- Tabs & Indentation ---
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set scrolloff=4

" --- UI & Search ---
set number
set cursorline
set showcmd
set showmode
set showmatch
set incsearch
set hlsearch
set wildmenu
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

" --- Folding ---
set foldenable
set foldlevelstart=10
set foldmethod=indent

" --- Viminfo (remember recent files for auto-open) ---
set viminfo='200,<50,s10,h

" --- Persistent Undo ---
if has('persistent_undo')
    let target_path = expand('~/.config/vim-persisted-undo/')
    if !isdirectory(target_path) | call system('mkdir -p ' . target_path) | endif
    let &undodir = target_path
    set undofile
endif

" --- Auto-Commands ---
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Open the most recently opened file in cwd when vim starts with no arguments
function! OpenLastFileInCwd()
  if argc() > 0 || exists("s:std_in")
    return
  endif
  let l:cwd = resolve(expand(getcwd())) . '/'
  for f in v:oldfiles
    " Skip NERDTree buffers
    if f =~# 'NERD_tree' | continue | endif
    " Expand ~ and resolve symlinks
    let l:fullpath = resolve(expand(f))
    if stridx(l:fullpath, l:cwd) == 0 && filereadable(l:fullpath)
      execute 'edit' fnameescape(l:fullpath)
      return
    endif
  endfor
endfunction
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * nested call OpenLastFileInCwd()
" Note: vim-sleuth auto-detects indentation per file, so explicit
" filetype rules for Python/Go are not needed.

" =============================================================================
" 2. PLUGIN MANAGEMENT
" =============================================================================
call plug#begin()

" Intelligence & AI
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'github/copilot.vim'

" Navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'liuchengxu/vim-which-key'

" UI
Plug 'sainnhe/everforest'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'jeetsukumaran/vim-markology'

" Tools
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-sleuth'
" Syntastic removed — CoC provides diagnostics via language servers
Plug 'kamykn/spelunker.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown']}

call plug#end()

" =============================================================================
" 3. PLUGIN CONFIG
" =============================================================================
if has('termguicolors') | set termguicolors | endif
set background=dark
let g:everforest_background = 'soft'
colorscheme everforest
let g:airline_theme = 'everforest'

" --- CoC Completion Settings ---
set shortmess+=c
set updatetime=300

" Tab: navigate completion menu or trigger completion; Shift-Tab: navigate back
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Enter: confirm completion or normal newline
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Ctrl+Space: manually trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Trigger completion after typing '.' (for method/field access)
inoremap <silent> . .<C-\><C-o>:silent call coc#refresh()<CR>

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Jump to definition
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" =============================================================================
" 4. KEYBINDINGS & WHICH-KEY (The Full Map)
" =============================================================================
let mapleader = "\<Space>"

" --- Manual Mappings ---
" Clear search highlights
nnoremap <leader><space> :nohlsearch<CR>
" Reload vimrc
nnoremap <leader>vc :source $MYVIMRC<CR>:echo "Config Reloaded!"<CR>
" Smart NERDTree toggle: close if open, otherwise open & highlight current file
function! NERDTreeSmartToggle()
  if exists("g:NERDTree") && g:NERDTree.IsOpen()
    NERDTreeClose
  elseif expand('%') ==# '' || !filereadable(expand('%'))
    NERDTreeToggle
  else
    NERDTreeFind
  endif
endfunction
nnoremap <leader>nt :call NERDTreeSmartToggle()<CR>
" Find current file in NERDTree
nnoremap <leader>nf :NERDTreeFind<CR>
" Auto-indent entire file
nnoremap <leader>= m'gg=G`'
" Append semicolon at end of line
nnoremap <leader>; m'A;<ESC>`'

" Copilot Insert Mode
imap <silent><script><expr> <C-j> copilot#Accept("\<CR>")
imap <C-l> <Plug>(copilot-accept-word)
imap <C-f> <Plug>(copilot-next)
imap <C-b> <Plug>(copilot-previous)

" Use Ctrl+n to toggle NERDTree (N = NERDTree)
nnoremap <C-n> :call NERDTreeSmartToggle()<CR>
" Use Ctrl+p to find files (FZF)
nnoremap <C-p> :Files<CR>
" Use Ctrl+s to search for text inside files (Interactive Ripgrep)
" Note: requires 'stty -ixon' in your shell rc to prevent terminal flow control from intercepting Ctrl+S
nnoremap <C-s> :Rg<CR>
" Use Ctrl+b to list open buffers (quick switching)
nnoremap <C-b> :Buffers<CR>
" Use Ctrl+e to edit vimrc quickly
nnoremap <C-e> :edit $MYVIMRC<CR>
" Use Ctrl+q to close current buffer (quick cleanup)
nnoremap <C-q> :bd<CR>
" Use Ctrl+g to run lazygit (overrides Vim's file-info command)
nnoremap <C-g> :!lazygit<CR>

" --- Which-Key Setup ---
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
let g:which_key_map = {}

" f: Files
let g:which_key_map.f = {
      \ 'name' : '+file',
      \ 'f' : [':Files', 'find files'],
      \ 'r' : [':Rg', 'ripgrep text'],
      \ 'e' : [':edit $MYVIMRC', 'edit vimrc'],
      \ }

" b: Buffers
let g:which_key_map.b = {
      \ 'name' : '+buffer',
      \ 'n' : [':bnext', 'next buffer'],
      \ 'p' : [':bprevious', 'previous buffer'],
      \ 'd' : [':bd', 'delete buffer'],
      \ 'l' : [':ls', 'list buffers'],
      \ }

" w: Windows
let g:which_key_map.w = {
      \ 'name' : '+windows',
      \ 'w' : ['<C-W>w', 'other-window'],
      \ 'd' : ['<C-W>c', 'delete-window'],
      \ '-' : ['<C-W>s', 'split-below'],
      \ '|' : ['<C-W>v', 'split-right'],
      \ 'h' : ['<C-W>h', 'window-left'],
      \ 'j' : ['<C-W>j', 'window-below'],
      \ 'k' : ['<C-W>k', 'window-up'],
      \ 'l' : ['<C-W>l', 'window-right'],
      \ '=' : ['<C-W>=', 'balance-window'],
      \ }

" t: Tabs
let g:which_key_map.t = {
      \ 'name' : '+tab',
      \ 'n' : [':tabnew', 'new tab'],
      \ 'c' : [':tabclose', 'close tab'],
      \ 'l' : [':tabnext', 'next tab'],
      \ 'h' : [':tabprevious', 'previous tab'],
      \ }

" g: Git
let g:which_key_map.g = {
      \ 'name' : '+git',
      \ 's' : [':Git', 'status'],
      \ 'd' : [':Gdiffsplit', 'diff'],
      \ 'b' : [':Git blame', 'blame'],
      \ 'c' : [':Git commit', 'commit'],
      \ 'p' : [':Git push', 'push'],
      \ }

" a: AI (Copilot)
let g:which_key_map.a = {
      \ 'name' : '+ai-copilot',
      \ 's' : [':Copilot status', 'status'],
      \ 'p' : [':Copilot panel', 'open panel'],
      \ 'd' : [':Copilot disable', 'disable'],
      \ 'e' : [':Copilot enable', 'enable'],
      \ }

" m: Marks
let g:which_key_map.m = {
      \ 'name' : '+marks',
      \ 'l' : [':marks', 'list marks'],
      \ 'd' : [":delmarks!<CR>", 'delete all marks'],
      \ }

" c: Code Actions (Coc)
let g:which_key_map.c = {
      \ 'name' : '+lsp-diagnostics',
      \ 'n' : ['<Plug>(coc-diagnostic-next)', 'next error'],
      \ 'p' : ['<Plug>(coc-diagnostic-prev)', 'prev error'],
      \ 'i' : [':CocInfo', 'lsp info'],
      \ 'f' : ['<Plug>(coc-fix-current)', 'quick-fix'],
      \ }

call which_key#register('<Space>', "g:which_key_map")
