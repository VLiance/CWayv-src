package language.vars.varObj ;
	import language.enumeration.EuBit;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarVector extends CommonVar {

		
		public var nSize   : Int = 0;
		public var sSize   : String;
		public var aValue   : Array<Float> = new Array<Float>();

		
		public function new(_oSBloc:SBloc, _nSize : Int) {
			nSize = _nSize;
			sSize = Std.string(nSize);
			super(_oSBloc, EuVarType._Vector);
		}
		
		
		override public function fGetType():String {
			return "Vec" + nSize;
		}
		override public function fGetSingature():String {
			return "v";
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVec(new VarVector(_oSBloc, nSize) );
		}		
					
		private function copyVec(_oCopy:VarVector):VarObj {
			nSize = _oCopy.nSize;
			aValue = _oCopy.aValue.copy();
			
			return copyCommonVar(_oCopy);
		}
		
		
	}
	
		
