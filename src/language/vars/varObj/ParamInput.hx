package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	

	class ParamInput extends LineObj {
		
		public var oVarInput  : CommonVar;

		public function new():Void {
			super();
			eType = EuVarType._ParamInput;
		}
			
	
	}
	
		
