import { useRef, useState } from 'react';
import classname from 'classname';
import './index.css';


const MultipleRangeInput = ({ min = 0, max = 150, step = 25, defaultValues = [[0, 50], [50, 100]], color, size }) => {

    const defaultValuesFlat = defaultValues.flat();
    if (!defaultValuesFlat.length || defaultValuesFlat.length % 2 !== 0) {
        throw Error("The `defaultValues` property must be an array with a pair number of elements");
    }
    for (let i = 1; i < defaultValuesFlat.length; i++) {
        const sep = defaultValuesFlat[i] - defaultValuesFlat[i - 1];
        if (sep < 0 || sep % step !== 0) {
            throw Error("The `defaultValues` property must have values in order and separated with a multiple of `step`");
        }
    }

    if (size && !['xs', 'sm', 'md', 'lg'].includes(size)) {
        throw Error("Invalid value for `size` property");
    }

    if (color && !['primary', 'secondary', 'accent', 'success', 'warning', 'info', 'error'].includes(color)) {
        throw Error("Invalid value for `color` property");
    }

    const range = max - min;
    const ticks = Math.floor((max - min) / step) + 1;

    const [values, setValues] = useState(defaultValues);
    const handles = useRef([]);
    const pointerDown = useRef(false);

    const findNearestHandles = (value) => {
        const valuesFlatDiff = values.flat().map(v => Math.abs(v - value));
        const min = Math.min(...valuesFlatDiff);
        return valuesFlatDiff.reduce((a, e, i) => (e === min) ? a.concat(i) : a, []);
    }

    const handleValues = (value) => {
        const newValue = Math.round(value / step) * step;
        // Iterate through possible handles
        for (const i of handles.current) {
            // Validate new value
            const valuesFlat = values.flat();
            if (value < valuesFlat[i - 1] || valuesFlat[i + 1] < value) {
                continue;
            }
            // Ignore unchanged value
            const i1 = Math.floor(i / 2),
                i2 = i % 2;
            if (values[i1][i2] === newValue) {
                break;
            }
            // Set new value
            setValues(prevValues => {
                prevValues[i1][i2] = newValue;
                return [...prevValues];
            });
            // Update possible handles to a fixed handle
            handles.current = [i];
            break;
        }
    }

    const handleInput = (e) => {
        const value = +e.target.value;
        // First call
        if (pointerDown.current) {
            pointerDown.current = false;
            // Set possible handles
            handles.current = findNearestHandles(value);
        }
        handleValues(value);
    }

    return <>
        <div className={classname('mulrange', size && `mulrange-${size}`, color && `mulrange-${color}`)}>
            <input className={classname('mulrange-control range', size && `range-${size}`)} type="range" min={min} max={max}
                onInput={handleInput} onPointerDown={() => { pointerDown.current = true }} />
            <div className='mulrange-slider'></div>
            <div className='mulrange-ranges'>
                {values.map(([v1, v2], i) =>
                    <div key={i} style={{ left: `${v1 / range * 100}%`, width: `${(v2 - v1) / range * 100}%` }}></div>
                )}
            </div>
            <div className='mulrange-handles'>
                {values.flat().map((v, i) =>
                    <div key={i} style={{ left: `${v / range * 100}%` }}></div>
                )}
            </div>
        </div>
        <div className="select-none w-full flex justify-between text-xs p-2">
            {[...Array(ticks)].map((i) => <span key={i}>|</span>)}
        </div>
    </>;
}


export default MultipleRangeInput;