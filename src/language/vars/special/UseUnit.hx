package language.vars.special ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SClass;
	import language.vars.varObj.VarObj;
	/**
	 * ...
	 * @author ...
	 */
	class UseUnit extends VarObj {
		
		public var oUnit  : UnitObj;
		public var oSClass  : SClass;
	
		public function new(_oSClass:SClass, _oUnit:UnitObj):Void {
			super();
			eType = EuVarType._UseUnit;
			oSClass = _oSClass;
			oUnit = _oUnit;
		}
		
		
	}

