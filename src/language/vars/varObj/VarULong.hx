package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarULong extends CommonVar {
		
		public function new(_oSBloc:SBloc) {
			super(_oSBloc, EuVarType._ULong);
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVarULong(new VarULong(_oSBloc) );
		}		
					
		private function copyVarULong(_oCopy:VarULong):VarObj {
			return copyCommonVar(_oCopy);
		}
		
		
	}

