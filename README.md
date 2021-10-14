Smiley Prompt
--

A handy prompt that displays useful information and a text emoji for return code.

![smiley-prompt](https://github.com/debaillie/smiley-prompt/blob/main/screenshot.jpg?raw=true)

### Installation

Update your .bashrc or .zshrc to change the prompt using something like this:
```
PS1="\`let RET=\$?; $HOME/bin/smiley-prompt.sh; if [ \$RET = 0 ]; then echo -ne '\\[\\033[01;32m\\]:)'; else echo -ne '\\[\\033[01;31m\\]'; echo -ne \$RET; echo -ne ' :('; fi; echo -n '\\[\\033[00m\\] '\`"
```
