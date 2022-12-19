import { useRef, useState, useEffect } from 'react';
import './index.css';

const MockupTerminal = () => {
    const prefix = "guest@aauav-nei:~$";

    const inputRef = useRef(null);
    const [command, setCommnad] = useState(["dfsdfds", "lkdfjsf", "wfdsf"]);

    const handleInput = (e) => {
        const { type, key, target } = e;
        const value = target.value;

        console.log('adeus', e)
        if (type === "keydown") {
            if (key === "Backspace" && value === ""
                && command.length > 1 && command.at(-1) === "") {
                // Remove additional input when latter is empty
                console.log(command, [...command.slice(0, -1)])
                setCommnad(prevCommand => [...prevCommand.slice(0, -1)]);
                return;
            }
        }

        console.log(target.scrollWidth, 'f', target.offsetWidth)

        setCommnad(prevCommand => {
            if (target.scrollWidth > target.offsetWidth) {
                // Add input when latter is full
                prevCommand.push(value.at(-1));
            } else {
                // Update latter input
                prevCommand[prevCommand.length - 1] = value;
            }
            return [...prevCommand];
        });
    }

    const isTextSelected = () => {
        const selection = window.getSelection();
        return selection && selection.type === 'Range';
    }

    const setInputFocus = (e) => {
        return;
        if (isTextSelected()) return;
        e.preventDefault();
        inputRef.current && inputRef.current.focus();
    };

    const handleInput2 = () => {

    }

    return (
        <>
        
        <div className="mockup-terminal mockup-code" onClick={setInputFocus}>
            <pre data-prefix="$"><code>npm i daisyui</code></pre>
            <pre data-prefix=">" className="text-warning"><code>installing...</code></pre>
            <pre data-prefix=">" className="text-success"><code>Done!</code></pre>
            {
                command.slice(0, -1).map((c, i) =>
                    <pre key={i} data-prefix={i === 0 ? prefix : null} className="text-success">
                        <code>{c}</code>
                    </pre>
                )
            }
            <pre data-prefix={command.length > 1 ? null : prefix} className="text-success">
                <code>{command.at(-1)}</code>
                <input ref={inputRef} autoFocus type="text" spellCheck="false" className='w-[1ch] outline-none bg-transparent'
                   value={command.at(-1)} onChange={handleInput} onKeyDown={handleInput} />
            </pre>
            <textarea spellCheck={false} className='px-[1.5rem] resize-none outline-none bg-transparent w-full'
             value={""} onChange={handleInput2}>
                sdf
            </textarea>
        </div >
        </>
    );
}

export default MockupTerminal;
