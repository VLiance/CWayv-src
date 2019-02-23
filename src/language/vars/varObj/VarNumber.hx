package language.vars.varObj ;
	import language.enumeration.EuBit;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	
	//Number can be a float or integer

	class VarNumber extends CommonVar {

		public var nValue   : Float = 0;
	///	public var nIntValue   : Int = 0;
	//	public var nIntValue   : Int = 0;
	//	public var eBit   : EuBit;
		
		public function new(_oSBloc:SBloc) {
			super(_oSBloc, EuVarType._Number);
//			eBit = EuBit.nFast;
		}
		
		
		override public function fGetType():String {
			return "Number"  + EuBit_.getStringBit(this);
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVarFloat(new VarNumber(_oSBloc) );
		}		
					
		private function copyVarFloat(_oCopy:VarNumber):VarObj {
			_oCopy.nValue = nValue;
			
			//_oCopy.nFloatValue = nFloatValue;
			//_oCopy.nIntValue = nIntValue;
		//	eBit = _oCopy.eBit;
			return copyCommonVar(_oCopy);
		}

	}
