<?php
/**
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/

/**
*Classe de Banco de Dados do Scielo regional
*
*@package	Scielo.org
*@version      1.0
*@author       André Otero(andre.otero@bireme.org)
*@copyright     BIREME
*/


class DBClass{


/**
* Objeto de conexão com o banco de dados
* @var Object $_conn
*/
var $_connScielo = null;

/**
* Endereço do host
* @var string $_host
*/
//var $_host = "127.0.0.1";
var $_host = "";


/**
* Nome do usuário do BD
* @var string $_user
*/
//var $_user = $DBUser;
var $_user = "";

/**
* Senha do usuário do BD
* @var string $_password
*/
var $_password = "";

/**
* Nome do databse
* @var string $_db
*/
var $_db = "";

function DBClass(){

     $fileDef = parse_ini_file(dirname(__FILE__)."/../../../scielo.def.php");
     $this->_password = $fileDef["DB_USER_SCIELO_PASSWORD"];
     $this->_db  = $fileDef["DB_SCIELO"];
     $this->_user = $fileDef["DB_USER_SCIELO"];
     $this->_host = $fileDef["DB_HOST_SCIELO"];

               $this->_connScielo = mysql_pconnect($this->_host, $this->_user, $this->_password);
               if (!$this->_connScielo) {
                    error_log("Nao foi possivel conectar ao banco: " . mysql_error());
                    die("Nao foi possivel conectar ao banco");
               }

                if (!mysql_select_db($this->_db)) {
                    error_log("Nao pude selecionar o banco de dados: " . mysql_error());
                    die("Nao pude selecionar o banco de dados");
                }
        }



	function databaseExecInsert($query){
		$result = mysql_query($query,$this->_connScielo);
		if($result)
		{
			return(mysql_insert_id());
		}else{
			error_log("A consulta falhou: " . mysql_error());
			return array("A consulta falhou");
		}
	}

	function databaseExecUpdate($query){
		$result = mysql_query($query,$this->_connScielo);
		$error = mysql_error();
		if ($error){
			error_log("A consulta falhou: " . $error);
			return 0;
		}
		return(mysql_affected_rows());
	}

	function databaseQuery($query){
		$result = mysql_query($query,$this->_connScielo);
		if (!$result) {
			error_log("A consulta falhou: " . mysql_error());
			return array();
		}

		$recordSet = array();

		while ($row = mysql_fetch_assoc($result)) {
			array_push($recordSet, $row);
		}

		return($recordSet);
	}

	function quote($value){
		return "'" . mysql_real_escape_string((string)$value, $this->_connScielo) . "'";
	}

	function intValue($value){
		return (string)(int)$value;
	}

	function fechaConexao(){
		mysql_close($this->_connScielo);


	}



}

?>
