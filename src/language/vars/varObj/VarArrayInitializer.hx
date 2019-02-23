package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	

	class VarArrayInitializer extends VarObj {

		public var oSFunc  : SFunction;
		public var oSClass  : SClass;
		public var sInitilize  : String;

		public function new(_oSBloc:SBloc, _sInitilize:String) {
			super();
			eType =  EuVarType._ArrayInitializer;
			oSClass = _oSBloc.oSClass;
			sInitilize = _sInitilize;
			
		}
		
		public function fToCpp() : String{
			
			return "{" + sInitilize + "}";
		}
		
	}
	
		
