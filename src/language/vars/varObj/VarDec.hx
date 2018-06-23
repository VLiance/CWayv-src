package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarDec extends CommonVar {

		public var oVar   : VarObj;
		
		public function new(_oSBloc:SBloc) {
			super(_oSBloc, EuVarType._VarDec);
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVarDec(new VarDec(_oSBloc) );
		}		
					
		private function copyVarDec(_oCopy:VarDec):VarObj {
			_oCopy.oVar = oVar;
			return copyCommonVar(_oCopy);
		}
	}
	
		
