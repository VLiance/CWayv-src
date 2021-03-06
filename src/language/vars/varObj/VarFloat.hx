package language.vars.varObj ;
	import language.enumeration.EuBit;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarFloat extends CommonVar {

		public var nValue   : Float = 0;
		public var eBit   : EuBit;
		public var bEaseType   : Bool = false;
		
		public function new(_oSBloc:SBloc) {
			super(_oSBloc, EuVarType._Float);
			eBit = EuBit.nFast;
		}
		
		
		override public function fGetType():String {
			return "Float"  + EuBit_.getStringBit(this);
		}
		
		override public function fGetSingature():String {
			return "f";
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVarFloat(new VarFloat(_oSBloc) );
		}		
					
		private function copyVarFloat(_oCopy:VarFloat):VarObj {
			_oCopy.nValue = nValue;
			return copyCommonVar(_oCopy);
		}

	}
