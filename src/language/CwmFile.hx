package language;

	import language._system.FileSys;
	import language.base.Debug;
	import language.cwMake.line.BuildEntry;
	import language.cwMake.line.CWaveArg;
	import language.cwMake.line.Generate;
	import language.cwMake.line.PCH;
	import language.cwMake.line.Rc;
	import language.cwMake.line.Require;
	import language.enumeration.EuBetween;
	import language.pck.FileImport;
	import language.project.convertSima.SFrame;
	import language.project.CppProject;
	import language.project.SProject;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	//import sys.FileSystem;
	

	import language.base.InObject;
	import language.base.Root;
	/*
	import language.base.InSprite;
	import language.base.Debug;
	import mx.core.UITextField;
	import ssp.application.Application;
	import ssp.filesystem.File;
	*/
	
	/**
	 * @author Maeiky
	 */	
	class CwmFile extends InObject {
		
		
		public var bReadOnly : Bool = true;
		public var oMake : CWaveMake;
		public var sPath : String;
		//public var sLibPath : String;
		public var sName : String;
		public var sExportPath : String = ""; //Not used?
		public var aFile : Array<Dynamic>;
		public var aCwm : Array<Dynamic> = [];
		
		
		
		public var aLib : Array<Dynamic> = [];
		public var aRc : Array<Dynamic> = [];
		public var aImport : Array<Dynamic> = [];
		public var aBuildEntry : Array<Dynamic> = [];
		public var aRequire : Array<Dynamic> = [];
		public var aPCH : Array<Dynamic> = [];
		public var aLibLoadAll : Array<Dynamic> = [];
		public var aGenerate : Array<Dynamic> = [];
		
		
		public function new(_Main:Root, _oMake: CWaveMake, _aFile:Array<String> = null, _sPath:String= "", _sName:String= "",  _sExportPath:String = "", _sLibPath:String= "", _bReadOnly:Bool = true ) {
			super(_Main);
			oMake = _oMake;
			sPath = _sPath;
			sName = _sName;
			aFile = _aFile;
			//sLibPath = _sLibPath;
			bReadOnly = _bReadOnly;
		//	sExportPath = _sExportPath;
		
		//	Out.fDebug("New CwmFile:"  + sPath);
		
			/*
			Text.fIniFile();
			for (i in 0 ... aFile.length) {
					//Out.fDebug("New CwmFileFile:"  + aFile[i]);
			
				fProcessLine( Text.removeComments( aFile[i]));
			}

			for (j in 0 ... aImport.length) {
				var _oImport : CwmImport = aImport[j];
				var _sPath : String = fFindFirstLibPath(_oImport.sCWaveMakePath);
				if (_sPath != "") {
					var _sFoundLibPath:String  = _sPath;
					var _aRead : Array<String> = MyFile.readFile(_sPath +  _oImport.sCWaveMakePath);
				
					
					var _sFinalPath : String =  MyFile.getFullPathFromRelative(_sPath, _oImport.sCWaveMakePath);
					var _nIndexFile : UInt =  CWaveArg.fGetFileStartIndex(_sFinalPath);
					var _sFileName : String = _sFinalPath.substring( _nIndexFile );
				
					_sFinalPath = _sFinalPath.substring(0, _nIndexFile );

					aCwm.push( oMake.fInsertFile(_aRead, _sFinalPath, _sFileName, _oImport.sExportPath, _sFoundLibPath, _oImport.bReadOnly) );	
					//aCwm.push( oMake.fInsertFile(_aRead, _sPath, _oImport.sCWaveMakePath, _oImport.sExportPath, _oImport.bReadOnly) );
				}
			
			}*/
		}
		
		public function fProcessLine(_sLine:String):Void {
		
			
			var _sWord : String = Text.between3(_sLine, 0,EuBetween.Word);

			if (_sWord != null) { //Not Empty line
				
				switch (_sWord) {
					
					case "Generate" :
						fGenerate( _sLine);
					//break;
					
					case "AddLib" :
						fAddLib( _sLine);
					//break;
					
					case "AddRc" :
						fAddRc( _sLine);
					//break;
					
					
					case "AddSearchLibPath" :
						oMake.fAddLibPath(_sLine);
					//break;
					
					case "ExportBasePath" :
						oMake.fSetExportBasePath(_sLine);
					//break;
					
					case "Import" :
						aImport.push(new CwmImport(this, _sLine));
					//break;
					
					case "BuildEntry" :
						aBuildEntry.push(new BuildEntry(this, _sLine));
					//break;
					
					case "Require" :
						var _oRequire : Require =  new Require(this, _sLine);
						aRequire.push(_oRequire);
					//break;
					
					case "PCH" :
						var _oPCH : PCH =  new PCH(this, _sLine);
						aPCH.push(_oPCH);
					//break;
				}
			}
		}
		
			
		public function fGenerate(_sLine: String) :Void {
			var _oGenerate : Generate = new Generate(this, _sLine);
			aGenerate.push(_oGenerate);
		}
		
		
		public function fAddRc(_sLine: String) :Void {
			var _oRc : Rc = new Rc(this, _sLine);
			aRc.push(_oRc);
		}
		
		
		
		
		
		
		public function fAddCompileEntry(_sLine: String) :Void {
				aBuildEntry.push(new BuildEntry(this, _sLine));	
		}
		
		
		public function fAddLib(_sLine: String,  _bReadOnly : Bool = false) :Void {
			var _oCwmLib : CwmLib = new CwmLib(this, _sLine, _bReadOnly);
			
			//Test if already exist, we cannot have 2 lib with same readpath
			for (  _oCwLib in  aLib){
				if (_oCwLib.oLib.sReadPath == _oCwmLib.oLib.sReadPath ){
					return; //Already exist
				}
			}
			
		
			aLib.push(_oCwmLib);
			
			//Debug.fTrace("AAAAAADDDD " + _sLine );
			//oMake.aCwmLib.push(_oCwmLib);
		}
		public function fSetExportPath(_sLine: String) :Void {
			sExportPath = _sLine; //To remove??
			oMake.sExportBasePath = _sLine;
		}
		
		
		
		
		
		public function fFindFirstLibPath(_sSubPath: String) :String {
			//Check current folder
			if (FileSys.fExist(oMake.sCurrentDir + _sSubPath)) {
				return oMake.sCurrentDir;
			}
			var _aPath : Array<Dynamic> = oMake.aLibPath;
			for (i in 0 ...  _aPath.length) {
				if (FileSys.fExist(oMake.aLibPath[i] + _sSubPath)) {
					return oMake.aLibPath[i];
				}
			}
		
			Debug.fError("CWM File not found : " + _sSubPath.split("\\").join("/") );
			Debug.fError(" -- Possible path are : ");
			Debug.fError((oMake.sCurrentDir + _sSubPath).split("\\").join("/") );
			for (j in 0 ... _aPath.length) {
				Debug.fError(" -----> " + (oMake.aLibPath[j] +"|"+ _sSubPath).split("\\").join("/") );
			}
			return "";
		}

	}
