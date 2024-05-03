const { SlashCommandBuilder } = require('discord.js');

module.exports = {
	 data: new SlashCommandBuilder()
		.setName("pic")
		.setDescription("description"),
	async execute(interaction) {
		await interaction.reply({
			content: "here is a picture:",
			files: ["https://nypost.com/wp-content/uploads/sites/2/2024/04/phoenix-suns-forward-kevin-durant-80890182.jpg?w=1024" ]
		});
	},
};