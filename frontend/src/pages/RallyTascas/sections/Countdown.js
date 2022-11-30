import { default as React_countdown, zeroPad } from 'react-countdown';

const renderer = ({ days, hours, minutes, seconds, completed }) => {
    if (completed) {
        return <span></span>;
    } else {
        return <div className='d-flex justify-content-around col-8 position-absolute '>
            <h1>{zeroPad(days)}</h1>
            <h1>:</h1>
            <h1>{zeroPad(hours)}</h1>
            <h1>:</h1>
            <h1>{zeroPad(minutes)}</h1>
            <h1>:</h1>
            <h1>{zeroPad(seconds)}</h1>
        </div>;

    }
};
export const Countdown_section = () => {
    return (
        <React_countdown date={Date.now() + 1000000} renderer={renderer} />
    );
}