package language.enumeration ;
	
	
		enum EuFuncType {

			
				 None 						;
			
			//	 Main 						;
				// Extension 				;
				 Extend 					;
				 Override 					;
				 Riding 					;
				 Normal 					;
				// Static 					; //
				 Macro 					;
				 Pure 						;
				 Const 					;
		}
		
		
		class EuFuncType_ {
			public static function fGet(_eType: EuFuncType):String {
				var _sGet : String = fGetName(_eType);
				if (_sGet != ""){
					return _sGet + " ";
				}
				return "";
			}
			
			public static function fGetName(_eType: EuFuncType):String {
				if (_eType == null){return ""; }
				switch(_eType) {
					case None :
						return "Invalid";
					//break;
					/*
					case Main :
						return "";
					//break;*/
					
					case Extend :
						return "extend";
					//break;
					
					case Macro :
						return "macro";
					//break;
					
					case Pure :
						return "pure";
					//break;
					
					case Normal:
						return "";
						
					case Override:
						return "override";
					
					case Riding:
						return "riding";
					
					case Const:
						return "overable";
					
				}
			}
			
		
			
		}