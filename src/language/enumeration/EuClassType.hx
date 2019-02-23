package language.enumeration ;
	
	
		enum EuClassType {
			 Invalid ;
			 Pod ;
			 Class ;
			 Overclass ;
			 Extension ;
			 Thread ;
			 Atomic ;
			 Vector;
		}
		
			
		class EuClassType_ {
			
			public static function fGet(_eType: EuClassType):String {
				
				switch(_eType) {
					case Pod :
						return "pod";

					case Class :
						return "class";
						
					case Overclass :
						return "overclass";
						
					case Extension :
						return "extension";

					case Thread :
						return "thread";

					case Atomic:
						return "atomic";
						
					case Vector :
						return "vector";
						
					case Invalid:
						return "Invalid";
						
					
				}
			//	return "Invalid";
			
		}
		
		
}
