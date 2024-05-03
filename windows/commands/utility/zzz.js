const { SlashCommandBuilder } = require('discord.js');

module.exports = {
	 data: new SlashCommandBuilder()
		.setName("zzz")
		.setDescription("outputs a random string"),
	async execute(interaction) {
		let output = ["one possible string","second string","third string"];
		let ind = Math.floor(Math.random() * output.length);
		let val = output[ind];
		await interaction.reply( "" + val + "");
	},
};