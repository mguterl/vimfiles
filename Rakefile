# Shamelessly lifted from https://github.com/mislav/vimfiles/blob/master/Rakefile

task :default => [:update, :link]

desc %(Bring bundles up to date)
task :update do
  sh "git submodule sync >/dev/null"
  sh "git submodule update --init"
end

desc %(Update each submodule from its upstream)
task :submodule_pull do
  system <<-EOS
    git submodule foreach '
      rev=$(git rev-parse HEAD)
      git pull --quiet --ff-only --no-rebase origin master &&
      git --no-pager log --no-merges --pretty=format:"%s %Cgreen(%ar)%Creset" --date=relative ${rev}..
      echo
    '
  EOS
end

desc %(Make ~/.vimrc and ~/.gvimrc symlinks)
task :link do
  %w[vimrc gvimrc].each do |script|
    dotfile = File.join(ENV['HOME'], ".#{script}")
    if File.exist? dotfile
      warn "~/.#{script} already exists"
    else
      ln_s File.join('.vim', script), dotfile
    end
  end
end

