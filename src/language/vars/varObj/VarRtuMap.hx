package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SFind;
	import language.vars.special.UnitObj;
	import language.vars.special.UseUnit;
	import language.base.Debug;
	

	class VarRtuMap extends VarRtu {
		
		public function new(_oSBloc:SBloc, _sType:String) {
	
			super(_oSBloc, _sType);
			eType = EuVarType._RtuMap;
		
		}


	}
		
