package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarResultModifier extends VarObj  {  //Maybe not commonvar

		//public var nModifier   : UInt = 0;
		public var bScopeConvert   : Bool = false;
		public var bScopeExtract   : Bool = false;
		public var bNewCreation   : Bool = false;
		public var oRef   : VarObj ;
		public var oTemplateType   : VarObj ;
		
		public function new(_oRef:VarObj) {
			super();
			oRef = _oRef;
			eType = EuVarType._ResultModifier;
		}
	}
	
		
