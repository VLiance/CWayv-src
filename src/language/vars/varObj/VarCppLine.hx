package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.vars.logicObj.ScopeBalise;
	import language.enumeration.EuCppLineType ;

	class VarCppLine extends VarObj {  //Maybe not commonvar

		public var sCppLine : String;
		public var eCppType : EuCppLineType;
		public var oBalise : ScopeBalise;
		
		
		
		public function new(_oBalise : ScopeBalise, _sCppLine:String, _eCppType : EuCppLineType ) {
			super();
			oBalise = _oBalise;
			eCppType = _eCppType;
			sCppLine = _sCppLine;
			eType = EuVarType._CppLine;
		}
	}
	
		
