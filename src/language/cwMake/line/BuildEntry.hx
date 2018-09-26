package language.cwMake.line;
	

	import language.pck.FileImport;
	
	import language.CwmFile;
	import language.base.Debug;
	import language.enumeration.EuBetween;
	import language.project.convertSima.SFrame;
	import language.project.CppProject;
	import language.project.SProject;
	import language.Text;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	

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
	class BuildEntry  {
		
		public var oCwmFile : CwmFile;
		
		
		public var sFolder : String = "";  //sLib = File FolderName
		public var sLib_IdName : String = "";  //sLib = File FolderName  -> To REMOVE ???????
		public var sFile : String = "";
		public var sFileName : String = "";
		public var sPath : String = "";


		
		public function new( _oCwmFile: CwmFile, _sLine:String ) {
			oCwmFile = _oCwmFile;
			
			Debug.fTrace("new CwmFile: " +_sLine );
			
			
			_sLine = StringTools.replace(_sLine, "\\", "/");
			sFile = _sLine;
			
			
			
			sFileName = _sLine.substring(_sLine.lastIndexOf("/") + 1, _sLine.length);
			sPath = _sLine.substring(0,  _sLine.length - sFileName.length);
			if (sPath.charCodeAt(sPath.length-1) ==  "/".code){
				var _sSubPath : String = sPath.substring(0,sPath.length-1);
				sFolder = _sSubPath.substring(_sSubPath.lastIndexOf("/") + 1, _sSubPath.length);
			}
			
			//Debug.fTrace("sFileName: " +sFileName );
			//Debug.fTrace("sPath: " +sPath );
			if (sFolder == ""){
				Debug.fFatal("Entry must have a Folder specifying the lib name: " + sFileName);
			//	Debug.fTrace("Entry must have a Folder specifying the lib name: " + sFileName);
			}

			
			sLib_IdName = sFolder.substring(sFolder.indexOf("_") + 1,sFolder.length);
					/*
			Debug.fTrace("----BuildEntry---- "  + sFile);
			Debug.fTrace("sFileName "  + sFileName);
			Debug.fTrace("sLib_IdName "  + sLib_IdName);
			Debug.fTrace("sFolder "  + sFolder);
			Debug.fTrace("sPath "  + sPath);
*/
			
		
			
			//TODO Relative path?
			/*
			if (_sLine.charAt(1) != ":"){
				Debug.fTrace("TODO Make relative path"  + _sLine);
				//Debug.fTrace("oCwmFile.sPath " + oCwmFile.oMake.sCurrentDir);
				Debug.fTrace("oCwmFile.sPath " + oCwmFile.sPath);
				Debug.fTrace("oCwmFile.oMake.sPath " + oCwmFile.oMake.sCurrentDir);
				Debug.fTrace("oMake.sCurrentFile " + oCwmFile.oMake.sCurrentFile);
				Debug.fTrace("oMake.sExportBasePath" + oCwmFile.oMake.sExportBasePath);
				
			}*/
						

		}
		
		/*
		public function fExtractParam( _sParamList : String) {
			
			var _aParamList : Array<Dynamic> = Text.surfaceSplit(_sParamList, ",");
			
		
			if(Text.between3(_aParamList[0], 0, EuBetween.CodeDelim) != null){
				sLib = Text.between3(_aParamList[0], Text.nCurrentIndex  , EuBetween.EndString )  ;
			}else {
				Debug.fError("Addlib param #1 require string \"\"");
			}*/
			//Debug.trace3("BuildEntry : " +  sLib);
			
				/*
			if(Text.between3(_aParamList[1], 0, EuBetween.CodeDelim) != null){
				sWriteCppPath = Text.between3(_aParamList[1], Text.nCurrentIndex  , EuBetween.EndString )  ;
			}else {
				Debug.fError("Addlib param #2 require string \"\"");
			}
			
			if(Text.between3(_aParamList[2], 0, EuBetween.CodeDelim) != null){
				sLibCWaveName = Text.between3(_aParamList[2], Text.nCurrentIndex  , EuBetween.EndString )  ;
			}else {
				Debug.fError("Addlib param #3 require string \"\"");
			}
			
			if(_aParamList.length > 4){
				if(Text.between3(_aParamList[4], 0, EuBetween.CodeDelim) != null){
					sLibCppName = Text.between3(_aParamList[4], Text.nCurrentIndex  , EuBetween.EndString )  ;
				}else {
					Debug.fError("Addlib param #5 require string \"\"");
				}
			}
			
			if (_aParamList.length > 3) {
				var _sBool :String = Text.between3(_aParamList[3], 0, EuBetween.Word) ;
				if (_sBool == "true") {
					bReadOnly = true;
				}
			}*/
			

		//}
		
		
		
		
		
	}
