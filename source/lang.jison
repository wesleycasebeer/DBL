%lex /*this declares that its a lexical grammar*/

%%
\s+ /*skips whitespace*/
\\n return 'T_NEWLINE'

/* keywords */
"start" return 'T_START'

/*for adding a command*/
"commands" return 'T_COMMANDS'
"norm" return 'T_NORM'
"rand" return 'T_RAND'
"count" return 'T_COUNT'
"picture" return 'T_PICTURE'

/*initialization stuff*/
"client"  return 'T_CLIENT'
"guild"   return 'T_GUILD'
"token"   return 'T_TOKEN'
"init"    return 'T_INIT'

/*symbols*/
"("       return 'T_LPAREN'
")"       return 'T_RPAREN'
"{"       return 'T_LBRACE'
"}"       return 'T_RBRACE'
","       return 'T_COMMA'
";"       return 'T_SEMIC'
":"       return 'T_COLON'
"="       return 'T_ASSIGN'
"."       return 'T_PERIOD'

\"[^\"]*\"|\'[^\']*\' {yytext = yytext.substr(1, yyleng-2); return 'T_STRING_CONSTANT'}

"#"(.*)\n /*ignore comments*/

[a-zA-Z][a-zA-Z0-9]* return 'T_IDENTIFIER' /*identifiers must start with a letter then can have 0 or more letters/numbers after that*/
/*[a-zA-Z0-9\_\-\.]+   return 'T_KEY'*/ /*i think this has to be sunset cause having stuff
 other than T_ID and T_STRING.. could be a problem but maye i could make tokens surrounded in single quotes or something idk.. actually i think thats dumb i think treating tokens etc as strings makes more sense*/

<<EOF>> return 'EOF'

/lex

