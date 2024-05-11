# Discord Bot Language (DBL)
## Background
DBL is a simple wrapper language for Discord.js, a Node.js module that is used to code Discord bots. It is intended for casual, personal use, with only a few functionalities in its current state, and it is designed to be simple enough for just about anybody to use. This language was my Senior project for Chico State Computer Science in Spring 2024.

## Overview
DBL has two main parts, an intialization block and a command block. The initialization block takes information that is used to authenticate the bot through Discord's servers, and all of the information required for it is received directly from Discord. The command block is where the actual commands that can be used in Discord are coded.

## Commands
DBL has four command types currently:
1. **Normal Command:** A normal command is simply a command where the bot replies with any single string of text that it is designed to respond with. It is denoted by the "norm" prefix.
2. **Counter Command:** A counter command is a command with a number attached to it which starts at 0 and increments by one every time it is called by a user, and the running total is a part of the command output. It is denoted by the "count" prefix.
3. **Random Command:** A random command is a command where multiple possible response strings are defined. When the command is called, the bot chooses one of these responses at random. It is denoted by the "rand" prefix.
4. **Picture Command:** A picture command is a command with both an optional caption and a picture, the picture is added via a URL, and the bot will respond with the image itself and the caption, if there is one. It is denoted by the "picture" prefix.

## Usage
Bots that are created using DBL are ran from a terminal window, like Windows or Linux command prompt. When running a bot, the code for the bot and the executable (dbl-windows.bat for Windows and dbl for Linux) must be in the same folder/directory as the code that is being run. For example, when running with a DBL file called "bot.txt":

### Windows
```
dbl-windows.bat bot.txt
```
### Linux
```
./dbl bot.txt
```
## Requirements
### Node.js
The first requirement for DBL is Node.js. Node.js simply is an environment that allows you to run JavaScript code.
#### Windows
[Installing Node on Windows](https://radixweb.com/blog/installing-npm-and-nodejs-on-windows-and-mac)
#### Linux
[Installing Node on Linux](https://www.geeksforgeeks.org/installation-of-node-js-on-linux/)

### Token, Application ID, and Guild ID
You will also need a token, application ID, and guild ID. The token and application ID are used to identify the bot, and the guild ID is used to identify the server the bot will be used in. 

For the token and application ID, you will first need to go to Discord's [developer portal](https://discord.com/developers). Create a bot application, and navigate to the General Information tab, where you will get your application ID. The token can be found in the Bot tab. Then in the OAuth2 tab you can select the permissions you would like to give the bot, and create an invite link to add your bot to a server. Simply paste the invite link into your browser and select the server you'd like to add it to. The guild ID comes from the Discord app itself, and is found by navigating to the server you'd like to add the bot to, and right clicking the name of the server at the top left, then selecting copy Server ID from the popout menu, pictured [here](https://i.imgur.com/PTLxLqJ.png).

More information on creating a bot can be found in sections "setting up a bot application" through "adding your bot to servers" in the [Discord.js documentation](https://discordjs.guide/preparations/setting-up-a-bot-application.html).
