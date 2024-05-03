const { SlashCommandBuilder } = require('discord.js');

module.exports = {
	 data: new SlashCommandBuilder()
		.setName("abc")
		.setDescription("undefined"),
	async execute(interaction) {
		await interaction.reply( "def");
	},
};