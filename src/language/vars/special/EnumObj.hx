package language.vars.special ;
	import language.enumeration.EuVarType;
	import language.enumeration.EuSharing;
	import language.project.convertSima.SClass;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.VarObj;
	/**
	 * ...
	 * @author ...
	 */
	class EnumObj extends VarObj {
		
		public var sName	    : String;
		//public var nLine	    : UInt;
		public var oSClass       : SClass;
		public var oSExtendClass : SClass;
		public var eSharing     : EuSharing;
		public var aVarList     : Array<Dynamic> = []; //array of VarObj
		public var sIniList     :String;
		public var bCpp     :Bool = false;
		public var aAlreadyIniVal  : Array<Dynamic> = [];
		
		public var oVarsType   : CommonVar;
		
		public function new():Void {
			super();
			eType = EuVarType._Enum;
		}
		
		public function isExtend():Bool {
			if (oSExtendClass == null) {
				return false;
			}
			return true;
		}
		public function pushVar(_oVar:VarObj):Void {
			aVarList.push(_oVar);
		}
		
		public function getCppName():String {
			//return oSClass.oSLib.sWriteName + "::" +  oSClass.sName + "::" + sName;
			return oSClass.sNsAccess + oSClass.sName + "::" + sName;
		}
		
		public function fGetCppDefaultVar(): String {
		
			if (aVarList.length > 0){
				return getCppName() + "::" + cast(cast(aVarList[0], ParamInput).oVarInput, CommonVar).sName;
			}
			return "0";
		}
		
		
	}

