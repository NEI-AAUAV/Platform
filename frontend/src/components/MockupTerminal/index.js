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


const commandNames = ['ls', 'cd', 'cat', 'mkdir', 'rmdir', 'echo', 'pwd', 'clear', 'touch', 'cp', 'whoami', 'rm'];

const MockupTerminal = () => {
    const inputRef = useRef(null);
    const terminalRef = useRef(null);
    const [suggestion, setSuggestion] = useState("");
    const [history, setHistory] = useState(terminalHistory);
    const [command, setCommnad] = useState("");

    useEffect(() => {
        const elem = inputRef.current;
        if (elem) {
            // Manually resize textarea input
            elem.style.height = 'auto';
            elem.style.height = elem.scrollHeight + 'px';
        }
        findSuggestion();
    }, [command])

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
        setCommnad(value);
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
        findSuggestion();
    }

    const handleKeyDown = (e) => {
        if (e.key === 'Enter') {
            e.preventDefault();
            executeCommand();
        } else if (e.key === 'Tab') {
            e.preventDefault();
            setCommnad(prevCommand => prevCommand + suggestion);
        }
    }

    const findSuggestion = () => {
        const lastCommand = command.split(/(\s+)/).at(-1);
        if (!lastCommand) {
            setSuggestion("");
            return;
        }
        for (const cn of commandNames) {
            if (cn.startsWith(lastCommand)) {
                setSuggestion(cn.slice(lastCommand.length));
                return;
            }
        }
        setSuggestion("");
    }

    const executeCommand = () => {
        setHistory(prevHistory => {
            const { user, device, path } = prevHistory.at(-1);
            const firstCommand = command.trim().split(/(\s+)/).at(0);
            const history = [...prevHistory, {
                user, device, path, command,
                output: [firstCommand && !commandNames.includes(firstCommand) ? `${firstCommand}: command not found` : ""]
            }];
            setCommnad("");
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
            <div ref={terminalRef} className='max-h-96 overflow-hidden overflow-y-scroll mockup-terminal-body px-[1.5rem]'>
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
                        <span className='invisible'>{command}</span>
                        {suggestion}
                    </div>
                    <textarea ref={inputRef} rows={1} className='w-full break-all bg-transparent resize-none outline-none'
                        style={{ textIndent: identationChars('leand', 'ro', '~') + 'ch' }}
                        autoFocus={true} autoComplete="false" autoCorrect="false" spellCheck={false}
                        value={command} onChange={handleChange} onKeyDownCapture={handleKeyDown}
                        onFocus={handleFocus} onBlur={() => setSuggestion("")} />
                </div>
            </div>
        </div>
    );
}

export default MockupTerminal;
