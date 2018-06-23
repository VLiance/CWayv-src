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
	
//import mx.core.UITextField;
	//import ssp.application.Application;
	//import ssp.filesystem.File;
	
	
	/**
	 * @author Maeiky
	 */	
	class Rc  {
		
		public var oCwmFile : CwmFile;
		
		public var sLibCWaveName : String = "";
		public var sReadCWavePath : String = "";
		//public var sRelativeCWavePath : String = "";
		public var sWriteCppPath : String = "";
		public var sIdName : String = "";
		public var sRcName : String = "";
	
		public var bEmbed : Bool = true;
		//public var sLibCppName : String = "";
	//	public var aRequire : Array<Dynamic> = [];
	//	public var sPlatform : String = "";
		
		//public var bLoadAll : Bool = false;

		
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
				sRcName = sIdName; //by default
			}else {
				Debug.fError("Rc param #0 require string \"\"");
			}
			
			if (_aParamList.length > 2) {
				if(Text.between3(_aParamList[2], 0, EuBetween.CodeDelim) != null){
					sRcName = Text.between3(_aParamList[2], Text.nCurrentIndex  , EuBetween.EndString )  ;
				}else {
					Debug.fError("Rc param #3 require string \"\"");
				}
			}
			
			if(Text.between3(_aParamList[1], 0, EuBetween.CodeDelim) != null){
				sReadCWavePath = Text.between3(_aParamList[1], Text.nCurrentIndex  , EuBetween.EndString );
				sWriteCppPath = sReadCWavePath + sRcName + "/";
				//sReadCWavePath = oCwmFile.sPath + sRelativeCWavePath;
			//	sReadCWavePath =  sRelativeCWavePath;
				
 			}else {
				Debug.fError("Rc param #1 require string \"\"");
			}
			
			
			//bEmbed
			if (_aParamList.length > 3) {
				var _sBool :String = Text.between3(_aParamList[3], 0, EuBetween.Word) ;
				if (_sBool == "false") {
					bEmbed = false;
				}
			}
			
					
			if(_aParamList.length > 4){
				if(Text.between3(_aParamList[4], 0, EuBetween.CodeDelim) != null){
					sWriteCppPath = Text.between3(_aParamList[4], Text.nCurrentIndex  , EuBetween.EndString )  ;
				}else {
					Debug.fError("Addlib param #4 require string \"\"");
				}
			}
	
			

		}
			
		
	}
