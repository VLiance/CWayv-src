package language;
	

	import language.cwMake.line.CWaveArg;
	import language.cwMake.line.Require;
	import language.enumeration.EuBetween;
	import language.pck.FileImport;
	import language.project.convertSima.SFrame;
	import language.project.CppProject;
	import language.project.SProject;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	

	import language.base.InObject;
	import language.base.Root;

	import language.base.Debug;
	/*
	import mx.core.UITextField;
	import ssp.application.Application;
	import ssp.filesystem.File;
	import ssp.system.System;
	import ssp.winapi.ShowWindowStyles;
	import ssp.application.Form;
	import ssp.application.TransparentForm;
	*/
	/**
	 * @author Maeiky
	 */	
	class CWaveMake extends InObject {
		

		public var sRootPath : String = "";
		public var sCurrentFile : String = "";
		public var sCurrentDir : String = "";
		
		public var sProjectName : String = "";
		
	//	public var aAllRequire : Array<Dynamic> = [];
	/*	

		
		public static var nHandleID : Int = 0;
		public static var bManaged : Bool = false;
		*/
		
		public var aLibPath : Array<String> = [];
		public var sExportBasePath : String = "_out/"; //Todo
		
		public var oMainCwe : CwmFile;
		public var aCwm : Array<CwmFile> = [];
		
		public var oArg : CWaveArg;
		
		//public var aCwmLib : Array<Dynamic> = [];
		
		public function new(_Main:Root, _sRootPath:String) {

	
			
			super(_Main);
			sRootPath = _sRootPath;

			oArg = new CWaveArg(_Main, sRootPath, fInsertModule());
			
			oMainCwe = oArg.oModule; // Not sure?
			
			
			
			
			/*
			
			sCurrentFile = oArg.sCurrentFile;
			sCurrentDir = oArg.sCurrentDir;
			
			if (sCurrentFile == ""){
				Debug.fError("Error: No CwMake File" );
			}
			
	
			//sProjectName = sCurrentFile.substring(0, sCurrentFile.length - 5 );
			sProjectName = sCurrentFile.split(".")[0];
			Out.fDebug("sProjectName:"  + sProjectName);
			*/
			/*
			sCurrentDir = File.getCurrentDirectory();
			//Debug.trace3("Arguemnts : " + Application.commandLineArguments.toString() );
			fExtractArgument(Application.commandLineArguments.toString());
			*/

	//		var _aRead : Array<String> = MyFile.readFile(oArg.sCurrentDir + oArg.sCurrentFile);
	//		oMainCwe = fInsertFile(_aRead, oArg.sCurrentDir, oArg.sCurrentFile, "", oArg.sCurrentDir); //Load first file of the project Test.as  //Todo change test
		
			
			//aImportCreated[sProjectFile + sMainFile + ".as"] = oMainSClass;    //Don't reload first file of the project Test.as	
		
			/*
			Debug.trace3("sCurrentDir: " + sCurrentDir);
			Debug.trace3("sCurrentFile: " + sCurrentFile);

			Debug.trace3("ExportBasePath: " + sExportBasePath);
			*/

		}
		
		
		public function fInsertModule():CwmFile {
			
			var _oFile : CwmFile = new CwmFile(Main, this);
			aCwm.push(_oFile);
			return _oFile;
		}
		
/*
		public function fInsertFile(_aFile:Array<String>, _sPath:String, _sName:String, _sExportPath:String,  _sLibPath:String, _bReadOnly: Bool = true ):CwmFile {
			
			var _oFile : CwmFile = new CwmFile(Main, this, _aFile, _sPath, _sName, _sExportPath, _sLibPath, _bReadOnly);
			aCwm.push(_oFile);
			return _oFile;
		}
		*/
		
		public function fAddLibPath(_sLib:String) :Void {
			var _nIndex : Int = Text.search(_sLib,  "(");
			if (_nIndex > 0) {
				_sLib = Text.between3(_sLib, _nIndex + 1, EuBetween.Priority);
			}else {
				Debug.fError("AddLibPath parameters not found");
			}
			
			if (Text.between3(_sLib, 0, EuBetween.CodeDelim) != null) {
				var _sLibPath : String = Text.between3(_sLib, Text.nCurrentIndex  , EuBetween.EndString );

				aLibPath.push(  MyFile.getFullPathFromRelative( oArg.sCurrentDir, _sLibPath ));
			}else {
				Debug.fError("AddLibPath require string \"\"");
			}
		}
		
		public function fSetExportBasePath(_sLine:String) :Void {
			var _nIndex : Int = Text.search(_sLine,  "(");
			if (_nIndex > 0) {
				_sLine = Text.between3(_sLine, _nIndex + 1, EuBetween.Priority);
			}else {
				Debug.fError("ExportBasePath parameters not found");
				return;
			}
			
			if(Text.between3(_sLine, 0, EuBetween.CodeDelim) != null){
				sExportBasePath = Text.between3(_sLine, Text.nCurrentIndex  , EuBetween.EndString ) ;
			}else {
				Debug.fError("ExportBasePath require string \"\"");
				return;
			}
			
			 sExportBasePath = MyFile.getFullPathFromRelative( oArg.sCurrentDir, sExportBasePath);
		}
		
		
		public function fPrintAll():Void {
			for (i in 0 ...  aCwm.length) {
				var _oCwmFile : CwmFile = aCwm[i];
				var _aLib : Array<Dynamic> = _oCwmFile.aLib;
				for (j in 0 ... _aLib.length) {
					var _oCwmLib : CwmLib = _aLib[j];
					fPrintLib(_oCwmFile,_oCwmLib );
				}
			}
	
		}
		
		public function fPrintLib(_oFile : CwmFile, _oLib: CwmLib):Void {
			Debug.fTrace("ReadPath : " +  _oFile.sPath + _oLib.oLib.sReadPath );
		}
		
		
		
	}
