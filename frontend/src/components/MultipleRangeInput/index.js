import { useRef, useState } from 'react';
import classname from 'classname';
import './index.css';


const MultipleRangeInput = ({ min = 0, max = 150, step = 25, defaultValues = [[0, 50], [50, 100]], colors, size }) => {

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

    if (!['xs', 'sm', 'md', 'lg'].includes(size)) {
        throw Error("Invalid value for `size` property");
    }

    const range = max - min;
    const ticks = Math.floor((max - min) / step) + 1;

    const [values, setValues] = useState(defaultValues);
    const handles = useRef(null);
    const pointerDown = useRef(false);

    const findNearestHandle = (value) => {
        const valuesFlatDiff = values.flat().map(v => v - value);
        const min = Math.min(...valuesFlatDiff.map(v => Math.abs(v)));
        const rightIndex = valuesFlatDiff.lastIndexOf(-min);
        const leftIndex = valuesFlatDiff.indexOf(min);
        return rightIndex !== -1 ? rightIndex : leftIndex;
    }

    const handleValues = (value) => {
        // Validate new value
        const i = +handles.current;
        const valuesFlat = values.flat();
        if (value < valuesFlat[i - 1] || valuesFlat[i + 1] < value) {
            return;
        }
        // Set new value
        setValues(prevValues => {
            const i1 = Math.floor(i / 2),
                i2 = i % 2;
            prevValues[i1][i2] = Math.round(value / step) * step;
            return [...prevValues];
        })
    }

    const handleInput = (e) => {
        const value = +e.target.value;
        if (pointerDown.current) {
            pointerDown.current = false;
            handles.current = findNearestHandle(value);
        }
        handleValues(value);
    }

    return <>
        <input type="range" className="range range-xs" step={step} defaultValue={defaultValues[0]} />
        <div className="w-full flex justify-between text-xs px-2">
            <span>|</span>
            <span>|</span>
            <span>|</span>
            <span>|</span>
            <span>|</span>
        </div>
        <div className={classname('mulrange', size && `mulrange-${size}`)}>
            <input className="mulrange-control range" type="range" min={min} max={max}
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
        <div className="select-none w-full flex justify-between text-xs px-2">
            {[...Array(ticks)].map((i) => <span key={i}>|</span>)}
        </div>

    </>;
}


export default MultipleRangeInput;