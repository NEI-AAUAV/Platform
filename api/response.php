<?php 

    // This script gathers response related code, to avoid code duplication

    /**
     * Executes query and returns (echo) results
     * 
     * @param $st Connection with query prepared for execution
     */
    function response($st, $object=false) {
        // Execute query
        $st->execute();
        
        // Build JSON Response
        if($st->rowCount() > 0){
            $res = $st->fetchAll(PDO::FETCH_ASSOC);
            $res = $object ? $res[0] : $res;
        } else {
            $res = $object ? NULL : [];
        }
        $object = (object) ['data' => $res];
        echo json_encode($object);
        exit();
    }

    /**
     * Returns (echo) error message
     * 
     * @param $message Error message text.
     * @param $statusCode The HTTP error status. 400 by default
     */
    function errorResponse($message, $statusCode=400, $error=NULL) {
        // Build JSON
        $object = (object) ['error' => $message];
        // TODO Remove on production
        if ($error!=NULL) {
            $object = (object) ['error' => $message, 'detail' => $error->getMessage()];
        }
        echo json_encode($object);
        // Set HTTP status
        http_response_code($statusCode);
        // Terminate script
        exit();
    }

?>