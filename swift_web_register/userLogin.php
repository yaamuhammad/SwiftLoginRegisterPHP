<?php

require("Conn.php");
require("MySQLDao.php");
// $email = htmlentities($_POST["email"]);
// $password = htmlentities($_POST["password"]);
$returnValue = array();

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

$secure_password = md5($password);
$dao = new MySQLDao();
$dao->openConnection();
$userDetails = $dao->getUserDetailsWithPassword($email,$secure_password);
if(!empty($userDetails))
{
	$returnValue["status"] = "Success";
	$returnValue["message"] = "User is registered";
	echo json_encode($returnValue);
} else {
	http_response_code(400);
	$returnValue["status"] = "error";
	$returnValue["message"] = "User is not found";
	echo json_encode($returnValue);
}

$dao->closeConnection();

?>
