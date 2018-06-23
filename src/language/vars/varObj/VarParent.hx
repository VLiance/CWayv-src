package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarParent extends CommonVar {  //Maybe not commonvar

		
		public function new(_oSBloc:SBloc) {
			super(_oSBloc, EuVarType._Parent);
		}
	}

