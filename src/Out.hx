package;

import cs.Lib;
import arguable.ArgParser;//haxelib install arguable


/**
 * ...
 * @author Maeiky
 */
class Out 
{

	
	
	
	public static function fPrint(value) {  
		Sys.println(value);
	}

	
	public static function fDebug(value) {  
		#if debug
			trace(value);
		#end
	}
}