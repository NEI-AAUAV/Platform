<?php 

    // This script gathers response related code, to avoid code duplication

    /**
     * This function returns an array as JSON
     */
    function response($st) {
        // Execute query
        $st->execute();
        
        // Build JSON Response
        if($st->rowCount() > 0){
            $res = $st->fetchAll(PDO::FETCH_ASSOC);
            $object = (object) ['data' => $res];
            echo json_encode($object);
        } else {
            $object = (object) ['data' => []];
            echo json_encode($object);
        }
    }

    function errorResponse($message, $statusCode=400) {
        // Build JSON
        $object = (object) ['error' => $message];
        echo json_encode($object);
        // Set HTTP status
        http_response_code($statusCode);
        // Terminate script
        exit();
    }

?>