%{
    const fs = require('node:fs');
    const path = require('node:path');    

    function begin(token)
    {
        const fs = require('node:fs');
        const path = require('node:path');
        const {Client, Collection, Events, GatewayIntentBits} = require('discord.js');
        const prefix = '/';
        const client = new Client({intents: [GatewayIntentBits.Guilds]});

        client.commands = new Collection();

        const foldersPath = path.join(__dirname, 'commands');
        const commandFolders = fs.readdirSync(foldersPath);

        for (const folder of commandFolders)
        {
            const commandsPath = path.join(foldersPath, folder);
            const commandFiles = fs.readdirSync(commandsPath).filter(file => file.endsWith('.js'));
            for (const file of commandFiles)
            {
                const filePath = path.join(commandsPath, file);
                const command = require(filePath);
                if ('data' in command && 'execute' in command)
                {
                    client.commands.set(command.data.name, command);
                }
                else
                {
                    //console.log('[WARNING] The command at ${filePath} is missing a required "data" or "execute" property.');
                }
            }
        }

        client.once(Events.ClientReady, readyClient =>
        {
            console.log('Bot successfully logged in.');
            console.log('Press q to stop.');
            //console.log('Ready! logged in as ${readyClient.user.tag}');
        });

        client.on(Events.InteractionCreate, async interaction =>
        {
            if (!interaction.isChatInputCommand()) return;
            const command = interaction.client.commands.get(interaction.commandName);
            if (!command)
            {
                console.error('No command matching ${interaction.commandName} was found.');
                return;
            }

            try
            {
                await command.execute(interaction);
            }
            catch (error)
            {
                console.error(error);
                if (interaction.replied || interaction.deferred)
                {
                    await interaction.followUp({content: 'There was an error while executing this command!', ephemeral: true});
                }
                else
                {
                    await interaction.reply({content: 'There was an error while executing this command!', ephemeral:true});
                }
            }
        });

        process.stdin.setRawMode(true);
        process.stdin.resume();
        process.stdin.setEncoding('utf8');

        process.stdin.on('data', async (key) => {
            if (key == 'q') {
                console.log('Shutting down...');
                client.destroy();
                process.exit();
            }
        });        

        client.login(token);
    }

    function deploy(clientId, guildId, token)
    {
        const {REST, Routes} = require('discord.js');
        const fs = require('node:fs');
        const path = require('node:path');

        const commands = [];
        const foldersPath = path.join(__dirname, 'commands');
        const commandFolders = fs.readdirSync(foldersPath);

        for (const folder of commandFolders)
        {
            const commandsPath = path.join(foldersPath, folder);
            const commandFiles= fs.readdirSync(commandsPath).filter(file => file.endsWith('.js'));
            for (const file of commandFiles) {
                const filePath = path.join(commandsPath, file);
                const command = require(filePath);
                if ('data' in command && 'execute' in command) 
                {
                    commands.push(command.data.toJSON());                    }
                else
                {
                    //console.log('[WARNING The command at ${filePath} is missing a required "data" or "execute" property.');
                }
            }
        }

        const rest = new REST().setToken(token);

        (async () => {
            try {
                    //console.log('Started refreshing ${commands.length} application (/) commands.');
                    const data = await rest.put(
                        Routes.applicationGuildCommands(clientId, guildId),
                    {body: commands},
            );

            //console.log('Successfully reloaded ${data.length} application (/) commands.');
            } catch (error) {
                console.error(error);
            }
        })();
    }

    function normalCommand(name, output, description)
    {
        let out =
        "const { SlashCommandBuilder } = require('discord.js');\n\n"
        + "module.exports = {\n"
        + "\t data: new SlashCommandBuilder()\n"
        + "\t\t.setName(\"" + name + "\")\n"
        + "\t\t.setDescription(\"" + description + "\"),\n"
        + "\tasync execute(interaction) {\n"
        + "\t\tawait interaction.reply( \"" + output + "\");\n"
        + "\t},\n"
        + "};";

        const dirPath = "commands/utility/";
        const filePath = path.join(dirPath, name + ".js");

        if (!fs.existsSync(dirPath))
        {
            fs.mkdirSync(dirPath, {recursive: true});
        } 
        fs.writeFileSync(filePath, out);
    }
    function countCommand(name, output1, output2, description)
    {
        let out =
        "const { SlashCommandBuilder } = require('discord.js');\n"
        + "const { QuickDB } = require ('quick.db');\n"
        + "const db = new QuickDB();\n\n"
        + "module.exports = {\n"
        + "\t data: new SlashCommandBuilder()\n"
        + "\t\t.setName(\"" + name + "\")\n"
        + "\t\t.setDescription(\"" + description + "\"),\n"
        + "\tasync execute(interaction) {\n"
        + "\t\tconst exists = await db.has(\"" + name + "\");\n"
        + "\t\tif (!exists) { await db.set(\"" + name + "\", 0) }\n"
        + "\t\tawait db.add(\"" + name + "\", 1);\n\n"
        + "\t\tconst timesUsed = await db.get(\"" + name + "\");\n"
        + "\t\tawait interaction.reply(\"" + output1 + "\" + timesUsed + \"" + output2 + "\");\n"
        + "\t},\n"
        + "};";

        const dirPath = "commands/utility/";
        const filePath = path.join(dirPath, name + ".js");
    
        if (!fs.existsSync(dirPath))
        {
            fs.mkdirSync(dirPath, {recursive: true});
        }
        fs.writeFileSync(filePath, out);
    }
    function randomCommand(name, output, description)
    {
        outputValues = JSON.stringify(output);

        let out =
        "const { SlashCommandBuilder } = require('discord.js');\n\n"
        + "module.exports = {\n"
        + "\t data: new SlashCommandBuilder()\n"
        + "\t\t.setName(\"" + name + "\")\n"
        + "\t\t.setDescription(\"" + description + "\"),\n"
        + "\tasync execute(interaction) {\n"
        + "\t\tlet output = " + outputValues + ";\n"
        + "\t\tlet ind = Math.floor(Math.random() * output.length);\n"
        + "\t\tlet val = output[ind];\n"
        + "\t\tawait interaction.reply( \"" + "\" + val + \"" + "\");\n"
        + "\t},\n"
        + "};";

        const dirPath = "commands/utility/";
        const filePath = path.join(dirPath, name + ".js");

        if (!fs.existsSync(dirPath))
        {
            fs.mkDirSync(dirPath, {recursive: true});
        }
        fs.writeFileSync(filePath, out);
    }
    function pictureCommand(name, output, url, description)
    {
        let out =
        "const { SlashCommandBuilder } = require('discord.js');\n\n"
        + "module.exports = {\n"
        + "\t data: new SlashCommandBuilder()\n"
        + "\t\t.setName(\"" + name + "\")\n"
        + "\t\t.setDescription(\"" + description + "\"),\n"
        + "\tasync execute(interaction) {\n"
        + "\t\tawait interaction.reply({\n"
        + "\t\t\tcontent: \"" + output + "\",\n"
        + "\t\t\tfiles: [\"" + url + "\" ]\n"
        + "\t\t});\n"
        + "\t},\n"
        + "};";

        const dirPath = "commands/utility/";
        const filePath = path.join(dirPath, name + ".js");

        if (!fs.existsSync(dirPath))
        {
            fs.mkDirSync(dirPath, {recursive: true});
        }
        fs.writeFileSync(filePath, out);
    }
%}

%start file /*this declares the start symbol*/

%% /*language grammar*/

file: init_block cmd_block start 
    {
        deploy($1.cli, $1.gui, $1.tok);
        begin($1.tok);
        /*console.log("Bot is online...");*/
        /*console.log("Ctrl + C to stop.");*/
    }
    | init_block start /*might change this but this is so you can boot a bot with no commands*/
    ;

