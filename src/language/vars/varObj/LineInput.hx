package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	

	class LineInput extends LineObj {
		
		
		public var oVarInput  : VarObj;
		public var bVarCreation  : Bool;
		public var bSingle  : Bool;	//Maybe???
		public var eDominantType  : EuVarType;//Maybe???
		public var eDominantVar  : VarObj; //Maybe???
		
		public function new():Void {
			super();
			bVarCreation = false;
			eType = EuVarType._LineInput;
		}
			
		
		override function fGetName():String {
			return oVarInput.fGetName();
		}
		
		
		override public function copy(_oSBloc:SBloc):VarObj {
			var _oLine : LineInput = new LineInput();
			_oLine.oSBloc = oSBloc;
			return copyLineInput(new LineInput());
		}	
		
		private function copyLineInput(_oCopy:LineInput):VarObj {

			_oCopy.oVarInput = getInstanceOrCopieVar(_oCopy.oSBloc, oVarInput);
			_oCopy.bVarCreation = bVarCreation;
			_oCopy.bSingle = bSingle;
			_oCopy.eDominantType = eDominantType;
			_oCopy.eDominantVar = eDominantVar;
		
			return copyLineObj(_oCopy);
		}
	
	}
	
		
