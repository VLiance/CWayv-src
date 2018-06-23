package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	

	class ExtendFuncCall extends FuncCall {
		
		public var oSClass  : SClass;

		public function new(_oSBloc:SBloc, _oSClass:SClass, _oSFunc:SFunction, _oCallerType:VarObj) {
			super(_oSBloc, _oCallerType);
			eType =  EuVarType._ExtendFuncCall;
			oFunction = _oSFunc;
			oSClass = _oSClass;
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyExtendFuncCall(new ExtendFuncCall(_oSBloc, oSClass, oFunction, oCallerType) );
		}		
					
		private function copyExtendFuncCall(_oCopy:ExtendFuncCall):VarObj {
			_oCopy.oSClass = oSClass;
			return copyFuncCall(_oCopy);
		}
		
		
	}
	
		
