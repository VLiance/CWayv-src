package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	

	class LineInputMod extends LineInput {
		
		public var eOppType : EuOperator;
		
		public function new(_eOpType : EuOperator):Void {
			super();
			bVarCreation = false;
			eType = EuVarType._LineInputMod;
			eOppType = _eOpType;
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			var _oLine : LineInputMod = new LineInputMod(eOppType);
			_oLine.oSBloc = oSBloc;
			return copyLineInputMod(_oLine);
		}	
		
		private function copyLineInputMod(_oCopy:LineInputMod):VarObj {
			_oCopy.eOppType = eOppType; //Not obligated?
			return copyLineInput(_oCopy);
		}
			
	}
	
		
