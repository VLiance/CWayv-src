package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SFind;
	import language.TextType;
	import language.vars.special.EnumObj;
	import language.vars.special.UnitObj;
	import language.vars.special.UseEnum;
	import language.vars.special.UseUnit;
	import language.base.Debug;
	

	class VarHoldEnum extends CommonVar {

		public var oEnumRef   : EnumObj;
		
		public var oEnumFull   : VarObj;
		public var sTypeNotIni  : String;
		public var bMultiLoc  : Bool = false;
		public var aMultiLoc  : Array<Dynamic> = [];
		
		public function new(_oSBloc:SBloc, _sType:String) {
			super(_oSBloc, EuVarType._HoldEnum);
			
			if (TextType.aLastClassLoc.length > 0) {
				aMultiLoc =  TextType.aLastClassLoc.copy();
				_sType = aMultiLoc[aMultiLoc.length - 1];	
				bMultiLoc = true;
			}
			
			sTypeNotIni = _sType;
			if (_oSBloc.oSClass.oSProject.bClassLoaded ) {
				applyRefUnit();
			}

		}
		
		public function applyRefUnit():Void {
			
			var _oSearchBloc : SBloc = oSBloc;
			if (bMultiLoc) {
				_oSearchBloc = SFind.findClass(oSBloc.oSClass, aMultiLoc[0] ); //only one class for now (Possibility of more?)
			}
			
			var _oEnum : VarObj = SFind.findEnum(_oSearchBloc, sTypeNotIni);
			if (_oEnum != null) {
				oEnumFull = _oEnum;
				if (_oEnum.eType == EuVarType._Enum) {
					oEnumRef = cast(_oEnum,EnumObj);
				}else { //UseEnum
					oEnumRef = cast(_oEnum,UseEnum).oEnum;
				}
		
			}else {
				Debug.fError("Rtu Unit not found : " + sTypeNotIni);
				Debug.fStop();
			}
			sTypeNotIni = null; //Delete?
		}
		
		
		
		
		
		
	}
	
		
