if $SHELL =~ 'fish'
  set shell=/bin/sh
endif

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

set t_Co=256
set encoding=utf8
set ambiwidth=double
colorscheme desert
set background=dark
set laststatus=2
set number
set shiftwidth=2
set smarttab
set tabstop=2
set smartindent
set expandtab
set showmatch
set matchtime=2
set display=lastline
set tags=./tags,tags

set directory=~/tmp/vimswap/
set backupdir=~/tmp/vimbackup/

" 検索時のハイライト
set hlsearch
" esc2回で消える
nnoremap <ESC><ESC> :nohlsearch<CR>

" タブページ
" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

"--------------------------------------------------------------------------
" .md .mdwn などをfiletype markdownとして
augroup PrevimSettings
  autocmd!
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END

"--------------------------------------------------------------------------
" neobundle
set nocompatible               " Be iMproved
filetype off                   " Required!

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle/'))

filetype plugin indent on     " Required!

" Installation check.
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Please execute ":NeoBundleInstall" command.'
  "finish
endif

" vim plugins with neo bundle
NeoBundle 'mfontani/vim-gitrebase-mappings'
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'Shougo/neocomplcache.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'bling/vim-airline'
NeoBundle 'Lokaltog/powerline'
NeoBundle 'https://github.com/vim-scripts/yanktmp.vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'rking/ag.vim'
NeoBundle 'itchyny/calendar.vim'
NeoBundle 'taichouchou2/alpaca_powertabline'
NeoBundle 'vim-scripts/AnsiEsc.vim'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'tpope/vim-markdown'
NeoBundle 'kannokanno/previm'

au BufRead,BufNewFile *.md set filetype=markdown


" vim plugins
"-------------------------------------------------------------------------
" ctrlp
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_use_migemo = 1 "migemo patter for japanese
let g:ctrlp_clear_cache_on_exit = 0   " 終了時キャッシュをクリアしない
let g:ctrlp_cache_dir = '~/tmp/ctrlp/'
set wildignore+=*/tmp/*,*/log/*,*.so,*.swp,*.zip

" neocomplecache
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" syntastic
let g:syntastic_mode_map = { 'mode': 'active',
  \ 'active_filetypes': ['php', 'ruby', 'html', 'javascript'] }
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=2
let g:syntastic_ruby_checkers = ['rubocop']
let g:syntastic_javascript_checkers=['jshint']
syntax on

" airline
let g:airline_theme="bubblegum"
let g:airline_powerline_fonts=1
let g:airline#extensions#whitespace#symbol='(´つヮ⊂)ｳｫｫw'
let g:airline_readonly_symbol='( ˘ω˘)ｽﾔｧ'

" yanktmp
let g:yanktmp_file = '~/tmp/yanktmp_file'
map <silent> Ty :call YanktmpYank()<CR>
map <silent> Tp :call YanktmpPaste_p()<CR>
map <silent> TP :call YanktmpPaste_P()<CR>

" nerdtree
nmap <silent> <C-e>      :NERDTreeToggle<CR>
vmap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
omap <silent> <C-e>      :NERDTreeToggle<CR>
imap <silent> <C-e> <Esc>:NERDTreeToggle<CR>
cmap <silent> <C-e> <C-u>:NERDTreeToggle<CR>
autocmd vimenter * if !argc() | NERDTree | endif
let g:NERDTreeIgnore=['\.clean$', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowHidden=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeDirArrows=0

" calendar↲
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1
let g:calendar_updatetime = 1000

" vim-indent-guides
let g:indent_guides_auto_colors=0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd   ctermbg=245
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven  ctermbg=240
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=2

" previm
let g:previm_open_cmd="open -a 'google chrome'"

call neobundle#end()

NeoBundleCheck
