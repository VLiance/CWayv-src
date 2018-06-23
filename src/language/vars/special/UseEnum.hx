package language.vars.special ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SClass;
	import language.vars.varObj.VarObj;
	/**
	 * ...
	 * @author ...
	 */
	class UseEnum extends VarObj {
		
		public var oEnum  : EnumObj;
		public var oSClass  : SClass;
	
		public function new(_oSClass:SClass, _oEnum:EnumObj):Void {
			super();
			eType = EuVarType._UseEnum;
			oSClass = _oSClass;
			oEnum = _oEnum;
		}
		
		
	}

