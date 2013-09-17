I'm still mostly an emacs guy, but I've been using vim more and more as I pair
with different people at [Gaslight](http://gaslight.co).

## Installation:

Prerequisites: ruby, git.

1. Move your existing configuration somewhere else:  
   `mv ~/.vim* ~/.gvim* my_backup`
2. Clone this repo into ".vim":  
   `git clone https://github.com/mguterl/vimfiles ~/.vim`
3. Go into ".vim" and run "rake":  
   `cd ~/.vim && rake`

This will install "~/.vimrc" and "~/.gvimrc" symlinks that point to
files inside the ".vim" directory.

## References

* https://github.com/mislav/vimfiles
* http://mislav.uniqpath.com/2011/12/vim-revisited/
* https://github.com/garybernhardt/dotfiles

