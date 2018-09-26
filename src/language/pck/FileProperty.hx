package language.pck;
import language.base.Debug;
import language.pck.SLib;

/**
 * ...
 * @author Maeiky
 */
class FileProperty 
{

	public var sCwPath : String = "";
	public var sExtention : String = "";
	public var sPath : String = "";
	public var sDot : String = "";
	public var sName : String = "";
	public var bIsProbablyOverPlace  = false;
	public var oSLib : SLib;
	
	
	public function new(_oSLib : SLib,  _sPath : String) {
			oSLib = _oSLib;
			sPath = _sPath.split("\\").join("/");
			var _sPathWithoutExt : String = sPath;
		
			//Remove extention
			var _nIndex : Int = sPath.lastIndexOf(".");
			if (_nIndex > -1) {
				sDot  = ".";
				_sPathWithoutExt =  sPath.substring( 0 , _nIndex);
				sExtention =  sPath.substring( _nIndex + 1).toLowerCase();
			}
			sName = _sPathWithoutExt.substring(sName.lastIndexOf("/" )+ 1);
			
			/////
			if (sExtention == "cw"){
				sCwPath = _sPathWithoutExt.split("/").join(".");
				
				if (sName.length > 2 && sName.charAt(0) == "O" && sName.charAt(1) == "p" && sName.charAt(2) >= "A"  && sName.charAt(2) <= "Z" ){
					bIsProbablyOverPlace = true; //TODO  verify if this is really an overplace class
				}
			}
			sPath = _sPathWithoutExt;
	}
	
	
	
	public function fFullPath() : String {
		return oSLib.sReadPath + sPath + sDot + sExtention;
		
	}
	public function fRelativePath() : String {
		return sPath + sDot + sExtention;
		
	}
	
	
	
	
}