if [ ! $SHORTY_DIR ]; then export SHORTY_DIR=$HOME/workspace/shorty; fi

cd $SHORTY_DIR
tmux new-session  -d   -s shorty
tmux set-environment   -t shorty -g SHORTY_DIR $SHORTY_DIR

tmux new-window        -t shorty -n 'Web'
tmux send-key          -t shorty 'cd $SHORTY_DIR'  Enter 'puma -p 4000 -t 0:5'        Enter

tmux new-window        -t shorty -n 'Console'
tmux send-key          -t shorty 'cd $SHORTY_DIR'  Enter 'pry'                        Enter

tmux new-window        -t shorty -n 'SQL'
tmux send-key          -t shorty 'cd $SHORTY_DIR'  Enter 'sqlite3 shorty_development' Enter

tmux new-window        -t shorty -n 'Shorty'
tmux send-key          -t shorty 'cd $SHORTY_DIR'  Enter 'vim .'                      Enter

tmux new-window        -t shorty -n 'Yard'
tmux send-key          -t shorty 'cd $SHORTY_DIR'  Enter 'yard server'                Enter

tmux -2 attach-session -t shorty
