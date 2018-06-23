package language.enumeration ;
	import language.vars.varObj.VarFloat;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	
	
		class EuBit_ {
	
			
			public static var aToString : Array<Dynamic>  = ["",   "8", "16", "32", "64", "128", "X"];
			
			public static function getStringBit(_oVar : VarObj, _bForceBit = false):String {
				if(_oVar.eType == EuVarType._Int){
					if (_bForceBit && cast(_oVar,VarInt).eBit == EuBit.nFast) {
						return "32";
					}
					return aToString[cast(_oVar,VarInt).eBit.getIndex()];
				}
				
				if (_oVar.eType == EuVarType._Float) {
					if (_bForceBit && cast(_oVar,VarFloat).eBit == EuBit.nFast) {
						return "32";
					}
					return aToString[cast(_oVar,VarFloat).eBit.getIndex()];
				}
				
				return "";
			}
			
		}
		
		enum EuBit {
			 nFast 			;
			 n8 				;
			 n16 				;
			 n32 				;
			 n64 				;
			 n128 				;
			 nX 				;

		}
