package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.vars.logicObj.CompareObj;
	import language.vars.special.VarFixeArray;
	

	class VarNewArraySquare extends VarObj {  //Maybe not commonvar

		public var nSize   : UInt = 0;
		
		public var oIniArray   : VarFixeArray;
		public var nDimReq   : UInt;
		
		public function new(_oSBloc:SBloc, _nSize:UInt) {
			super();
			eType =  EuVarType._NewArraySquare;
			nSize = _nSize;
		}
	}
	
		
