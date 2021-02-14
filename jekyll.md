# Jekyll
[✏️](https://github.com/meleu/my-notes/edit/master/jekyll.md)

## Installation

I had some problems to get jekyll up and running on Linux Mint 20.

Instructions adapted from <https://jekyllrb.com/docs/installation/ubuntu/>:

```
sudo apt-get install ruby-full build-essential zlib1g-dev

echo '# Install Ruby Gems to ~/.gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/.gems"' >> ~/.bashrc
echo 'export PATH="$HOME/.gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

gem install jekyll bundler

# I noticed that it's not smoothly installed and sometimes I need
# to run jekyll prefixing it with 'bundle exec'
```

**Note**: I remember I installed it via Ruby enVironment Manager (<https://rvm.io/>) in the past and it was a good option, but the rvm installation process is not for dummies and I didn't take notes at that time. I need to retry it taking notes.

