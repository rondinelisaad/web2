<?
require_once(dirname(__FILE__)."/wpPosts.php");
require_once(dirname(__FILE__)."/../users/DBClassBlog.php");

class wpPostsDAO{

function wpPostsDAO(){

//	$fileDef = parse_ini_file(dirname(__FILE__)."/../../../scielo.def.php");
//		$DBparams["password"] = $fileDef["DB_USER_BLOG_PASSWORD"];
//		$DBparams["db"] = $fileDef["DB_BLOG"];
//		$DBparams["user"] = $fileDef["DB_USER_BLOG"];
//		$DBparams["host"] = $fileDef["DB_HOST_BLOG"];
//		$this->_db = new DBClass($DBparams);
		$this->_db = new DBClassBlog();
}

function addPost($post,$blogId){
	$strsql = "INSERT INTO wp_" . $this->_db->intValue($blogId) . "_posts (
		post_author, post_date, post_date_gmt, post_content, post_title, post_category,
		post_status, comment_status, ping_status, post_name, guid, post_modified,
		post_modified_gmt, post_parent, menu_order, comment_count
		) VALUES (" .
		$this->_db->intValue($post->getPostAuth()) . "," .
		$this->_db->quote($post->getPostDate()) . "," .
		$this->_db->quote($post->getPostDateGmt()) . "," .
		$this->_db->quote($post->getPostContent()) . "," .
		$this->_db->quote($post->getPostTitle()) . "," .
		$this->_db->intValue($post->getPostCategory()) . "," .
		$this->_db->quote($post->getPostStatus()) . "," .
		$this->_db->quote($post->getCommentStatus()) . "," .
		$this->_db->quote($post->getPingStatus()) . "," .
		$this->_db->quote($post->getPostName()) . "," .
		$this->_db->quote($post->getPostGuid()) . "," .
		$this->_db->quote($post->getPostModified()) . "," .
		$this->_db->quote($post->getPostModifiedGmt()) . "," .
		$this->_db->intValue($post->getPostParent()) . "," .
		$this->_db->intValue($post->getMenuOrder()) . "," .
		$this->_db->intValue($post->getCommentCount()) .
		")";
	$result = $this->_db->databaseExecInsert($strsql);

	$this->_db->fechaConexao();
	return $result;
	}

	function getLastComment($blogID,$commentID){
		$strsql = "SELECT comment_author,comment_content from wp_" . $this->_db->intValue($blogID) . "_comments where comment_ID=".$this->_db->intValue($commentID);

		$arr = $this->_db->databaseQuery($strsql);

		$this->_db->fechaConexao();

		return $arr;

	}

}
?>
