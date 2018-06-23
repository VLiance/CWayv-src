package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarAnyClass extends VarCallClass {  //Maybe not commonvar


		public function new(_oSBloc:SBloc, _sType:String, _bScopeOwner:Bool = false, _bWeak:Bool = false) {
			super(_oSBloc, "Class", _bScopeOwner, _bWeak);
			eType = EuVarType._AnyClass;
		}
	}

