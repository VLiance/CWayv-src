package language.vars.varObj ;
	import language.enumeration.EuStringFormat;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarString extends CommonVar {

		public var sValue   : String = "";
		public var eFormat   : EuStringFormat = EuStringFormat.None;
		
		public function new(_oSBloc:SBloc) {
			//bSpecial = true;
			super(_oSBloc, EuVarType._String);
		}
		
		
		
				
		override public function fGetType(_eOpt:UInt = 0):String {
			return "String";
		}

	}
	
		


/*

package language.vars.varObj {
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarString extends CommonVar {

		public var sValue   : String = "";
		
		public function VarString(_oSBloc:SBloc) {
			//bSpecial = true;
			super(_oSBloc, EuVarType._String);
		}
		

	}
	
		

*/