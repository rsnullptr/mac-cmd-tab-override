## cmdtab override

Right now it triggers Raycast Switch Windows, override it to use env SCRIPT_PATH. 


### build
```
clang -framework Cocoa -framework ApplicationServices code.m -o cmdtab-raycast-sw
```

### plist
```
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
      <key>Label</key>
      <string>pt.nullptr.cmdtab-raycast</string>
      <key>ProgramArguments</key>
      <array>
          <string>$(pwd)/cmdtab-raycast-sw</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
  </dict>
</plist>' > cmdtab-raycast-sw.plist
```

```
launchctl load $(pwd)/cmdtab-raycast-sw.plist
```

### custom script when cmd+tab is triggered?
```
echo '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
      <key>Label</key>
      <string>pt.nullptr.cmdtab-raycast</string>
      <key>ProgramArguments</key>
      <array>
          <string>$(pwd)/cmdtab-raycast-sw</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>EnvironmentVariables</key>
      <dict>
          <key>SCRIPT_PATH</key>
          <string><your_custom_script_path></string>
      </dict>
  </dict>
</plist>' > cmdtab-raycast-sw.plist
```

replace above
```
<your_custom_script_path> with the full path for the desire script
```