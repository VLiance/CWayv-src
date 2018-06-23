package language;
	

	import language.enumeration.EuBetween;
	import language.pck.FileImport;
	import language.pck.SLib;
	import language.project.convertSima.SFrame;
	import language.project.CppProject;
	import language.project.SProject;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	


	import language.base.Debug;
//	import mx.core.UITextField;
//	import ssp.application.Application;
//	import ssp.filesystem.File;
	
	
	/**
	 * @author Maeiky
	 */	
	class CwmLib  {
		
		public var oCwmFile : CwmFile;
		/*
		public var sLibCWaveName : String = "";
		public var sReadCWavePath : String = "";
		public var sRelativeCWavePath : String = "";
		public var sWriteCppPath : String = "";
		public var sRelativeWriteCppPath : String = "";
		public var sIdName : String = "";
	
		public var bReadOnly : Bool = false;
		public var sLibCppName : String = "";
		public var aRequire : Array<Dynamic> = [];
		public var sPlatform : String = "";
		

		*/
		
				public var bLoadAll : Bool = false;
		
		public var oLib : SLib;
		

		
		public function new( _oCwmFile: CwmFile, _sLine:String , _bReadOnly : Bool = false) {
			oCwmFile = _oCwmFile;
			
			
			oLib = new SLib();
			oLib.oCwmLib = this;
			
			
			Debug.fTrace("--CwmLib _sLine "  + _sLine);
			
			_sLine = StringTools.replace(_sLine, "\\", "/");
			
		
			
		
			oLib.sReadPath = _sLine;
			

			var _sSubPath : String = _sLine;
			if (oLib.sReadPath.charAt(	oLib.sReadPath.length-1 ) ==  "/"){
				_sSubPath = _sLine.substring(0,_sLine.length-1);
			}
			
			oLib.sName  = _sSubPath.substring(_sSubPath.lastIndexOf("/") + 1, _sSubPath.length);
		//	oLib.sIdName  = oLib.sWriteName = oLib.sName;
			
		//	oLib.sIdName  = oLib.sName.substring(oLib.sName.indexOf("_") + 1, oLib.sName.length);
			
			oLib.sIdName  =	oLib.sName;
			
			
			if(oLib.sName.indexOf("Lib_") >= 0){
				oLib.sIdName  = oLib.sName.substring(oLib.sName.indexOf("Lib_") + 4, oLib.sName.length);
			}
			
			if (oLib.sIdName.indexOf(")") > oLib.sIdName.indexOf("(") ){
				oLib.sIdName  = oLib.sName.substring(oLib.sName.indexOf("(") + 1, oLib.sIdName.indexOf(")") );
			}
			
			
			oLib.sWriteName =  "Lib_" + oLib.sIdName;
			oLib.sWritePath = "Lib_" + oLib.sIdName + "/";
			
			oLib.bReadOnly = _bReadOnly;//Interface are readOnly
			
			Debug.fTrace("oLib.sReadPath "  + oLib.sReadPath);
			Debug.fTrace("oLib.sName "  + oLib.sName);
			Debug.fTrace("oLib.sIdName  "  + oLib.sIdName);
				
			
				
			/*
			var _nIndex : Int = _sLine.lastIndexOf("/");
			if (_nIndex != -1){
				sLibCWaveName = _sLine.substring(_nIndex, _sLine.length);
			}*/
			

			
			//TODO Relative path?
			if (_sLine.charAt(1) != ":"){
				Debug.fTrace("TODO Make relative path"  + _sLine);
				//Debug.fTrace("oCwmFile.sPath " + oCwmFile.oMake.sCurrentDir);
				Debug.fTrace("oCwmFile.sPath " + oCwmFile.sPath);
				Debug.fTrace("oCwmFile.oMake.sPath " + oCwmFile.oMake.sCurrentDir);
				Debug.fTrace("oMake.sCurrentFile " + oCwmFile.oMake.sCurrentFile);
				Debug.fTrace("oMake.sExportBasePath" + oCwmFile.oMake.sExportBasePath);
				
			}
						
						
			
			/*
			var _nIndex : Int = Text.search(_sLine,  "(");
			if (_nIndex > 0) {
				fExtractParam(Text.between3(_sLine, _nIndex + 1, EuBetween.Priority));
			}else {
				Debug.fError("Addlib parameters not found");
			}
			Debug.fTrace("Addlib: " +_sLine);
			
			*/
			
		}
		//AddLib("GzOpenGL", "SubLib_System/WinOpenGL/",   "SubLib_System/Lib_GZ_WinOpenGL/",      false,   "Lib_GZ_WinOpenGL",   "GzWinOpenGL", true, "Windows");



		/*
		public function fExtractParam( _sParamList : String) {
			
			var _aParamList : Array<Dynamic> = Text.surfaceSplit(_sParamList, ",");
			
			if(Text.between3(_aParamList[0], 0, EuBetween.CodeDelim) != null){
				sLibCWaveName = Text.between3(_aParamList[0], Text.nCurrentIndex  , EuBetween.EndString )  ;
				sIdName = sLibCWaveName;
			}else {
				Debug.fError("Addlib param #3 require string \"\"");
			}
			
			
			if(Text.between3(_aParamList[1], 0, EuBetween.CodeDelim) != null){
				sRelativeCWavePath = Text.between3(_aParamList[1], Text.nCurrentIndex  , EuBetween.EndString );
				//sReadCWavePath = oCwmFile.sPath + sRelativeCWavePath;
				//sReadCWavePath = oCwmFile.sLibPath + sRelativeCWavePath;
				sReadCWavePath = oCwmFile.sPath + sRelativeCWavePath;
	
 			}else {
				Debug.fError("Addlib param #1 require string \"\"");
			}
			
			if(Text.between3(_aParamList[2], 0, EuBetween.CodeDelim) != null){
				sRelativeWriteCppPath = Text.between3(_aParamList[2], Text.nCurrentIndex  , EuBetween.EndString )  ;
				sWriteCppPath = oCwmFile.sExportPath + sRelativeWriteCppPath;
			//	Debug.trace3("----Write sWriteCppPath : " + sWriteCppPath);
			//	Debug.trace3("--Read Path : " +  sReadCWavePath);
			}else {
				Debug.fError("Addlib param #2 require string \"\"");
			}
			
			
			if (_aParamList.length > 3) {
				var _sBool :String = Text.between3(_aParamList[3], 0, EuBetween.Word) ;
				if (_sBool == "true") {
					bReadOnly = true;
				}
			}
			
					
			if(_aParamList.length > 4){
				if(Text.between3(_aParamList[4], 0, EuBetween.CodeDelim) != null){
					sLibCppName = Text.between3(_aParamList[4], Text.nCurrentIndex  , EuBetween.EndString )  ;
				}else {
					Debug.fError("Addlib param #5 require string \"\"");
				}
			}
			
			if(_aParamList.length > 5){
				if(Text.between3(_aParamList[5], 0, EuBetween.CodeDelim) != null){
					sIdName = Text.between3(_aParamList[5], Text.nCurrentIndex  , EuBetween.EndString )  ;
				}else {
					Debug.fError("Addlib param #5 require string \"\"");
				}
			}
			
			
			if (_aParamList.length > 6) {
				var _sBool :String = Text.between3(_aParamList[6], 0, EuBetween.Word) ;
				if (_sBool == "true") {
					bLoadAll = true;
					oCwmFile.aLibLoadAll.push(this);
				}
			}
			
			if(_aParamList.length > 7){
				if(Text.between3(_aParamList[7], 0, EuBetween.CodeDelim) != null){
					sPlatform = Text.between3(_aParamList[7], Text.nCurrentIndex  , EuBetween.EndString )  ;
				}else {
					Debug.fError("Addlib param #7 require string \"\"");
				}
			}
	
		}
			*/
		
	}
