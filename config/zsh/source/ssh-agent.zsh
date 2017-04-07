SSH_DIR=$HOME/.ssh
SSH_ENV=$SSH_DIR/environment

# start the ssh-agent
function start_agent {
    e_info "Initializing new SSH agent..."
    if [ ! -f ${SSH_ENV} ]; then
      e_info "Creating $SSH_DIR..."
      mkdir -p $SSH_DIR
    fi
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' >! "${SSH_ENV}"
    e_success "Success!"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi