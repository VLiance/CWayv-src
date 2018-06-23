package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SFind;
	import language.vars.special.UnitObj;
	import language.vars.special.UseUnit;
	import language.base.Debug;
	

	class VarRtu extends CommonVar {

		public var oUnitRef   : UnitObj;
		
		public var oUnitFull   : VarObj;
		public var sTypeNotIni  : String;
		
		public function new(_oSBloc:SBloc, _sType:String) {
			super(_oSBloc, EuVarType._Rtu);
			sTypeNotIni = _sType;
			if (_oSBloc.oSClass.oSProject.bClassLoaded ) {
				applyRefUnit();
			}
		}
		
		public function applyRefUnit():Void {
			
			var _oUnit : VarObj = SFind.findUnit(oSBloc, sTypeNotIni);
			if (_oUnit != null) {
				oUnitFull = _oUnit;
				if (_oUnit.eType == EuVarType._Unit) {
					oUnitRef = cast(_oUnit,UnitObj);
				}else { //UseUnit
					oUnitRef = cast(_oUnit,UseUnit).oUnit;
				}
		
			}else {
				Debug.fError("Rtu Unit not found : " + sTypeNotIni);
				Debug.fStop();
			}
			sTypeNotIni = null; //Delete?
		}
		
		
		
		
		
		
	}
	
		
