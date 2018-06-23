package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	

	class LineDelete extends LineObj {
		

		public function new():Void {
			super();
			eType = EuVarType._LineDelete;
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			var _oLine : LineDelete = new LineDelete();
			_oLine.oSBloc = oSBloc;
			return copyLineDelete(_oLine);
		}	
		
		private function copyLineDelete(_oCopy:LineDelete):VarObj {
			return copyLineObj(_oCopy);
		}
			
	}
	
		
