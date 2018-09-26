package;


import language.FileManager;
import language._system.FileSys;
import language._system.System;

import arguable.ArgParser;//haxelib install arguable
import language.base.Root;

//import sys.FileSystem;
//import sys.io.File;
import language.ProjectData;

/**
 * ...
 * @author Maeiky
 */
class Main 
{
	static function main(){
		#if !js
			fCreateCompilo();
		#end	
		
	}
	
	 public static function fCreateCompilo() {
		var _oRoot :Root = new Root(null);
		var	oFileManager =  new FileManager(_oRoot);
	 }

}


 
#if js
	
	@:expose  // <- makes the class reachable from plain JavaScript
	@:keep    // <- avoids accidental removal by dead code elimination
	class CWayv {
	  public function new() { }
	  public function fStart(_sArg:String) {
		 System.sFullArg = _sArg;
		 System.fPrint("CWayv Started! : " + _sArg);
		 
		Main.fCreateCompilo();
		 
	  }
	}
	
#end

	