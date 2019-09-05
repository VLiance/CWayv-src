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
		_Val 					; //Javascript type
		_Int 					;
		_UInt 					; //Must beat Int + Hex
		_Long 					;
		_ULong 				; 
		_Float 				;
		_Number 				;
		_Vector 				;
		_Matrix 				;
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
		_GateFunction		;
		_ArrayInitializer		;
		_ExtendFuncCall		;
		_GateFuncCall		;
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
		_Rc 				;
		_String 				;
	}

	class EuVarType_ {
			
		public static function fGet(_eType: EuVarType):String {
			var _sGet : String = fGetName(_eType);
			if (_sGet != ""){
				return _sGet + " ";
			}
			return "";
			
		}
		
		public static function fGetName(_eType: EuVarType):String {
			
				switch(_eType) {
					case _None : return "None";
					case _Error : return "Error";
					case _Null: return "Null";
					case _QElement: return "QElement"; 
					case _Bool : return "Bool";
					case _Hex : return "_Hex";
					case _Int : return "Int";
					case _UInt : return "_UInt"; //Must beat Int + Hex
					case _Long : return "_Long";
					case _ULong : return "_ULong"; 
					case _Float : return "Float";
					case _Number : return "Number";
					case _Vector : return "Vector";
					case _Matrix : return "Matrix";
					case _BeforeIsCommun : return "";  //*Base types*////////////////// BEF COMMUN  ///////////////////////////////////////
					case _DArray : return "DArray";
					case _DataArr : return "DataArr";
					 case _CallDelgate: return "CallDelgate";
					case _Delegate: return "Delegate";
					case _PtrFunc: return "PtrFunc";
					case _SNatFunction : return "SNatFunction";
					case _SNatAttribut : return "SNatAttribut";
					case _NativeFuncCall : return "NativeFuncCall";
					case _EaseOut : return "EaseOut";
					case _New: return "New";
					case _SClass: return "SClass";
					case _SBloc: return "SBloc";
					case _Line : return "Line";
					case _CallVar: return "CallVar";
					case _AnyClass: return "AnyClass";
					case _CallClass: return "CallClass";
					case _ClassCallFunction: return "ClassCallFunction";
					case _Void : return "Void";
					case _Function : return "Function";
					case _ClassCallVar : return "ClassCallVar";
					case _LineArray : return "LineArray";
					case _Square : return "Square";
					case _Rtu: return "Rtu";
					case _RtuMap: return "RtuMap";
					case _HoldEnum: return "HoldEnum";
					case _This : return "This";
					case _Parent : return "Parent";
					case _Thread : return "Thread";
					case _IU : return "IU";
					case _Enum : return "Enum";
					case _SquareEnum : return "SquareEnum";
					case _NewArraySquare : return "NewArraySquare";
					case _Override: return "Override";
					case _Static: return "Static";
					case _Normal: return "Normal";
					case _Main: return "Main";
					case _StaticClass: return "StaticClass";
					case _ExClass: return "ExClass";
					case _StaticVar : return "StaticVar";
					case _ExtendVar: return "ExtendVar";
					case _ExtendFunction: return "ExtendFunction";
					case _GateFunction: return "GateFunction";
					case _ExtendFuncCall: return "ExtendFuncCall";
					case _GateFuncCall: return "GateFuncCall";
					case _ArrayInitializer: return "ArrayInitializer";
					case _LineRtu : return "LineRtu";
					case _CppStaticClass: return "CppStaticClass";
					case _CppClassCallFunction : return "CppClassCallFunction";
					case _CppCallClass: return "CppCallClass";
					case _Queue : return "Queue";
					case _QueueArray : return "QueueArray"; //44
					case _FixeArray : return "FixeArray"; 
					case _ClassCallSpecialFunction : return "ClassCallSpecialFunction";
					case _SpecialVar: return "SpecialVar";
					case _NotSet : return "NotSet";
					case _Unit : return "Unit";
					case _UseUnit : return "UseUni";
					case _UseEnum : return "UseEnum";
					case _FuncCall: return "FuncCall";
					case _ResultModifier: return "ResultModifier";
					case _LogicFor : return "LogicFor";
					case _LogicSwitch : return "LogicSwitch";
					case _LogicSwitchCast : return "LogicSwitchCast";
					case _LogicCase: return "LogicCase";
					case _LogicForEach : return "LogicForEach";
					case _LogicWhile: return "LogicWhile";
					case _LogicIf: return "LogicIf";
					case _LogicIfElse: return "LogicIfElse";
					case _LogicIfElseIf: return "LogicIfElseIf";
					case _LogicElseIf: return "LogicElseIf";
					case _LogicElse: return "LogicElse";
					case _LogicMultiIf: return "LogicMultiIf";
					case _LogicSingleIf : return "LogicSingleIf";
					case _LogicFalse : return "LogicFalse";
					case _LineVarIni: return "LineVarIni";
					case _LineReturn: return "LineReturn";
					case _LineDelete: return "LineDelete";
					case _LineInput : return "LineInput";
					case _LineInputMod : return "LineInputMod";
					case _LineLoc: return "LineLoc";
					case _ParamInput : return "ParamInput";
					case _LineClassCreation: return "LineClassCreation";
					case _LineClassFuncCall: return "LineClassFuncCall";
					case _LineStaticClassFuncCall: return "LineStaticClassFuncCall";
					case _LineCppClassFuncCall : return "LineCppClassFuncCall";
					case _LineCppStaticClassFuncCall : return "LineCppStaticClassFuncCall";
					case _LineVarFuncCall: return "LineVarFuncCall";
					case _LineDirectFuncCallInput: return "LineDirectFuncCallInput";
					case _LineDirectClassFuncCallInput : return "LineDirectClassFuncCallInput";
					case _LineDirectStaticClassFuncCallInput : return "LineDirectStaticClassFuncCallInput";
					case _VarInc : return "VarInc";
					case _VarDec : return "VarDec";
					case _LineSuper : return "LineSuper";
					case _LineMultiLocVarFuncCall: return "LineMultiLocVarFuncCall";
					case _LineClassSpecialFuncCall: return "LineClassSpecialFuncCall";
					case _LogicalOR: return "LogicalOR";
					case _LogicalAnd: return "LogicalAnd";
					case _Compare: return "Compare";
					case _ClassObject : return "ClassObject ";
					case _ClassExtension : return "ClassExtension ";
					case _TypeDef : return "TypeDef";
					case _CastTypeDef : return "CastTypeDef";
					case _Any : return "Any";
					case _Type : return "Type";
					case _Comment : return "Comment";
					case _CppLine : return "CppLine";
					case _Gate : return "Gate";
					case _Balise : return "Balise";
					case _Val : return "Val"; //Javascript type
					case _Rc : return "Rc";
					case _String : return "String";	
				}
		}
	
	}
	