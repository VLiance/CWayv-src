package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.pck.SLib;
	import language.project.convertSima.SClass;
	import language.vars.logicObj.CompareObj;
	import language.vars.special.TypeDef;
	import language.vars.varObj.VarObj;
	/**
	 * ...
	 * @author ...
	 */
	class CastTypeDef extends VarObj {
		
		public var oTypeDef : TypeDef;
		public var oVar : VarObj;
	
		public function new(_oTypeDef:TypeDef, _oVar:VarObj):Void {
			super();
			eType = EuVarType._CastTypeDef;
			oTypeDef = _oTypeDef;
			oVar = _oVar;
		}
	}
