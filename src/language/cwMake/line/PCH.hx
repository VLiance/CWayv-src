package language.cwMake.line;
	
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
	//import mx.core.UITextField;
	//import ssp.application.Application;
	//import ssp.filesystem.File;
	
	
	/**
	 * @author Maeiky
	 */	
	class PCH  {
		
		public var oCwmFile : CwmFile;
		
		public var sPath : String = "";
		public var sType : String = "";
		public var sLibId : String;
		
		public function new( _oCwmFile: CwmFile, _sLine:String ) {
			oCwmFile = _oCwmFile;

			var _nIndex : Int = Text.search(_sLine,  "(");
			if (_nIndex > 0) {
				fExtractParam(Text.between3(_sLine, _nIndex + 1, EuBetween.Priority));
			}else {
				Debug.fError("PCH parameters not found");
			}
		}
		
		
		public function fExtractParam( _sParamList : String) {
			
			var _aParamList : Array<Dynamic> = Text.surfaceSplit(_sParamList, ",");
			
			if(Text.between3(_aParamList[0], 0, EuBetween.CodeDelim) != null){
				sLibId = Text.between3(_aParamList[0], Text.nCurrentIndex  , EuBetween.EndString )  ;
			}else {
				Debug.fError("PCH param #1 require string \"\"");
			}
			
				
			if(Text.between3(_aParamList[1], 0, EuBetween.CodeDelim) != null){
				sPath = Text.between3(_aParamList[1], Text.nCurrentIndex  , EuBetween.EndString );
				var _nIndex : Int = sPath.length - 1;
				//Get Extention
				while (_nIndex > 0 && sPath.charAt(_nIndex) != "." && sPath.charAt(_nIndex) != "\\"  && sPath.charAt(_nIndex) != "/") {
					_nIndex--;
				}
				if (sPath.charAt(_nIndex) == "." ) {
					sType = sPath.substr(_nIndex + 1);
				}
				sPath = sPath.substr(0, _nIndex);
				
				
				
			}else {
				Debug.fError("PCH param #2 require string \"\"");
			}


		}

	}
