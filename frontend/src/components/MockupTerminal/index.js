import { useRef, useState } from 'react';
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


const MockupTerminal = () => {
    const inputRef = useRef(null);
    const [history, setHistory] = useState(terminalHistory);
    const [command, setCommnad] = useState("");

    const handleInput = (e) => {
        const target = e.target;
        const value = target.value;

        setCommnad(value.trim());

        target.style.height = 'auto';
        target.style.height = target.scrollHeight + 'px';
    }

    const setInputFocus = (e) => {
        const isTextSelected = () => {
            const selection = window.getSelection();
            return selection && selection.type === 'Range';
        }
        if (isTextSelected()) return;
        e.preventDefault();
        inputRef.current && inputRef.current.focus();
    }

    const executeCommand = () => {
        setCommnad("");
        const { user, device, path } = history.at(-1);
        setHistory([...history, {
            user, device, path, command,
            output: [command ? `${command}: command not found` : ""]
        }]);
    }

    const prompt = (user, device, path) => {
        return <>{user}@{device}:<span className='text-info'>{path}</span>$</>;
    }

    return (
        <div className="mockup-terminal mockup-code font-mono" onClick={setInputFocus}>
            <div className='max-h-96 overflow-auto mockup-terminal-body px-[1.5rem]'>
                {
                    history.map(({ user, device, path, command, output }, i) =>
                        <div key={i} className='text-success'>
                            <span className='font-bold opacity-50 pr-[1ch]'>{prompt(user, device, path)}</span>
                            <span>{command}</span>
                            {
                                output.map((out, i) => <span key={i} className='block'>{out}</span>)
                            }
                        </div>
                    )
                }
                <div className='text-success relative'>
                    <span className='font-bold opacity-50 absolute'>{prompt('leand', 'ro', '~')}</span>
                    <textarea ref={inputRef} className='w-full bg-transparent resize-none outline-none'
                        style={{ textIndent: `${('leand' + 'ro' + '~').length + 4}ch` }}
                        autoFocus={true} autoComplete="false" autoCorrect="false" spellCheck={false}
                        value={command} onChange={handleInput}
                        onKeyDown={(e) => e.key === 'Enter' && executeCommand()} />
                </div>
            </div>
        </div>
    );
}

export default MockupTerminal;
