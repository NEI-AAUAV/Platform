<?php 
    // Load database connection from start.php file
    require_once("../start.php");
    // Load response assistant script
    require_once("../response.php");
    // Load pagination assistant script
    require_once("../pagination.php");
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
    if(count($categories)>0) {
        $validOptions = ['summary', 'tests', 'bibliography', 'slides', 'exercises', 'projects', 'notebook'];
        $valid = true;
        foreach($categories as $category) {
            $validCat = false;
            foreach($validOptions as $op) {
                if ($op==$category) {
                    $validCat = true;
                }
            }
            $valid = $valid && $validCat;
        }
        if(!$valid) {
            errorResponse('Categoria inválida!');
        }
    }

    if(!is_null($teacher)) {
        $validOptions = $conn->query("SELECT id FROM notes_teachers")->fetchAll(PDO::FETCH_ASSOC);
        $valid = false;
        foreach($validOptions as $op) {
            if ($op['id']==$teacher) {
                $valid = true;
            }
        }
        if (!$valid) {
            errorResponse('Parâmetro "teacher" inválido!');
        }
    }

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
    }

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
    }

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
    }

    // Get news list (with or without category filtering)
    $query_getContent = "SELECT notes.id, notes.name, notes_subjects.short AS subjectShort, notes_subjects.name AS subjectName, notes.summary, notes.tests, notes.bibliography, notes.slides, notes.exercises, notes.projects, notes.notebook FROM notes INNER JOIN notes_subjects ON notes.subject=notes_subjects.paco_code INNER JOIN notes_schoolyear ON notes.schoolYear=notes_schoolyear.id";

    $query_getContent.=" WHERE";

    if(count($categories)>0) {
        $query_getContent.=" (";    
        $counter = 0;
        foreach($categories as $category) {
            $query_getContent.= $category . "=1";
            $counter = $counter + 1; 
            if($counter < count($categories)) {
                $query_getContent.=" OR ";
            }   
        }
        $query_getContent.=")";
    } else {
        $query_getContent.=" 1";
    }

    if(!is_null($teacher)) {
        $query_getContent.=" AND notes.teacher=:teacher";
    }
    if(!is_null($student)) {
        $query_getContent.=" AND notes.author=:student";
    }
    if(!is_null($subject)) {
        $query_getContent.=" AND notes.subject=:subject";
    }
    if(!is_null($schoolYear)) {
        $query_getContent.=" AND notes.schoolYear=:schoolYear";
    }

    $query_getContent.= " ORDER BY notes_schoolyear.yearEnd DESC, notes.createdAt DESC";

    // Make query to database
    try{
        $st = $conn->prepare($query_getContent);
        // Bind parameters to query
        if(!is_null($teacher)) {
            $st->bindParam(":teacher", $teacher);
        }
        if(!is_null($student)) {
            $st->bindParam(":student", $student);
        }
        if(!is_null($subject)) {
            $st->bindParam(":subject", $subject);
        }
        if(!is_null($schoolYear)) {
            $st->bindParam(":schoolYear", $schoolYear);
        }
        // Return paginated results
        paginate($st, $page_number, $page_size);
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>