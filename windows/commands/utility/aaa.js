const { SlashCommandBuilder } = require('discord.js');
const { QuickDB } = require ('quick.db');
const db = new QuickDB();

module.exports = {
	 data: new SlashCommandBuilder()
		.setName("aaa")
		.setDescription("Counts something"),
	async execute(interaction) {
		const exists = await db.has("aaa");
		if (!exists) { await db.set("aaa", 0) }
		await db.add("aaa", 1);

		const timesUsed = await db.get("aaa");
		await interaction.reply("this command has been called " + timesUsed + " times");
	},
};