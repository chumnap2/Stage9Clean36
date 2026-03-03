#!/bin/bash
# One-step F' 3.1 Python 2.7 launcher

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
pyenv shell fprime27
cd ~/fprime-workspace/fprime-3.1.0
echo "✅ Ready for F' 3.1 with Python 2.7 (fprime27)"
python --version
