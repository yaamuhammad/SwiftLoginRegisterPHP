<?php 
require("Conn.php");
require("MySQLDao.php");

$dao = new MySQLDao();
$dao->openConnection();
$user = $dao->getAllUsers();
print_r(json_encode($user));
return;

$dao->closeConnection();

?>