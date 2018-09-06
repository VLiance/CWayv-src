package language._system;

/**
 * ...
 * @author Maeiky
 */
class System 
{

	public static function fPrint(_oPrint:Dynamic):Void {
		#if !js
			Sys.println(_oPrint);
		#end
	}
	
	
	public static function fProgramPath():String {
		#if !js
			return Sys.programPath();
		#else
			return "";
		#end
	}
	
	public static function fArg():Array<String> {
		#if !js
			return Sys.args();
		#else
			return new Array<String>();
		#end
	}
	

	
}