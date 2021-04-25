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
    $schoolYear = $_GET["schoolYear"];

    // Parameter validation
    $categoriesQuery = validateCategories($categories, $conn);
    $studentQuery = validateStudent($student, $conn);
    $schoolYearQuery = validateSchoolYear($schoolYear, $conn);
    $teacherQuery = validateTeacher($teacher, $conn);


    // Make query to the database
    $query_getContent = "SELECT DISTINCT notes_subjects.name, notes_subjects.short, notes_subjects.paco_code, notes_subjects.year, notes_subjects.semester FROM notes INNER JOIN notes_subjects ON notes.subject = notes_subjects.paco_code";

    $query_getContent.= " WHERE";
    $query_getContent.= $categoriesQuery;
    $query_getContent.= $teacherQuery;
    $query_getContent.= $studentQuery;
    $query_getContent.= $schoolYearQuery;

    $query_getContent.= " ORDER BY notes_subjects.year, notes_subjects.semester, notes_subjects.name";

    try{
        $st = $conn->prepare($query_getContent);
        // Bind parameters to query
        if(!empty($teacherQuery)) {
            $st->bindParam(":teacher", $teacher);
        }
        if(!empty($studentQuery)) {
            $st->bindParam(":student", $student);
        }
        if(!empty($schoolYearQuery)) {
            $st->bindParam(":schoolYear", $schoolYear);
        }
        // Return response
        response($st);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>