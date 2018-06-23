package;

import cs.Lib;
import language.FileManager;

import arguable.ArgParser;//haxelib install arguable
import language.base.Root;
import sys.FileSystem;
import sys.io.File;
import language.ProjectData;

/**
 * ...
 * @author Maeiky
 */
class Main 
{
	
	
	//Vérifier les vrai break;
	//Vérifier les lopp avec i initiliser au début
	//var i : Int  = _i;//???CW
	
	//Repace split("\\").join("/") to replace
	
	static function main()
    {

			var _oRoot :Root = new Root(null);
		
			var	oFileManager =  new FileManager(_oRoot);
			
		
			//var	oProjectData =  new ProjectData(_oRoot);
		
		  for (arg in Sys.args()){
			Sys.println(arg);
		  }
			


		Out.fDebug("Finish !");
		
	//	File.saveContent("Test.txt","HELLO");
		
	}
	
	
	
}
