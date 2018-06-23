package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class EaseOut extends VarObj {

		public var oAssociate   : CommonVar;
		
		public function new(_oSBloc:SBloc) {
			super();
			eType = EuVarType._EaseOut;
		}
	}
	
		
