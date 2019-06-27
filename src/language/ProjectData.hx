package language;
	


	import language.cwMake.line.BuildEntry;
	import language.cwMake.line.CWaveArg;
	import language.pck.FileImport;
	import language.pck.SLib;
	import language.project.convertSima.SFrame;
	import language.project.CppProject;
	import language.project.SProject;
	import language.project.packLib.PackLib;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	

	import language.base.InObject;
	import language.base.Root;
	import language.base.Debug;


	
	
	/**
	 * @author Maeiky
	 */	
	class ProjectData extends InObject {
		
		private var bConvertDebug : Bool = true; //Convert with debug class : Debug.trace()
		

		//private var csCppStaticSuffix : String = "s_";


	
		
		//////////////////
		
		public var oCWaveMake : CWaveMake;
		public var oSProject : SProject;
		public var oCppProject : CppProject;

		
		/////
		private var oFile : MyFile; 
		
	//	public var sRootPath : String;
		//private var sRootPathS : String;
		
		public function new(_Main:Root) {
			super(_Main);
			
	//		sRootPath = _sFirstRootPath;
			

		
			
			//sRootPathS = oFile.convertSlash(sRootPath);
			
			//oFile = new MyFile(Main, _sFirstRootPath);
		
		}
		

		
		public function loadProject(_oCWaveMake: CWaveMake):Bool {
			
			oSProject = new SProject(Main, this); //Todo multiple SProject
			
			oCWaveMake = _oCWaveMake;
			
			fAddAllLib();
			fBuildEntryPoints();
			oSProject.setGZE_lib();
			oSProject.fTestAddFullImport();
		
			return true;
		}
		
		public function extract():Void {
			oSProject.extract();
		}
		
		
		
		///////////// MAKE ////////////////
		
		public function fAddAllLib():Void {
			var _aList : Array<Dynamic> =  oCWaveMake.aCwm;
			for (i in 0 ...  _aList.length) {
				var _oCwmFile : CwmFile = _aList[i];
				var _aLib : Array<Dynamic> = _oCwmFile.aLib;
				for (j in 0 ... _aLib.length) {
					var _oCwmLib : CwmLib = _aLib[j];
					fAddAllLibFile(_oCwmFile, _oCwmLib );
				}
			}
		}
		public function fAddAllLibFile(_oFile : CwmFile, _oLib: CwmLib):Void {
	/*
			var _bReadOnly : Bool = true;
			if (!_oFile.bReadOnly && !_oLib.oLib.bReadOnly) {
				_bReadOnly = false;
			}*/
			
			Debug.fTrace("--LIB : " + _oLib.oLib.sName + "  File " + _oFile.sName );
			
				//	Debug.fTrace("--LIB : " + _oLib.bReadOnly + "  File " + _oFile.bReadOnly );
		//	oSProject.addLib(_oLib, _oLib.sReadCWavePath, _oLib.sWriteCppPath, _oLib.sLibCWaveName, _bReadOnly, _oLib.sLibCppName, _oLib.sIdName, _oLib.bLoadAll, _oLib.sPlatform);
			oSProject.addLib(_oLib);
		
			
		}
		//	b(_sReadPath:String, _sWritePath:String, _sLibName:String, _bReadOnly:Bool, _sWriteName:String = null,
		
		
		public function fBuildEntryPoints():Void {
			var _aList : Array<Dynamic> =  oCWaveMake.aCwm;
			for (i in 0 ...  _aList.length) {
				var _oCwmFile : CwmFile = _aList[i];
				var _aEntry : Array<Dynamic> = _oCwmFile.aBuildEntry;
				for (j in 0 ... _aEntry.length) {
					var _oEntry : BuildEntry = _aEntry[j];
					fBuildEntryPointsFile(_oCwmFile, _oEntry );
				}
			}
		}
		
		public function fBuildEntryPointsFile(_oFile : CwmFile, _oEntry: BuildEntry):Void {
			//var _oMainLib : SLib = oSProject.fFindLib(_oEntry.sLib_IdName);
			var _oMainLib : SLib = oSProject.fFindLib(_oEntry.sFolder);
			
			oSProject.setMainLib(_oMainLib, null, null, _oEntry.sFileName );
			//oSProject.setMainLib(_oMainLib, null, null,  "MainEntry");
		}
		
		/////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		private static var bDone : Bool = false;
		/////////////////////////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////////////////////
		public function convertCW(_sCppPath:String, _sLibCppPath:String, _bMakeFile : Bool, _sAppName : String, _bConvertFullDebug : Bool, _sTarget:String = "", _sBuildType:String = ""):Bool {

			if(CWaveArg.bHaveToCompileFile){
				//if (!bDone) {
				//bDone = true;	
				if(oCppProject == null){
					oCppProject = new CppProject(Main, this, oSProject, _sCppPath, "", _sAppName, _bConvertFullDebug, _sTarget, _sBuildType);
				}
				oCppProject.fIni(Main, this, oSProject, _sCppPath, "", _sAppName, _bConvertFullDebug, _sTarget, _sBuildType);
				oCppProject.writeAllFiles();
				
				return true;
			}
			
			if (CWaveArg.bHavePackingLib){
				var _oPackLib : PackLib = new PackLib(Main);
				_oPackLib.fIni( this, oSProject, _sCppPath, "", _sAppName, _bConvertFullDebug, _sTarget, _sBuildType);
			}
			
			
			return false;
		}
		

		
		private function gbug():Void {
			var aTruc : Array<Dynamic>=[];aTruc = aTruc[5];//bug
		}
		
	}
