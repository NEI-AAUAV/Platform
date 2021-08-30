import { CommandMapping, EmulatorState, FileSystem, OutputFactory, defaultCommandMapping, Outputs } from "javascript-terminal";

// TODO: update prompt with current working directory,
//       more easter eggs


const defaultState = EmulatorState.createEmpty();
    const defaultOutputs = defaultState.getOutputs();

    const newOutputs = Outputs.addRecord(
      defaultOutputs, OutputFactory.makeTextOutput(
        "Welcome to the hacker zone! "
      )
    );


const terminalstate = EmulatorState.create(
    {
        'commandMapping': CommandMapping.create(
            {
                "ls": defaultCommandMapping.ls,
                "cd": defaultCommandMapping.cd,
                "cat": {
                    'function': (state, inpt) => {
                        if (inpt.includes("flag.txt")) {
                            return {
                                output: OutputFactory.makeTextOutput("UAC{g00d_0ld_flag.txt}")
                            };
                        }
                        else
                            return defaultCommandMapping.cat.function(state, inpt);
                    },
                    'optDef': defaultCommandMapping.cat.optDef
                },
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
                        if (inpt.length == 2 && inpt.includes("-r") && inpt.includes("/")) {
                            // TODO

                            var root = document.getElementById("root");
                            root.innerHTML = "Uh oh!<br/>What have you done!?";
                            root.style.height = "100vw";
                            root.style.backgroundColor = "black";
                            root.style.color = "white";
                            root.style.fontFamily = "monospace";

                            return {
                                output: OutputFactory.makeTextOutput("oops, site is dead (TODO)")
                            };
                        }
                        else
                            return defaultCommandMapping.rm.function(state, inpt);
                    },
                    'optDef': defaultCommandMapping.rm.optDef
                },
                /*
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
                }*/
            }
        ),

        'fs': FileSystem.create(
            {
                '/': {},
                '/README.md': {content: "Welcome to the NEI website!\nCheck back in the future for some hidden secrets!"},
                '/public/file1': {content: "easter egg"},
                '/public/file2': {content: "christmas egg"},
                '/public/important': {content: "01010010 01101001 01100011 01101011\n00100000 01010010 01101111 01101100\n01101100 00111010 00100000 01101000\n01110100 01110100 01110000 01110011\n00111010 00101111 00101111 01110111\n01110111 01110111 00101110 01111001\n01101111 01110101 01110100 01110101\n01100010 01100101 00101110 01100011\n01101111 01101101 00101111 01110111\n01100001 01110100 01100011 01101000\n00111111 01110110 00111101 01111001\n01010000 01011001 01011010 01110000\n01110111 01010011 01110000 01001011\n01101101 01000001"},
                '/public/programs/README.md': {content: "Work in progress, check back later!"},
                '/.hidden/.secrets': {content: "Excel is a database"},
                '/.hidden/.confidential': {content: "Access Denied\nThe authorities have been notified."}
            }
        ),

        'outputs': newOutputs
    }
)

export default terminalstate;