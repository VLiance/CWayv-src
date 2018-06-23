package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	

	class LineReturn extends LineObj {
		
		public var oVarReturn : VarObj;

		public function new(_oSBloc:SBloc):Void {
			super();
			eType = EuVarType._LineReturn;
			oSBloc = _oSBloc;
			oSBloc.oSFunction.aLineReturnList.push(this);
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			var _oLine : LineReturn = new LineReturn(_oSBloc);
			return copyLineReturn(_oLine);
		}	
		
		private function copyLineReturn(_oCopy:LineReturn):VarObj {
			_oCopy.oVarReturn = oVarReturn;
			return copyLineObj(_oCopy);
		}
			
	}
	
		
