import { CommandMapping, EmulatorState, FileSystem, OutputFactory, defaultCommandMapping } from "javascript-terminal";

/*
const commands = {
    whoami: "nei-os",
    cd: (args) => `changed path to ${args}`,
    help: "list of commands: \n whoami \n cd \n help",
    rm: (args) => {
        if (args == "")
            return "usage: rm <name>"
        if (args == "/") {
            alert("YOU SHOULDN'T HAVE DONE THAT")
            window.open("https://cdn.discordapp.com/attachments/822074448961077260/848594704357392414/IMG_20210530_171126.jpg");
        }
        return "removed " + args;
    },
    ls: (args) => {
        return "";
    },
    cat: (args) => {
        return "";
        // dict, {filename, content}
    },
    mkdir: (args) => {
        return "";
    },
    echo: (args) => args,
    pwd: (args) => {
        return "";
    }
  }; */

const terminalstate = EmulatorState.create(
    {
        'commandMapping': CommandMapping.create(
            {
                "ls": defaultCommandMapping.ls,
                "cd": defaultCommandMapping.cd,
                "cat": defaultCommandMapping.cat,
                "mkdir": defaultCommandMapping.mkdir,
                "rmdir": defaultCommandMapping.rmdir,
                "echo": defaultCommandMapping.echo,
                "pwd": defaultCommandMapping.pwd,
                "clear": defaultCommandMapping.clear,
                "touch": defaultCommandMapping.touch,
                "cp": defaultCommandMapping.cp,
                "whoami": {
                    'function': (state, inpt) => {
                        return {
                            output: OutputFactory.makeTextOutput("nei-os")
                        };
                    },
                    'optDef': {}
                },
                "rm": {
                    'function': (state, inpt) => {
                        console.log(state)

                        if (inpt.length == 2 && inpt.includes("-r") && inpt.includes("/")) {
                            return {
                                output: OutputFactory.makeTextOutput("oops, site is dead (TODO)")
                            };
                        }
                        else
                            defaultCommandMapping.rm.function(state, inpt);
                    },
                    'optDef': {}
                },

                "comm": {
                    'function': (state, inpt) => {
                        

                        console.log(inpt);
                        return {
                            output: OutputFactory.makeTextOutput(inpt.join(" "))
                        };
                    },
                    'optDef': {
                        '-t, --test': "",
                        '-l': ""
                    }
                }
            }
        ),

        'fs': FileSystem.create(
            {
                '/home': {},
                '/home/README.md': {content: "blah blah"},
                '/home/public/file1': {content: "easter egg"},
                '/home/public/dir': {},
                '/home/.hidden/.secrets': {content: "Excel is a database"}
            }
        )
    }
)


/* 

/: 
    .hidden
        file1
        file2
        dir2
            file
        .secrets

    public
        file1 (vazio)
        file2 (vazio)
        file3 (vazio)

    README.md

*/

/* 
TODO 
autocomplete
descobrir how to use \n
(optional)
criar ficheiros (touch ou echo com >)
piping
*/


export default terminalstate;