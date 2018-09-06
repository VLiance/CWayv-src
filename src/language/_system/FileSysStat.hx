package language._system;
import sys.FileStat;
import sys.FileSystem;

/**
 * ...
 * @author Maeiky
 */
class FileSysStat 
{
	
	public var dModTime : Date;
	public var sPath : String;
	public var oStat : FileStat;
	
	public function new(_sFile:String) {
		sPath = _sFile;
		
		oStat = FileSystem.stat(_sFile);
		dModTime =  oStat.mtime;
	}
	
}