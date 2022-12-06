import { style } from '@mui/system';
import { default as React_countdown, zeroPad } from 'react-countdown';

export const Countdown_section = (props) => {
    const today = Date.now();
    const start = new Date('2022-12-07T19:00:00')
    // get the difference in date format
    const diff = start - today;
    const dateDiff = Date.now() + diff;

    return (
        <React_countdown date={dateDiff} renderer={({ days, hours, minutes, seconds, completed }) => {
            if (completed) {
                props.countdown_callback();
                return <span></span>;
            } else {
                return <div className='d-flex justify-content-around col-12' style={{ height: '80vh', alignItems: 'center' , fontFamily: 'Azeret Mono'}}>
                    <div className='mt-3 px-1'>
                        <h2 className='text-center'>{zeroPad(days)}</h2>
                        <p className='m-auto' style={{ width: 'fit-content' }}>Days</p>
                    </div>
                    <h2 style={{ width: 'fit-content'}} className='px-0 d-block'>:</h2>
                    <div className='mt-3 px-0'>
                        <h2 className='text-center'>{zeroPad(hours)}</h2>
                        <p className='m-auto' style={{ width: 'fit-content' }}>Hours</p>
                    </div>
                    <h2 style={{ width: 'fit-content' }} >:</h2>
                    <div className='mt-3 px-0'>
                        <h2 className='text-center'>{zeroPad(minutes)}</h2>
                        <p className='m-auto' style={{ width: 'fit-content' }}>Minutes</p>
                    </div>
                    <h2 style={{ width: 'fit-content' }}>:</h2>
                    <div className='mt-3 px-0'>
                        <h2 className='text-center'>{zeroPad(seconds)}</h2>
                        <p className='m-auto' style={{ width: 'fit-content' }}>Seconds</p>
                    </div>
                </div>;
               
            }
        }} />
    );
}