set sh1 to "launchctl unload -w /Library/LaunchDaemons/kr.co.ilv.shopremote_service.plist;"
set sh2 to "/bin/rm /Library/LaunchDaemons/kr.co.ilv.shopremote_service.plist;"
set sh3 to "/bin/rm /Library/LaunchAgents/kr.co.ilv.shopremote_server.plist;"

set sh to sh1 & sh2 & sh3
do shell script sh with prompt "ShopRemote wants to unload daemon" with administrator privileges