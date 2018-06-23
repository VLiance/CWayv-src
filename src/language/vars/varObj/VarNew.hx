package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	
	
	//FuncCall with param else we have SFunction (EuVarType._Function) direcly

	class VarNew extends FuncCall {
		
	
		public var oNewRef  : VarObj;

		
		override public function fGetType(_eOpt:UInt = 0):String {
			return "New";
		}
		
		public function new(_oSBloc:SBloc):Void {
			super(_oSBloc, null);
			eType = EuVarType._New;
		}
			
	
	}
	
		
