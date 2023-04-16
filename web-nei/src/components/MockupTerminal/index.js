import { useEffect, useRef, useState } from "react";

import { useUserStore } from "stores/useUserStore";

import * as Emulator from "./emulator";
import "./index.css";

const terminalInput = {
    curr: 0,
    commands: [
        { original: "", mutated: null },
        { original: "ssh leand@ro", mutated: null },
        { original: "ls", mutated: null },
        { original: "cd lixo", mutated: null },
    ],
};

const initialOutput = [
    {
        type: "prompt",
        user: "guest",
        hostname: "aauav-nei",
        cwd: "~/lixo",
        cmdline: "cd lixo",
    },
    {
        type: "prompt",
        user: "guest",
        hostname: "aauav-nei",
        cwd: "~/lixo",
        cmdline: "ls",
    },
    { type: "output", output: "lixo2\nreadme.md\nsomething.sh" },
];
const initialState = {
    user: "guest",
    hostname: "aauav-nei",
    cwd: "~/lixo",
    outputOffset: 0,
};

const MockupTerminal = () => {
    const surname = useUserStore((state) => state.surname);

    const inputRef = useRef(null);
    const terminalRef = useRef(null);
    const [input, setInput] = useState(terminalInput);
    const [suggestion, setSuggestion] = useState("");
    const [output, setOutput] = useState(initialOutput);
    const [state, setState] = useState(initialState);

    const currMutated = input.commands[input.curr].mutated;
    const currCmdLine =
        currMutated != null ? currMutated : input.commands[input.curr].original;

    useEffect(() => {
        if (surname) {
            const oldState = { ...state };
            setOutput((output) => [
                ...output,
                {
                    type: "prompt",
                    user: oldState.user,
                    hostname: oldState.hostname,
                    cwd: oldState.cwd,
                    cmdline: `ssh ${surname}@nei`,
                },
                { type: "output", output: `${surname}@nei's password: ` },
            ]);
            setState((state) => ({
                ...state,
                user: surname,
                hostname: "nei",
                cwd: "~",
            }));
        }
    }, [surname]);

    useEffect(() => {
        const elem = inputRef.current;
        if (elem) {
            // Manually resize textarea input
            elem.style.height = "auto";
            elem.style.height = elem.scrollHeight + "px";
        }
        findSuggestions();
    }, [input]);

    useEffect(() => {
        const elem = terminalRef.current;
        if (elem) {
            // Manually scroll down
            elem.scrollTop = elem.scrollHeight;
        }
    }, [output]);

    const handleChange = (e) => {
        const target = e.target;
        const value = target.value;
        const commands = [...input.commands];
        commands[input.curr].mutated = value;
        setInput({ ...input, commands });
    };

    const setInputFocus = (e) => {
        // Focus textarea input if no text is being selected
        const isTextSelected = () => {
            const selection = window.getSelection();
            return selection && selection.type === "Range";
        };
        if (isTextSelected()) return;
        e.preventDefault();
        inputRef.current && inputRef.current.focus();
    };

    const handleFocus = () => {
        findSuggestions();
    };

    function newPrompt(cmdline = "") {
        return {
            type: "prompt",
            user: state.user,
            hostname: state.hostname,
            cwd: state.cwd,
            cmdline,
        };
    }

    const handleKeyDown = (e) => {
        if (e.key === "Enter") {
            executeCommand();
        } else if (e.key === "Tab") {
            const suggestions = findSuggestions();
            if (suggestions.length === 1) {
                const commands = [...input.commands];
                commands[input.curr].mutated += suggestion;
                setInput({ ...input, commands });
            } else if (suggestions.length > 1) {
                setOutput((output) => [
                    ...output,
                    newPrompt(currCmdLine),
                    {
                        type: "output",
                        output: suggestions.join(" "),
                    },
                ]);
            }
        } else if (e.key === "ArrowUp") {
            if (input.curr < input.commands.length - 1) {
                setInput((prevInput) => ({ ...prevInput, curr: prevInput.curr + 1 }));
            }
        } else if (e.key === "ArrowDown") {
            if (input.curr > 0) {
                setInput((prevInput) => ({ ...prevInput, curr: prevInput.curr - 1 }));
            }
        } else {
            return;
        }
        e.preventDefault();
    };

    const findSuggestions = () => {
        setSuggestion("");
        const lastCommand = currCmdLine.split(/(\s+)/).at(-1);
        if (!lastCommand) {
            return [];
        }
        const suggestions = Emulator.availableCommands().filter((cn) =>
            cn.startsWith(lastCommand)
        );
        if (suggestions.length === 1) {
            setSuggestion(suggestions.at(0).slice(lastCommand.length));
        }
        return suggestions;
    };

    const executeCommand = () => {
        const { output: cmdOutput, state: newState } = Emulator.runCommand(
            currCmdLine,
            state,
            output
        );

        // Update input
        const prevCommand =
            (input.curr != 1 && input.commands[1]?.mutated) ||
            input.commands[1]?.original;
        const commands = input.commands;
        commands[input.curr].mutated = null;
        if (currCmdLine && currCmdLine !== prevCommand) {
            commands[0] = { original: currCmdLine, mutated: null };
            commands.unshift({ original: "", mutated: null });
        }
        setInput({ curr: 0, commands });

        setOutput((prevOutput) => {
            const newOutput = [...prevOutput, newPrompt(currCmdLine)];

            if (cmdOutput) newOutput.push({ type: "output", output: cmdOutput });

            return newOutput;
        });

        setState(newState);
    };

    const prompt = (user, hostname, cwd) => (
        <>
            {user}@{hostname}:<span className="text-info">{cwd}</span>$
        </>
    );

    const identationChars = (user, hostname, cwd) =>
        (user + hostname + cwd).length + 4;

    return (
        <div
            className="mockup-terminal mockup-code font-mono leading-[22px]"
            onClick={setInputFocus}
        >
            <div
                ref={terminalRef}
                className="mockup-terminal-body h-96 overflow-hidden overflow-y-scroll px-[1.5rem]"
            >
                {output.slice(state.outputOffset).map(({ type, ...data }, i) => {
                    switch (type) {
                        case "prompt":
                            return (
                                <div key={i} className="relative text-success">
                                    <span className="absolute font-bold opacity-50">
                                        {prompt(data.user, data.hostname, data.cwd)}
                                    </span>
                                    <div
                                        className="min-h-[22px] w-full whitespace-pre-wrap break-all"
                                        style={{
                                            textIndent:
                                                identationChars(data.user, data.hostname, data.cwd) +
                                                "ch",
                                        }}
                                    >
                                        {data.cmdline}
                                    </div>
                                </div>
                            );
                        case "output":
                            return (
                                <div key={i} className="w-full whitespace-pre-wrap break-all">
                                    {data.output}
                                </div>
                            );
                    }
                })}
                <div className="relative text-success">
                    <span className="absolute font-bold opacity-50">
                        {prompt(state.user, state.hostname, state.cwd)}
                    </span>
                    <div
                        className="absolute w-full whitespace-pre-wrap break-all text-gray-50 opacity-25"
                        style={{
                            textIndent:
                                identationChars(state.user, state.hostname, state.cwd) + "ch",
                        }}
                    >
                        <span className="invisible">{currCmdLine}</span>
                        {suggestion}
                    </div>
                    <textarea
                        ref={inputRef}
                        rows={1}
                        className="w-full resize-none break-all bg-transparent outline-none"
                        style={{
                            textIndent:
                                identationChars(state.user, state.hostname, state.cwd) + "ch",
                        }}
                        autoFocus={true}
                        autoComplete="false"
                        autoCorrect="false"
                        spellCheck={false}
                        value={currCmdLine}
                        onChange={handleChange}
                        onKeyDownCapture={handleKeyDown}
                        onFocus={handleFocus}
                        onBlur={() => setSuggestion("")}
                    />
                </div>
            </div>
        </div>
    );
};

export default MockupTerminal;
