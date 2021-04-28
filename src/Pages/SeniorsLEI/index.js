import React from 'react'

import Tabs from "../../Components/Tabs/index.js"

const SeniorsLEI = () => {
    return(
        <div>
            <h1 id="title">Finalistas de Licenciatura</h1>

            <Tabs tabs={[200, 100]} _default={100} onChange={() => {}} />
        </div>
    )
}

export default SeniorsLEI;