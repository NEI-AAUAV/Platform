import { sample } from "lodash";

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

function executeLs(args, state) {
  return sample([
    "Hmm, let's see... Nope, there's nothing here. Sorry, not sorry.",
    "You're looking for files, but have you considered looking for inner peace instead?",
    "404: Files not found. Looks like someone's been a little too tidy around here.",
    "I would give you a list of files, but then I would have to kill -9 you.",
    "These are not the files you're looking for. Move along, move along.",
  ]);
}

function executeCd(args, state) {
  state.cwd = sample([
    "~",
    "/",
    "/dev/null/abyss",
    "/home/spongebob/pineapple",
    "/usr/local/pub",
    "/boot/grub",
    "/var/empty/soul",
  ]);
}

function executeCat(args, state) {
  return sample([
    "Meow! Sorry, I couldn't find any files to read. Maybe try again with a different command?",
    "I'm sorry, Dave. I'm afraid I can't let you do that. Oh wait, wrong movie. But seriously, there's nothing to see here.",
    "Looks like the cat got your files. Time to start over.",
    "All your files are belong to us... just kidding, there's nothing to see here.",
    "No files found. Maybe try uploading some cat pictures instead?",
  ]);
}

function executeMkDir(args, state) {
  if (!args[0]) return "mkdir: missing operand";

  return (
    "mkdir: " +
    sample([
      `Unable to create directory '${args[0] || ""}'. Maybe your computer is allergic to new folders?`,
      `Error: Cannot create directory '${args[0] || ""}'. The hamsters powering this computer are on strike.`,
      `Sorry, Dave. I'm afraid I can't let you create that directory. It's against my programming.`,
      `Whoops, looks like your folder creation license has expired. Please renew and try again.`,
      `Creating directory '${args[0] || ""}'... just kidding, it's opposite day. No directory for you!`,
    ])
  );
}

function executeRmDir(args, state) {
  if (!args[0]) return "rmdir: missing operand";

  return (
    "rmdir: " +
    sample([
      `Unable to remove directory '${args[0] || ""}'. The files inside it are too busy having fun.`,
      `Error: Cannot remove directory '${args[0] || ""}'. It has become sentient and is refusing to leave.`,
      `Sorry, Dave. I'm afraid I can't let you delete that directory. It's grown too attached to its files.`,
      `Whoops, looks like the directory you're trying to remove is still being used as a secret hideout for squirrels.`,
      `Deleting directory '${args[0] || ""}'... just kidding, it's opposite day. That directory is staying put!`,
    ])
  );
}

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

function executeTouch(args, state) {
  if (!args[0]) return;

  return (
    "touch: " +
    sample([
      `Error: Cannot touch file '${args[0] || ""}'. Your fingers are too cold and the computer can't feel them.`,
      `Unable to create file '${args[0] || ""}'. The computer is allergic to your typing skills.`,
      `Sorry, Dave. I'm afraid I can't let you touch that file. It's too hot to handle.`,
      `Whoops, looks like the file you're trying to create already exists in a parallel universe.`,
      `Touching file '${args[0] || ""}'... just kidding, it's opposite day. That file is untouchable!`,
    ])
  );
}

function executeCp(args, state) {
  if (!args[0]) return "cp: missing operand";

  return (
    "cp: " +
    sample([
      `Error: Cannot copy file '${args[0] || ""}'. It's too clingy and won't let go of its original location.`,
      `Unable to copy file '${args[0] || ""}'. The computer is allergic to duplicates.`,
      `Sorry, Dave. I'm afraid I can't let you copy that file. It's protected by a jealous firewall.`,
      `Whoops, looks like the file you're trying to copy is already on its way to the Bermuda Triangle.`,
      `Copying file '${args[0] || ""}'... just kidding, it's opposite day. That file is going nowhere!`,
    ])
  );
}

function executeWhoami(args, state) {
  return state.user;
}

function executeRm(args, state) {
  if (!args[0]) return "rm: missing operand";

  return (
    "rm: " +
    sample([
      `Error: Cannot remove file '${args[0] || ""}'. It has become self-aware and is refusing to leave.`,
      `Unable to delete file '${args[0] || ""}'. The computer has developed an attachment to it.`,
      `Sorry, Dave. I'm afraid I can't let you delete that file. It's the last unicorn of the digital realm.`,
      `Whoops, looks like the file you're trying to delete has been classified as a national treasure.`,
      `Deleting file '${args[0] || ""}'... just kidding, it's opposite day. That file is here to stay!`,
    ])
  );
}

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
