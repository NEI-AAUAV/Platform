<?php 

    // This script gathers response related code, to avoid code duplication

    /**
     * Executes query and returns (echo) results
     * 
     * @param $st Connection with query prepared for execution
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
        exit();
    }

    /**
     * Returns (echo) error message
     * 
     * @param $message Error message text.
     * @param $statusCode The HTTP error status. 400 by default
     */
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