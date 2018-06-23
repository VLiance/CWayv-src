package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarVal extends CommonVar {

		
		public function new(_oSBloc:SBloc) {
			super(_oSBloc, EuVarType._Val);
		}
		
				
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVarVal(new VarVal(_oSBloc) );
		}		
					
		private function copyVarVal(_oCopy:VarVal):VarObj { 
			return copyCommonVar(_oCopy);
		}
	}
	
		
