package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	

	class GateFunc extends VarObj {

		public var oSFunc  : SFunction;
		public var oSClass  : SClass;

		public function new(_oSClass:SClass, _oSFunc:SFunction) {
			super();
			eType =  EuVarType._GateFunction;
			oSClass = _oSClass;
			oSFunc = _oSFunc;
		}
	}
	
		
