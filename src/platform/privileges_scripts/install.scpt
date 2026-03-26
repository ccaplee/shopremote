on run {daemon_file, agent_file, user}

  set sh1 to "echo " & quoted form of daemon_file & " > /Library/LaunchDaemons/kr.co.ilv.shopremote_service.plist && chown root:wheel /Library/LaunchDaemons/kr.co.ilv.shopremote_service.plist;"

  set sh2 to "echo " & quoted form of agent_file & " > /Library/LaunchAgents/kr.co.ilv.shopremote_server.plist && chown root:wheel /Library/LaunchAgents/kr.co.ilv.shopremote_server.plist;"

  set sh3 to "cp -rf /Users/" & user & "/Library/Preferences/kr.co.ilv.shopremote/ShopRemote.toml /var/root/Library/Preferences/kr.co.ilv.shopremote/;"

  set sh4 to "cp -rf /Users/" & user & "/Library/Preferences/kr.co.ilv.shopremote/ShopRemote2.toml /var/root/Library/Preferences/kr.co.ilv.shopremote/;"

  set sh5 to "launchctl load -w /Library/LaunchDaemons/kr.co.ilv.shopremote_service.plist;"

  set sh to sh1 & sh2 & sh3 & sh4 & sh5

  do shell script sh with prompt "ShopRemote wants to install daemon and agent" with administrator privileges
end run
