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

To run a bot, first download either everything from this repository, or simply the executable and folder that match your operating system, then create a text file in the same folder as the executable, and write your code in that file using a text editor of your choice.

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

## Creating a Bot
### Initialization Block
The beginning of your code should be the initialization block, where you add the token, process/application/client ID (they all mean the same thing), and guild ID. The initialization block is denoted simply by the word "init" followed by a colon, then a set of curly braces, with the initializers in between the statements. It should look like this:
```
init:
{
  token="YOURTOKEN";
  client="YOURCLIENTID";
  guild="YOURGUILDID";
}
```
### Command Block
The command block looks similar to the initialization block, but with the keyword "commands" instead of "init", like this:
```
commands:
{
  
}
```
#### Commands
Different commands differ slightly in their syntax and format, but the general format is the command type (norm, count, rand, picture) followed by a period and the command name. The command name is what will be typed in Discord in order to use the command, and in the case of a count command will be attached to the value that the count command holds. Then there will be a set of parentheses, inside of which are the additional information required for a command, with a semicolon at the end, outside of the parentheses. Inside the parentheses for every command will be some form of output, and an optional description. 
##### Normal Command
A normal command looks like this: `norm.commandname("output", "optional decription");` or with no description `norm.commandname("output");`. Anything inside quotes, along with the command name can be changed to the coder's liking. In this case, the command name is ```commandname```, the bot's response would be ```output```, and the description would be ```optional description```, in the case that no description is added, when calling the command in Discord the description will simply say ```undefined```
#### Counter Command
A counter command looks like this: `count.commandname("output", "output2", "description");`. The only difference between this and a normal command, is that there are two spots for output. This is because this command has a number attached to it, the number of times it is called, and this number will be inserted directly between the first and second outputs that are defined. For example, the first time that this command is called, the output will be `output1output2`. Then the 1000th time this command is called, the output will be `output1000output2`. It is worth noting that these counts will be retained even when the bot is not running, so stopping the bot will not reset the counts. Also, the count is attached to the command name, so as long as the command name is not changed the count will continue to be stored, and if a new count command is created with the same name as an old one, the new one will begin at the count that the old one ended at.
#### Random Command
A random command looks like this: `rand.commandname("output" "output2" "output3" "output4", "description");` Something important to note with this command is that each of the **possible random outputs are divided by spaces.** It would be an easy mistake to add a comma between each string of text, but it may lead to errors in this case. The output for this command would be a random choice between `output`, `output2`, `output3`, and `output4`. The output is randomly chosen every time the command is called.
#### Picture Command
A picture command looks like this: `picture.commandname("caption", "PICTUREURL", "description");` This command will simply make the bot respond with the picture that is referenced in the URL, along with a caption, if you would like one. ***The set of quotes for the caption must be there, but it may be left blank if you would not like to add a caption.*** Like this: `picture.commandname("", "PICTUREURL", "description");` When choosing a URL for a picture, I found it most effective to right click the picture and "open image in new tab" and use that URL. Some URLs will not work properly, and it will simply show up in Discord as the URL instead of the actual embedded picture.

When put together, it should look something like this:
```
commands:
{
  norm.command1("output", "optional decription");
  count.command2("output", "output2", "description");
  rand.command3("output" "output2" "output3" "output4", "description");
  picture.command4("caption", "PICTUREURL", "description");
}
```
### Start
Finally, at the end of your program should simply be a line that says `start;`. This line will begin running the bot.

### Etc
- Commands must have different names. If two commands are defined with the same name, even if they are not the same type, only one of them will work.
- To add comments to your code, simply put # followed by the comment you would like to add. It must come at the end of the line or be on its own line, comments cannot be added in the beginning or middle of lines of code. Like this: `codecodecodecode #THIS IS A COMMENT, WILL NOT AFFECT ANYTHING THAT IS GOING ON INSIDE OF THE CODE.`
- [Here is an example of a full working bot using each type of command, and comments](example.txt)
