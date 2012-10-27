# githublink.vim

This vim plugin allows you to type `\ g` in command mode to display the github.com URL of the current line.

If [pbcopy](http://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man1/pbcopy.1.html) is available, the URL will also be copied to the clipboard.

## Installation

### Option 1: Manual installation

1.  Clone the repository.

        $ git clone https://github.com/jtai/vim-githublink.git

2.  Move `githublink.vim` to your `.vim/plugins` directory.

        $ cd vim-githublink/plugins
        $ mv githublink.vim ~/.vim/plugins/

### Option 2: Pathogen installation ***(recommended)***

1.  Download and install Tim Pope's [Pathogen](https://github.com/tpope/vim-pathogen).

2.  Clone the repository in the pathogen plugins directory.

        $ cd ~/.vim/bundle
        $ git clone https://github.com/jtai/vim-githublink.git
