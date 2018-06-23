package language.vars.special;

	import language.enumeration.EuVarType;
	import language.pck.SLib;
	import language.project.convertSima.SClass;
	import language.vars.varObj.VarObj;
	/**
	 * ...
	 * @author ...
	 */
	class TypeDef extends VarObj {
		
		public var sName  : String;
		public var oSLib : SLib;
	
		public function new(_oSLib:SLib, _sName:String):Void {
			super();
			eType = EuVarType._TypeDef;
			oSLib = _oSLib;
			sName = _sName;
		}
		
		
	}

