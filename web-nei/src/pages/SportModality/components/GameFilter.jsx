import './GameFilter.css';

const GameFilter = (props) => {
    return (
        <div className='game-filter'>
            <p>{props.text}</p>
        </div>
    )
}

export default GameFilter;