cmd_block: T_COMMANDS T_COLON T_LBRACE commands T_RBRACE
         ;

commands: norm_cmd
        {
            normalCommand($1.name, $1.output, $1.description);           
            //console.log("In norm_cmd 1\n");
        }
        | commands norm_cmd
        {
            normalCommand($2.name, $2.output, $2.description);
            //console.log("In nom_cmd 2\n");
        }
        | count_cmd
        {
            countCommand($1.name, $1.output1, $1.output2, $1.description);
            //console.log("In count_cmd 1\n");
        }
        | commands count_cmd
        {
            countCommand($2.name, $2.output1, $2.output2, $2.description);
            //console.log("In count_cmd 2\n");
        }
        | rand_cmd
        {
            randomCommand($1.name, $1.output, $1.description);
            //console.log('In first rule for rand cmd');
        }
        | commands rand_cmd
        {
            randomCommand($2.name, $2.output, $2.description);
            //console.log('In second rule for rand cmd');
        }
        | pic_cmd
        {
            pictureCommand($1.name, $1.output, $1.url, $1.description);
           //console.log('In first rule for picture cmd');
        }
        | commands pic_cmd
        {
            pictureCommand($2.name, $2.output, $2.url, $2.description);
            //console.log('In second rule for picture cmd');
        }
        ;

norm_cmd: T_NORM T_PERIOD T_ID T_LPAREN T_STRING T_COMMA T_STRING T_RPAREN T_SEMIC 
    {
        $$ = {name: $3, output: $5, description: $7};
        //console.log('In first norm command rule');
    }
   | T_NORM T_PERIOD T_ID T_LPAREN T_STRING T_RPAREN T_SEMIC 
    {
        $$ = {name: $3, output: $5, descrption: ""};
    }
    ;

count_cmd: T_COUNT T_PERIOD T_ID T_LPAREN T_STRING T_COMMA T_STRING T_COMMA T_STRING T_RPAREN T_SEMIC
    {
        $$ = {name: $3, output1: $5, output2: $7, description: $9};
    }
    | T_COUNT T_PERIOD T_ID T_LPAREN T_STRING T_COMMA T_STRING T_RPAREN T_SEMIC
    {
        $$ = {name: $3, output1: $5, output2: $7, description: ""};
    }
    ;

rand_cmd: T_RAND T_PERIOD T_ID T_LPAREN set_of_strings T_COMMA T_STRING T_RPAREN T_SEMIC
    {
        $$ = {name: $3, output: $5, description: $7};
    }
    | T_RAND T_PERIOD T_ID T_LPAREN set_of_strings T_RPAREN T_SEMIC
    {
        $$ = {name: $3, output: $5, description: ""};
    }
    ;

pic_cmd: T_PICTURE T_PERIOD T_ID T_LPAREN T_STRING T_COMMA T_STRING T_COMMA T_STRING T_RPAREN T_SEMIC /*full thing*/
    {
        $$ = {name: $3, output: $5, url: $7, description: $9};
    }
    | T_PICTURE T_PERIOD T_ID T_LPAREN T_STRING T_COMMA T_STRING T_RPAREN T_SEMIC
    {
        $$ = {name: $3, output: $5, url: $7, description: $3};
    }
    ;

init_block: T_INIT T_COLON T_LBRACE token_init client_init guild_init T_RBRACE
            {
                $$ = {tok: $4, cli: $5, gui: $6};
            }
          ;

token_init: T_TOKEN T_ASSIGN T_STRING T_SEMIC 
            {
                let tokenPtr;
                tokenPtr = $3;
                /*console.log(tokenPtr);*/
                $$ = tokenPtr;
            }
            ;
client_init: T_CLIENT T_ASSIGN T_STRING T_SEMIC
             {
                let clientPtr;
                clientPtr = $3;
                /*console.log(clientPtr);*/
                $$ = clientPtr;
             }
             ;
guild_init:  T_GUILD T_ASSIGN T_STRING T_SEMIC
             {
                let guildPtr;
                guildPtr = $3;
                /*console.log(guildPtr);*/
                $$ = guildPtr;
             }
             ;

start: T_START T_SEMIC
    ;

set_of_strings: T_STRING T_STRING
            {
                let vector = [$1, $2]
                $$ = vector
            }
            | set_of_strings T_STRING
            {
                $1.push($2);
                $$ = $1;
            }
            ;

count_lines: T_NEWLINE {console.log("HIT THE END OF A LINE");line_number = line_number + 1;};

T_STRING: T_STRING_CONSTANT {$$ = yytext;} /*every string has to be run through this rule to make sure we save its value*/
        ;
T_ID: T_IDENTIFIER {$$ = yytext;} /* do the same thing with identifiers */
    ;
