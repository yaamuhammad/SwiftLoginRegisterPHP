<?php 
require("Conn.php");
require("MySQLDao.php");

// $email = htmlentities($_POST["email"]);
// $password = htmlentities($_POST["password"]);

$data = json_decode(file_get_contents("php://input"));
$email = $data->email;
$password = $data->password;

if(empty($email) || empty($password))
{
    http_response_code(400);
    $returnValue["status"] = "error";
    $returnValue["message"] = "Missing required field";
    echo json_encode($returnValue);
    return;
}

$dao = new MySQLDao();
$dao->openConnection();
$userDetails = $dao->getUserDetails($email);

if(!empty($userDetails))
{
    http_response_code(400);
    $returnValue["status"] = "error";
    $returnValue["message"] = "User already exists";
    echo json_encode($returnValue);
    return;
}

$secure_password = md5($password); // I do this, so that user password cannot be read even by me
$result = $dao->registerUser($email,$secure_password);
if($result)
{
    $returnValue["status"] = "Success";
    $returnValue["message"] = "User is registered";
    echo json_encode($returnValue);
    return;
}

$dao->closeConnection();

?>