" Vim plugin for GitHub integration
" Maintainer: Jon Tai <jon.tai@gmail.com>
" License: MIT License

if exists("githublink_loaded")
  finish
endif
let githublink_loaded = 1

if !exists("g:githublink_git_remote")
  let g:githublink_git_remote = "origin"
endif

if !exists("g:githublink_mode")
  " Test to see if pbcopy is available
  silent !which pbcopy
  if !v:shell_error
    let g:githublink_mode = "pbcopy"
  else
    let g:githublink_mode = "echo"
  endif
endif

" Change directories to the directory of the file we're editing, then execute a command
function s:Cd(command)
  let output = system("cd " . shellescape(expand("%:p:h")) . " && " . a:command)
  if v:shell_error
    return ""
  endif
  return output
endfunction

" Get the value of a git config option
function s:GitConfig(name)
  let value = s:Cd("git config " . shellescape(a:name))
  let value = substitute(value, "\n$", "", "")
  return value
endfunction

" Get the name of the current branch we're on
function s:GitBranch()
  let head = s:Cd("git symbolic-ref HEAD")
  let head = substitute(head, "^refs/heads/", "", "")
  let head = substitute(head, "\n$", "", "")
  return head
endfunction

" Get the root directory of the current repository
function s:GitRoot()
  let root = s:Cd("git rev-parse --show-toplevel")
  let root = substitute(root, "\n$", "", "")
  return root
endfunction

" Figure out the base URL on github.com for the current repository
function s:BaseUrl()
  let url = s:GitConfig("remote." . g:githublink_git_remote . ".url")
  let url = substitute(url, "^https://github.com/", "", "")
  let url = substitute(url, "^git@github.com:", "", "")
  let url = substitute(url, "\.git$", "", "")
  return "https://github.com/" . url
endfunction

" Called when key binding is activated
function s:Main()
  let path = expand("%:p")
  if empty(path)
    echohl Error | echo "No file name" | echohl Normal
    return
  endif

  let root = s:GitRoot()
  if empty(root)
    echohl Error | echo "Not a git repository" | echohl Normal
    return
  endif

  let url = s:BaseUrl() . "/blob/" . s:GitBranch() . substitute(path, "^" . root, "", "") . "#L" . line(".")
  if g:githublink_mode == "pbcopy"
    " Copy URL to clipboard with pbcopy and echo a status message
    call system("pbcopy", url)
    echo "\"" . url . "\" copied to clipboard"
  elseif g:githublink_mode == "echo"
    echo url
  else
    echohl Error | echo "g:githublink_mode not set" | echohl Normal
  endif
endfunction

" Type backslash g in command mode to display the github.com URL of the current line
if !hasmapto("<Plug>GitHubLink")
  map <unique> <Leader>g <Plug>GitHubLink
endif

noremap <unique> <script> <Plug>GitHubLink <SID>GitHubLink
noremap <SID>GitHubLink :call <SID>Main()<CR>

