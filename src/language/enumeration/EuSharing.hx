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
		
		
		
