package language.enumeration;



		enum EuOperator {


			 None 				;
			 Add 				;
			 Substract 		;
			 Concat 	       	;
			
			//  ----------- Priority over Add / Substract -------------------
			 Divide 	        ;
			 Multiply 	        ;
			 Modulo 	        ;
			
			 Dot 	      		;
			 LShift 	        ;
			 RShift 	        ;
			 Mask 	       		;
			 Or 	       		;
			 XOr 	       		;
			

			//Logical
			 LogicEgal 	      		;
			 LogicNotEgal 	      		;
			 LogicInfEgal 	      		;
			 LogicSupEgal 	      		;
			 LogicInf 	      			;
			 LogicSup		      		;
			 
			 
	
			 
		}
		
	
	 class EuOperator_ {
		
			public static function  fAsLowPriority(_eOp : EuOperator){
					if (_eOp.getIndex() <= EuOperator.Concat.getIndex()) {
						return true;
					}else{
						return false;
					}
			}
		}
	
		