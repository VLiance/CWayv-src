package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarThis extends CommonVar {  //Maybe not commonvar

		public var nValue   : UInt = 0;
		
		public function new(_oSBloc:SBloc) {
			super(_oSBloc, EuVarType._This);
		}
	}

