<?php

    /**
     * This script provides functions to assist on the pagination processs
     * and prevent code duplication for that end
     */

    // Load response assistant script
    require_once("../response.php");

    // Default values
    $page_size = 9;
    $page_number = 1;

    /**
     * This function gets the pagionation parameter from the (GET) request and validates them
     * 
     * @param $page_number Default page number
     * @param $page_size Default page size
     * @return Array with effective page number and size
     */
    function validatePagination($page_number, $page_size) {
        $page_number = empty($_GET["page"]) ? $page_number : (int)$_GET["page"];
        $page_size = empty($_GET["itemsPerPage"]) ? $page_size : (int)$_GET["itemsPerPage"];
        if($page_number<=0 || $page_size<=0) {
            errorResponse($page_number<=0 ? 'Página inválida!' : 'Número de items por página inválido!');
        }
        return array($page_number, $page_size);
    }

    /**
     * Executes query and returns (echo) paginated results
     * 
     * @param $st Connection with query prepared for execution
     * @param $page_number Number of page to return
     * @param $page_size The size of the page to return 
     */
    // Paginate query results
    function paginate($st, $page_number, $page_size) {
        // Execute query
        $st->execute();
        // Build JSON Response
        if($st->rowCount() > 0){
            $res = $st->fetchAll(PDO::FETCH_ASSOC);
            if(!empty($article)) {
                $object = (object) ['data' => $res[0]];
            } else {
                // If news list, add pagination
                if (($page_size*($page_number-1)) > count($res)) {
                    // Validate there are that many pages
                    errorResponse('Página inválida!');
                } else {
                    // If so, slice array
                    $pages_number = ceil(count($res)/$page_size);
                    $res = array_slice($res, ($page_size*($page_number-1)), $page_size);
                    $object = (object) ['page' => (object) [ 
                        'itemsPerPage' => $page_size, 
                        'currentPage' => $page_number, 
                        'count' => count($res),
                        'pagesNumber' => $pages_number,
                    ], 'data' => $res];
                }
            }
            $myJSON = json_encode($object);
            echo $myJSON;
        } else {
            if ($page_number>1) {
                // Validate there are that many pages
                errorResponse('Página inválida!');
            } else {
                $object = (object) ['page' => (object) [ 
                    'itemsPerPage' => $page_size, 
                    'currentPage' => $page_number, 
                    'count' => 0,
                    'pagesNumber' => 1,
                ], 'data' => []];
            }
            $myJSON = json_encode($object);
            echo $myJSON;
        }
    }

?>