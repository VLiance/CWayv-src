package language;
	
	import language.enumeration.EuBetween;
	import language.pck.FileImport;
	import language.project.convertSima.SFrame;
	import language.project.CppProject;
	import language.project.SProject;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	

	import language.base.Root;
	//import language.base.InSprite;
	import language.base.Debug;
	//import mx.core.UITextField;
	//import ssp.application.Application;
	//import ssp.filesystem.File;
	
	
	/**
	 * @author Maeiky
	 */	
	class CwmImport  {
		
		public var oCwmFile : CwmFile;
		
		public var sCWaveMakePath : String = "";
		public var bReadOnly : Bool = true;
		public var sExportPath : String = "";
		public var bIncludeRecursive : Bool; //TODO ?
		
		public function new( _oCwmFile: CwmFile, _sLine:String , _bIncludeRecursive = false) {
			oCwmFile = _oCwmFile;
	
			bIncludeRecursive = _bIncludeRecursive;
			var _nIndex : Int = Text.search(_sLine,  "(");
			if (_nIndex > 0) {
				fExtractParam(Text.between3(_sLine, _nIndex + 1, EuBetween.Priority));
			}else {
				Debug.fError("Import parameters not found");
			}
			
		}
		
		
		public function fExtractParam( _sParamList : String) {
			
			var _aParamList : Array<Dynamic> = Text.surfaceSplit(_sParamList, ",");
			
			if(Text.between3(_aParamList[0], 0, EuBetween.CodeDelim) != null){
				sCWaveMakePath = Text.between3(_aParamList[0], Text.nCurrentIndex  , EuBetween.EndString )  ;
			}else {
				Debug.fError("Import param #1 require string \"\"");
			}
			
						
			if (_aParamList.length > 1) {
				var _sBool :String = Text.between3(_aParamList[1], 0, EuBetween.Word) ;
				if (_sBool == "false") {
					bReadOnly = false;
				}
			}
			
			if(_aParamList.length > 2){
				if(Text.between3(_aParamList[2], 0, EuBetween.CodeDelim) != null){
					sExportPath = Text.between3(_aParamList[2], Text.nCurrentIndex  , EuBetween.EndString )  ;
				}else {
					Debug.fError("Import param #3 require string \"\"");
				}
			}

/*
			Debug.trace3("sCWaveMakePath: " + sCWaveMakePath);
			Debug.trace3("bReadOnly: " + bReadOnly);
			Debug.trace3("sExportPath: " + sExportPath);*/

		}
		
		
		
		
		
	}
