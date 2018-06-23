package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarInc extends CommonVar {

		public var oVar   : VarObj;
		
		public function new(_oSBloc:SBloc) {
			super(_oSBloc, EuVarType._VarInc);
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVarInc(new VarInc(_oSBloc) );
		}		
					
		private function copyVarInc(_oCopy:VarInc):VarObj {
			_oCopy.oVar = oVar;
		
			return copyCommonVar(_oCopy);
		}
		
	}
	
		
