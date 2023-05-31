call plug#begin()
	" Nimda
	Plug 'ozkanonur-backups/nimda.vim'

	" Multi Cursor
	Plug 'mg979/vim-visual-multi', {'branch': 'master'}

	" Indent Guides
	Plug 'nathanaelkane/vim-indent-guides'

	" Golang Format
	Plug 'darrikonn/vim-gofmt', { 'do': ':GoUpdateBinaries' }
	
	" Mason.nvim
	Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }

	" Telescope
	Plug 'ozkanonur-backups/plenary.nvim'
	Plug 'ozkanonur-backups/telescope.nvim'

	" Svelte
	Plug 'leafOfTree/vim-svelte-plugin'
	
	" Nvim Tree
	Plug 'ozkanonur-backups/nvim-tree.lua'

	" Vim Search
	Plug 'ozkanonur-backups/vim-esearch'

	" Nvim LspConfig
	Plug 'ozkanonur-backups/nvim-lspconfig'

	" Nvim Cmp
	Plug 'ozkanonur-backups/nvim-cmp'
	Plug 'ozkanonur-backups/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-vsnip' 
	Plug 'hrsh7th/vim-vsnip'

	" Treesitter
	Plug 'ozkanonur-backups/nvim-treesitter', {'do': ':TSUpdate'}

	" Lualine
	Plug 'ozkanonur-backups/lualine.nvim'
call plug#end()

" Mappings {
	" Back to previously opened window
	nnoremap <S-h> <C-6> <CR>
	" Open file explorer
	nnoremap <silent> ` :NvimTreeToggle <CR>
	" File search
	nnoremap <silent> <space>` :Telescope find_files <CR>
	" Display git status
	nnoremap <BS> :Telescope git_status <CR>
	" Grep for string that is under the cursor
	nnoremap <C-n> :Telescope grep_string <CR>
	" Grep in whole workspace
	nnoremap <C-f> :Telescope live_grep <CR>
	" Lists git commits with diff preview, checkout action <cr>, reset mixed <C-r>m, reset soft <C-r>s and reset hard <C-r>h
	nnoremap <C-g> :Telescope git_commits <CR>
	" Copy to clipboard
	vnoremap  <space>y  "+y

	" Format golang code
	nnoremap <silent> <space>g :GoFmt<CR>

	" Open mason
	nnoremap <silent> <space>m :Mason<CR>

	" Open terminal
	noremap <silent> <space>h :term<CR>

	" Switch Panes
	nnoremap <silent> <A-k> :wincmd k<CR>
	nnoremap <silent> <A-j> :wincmd j<CR>
	nnoremap <silent> <A-h> :wincmd h<CR>
	nnoremap <silent> <A-l> :wincmd l<CR>
	
	" Window sizing
	noremap <silent> <A-Left> :vertical resize +3<CR>
	noremap <silent> <A-Right> :vertical resize -3<CR>
	noremap <silent> <A-Up> :resize +3<CR>
	noremap <silent> <A-Down> :resize -3<CR>

	" move lines
	nnoremap <C-j> :m .+1<CR>==
	nnoremap <C-k> :m .-2<CR>==
	vnoremap <C-j> :m '>+1<CR>gv=gv
	vnoremap <C-k> :m '<-2<CR>gv=gv

	" Switch tabs easier
	for i in range(1, 12)
	  execute "nmap ".i."T ".i."gt"
	endfor
" Mappings }

" vim-illuminate {
	augroup illuminate_augroup
		autocmd!
		autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline
	augroup END
" vim-ulluminate }

" open terminal automatically in insert mode
autocmd TermOpen * startinsert

" autoclose-terminal
  augroup terminal_settings
    autocmd!

    autocmd BufWinEnter,WinEnter term://* startinsert
    autocmd BufLeave term://* stopinsert

    " Ignore various filetypes as those will close terminal automatically
    " Ignore fzf, ranger, coc
    autocmd TermClose term://*
          \ if (expand('<afile>') !~ "fzf") && (expand('<afile>') !~ "ranger") && (expand('<afile>') !~ "coc") |
          \   call nvim_input('<CR>')  |
          \ endif
  augroup END

" Settings {
	set termguicolors
	colorscheme tokyonight-moon

	set showtabline=2
	set tabline=%!DisplayTabId()

	set shortmess-=S

	hi! Normal ctermbg=NONE guibg=NONE
	hi! NonText ctermbg=NONE guibg=NONE

	silent verbose setlocal omnifunc

	filetype indent plugin on
	if !exists('g:syntax_on') | syntax enable | endif
	set encoding=utf-8
	scriptencoding utf-8

	set number relativenumber

	" Highlight extra white spaces
	match Error /\s\+$/
	autocmd BufWinEnter * match Error /\s\+$/
	autocmd BufWinLeave * call clearmatches()

	set backspace=indent,eol,start
	set autoindent noexpandtab tabstop=4 shiftwidth=4
	set textwidth=80
	set title

	set hidden
	set nofixendofline
	set nostartofline
	set splitbelow
	set splitright

	set hlsearch
	set incsearch
	set laststatus=2
	set noruler
	set noshowmode
	set signcolumn=yes

	set mouse=a
	set updatetime=1000

	set ttyfast
	set lazyredraw

	" Set completeopt to have a better completion experience
	set completeopt=menuone,noinsert,noselect

	let g:loaded_python3_provider = 1
	let g:loaded_node_provider = 0
	let g:loaded_perl_provider = 0
	let g:loaded_ruby_provider = 0

	let g:indent_guides_enable_on_vim_startup = 1

	let g:esearch = {}
	" Set the root as current working directory as default for esearch plugin
	let g:esearch.root_markers = []
" Settings }

" Functions }
	function! DisplayTabId()
		let s = ''
		for i in range(tabpagenr('$'))
			let tab = i + 1
			let winnr = tabpagewinnr(tab)
			let buflist = tabpagebuflist(tab)
			let bufnr = buflist[winnr - 1]
			let bufname = bufname(bufnr)
			let bufmodified = getbufvar(bufnr, "&mod")

			let s .= '%' . tab . 'T'
			let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
			let s .= ' [' . tab .'] '
			let s .= (bufname != '' ?  fnamemodify(bufname, ':t') . ' ' : '[No Name] ')
			if bufmodified
				let s .= '• '
			endif
		endfor

		let s .= '%#TabLineFill#'
		if (exists("g:tablineclosebutton"))
			let s .= '%=%999XX'
		endif
		return s
	endfunction
" Functions }

lua require('./cfg_lualine')
lua require('./cfg_nvimtree')
lua require('./cfg_lsp')
lua require('./cfg_treesitter')
lua require('./plugins')
lua require('mason').setup()
