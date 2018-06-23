package language.vars.logicObj ;
	import language.enumeration.EuBaliseLang;
	import language.enumeration.EuBetween;
	import language.enumeration.EuCppLineType;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.Text;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.VarObj;
	import language.base.Debug;
	

	class ScopeBalise extends SBloc {
		
		public var eBaliseSubType  : UInt;
		public var eBaliseLang  : EuBaliseLang;
		public var sBaliseName  : String = "Unknow";
		public var sParam : String = "";
		
		public function new(_oSParentBloc:SBloc, _sLine:String, _nIndex:UInt):Void {
			super(_oSParentBloc);
			eType = EuVarType._Balise;
			var _sWord : String = Text.between3(_sLine, _nIndex, EuBetween.Word);
			sBaliseName = _sWord;
			
			
			
			switch(_sWord) {
				case "glsl":
					eBaliseLang = EuBaliseLang.Glsl;
					
					var _nParamIndex : Int =  Text.search(_sLine, "(", _nIndex);
					if (_nParamIndex < 0) {
						Debug.fError("Glsl Tag require a ShaderBase obj in Param:  <glsl(oShaderBase)> ");
					}else {
					
						sParam = Text.between3(_sLine, _nParamIndex + 1, EuBetween.Priority);
						
					}
					
				//break;
				
				default:
					eBaliseLang = EuBaliseLang.Unknow;
				//break;
			
			}
			
		}
			
	
	}
	
		
