package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarHex extends CommonVar {

		public var nValue   : UInt = 0;
		
		public function new(_oSBloc:SBloc) {
			super(_oSBloc, EuVarType._Hex);
		}
		
				
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVarHex(new VarHex(_oSBloc) );
		}		
					
		private function copyVarHex(_oCopy:VarHex):VarObj {
			_oCopy.nValue = nValue;
		
			return copyCommonVar(_oCopy);
		}
	}
	
		
