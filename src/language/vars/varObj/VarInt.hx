package language.vars.varObj ;
	import language.enumeration.EuBit;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarInt extends CommonVar {

		
		public var bUnsigned   : Bool = false;
		public var eBit   : EuBit;
		public var bEaseType   : Bool = false;
		
		public var nValue   : Int = 0;
		public var bConvertInPixel : Bool = false;
		public var nPixfrac : UInt = 0;
		
		public function new(_oSBloc:SBloc) {
			super(_oSBloc, EuVarType._Int);
			eBit = EuBit.nFast;
		}
		
		
		override public function fGetType():String {
			if(bUnsigned){
				return "UInt" + EuBit_.getStringBit(this);
			}else {
				return "Int" + EuBit_.getStringBit(this);
			}
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVarInt(new VarInt(_oSBloc) );
		}		
					
		private function copyVarInt(_oCopy:VarInt):VarObj {
			_oCopy.nValue = nValue;
			_oCopy.bConvertInPixel = bConvertInPixel;
			_oCopy.nPixfrac = nPixfrac;
			_oCopy.bUnsigned = bUnsigned;
			_oCopy.eBit = eBit;
		
			return copyCommonVar(_oCopy);
		}
		
		
	}
	
		
