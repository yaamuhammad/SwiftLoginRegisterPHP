<?php

class MySQLDao {
var $dbhost = null;
var $dbuser = null;
var $dbpass = null;
var $conn = null;
var $dbname = null;
var $result = null;

function __construct() {
    $this->dbhost = Conn::$dbhost;
    $this->dbuser = Conn::$dbuser;
    $this->dbpass = Conn::$dbpass;
    $this->dbname = Conn::$dbname;
}

public function openConnection() {
    // echo $this->dbhost;
    // echo $this->dbuser;
    // echo $this->dbpass;
    // echo $this->dbname;

    $this->conn = new mysqli($this->dbhost, $this->dbuser, $this->dbpass, $this->dbname);
    if (mysqli_connect_errno())
    echo new Exception("Could not establish connection with database");
}

public function getConnection() {
    return $this->conn;
}

public function closeConnection() {
    if ($this->conn != null)
        $this->conn->close();
}

public function getUserDetails($email)
{
    $returnValue = array();
    $sql = "select * from users where user_email='" . $email . "'";

    $result = $this->conn->query($sql);
    if ($result != null && (mysqli_num_rows($result) >= 1)) {
        $row = $result->fetch_array(MYSQLI_ASSOC);
        if (!empty($row)) {
            $returnValue = $row;
        }
    }
    return $returnValue;
}

public function getAllUsers() {
    $returnValue = array();
    $sql = "select * from users";

    $result = $this->conn->query($sql);
    if ($result != null && (mysqli_num_rows($result) >= 0)) {
        // $row = $result->fetch_array(MYSQLI_ASSOC);
        // if (!empty($row)) {
        //     $returnValue = $row;
        // }
        $returnValue = array();
        while($r = mysqli_fetch_assoc($result)) {
            array_push($returnValue, $r);
        }
    }
    return $returnValue;
}

public function getUserDetailsWithPassword($email, $userPassword)
{
    $returnValue = array();
    $sql = "select id,user_email from users where user_email='" . $email . "' and user_password='" .$userPassword . "'";

    $result = $this->conn->query($sql);
        if ($result != null && (mysqli_num_rows($result) >= 1)) {
            $row = $result->fetch_array(MYSQLI_ASSOC);
        if (!empty($row)) {
            $returnValue = $row;
        }
    }
    return $returnValue;
}

public function registerUser($email, $password)
{
    $sql = "insert into users set user_email=?, user_password=?";
    $statement = $this->conn->prepare($sql);
    if (!$statement)
        throw new Exception($statement->error);

    $statement->bind_param("ss", $email, $password);
    $returnValue = $statement->execute();

    return $returnValue;
}

}
?>
