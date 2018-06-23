package language.vars.logicObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.VarObj;
	import language.base.Debug;
	

	class LogicFor extends SBloc {
		
		
		public var oIni  : VarObj;
		public var oCond  : VarObj;	
		public var oIncDec  : VarObj;	

		
		public function new(_oSParentBloc:SBloc):Void {
			super(_oSParentBloc);
			eType = EuVarType._LogicFor;
		}
			
	
	}
	
		
