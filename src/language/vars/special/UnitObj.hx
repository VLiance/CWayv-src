package language.vars.special;
	import language.enumeration.EuVarType;
	import language.enumeration.EuSharing;
	import language.project.convertSima.SClass;
	import language.vars.varObj.VarObj;
	/**
	 * ...
	 * @author ...
	 */
	class UnitObj extends VarObj {
		
		public var sName	    : String;
	//	public var nLine	    : UInt;
		public var oSClass       : SClass;
		public var oSExtendClass : SClass;
		public var eSharing     : EuSharing;
		public var aVarList     : Array<Dynamic> = []; //array of VarObj
		public var sIniList     :String;
		public var bCpp     :Bool = false;
		
		
		public function new():Void {
			super();
			eType = EuVarType._Unit;
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
		
		//public function getCppName(_oCurrentClass : SClass):String {
		public function getCppName():String {
			
			//return "_" + oSClass.sName + "::" + sName;
			return   oSClass.sNsAccess + oSClass.sName + "::" + sName;
		}
		
		public function getCppNameRtuMap():String {
			
			//return "_" + oSClass.sName + "::" + sName;
			return  oSClass.sNsAccess + oSClass.sName + "::_" + sName;
		}
		
		
		public function getCppClassDef():String {
			return   oSClass.sNsAccess + "c" + oSClass.sName + "::";
		}
		
		
	}

