package language._system;

#if !js
import sys.FileStat;
import sys.FileSystem;
#end

/**
 * ...
 * @author Maeiky
 */
class FileSysStat 
{
	
	public var dModTime : Date;
	public var sPath : String;
	
	#if !js
	public var oStat : FileStat;
	#end
	
	public function new(_sFile:String) {
		sPath = _sFile;
		#if !js
			oStat = FileSystem.stat(_sFile);
			dModTime =  oStat.mtime;
		#end
	}
	
}