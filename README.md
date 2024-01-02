# PWA Studio: Component Generator
This script is designed to facilitate the generation of components and extensions for PWA Studio.

## Summary
* [Usage](#usage)
* [Command](#commands)
    * [Arguments](#arguments)
    * [Options](#options)
* [Installation](#installation)
* [Example Usage](#example-usage)
* [Disclaimer](#disclaimer)

## Usage

```bash
pwagen <command> [--args]...
```

## Commands

#### create-component (or component, cc, c)
Create a new React component with css file.
#### create-extension (or extension, ce, e)
Create a new extension using a template.

### Arguments
- **ComponentName**: Name of the component to be created.

### Options
- **-d, --path CustomPath**: Custom path to create the component. (default: lib/components)
- **-p, --parent ParentComponentName**: Name of the parent component (optional).
- **-u, --use yarn || npm**: Installation tool (default: yarn).
- **-t, --template TemplateName**: Name of the template to create the extension. (default: [@devgfnl/pwa-extension-template](https://github.com/GabrielFNLima/pwa-extension-template))

## Installation

#### Step 1: Clone the Repository
```bash
git clone https://github.com/GabrielFNLima/pwa-component-generator.git
cd pwa-component-generator
```
#### Step 2: Add the CLI to /usr/local/bin
```bash
sudo cp $(pwd)/pwagen.sh /usr/local/bin/pwagen
sudo chmod +x /usr/local/bin/pwagen
```
Now you can access the CLI globally by using **pwagen**.

### Example Usage

#### Creating a Component
```bash
pwagen create-component MyNewComponent -d custom/path

# with parent component
pwagen create-component OtherNewComponent -d custom/path -p MyNewComponent
```

#### Creating an Extension
```bash
pwagen create-extension
```

## Disclaimer

This script assumes the usage of PWA Studio tools and may require modifications based on your specific project setup. Always review and customize the script according to your project's requirements.

**Important**: Ensure that you understand the implications of running the script, especially when creating components within an existing project. Always test in a safe environment before deploying to a production environment.