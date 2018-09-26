package language._system;
import language.base.Debug;

#if js
import js.Browser;
#end

/**
 * ...
 * @author Maeiky
 */
class System 
{

	public static function fPrint(_oPrint:Dynamic):Void {
		#if !js
			Sys.println(_oPrint);
		#else
			 Browser.window.console.log(_oPrint);
		#end
	}
	
	public static function fFatal(_oPrint:Dynamic):Void {
		#if !js
			Sys.println(_oPrint);
		#else
			 Browser.window.console.error(_oPrint);
		#end
	}
	
	
	public static function fProgramPath():String {
		#if !js
			return Sys.programPath();
		#else
			return "";
		#end
	}
	
	
	#if js
	public static var sFullArg : String = "";
	#end
	
	
	public static function fArg():Array<String> {
		#if !js
			return Sys.args();
		#else
			return fExtractFullArg(sFullArg);
		#end
	}
	
	
	/////////////////////////////////////////
	
	#if js
	///Split args with space but keep space inside quotes
	public static var sJokerChar : String = "|";
	public static function fExtractFullArg(_sArg:String):Array<String> { 
		
		var _oArray = new Array<String>();
		var _sResult : String = "";
		
		var _sLastChar : String = "";
		var i : Int = 0;
		var _bInQuote : Bool = false;
		while (i < _sArg.length){ //Change Space in quote
			var _sChar : String = _sArg.charAt(i);
			if (_sChar == '\"'){
				_bInQuote = !_bInQuote;
			}
			if (!_bInQuote && _sChar == ' '){
				_sChar = sJokerChar;
			}
			if( !(_sChar == sJokerChar && _sLastChar == sJokerChar) ){ //Don't allow 2 following *
				_sResult += _sChar;
			}
			_sLastChar = _sChar;
			i++;
		}
	
		//Debug.fTrace(_sResult.split(sJokerChar));
		return _sResult.split(sJokerChar);
	}
	#end
	
}