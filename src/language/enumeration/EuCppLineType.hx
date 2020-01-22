package language.enumeration ;
	import language.enumeration.EuBetween;
	import language.Text;
	import language.base.Debug;
	
	//Most for execution code
	//I will create an array of each to get current posision variable
	
		enum EuCppLineType { //Maybe more generic name
			
			 Normal		;
			 Header 		;
			
					
			 Class 	 ;
			 Class_H 	 ;
			 Class_H_Aft 	 ;
			
			 Namespace 	 ;
			 Namespace_H 	 ;
			 Namespace_End_H 	 ;
			 Initializer_list;
			 Initializer;
			 Static 	 ;
			 Static_H 	 ;
			
			 ClassStatic 	 ;
			
			
			 Glsl 	 ;
			 VecUnion 	 ;
			
			
			
			 Error		;
		}
		
		
		class EuCppLineType_ {
			
			public static function fTextToType(_sType:String, _bInsideClass:Bool = false) {
				
				var _sWord :String = Text.between3(_sType,0, EuBetween.Word);
				
				switch(_sWord) {
					case "cpp" :
						if (_bInsideClass) {
							return EuCppLineType.Namespace;
						}else {
							return EuCppLineType.Normal;
						}
					//break;	
					
					case "cpp_h" :
						return EuCppLineType.Header;
					//break;
					
					case "cpp_namespace" :
						return EuCppLineType.Namespace;
					//break;
					case "cpp_namespace_h" :
						return EuCppLineType.Namespace_H;
					//break;
					
					case "cpp_namespace_end_h" :
						return EuCppLineType.Namespace_End_H;
					//break;
					
					case "cpp_class" :
						return EuCppLineType.Class;
					//break;
					case "cpp_class_h" :
						return EuCppLineType.Class_H;
						
					case "cpp_class_h_" :
						return EuCppLineType.Class_H_Aft;
					//break;
					
					case "cpp_static" :
						return EuCppLineType.Static;
					//break;
					case "cpp_static_h" :
						return EuCppLineType.Static_H;
					//break;	
					
					case "cpp_initializer_list" :
						return EuCppLineType.Initializer_list;
						
					case "cpp_initializer" :
						return EuCppLineType.Initializer;
						
					case "cpp_vec_union" :
						return EuCppLineType.VecUnion;
					
					case "glsl" :
					
						return EuCppLineType.Glsl;
					//break;	
					
					
					/*
					case "cpp_cs" :
						return EuCppLineType.ClassStatic;
					//break;	*/
				}
				Debug.fError("Unknow <" + _sType +  "> balise code");
				return EuCppLineType.Error;
			}
			
			
			
			
		}
		
	
		
		
