<?php

    /** 
     * This functions validate the parameter (check if there are data on de DB for given attribute id)
     * If error, it is thrown and the connection aborted (404 code with error message - see errorResponse() at api/response.php)
     * If success, returns text to append to query with parameter filter
    */

    function validateTeacher($teacher, $conn) {
        if(!is_null($teacher)) {
            $validOptions = $conn->query("SELECT DISTINCT teacher FROM notes")->fetchAll(PDO::FETCH_ASSOC);
            $valid = false;
            foreach($validOptions as $op) {
                if ($op['teacher']==$teacher) {
                    $valid = true;
                }
            }
            if (!$valid) {
                errorResponse('Parâmetro "teacher" inválido!');
            }
            return " AND notes.teacher=:teacher";
        }
        return NULL;
    }

    function validateStudent($student, $conn) {
        if(!is_null($student)) {
            $validOptions = $conn->query("SELECT DISTINCT author FROM notes")->fetchAll(PDO::FETCH_ASSOC);
            $valid = false;
            foreach($validOptions as $op) {
                if ($op['author']==$student) {
                    $valid = true;
                }
            }
            if (!$valid) {
                errorResponse('Parâmetro "student" inválido!');
            }
            return " AND notes.author=:student";
        }
        return NULL;
    }

    function validateSubject($subject, $conn) {
        if(!is_null($subject)) {
            $validOptions = $conn->query("SELECT DISTINCT subject FROM notes")->fetchAll(PDO::FETCH_ASSOC);
            $valid = false;
            foreach($validOptions as $op) {
                if ($op['subject']==$subject) {
                    $valid = true;
                }
            }
            if (!$valid) {
                errorResponse('Parâmetro "subject" inválido!');
            }
            return " AND notes.subject=:subject";
        }
        return NULL;
    }

    function validateSchoolYear($schoolYear, $conn) {
        if(!is_null($schoolYear)) {
            $validOptions = $conn->query("SELECT DISTINCT schoolYear FROM notes")->fetchAll(PDO::FETCH_ASSOC);
            $valid = false;
            foreach($validOptions as $op) {
                if ($op['schoolYear']==$schoolYear) {
                    $valid = true;
                }
            }
            if (!$valid) {
                errorResponse('Parâmetro "schoolYear" inválido!');
            }
            return " AND notes.schoolYear=:schoolYear";
        }
        return NULL;
    }

    function validateCategories($categories, $conn) {
        if(count($categories)>0) {
            // Query build
            $query_getContent =" (";    
            $counter = 0;
            // Validation
            $validOptions = ['summary', 'tests', 'bibliography', 'slides', 'exercises', 'projects', 'notebook'];
            $valid = true;
            foreach($categories as $category) {
                // Validation
                $validCat = false;
                foreach($validOptions as $op) {
                    if ($op==$category) {
                        $validCat = true;
                    }
                }
                $valid = $valid && $validCat;
                // Query build
                $query_getContent.= "notes.".$category . "=1";
                $counter = $counter + 1; 
                if($counter < count($categories)) {
                    $query_getContent.=" OR ";
                }   
            }
            $query_getContent.=")";
            if(!$valid) {
                errorResponse('Categoria inválida!');
            }
            return $query_getContent;
        }
        return " 1";
    }

?>