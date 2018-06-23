package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	

	class LineLoc extends LineObj {
		
		
		public var oVarInput  : VarObj;
		public var oResultVar  : VarObj;
		public var sBefore  : String; //use for convertion
		public var bLast  : Bool; //use for convertion
		
		public function new():Void {
			super();
			eType = EuVarType._LineLoc;
		}
		
		
		override public function copy(_oSBloc:SBloc):VarObj {
			var _oLine : LineLoc = new LineLoc();
			_oLine.oSBloc = oSBloc;
			return copyLineLineLoc(_oLine);
		}	
		
		private function copyLineLineLoc(_oCopy:LineLoc):VarObj {
			_oCopy.oVarInput = oVarInput;
			_oCopy.oResultVar = oResultVar;
			_oCopy.sBefore = sBefore;
			_oCopy.bLast = bLast;
			return copyLineObj(_oCopy);
		}
			
	
	}
	
		
