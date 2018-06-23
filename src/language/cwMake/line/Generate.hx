package language.cwMake.line ;
	

	import language.CwmFile;
	import language.enumeration.EuBetween;
	import language.pck.FileImport;
	import language.project.convertSima.SFrame;
	import language.project.CppProject;
	import language.project.SProject;
	import language.Text;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	

	import language.base.Root;
	import language.base.Debug;
	/*
	import mx.core.UITextField;
	import ssp.application.Application;
	import ssp.filesystem.File;
	
	*/
	/**
	 * @author Maeiky
	 */	
	class Generate  {
		
		public var oCwmFile : CwmFile;
		
		public var sLibCWaveName : String = "";
		public var sReadCWavePath : String = "";
		public var sRelativeCWavePath : String = "";
		public var sRelativeWriteCppPath : String = "";
		
		public var sWriteCppPath : String = "";
		public var sIdName : String = "";

		
		public var sTag : String = "";

		
		public function new( _oCwmFile: CwmFile, _sLine:String ) {
			oCwmFile = _oCwmFile;
			
			var _nIndex : Int = Text.search(_sLine,  "(");
			if (_nIndex > 0) {
				fExtractParam(Text.between3(_sLine, _nIndex + 1, EuBetween.Priority));
			}else {
				Debug.fError("Addlib parameters not found");
			}
		}
		
		
		public function fExtractParam( _sParamList : String) {
			
			var _aParamList : Array<Dynamic> = Text.surfaceSplit(_sParamList, ",");
			
			if(Text.between3(_aParamList[0], 0, EuBetween.CodeDelim) != null){
				sLibCWaveName = Text.between3(_aParamList[0], Text.nCurrentIndex  , EuBetween.EndString )  ;
				sIdName = sLibCWaveName;
			}else {
				Debug.fError("Generate param #3 require string \"\"");
			}
			
			
			if(Text.between3(_aParamList[1], 0, EuBetween.CodeDelim) != null){
				sRelativeCWavePath = Text.between3(_aParamList[1], Text.nCurrentIndex  , EuBetween.EndString );
				//sReadCWavePath = oCwmFile.sPath + sRelativeCWavePath;
				//sReadCWavePath = oCwmFile.sLibPath + sRelativeCWavePath;
				sReadCWavePath = oCwmFile.sPath + sRelativeCWavePath;
	
 			}else {
				Debug.fError("Generate param #1 require string \"\"");
			}
			
			if(Text.between3(_aParamList[2], 0, EuBetween.CodeDelim) != null){
				sRelativeWriteCppPath = Text.between3(_aParamList[2], Text.nCurrentIndex  , EuBetween.EndString )  ;
				sWriteCppPath = oCwmFile.sExportPath + sRelativeWriteCppPath;
			//	Debug.trace3("----Write sWriteCppPath : " + sWriteCppPath);
			//	Debug.trace3("--Read Path : " +  sReadCWavePath);
			}else {
				Debug.fError("Generate param #2 require string \"\"");
			}
			
			if(_aParamList.length > 3){
				if(Text.between3(_aParamList[3], 0, EuBetween.CodeDelim) != null){
					sTag = Text.between3(_aParamList[3], Text.nCurrentIndex  , EuBetween.EndString )  ;
				}else {
					Debug.fError("Generate param #4 require string \"\"");
				}
			}
			
			

		}
	}
