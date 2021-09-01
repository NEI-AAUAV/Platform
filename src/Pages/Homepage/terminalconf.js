import { CommandMapping, EmulatorState, FileSystem, OutputFactory, defaultCommandMapping, Outputs, hasFile } from "javascript-terminal";

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
                "./pimpneiwebsite.bin": {
                    'function': (state, inpt) => {
                        
                        // TODO: check if working directory is '/public/programs'
                        // TODO: mudar partículas do fundo para something silly tipo ඞ

                        /* //a minha tentativa de verificar o working directory,
                           //por alguma razão retorna no terminal o erro "emulator: Unhandled command error"
                        console.log(state.getFileSystem())
                        let out = "";

                        if (hasFile(state.getFileSystem(), "./pimpneiwebsite.bin")) {
                            var root = document.getElementById("root");
                            root.style.fontFamily = "'Comic Sans MS', fantasy";
                            root.style.color = "deeppink";
                            out ="cool mode activated B)";
                        }
                        else {
                            out = "File not found";
                        }

                        return {
                            output: OutputFactory.makeTextOutput(out)
                        };
                        */

                        var root = document.getElementById("root");
                        root.style.fontFamily = "'Comic Sans MS', fantasy";
                        root.style.color = "deeppink";

                        return {
                            output: OutputFactory.makeTextOutput("cool mode activated B)")
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
                '/': {},
                '/README.md': {content: "Welcome to the NEI website!\nCheck back in the future for some hidden secrets!"},
                '/public/file1': {content: "easter egg"},
                '/public/file2': {content: "christmas egg"},
                '/public/important': {content: "01010010 01101001 01100011 01101011\n00100000 01010010 01101111 01101100\n01101100 00111010 00100000 01101000\n01110100 01110100 01110000 01110011\n00111010 00101111 00101111 01110111\n01110111 01110111 00101110 01111001\n01101111 01110101 01110100 01110101\n01100010 01100101 00101110 01100011\n01101111 01101101 00101111 01110111\n01100001 01110100 01100011 01101000\n00111111 01110110 00111101 01111001\n01010000 01011001 01011010 01110000\n01110111 01010011 01110000 01001011\n01101101 01000001"},
                '/public/pimpneiwebsite.bin': {content: "Cannot read file"},
                '/.hidden/.secrets': {content: "Excel is a database"},
                '/.hidden/.confidential': {content: "Access Denied\nThe authorities have been notified."}
            }
        ),

        'outputs': newOutputs
    }
)

export default terminalstate;