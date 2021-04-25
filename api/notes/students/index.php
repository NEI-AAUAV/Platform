<?php 
    // Load database connection from start.php file
    require_once("../../start.php");
    // Load response assistant script
    require_once("../../response.php");
    // Load notes validators
    require_once("../validators.php");
?>
<?php

    // Get url parameter and validate it 
    $categories = $_GET["category"]!=NULL ? $_GET["category"] : [];
    $teacher = $_GET["teacher"];
    $subject = $_GET["subject"];
    $schoolYear = $_GET["schoolYear"];

    // Parameter validation
    $categoriesQuery = validateCategories($categories, $conn);
    $subjectQuery = validateSubject($subject, $conn);
    $schoolYearQuery = validateSchoolYear($schoolYear, $conn);
    $teacherQuery = validateTeacher($teacher, $conn);

    // Make query to the database
    $query_getContent = "SELECT DISTINCT users.name, users.id FROM notes INNER JOIN users ON notes.author =users.id";

    $query_getContent.= " WHERE";
    $query_getContent.= $categoriesQuery;
    $query_getContent.= $teacherQuery;
    $query_getContent.= $subjectQuery;
    $query_getContent.= $schoolYearQuery;

    $query_getContent.= " ORDER BY users.name";

    try{
        $st = $conn->prepare($query_getContent);
        // Bind parameters to query
        if(!is_null($teacherQuery)) {
            $st->bindParam(":teacher", $teacher);
        }
        if(!is_null($subjectQuery)) {
            $st->bindParam(":subject", $subject);
        }
        if(!is_null($schoolYearQuery)) {
            $st->bindParam(":schoolYear", $schoolYear);
        }
        // Return response
        response($st);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>