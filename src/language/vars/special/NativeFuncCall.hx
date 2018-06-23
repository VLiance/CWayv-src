package language.vars.special ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.vars.varObj.FuncCall;
	import language.vars.varObj.VarObj;
	

	class NativeFuncCall extends FuncCall {
		
		public var oSource : VarObj;
		public var oAssociate : VarObj;

		
		
		public function new(_oSBloc:SBloc, _oNativeFunc:SNatFunction, _oCallerType:VarObj) {
			super(_oSBloc, _oCallerType);
			

			eType =  EuVarType._NativeFuncCall;
			oFunction = _oNativeFunc;
		}
		
	
		
	}
	
		
