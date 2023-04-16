const registeredCommands = {
	ls: executeLs,
	cd: executeCd,
	cat: executeCat,
	mkdir: executeMkDir,
	rmdir: executeRmDir,
	echo: executeEcho,
	pwd: executePwd,
	clear: executeClear,
	touch: executeTouch,
	cp: executeCp,
	whoami: executeWhoami,
	rm: executeRm,
	mario: { runner: executeMario, hidden: true },
	deti: executeDeti,
};

function executeLs(args, state) { }
function executeCd(args, state) { }
function executeCat(args, state) { }
function executeMkDir(args, state) { }
function executeRmDir(args, state) { }
function executeEcho(args, state) {
	return args.join(" ");
}
function executePwd(args, state) {
	let path = state.cwd;

	if (path[0] == "~") {
		path = `/home/${state.user}` + path.substring(1);
	}

	return path;
}
function executeClear(args, state, fullOutput) {
	state.outputOffset = fullOutput.length + 1;
}
function executeTouch(args, state) { }
function executeCp(args, state) { }
function executeWhoami(args, state) {
	return state.user;
}
function executeRm(args, state) { }
function executeMario() {
	return `
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠴⠒⠚⠉⠉⠉⠓⠲⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⡠⠊⠁⠀⢀⢄⠒⢀⡠⢄⠀⠀⠈⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⠞⠁⠀⠀⢠⢁⣾⢷⡾⣿⡌⡆⠀⠀⠀⠈⢧⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢠⠏⠀⠀⠀⠀⠈⣸⣟⣀⣁⣙⣛⡇⠀⠀⠀⠀⠀⢳⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⡞⠀⠀⠀⢀⠄⠂⠉⢀⣀⣀⣀⠀⠈⠁⠂⢄⠀⠀⠀⢧⠀⠀⠀⠀⠀
⠀⠀⠀⠀⡇⠀⢀⠔⡡⢔⣨⣥⠔⠒⠒⠒⢲⣮⣥⣂⠄⠑⡄⠀⢸⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢳⠀⢘⢀⠔⠟⠋⡙⡣⠀⠀⠠⣛⣉⠉⠇⠑⢄⡰⠀⡸⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢠⠗⢌⢩⠀⠀⠂⣞⣢⠀⠀⢰⡚⣦⢡⠀⠀⠸⢡⠚⢧⠀⠀⠀⠀⠀
⠀⠀⠀⠀⢺⠈⣻⠀⡄⠀⠂⠻⠛⠉⠉⠉⠻⡟⠈⠀⠀⢦⢸⡁⢸⡆⠀⠀⠀⠀
⢀⡖⠒⢄⠘⢆⠈⡋⠁⣷⣦⡄⠀⠀⠀⠀⠀⢠⣴⣾⡆⠀⠋⢀⡼⡼⠉⠙⡄⠀
⠘⡆⠀⠸⡄⠈⠑⢷⠀⠉⠻⣿⣦⣀⣀⣀⣤⣿⡿⠋⠀⢀⠗⠋⠀⡇⠀⠀⡇⠀
⠀⢧⠀⠀⣇⣀⡀⠀⠳⣤⣀⠀⠀⠫⠍⠩⠍⠀⠀⣀⡴⠋⠀⡤⢤⡇⠀⢸⡃⠀
⡴⠉⠀⠀⠃⠀⠙⠲⠊⠙⠉⠹⠢⢄⣀⣀⡀⡔⠋⢻⠙⡲⠛⠃⠀⠁⠀⠈⠉⣆
⢧⠀⠀⠀⠀⠀⠀⠀⡇⠀⢀⠀⠀⢀⣀⣀⠀⠇⢀⡀⡀⡇⠀⠀⠀⠀⡀⠀⠀⡟
⠈⢣⣐⠘⠐⠀⠀⣠⣇⣿⣁⡱⠀⠀⠀⠀⠀⠀⣏⢉⣧⣰⢀⠀⠀⠃⠁⣁⠜⠁
⠀⠀⠈⠙⠒⠶⠶⠚⣟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠀⢻⠙⠒⠒⠚⠉⠁⠀⠀

        O mario vai ao enterro`;
}
function executeDeti() {
	return `Fato de treino do deti com os boys a girar no aquário
Tentei ir para a biblio mas não há espaço em nenhum lado
Acho que vou a recurso não sei programar eu tou lixado

Queria faina no parque, mas tenho exame marcado (bis)`;
}

function runCommand(cmdline, prevState, fullOutput) {
	let output = null;
	let state = { ...prevState };

	if (/\S/.test(cmdline)) {
		const [name, ...args] = cmdline
			.trim()
			.split(/(\s+)/)
			.filter((e) => e.trim().length > 0);

		const command = registeredCommands[name];

		if (!command) {
			output = `${name}: command not found`;
		} else {
			const runner = typeof command === "object" ? command.runner : command;
			output = runner(args, state, fullOutput);
		}
	}

	return {
		output,
		state,
	};
}

function availableCommands() {
	return Object.entries(registeredCommands)
		.filter(([key, value]) =>
			typeof value === "object" ? !value.hidden : true
		)
		.map(([key, value]) => key);
}

export { runCommand, availableCommands };
