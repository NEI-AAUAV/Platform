import { useEffect, useRef, useState } from 'react';
import classname from 'classname';
import './index.css';

const terminalHistory = [
    {
        user: "guest",
        device: "aauav-nei",
        path: "~",
        command: "cd lixo",
        output: []
    },
    {
        user: "guest",
        device: "aauav-nei",
        path: "~/lixo",
        command: "ls",
        output: ["lixo2", "readme.md", "something.sh"]
    },
    {
        user: "guest",
        device: "aauav-nei",
        path: "~/lixo",
        command: "ssh leand@ro",
        output: ["leand@ro's password: "]
    },
    {
        user: "leand",
        device: "ro",
        path: "~",
        command: "",
        output: []
    },
];

const terminalInput = {
    curr: 0,
    commands: [
        { original: "", mutated: null },
        { original: "ssh leand@ro", mutated: null },
        { original: "ls", mutated: null },
        { original: "cd lixo", mutated: null },
    ]
};

const commandNames = ['ls', 'cd', 'cat', 'mkdir', 'rmdir', 'echo', 'pwd', 'clear', 'touch', 'cp', 'whoami', 'rm'];

const MockupTerminal = () => {
    const inputRef = useRef(null);
    const terminalRef = useRef(null);
    const [input, setInput] = useState(terminalInput);
    const [suggestion, setSuggestion] = useState("");
    const [history, setHistory] = useState(terminalHistory);

    const currMutated = input.commands[input.curr].mutated;
    const currCommand = currMutated != null ? currMutated : input.commands[input.curr].original;

    useEffect(() => {
        const elem = inputRef.current;
        if (elem) {
            // Manually resize textarea input
            elem.style.height = 'auto';
            elem.style.height = elem.scrollHeight + 'px';
        }
        findSuggestions();
    }, [input])

    useEffect(() => {
        const elem = terminalRef.current;
        if (elem) {
            // Manually scroll down
            elem.scrollTop = elem.scrollHeight;
        }
    }, [history])

    const handleChange = (e) => {
        const target = e.target;
        const value = target.value;
        const commands = [...input.commands];
        commands[input.curr].mutated = value;
        setInput({ ...input, commands });
    }

    const setInputFocus = (e) => {
        // Focus textarea input if no text is being selected
        const isTextSelected = () => {
            const selection = window.getSelection();
            return selection && selection.type === 'Range';
        }
        if (isTextSelected()) return;
        e.preventDefault();
        inputRef.current && inputRef.current.focus();
    }

    const handleFocus = () => {
        findSuggestions();
    }

    const handleKeyDown = (e) => {
        if (e.key === 'Enter') {
            executeCommand();
        } else if (e.key === 'Tab') {
            const suggestions = findSuggestions();
            if (suggestions.length === 1) {
                const commands = [...input.commands];
                commands[input.curr].mutated += suggestion;
                setInput({ ...input, commands });
            } else if (suggestions.length > 1) {
                setHistory(prevHistory => {
                    const { user, device, path } = prevHistory.at(-1);
                    const history = [...prevHistory, {
                        user, device, path,
                        command: currCommand,
                        output: suggestions
                    }];
                    return history;
                });
            }
        } else if (e.key === 'ArrowUp') {
            if (input.curr < input.commands.length - 1) {
                setInput(prevInput => ({ ...prevInput, curr: prevInput.curr + 1 }));
            }
        } else if (e.key === 'ArrowDown') {
            if (input.curr > 0) {
                setInput(prevInput => ({ ...prevInput, curr: prevInput.curr - 1 }));
            }
        } else {
            return;
        }
        e.preventDefault();
    }

    const findSuggestions = () => {
        setSuggestion("");
        const lastCommand = currCommand.split(/(\s+)/).at(-1);
        if (!lastCommand) {
            return [];
        }
        const suggestions = commandNames
            .filter(cn => cn.startsWith(lastCommand));
        if (suggestions.length === 1) {
            setSuggestion(suggestions.at(0).slice(lastCommand.length));
        }
        return suggestions;
    }

    const executeCommand = () => {
        setHistory(prevHistory => {
            const { user, device, path } = prevHistory.at(-1);
            const firstCommand = currCommand.trim().split(/(\s+)/).at(0);
            const history = [...prevHistory, {
                user, device, path,
                command: currCommand,
                output: [firstCommand && !commandNames.includes(firstCommand) ? `${firstCommand}: command not found` : ""]
            }];

            // Update input
            const prevCommand = (input.curr != 1 && input.commands[1]?.mutated) || input.commands[1]?.original;
            const commands = input.commands;
            commands[input.curr].mutated = null;
            if (currCommand && (currCommand !== prevCommand)) {
                commands[0] = { original: currCommand, mutated: null };
                commands.unshift({ original: "", mutated: null });
            }
            setInput({ curr: 0, commands });

            return history;
        });
    }

    const prompt = (user, device, path) => (
        <>{user}@{device}:<span className='text-info'>{path}</span>$</>
    )

    const identationChars = (user, device, path) => (
        (user + device + path).length + 4
    )

    return (
        <div className="mockup-terminal mockup-code font-mono leading-[22px]" onClick={setInputFocus}>
            <div ref={terminalRef} className='h-80 overflow-hidden overflow-y-scroll mockup-terminal-body px-[1.5rem]'>
                {
                    history.map(({ user, device, path, command, output }, i) =>
                        <div key={i} className='text-success relative'>
                            <span className='font-bold opacity-50 absolute'>{prompt(user, device, path)}</span>
                            <div className='w-full break-all whitespace-pre-wrap min-h-[22px]'
                                style={{ textIndent: identationChars(user, device, path) + 'ch' }}>
                                {command}
                            </div>
                            <div className='w-full break-all whitespace-pre-wrap'>
                                {output.join('\n')}
                            </div>
                        </div>
                    )
                }
                <div className='text-success relative'>
                    <span className='font-bold opacity-50 absolute'>{prompt('leand', 'ro', '~')}</span>
                    <div className='w-full break-all whitespace-pre-wrap opacity-25 absolute text-gray-50'
                        style={{ textIndent: identationChars('leand', 'ro', '~') + 'ch' }}>
                        <span className='invisible'>{currCommand}</span>
                        {suggestion}
                    </div>
                    <textarea ref={inputRef} rows={1} className='w-full break-all bg-transparent resize-none outline-none'
                        style={{ textIndent: identationChars('leand', 'ro', '~') + 'ch' }}
                        autoFocus={true} autoComplete="false" autoCorrect="false" spellCheck={false}
                        value={currCommand} onChange={handleChange} onKeyDownCapture={handleKeyDown}
                        onFocus={handleFocus} onBlur={() => setSuggestion("")} />
                </div>
            </div>
        </div>
    );
}

export default MockupTerminal;
