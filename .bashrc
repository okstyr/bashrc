export CVSROOT='/web/src'
echo "===============================================
$PATH

"
export PATH="$PATH:$HOME/bin:$HOME/bin/ec2-api-tools/bin:$HOME/bin/android-sdk/tools:/var/lib/gems/1.8/bin"
echo "
$PATH

=============================================
"
#expand those aliases
shopt -s expand_aliases

alias my="cat $HOME/toolbox/mysql/aliases/csh|grep -v '##--'|cut -d ' ' -f 1-2"
alias open='classToFileOrDir file'
alias list='classToFileOrDir dir'
alias subs='classToFileOrDir subs'
alias meths='classToFileOrDir methods'
alias methods='classToFileOrDir methods'
# vim should always open multiple files easily
#alias vim='vim -p'
# the way grep should always work
alias grep='egrep -ir --color'

# quickly create executable file
vimx()
{
    vim $1; chmod +x $1
}

#cat ~/toolbox/mysql/aliases/csh | sed 's/^alias \(.*\) \(mysql .*\)$/alias \1="\2"/' > $HOME/myalias
cat ~/toolbox/mysql/aliases/csh | tr -s ' ' |sed 's/^alias \(.*\) \(mysql .*\)$/alias \1="\2"/' > $HOME/myalias
source myalias

# this does magic to give us git branch for prompt
source ~/bin/git-completion.sh

export export EC2_HOME=/home/amuhrer/bin/ec2-api-tools/
export JAVA_HOME=/usr/lib/jvm/java
#export JAVA_HOME=/usr/java/latest/jre/bin/java

#export JDK_HOME=/usr/lib/jvm/java-6-sun-1.6.0.20
#export ANDROID_HOME=/home/amuhrer/bin/android-sdk/tools
# for imagemagick and rmagick
export LD_LIBRARY_PATH=/usr/local/lib

# for all your REA cucumber testing needs
export TEST_ENV=amuhrer
#export JBOSS_HOME=$HOME/jboss/jboss-soa-p.4.3.0/jboss-as

# colors are fun
export RED='\[\033[0;31m\]'
export GREEN='\[\033[0;32m\]'
export BROWN='\[\033[0;33m\]'
export BLUE='\[\033[1;34m\]'
export PURPLE='\[\033[1;35m\]'
export NORMAL='\[\033[0m\]'
export TITLEBAR='\[\033]0;\h:\w ---\t\007\]'

export MYSQL_PS1="\u@\h \d> "

#------ bash history stuff
# unlimited histfile
unset HISTFILESIZE
#lotsa lines in memory
HISTSIZE=100000
# write to history file every time we write a prompt
PROMPT_COMMAND="smiley; branch; history -a"
# don't overwrite history - just append
shopt -s histappend

# rvm stuff
if [[ -s "$HOME/.rvm/scripts/rvm" ]]
then 
    source "$HOME/.rvm/scripts/rvm"
  #  rvm use ruby-1.8.7-p358
fi

# rea-ec2 stuff
if [[ `gem list |grep rea-ec2` ]]; then
    # noisy fucking slow tool
    eval `rea-ec2-aws-tools-env 2>/dev/null` &
fi

## OS dependent stuff
if [ $OSTYPE == 'FreeBSD' ]
then
    alias ls='ls -G'
    export TERM='xterm-color'
    export PERLLIB="$HOME/myperl/lib/site_perl/5.6.1:$HOME/myperl/lib:$HOME/myperl/lib/perl5/site_perl/5.6.1"
else
    alias ls='ls --color'
    export TERM='linux'
    export PERLLIB="$HOME/myperl/lib/perl5:$HOME/myperl/share/perl/5.8.8:$HOME/myperl/lib:$HOME/myperl/local/share/perl/5.8.8"
fi

##-----------------------------------------------------------------
## command line utility aliases
alias ack='ack --group --color'

##-----------------------------------------------------------------
## here begins a whole bunch of prompt stuff
export regHOME=`echo $HOME|sed -e 's/\//\\\\\//g'`
export sedHOME="s/${regHOME}/~/"

## explanation of promt sequences
## \h - first part of host name
## \y - time
## \u - username
## \w - the current dir

# conserve earlier prompt_command
export PROMPT_COMMAND="$PROMPT_COMMAND;makeps1"
export pwdmaxlen=30

function branch() {
##  show current git/cvs branch on the prompt.
##  eg.  PS1='[\u@\h \W$(vcs_ps1 " (%s)")]\$ '
if [ -n "$(which git)" ] ; then
    export vcs='G'
    export branch="$(__git_ps1 "%s")" ## lives in git-completion.sh
elif [ -d "CVS/" ]; then
    export vcs='C'
    if [ -f "CVS/Tag" ]; then
        export branch=$(cat CVS/Tag | sed -e "s/^T//")
    elif [ "x$PWD" == "x$HOME" ]; then
        export branch=""
    else
        export branch="HEAD"
    fi
fi
}

function smiley() {
    ## build a smiley depending on the status of the last command
    if [ $? == 0 ] 
    then
        export smiley="${GREEN}^_^${NORMAL}"
    else
        export smiley="${RED}0_o${NORMAL}"
    fi
}
                export PS1='$(smiley) '
function makeps1 {
    ##   Indicator that there has been directory truncation:
    local trunc_symbol="..."
    export thispwd=`echo $PWD|sed -e $sedHOME`
    if [ ${#thispwd} -gt $pwdmaxlen ]
    then
        local pwdoffset=$(( ${#thispwd} - $pwdmaxlen ))
        local newPWD="${trunc_symbol}${thispwd:$pwdoffset:$pwdmaxlen}"
    else
        local newPWD=${thispwd}
    fi

    PS1="${TITLEBAR}${BLUE}\h:${GREEN}${newPWD}${BLUE} \t ${PURPLE}${branch} $smiley ${NORMAL}> "
}


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
