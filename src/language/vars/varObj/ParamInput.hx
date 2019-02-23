package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	

	class ParamInput extends LineObj {
		
		public var oVarInput  : CommonVar;
		public var sOriLine  : String = ""; //Just to get prototype headers

		public function new(_sOriLine : String):Void {
			super();
			sOriLine = _sOriLine;
			eType = EuVarType._ParamInput;
		}
		
		override function fGetName():String {
			return oVarInput.fGetName();
		}
	
	}
	
		
