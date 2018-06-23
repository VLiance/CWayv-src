package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarAny extends CommonVar {

		
		public function new(_oSBloc:SBloc) {
			super(_oSBloc, EuVarType._Any);
		}
		
				
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVarVal(new VarAny(_oSBloc) );
		}		
					
		private function copyVarVal(_oCopy:VarAny):VarObj { 
			return copyCommonVar(_oCopy);
		}
	}
	
		
