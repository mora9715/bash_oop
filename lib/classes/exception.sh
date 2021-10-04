#! /usr/bin/env bash

class Exception

Exception . __init__ << 'EOF'
  local message
  local exit_code

  message="${1:-something went wrong}"; shift
  exit_code="${1:-1}"; shift

  ${this} : message = "${message}"
  ${this} : exit_code = "${exit_code}"
EOF

Exception . _print_error_message << 'EOF'
  _print_stacktrace
  echo -e "${this}: `$this : message`"
EOF

Exception . _exit << 'EOF'
  exit `${this} : exit_code`
EOF

Exception . __raise__ << 'EOF'
  ${this} . __init__ "${@}"

  $this . _print_error_message
  $this . _exit
EOF

