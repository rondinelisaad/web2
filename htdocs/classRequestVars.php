<?php

include_once("old2new.inc");

class RequestVars
{
    var $_request = array();

    function __construct()
    {
        $this->RequestVars();
    }

    function RequestVars ()
    {
        global $HTTP_GET_VARS, $HTTP_POST_VARS, $REQUEST_URI, $SCRIPT_NAME;

        $getVars = isset($_GET) ? $_GET : (isset($HTTP_GET_VARS) ? $HTTP_GET_VARS : array());
        $postVars = isset($_POST) ? $_POST : (isset($HTTP_POST_VARS) ? $HTTP_POST_VARS : array());
        $requestUri = isset($_SERVER['REQUEST_URI']) ? $_SERVER['REQUEST_URI'] : $REQUEST_URI;
        $scriptName = isset($_SERVER['SCRIPT_NAME']) ? $_SERVER['SCRIPT_NAME'] : $SCRIPT_NAME;

        if (strpos($requestUri, "?") === false)
        {
            $QSCnav = $requestUri;
            $QSCscript = $scriptName;
            $QSCnav = preg_replace('/^' . preg_quote($QSCscript, '/') . '/', '', $QSCnav);
            $QSCvars = explode("/", $QSCnav);
            $QSCArray = array();

            for ($QSCi = 1; $QSCi < count($QSCvars); $QSCi++)
            {
                $QSCpos = strpos($QSCvars[$QSCi], "_");
                if ($QSCpos)
                {
                    $QSCvar = substr($QSCvars[$QSCi], 0, $QSCpos);
                    $QSCArray[$QSCvar] = substr($QSCvars[$QSCi], $QSCpos + 1);
                }
                else
                {
                    $QSCvar = $QSCvars[$QSCi];
                    $QSCArray[$QSCvar] = "";
                }
            }

            $this->_request = array_merge($getVars, $postVars, $QSCArray);
        }
        else
        {
            $this->_request = array_merge($getVars, $postVars);
        }

        if (!isset($this->_request['lng']) || !in_array(strtolower($this->_request['lng']), array('pt', 'es', 'en'))) {
            $this->_request['lng'] = $this->_detectDefaultLanguage();
        } else {
            $this->_request['lng'] = strtolower($this->_request['lng']);
        }
    }

    function _detectDefaultLanguage()
    {
        $acceptLanguage = isset($_SERVER['HTTP_ACCEPT_LANGUAGE']) ? strtolower($_SERVER['HTTP_ACCEPT_LANGUAGE']) : '';
        if ($acceptLanguage) {
            $languages = explode(',', $acceptLanguage);
            foreach ($languages as $language) {
                $code = substr(trim($language), 0, 2);
                if (in_array($code, array('pt', 'es', 'en'))) {
                    return $code;
                }
            }
        }

        return 'pt';
    }

    function getRequestValue ($key, &$value)
    {
        if (!isset($this->_request[$key])) return false;

        $value = $this->_request[$key];

        return true;
    }

    function getQueryString ()
    {
        $query = "";
        $count = sizeof($this->_request);

        foreach ($this->_request as $key => $value)
        {
            if (is_array($value))
            {
                $query .= rawurlencode($key) . "[]=" . rawurlencode($value[0]);

                for ($i = 1; $i < sizeof($value); $i++)
                {
                    $query .= "&" . rawurlencode($key) . "[]=" . rawurlencode($value[$i]);
                }
            }
            else
            {
                $query .= rawurlencode($key) . "=" . rawurlencode($value);
            }

            if (--$count > 0) $query .= "&";
        }

        return $query;
    }
}

?>
