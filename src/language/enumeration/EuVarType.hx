package language.enumeration ; import language.vars.varObj.CommonVar; import language.vars.varObj.VarObj;
	import haxe.EnumTools;
	
	class EuVar {
		//	private static var n:Int = 0;	//Order is important for resolve priority !!!!!		
		public static var  VarNone	:VarObj;
		public static var  VarAny	:CommonVar;	
		public static var  VarUInt	:CommonVar; //For Arrays
		public static var  VarType	:CommonVar; 
	
		
		public static function fIndex(e:EnumValue):UInt{
			return	EnumValueTools.getIndex(e);
		}
	}
		
	enum EuVarType {
		
		_None 					;
		_Error 				;
		_Null					;
		_QElement			; 
		_Bool 				;
		_Hex 					;
		_Int 					;
		_UInt 					; //Must beat Int + Hex
		_Long 					;
		_ULong 				; 
		_Float 				;
		_BeforeIsCommun 		;  //*Base types*	////////////////// BEF COMMUN  ///////////////////////////////////////
		_DArray 				;	
		_DataArr 				;	
		 _CallDelgate			;
		_Delegate				;	
		_PtrFunc			;
		_SNatFunction 				;
		_SNatAttribut 				;
		_NativeFuncCall 		;
		_EaseOut		 		;
		_New				;
		_SClass			;
		_SBloc				;
		_Line 				;
		_CallVar				;
		_AnyClass			;
		_CallClass			;
		_ClassCallFunction	;
		_Void 				;
		_Function 			;
		_ClassCallVar 		;
		_LineArray 			;
		_Square 				;
		_Rtu					;
		_RtuMap				;
		_HoldEnum			;
		_This 				;
		_Parent 				;
		_Thread 				;
		_IU 					;
		_Enum 				;
		_SquareEnum 			;
		_NewArraySquare 		;
		_Override			;
		_Static				;
		_Normal				;
		_Main				;
		_StaticClass			;
		_ExClass			;
		_StaticVar 			;
		_ExtendVar			;
		_ExtendFunction		;
		_ExtendFuncCall		;
		_LineRtu 				;
		_CppStaticClass		;
		_CppClassCallFunction ;
		_CppCallClass			;
		_Queue 				;
		_QueueArray 			; //44
		_FixeArray 			; 
		_ClassCallSpecialFunction ;
		_SpecialVar			;
		_NotSet 				;
		_Unit 				;
		_UseUnit 				;
		_UseEnum 				;
		_FuncCall					;
		_ResultModifier	;
		_LogicFor 						;	
		_LogicSwitch 						;	
		_LogicSwitchCast 						;	
		_LogicCase						;	
		_LogicForEach 					;	
		_LogicWhile					;
		_LogicIf						;
		_LogicIfElse					;
		_LogicIfElseIf					;
		_LogicElseIf					;
		_LogicElse						;
		_LogicMultiIf					;
		_LogicSingleIf 				;
		_LogicFalse 					;
		_LineVarIni					;
		_LineReturn					;
		_LineDelete					;
		_LineInput 					;
		_LineInputMod 					;
		_LineLoc						;
		_ParamInput 					;
		_LineClassCreation				;
		_LineClassFuncCall				;
		_LineStaticClassFuncCall		;
		_LineCppClassFuncCall 			;
		_LineCppStaticClassFuncCall 	;
		_LineVarFuncCall				;
		_LineDirectFuncCallInput		;
		_LineDirectClassFuncCallInput 	;
		_LineDirectStaticClassFuncCallInput ;
		_VarInc 						;
		_VarDec 						;
		_LineSuper 					;
		_LineMultiLocVarFuncCall		;
		_LineClassSpecialFuncCall		;
		_LogicalOR						;	
		_LogicalAnd					;	
		_Compare						;	
		_ClassObject 					;
		_ClassExtension 				;
		_TypeDef 					;
		_CastTypeDef 					;
		_Any 					;
		_Type 					;
		_Comment 				;
		_CppLine 				;
		_Gate 				;
		_Balise 				;
		_Val 					; //Javascript type
		_Rc 				;
		_String 				;
	}
