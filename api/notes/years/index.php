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
    $student = $_GET["student"];
    $subject = $_GET["subject"];

    // Parameter validation
    $categoriesQuery = validateCategories($categories, $conn);
    $teacherQuery =validateTeacher($teacher, $conn);
    $studentQuery = validateStudent($student, $conn);
    $subjectQuery = validateSubject($subject, $conn);

    // Make query to the database
    $query_getContent = "SELECT DISTINCT notes_schoolyear.id, notes_schoolyear.yearBegin, notes_schoolyear.yearEnd FROM notes INNER JOIN notes_schoolyear ON notes.schoolYear = notes_schoolyear.id";

    $query_getContent.= " WHERE";
    $query_getContent.= $categoriesQuery;
    $query_getContent.= $teacherQuery;
    $query_getContent.= $studentQuery;
    $query_getContent.= $subjectQuery;

    $query_getContent.=" ORDER BY notes_schoolyear.yearBegin, notes_schoolyear.yearEnd";

    try{
        $st = $conn->prepare($query_getContent);
        // Bind parameters to query
        if(!empty($teacherQuery)) {
            $st->bindParam(":teacher", $teacher);
        }
        if(!empty($studentQuery)) {
            $st->bindParam(":student", $student);
        }
        if(!empty($subjectQuery)) {
            $st->bindParam(":subject", $subject);
        }
        // Return response
        response($st);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>