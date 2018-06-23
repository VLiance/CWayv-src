package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	
	//FuncCall with param else we have SFunction (EuVarType._Function) direcly

	class CallDelegate extends FuncCall  {
		
		
		public var oDelegate  : Delegate;
		
		public function new(_oSBloc:SBloc, _oDelegate : Delegate, _oCallerType:VarObj):Void {
			super(_oSBloc, _oCallerType);
			eType =  EuVarType._CallDelgate;
			oDelegate = _oDelegate;
			oFunction = oDelegate.oSFunc;
		}
		
			
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyCallDelegate( new CallDelegate(_oSBloc, oDelegate, oCallerType));
		}		
					
		private function copyCallDelegate(_oCopy:CallDelegate):VarObj {
			
			_oCopy.oDelegate = oDelegate;
			
			return copyFuncCall(_oCopy);
		}
		
		
	
	}
	
		
