package language.project.convertCpp ;
	import language.enumeration.EuBit;
	import language.enumeration.EuConstant;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuSharing;
	import language.enumeration.EuVarType;
	import language.pck.SLib;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SDelegate;
	import language.project.convertSima.SFunction;
	import language.project.convertSima.TypeResolve;
	import language.vars.special.SNatFunction;
	import language.vars.special.UnitObj;
	import language.vars.special.VarArray;
	import language.vars.special.VarDataArray;
	import language.vars.special.VarFixeArray;
	import language.vars.special.VarQElement;
	import language.vars.special.VarQueueArray;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.Delegate;
	import language.vars.varObj.LineArray;
	import language.vars.varObj.LineLoc;
	import language.vars.varObj.LineObj;
	import language.vars.varObj.LineReturn;
	import language.vars.varObj.VarCallClass;
	import language.vars.varObj.VarFloat;
	import language.vars.varObj.VarGate;
	import language.vars.varObj.VarHoldEnum;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	import language.vars.varObj.VarParent;
	import language.vars.varObj.VarRc;
	import language.vars.varObj.VarResultModifier;
	import language.vars.varObj.VarRtu;
	import language.vars.varObj.VarRtuMap;
	import language.vars.varObj.VarStaticClass;
	import language.vars.varObj.VarString;
	import language.vars.varObj.VarThis;
	import language.base.Debug;
	import language.vars.varObj.VarVector;
	/**
	 * ...
	 * @author ...
	 */
	class TypeText 
	{
		
	
		public static function logicOpToString(_eType : EuOperator):String {
			switch (_eType) {
		
				case EuOperator.LogicInf :
					return "<";
				//break;
				
				case EuOperator.LogicInfEgal :
					return "<=";
				//break;
				
				case  EuOperator.LogicSup  :
					return ">";
				//break;
				
				case EuOperator.LogicSupEgal :
					return ">=";
				//break;
				
				case EuOperator.LogicEgal :
					return "==";
				//break;
				
				case EuOperator.LogicNotEgal :
					return "!=";
				//break;
					
				default:
			}
			return "Error, conditionnal type to string("+_eType + ")";
		}
		
		public static function opToString(_eType : EuOperator):String {
			switch (_eType) {
				
					
				case EuOperator.None :
					return "_";
				//break;
				
				case EuOperator.Add :
					return "+";
				//break;
				
				case EuOperator.Substract :
					return "-";
				//break;
				
				case  EuOperator.Divide  :
					return "/";
				//break;
				
				case EuOperator.Multiply :
					return "*";
				//break;
				
				case EuOperator.Modulo :
					return "%";
				//break;
				
				case EuOperator.Dot :
					return ".";
				//break;
				
				case EuOperator.LShift :
					return "<<";
				//break;
					
				case EuOperator.RShift :
					return ">>";
				//break;
				
				case EuOperator.Mask :
					return "&";
				//break;
				
				case EuOperator.Or :
					return "|";
				//break;
				
				case EuOperator.XOr :
					return "^";
				//break;
				
				case EuOperator.Concat :
					return "W";
				//break;
				
				default:
				
			}
			return "Error, conditionnal op type to string("+_eType + ")";
		}
		
		
		
		public static function typeToCPP(_oVar:VarObj, _bFunReturn:Bool = false, _bIsolate:Bool = false, _bForceBit:Bool = false, _bFuncParam:Bool = false, _bNotScopeOwner : Bool = false, _bParam_owner: Bool = false, _bAddEasing:Bool = true):String {
	
			var _eType : EuVarType = _oVar.eType;
			var _sParamAdd : String = "";
			if (_bFuncParam) {
				//_sParamAdd = "P";
				_sParamAdd = "_";
			}
			
			
			switch (_eType) {
				
				
				case EuVarType._CallClass : //Not sure
					var _oCallClass : VarCallClass  = cast(_oVar);
					
					if (_oCallClass.oCallRef.bIsVector){
						//return _oCallClass.oCallRef.sNsAccess + "gzVec" +   _oCallClass.oCallRef.sName + "< gzFloat>";
						
						var _sResultTemplateVar : String = TypeText.typeToCPP(_oCallClass.oTemplateVar);
						var _sIsEase : String = "";
						if (_sResultTemplateVar.indexOf("Ease") >= 0){
							_sIsEase = "Ease";
						}
						/*
						if (_oCallClass.oTemplateVar){
							
						}*/
						return _oCallClass.oCallRef.sNsAccess + "gzVec" + _sIsEase + _oCallClass.oCallRef.sName + "<" +TypeText.typeToCPP(_oCallClass.oTemplateVar,false,false,false,false,false,false,false) + ">";
						//if (_bFuncParam) { //Not used&
					
					}else if (_oCallClass.oCallRef.bIsResults) {
						return _oCallClass.oCallRef.sNsAccess + "c" +   _oCallClass.oCallRef.sName;
						
					}else if ((_oCallClass.bScopeOwner &&  !_bNotScopeOwner) || _bFunReturn || _bParam_owner) {
						if(_oCallClass.bWeak){
							return "gzWp<" + _oCallClass.oCallRef.sNsAccess + "c" +   _oCallClass.oCallRef.sName + ">";
						}else if(_oCallClass.oCallRef.bIsPod){
							return "gzPod<" + _oCallClass.oCallRef.sNsAccess + "c" +   _oCallClass.oCallRef.sName + ">";
						}else if(_oCallClass.bEmbed){
							//return "gzEmbed<" + _oCallClass.oCallRef.sNsAccess + "c" +   _oCallClass.oCallRef.sName + ">";
							return "gzPod<" + _oCallClass.oCallRef.sNsAccess + "c" +   _oCallClass.oCallRef.sName + ">";
							
						}else if (_oCallClass.oCallRef.bIsVector){
							return   _oCallClass.oCallRef.sNsAccess +  "gzVec" + _oCallClass.oCallRef.sName ;
						}else{
							return "gzSp<" + _oCallClass.oCallRef.sNsAccess + "c" +   _oCallClass.oCallRef.sName + ">";
						}
						
					}else {
						if(_bIsolate){
							return "(" + _oCallClass.oCallRef.sNsAccess + "c" +   _oCallClass.oCallRef.sName + "*" + ")";
						}else{
							return _oCallClass.oCallRef.sNsAccess + "c" +   _oCallClass.oCallRef.sName + "*";
						}
					}
					
					
				//break;
				
				
				case EuVarType._SClass:
					var _oSClass : SClass  = cast(_oVar);
					//return _oCallClass.oCallRef.sNsAccess + "c" +   _oSClass.sName + "*";????

					return _oSClass.sNsAccess + "c" +   _oSClass.sName + "*";
				//	return _oSClass.oCallRef.sNsAccess + "c" +   _oSClass.sName + "*";
					
				//break;
				
				
				case EuVarType._HoldEnum:
					var _oHold : VarHoldEnum  = cast(_oVar);
					return _oHold.oEnumRef.getCppName();
			
				//break;
				
				case EuVarType._RtuMap:
					var _oRtuMap : VarRtuMap  = cast(_oVar);
					if(_bIsolate){
						return "(" +  _oRtuMap.oUnitRef.getCppNameRtuMap() + "*" + ")";
					}
					return   _oRtuMap.oUnitRef.getCppNameRtuMap() + "*" ;
			
				//break;
				
				case EuVarType._Rtu:
					var _oRtu : VarRtu  = cast(_oVar);
					if(_bIsolate){
						return "(" +  _oRtu.oUnitRef.getCppName() + "*" + ")";
					}
					return _oRtu.oUnitRef.getCppName() + "*" ;
			
				//break;
			
				
				case EuVarType._FixeArray:
					var _oFixeArray : VarFixeArray  = cast(_oVar);
					if (_bIsolate) {
						return "(" + getFixeArrayType(_oFixeArray) + _oFixeArray.sNbDimStar + ")" ;
					}else {
						return getFixeArrayType(_oFixeArray) + _oFixeArray.sNbDimStar;
					}
				//break;
				
				
				
				case EuVarType._Gate :
					var _oGate : VarGate  = cast(_oVar);
					
					return "gzGate<" + _oGate.getTemplateTypeString()    + ">";
				
				//break;
				
				case EuVarType._DataArr:
					var _oDataArray : VarDataArray  = cast(_oVar);
					
					
					if (_oDataArray.nDimention == 1) {
						if(_sParamAdd != ""){
							return "gz" + _sParamAdd + "Data(" +  getArrayType(_oDataArray) + ")";
						}else {
							if (_bNotScopeOwner) {
								_sParamAdd = "F";
							}
							
							return "gz" + _sParamAdd + "Data<" +  getArrayType(_oDataArray) + ">";
						}
					}else {
						return "gz" + _sParamAdd + "Data" + _oDataArray.nDimention + "D(" +  getArrayType(_oDataArray) + ")";
					}
					//if(_bFunReturn){
					//	return "ArrayPtr*";//Little hack here all returning array is arrayPtr to simplify
				 //}else {
					
					//}
				//break;
				
				
				case EuVarType._DArray:
					var _oArray : VarArray  = cast(_oVar);
					
					if (_oArray.nDimention == 1) {
						return "gzArray<" +  getArrayType(_oArray) + ">";
					}else {
						return "gzArray" + _oArray.nDimention + "D(" +  getArrayType(_oArray) + ")";
					}
					//if(_bFunReturn){
					//	return "ArrayPtr*";//Little hack here all returning array is arrayPtr to simplify
				 //}else {
					
					//}
				//break;
				
				case EuVarType._LineArray:
					var _oLineArray : LineArray  = cast(_oVar);
					if (_oLineArray.oArray.eType == EuVarType._FixeArray) {
						return "";  //TODO maybe a better method to remove useless ()
					}
					//return "(" + getArrayType(_oLineArray.oArray) + "*" + ")";
					return ""; //Little hack here all returning array is arrayPtr to simplify
			
				//break;
				
				
				case EuVarType._QueueArray:
					var _oQueueArray : VarQueueArray  = cast(_oVar);
					if(_bIsolate){
						return "(gzQArray<" +TypeText.typeToCPP( _oQueueArray.oResultVarsType) + ">)";
					}
					return "gzQArray<" +TypeText.typeToCPP( _oQueueArray.oResultVarsType) + ">";
				//break;
				
				
				case EuVarType._QElement:
					var _oQElement : VarQElement  = cast(_oVar);
					return getQElementType(_oQElement);
				//break;
				
				case EuVarType._Delegate :
					var _oDelegate : Delegate  = cast(_oVar);
					//return   _oDelegate.oSFunc.oSClass.sName + "::" + _oDelegate.sDelegateStringFull + "::Dlg";
					return   _oDelegate.oSFunc.oSClass.sNsAccess + _oDelegate.oSFunc.oSClass.sName + "::" + _oDelegate.sDelegateStringFull + "::Dlg";
				//break;
				
				case EuVarType._String:
					var _oString : VarString  = cast(_oVar);

					if(_bIsolate){
						return "(gzStr)";
					}
				//	return "gz" + _sParamAdd + "Str";
					return _sParamAdd + "gzStr";
			
				//break;
				
				case EuVarType._Val :
					return "gzVal";
				//break;
						
				case EuVarType._Int :
					var _oVarInt : VarInt  = cast(_oVar);
					if(_oVarInt.bUnsigned && !_bForceBit){
						return "gzUInt" + EuBit_.getStringBit(_oVarInt, _bForceBit);
					}else {
						return "gzInt" + EuBit_.getStringBit(_oVarInt, _bForceBit);
					}
					//return _sStatic + "gzUInt32";
	
				//break;
				
				
				case EuVarType._Float :
					var _oVarFloat : VarFloat  = cast(_oVar);
					var _sType : String = "gzFloat" + EuBit_.getStringBit(_oVarFloat, _bForceBit);
					if (_oVarFloat.bEaseType && _bAddEasing){
					
						return "gzEase<gzFloat" + EuBit_.getStringBit(_oVarFloat, _bForceBit ) + ">";
						/*
						var _sSubType : String = "";
						if (_bAddSubType){//Vector not require subtype
							//_sSubType = "," + _sType;
							return "gzFloat" + EuBit_.getStringBit(_oVarFloat, _bForceBit );
						}else{
							return "gzEase<gzFloat" + EuBit_.getStringBit(_oVarFloat, _bForceBit )+ ">";
						}*/
						//return "gzEase<gzFloat" + EuBit_.getStringBit(_oVarFloat, _bForceBit )+ ">" + _sSubType ; //SubType template used in gzEase
					}else{
						return _sType;
					}
					
					
				case EuVarType._Vector :
					var _oVarVector : VarVector  = cast(_oVar);
					return "gzVec" + _oVarVector.sSize;	
					
					//return _sStatic + "gzUInt32";
	
				//break;
				/*
				case EuVarType._StaticClass :
					var _oStaticClass : VarStaticClass  = VarStaticClass(_oVar);
					return _oStaticClass.oImport.sLib + "_" +   _oStaticClass.sName + "*";
				//break;
				*/
				default:
				//	return "unknowType(" + _eType.getName + ")";
			
			}
			
			
			/*
			//Class type
			if (_eType == EuVarType._CallClass ) {
				var _aClass : Array<Dynamic>;
				if (_bFunReturn) {
					Debug.trac("Error, function retrun class not set Int typeToCPP : TODO")
					return "TODO"
				}
							
				var _nClass : UInt = _aVar[cVarListClass]; //////éééééééé
				if (_aVar[cVarListLocation] == cLocCPP) {
					//Cpp loc
					_aClass = aCppClass[_nClass];
		
				
					return _aClass[cCppClassLib] + "_" + _aClass[cCppClassName] + "*";
				}else {
					//Normal
					_aClass = aClass[_nClass];

					var _sLib : String = _aClass[cClassLib];
			

					return _sLib + "_" + _aClass[cClassName]+ "*";
				}
			}
			*/
			
			/*
			if (_eType == EuVarType._Array<Dynamic> ) {
				var _inputType : UInt;
				if(_bFunReturn){
					_inputType = _aVar[cFuncReturnArrayIuInput];
				}else {
					_inputType  = _aVar[cVarListInputType];
				}
				
				
				
				if (_aVar[cVarListDimention] != 1) {//Array<Dynamic> of Array<Dynamic>
					return "ArrayPtr*";
				}
					
				switch(_inputType) {
				case cTypeInt:
					return "ArrayInt*";
				//break;
				
				
				case cTypeEnum:
					return "Void**";
				//break;
				
				case cTypeFunction:
					return "ArrayFunc*";
				//break;
				
				
				default :
					return "UnknowType*";
				//break;
					
				}
			}
			*/
			
			/*
			//Rtu type
			if (_eType == EuVarType._Rtu  || _eType == EuVarType._IU ) {

				var _nUnitId : UInt;
				if (_nType == cTypeIU) {
					_nUnitId = _aVar[cFuncReturnArrayIuInput]; //Function IU
				}else {
					_nUnitId = _aVar[cVarListUnitRef];
				}
				
				aCurrentUnit = aCurrentClassUnit[_nUnitId];
				if (_aVar[cVarListInsideUnit] != null) {
				*/
					//return "Void*/*" + aCurrentUnit[cUnitListName] + "*/" ; 
				/*
				}else {
					return aCurrentUnit[cUnitListName] + "*" ;
				}
			}*/
			
			/*
			if (_eType == EuVarType._QueueArray ) {
				return "QueueRoot*";
			}
			if (_eType == EuVarType._QueueElement) {
				return queueTypeToCpp(_oVar) + "*";
			}
			*/
			if (_bIsolate) {
				var _sReturn : String = numTypeToCPP( _eType);
				if(_sReturn != ""){
					return "("  + numTypeToCPP( _eType)  + ")";
				}
			}
			return numTypeToCPP(_eType);	
			//All other type
		
		}
		
		
		public static function numTypeToCPP(_eType:EuVarType, _bStatic:Bool = false):String { //Static ?? (remove)
			
			var _sStatic : String = "";
			if (_bStatic) {
				_sStatic = "static ";
			}
		
			switch (_eType) {
				
		
				
				case EuVarType._None :
					return "";
				//break;
				
				case EuVarType._Gate :
					return " aaaaa";
				//break;
				
				case EuVarType._Bool :
					return _sStatic + "gzBool";
				//break;
				
				case EuVarType._Int :
			
					return _sStatic + "gzInt32";
			
					//return _sStatic + "gzUInt32";
	
				//break;
				/*
				case EuVarType._UInt:
					return _sStatic + "gzUInt32";
				//break;
				*/
				case EuVarType._Long :
					return _sStatic + "gzInt64";
				//break;
				
				case EuVarType._ULong:
					return _sStatic + "gzUInt64";
				//break;
				
				case EuVarType._Float :
					return _sStatic + "gzFloatA";
				//break;
				
				case EuVarType._String :
					return _sStatic + "gzStr";
				//break;
				
				case EuVarType._DArray :	//Not Used
					return _sStatic + "Error Array<Dynamic> type";
				//break;
				
				case EuVarType._CallVar :
					return "CallVar";
				//break;
				
				case EuVarType._Void : 
					return "void";
				//break;
				
					
				case EuVarType._AnyClass : 
					return "cClass*";
				//break;
				
				case EuVarType._Any : 
					return "void*";
					//return "cClass*";
				//break;
				
				case EuVarType._Function : 
					return "FuncCall";
				//break;
		
				case EuVarType._Delegate :
					return "gzDelegate";
				//break;
				
				case EuVarType._Rtu ://Not Used
					return "Rtu";
				//break;
				
				case EuVarType._Line ://Not Used
					return "Line";
				//break;
				
				case EuVarType._Error ://Not Used
					return "Error";
				//break;
				
				case EuVarType._CallClass ://Not Used
					//var _aBug : Array<Dynamic> =   _aBug[1];
					return "CallClass";
				//break;
				
			
				default :
					return "";
					Debug.fError("typeToCPP null type : " + _eType);
					Debug.fStop();
				//break;
			}
			
			return null;
		}
		
		public static function getContatAddFunc( _oConvertInType : VarObj,  _oResultType : VarObj):String {
			if(_oConvertInType.eType == EuVarType._String){
				return "GZ_cStr";
			}
			
			return "ErrAddFunc";
			/*
			switch (_oType.eType) {
				case EuVarType._Int:
					return "c_add_Int_ToString";
				//break;
				case EuVarType._UInt:
					return "c_add_UInt_ToString";
				//break;
				case EuVarType._Float:
					return "c_add_Float_ToString";
				//break;
				case EuVarType._String:
					return "c_add_String_ToString";
				//break;
				
				default :
					return "Err";
				//break;
			}*/
		}
		
		
		public static function getConvertFunc(_sVar:String, _oConvertInType : VarObj,  _oResultType : VarObj,  _oMod : VarResultModifier = null, _oContainer:VarObj = null):String {
			
			_oResultType = TypeResolve.getResultingType(_oResultType); //For LineReturn ... maybe others
			
			if (_oConvertInType != null) {
				if (_oResultType.eType == EuVarType._QElement && _oConvertInType.eType !=  EuVarType._QElement && _oConvertInType.eType !=  EuVarType._None) { //Special case for queue array
					 _sVar += ".ref()";
					 _oResultType = cast(_oResultType,VarQElement).oType;
					 //Todo maybe check if _oConvertInType
			
				}
				
				
			
				
				switch(_oConvertInType.eType) {
					case EuVarType._None :
						
						return _sVar;
					//break;
					
					
					case EuVarType._Rc :
						var _oVarRc : VarRc = cast( _oConvertInType);
						if (_oVarRc.bEmbedObj) {
							if (_oMod != null && _oMod.bScopeExtract) {
								return _oVarRc.sEmbedRc +  ".get()"; //Already an object
							}else{
								return _oVarRc.sEmbedRc ; //Already an object
							}
						}
		
						return _sVar;
					//break;
					
					
					case EuVarType._PtrFunc :
						return _sVar;
					//break;
					
					case EuVarType._Delegate:
						return getCallBackFunc(_oResultType, _sVar);
					//break;
					
					case EuVarType._String :
							/*
						if (_oResultType.eType == 12) {
							var _aBug:Array<Dynamic> = _aBug[5];
						}*/
						//return "(gzStr*)" + getStringFunc(_oResultType, _sVar);
						//return typeToCPP(_oConvertInType, false, true) + "(" + getStringFunc(_oResultType, _sVar) + ")";
						return getStringFunc(_oResultType, _sVar, _oContainer);
						/*
						var _sReslut : String = getStringFunc(_oResultType);
						if (_sReslut != "") {
							return _sReslut + "(" + _sVar + ")";
						}else {
							return _sVar;
						}
						*/
					
					//break;
					
					case EuVarType._RtuMap :
						if(TypeResolve.isVarCommon(_oResultType)){
							return  "(" + cast(_oConvertInType,VarRtuMap).oUnitRef.getCppNameRtuMap()  +  "*)&(" + _sVar + ")";	
						}else {
							return  "(" + cast(_oConvertInType,VarRtuMap).oUnitRef.getCppNameRtuMap()  +  "*)(" + _sVar + ")";	
						}
					//break;
						
					case EuVarType._Unit :
					
						return  "(" + cast(_oConvertInType,UnitObj).getCppName()  +  "*)(" + _sVar + ")";
					//break;
					/*
					case EuVarType._SClass :
						var _oSClass : SClass  = SClass(_oConvertInType);
						//if(_bScopeConvert){
							return  "(" + _oSClass.oSLib.sWriteName + "::" +   _oSClass.sName + "*)(" + _sVar + ")";
					
						//}else {
						//	return  "(<gzSCast(" + _oSClass.oSLib.sWriteName + "::" +   _oSClass.sName + ")>(" + _sVar + ")->shared_from_this())";
						//}
					//break;
					*/
							
					case EuVarType._QElement :
						
						if (_oResultType.eType == EuVarType._QElement) { //Aready a resulting queue
							return getQueueType(cast(_oConvertInType,VarQElement) , _sVar); 
						}else {
							if (_oMod != null && _oMod.bScopeConvert) {
								var _oQeClass : SClass = null;
								var _oQeResult : VarObj = cast(_oConvertInType,VarQElement).oResultVarsType;
								switch(_oQeResult.eType) {
									case EuVarType._Type:
										if (_oMod != null && _oMod.oTemplateType != null) {
											_oQeClass = cast(_oMod.oTemplateType,VarCallClass).oCallRef;
										}else {
											return  "!Unknow QElement container bScopeConvert " + _oQeResult.eType + "!";
										}
									//break;
									case EuVarType._SClass:
										_oQeClass = cast(_oQeResult,SClass);
									//break;
									default:
										return  "!Unknow QElement bScopeConvert " + _oQeResult.eType + "!";
									//break;
								}
				
								////////////////////Repaeat as below  ///////
								//_oQeClass = _oCallClass.oCallRef
								if (_oResultType.eType == EuVarType._CallClass && cast(_oResultType,VarCallClass).bScopeOwner) {
									//Todo No cast?
									return  "gzSCast<" + _oQeClass.sNsAccess + "c"  +  _oQeClass.sName + ">(" + _sVar + ")";
								}else {
									return  "gzSCastSelf<" + _oQeClass.sNsAccess + "c"  +  _oQeClass.sName + ">(" + _sVar + ")";
								}
								/////////////////////////////////////////////
				
							//	return  "gzSCastSelf<" + _oQeClass.sNsAccess + "c" +  _oQeClass.sName + ">(" + _sVar + ")";
							}
						}
						//return  getQueueFunc(VarQElement(_oConvertInType).oResultVarsType, _oResultType) + "(" + _sVar  + ")";
						return   _sVar  ;
					//break;
					
					case EuVarType._FixeArray :
						if ( TypeResolve.isVarCommon(_oResultType) ) {
							if	(_oResultType.eType != EuVarType._Null && _sVar != "0" && _sVar != "null"){ //Not number,  null was acceptable, ugly but  work
								return typeToCPP(_oConvertInType, false, true) + "(&" + _sVar + ")"; //Int extract adresse
							}
						 }
						 if (_oResultType.eType == EuVarType._String) {
							return typeToCPP(_oConvertInType, false, true) + "(" + _sVar + ".fToChar())"; //String extract adresse
						 }
	
						return typeToCPP(_oConvertInType, false, true) + "(" + _sVar + ")";
					//break;
					
					case EuVarType._ResultModifier :
							var _oMod : VarResultModifier = cast(_oConvertInType);
							
							//var _oSClass : SClass  = cast(_oConvertInType);
							if (_oMod.oRef.eType == EuVarType._CallClass && cast(_oMod.oRef, VarCallClass).oCallRef.bIsVector ){
								return  getConvertFunc(_sVar, _oMod.oRef, _oResultType, null, _oContainer) ; //Not sure -> "Add ( )"
								//return  _sVar; //Not sure
							}
							
							if (_oMod.bScopeExtract) {
								return  getConvertFunc(_sVar + ".get()", _oMod.oRef, _oResultType, _oMod, _oContainer);
							}else if (_oMod.bScopeConvert) {
								
								return  getConvertFunc(_sVar, _oMod.oRef, _oResultType, _oMod, _oContainer);	
							}else{
								return  "!(" + getConvertFunc(_sVar, _oMod.oRef, _oResultType, null, _oContainer) +")!";
							}
							
							
					//break;
					
					case EuVarType._DataArr:
						var _oDataArray : VarDataArray  = cast(_oConvertInType);
						
						if (_oMod != null && _oMod.bScopeExtract) {
							return "gzFData<" +  getArrayType(_oDataArray) + ">(" + _sVar + ")"; //Optimised
						}
						return typeToCPP(_oConvertInType, false, true) + "(" + _sVar + ")"; //Normal
				
						//	return "gzFData(" +  getArrayType(_oDataArray) + ")";
					//break;
					
					
					case EuVarType._SClass :
						var _oSClass : SClass  = cast(_oConvertInType);
						/*
						if (_oResultType.eType == EuVarType._String) {
							return fStringToClass( _oResultType, _oSClass);
						}*/
						
						if (_oMod != null && _oMod.bScopeConvert) {
							if (_oMod.bNewCreation){
								return  "gzSCastA<" + _oSClass.sNsAccess + "c" +  _oSClass.sName + ">((" + _sVar + "))";
							}else {
								//return  "gzSCast<" + _oSClass.oSLib.sWriteName + "::c" +  _oSClass.sName + ">((" + _sVar + ")->SpFromThis())";
								return  "gzSCastSelf<" + _oSClass.sNsAccess + "c" +  _oSClass.sName + ">(" + _sVar + ")";
							}
							
						}else{
							return  "!(" + _oSClass.sNsAccess + "c" +  _oSClass.sName + "*)(" + _sVar + ")";
						}
					//break;
					
		
					
					
					
					case EuVarType._CallClass :
						return fResolveScopeClassCaster( cast(_oConvertInType,VarCallClass).oCallRef, _oResultType, _oConvertInType, _oMod, _sVar);
					//break;
					
					
					case EuVarType._This :
						return fResolveScopeClassCaster( (cast(_oConvertInType,VarThis).oSBloc.oSClass), _oResultType, _oConvertInType, _oMod, _sVar);		
					//break;
						
					case EuVarType._Parent :
						return fResolveScopeClassCaster( (cast(_oConvertInType,VarParent).oSBloc.oSClass), _oResultType, _oConvertInType, _oMod, _sVar);		 ///VarParent(_oConvertInType).oSBloc.oSClass really ot sure
					//break;
					

					default :
						return typeToCPP(_oConvertInType, false, true) + "(" + _sVar + ")";
					//break;
				
				}
			}
			return _sVar;
		}
		
		
		public static function fResolveScopeClassCaster(_oSClass:SClass, _oResultType  : VarObj, _oConvertInType : VarObj, _oMod : VarResultModifier , _sVar:String):String {
			
			if (_oMod != null && _oMod.bScopeConvert) {
				if (_oMod.bNewCreation) {
					if (_oSClass.bIsPod || _oSClass.bIsVector || _oSClass.bIsResults) {
						//return "(" +_oSClass.sNsAccess + "c" +   _oSClass.sName  + ")" +  "(" + _sVar + ")"; //?
						return  "(" + _sVar + ")"; 
					}else{	
						return  "gzSCast<" + _oSClass.sNsAccess + "c" +   _oSClass.sName + ">((" + _sVar + "))";
					}
					
				}else {
					///////////////////// Check as aboce for same /////////////////
					if (_oResultType.eType == EuVarType._CallClass && cast(_oResultType,VarCallClass).bScopeOwner) {
						//Todo No cast?
						return  "gzSCast<" + _oSClass.sNsAccess + "c"  +  _oSClass.sName + ">(" + _sVar + ")";
					}else {
						//return  "gzSCast<" + _oCallClass.oCallRef.oSLib.sWriteName + "::c" +   _oCallClass.oCallRef.sName + ">(" + _sVar + ")";
						//return  "gzSCast<" + _oCallClass.oCallRef.oSLib.sWriteName + "::c" +   _oCallClass.oCallRef.sName + ">((" + _sVar + ")->SpFromThis())";
						return  "gzSCastSelf<" +_oSClass.sNsAccess + "c"  +   _oSClass.sName + ">(" + _sVar + ")";
					}
					////////////////////////////////////////////////////////////////////
			
				}

			}else {
				// if (_oConvertInType.eType == EuVarType._CallClass && VarCallClass(_oConvertInType).oCallRef.bIsPod) { //POD
				 if (_oSClass.bIsPod ) { //POD
						return "(" +_oSClass.sNsAccess + "c" +   _oSClass.sName  + "*)" +  "(" + _sVar + ")"; //Work?
				}else if ( _oSClass.bIsVector || _oSClass.bIsResults) {
			
					//return "(" +_oSClass.sNsAccess + "gzVec" +   _oSClass.sName  + "&)" +  "(" + _sVar + ")"; //TODO test if UpCast is legal
					//return "(" + _sVar + ")"; //TODO test if UpCast is legal
					return  _sVar ; //TODO test if UpCast is legal
				
				}else if (_oConvertInType.eType == EuVarType._CallClass && cast(_oConvertInType,VarCallClass).bScopeOwner) {
					return  "gzSCast<" + _oSClass.sNsAccess + "c" +   _oSClass.sName + ">(" + _sVar + ")";
				}else {
					return "(" +_oSClass.sNsAccess + "c" +   _oSClass.sName + "*" + ")" +  "(" + _sVar + ")";
				}
				

			}
		}
		
		
		
	
		//public function fStringToClass(_oResultType:VarString, _oSClass:SClass ) {
		
		

		
		
		
		
		
		
		///////////////////////// Not used now
		public static function getQueueFunc(_oQueue : VarObj, _oResultType : VarObj):String {
			
			switch (_oQueue.eType) {
				
				case EuVarType._None:
					return "";
				//break;
				
				case EuVarType._Any:  //TODO TODO TODO
				
					if (_oResultType.eType == EuVarType._SClass || _oResultType.eType == EuVarType._CallClass) {
						return "GZ_cQA_Ptr";
					}else{
						return "GZ_cQA_Rtu";
					}
					//getQueueFunc(_oResultType, EuVar.VarNone);
				//break;	
				
				//case EuVarType._VarAny:
				//case EuVarType._Any:
				case EuVarType._Unit:
					return "GZ_cQA_Rtu";
				//break;
				

				case EuVarType._SClass:
				case EuVarType._CallClass:
					return "GZ_cQA_Ptr";
				//break;
				
				case EuVarType._String:
					return "GZ_cQA_string";
				//break;
				
				case EuVarType._Int:
					return   "GZ_cQA_int";
				//break;
				/*
				case EuVarType._UInt:
					return   "cqn_UInt" ;
				//break;
				*/
				case EuVarType._Float:
					return   "GZ_cQA_float";
				//break;
				
				case EuVarType._Delegate:
					return   "GZ_cQA_Func";
				//break;
				default:
				
			}
			return "!queueNotting" + _oQueue.eType + "!";
		}
		
				
		
		public static function getQueueType(_oQueue : VarQElement, _sVar:String):String {
	
			switch (_oQueue.oResultVarsType.eType) {
	

				case EuVarType._Int:
					return   "(QueueInt*)(" + _sVar + ")";
				//break;
				/*
				case EuVarType._UInt:
					return   "(QueueUInt*)(" + _sVar + ")";
				//break;
				*/
				case EuVarType._Float:
					return   "(QueueFloat*)(" + _sVar + ")";
				//break;
				
				case EuVarType._String: return   "(QueueRtu*)(" + _sVar + ")";
				//case EuVarType._VarAny: return   "(QueueRtu*)(" + _sVar + ")";
				case EuVarType._Any:    return   "(QueueRtu*)(" + _sVar + ")";
				case EuVarType._Unit:   return   "(QueueRtu*)(" + _sVar + ")";
				//break;
			
			
				case EuVarType._SClass:
				case EuVarType._CallClass:
					return   "(QueuePtr*)(" + _sVar + ")";
				//break;
				
				case EuVarType._Delegate:
					return   "(QueueFunc*)(" + _sVar + ")";
				//break;
				default:
				
			}
			return "Q!" + _oQueue.oResultVarsType.eType + "!";
			
		}
		
		
		
	public static function getStringFunc(_oString : VarObj, _sVar:String, _oContainer:VarObj ):String {
			
			var _eType : EuVarType = _oString.eType;
			if (_eType == EuVarType._Number){
				if (_oContainer != null && _oContainer.eType == EuVarType._LineLoc){
			
					var _oLoc : LineLoc =  cast(_oContainer, LineLoc);
					var _oPecedentVar : VarObj = _oLoc.aVarList[_oLoc.aVarList.length -2]; // -1 itself, -2 precedent
					
					if(_oPecedentVar.eType == EuVarType._CallClass){
						_eType = cast(_oPecedentVar, VarCallClass).eTemplateType;
					}
				
				}
			}
				
				
			switch (_eType) {
				case EuVarType._None:
					return  _sVar ;
				//break;
				
				
				case EuVarType._String:
					//return "gzPStr(" + _sVar + ")"; ;
					return  _sVar ;
				//break;
				
				case EuVarType._Int:
					return   "gzStrI(" + _sVar + ")";
				//break;
				/*
				case EuVarType._UInt:
					return   "GZ_cStr_UInt(" + _sVar + ")";
				//break;
				*/
				case EuVarType._Bool:
					return   "gzStrB(" + _sVar + ")";
				//break;
					
					
				case EuVarType._Number:
					return   "gzStrN(" + _sVar + ")";
				
				case EuVarType._Float:
					return   "gzStrF(" + _sVar + ")";
				//break;
					
				case EuVarType._Hex:
					return   "gzStrH32(" + _sVar + ")";
				//break;
				
				case EuVarType._Thread:
					return   "gzStrUI(" + _sVar + "->nId)";
				//break;
				
				case EuVarType._SNatFunction:
					var _oNativeFunc : SNatFunction = cast(_oString);
					return 	"ss";
				//break;
				
				case EuVarType._QElement:
					var _oQElement : VarQElement = cast(_oString);
					return   getStringFunc( _oQElement.oResultVarsType , _sVar  +  "->Val",_oContainer);
				//break;
				default:
				
			}
			
			//var aBug : Array<Dynamic> = aBug[6];
			return "S!" + _eType + "!" ;
			
		}
		
		//For openGL Only
		public static function getStringFuncOGL(_oString : VarObj, _sVar:String):String {
			
			if (_oString.eType == EuVarType._Val) {
				return   "gzStrI(" + _sVar + ")";
			}
			if (_oString.eType == EuVarType._FixeArray) {
			//	_sVar = "*" + _sVar;
			}
			
			switch (_sVar.charAt(1)) {
				case "b" :
					return   "gzStrB(" + _sVar + ")";
				//break;
				case "c" :
					if (_oString.eType == EuVarType._FixeArray) {
							return   "gzU8(\"*\")";
					}
					return   "gzStrC(" + _sVar + ")";
				//break;
				
				case "h" :
				case "e" : //Temp?
					return   "gzStrUI(" + _sVar + ")";
				//break;
				
				case "a" :
				case "p" :
					if (_oString.eType == EuVarType._FixeArray) {
						if (cast(_oString,VarFixeArray).nDimention != 1) {
							return   "gzU8(\"*\")";
						}
						var _sAdd : String = "";
						if (_sVar.charAt(1) == "a") {
							_sAdd = "+ gzU8(\"*\")";
						}
						
						switch (cast(_oString,VarFixeArray).oResultVarsType.eType) {
							
							case EuVarType._Bool:
								return   "gzStrB(*" + _sVar + ")" + _sAdd;
							//break;
							
							case EuVarType._Int:
								return   "gzStrI(*" + _sVar + ")" + _sAdd;
							//break;
							
							case EuVarType._UInt:
								return   "gzStrUI(*" + _sVar + ")" + _sAdd;
							//break;
							
							case EuVarType._Float:
								return   "gzStrF(*" + _sVar + ")" + _sAdd;
							//break;
							
							case EuVarType._Any:
								return   "gzU8(\"*\")";
							//break;
							default:
						}
						return "P!" +cast(_oString,VarFixeArray).oResultVarsType.eType + "!" ;
					}
					if (_oString.eType == EuVarType._Any) {
							return   "gzU8(\"*\")";
					}
					return "Q!" + _oString.eType + "!" ;
					
				//break;
				
				case "n" :
						switch (_oString.eType) {
							
							case EuVarType._Int:
								return   "gzStrI(" + _sVar + ")";
							//break;
							
							case EuVarType._UInt:
								return   "gzStrUI(" + _sVar + ")";
							//break;
							
							case EuVarType._Float:
								return   "gzStrF(" + _sVar + ")";
							//break;
							default:
						}
				//break;
				default:
			}
			
			//var aBug : Array<Dynamic> = aBug[6];
			return "G!" + _oString.eType + "!" ;
		}
		
		
		
		
		
		
		
		private static function getCallBackFunc(_oVar : VarObj, _sVar:String):String {
			
			switch (_oVar.eType) {
				
				case EuVarType._None:
					return _sVar;
				//break;
				/*
				case EuVarType._PtrFunc:
					//return "MakeDelegate(this" + _sVar + ")";
					return  _sVar;
				//break;	
				¸*/
				/*
				case EuVarType._QElement:
					return "CallFunc(" + _sVar + "->Val)"; //Todo check queuelement to be queuefunc
				//break;
				*/	
				
				default :
					return  _sVar + ".get()"; //Not sure
				//break;
				
			}
			
		}
		
		
		public static function getFixeArrayType(_oFixeArray:VarFixeArray):String {
			var _oVars  : VarObj = _oFixeArray.oResultVarsType;
			if (TypeResolve.isVarCommon(_oVars)) {
				return TypeText.typeToCPP(_oVars);
			}else {
				//Return Void
				return getArrayType(_oFixeArray);
				//return "Void*";
			}
			
			return "FA!" + _oVars.eType + "!";
		}
		
		
		
		
		
		
		public static function getArrayType(_oArray : VarArray):String {
			
		
			/*
			if (_oArray.nDimention != 1) {
				return   "ArrayPtr";
			}
			*/
			
			
		
			//var _oVars  : VarObj = _oArray.oVarsType;
			var _oVars  : VarObj = _oArray.oResultVarsType;
			
			return typeToCPP(_oVars);
			
				/*
			switch (_oVars.eType) {
				case EuVarType._None:
					return "";
				//break;
				
				case EuVarType._String:
					return "";
				//break;
				
				case EuVarType._Int:
					return   "ArrayInt";
				//break;

				case EuVarType._Float:
					return   "ArrayFloat";
				//break;
				
				case EuVarType._Unit:
					return  "ArrayPtr";
				//break;
				
				case EuVarType._SClass:
					return  "ArrayPtr";
				//break;
				
				default :
					return typeToCPP(_oVars);
				//break;
				
			}
			return "AT!" + _oVars.eType + "!";
			*/
			
		}
		
		
		public static function getQElementType(_oQElement : VarQElement):String {
			
			
			var _oVars  : VarObj = _oQElement.oResultVarsType;
			
			return "gzQElement<" + typeToCPP(_oQElement.oResultVarsType)  + ">";
			
			/*
			switch (_oVars.eType) {
				
					
				case EuVarType._None:
					return "";
				//break;
				
			
				case EuVarType._String:
					return "QueueRtu";
				//break;
				
				case EuVarType._Delegate:
					return "QueueFunc";
				//break;
				
				case EuVarType._Int:
					return   "QueueInt";
				//break;
		
				case EuVarType._Float:
					return   "QueueFloat";
				//break;
				
				case EuVarType._Unit:
					return  "QueueRtu";
				//break;
				
				case EuVarType._SClass:
				case EuVarType._CallClass:
					return  "QueuePtr";
				//break;
				
				case EuVarType._Any:
					return   "QueueElement" ;
				//break;
				
				
			}*/
			return "QE!" + _oVars.eType + "!";
			
		}
		

		
		public static function iniMemFixeArray(_oFixeArray:VarFixeArray, _nSize:UInt, _nDim:UInt ):String {
			var _sType : String;
			if(TypeResolve.isVarCommon(_oFixeArray.oResultVarsType)){
			 _sType  = typeToCPP(_oFixeArray.oResultVarsType);
			}else {
				 _sType  =  "void*";
			}
	
			var _sStar : String = "";
			for ( i in 0 ... _nDim) {
				_sStar += "*";
			}
			
			return "(" + _sType + _sStar  + ")GZ_fMalloc(" + _nSize +  ", sizeof(" + _sType + "))";	
			
		}

		public static function getGeneralStringType(_oVar:VarObj):String {
			
			if (_oVar.eType == EuVarType._Void) {
				return "void";
			}
			
			if(TypeResolve.isVarCommon(_oVar)){
				return typeToCPP(_oVar);
			}else {
				return  "Ptr";
			}
		}
		
		public static function getStringTypeBaseStrict(_oVar:VarObj):String {
			switch(_oVar.eType) {
				case EuVarType._Bool :
					return "gzBool";
				//break;
				case EuVarType._String :
					return "gzStr";
				//break;
				case EuVarType._Void :
					return "void";
				//break;
				case EuVarType._Int :
					return "gzInt" +  EuBit_.getStringBit(_oVar, true);
				//break;
				case EuVarType._Float :
					
					return "gzFloat" +  EuBit_.getStringBit(_oVar, true);
				//break;
				case EuVarType._QElement :
					return "gzQElement" ;
				//break;
				case EuVarType._QueueArray :
					return "gzQArray" ;
				//break;
				
				default:
					return "gzPtr" ;
				//break;
				
			}
			
		}
		
		

		
		public static function getIniFuncSpecialVarArray(_oVarArray : VarArray):String {
			if (_oVarArray.nDimention != 1) {
				return   "GZ_mArray_New";
			}
			
			//var _oVars : CommonVar = _oVarArray.oVarsType;
			var _oVars : VarObj = _oVarArray.oResultVarsType;
			switch(_oVars.eType) {
				case EuVarType._Int:
					return "GZ_mArray_NewInt";
				//break;
				case EuVarType._Float:
					return "GZ_mArray_NewFloat";
				//break;
				/*
				case EuVarType._Rtu:
					return "GZ_mArray_NewArray";
				break;*/
				case EuVarType._Unit:
					return "GZ_mArray_New";
				//break;
				default:

			}
			
			return "!!" + _oVars.eType + "!!";
		}
	
		public static function getFuncPtrType(_oDlg : Delegate):String {
			var _sLoc : String =  _oDlg.oSFunc.oSClass.sName + "::" + _oDlg.sDelegateStringFull + "::";
			
			if (_oDlg.oSFunc.bStatic) {
				return _sLoc + "FpD";
			}else {
				return _sLoc + "FpM";
			}
		}
		
		public static function getFuncPtrTypeIni(_oDlg : Delegate, _sInstance:String):String {
			//var _sLoc : String =  "_" + _oDlg.oSFunc.oSClass.sName + "::" + _oDlg.sDelegateStringFull + "::";
			
			if (_oDlg.oSFunc.bStatic) {
				return "";
			}else {
				return _sInstance  + ", ";
			}
		}
		/*
		public static function getFuncPtrTypeIni(_oDlg : Delegate, _sInstance:String):String {
			var _sLoc : String =  "_" + _oDlg.oSFunc.oSClass.sName + "::" + _oDlg.sDelegateStringFull + "::";
			
			if (_oDlg.oSFunc.eFuncType == EuFuncType.Static) {
				return "(" + _sLoc + "FpD)";
			}else {
				return _sInstance  + ",(" + _sLoc + "FpM)";
			}
		}*/
		
		public static function getFuncLoc(_oSFunc : SFunction):String {
			
			if (_oSFunc.bStatic) {
				return _oSFunc.oSClass.sNsAccess + "::"  + _oSFunc.oSClass.sName  + "::" + _oSFunc.sName ;
			}else {
				//return _oSFunc.oSClass.oSLib.sWriteName + "::c"  + _oSFunc.oSClass.sName  + "::" + _oSFunc.sName ;
				return _oSFunc.oSClass.sNsAccess + "c"  + _oSFunc.oSClass.sName  + "::" + _oSFunc.sName ;
			}
		}
		
		public static function getFuncLocWrapper(_oSFunc : SFunction):String {
			
			if (_oSFunc.bStatic) {
				return _oSFunc.oSClass.sNsAccess  + "::"  + _oSFunc.oSClass.sName  + "::w" + _oSFunc.sName.substr(1);
			}else {
				return _oSFunc.oSClass.sNsAccess + "c"  + _oSFunc.oSClass.sName  + "::w"  + _oSFunc.sName.substr(1);
			}
		}
		

	}

