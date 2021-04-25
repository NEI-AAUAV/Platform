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
    $note = $_GET["note"];

    // Prevent filtering by both parameters
    if ((count($categories)>0 or !is_null($teacher) or !is_null($student) or !is_null($subject) or !is_null($schoolYear)) and !is_null($note)) {
        errorResponse('Não é possível filtrar com o argumento "note"!');
    }

    // Pagination
    list($page_number, $page_size) = validatePagination(
        $page_number, 
        $page_size,
        !is_null($note) ? ['note'] : []
    );

    // Parameter validation
    $categoriesQuery = validateCategories($categories, $conn);
    $studentQuery = validateStudent($student, $conn);
    $subjectQuery = validateSubject($subject, $conn);
    $schoolYearQuery = validateSchoolYear($schoolYear, $conn);
    $teacherQuery = validateTeacher($teacher, $conn);

    // Get news list (with or without category filtering)
    $query_getContent = "SELECT 
            notes.id, 
            notes.name, 
            notes_subjects.short AS subjectShort, 
            notes_subjects.name AS subjectName, 
            notes.summary, 
            notes.tests, 
            notes.bibliography, 
            notes.slides, 
            notes.exercises, 
            notes.projects, 
            notes.notebook 
        FROM notes 
            INNER JOIN notes_subjects ON notes.subject=notes_subjects.paco_code 
            INNER JOIN notes_schoolyear ON notes.schoolYear=notes_schoolyear.id
        ";

    $query_getContent.= " WHERE";
    $query_getContent.= $categoriesQuery;
    $query_getContent.= $teacherQuery;
    $query_getContent.= $studentQuery;
    $query_getContent.= $subjectQuery;
    $query_getContent.= $schoolYearQuery;

    $query_getContent.= " ORDER BY notes_schoolyear.yearEnd DESC, notes.createdAt DESC";

    // Get note by ID 
    if(!is_null($note)) {
        $query_getContent = "SELECT 
                notes.name, 
                notes.location, 
                notes_subjects.paco_code AS subjectId,
                notes_subjects.short AS subjectShort, 
                notes_subjects.name AS subjectName,	
                users.name AS student,
                users.id AS studentId,
                notes_schoolyear.id AS schoolYearId,
                notes_schoolyear.yearBegin AS schoolYearBegin,
                notes_schoolyear.yearEnd AS schoolYearEnd,
                notes_teachers.id AS teacherId,
                notes_teachers.name AS teacher,
                notes_teachers.personalPage AS teacherPersonalPage,
                notes.content,
                notes.summary, 
                notes.tests, 
                notes.bibliography, 
                notes.slides, 
                notes.exercises, 
                notes.projects, 
                notes.notebook 
            FROM notes 
                INNER JOIN notes_subjects ON notes.subject=notes_subjects.paco_code 
                LEFT JOIN notes_schoolyear ON notes.schoolYear=notes_schoolyear.id 
                LEFT JOIN users ON notes.author=users.id
                LEFT JOIN notes_teachers ON notes.teacher=notes_teachers.id
            WHERE notes.id=:note
        ;";
    }

    // Make query to database
    try{
        $st = $conn->prepare($query_getContent);
        // Bind parameters to query
        if(is_null($note)) {
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
        } else {
            $st->bindParam(":note", $note);
            // Return response
            response($st);
        }
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>