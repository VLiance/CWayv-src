package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	

	class GateFuncCall extends FuncCall {
		
		public var oSClass  : SClass;

		public function new(_oSBloc:SBloc, _oSClass:SClass, _oSFunc:SFunction, _oCallerType:VarObj) {
			super(_oSBloc, _oCallerType);
			eType =  EuVarType._GateFuncCall;
			oFunction = _oSFunc;
			oSClass = _oSClass;
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyExtendFuncCall(new GateFuncCall(_oSBloc, oSClass, oFunction, oCallerType) );
		}		
					
		private function copyExtendFuncCall(_oCopy:GateFuncCall):VarObj {
			_oCopy.oSClass = oSClass;
			return copyFuncCall(_oCopy);
		}
		
		
	}
	
		
