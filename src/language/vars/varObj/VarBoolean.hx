package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarBoolean extends CommonVar {

		public var nValue   : Int = 0;
		
		public function new(_oSBloc:SBloc) {
			super(_oSBloc, EuVarType._Bool);
		}
		
		

	}
	
		
