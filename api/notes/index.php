<?php 
    // Load database connection from start.php file
    require_once("../start.php");
    // Load response assistant script
    require_once("../response.php");
    // Load pagination assistant script
    require_once("../pagination.php");
    // Load notes validators
    require_once("./validators.php");
?>
<?php

    // Get url parameter and validate it 
    $categories = $_GET["category"]!=NULL ? $_GET["category"] : [];
    $teacher = $_GET["teacher"];
    $student = $_GET["student"];
    $subject = $_GET["subject"];
    $schoolYear = $_GET["schoolYear"];

    // Pagination
    list($page_number, $page_size) = validatePagination(
        $page_number, 
        $page_size
    );

    // Parameter validation
    $categoriesQuery = validateCategories($categories, $conn);
    $studentQuery = validateStudent($student, $conn);
    $subjectQuery = validateSubject($subject, $conn);
    $schoolYearQuery = validateSchoolYear($schoolYear, $conn);
    $teacherQuery = validateTeacher($teacher, $conn);

    // Get news list (with or without category filtering)
    $query_getContent = "SELECT notes.id, notes.name, notes_subjects.short AS subjectShort, notes_subjects.name AS subjectName, notes.summary, notes.tests, notes.bibliography, notes.slides, notes.exercises, notes.projects, notes.notebook FROM notes INNER JOIN notes_subjects ON notes.subject=notes_subjects.paco_code INNER JOIN notes_schoolyear ON notes.schoolYear=notes_schoolyear.id";

    $query_getContent.= " WHERE";
    $query_getContent.= $categoriesQuery;
    $query_getContent.= $teacherQuery;
    $query_getContent.= $studentQuery;
    $query_getContent.= $subjectQuery;
    $query_getContent.= $schoolYearQuery;

    $query_getContent.= " ORDER BY notes_schoolyear.yearEnd DESC, notes.createdAt DESC";

    // Make query to database
    try{
        $st = $conn->prepare($query_getContent);
        // Bind parameters to query
        if(!is_null($teacherQuery)) {
            $st->bindParam(":teacher", $teacher);
        }
        if(!is_null($studentQuery)) {
            $st->bindParam(":student", $student);
        }
        if(!is_null($subjectQuery)) {
            $st->bindParam(":subject", $subject);
        }
        if(!is_null($schoolYearQuery)) {
            $st->bindParam(":schoolYear", $schoolYear);
        }
        // Return paginated results
        paginate($st, $page_number, $page_size);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>