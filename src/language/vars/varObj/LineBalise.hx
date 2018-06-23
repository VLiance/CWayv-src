package language.vars.varObj {
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class LineBalise extends VarObj {  //Maybe not commonvar

		public var sCppLine : String;
		public var eCppType : UInt;
		
		
		
		public function new(_sCppLine:String, _eCppType : UInt ) {
			eCppType = _eCppType;
			sCppLine = _sCppLine;
			eType = EuVarType._CppLine;
		}
	}
	
		
