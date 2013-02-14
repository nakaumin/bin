#!/bin/sh -eu
# -*- coding:utf-8-unix; mode:sh; -*-
#
# GNU screen で ssh を立ちあげた時に、タイトルを設定するためのスクリプト
#
# 使い方
# ==================
#
# .ssh/config の最初の行に下記の三行を追加
#
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Host *
#   PermitLocalCommand yes
#   LocalCommand /path/to/screen_ssh.sh $PPID %n %r
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
# 参考にしたもの
# ==================
#
# * http://www.tenshu.net/p/screenssh.html
# * http://ninad.pundaliks.in/blog/2011/10/show-hostname-and-username-during-ssh-in-screen-or-byobus-window-title/
#

d() {
    (echo "$@" | tee $HOME/.ssh/screen_ssh.sh)
}

# 端末上で実行されてる？
! tty -s && exit 1
# [ ! -t 0 ] && a "stdin is not a terminal"

# screen 上で実行されてる？
[ -z "$STY" ] && exit 1

# 引数の数は正しい？
[ $# != "3" ] && exit 1

# SSH は対話モードで実行されてる？（バッチモードで実行されてない？）
grep -a -i "Batchmode yes" /proc/$1/cmdline >/dev/null 2>&1 && a "SSH is in Batch mode"

HOST="$2"
USER="$3"
d "host:  $HOST"
d "user:  $USER"

# TITLE="$USER@$HOST"
TITLE="$HOST"
d "title: $TITLE"

# ウィンドウタイトル変更
echo "\033k$TITLE\033\\"
