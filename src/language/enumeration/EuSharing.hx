package language.enumeration ;
	
	
		enum EuSharing {

			
			 Private 				;
			 Public 				;
			 Protected 				;
			 SharingInvalid 		;
			 Destructor 			;
			 Overable 				;
		}
			
		class EuSharing_ {
			
			public static function fGet(_eType: EuSharing):String {
				var _sGet : String = fGetName(_eType);
				if (_sGet != ""){
					return _sGet + " ";
				}
				return "";
				
			}
			
			public static function fGetName(_eType: EuSharing):String {
				switch(_eType) {
					case Private :
						return "private";
					//break;
					
					case Public :
						return "public";
					//break;
					
					case Protected :
						return "protected";
					//break;
					
					case SharingInvalid :
						return "Invalid";
					//break;
					
					case Destructor :
						return "Destructor";
					//break;
					
					case Overable:
						return "overable";
					
				}
			}
			
			public static function fGetSharingLite(_eShareType: EuSharing):String {
				switch(_eShareType) {
					case Private :
						return "Pv";
					//break;
					
					case Public :
						return "Pb";
					//break;
					
					case Protected :
						return "Pt";
					//break;
					
					case SharingInvalid :
						return "Iv";
					//break;
					
					case Destructor :
						return "Dt";
					//break;
					
					case Overable:
						return "Ov";
					
				}
				return "Sharing Not Implemented";
			}
			
		}
		
		
		
