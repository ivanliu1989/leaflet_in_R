# 1. Copy your project folder to /home/xiaoxig/ShinyApps/
system('cp -rf /home/xiaoxig/XXX /home/xiaoxig/ShinyApps/XXX') # XXX is your shiny project name

# 2. Update access
RQuant::updateDirFilePermissions('/home/xiaoxig/ShinyApps')

# 3. You can visit your app from: http://rstudio.anzinsights.com/shiny/xiaoxig/XXX/



# To delete deployed Shiny app
system(command = 'sudo rm -rf /home/rstudio/ShinyApps/XXX') # XXX is your shiny project name





