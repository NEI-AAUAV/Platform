<?php 
    // Load database connection from start.php file
    require_once("../start.php");
    // Load response assistant script
    require_once("../response.php");
?>
<?php
    
    // Get url parameter and validate it 
    $course = $_GET["course"];
    $year = $_GET["year"];
    $validOptions = $conn->query("SELECT DISTINCT course, year FROM seniors")->fetchAll(PDO::FETCH_ASSOC);
    $validCourse = false;
    $validYear = false;
    foreach($validOptions as $op) {
        if ($op['course']==$course) {
            $validCourse = true;
        }
        if ($op['year']==$year) {
            $validYear = true;
        }
    }
    if(!$validCourse and empty($_GET["course"])) {
        errorResponse('Parâmetro "course" em falta!');
    } else if (!$validCourse) {
        errorResponse('Parâmetro "course" inválido!');
    } else if(!$validYear and empty($_GET["year"])) {
        errorResponse('Parâmetro "year" em falta!');
    } else if (!$validYear) {
        errorResponse('Parâmetro "year" inválido!');
    }

    // Make query to the database
    $query_getContent = "SELECT image FROM seniors WHERE course=:course AND year=:year";
    $query2_getContent = "SELECT users.name, seniors_students.quote, seniors_students.image FROM seniors_students INNER JOIN users ON users.id=seniors_students.userId WHERE seniors_students.course=:course AND seniors_students.year=:year ORDER BY users.name";

    try{
        // Query 1
        $st = $conn->prepare($query_getContent);
        $st->bindParam(':course', $course);
        $st->bindParam(':year', $year);
        // Query 2
        $st2 = $conn->prepare($query2_getContent);
        $st2->bindParam(':course', $course);
        $st2->bindParam(':year', $year);
        // Execute query
        $st->execute();
        $st2->execute();
        // Return response
        // Build JSON Response
        $res = $st->fetchAll(PDO::FETCH_ASSOC);
        $res2 = $st2->fetchAll(PDO::FETCH_ASSOC);
        // Add res2 to res
        $res[0]['students'] = $res2;
        $object = (object) ['data' => $res[0]];
        echo json_encode($object);
        exit();
    } catch(Exception $e){
        errorResponse('Ocorreu um erro inesperado.', 500, $e);
    }

    // The connection is closed automatically when the script ends
?>