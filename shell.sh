#!/bin/bash

# Check the current shell
if [ "$SHELL" = "/bin/bash" ]; then
  echo "Bash shell found"
  # Execute commands for Bash shell here
  # ...
elif [ "$SHELL" = "/bin/zsh" ]; then
  echo "Zsh shell found"
  # Execute commands for Zsh shell here
  # ...
else
  echo "Unknown shell found"
  # Execute commands for unknown shell here
  # ...
fi





