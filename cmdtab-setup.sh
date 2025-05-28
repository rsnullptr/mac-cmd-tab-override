#!/bin/bash

setup_cmdtab_raycast() {
    local plist_path="$HOME/Library/LaunchAgents/pt.nullptr.cmdtab-raycast.plist"
    local executable_source="cmdtab-raycast-sw"
    local executable_dest="/usr/local/bin/cmdtab-raycast-sw"
    local reset_flag=false

    if [ "$1" = "reset" ]; then
        reset_flag=true
    fi

    # If reset flag is true, unload and remove existing components
    if [ "$reset_flag" = true ]; then
        echo "Resetting cmdtab-raycast..."

        # Unload the launch agent if it exists
        if [ -f "$plist_path" ]; then
            launchctl unload "$plist_path" 2>/dev/null
            rm -f "$plist_path"
            echo "Removed existing plist at $plist_path"
        fi

        # Remove the executable if it exists
        if [ -f "$executable_dest" ]; then
            sudo rm -f "$executable_dest"
            echo "Removed existing executable at $executable_dest"
        fi
    elif [ -f "$plist_path" ]; then
        echo "Launch Agent already exists at $plist_path. No action needed."
        echo "Use --reset or -r flag to force reset and setup."
        return 0
    fi

    echo "Setting up cmdtab-raycast..."

    # Copy the executable to /usr/local/bin
    if [ -f "$executable_source" ]; then
        sudo cp "$executable_source" "$executable_dest"
        sudo chmod +x "$executable_dest"
        echo "Copied executable to $executable_dest"
    else
        echo "Error: Executable $executable_source not found in current directory"
        return 1
    fi

    # Create the LaunchAgents directory if it doesn't exist
    mkdir -p "$(dirname "$plist_path")"

    # Copy the plist file
    if [ -f "pt.nullptr.cmdtab-raycast.plist" ]; then
        cp "pt.nullptr.cmdtab-raycast.plist" "$plist_path"
        echo "Copied plist to $plist_path"
    else
        # If plist doesn't exist in current directory, create it using the content
        cat > "$plist_path" << 'EOL'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
      <key>Label</key>
      <string>pt.nullptr.cmdtab-raycast</string>
      <key>ProgramArguments</key>
      <array>
          <string>/usr/local/bin/cmdtab-raycast-sw</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
  </dict>
</plist>
EOL
        echo "Created plist at $plist_path"
    fi

    # Load the plist
    launchctl load "$plist_path"
    echo "Loaded Launch Agent successfully"

    return 0
}

# Example usage:
# setup_cmdtab_raycast          # Normal setup
# setup_cmdtab_raycast --reset  # Reset and setup
# setup_cmdtab_raycast -r       # Reset and setup (short version)
setup_cmdtab_raycast $1