#!/bin/bash

# Default variables
command=""
component_name=""
custom_path="lib/components"
install_tool="yarn"  # Defaulting to Yarn
template="@devgfnl/pwa-extension-template@latest"  # Default template
parent_component=""  # Optional parent component name

# Colors
RED="\033[1;31m"
YELLOW="\033[1;33m"
GREEN="\033[1;32m"
RESET="\033[0m"

function show_error_message {
  echo -e "${RED}[✘] ${RESET}$1" >&2
}

function show_warning_message {
  echo -e "${YELLOW}[!] ${RESET}$1" >&2
}

function show_success_message {
  echo -e "${GREEN}[✔] ${RESET}$1"
}

# Function to display helper message
function show_helper_message {
  echo -e "${GREEN}Usage:${RESET}"
  echo -e "${YELLOW}  $0 <command> [--args]...${RESET}"
  echo
  echo -e "${GREEN}Options:${RESET}"
  echo -e "${YELLOW}  create-component, component, cc, c${RESET}   Create a new React component."
  echo -e "${YELLOW}  create-extension, extension, ce, e${RESET}    Create a new extension using a template."
  echo
  echo -e "${GREEN}Arguments:${RESET}"
  echo -e "${YELLOW}  ComponentName${RESET} Name of the component to be created."
  echo -e "${YELLOW}  -d, --path CustomPath${RESET} Custom path to create the component. (default: lib/components)"
  echo -e "${YELLOW}  -p, --parent ParentComponentName${RESET} Name of the parent component (optional)."
  echo -e "${YELLOW}  -u, --use yarn || npm${RESET} Installation tool (default: yarn)."
  echo -e "${YELLOW}  -t, --template TemplateName${RESET} Name of the template to create the extension. (default: @devgfnl/pwa-extension-template)"
  exit 1
}

# Process arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
    create-component | component | cc | c)
      command="create-component"
      ;;
    create-extension | extension | ce | e)
      command="create-extension"
      ;;
    --use | -u)
      shift
      install_tool="$1"
      ;;
    --path | -d)
      shift
      custom_path="$1"
      ;;
    --template | -t)
      shift
      template="$1"
      ;;
    --parent | -p)
      shift
      parent_component="$1"
      ;;
    *)
      # If not a known argument, assume it is the ComponentName
      component_name="$1"
      ;;
  esac
  shift
done

# Check if the command and necessary arguments are provided
if [ -z "$command" ]; then
  show_helper_message
fi

# Check if it's the create-extension command and --use is present
if [ "$command" == "create-extension" ] && [ -z "$install_tool" ]; then
  show_helper_message
fi

if [ "$command" == "create-component" ] && [ -z "$component_name" ]; then
  show_helper_message
fi

if [ "$command" == "create-extension" ]; then
  if [ "$install_tool" == "yarn" ]; then
    yarn create @larsroettig/pwa-extension --template $template
  elif [ "$install_tool" == "npm" ]; then
#    npm create @larsroettig/pwa-extension --template $template
    show_warning_message "npm is not supported yet!"
  else
    show_error_message "Incorrect option for --use. Please use 'yarn' or 'npm'."
    show_helper_message
  fi
  exit 0
fi

# Convert the first letter to lowercase
first_letter_lowercase="$(echo -n $component_name | head -c 1 | tr '[:upper:]' '[:lower:]')"
file_name="$first_letter_lowercase$(echo -n $component_name | tail -c +2)"

# Determine the destination directory
if [ -n "$parent_component" ]; then
  destination_directory="$custom_path/$parent_component"
else
  destination_directory="$custom_path/$component_name"
fi

# Create the directory if it doesn't exist
mkdir -p "$destination_directory"

# Content of the component file
component_content="\
import React from 'react';
import { mergeClasses } from '@magento/venia-ui/lib/classify';
import { shape, string } from 'prop-types';

import defaultClasses from './$file_name.module.css';

const $component_name = props => {
    const classes = mergeClasses(defaultClasses, props.classes);
    return <div className={classes.root} />;
};

$component_name.propTypes = {
    classes: shape({ root: string })
};
$component_name.defaultProps = {};
export default $component_name;
"

index_content="\
export { default } from './$file_name';
"

css_content="\
.root {

}
"

# Create the file with content
echo "$component_content" > "$destination_directory/$file_name.js"

if [ ! -n "$parent_component" ]; then
  echo "$index_content" > "$destination_directory/index.js"
fi

echo "$css_content" > "$destination_directory/$file_name.module.css"

if [ "$command" == "create-component" ]; then
  show_success_message "React component '$component_name' created successfully in '$destination_directory'"
fi
