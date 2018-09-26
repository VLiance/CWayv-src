package language.cwMake.line;
	

	import language._system.System;
	import language.base.InObject;
	import language.base.Root;
	import language.base.Debug;

	/**
	 * @author Maeiky
	 */	
	class CWaveArg extends InObject {
		
		public var sArguments : String = "";
		public var sRootPath : String = "";
		public var sCurrentDir : String = "";
		public var sCurrentFile : String = "";
		
		public static var nHandleID : Int = 0;
		public static var bManaged : Bool = false;
		public static var nAssist : UInt = 0;
		public static var nAssistHandle : UInt = 0;
		
		
						
		public static var bHaveToCompileFile : Bool = false;
		public static var bHavePackingLib : Bool = false;
		

		
		public var oModule : CwmFile;
		
		
		//public function CWaveArg(_Main:Root, _sRootPath:String, _oWin : Form ) {
		public function new(_Main:Root, _sRootPath:String, _oModule : CwmFile) {
			super(_Main);
			oModule = _oModule;
			
			sRootPath = _sRootPath;
			
			
			//sCurrentDir = File.getCurrentDirectory();
			sCurrentDir = System.fProgramPath();
			
			
			//Debug.trace3("Arguemnts : " + Application.commandLineArguments.toString() );
		//	fExtractArgument(Application.commandLineArguments.toString());

		
		//	var _sTempArg : String = "-c E:/_Project/_MyProject/Cwift_Haxe/CWDK/LinxDemo/_MainDemo/MainDemo.cwe"; //TODO

		//	Out.fDebug("_sTempArg: " +_sTempArg );
		//	fExtractArgument(_sTempArg); //for (arg in Sys.args()){??
			
		
		
		
	//	Debug.fTrace("Arguemnts : " +Sys.args().join(" "));
			
			fExtractCommandLine(System.fArg());
			/*
Debug.fTrace("---------------------- : " );
			
			if (sCurrentFile == ""){
				Out.fDebug("Error: No CwMake File" );
			}
			Out.fDebug("sCurrentFile: " +sCurrentFile);
			
			*/
			if (nHandleID != 0 || nAssistHandle != 0) {	
				bManaged = true;
			}else {
				//_oWin.showWindow(ShowWindowStyles.Show);
//				_oWin.showWindow(ShowWindowStyles.ShowDefault);
			}
			
			
			//Debug.fError("Argument : " + sArguments);
			//Debug.fError("Arg: " +  Application.commandLineArguments.toString());
		}
		
	
		public function fExtractCommandLine(_sArgumentsList:Array<String>):Void {
			
			
			for (i in 0... _sArgumentsList.length-1){ //-1 (Require at least one input value)
				
				var _sInput : String = _sArgumentsList[i + 1];
				
				switch (_sArgumentsList[i]) {
					
					case "-L"   //Lib
					   | "-l":
						oModule.fAddLib(_sInput);
						
					case "-I"   //Interface
					   | "-i":
						oModule.fAddLib(_sInput,true); //Interface are readonly
						
						
					case "-E"   //Compile enyty file & dependances
						| "-e" :
						oModule.fAddCompileEntry(_sInput);
						bHaveToCompileFile = true;
						
					case "-C"   //Compile one file
						| "-c" :
						oModule.fAddCompileEntry(_sInput);
						bHaveToCompileFile = true;
						
					case "-O"   //Output
						| "-o" :
						oModule.fSetExportPath(_sInput);
					
					case "-P"   //Pack lib
						| "-p" :
						oModule.fAddPackingLib(_sInput);
						bHavePackingLib = true;
						
				}
				
			}
			
			/*
			for (_sArg in _sArgumentsList){
				
				Sys.println(_sArg);
				switch (_sArg.charAt(0)) {
					case "I" :  //Lib
							
						
					default:
				}
				
			}*/
		}
		
		
		
		public function fExtractArgument(_sArgumentsList:String):Void { //TEMP
			
			sArguments = _sArgumentsList.split(",").join(" "); //Remove , bug

			var _aList : Array<Dynamic> = sArguments.split("-");

			for (i in 1 ... _aList.length) {
				
				var _sArgument : String = _aList[i];
			
				switch (_sArgument.charAt(0)) {
					
					case "I" :  //Lib
						//aLibPath.push( fConvertArg(_sArgument) );
					//break;
					
					case "E" :  
						//sExportPath =  fConvertArg(_sArgument);
					//break;
					
					case "c" 
					| "C" : 
						Debug.fTrace(_sArgument);
						sCurrentDir = fConvertArg(_sArgument);
						sCurrentFile = sCurrentDir.substring( fGetFileStartIndex(sCurrentDir) );
						sCurrentDir = sCurrentDir.substring(0, fGetFileStartIndex(sCurrentDir));
						if (sCurrentDir.charAt(1) != ":") { //Relative path
							sCurrentDir = System.fProgramPath() + sCurrentDir;
						}

							//Debug.fStop();
					//break;
					
					case "H" : 
						nHandleID =  cast(fConvertArg(_sArgument));
					//break;		
					
				case "A" : 
						var _sArg : String = fConvertArg(_sArgument);
						var _aArg : Array<Dynamic> =  _sArg.split(";");
						nAssist =  cast(_aArg[0]);
						nAssistHandle = cast (_aArg[1]);
					//break;	
				}
			}
		}
		
		public function fConvertArg(_sArgument:String):String {
			return  Text.removeSpaceBefore(_sArgument.substring(1) ).split("/").join("\\") ;
		}
		public static function fGetFileStartIndex(_sPath:String):UInt {
			
			var i :Int = _sPath.length;
			
			while (i >= 0  && _sPath.charAt(i) != "\\"  && _sPath.charAt(i) != "/" ) {
				i--;
			}
		
			return i + 1;
		}

	}
