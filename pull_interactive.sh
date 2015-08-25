#!/bin/sh

# git pullでない場合はそのまま実行する
if [[ ! $@ =~ pull ]]; then
  command git $@
  exit 0
fi

# -iオプションがあるかどうか確認する
i_option_flg=0
for opt in $*
do
  case $opt in
    '-i' )
      i_option_flg=1
      ;;
  esac
done

# -iオプションがない場合はそのままgit pullする
if [ $i_option_flg != 1 ]; then
  command git $@
  exit 0
fi

# remote branchを入力する
read -p "Please input remote (default: origin) " remote
remote=${remote:-origin}

# local branchを入力する
read -p "Please input branch (default: master) " branch
branch=${branch:-master}

# dry-runをする
command git fetch $remote
command git diff --stat-width=500 HEAD..$remote/$branch

# yes/noの確認メッセージを出力する
printf "Are you sure you want to run? (y/N) "
read answer
if [ -z "${answer}" ]; then
  answer="no"
fi
if [[ ${answer} =~ ^\s*[yY]([eE][sS])?\s*$ ]]; then
  command git ${@#-i} $remote $branch
  exit 0
elif [[ ${answer} =~ ^\s*[nN][oO]?\s*$ ]]; then
  exit 1
fi
