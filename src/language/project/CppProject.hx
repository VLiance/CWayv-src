package language.project ;
	import haxe.io.Path;
	import language._system.System;
	import language.cwMake.line.PCH;
	import language.cwMake.line.Rc;
	import language.cwMake.line.Require;
	import language.CwmFile;
	import language.CwmLib;
	import language.enumeration.EuBetween;
	import language.MyFile;
	import language.pck.GroupSLib;
	import language.pck.SLib;
	import language.project.convertCpp.CommonCpp;
	import language.project.convertCpp.CppFile;
	import language.project.convertCpp.CppMainFile;
	import language.project.convertCpp.DefHeaderFile;
	import language.project.convertCpp.FileForm;
	import language.project.convertCpp.GpuFuncCpp;
	import language.project.convertCpp.GpuFunctions;
	import language.project.convertCpp.HCommonStructFile;
	import language.project.convertCpp.HDelegateFile;
	import language.project.convertCpp.HeaderFile;
	import language.project.convertCpp.LibCpp;
	import language.project.convertCpp.LibH;
	import language.project.convertCpp.LibIni;
	import language.project.convertCpp.OverPlaceFile;
	import language.project.convertSima.ExtractBlocs;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.ProjectData;
	import language.Text;
	import language.base.InObject;
	import language.base.Root;
	import language.base.Debug;
	import language.project.convertSima.SPackage;
	
	import language._system.FileSys;
	import language._system.FileSysStat;
	
	
	//FileStat 
	//import ssp.filesystem.File;
	//import ssp.filesystem.FileStat;
	
	/**
	 * ...
	 * @author ...
	 */
	class CppProject  extends InObject {
		
		public static var nTotalExtract : UInt = 0;

		//public static var sStaticPrefix : String = "_";
		public static var sStaticPrefix : String = "cs";
		
		//public static var sCppDir : String = "_cpp/"; //To delete?
		public static var sCppDir : String = ""; //To delete?
		
		private var bConvertFullDebug : Bool;
		private var sTab : String; 
		private var aCppFile : Array<Dynamic> = [];
		private var aUsedLib : Array<Dynamic> = [];
		private var aHFile : Array<Dynamic> = [];
		private var aOverPlace : Array<Dynamic> = [];
		private var aCppBuilList : Array<Dynamic>;
		private var aVerifyCppBuildList : Array<Dynamic>;
		
		private var aDefHFile : Array<Dynamic> = [];
		private var aCppFileFound : Array<Dynamic> = [];
	//	public var oMainFile : CppMainFile;
	//	private var oHDelegateFile : HDelegateFile;
		private var oHCommonStructFile : HCommonStructFile;
		
		public var sCppMainHeader : String = "mainHeader.h";
		//public var sFullPath : String;
		//public var sCppBaseLibName : String;
		public var sAppName : String;
		public var oProject : ProjectData;
		
		//public var sPath : String;
		public var sLibPath : String;
		//public var sLibRelativePath: String;
		public var sName : String;
		public var oSProject : SProject;
		public var aCommunStruct : Array<Dynamic> = [];
		public var oGpuFunc : SClass;
		public var sPlaformTarget : String;
		public var bNoBuild : Bool = false;
		
		
		
		public var  sCompilerPath : String = "TODO/";
		
		
		public function fAddUsedLib(_oLib:SLib){
			for (_oCurrLib in aUsedLib){
				if (_oLib == _oCurrLib){
					return;
				}
			}
			aUsedLib.push(_oLib);
		}

		public function new(_Main:Root, _oProject:ProjectData,  _oSProject:SProject, _sPath:String, _sLibPath:String, _sAppName : String, _bConvertFullDebug : Bool, _sPlaformTarget : String, _sBuildType:String) {
			super(_Main);
		}
		public function fIni(_Main:Root, _oProject:ProjectData,  _oSProject:SProject, _sPath:String, _sLibPath:String, _sAppName : String, _bConvertFullDebug : Bool, _sPlaformTarget : String, _sBuildType:String) {
			
			sPlaformTarget = _sPlaformTarget;
			oProject = _oProject;
			//sFullPath = _oProject.sRootPath + _sPath;
			oSProject = _oSProject;
		//	sCppBaseLibName = oSProject.sCppBaseLibName;
			
		//	nTotalExtract = 0;
			
			aHFile = [];
			aOverPlace = [];
			aCppFile = [];
			aDefHFile = [];
			aCommunStruct = [];
			
			bNoBuild = false;
			switch(_sBuildType) {
				case "NoBuild":
					bNoBuild = true;
				////break;
			}
			
			//Path
			//sPath = _sPath;
			//sLibPath = _sLibPath;
			
			
		//	sName = MyFile.getLastFolder(_sPath); //Not work???
			sName = "TodoCppPorjectName"; //

			//sLibRelativePath = mFile.getRelativePath(sPath, sLibPath, false);
		
			
			sAppName = _sAppName;
			bConvertFullDebug = _bConvertFullDebug;

			//MainFile
		//	oMainFile = new CppMainFile(Main, this, oSProject.oMainSPackage);
	//		oHDelegateFile = new HDelegateFile(Main, this, oSProject.oSDelegate);
			//oHCommonStructFile = new HCommonStructFile(Main, this, oSProject.oSDelegate, oSProject);
			/*
			var _i:UInt = oSProject.aLibList.length;
			for (i in 0 ..._i) {
				var _oLib : SLib = oSProject.aLibList[i];
				if(_oLib.oMergeSource == null){ //If merged, dont replace file second time
					aCommunStruct.push(new HCommonStructFile(Main, this, oSProject.oSDelegate, oSProject, _oLib ));
				}
			}*/
			
			aUsedLib = [];
			//Detect subclass
			for (_oPckg in  oSProject.aPackage) {
				if ( (_oPckg.oSLib.sPlatform == "" || _oPckg.oSLib.sPlatform == _sPlaformTarget)){
					fAddUsedLib(_oPckg.oSLib);
					//	Debug.fInfo("TEST: " + _oPckg.sFilePath +  "  --  " + _oPckg.oSLib.sName);
				}
			}
			
			//for (_oLib in oSProject.aLibList){
			//	Debug.fInfo("HAVE: " + _oLib.sName);
			//}
			for (_oLib in aUsedLib){
				Debug.fAssist("[C~:Lib]|" + _oLib.sName + "|");
			}
			
			//Create all class
		//	var _i:UInt = oSProject.aClass.length;for (i in 0 ..._i) {var _oSClass : SClass =  oSProject.aClass[i];
			for (_oPckg in  oSProject.aPackage) {
				if(!_oPckg.oSLib.bReadOnly && !_oPckg.oSFrame.bWrapper  && (_oPckg.oSLib.sPlatform == "" || _oPckg.oSLib.sPlatform == _sPlaformTarget)){
					
					
			
					//Extract functions if not already
					_oPckg.fExtractClasFunction();
					
					
					//Header
					aHFile.push( fCreateHeader(_oPckg) );
					
					if (_oPckg.fHaveConstant() ) {
						var _oDefHeader : DefHeaderFile = new DefHeaderFile(Main, this, _oPckg);
						aDefHFile.push(_oDefHeader);
						_oPckg.bDefHeader = true;
						_oPckg.oDefHeader = _oDefHeader;
					}
					
					//oSProject.aClass[i] = _oHeader; //MAybe
					
					//Class
					aCppFile.push(fCreateCpp(_oPckg));
					/*
					//OverPlace
					var _oOverPlace : OverPlaceFile = new OverPlaceFile(Main, this, oSProject.aClass[i]);
					aOverPlace.push(_oOverPlace);
					*/
					/*
					if ( SClass(oSProject.aClass[i]).sName ==  "SysGpuFunc") {
						oGpuFunc =  SClass(oSProject.aClass[i]);
					}*/
					
				}
				
			}
			
	
			//Debug.trac("Finish convert class")
		}
		
		public function fCreateHeader(_oSPck : SPackage):CommonCpp { 
		
		//	if (_oSClass.bGenerated) {
			if (_oSPck.bGenerated) {
				return new GpuFunctions(Main, this, _oSPck); //TODO check Tag
			}else{
				return new HeaderFile(Main, this, _oSPck);
			}
		}
		public function fCreateCpp(_oSPck : SPackage):CommonCpp { 
			//if (_oSClass.bGenerated) {
			if (_oSPck.bGenerated) {
				return new GpuFuncCpp(Main, this, _oSPck); //TODO check Tag
			}else{
				return new CppFile(Main, this, _oSPck);
			}
		}
		
		
		
		
		public static function fGetFilesInfo(_sPath:String):FileSysStat {
			
			if(FileSys.fExist(_sPath)){
				try{
					return FileSys.fStat(_sPath);
				//	 sys.FileSystem.stat("myFile.txt");
					//return File.getFileInfo(_sPath);
				} catch (err:String) {
				
				if (err.charAt(0) == ":") { //My errors
					//trace("Er");
					Debug.fError("Func Internal Error: " + err);
				}else {
					throw err; //throw away
				}
			}
			}
			return null;
		}
		
		public  function fGetModifiedCompilateurInfo():String {

		//	var _sCompilateurCpp : String = MyFile.getFullPathFromRelative(sCompilerPath, "../") + "cwc.exe"; 
			//var _sCompilateurCWift : String = sCompilerPath + "cwcc.exe";
			//var _sCompilateurCWift : String =  Sys.executablePath() + "cwcc.exe";
			var _sCompilateurCWift : String  = System.fProgramPath();
		//	var _oCompAS3 : FileStat = fGetFilesInfo(_sCompilateurAS3);
			var _oCompilateurCWift : FileSysStat = fGetFilesInfo(_sCompilateurCWift);
		//	var _oCompAS3 : FileStat = fGetFilesInfo(_sCompilateurAS3);
		
		//Debug.trace3("_sCompilateurCWift !! : " + _sCompilateurCWift);
		//Debug.fBreak();
			//if (_oCompAS3 == null || _sCompilateurAS3 == null){return ""; }
			if (_oCompilateurCWift == null){return ""; }
			//return  _oCompilateurCWift.mtime + "|"  + _oCompAS3.mtime;
			return  _oCompilateurCWift.dModTime.toString();
		}
		
		
		//public static var sCppWritePathOp : String; //Output
		public static var sGenPath : String; //Output
		public static var sCppWritePath : String; //Output
		public static var sCppWritePathCl : String; //Output
		public static var sCppWritePathCpp : String; //Output
		public static var sCppWritePathH : String; //Output
		public static var sCppWritePathDH : String; //Output
		public function fGetModifiedFilesInfo(_oSPackage:SPackage):String {
			
			var _sResult : String = "";
			var _sClassName : String = _oSPackage.sName; 
			var _sClassPath : String = _oSPackage.sPath; 

			var _sNxPath : String  =  _oSPackage.oSLib.sReadPath + _sClassPath + _sClassName + Setting.sFileExtention;
			
			sGenPath = _oSPackage.oSLib.sWritePath + _sClassPath + _sClassName;
			sCppWritePath = oProject.oCWaveMake.sExportBasePath  + sCppDir + _oSPackage.oSLib.sWritePath + _sClassPath ;
			sCppWritePathCl = sCppWritePath + _sClassName;
			sCppWritePathCpp = sCppWritePathCl + ".cpp";
			sCppWritePathH = sCppWritePathCl + ".h";	
			sCppWritePathDH = sCppWritePath + "_" + _sClassName + ".h";
			//sCppWritePathOp =  sCppWritePath + "__" + _sClassName + ".h";
			
			var _oCppInfo : FileSysStat = fGetFilesInfo(sCppWritePathCpp);
			var _oHInfo : FileSysStat= fGetFilesInfo(sCppWritePathH);		
			var _oNxInfo : FileSysStat = fGetFilesInfo(_sNxPath);
			if (_oCppInfo == null || _oHInfo == null || _oNxInfo == null) {
				return "Error";
			}

			_sResult  =	_oNxInfo.dModTime + "|" +  _oCppInfo.dModTime + "|" + _oHInfo.dModTime ;
					
			if (_oSPackage.bDefHeader) {

				var _oDefHInfo : FileSysStat = fGetFilesInfo(sCppWritePathDH);
				if(_oDefHInfo != null){
					_sResult += "|" + _oDefHInfo.dModTime ;
				}
			}
			
			return _sResult;
		}
		
		public function fGetModifiedFilesInfoLib(_oLib:SLib):String {
			sCppWritePath = oProject.oCWaveMake.sExportBasePath + sCppDir + _oLib.sWritePath +  _oLib.sWriteName;
			sCppWritePathH = sCppWritePath + ".h";	
			sCppWritePathCpp = sCppWritePath + ".cpp";
			
			var _oCppInfo : FileSysStat = fGetFilesInfo(sCppWritePathCpp);
			var _oHInfo : FileSysStat= fGetFilesInfo(sCppWritePathH);
			if (_oCppInfo == null || _oHInfo == null ) {
				return "Error";
			}
			return	 _oCppInfo.dModTime + "|" + _oHInfo.dModTime;
		}
		
	//W| _oCurrentPackage.sCppGetTime: 2018-12-28 23:08:30|2018-12-30 11:18:58|2018-12-30 11:18:58
	//W| _oCurrentPackage.sCppModTime: 2018-12-28 23:08:30|2018-12-30 11:18:58|2018-12-30 11:09:59
		public function fIsStrTimeMostRecent(_sIsGreater : String, _nCmp:String):Bool {
			var _bMostRecent : Bool = false;
		//	Debug.fWarning("fIsStrTimeMostRecent " + _sIsGreater.length + " "  + _nCmp.length);
			if (_sIsGreater.length == _nCmp.length){
				var i : Int = _sIsGreater.length;
				while(i > 0) {
					i--;
						
					var _sChar : String = _sIsGreater.charAt(i) ;
					if ( _sChar == '|' ){
							//		Debug.fWarning("| "+ i +" : " +  _bMostRecent);
						if (_bMostRecent){
							return true;
						}
					}else{
						if (_sChar > _nCmp.charAt(i) ){
							_bMostRecent = true;
						}else if (_sChar < _nCmp.charAt(i) ){
							_bMostRecent = false;
						}
						//Debug.fWarning(_sChar +" / " + _nCmp.charAt(i) + "  " + i +" : " +  _bMostRecent);
					}
				}
			}
			return _bMostRecent;
		}
		
		
		
		var sCompilateurModInfo : String;
		public function writeAllFiles():Void {
			

			
			aVerifyCppBuildList = [];
			aCppBuilList = [];
			//Todo Earase _oClass.sCppGetTime? Or set different of "" Useless?
			fRetreiveAllModificationInfo();
			
			var _oCurrentPackage : SPackage;
			var _oCppInfo : FileSysStat;
			var _oHInfo : FileSysStat;	
			var _oNxInfo : FileSysStat;

			sCompilateurModInfo = fGetModifiedCompilateurInfo();
			
			//Write all files
			var _i:UInt = aHFile.length;
			for (i in 0 ..._i) {
				var _oHeader : CommonCpp = aHFile[i];
				var _oCppFile : CommonCpp = aCppFile[i];
				//var _oOverPlaceFile : OverPlaceFile = aOverPlace[i];
				
				_oCurrentPackage = _oHeader.oSPackage;
				if ( !_oCurrentPackage.oSLib.bReadOnly && !_oCurrentPackage.oSFrame.bWrapper) { //not in readonly
					
					_oCurrentPackage.sCppModTime = fGetModifiedFilesInfo(_oCurrentPackage);
					if (_oCurrentPackage.sCppGetTime !=  _oCurrentPackage.sCppModTime || _oCurrentPackage.oSLib.sCompGetTime != sCompilateurModInfo) {
						//Debug.fWarning("-------------------" );
						//Debug.fWarning("_oCurrentPackage.sCppGetTime: " + _oCurrentPackage.sCppGetTime);
						//Debug.fWarning("_oCurrentPackage.sCppModTime: " +  _oCurrentPackage.sCppModTime );
						//Debug.fWarning("-------------------" );
							
						var bDebug : Bool = false; //TODO get compilation type !! not work  when remodify cw
						if (bDebug &&  _oCurrentPackage.oSLib.sCompGetTime == sCompilateurModInfo && fIsStrTimeMostRecent( _oCurrentPackage.sCppModTime,  _oCurrentPackage.sCppGetTime) ){
							Debug.fWarning("Generated Cpp file as been modified by user (allowed in debug): " + _oCurrentPackage.sFilePath);
							//aVerifyCppBuildList.push(sGenPath);//not sure??
							aCppBuilList.push(sGenPath);//not sure??
							Debug.fAssist( Setting.sShortName + Setting.sToCpp  + "| " + sCppWritePathCl.split("\\").join("/") );
						}else{
						
							//Debug.fError(_oCurrentClass.sName +  " sCppGetTime| " + _oCurrentClass.sCppGetTime + " sCppModTime " + _oCurrentClass.sCppModTime );
							//Debug.fError(_oCurrentClass.sName +  " sCompGetTime| " + _oCurrentClass.oSLib.sCompGetTime + " sCompilateurModInfo " + sCompilateurModInfo );
							aCppBuilList.push(sGenPath);
							
							if(!bNoBuild){
								MyFile.fwritefile(sCppWritePathH, _oHeader.aFile);
								MyFile.fwritefile(sCppWritePathCpp,  _oCppFile.aFile);
								if (_oCurrentPackage.bDefHeader) {
									MyFile.fwritefile(sCppWritePathDH, _oCurrentPackage.oDefHeader.aFile);
								}
								
								Debug.fAssist( Setting.sShortName + Setting.sToCpp  + "| " + sCppWritePathCl.split("\\").join("/") );
							}else{
							
								Debug.fAssist( "---| " + sCppWritePathCl.split("\\").join("/") );//?
							}
						}
						
					//	Debug.fTrace("");
					////	Debug.fTrace("sCppGetTime: " + _oCurrentClass.sCppGetTime);
					//	Debug.fTrace("sCppModTime: " + _oCurrentClass.sCppModTime);
					//	Debug.fTrace("");
						
						_oCurrentPackage.sCppModTime = fGetModifiedFilesInfo(_oCurrentPackage); //ReUpdate info

					}else {
						
						Debug.fAssist( Setting.sShortName +  Setting.sUpToDate +  "| " + sCppWritePathCl.split("\\").join("/") );
						//Debug.fAssist("Skip File : " + _oCurrentClass.sName);
						aVerifyCppBuildList.push(sGenPath);
					}
					
					
				}
			}
	
			
			var _sLibCppWrapper: String = fGetLibCppWrapper(); //Call before to get the list
			
		//	var startingTime:Int = getTimer(); 
			//Write compileList
			writeCwList();
			//Debug.fError("Elapsed time: " + String(endingTime - startingTime ));
			
			
			//All done now send compilation list to the IDE
			//fSendRequireList();
			fSendCompileList(_sLibCppWrapper);
			//fSendVerifyList();
	
			
			
		//	var endingTime:Int = getTimer();//TODO
 


		//	Debug.fError("Total Extracted Function : " + nTotalExtract);
			
			//		System.gc();
			
		}
		
		
		
		
		public function fSendCompileList(_sLibCppWrapper: String ):Void { //same list as above
			var _aAreadyPresent : Map<String, Bool> = [""=>false];
			
			var _sBuildList :  String = "";
			
			//Write all files
			var _i:UInt = aCppBuilList.length;
			for (i in 0 ..._i) {		
				var _sCppFile : String = aCppBuilList[i];
				_sBuildList += _sCppFile + "?";
				_aAreadyPresent[_sCppFile] = true;
				//Debug.fAssist("Lnx2Cpp| " + _sCppFile.split("\\").join("/") );
			}
			
			/*
			///Require list
			var _sRequire : String = "";
			for (var _oLibnx : CwmFile in  oProject.oCWaveMake.aCwm) {
				for(var _oRequire : Require in _oLibnx.aRequire) {
					if(_oRequire.sType == "cpp"){
						var _oLib : SLib = oSProject.fFindLibId(_oRequire.sLibId);
						var _sFile : String = _oLib.sWritePath + _oRequire.sPath;
						if (_aAreadyPresent[_sFile] != true) {
							_aAreadyPresent[_sFile]  = true;
							_sRequire += _sFile + "?";
						}
					}
				}
			}*/
			
			var _sLibPCH: String = fGetPCH();
			
					
			//Get cpp filelibOp list --> only when modified?
			var _sLibList : String = "";
			var _aList : Array<Dynamic>  =  oSProject.aLibList;
			for (i in 0 ... _aList.length) {
				var _oSLib : SLib = _aList[i];
				if (_oSLib.sPlatform == "" || _oSLib.sPlatform == sPlaformTarget ) {
					var _sFile : String =  _oSLib.sWritePath +  _oSLib.sWriteName;
					if (_aAreadyPresent[_sFile] != true) {
						_aAreadyPresent[_sFile]  = true;
						_sLibList += _sFile + "?";
					}
				}
			}
			
			//List on file to maybe recompile
			var _VerifyList :  String = "";
			var _i:UInt = aVerifyCppBuildList.length;
			for (i in 0 ..._i) {
				var _sCppFile : String = aVerifyCppBuildList[i];
				if (_aAreadyPresent[_sCppFile] != true) {
					_aAreadyPresent[_sCppFile]  = true;
					_VerifyList += _sCppFile + "?";
				}
			}
			
			//Include Lib list
			var _aLibExist : Map<String, Bool> = new Map<String, Bool>();
			var _sIncludeLibList :  String = "";
			var _aList : Array<Dynamic> = oSProject.aLibList;
			var _i:UInt = _aList.length;
			for (i in 0 ..._i) {
				var _oLib : SLib = _aList[i];
				if (_oLib.sPlatform == "" || _oLib.sPlatform == sPlaformTarget ) {
					var _aPath : Array<Dynamic> = _oLib.sWritePath.split("/");
					_aPath.pop();_aPath.pop();
					var _sPath : String = _aPath.join("/") + "/";
					if(_sPath != "/" && _aLibExist[_sPath] != true){
						_aLibExist[_sPath] = true;
						_sIncludeLibList += _sPath + "?";
					}
				}
			}
			
			//Overplace Lib list
			 _aLibExist  =  new Map<String, Bool>();
			var _sOpLibList :  String = "";
			_aList  = oSProject.aLibList;
			var _i:UInt = _aList.length;
			for (i in 0 ..._i) {
				var _oLib : SLib = _aList[i];
				if (_oLib.sPlatform == "" || _oLib.sPlatform == sPlaformTarget ) {
					if(_aLibExist[_oLib.sWriteName] != true){
						_aLibExist[_oLib.sWriteName] = true;
						_sOpLibList +=  _oLib.sWriteName + "?";
					}
				}
			}
			
			
			//Group folder
			//var _aLibGroupExist : Array<Dynamic> = [];
			var _sListGroupCompile :  String = "";
			for( _oGroup   in oSProject.aGroupLib  ) {
				for( _oSLib   in _oGroup.aSubLibList  ) {		
					if (_oSLib.sPlatform == "" || _oSLib.sPlatform == sPlaformTarget ) {
						var _aPath : Array<Dynamic> = _oSLib.sWritePath.split("/");
						_aPath.pop();
						var _sPath : String = _aPath.join("/") + "/";
						//if(_sPath != "/" && _aLibGroupExist[_sPath] != true){
						//	_aLibGroupExist[_sPath] = true;
							_sListGroupCompile += _sPath +  "_" + _oSLib.sIdName + ".gcpp" + "?";
						//}
					}
				}
				_sListGroupCompile += fGetRcCompileGroup(cast(_oGroup.aSubLibList[0],SLib).oCwmLib,  _oGroup.sName);
			}
			
			//Debug.fAssist("Lnx2Cpp| " + _sCppFile.split("\\").join("/") );
			Debug.fAssist("CppBuildList|" + oProject.oCWaveMake.sProjectName + "<" + oProject.oCWaveMake.sExportBasePath + "|" + _sBuildList + "|" +  _sLibList + "|" + _sLibCppWrapper + "|" + _VerifyList + "|" +  _sIncludeLibList + "|" + _sOpLibList  + "|" + _sLibPCH + "|" + _sListGroupCompile + "|");
		}
		
		
		public static function fGetRcCompileGroup(_oCwmLib: CwmLib, _sCheckName:String):String {
			var _sRcList : String = "";
			var _oCwmFile : CwmFile = _oCwmLib.oCwmFile;
			for ( _oRc  in _oCwmFile.aRc ) {
				if(_oRc.bEmbed == true && _oRc.sIdName  == _sCheckName){  //Todo detect if unused, detect from all cwm file?
				_sRcList += _oCwmLib.oLib.sWritePath + _oRc.sWriteCppPath + "_"  + _oRc.sRcName  +  ".gcpp"  + "?"; //TODO write path
				}
			}
			return _sRcList;
		}
		
		
		
		
		
		
		public function fGetLibCppWrapper():String {
			aCppFileFound = [];
			var _aInlude : Map<String,Bool> = [""=>false];
			var _sIncludeList : String = "";
			
			var _sReturn : String = "";
			var _aList : Array<Dynamic> = oSProject.aLibList;
			var _i:UInt = _aList.length;
			for (i in 0 ..._i) {
				var _oLib : SLib = _aList[i];
				if (_oLib.bReadOnly) { //LibCppWrapper
					
			
					///////// Include folder /////////
					var _sFolder : String = _oLib.sReadPath.split("\\").join("/"); 
					var _aFolder : Array<Dynamic> = _sFolder.split("/");
					_aFolder.pop();//Remove last folder
					_aFolder.pop();//Remove last folder
					_sFolder = _aFolder.join("/") + "/";
					if (_aInlude[_sFolder] != true) {
						_aInlude[_sFolder] = true;
						_sIncludeList +=  _sFolder + "<" + _oLib.sWritePath +  "<" + "Lib_" + _oLib.sName + "/" + "*";
					}
					//////////////////////////
					
					_sReturn +=  _oLib.sReadPath + "<" + _oLib.sWritePath + "<";
				//	var _aFiles:Array<Dynamic> = File.listFileNames(_oLib.sReadPath, "*.cpp", "all", true);
					//var _aFiles:Array<String> = FileSystem.readDirectory(_oLib.sReadPath); //TODO
					var _aFiles:Array<String> = FileSys.fReadDirectory(_oLib.sReadPath, true, ".cpp"); //TODO
					for ( j in 0 ...  _aFiles.length) {
						
						//var _sFile : String = _aFiles[j];
						var _sFile : String = _aFiles[j];
					  // var _sFilePart : String = _sFile.substring(_oLib.sReadPath.length, _sFile.length - 4).split("\\").join("/");
					   var _sFilePart : String = _sFile.substring(0, _sFile.length - 4); //Remove extention
					   
					  _sReturn += _sFilePart + "?";
					  aCppFileFound.push(_sFilePart);
					}	
					_sReturn += "*";
				}
			}
			return _sIncludeList + "|" + _sReturn;
		}
		
		
		public function fGetPCH():String {
			var _sPCH : String = "";
			
			for ( _oLibnx  in  oProject.oCWaveMake.aCwm) {
				//_sPCH += _oLibnx.sPath +  "<";
					
				for( _oPCH  in _oLibnx.aPCH) {
					var _oLib : SLib = oSProject.fFindLib(_oPCH.sLibId);
					var _sFile : String = _oPCH.sPath;
					/*
					if (_aAreadyPresent[_sFile] != true) {
						_aAreadyPresent[_sFile]  = true;
						_sRequire += _sFile + "?";
					}*/
					
					_sPCH += _oLib.sReadPath +  "<" + _oLib.sWritePath + "<" + _sFile + "?" + "*";
				}
				//_sPCH  += "*";
			}
			return _sPCH;
		//	Debug.fAssist("RequireList|" + oProject.oCWaveMake.sExportBasePath + "|" + _sRequire );
		}
		
		

		
		/*
		public function fSendVerifyList():Void { 
			var _sBuildList :  String = "";
			
			//Write all files
			var _i:UInt = aVerifyCppBuildList.length;
			for (i in 0 ..._i) {
				var _sCppFile : String = aVerifyCppBuildList[i];
				_sBuildList += _sCppFile + "?";
				//Debug.fAssist("Lnx2Cpp| " + _sCppFile.split("\\").join("/") );
			}
			//Debug.fAssist("Lnx2Cpp| " + _sCppFile.split("\\").join("/") );
			Debug.fAssist("VerifyCppBuildList|" + oProject.oCWaveMake.sExportBasePath + "|" + _sBuildList );
		}*/
		
		
		public function fSendRequireList():Void {
			var _sRequire : String = "";
			for ( _oLibnx  in  oProject.oCWaveMake.aCwm) {
			//	_oLibnx.sPath += "<";
			//	_oLibnx.sExportPath += "<";
					
				for( _oRequire  in _oLibnx.aRequire) {
				//	_sRequire  += _oRequire.sPath + "?";
					fCopyRequireFile(_oRequire, oProject.oCWaveMake.sExportBasePath + sCppDir);
				}
			
			//	_sRequire  += "*";
			}
			
		//	Debug.fAssist("RequireList|" + oProject.oCWaveMake.sExportBasePath + "|" + _sRequire );
			oProject.oCWaveMake.oMainCwe.aRequire;
		}
		
		

		
		public function fCopyRequireFile(_oRequire:Require, _sExpBasePath:String):Void {
			var _oLib : SLib = oSProject.fFindLib(_oRequire.sLibId);
		//	Debug.fAssist("RequireList|" + _oLib.sReadPath + _oRequire.sPath  + "?" + _sExpBasePath + _oLib.sWritePath + _oRequire.sPath );
			
			var _sPathFrom : String =  _oLib.sReadPath + _oRequire.sPath + "." + _oRequire.sType;
			var _sPathTo : String =  _sExpBasePath + _oLib.sWritePath + _oRequire.sPath + "." + _oRequire.sType;
			
			var _oInfoFrom : FileSysStat = fGetFilesInfo(_sPathFrom);
			if (_oInfoFrom == null) { //error
				Debug.fError("Require file not found: " +  _sPathFrom);
				return;
			}
			var _oInfoTo : FileSysStat = fGetFilesInfo(_sPathTo);
			if (_oInfoTo != null) {
				if (_oInfoFrom.dModTime.getTime() > _oInfoTo.dModTime.getTime() ) {
					//Copy Replace
					fCopy(_sPathFrom, _sPathTo);
				}
			}else {
				//Copy
				fCopy(_sPathFrom, _sPathTo);
			}
		}
		public function fCopy(_sSource  : String, _sTo : String):Void {
			Debug.fAssist("Copy " +  _sSource + " to " + _sTo);
		//	if (!File.fileExists(_sTo)) {
			if (!FileSys.fExist(_sTo)) {
				_sTo = _sTo.split("/").join("\\"); 
//				mFile.createFolderTree(_sTo);//CW TODO
			}
			//File.copyFile(_sSource, _sTo, true);
			FileSys.fCopy(_sSource, _sTo);
		}
		
		
		public function writeCwList():Void {
			var _aList : Array<Dynamic>  =  oSProject.aLibList;
	
			
			for (i in 0 ... _aList.length) {
				var _oSLib : SLib = _aList[i];
				
	
				if( sPlaformTarget == "" || _oSLib.sPlatform == sPlaformTarget || _oSLib.sPlatform == ""){
					writeLibCpp(_oSLib);
					writeCwListLib(_oSLib);
				}
				
			}
		}
		public function writeCwListLib(_oSLib : SLib):Void {
			
			ExtractBlocs.oCurrSClass = null;
			
			if (_oSLib.bReadOnly){//Not for interfaces
				return;
			}
			
			var _nCount : UInt = 0;
			var _oCompileList : FileForm = new FileForm(Main);
			var _aPckg : Array<SPackage>  =  _oSLib.aPackage;
			//Add Lib
			if ( !_oSLib.bReadOnly) { //not in readonly
				_oCompileList.pushLine( "#include \"" + _oSLib.sWriteName + ".cpp\"" ); //Alos Cpp?
			}
			for (_oPckg in _aPckg) {
			//for (_oSClass in  _oPckg.aClassList) {
				if ( !_oPckg.oSLib.bReadOnly &&  !_oPckg.oSFrame.bWrapper) { //not in readonly
					_nCount++;
					var _sClassName : String = _oPckg.sName; 
					var _sClassPath : String = _oPckg.sPath; 
					_oCompileList.pushLine( "#include \"" + _sClassPath + _sClassName + ".cpp\"" + " //" + _oPckg.sCppModTime);
				}
			}//}
			
			if (_oSLib.bReadOnly) { //bReadOnly = Cpp, add all .cpp founded
				for ( _sFile  in aCppFileFound) {
					_nCount++;
					_oCompileList.pushLine( "#include \"" + _sFile + ".cpp\"" + " //" ); 
				}
			}
			
			
			/*
			if (oGpuFunc && _oSLib == oSProject.oGzLib) { //Special for sysGPU
				_oCompileList.pushLine("//" + oGpuFunc.sCppModTime);
			}*/
			
			_oSLib.fCalculateCheckSum();
			_oCompileList.pushLine("//" + _oSLib.sClassListCheckSum);
			_oCompileList.pushLine("//" + _oSLib.sCppModTime);
			_oCompileList.pushLine("//" + fGetModifiedCompilateurInfo());
			
			
			if (_nCount != 0) {
				var _sPath : String = oProject.oCWaveMake.sExportBasePath + sCppDir + _oSLib.sWritePath +  "_" + _oSLib.sIdName + ".gcpp";
				MyFile.fwritefile(_sPath,  _oCompileList.aFile);
			//	Debug.fTrace("Create GCPP " +_sPath);
			}
		}
		public function writeLibCpp(_oSLib : SLib):Void {
			if (_oSLib.bReadOnly){return; }//Don't create cpp h lib for Readonly Lib ??!
			_oSLib.sCppModTime = fGetModifiedFilesInfoLib(_oSLib);
			var _sPath : String = oProject.oCWaveMake.sExportBasePath  + sCppDir  + _oSLib.sWritePath  + _oSLib.sWriteName;
				
			
			_oSLib.fCalculateCheckSum();
			if (_oSLib.sCppGetClassListChecksum != _oSLib.sClassListCheckSum  || _oSLib.sCppGetTime !=  _oSLib.sCppModTime || _oSLib.sCompGetTime != sCompilateurModInfo){
				var _oLibIni : LibIni = new LibIni(Main, _oSLib);
				MyFile.fwritefile(_sPath + ".icpp",  _oLibIni.aFile); //TODO RECREATE FILE IF CLASS LIST CHANGE!!
			}
			
			
			if (_oSLib.sCppGetTime !=  _oSLib.sCppModTime || _oSLib.sCompGetTime != sCompilateurModInfo) {
				
			
				var _oLibCpp : LibCpp = new LibCpp(Main, _oSLib);
				MyFile.fwritefile(_sPath + ".cpp",  _oLibCpp.aFile );
				
				var _oLibH : LibH = new LibH(Main, _oSLib);
				MyFile.fwritefile(_sPath + ".h",  _oLibH.aFile); 
				
			
				/*
				Debug.fTrace("    ------------------------------------------  ");
				Debug.fTrace("bReadOnly: "  + _oSLib.bReadOnly);
				Debug.fTrace("sIdName: "  + _oSLib.sIdName);
				Debug.fTrace("sReadPath: "  + _oSLib.sReadPath);
				Debug.fTrace("sPlatform: "  + _oSLib.sPlatform);
				Debug.fTrace("sWriteName: "  + _oSLib.sWriteName);
				Debug.fTrace("sWritePath: "  + _oSLib.sWritePath);
				Debug.fTrace("Lib: "  +_sPath);
				Debug.fTrace("sCompilateurModInfo : "  + sCompilateurModInfo);
				Debug.fTrace("_oSLib.sCompGetTime : "  + _oSLib.sCompGetTime );
				Debug.fTrace("       sCppGetTime  : "  +_oSLib.sCppGetTime );
				Debug.fTrace("_oSLib.sCppModTime  : "  + _oSLib.sCppModTime );
				*/

				_oSLib.sCppModTime = fGetModifiedFilesInfoLib(_oSLib);
				
				Debug.fAssist( Setting.sShortName + Setting.sToCpp  +  "| " + _sPath.split("\\").join("/") );
					//Debug.fAssist( Setting.sShortName + Setting.sToCpp  + "| " + sCppWritePathCl.split("\\").join("/") );
					
			}else{
				Debug.fAssist(  Setting.sShortName +  Setting.sUpToDate +  "| " + _sPath.split("\\").join("/") );
			//	Debug.fAssist(  Setting.sShortName +  Setting.sUpToDate +  "|Lib:" + _oSLib.sIdName +  ": " + _sPath );
				//	Debug.fAssist( Setting.sShortName +  Setting.sUpToDate +  "| " + sCppWritePathCl.split("\\").join("/") );
			}
		}
		
		
		public function fRetreiveAllModificationInfo():Void {
			var _aList : Array<Dynamic>  =  oSProject.aLibList;
			for ( i in 0  ...  _aList.length) {
				var _oSLib : SLib = _aList[i];
				//if(!_oSLib.bReadOnly || _oSLib == oSProject.oGzLib){
					fRetreiveModificationInfo(_oSLib);
			//	}
			}
		}
		
		
		public function fRetreiveModificationInfo(_oSLib : SLib):Void { 
			var _sPath : String = oProject.oCWaveMake.sExportBasePath  + sCppDir  + _oSLib.sWritePath +  "_" + _oSLib.sIdName + ".gcpp";
			_oSLib.sCompGetTime = "None";
			
			
			//Not for interface
			if (_oSLib.bReadOnly){
				return;
			}
				
				
			if(!FileSys.fExist(_sPath)){
				return;
			}
		
			
			
			//Debug.fWarning("----------- ReadFile  " + _sPath);//Debug.fBreak();
			var _aRead : Array<String> = MyFile.readFile(_sPath);  //TODO check if we have merged lib
			for (i in 1 ..._aRead.length) { //var i : UInt = 1 : Skip lib in first lin TODO mangage lib file modification info
				var _sLine : String = _aRead[i];
				//	Debug.fWarning("--_sLine  " + _sLine);//Debug.fBreak();
					
				var _nCurrIndex : Int = _sLine.indexOf("\"");
				if (_nCurrIndex != -1) {
					var _sResult : String = Text.between3(_sLine, _nCurrIndex + 1, EuBetween.EndString );
						//	Debug.fAssist("_sResult : " + _sResult);
					var _oPck : SPackage = oSProject.aImportCppLoc[_oSLib.sIdName + "/" + _sResult];
					if(_oPck != null){
						var _nIndex : Int = Text.search(_sLine, "/", _nCurrIndex + _sResult.length + 2 );
						if (_nIndex != -1) {
							var _sTime : String = _sLine.substr(_nIndex + 2);

							_oPck.sCppGetTime = _sTime;
						//Debug.fWarning("--Found  (" + _sPath + ") : "  + _oSLib.sIdName + "/"  + _sResult + " :: " + _sTime);//Debug.fBreak();
					
							//Debug.fAssist("_sTime : " + _sTime);
						}
					}else {
				//		Debug.fWarning("Not Found CppLoc (" + _sPath + ") : " + _oSLib.sIdName + "/"  + _sResult);//Debug.fBreak();
					}
				}
			}
		/*
			//GPU
			if (_oSLib == oSProject.oGzLib) { //Special case for sysGPU
				var _sGpuLine : String = _aRead[_aRead.length - 4];
				if (_sGpuLine.charAt(0) == "/" ) {
					var _sGpuTime : String = _sGpuLine.substr(2);
					oGpuFunc.sCppGetTime = _sGpuTime;
				}
			}
			*/
			var _sCompLine : String;
			var _sCompTime : String;
			
			
			
			//Lib Checksum
			 _sCompLine  = _aRead[_aRead.length - 3];
			if (_sCompLine.charAt(0) == "/" ) {
				_oSLib.sCppGetClassListChecksum = _sCompLine.substr(2);
			}else {
				Debug.fWarning("Lib Checksum mismatch: " + _oSLib.sName);
			}
			
			//Lib
			 _sCompLine  = _aRead[_aRead.length - 2];
			if (_sCompLine.charAt(0) == "/" ) {
				_sCompTime = _sCompLine.substr(2);
				_oSLib.sCppGetTime = _sCompTime;
			}else {
				Debug.fWarning("Lib TimeStamp mismatch: " + _oSLib.sName);
			}
			
			//Compialteur
			 _sCompLine  = _aRead[_aRead.length - 1];
			if (_sCompLine.charAt(0) == "/" ) {
				 _sCompTime = _sCompLine.substr(2);
				_oSLib.sCompGetTime = _sCompTime;
			}else {
				Debug.fWarning("Lib Compiler TimeStamp mismatch: " + _oSLib.sName);
			}
		}
		
		
		
	}
