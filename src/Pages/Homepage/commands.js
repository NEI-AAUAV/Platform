const commands = {
    whoami: "nei-os",
    cd: (args) => `changed path to ${args}`,
    help: "list of commands: \n whoami \n cd \n help",
    rm: (args) => {
        if (args == "")
            return "usage: rm <name>"
        if (args == "/") {
            alert("YOU SHOULDN'T HAVE DONE THAT")
            window.open("https://i.ytimg.com/vi/CUT09UP6yo0/maxresdefault.jpg");
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
  };

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


export default commands;