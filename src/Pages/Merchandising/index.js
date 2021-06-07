import React, { useEffect, useState } from "react";
import {fs} from "fs";

import {Container, Row, Col} from 'react-bootstrap';

const Merchandising = () => {

    const [imgs,setImgs] = useState([]);

    useEffect(() => {
        //const pathName = "../../../public/images/merch/";
        var arr = [];
        const fs = require('fs');
        // const files = fs.readdirSync(pathName)

        // //console.log("sus:"+tree);

        // fs.readdir(pathName, (err, files) => {
        //     if (err) {
        //         return console.log("és cringe");
        //     }

        //     files.forEach((file) => {
        //         console.log(file);
        //     })
        // })

    }, [])

    return (
        <div>
            <h2 className="mb-5 text-center">Merchandising</h2>

        </div>
    ); 
}

export default Merchandising;