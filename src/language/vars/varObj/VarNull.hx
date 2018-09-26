package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarNull extends CommonVar {  //Maybe not commonvar

		public var nValue   : UInt = 0;
		
		public function new(_oSBloc:SBloc) {
			super(_oSBloc, EuVarType._Null);
		}
		
		override public function fGetType():String {
			return "Null";
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVarNull(new VarNull(_oSBloc) );
		}		
					
		private function copyVarNull(_oCopy:VarNull):VarObj {
			_oCopy.nValue = nValue;
			return copyCommonVar(_oCopy);
		}
	}
	
		
