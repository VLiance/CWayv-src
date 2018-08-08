package language;

	import language.base.Debug;
	import language.base.Root;
	import language.cwMake.line.CWaveArg;
	import language.project.CppProject;
	import language.project.assist.CwInfo;
	import language.project.convertSima.ExtractBlocs;
	import language.project.convertSima.SClass;

			
	/**
	 * @author Maeiky
	 */	
	class FileManager {
		
		private var oFile : MyFile; 
		private var sProjectPath : String;
		private var sMainFile : String;
		private var sFirstRootPath : String;
		private var sCppPath : String;
		private var sLibCPPPath : String;
		private var sRelativeLibCPPPath : String;
		private var oProject : ProjectData;
		public var oMakeProject : CWaveMake;

		
		private var sGZ_Version : String = "Lib_GZE";
		//private var oWin : Form = null;
		
		private var bInEvent : Bool = true ; //Default off
		
		private var bReady : Bool = false;
		
		public var sRootPath : String = "";
		
		public var aEventList : Array<Dynamic> = [];
		
		
	
		public var oMain : Root;
		
		public function new(_oMain:Root) {
			oMain = _oMain;
		//	super(_Main, _mcRef, true, false, false, true);
	
		//	oWin = new Form("MainForm");
		//	oWin.addEventListener( FormCopyDataEvent.COPY_DATA, onExtEv, false, 30, true);  //TODO
			
		
			var bForceDebug : Bool = true;
			//var bForceDebug : Bool = false;

			#if debug
				bForceDebug = false;
			#end
			
			
			
			oMakeProject = new CWaveMake(oMain, sRootPath);
			
	
		//	oWin.title = "cwcc: " + CWaveArg.nHandleID;
			
			//oWin.showWindow(ShowWindowStyles.Show);
			//Debug.fError("Title: " +   "cwcc: " + CWaveArg.nHandleID);
		
			
		//	createGroundZero();
			
			
		
			
			
			if (CWaveArg.nAssist != 0) {
				
				 Debug.fAssist("Handle| " +  CWaveArg.nHandleID);
				// System.sendStringMessage(CWaveArg.nAssistHandle, "I Begin");
				 Debug.fAssist("I Begin");
				 
				 if(!bForceDebug){
					 try{
						fExtract();
						
						
					} catch (err:String) {
				
						if (err.charAt(0) == ":") { //My errors
							//trace("Er");
							Debug.fError("Internal Error: " + err);
						}else {
							throw err; //throw away
						}
					}
								
						
					
				 }else {
					fExtract();
				 }
				
				 bReady = true;
				// System.sendStringMessage(CWaveArg.nAssistHandle, "My I Finish");
				 Debug.fAssist("FinishExtract|");
				// Debug.fError("My I Finish é ^Îefé``d^pooppc^^c^çextract ");
			}else{

				if(CWaveArg.bManaged && !bForceDebug){

					try{	
						fExtract();
						fConvertToCPP();
					} catch (err:String) {
				
						if (err.charAt(0) == ":") { //My errors
							//trace("Er");
							Debug.fError("Internal Error: " + err);
						}else {
							throw err; //throw away
						}
					}
					
				}else {
			//		try{	
						fExtract();
						fConvertToCPP();
				//	}catch(err:String){
				//		Debug.fError("Internal Error: " + err);
				//	}
					//Error log & stack
					//fExtract();
					//fConvertToCPP();
					
				}
				
				bReady = true;
			//	Debug.fTrace("END-------------00");
			}
		
		//oWin.allowClosing = true;	
		
		}
		
	
		
		/* TODO
	
		private function onExtEv(e:FormCopyDataEvent):Void {
			
			if (bReady) {
				var _sReceive : String = e.data;
				aEventList.push(_sReceive);
			}
		}*/
		
		
		public function fDoEvent(_sEvent:String):Void {
			
			try{
					var _nIndex : UInt = Text.search(_sEvent, "|");
						var _sData : String = _sEvent.substring(0, _nIndex);
				
              // Debug.fError("CopyData!!!!!!!!!!!!!!!!!!!!!!!Error: " +  e.data);
	
				
				var _aArg : Array<String> = _sEvent.split("|");
				/*
				 for (var i:uint = 0; i < _aArg.length; i++) {
					 _aArg[i] =  String( _aArg[i]).
				 }*/
				
				
				switch(_sData) {
		
					
					case "FileSave":
						
						//Debug.fAssist("CW File save|");
						
						var _oSClass : SClass = CwInfo.fGetClassFromFile(oProject.oSProject, _aArg[1]);  
						if (_oSClass != null) {
							Debug.fAssist("CW File save, Reload|" + _oSClass.sName);
							_oSClass.fReload();
						}else {
							//Debug.fAssist("ErrorNotFoundClassForFileSave|" + _aArg[1]);
							Debug.fAssist("ErrorNotFoundClassForFileSave|" + _aArg[1].substring(0,_aArg[1].length-2 ) + "|" );
						}
						
						Debug.fAssist("CW File save|");
						
						return;
					
					
					case "LineChange":
						var _oSClass : SClass = CwInfo.fGetClassFromFile(oProject.oSProject, _aArg[1]);  
						if (_oSClass != null) {
							var _sScope : String = CwInfo.fIsScopeChange(_oSClass, cast(_aArg[2]), cast(_aArg[3]));
							if (_sScope != "") {
								//Debug.fAssist("ScopeVar|" + _aArg[1] + "|" + _sScope + "|" +  CwInfo.nScopeLevel  + "|");
								Debug.fAssist("ScopeVar|" + _aArg[1] + "|" + _sScope + "|");
							}else {
								Debug.fAssist("LScopeOutside|" + _aArg[1] + "|" + _aArg[2] + "|");
								//Debug.fAssist("ScopeSame|");
							}
						}else {
							Debug.fAssist("ErrorNotFoundClassForLocalScope|" + _aArg[1]);
						}
								
						return;
					
					
					case "GetRelScope":
						var _oSClass : SClass = CwInfo.fGetClassFromFile(oProject.oSProject, _aArg[1]);  
						if (_oSClass != null) {
							var _sScope : String = CwInfo.fGetRelScope(_oSClass, cast(_aArg[2]), _aArg[3] );
							Debug.fAssist("RelScope|" + _aArg[1] + "|" + _sScope);
						}else {
							Debug.fAssist("ErrorNotFoundClassForLocalScope|" + _aArg[1]);
						}
						return;
					

					//Completion
					case "CpNewWord":
						Debug.fAssist("CW File save|");
						return;
					
					
					case "GetLibInfo":
						Debug.fAssist("LibInfo|" + CwInfo.fGetLibInfo(oProject.oSProject));
						return;
				

					case "GetClassInfo":
						var _oSClass : SClass = CwInfo.fGetClassFromFile(oProject.oSProject, _aArg[1]);  
						if(_oSClass != null){
							Debug.fAssist("ClassInfo|"  + _aArg[1] + "|" + CwInfo.fGetClassInfo(_oSClass ));
						}else {
							Debug.fAssist("ErrorNotFoundClass|" + _aArg[1]);
						//		Debug.fError("ErrorNotFoundClass|" + _aArg[1]);
						}
						return;
					
					
					case "GetFuncInfo":
						var _oSClass : SClass = CwInfo.fGetClassFromFile(oProject.oSProject, _aArg[1]);  
						if(_oSClass != null){
							Debug.fAssist("FuncInfo|"  + _aArg[1] + "|" + CwInfo.fGetFunctionInfo(_oSClass, cast(_aArg[2]), _aArg[3]  ));
						}else {
							Debug.fAssist("ErrorNotFoundFunc|" + _aArg[1]);
						}
						return;
				
	
					
					case "ExtractClassFunc":
						var _oSClass : SClass = CwInfo.fGetClassFromFile(oProject.oSProject, _aArg[1]);  
						if (_oSClass != null) {
							ExtractBlocs.extractClassFunctions(_oSClass);
						}
						return;
					
					
				case "Compile":
			
						var _sBuildType : String = "";
						if (_aArg.length >= 2) {
							_sBuildType = _aArg[2];
						}
					
						fConvertToCPP( _aArg[1], _sBuildType);
						Debug.fAssist("FinishCompile|");
						return;
					
					
					
					case "Quit":
						Debug.fAssist("Quit|");
						CWaveArg.nAssist = 0; //Will quit app
						return;
					
				
					
				}
			//	e.stopPropagation();
				//while(1){
			var _sCmd : String = "";
			 for (i in 0 ... _aArg.length-1) {
				 _sCmd += _aArg[i] + "|";
			 }
			 //.replace("\\","/") + "end";
			 Debug.fAssist("UnknowCmd|" + _sCmd);
			
			} catch (err:String) {
				
					if (err.charAt(0) == ":") { //My errors
						//trace("Er");
						Debug.fError("Internal Error: " + err);
					}else {
						throw err; //throw away
					}
			}
			 
			 
			
		}
		


		public function fUpdate():Void {
			/*
			if (CWaveArg.nAssist) {
				var _bPresent : Boolean = false;
				//Check if assist is present, if not quit app
				var _aProcess : Array = Process.listProcesses();
			   for(var i:int =0; i<_aProcess.length; i++) {
					var _oPross:ProcessInfo = ProcessInfo(_aProcess[i]);
					if (_oPross.id == CWaveArg.nAssist) {
						_bPresent = true;
					}
			   }
			   if (!_bPresent) {
				   CWaveArg.nAssist = 0; //Will quit app
			   }
			}*/
			//Debug.fError("Update");
			
				//System.sendStringMessage(CWaveArg.nAssistHandle, "Q: " + "sasss");
			
			if (aEventList.length > 0) {
				fDoEvent(aEventList.shift());
			}
		}
		
	
		public function fExtract():Void {
			CppProject.nTotalExtract ++;
		
			oProject = new ProjectData(oMain);
			oProject.loadProject(oMakeProject);
			
			oProject.extract();
	
		}
		
		
		public function fConvertToCPP(_sTarget:String = "", _sBuildType: String = ""):Void {
			oProject.convertCPP("", "", false, "MyApp", true, _sTarget, _sBuildType);
		}
		
		
		public function createGroundZero():Void {
			/*
			oProject = new ProjectData(Main,  GData.sRootPath);
			
				var _oMainLib    : SLib;
			
			//Windows Engine
			oProject.loadProject();
			//oProject.oSProject.nStringType = euBit.n16;
			
			 oProject.oSProject.addLib("CWaveDemo\\_MainDemo\\" , "_GroundZeroEngine\\GzDemo\\_Src\\Demo", "SimaCode", false, "Demo");
			 oProject.oSProject.addLib("_CWaveLib\\GZE\\LibCPP\\"   , "_GroundZeroEngine\\_Lib\\Lib_GZE\\GZ\\", "LibCPP"  , true , "GZ");
	    	 oProject.oSProject.addLib("_CWaveLib\\GZE\\LibCPP\\_System\\_Common\\"   , "_GroundZeroEngine\\_Lib\\Lib_GZE\\System\\", "Sys"  , true , "GZ");
			//_oMainSysLib.sCommunStructPath = _oMainCppLib.sWritePath;
	
			//oProject.oSProject.addLib("_CWaveLib\\GZE\\SimaCodeEngine\\", "", "GZ", false, null, _oMainCppLib );
			oProject.oSProject.addLib("_CWaveLib\\GZE\\SimaCodeEngine\\", "_GroundZeroEngine\\_Lib\\Lib_GZE\\GZ\\", "GZ", false );
			
			_oMainLib = oProject.oSProject.fFindLib("SimaCode");
			
			oProject.oSProject.setMainLib(_oMainLib, null, null, "MainEntry");
			
			oProject.extract();
					
			//oProject.convertCPP(_oMainLib.sWritePath, _oMainCppLib.sWritePath, false, "MyApp", true);
			oProject.convertCPP("", "", false, "MyApp", true);
			
			//mFile.writefile( oProject.sRootPath +  "_GroundZero\\Example\\Win\\"  + "Main.cpp", oProject.oCppProject.oMainFile.aFile);
			*/
		}
		
		public function createArm():Void {
			/*
			sFirstRootPath =  GData.sRootPath;
			oProject = new ProjectData(Main, sFirstRootPath);
			
			//Windows Engine
			oProject.loadProject();
			oProject.oSProject.nStringType = euBit.n16;
			
			var _oMainLib    : SLib = oProject.oSProject.addLib("StmDisco\\" , "_GroundZero\\StmDisco\\_Src", "SimaCode", false, "StmDisco");
			var _oMainCppLib : SLib = oProject.oSProject.addLib("LibCPP\\"   , "_GroundZero\\_Lib\\"+ sGZ_Version +"\\GZ\\", "LibCPP"  , true , "GZ");
			var _oMainSysLib : SLib = oProject.oSProject.addLib("LibCPP\\_System\\_Common\\"   , "_GroundZero\\_Lib\\"+ sGZ_Version + "\\System\\", "Sys"  , true , "GZ");
			
			
			oProject.oSProject.addLib("SimaCodeEngine\\", "", "GZ", false, null, _oMainCppLib );
			oProject.oSProject.addLib("SimaCodeEngine\\", "", "GZ", false, null );
			oProject.oSProject.setMainLib(_oMainLib, _oMainCppLib, _oMainSysLib);
			
			oProject.extract();
					
			oProject.convertCPP(_oMainLib.sWritePath, _oMainCppLib.sWritePath, false, "MyApp", true);
			
			mFile.writefile( oProject.sRootPath +  "_GroundZero\\StmDisco\\Win\\"  + "Main.cpp", oProject.oCppProject.oMainFile.aFile);
		*/
		}
		
		
		public function createDrum():Void {
			/*
			sFirstRootPath =  GData.sRootPath;
			oProject = new ProjectData(Main, sFirstRootPath);
			
			//Windows Engine
			oProject.loadProject();
			oProject.oSProject.nStringType = euBit.n16;
			
			var _oMainLib    : SLib = oProject.oSProject.addLib("StmDrum\\" , "_GroundZero\\StmDrum\\_Src", "SimaCode", false, "StmDrum");
			var _oMainCppLib : SLib = oProject.oSProject.addLib("LibCPP\\"   , "_GroundZero\\_Lib\\GZ\\", "LibCPP"  , true , "GZ");
			var _oMainSysLib : SLib = oProject.oSProject.addLib("LibCPP\\_System\\_Common\\"   , "_GroundZero\\_Lib\\GZ\\_System\\", "Sys"  , true , "GZ");
			
			
			oProject.oSProject.addLib("SimaCodeEngine\\", "", "GZ", false, null, _oMainCppLib );
			oProject.oSProject.setMainLib(_oMainLib, _oMainCppLib, _oMainSysLib);
			
			oProject.extract();
					
			oProject.convertCPP(_oMainLib.sWritePath, _oMainCppLib.sWritePath, false, "MyApp", true);
			
			mFile.writefile( oProject.sRootPath +  "_GroundZero\\StmDrum\\Win\\"  + "Main.cpp", oProject.oCppProject.oMainFile.aFile);
		*/
		}
		
		
		
		
		/*
		
		public function createDrums():Void  {
			sFirstRootPath =  GData.sRootPath;
			oProject = new ProjectData(Main, sFirstRootPath);
			
			//Stm32f429_Engine
			sProjectPath = "DrumGUI\\";
			sMainFile = "MainGUI";
			sCppPath = "..\\Stm32f429_Engine\\DrumGUI\\";
			sLibCPPPath = "..\\Stm32f429_Engine\\_Lib\\ArmCpp\\";
			
			
			if (sCppPath.charAt(sCppPath.length - 1)  != "\\") {  //DO better than this
				sCppPath += "\\";
			}
			if (sLibCPPPath.charAt(sLibCPPPath.length - 1)  != "\\") {
				sLibCPPPath += "\\";
			}
			
			oProject.loadProject(sProjectPath, sMainFile, sCppPath, sLibCPPPath);
			oProject.oSProject.nStringType = euBit.n16;
			oProject.extract();
			//oProject.run();

			oProject.convertCPP(sCppPath, sLibCPPPath, false, "MyApp", true);
			
		}
		
		
		*/
		
		
		
		
		/*
		private function readFile(_sName:String):Void {
		
			
			
			
			//var _sNewPath : String = sSecondRootPath + _sName;
			oFile.readFile(_sName);
			oProject.insertFile(oFile.file);
			
			
			
			
			
			/*
			
			var _i:uint = oFile.readLength;
			for (var i:int = 0; i < _i; i++) {
				oFile.setReadLine(i);
				readLine();
			}*/
		
			//Build
			/*
			var _nFirst : int = oFile.getFileModification(_sNewPath, false);
			var _nSecond : int = oFile.getFileModification(_sName);
			if (_nFirst != _nSecond) {	
				oFile.clear();	
				var _i:uint = oFile.readLength;
				for (var i:int = 0; i < _i; i++) {
					buildFile(i);
				}
				
				oFile.writefile(_sNewPath, false);
			}*/
				
		//}
		

		/*
		private function finishRead():Void {
			
			//oProject.run();
			oProject.convertCPP(sRelativeLibCPPPath);
			
			//TODO multifile/class
			oFile.writefile(sSecondRootPath  + "MyCPP.cpp", false, oProject.aConvert[0]);
			

		}*/
		
		
		
		
		
		private function buildFile(_nLine:UInt):Void {
			oFile.setReadLine(_nLine);
			
			if (oFile.isOpenFunction()) {
				Debug.fTrace(oFile.getLine);
				
			}
			
			
			
		}
		
	
	}
