package language.project.convertSima ;
	import language.cwMake.line.Rc;
	import language.enumeration.EuBetween;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.Text;
	import language.TextType;
	import language.vars.logicObj.CompareObj;
	import language.vars.special.SNatAttribut;
	import language.vars.special.VarArray;
	import language.vars.special.VarDataArray;
	import language.vars.special.VarFixeArray;
	import language.vars.special.VarQElement;
	import language.vars.special.VarQueueArray;
	import language.vars.varObj.CallDelegate;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.Delegate;
	import language.vars.varObj.ExtendFunc;
	import language.vars.varObj.ExtendVar;
	import language.vars.varObj.FuncCall;
	import language.vars.varObj.LineArray;
	import language.vars.varObj.LineDelete;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.LineLoc;
	import language.vars.varObj.LineObj;
	import language.vars.varObj.LineReturn;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.PtrFunc;
	import language.vars.varObj.VarAny;
	import language.vars.varObj.VarAnyClass;
	import language.vars.varObj.VarBoolean;
	import language.vars.varObj.VarCallClass;
	import language.vars.varObj.VarExClass;
	import language.vars.varObj.VarFloat;
	import language.vars.varObj.VarGate;
	import language.vars.varObj.VarHoldEnum;
	import language.vars.varObj.VarInc;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarLong;
	import language.vars.varObj.VarNew;
	import language.vars.varObj.VarNewArraySquare;
	import language.vars.varObj.VarParent;
	import language.vars.varObj.VarRc;
	import language.vars.varObj.VarResultModifier;
	import language.vars.varObj.VarRtu;
	import language.vars.varObj.VarRtuMap;
	import language.vars.varObj.VarStaticClass;
	import language.vars.varObj.VarString;
	import language.vars.varObj.VarObj;
	import language.vars.varObj.VarThis;
	import language.vars.varObj.VarULong;
	import language.vars.varObj.VarVal;
	import language.base.Debug;
	/**
	 * ...
	 * @author ...
	 */
	class TypeResolve {
		
		public static function createVarWithType(_oSBloc : SBloc, _sType:String, _sLine:String, _nCurrentIndex:UInt, _bScopeOwner:Bool = false, _bWeak:Bool = false):CommonVar {
			
			var _eType : EuVarType = TextType.stringToType(_sType, _sLine, _nCurrentIndex); //Reset eTypeNbBit
			
			switch (_eType) {
				
				case EuVarType._Val :
					var _oVarVal : VarVal =  new VarVal(_oSBloc);
					return _oVarVal;
				//break;
				
				
				
				
				case EuVarType._UInt :
					var _oVarUInt : VarInt =  new VarInt(_oSBloc);
					_oVarUInt.bUnsigned = true;
					_oVarUInt.eBit = TextType.eTypeNbBit;
					return _oVarUInt;
				//break;
				
				case EuVarType._Int :
					var _oVatInt : VarInt = new VarInt(_oSBloc);
					_oVatInt.eBit = TextType.eTypeNbBit;
					return _oVatInt;
				//break;
				
				/*
				case EuVarType._ULong :
					return new VarULong(_oSBloc);
				//break;
				
				case EuVarType._Long :
					return new VarLong(_oSBloc);
				break;*/
				
				case EuVarType._Float :
					var _oVarFloat: VarFloat =  new VarFloat(_oSBloc);
					_oVarFloat.eBit = TextType.eTypeNbBit;
					return  _oVarFloat;
				//break;
				
				case EuVarType._Bool :
					return new VarBoolean(_oSBloc);
				//break;
					
				case EuVarType._String :
					return new VarString(_oSBloc);
				//break;
				
				case EuVarType._Void :
					var _oVoid : CommonVar = new CommonVar(_oSBloc, EuVarType._Void);//Maybe not
					return _oVoid; //Maybe not
				//break;
				
				case EuVarType._IU :
					return new CommonVar(_oSBloc, EuVarType._IU); //Maybe not
				//break;
				
				case EuVarType._AnyClass:
					return new VarAnyClass(_oSBloc, _sType, _bScopeOwner, _bWeak);
				//break;
				case EuVarType._CallClass :
					return new VarCallClass(_oSBloc, _sType, _bScopeOwner, _bWeak);
				//break;
				/*
				case EuVarType._ExClass :
					return new VarExClass(_oSBloc, _sType);
				//break;
				*/
				
				case EuVarType._Gate :
					if(_sLine.charAt(_nCurrentIndex) == "<"){
						var _sNextGate : String = Text.between3(_sLine, _nCurrentIndex + 1, EuBetween.Template  ); 
						return  new VarGate(_oSBloc, _sNextGate);
					}else {
						Debug.fError("Gate does'nt specify type <> in class : " + _oSBloc.oSClass.sName);
						Debug.fStop();
					}
					return null;
				//break;
				
				
				case EuVarType._Rtu :
					return new VarRtu(_oSBloc, _sType);
				//break;
				
				case EuVarType._HoldEnum :
					return new VarHoldEnum(_oSBloc, _sType);
				//break;
				/*
				case EuVarType._PtrFunc :
					return new PtrFunc(_oSBloc);
				break;*/
				
				case EuVarType._DataArr :
					if(_sLine.charAt(_nCurrentIndex) == "<"){
						var _sNextArray : String = Text.between3(_sLine, _nCurrentIndex + 1, EuBetween.Template  ); 
						return  new VarDataArray(_oSBloc, _sNextArray);
					}else {
						Debug.fError("Data Array<Dynamic> does'nt specify type <> in class : " + _oSBloc.oSClass.sName);
						Debug.fStop();
					}
					return null;
				//break;
				
				
				case EuVarType._DArray :
					if(_sLine.charAt(_nCurrentIndex) == "<"){
						var _sNextArray : String = Text.between3(_sLine, _nCurrentIndex + 1, EuBetween.Template  ); 
						return  new VarArray(_oSBloc, _sNextArray,EuVarType._DArray);
					}else {
						Debug.fError("Array<Dynamic> does'nt specify type <> in class : " + _oSBloc.oSClass.sName);
						Debug.fStop();
					}
					return null;
				//break;
				
				
				case EuVarType._QueueArray :
					if (_sLine.charAt(_nCurrentIndex) == "<") {
						var _sNextQueueArray : String = Text.between3(_sLine, _nCurrentIndex + 1, EuBetween.Template  ); 
						return  new VarQueueArray(_oSBloc, _sNextQueueArray);
					}else {
						Debug.fError("QueueArraydoes'nt specify type <> in class : " + _oSBloc.oSClass.sName);
						Debug.fStop();
					}
					return null;
				//break;
				
				
				case EuVarType._FixeArray :
					if (_sLine.charAt(_nCurrentIndex) == "<") {
						var _sNextFixeArray : String = Text.between3(_sLine, _nCurrentIndex + 1, EuBetween.Template  ); 
						return  new VarFixeArray(_oSBloc, _sNextFixeArray);
					}else {
						Debug.fError("FixeArraydoes'nt specify type <> in class : " + _oSBloc.oSClass.sName);
						Debug.fStop();
					}
					return null;

				//break;
				
				case EuVarType._RtuMap :
					if (_sLine.charAt(_nCurrentIndex) == "<") {
						var _sNextRtuMap : String = Text.between3(_sLine, _nCurrentIndex + 1, EuBetween.Template  ); 
						
						return  new VarRtuMap(_oSBloc, _sNextRtuMap);
					}else {
						Debug.fError("RtuMap does'nt specify type <> in class : " + _oSBloc.oSClass.sName);
						Debug.fStop();
					}
					
				//break;
				
				
				case EuVarType._QElement :
					if (_sLine.charAt(_nCurrentIndex) == "<") {
						var _sNextQueueElement : String = Text.between3(_sLine, _nCurrentIndex + 1, EuBetween.Template  ); 
						return  new VarQElement(_oSBloc, _sNextQueueElement);
					}else {
						return  new VarQElement(_oSBloc, "");
						//Debug.fError("QueueElement dont specefie type () : " + _sLine);
					}
					return null;
					
				//break;		
				
				
				case EuVarType._Delegate :
					if (_sLine.charAt(_nCurrentIndex) == "<") {
						var _sDelegateParam : String = Text.between3(_sLine, _nCurrentIndex + 1, EuBetween.Template  ); 
						//return  new VarFixeArray(_oSBloc, _sNextFixeArray);
						return new Delegate(_oSBloc, _sDelegateParam);
					}else {
						return new Delegate(_oSBloc, "");
						//Debug.fError("Delegate dont specefie type () " + _sLine);
					}
					return null;
				
					
				//break;
				
			case EuVarType._Any :
					return new VarAny(_oSBloc);
					//return EuVarType._VarAny;
				//break;	
				
				case EuVarType._Type :
					return EuVar.VarType;
				//break;	
				
				
				default :
					Debug.fError("Error unknow type : " + _eType);
					Debug.fStop();
				//break;

			}
			
			return null;
		}
		
		public static function resolveVarTypeInLine(_oLine : LineObj):Void {
		
			//TODO automatique priority for string and multiplication
			doAutomatiqueStringPriority(_oLine); //Include 	doAutomatiqueHighOpPriority(_oNewLine) in Sublines created
			
			doAutomatiqueHighOpPriority(_oLine);
			
			resolveDominantVar(_oLine);
			
			//Special case Line ConvertIn :
			//Overite default eConvertInType for Var input to force convertion ex:  var  _oVar : Int  = cast( xxx )
			switch (_oLine.eType) {
				
				case  EuVarType._LineInputMod :
				case  EuVarType._LineInput :
				
					var _oLineInput: LineInput = cast(_oLine);	
					resolveVarTypeInLineObj(_oLine, _oLineInput.oVarInput);
					
				//	/Debug.trace1("Var Input type : "  + );
					//var _aTruc2 : Array<Dynamic> = _aTruc2[5];
				//break;
						
				case EuVarType._LineReturn :
					
					var _oLineReturn: LineReturn = cast(_oLine);
					resolveVarTypeInLineObj(_oLine, _oLineReturn.oVarReturn);
					
				//break;
				
				case EuVarType._LineDelete :
					
					//var _oLineDelete : LineDelete = LineDelete(_oLine);
					//resolveVarTypeInLineObj(_oLine, _oLineDelete.oVarReturn);
					
				//break;
				
				case EuVarType._ParamInput :
					
					var _oLineParamInput: ParamInput = cast(_oLine);
					resolveVarTypeInLineObj(_oLine, _oLineParamInput.oVarInput);
				
				//break;
				default:

			}
		}
		
		
		public static function resolveVarConvertion(_oCurrResult:VarObj, _oToType:VarObj, _bNewCreation:Bool = false, _oTemplateType:VarObj = null, _bLineReturn:Bool = false):VarObj{
			var _oConvertIn : VarObj;
			
			var _eCurrResultType : EuVarType = _oCurrResult.eType;
		
			if (_oCurrResult.eType == EuVarType._String && _oToType.eType == EuVarType._CallClass ) {//String to rc convertion test
				var _oRcClass : VarCallClass = cast(_oToType);
				
				if (_oRcClass.oCallRef.sName == "RcImg" || _oRcClass.oCallRef.sName == "RcFont") {
					
					return fStringToClass(cast(_oCurrResult,VarString), _oRcClass.oCallRef, _oRcClass);
				}
			}

			
			if (_oToType.eType == EuVarType._DataArr ) {	
				var _oModExt : VarResultModifier = new VarResultModifier(_oToType);
					/*
					if(_oCurrResult ==  _oToType){ //TODO SClass == CallClass
						_oModExt.oRef = EuVar.VarNone;
					}*/
					_oModExt.bScopeExtract = true; //TODO not if it was the same type
					return _oModExt;
			}

			if (_oToType.eType == EuVarType._LineArray ) {	
				if ( _eCurrResultType == EuVarType._Int) { //UIntX can be an adresse	(adressse 2 array)	auto cast
					return cast(_oToType,LineArray).oArray;
				}
				
				////////////
				//	Array<Dynamic> //
				////////////
				var _oArrayInput : LineArray =  cast( _oToType);
				var _nDimReq : UInt = _oArrayInput.nDimReq; //_nDimReq always be > 0
				
				if(_eCurrResultType != EuVarType._Null ){ //EuVarType._None not sure
					//Result type must be an Array<Dynamic>
					if (_eCurrResultType ==  EuVarType._LineArray) {
						var _oArrayResult : LineArray =  cast( _oCurrResult);
						if ( _nDimReq ==  _oArrayResult.nDimReq) {
							//VALID INPUT
							
						}else {
							Debug.fError("" + _oArrayInput.oArray.sName  + " wrong Dim " +  _oArrayResult.nDimCount + " Req : " + _nDimReq);
							var _aTruc3 : Array<Dynamic>=[];_aTruc3= _aTruc3[5];
						}
					
					}else {
						if (_eCurrResultType ==  EuVarType._NewArraySquare) {
							if (_oArrayInput.oArray.eType == EuVarType._FixeArray) {
								//			aFA2D[6] = [54];  --> [54] know is array
								cast(_oCurrResult,VarNewArraySquare).oIniArray = cast(_oArrayInput.oArray,VarFixeArray);
								cast(_oCurrResult,VarNewArraySquare).nDimReq = _oArrayInput.nDimReq;
								
							}else {
								Debug.fError("" + _oArrayInput.oArray.sName + " is not fixe array to applay new malloc");
								var _aTruc6 : Array<Dynamic>=[];_aTruc6 = _aTruc6[5];
							}
							
						}else{
							Debug.fError("" + _oArrayInput.oArray.sName  + " must input an array of Dim " + _nDimReq + " recieved type insteed : " + _eCurrResultType);
							var _aTruc4 : Array<Dynamic>=[];_aTruc4 = _aTruc4[5];
						}
					}
				}
				
				//Result type must be same dimention as request
				
			}else{
				
				 if (isVarCommon(_oCurrResult)) {
					
					 if (_eCurrResultType == EuVarType._QElement) { //specail common var

						
						if(_eCurrResultType !=  _oToType.eType){ ///Todo check if realluy same // not goood
							return _oToType;
						
							
						}else {//Both are queue
							if(  cast(_oCurrResult,VarQElement).oResultVarsType ==   cast(_oToType,VarQElement).oResultVarsType){ 
								return EuVar.VarNone;
							}else {
								return _oToType;
							}
						}

						
					}else{
						 
						//////////
						//COMMUN//
						//////////
						/*
						if (_eCurrResultType == 0) {
							//Error
							Debug.trace3("Error on type in type resolve, input type : " + _oToType.eType +  " Result "+ _oCurrResult.eType)
							var _aTruc : Array<Dynamic> = _aTruc[5];
						}*/
						
						if (_eCurrResultType !=  _oToType.eType) { ///Todo check if realluy same // not goood
							return  _oToType;
					

						}else {
							
							return EuVar.VarNone;
						}
					}

					
				}else {  
		

					///////////
					//SPECIAL//
					///////////

					switch (_eCurrResultType) {
						
						
				/*
						case EuVarType._Delegate:
		
							
							//return EuVarType._VarAny;
						//break;
						*/
						case EuVarType._Parent:
						case EuVarType._This:
						case EuVarType._SClass:
						case EuVarType._CallClass:
							
							if (_oToType.eType == EuVarType._QElement) { //Maybe usless with if (_oToType.eType  == EuVarType._Type ) { ??
								if ( cast(_oToType,VarQElement).oResultVarsType.eType == EuVarType._Type ) {
									if (_oCurrResult.eType == EuVarType._CallClass || _oCurrResult.eType == EuVarType._This || _oCurrResult.eType == EuVarType._Parent ) {
										var _oMod : VarResultModifier = new VarResultModifier(_oToType);
										_oMod.oTemplateType = _oTemplateType;
										_oMod.bScopeConvert = true; 
										_oMod.bNewCreation = true;
										//return EuVarType._VarAny;
							
										return _oMod;
									}
								}
							}
							
							if (_oToType.eType  == EuVarType._Type ) { //Template Type get to the result form ex : aArray.fPush(_val : Type)
								var _oMod : VarResultModifier = new VarResultModifier(_oCurrResult);
								_oMod.oTemplateType = _oTemplateType;
								_oMod.bScopeConvert = true;
								return _oMod;
							}

							if (_oToType.eType == EuVarType._CallClass ) {
								/*
								if(VarCallClass(_oToType).oCallRef ==  _oCurrResult){
									//_oLine.oConvertInType = EuVar.VarNone;
									//return;
								}*/
									//Debug.fStop();
								//Debug.trace1("***-----"  +VarCallClass(_oLine.oConvertInType).sName + " TYpe: -------- " + _oResultingType.eType);
								//_oLine.oConvertInType = EuVar.VarNone;
								/*
								if(_oLine.oConvertInType.eType == EuVarType._SClass){
									Debug.trace1("***-----"  + SClass(_oLine.oConvertInType).sName + " -------- " + VarCallClass(_oInputType).sName  + " " +  VarCallClass(_oInputType).bScopeOwner );
								}*/
								
						
							
						
								if (_bLineReturn || (cast(_oToType,VarCallClass).bScopeOwner && !(_oCurrResult.eType == EuVarType._CallClass && cast(_oCurrResult,VarCallClass).bScopeOwner)  )) {
									
									var _oMod : VarResultModifier = new VarResultModifier(_oToType);
									_oMod.bScopeConvert = true;
									//Debug.trace1("***-----"  +VarCallClass(_oLine.oConvertInType).sName + " -------- " + VarCallClass(_oInputType).sName  );
									if (_bNewCreation) {
										_oMod.bNewCreation = true;
									}
									//Debug.fStop();
									return _oMod;

								}
								
								if (_oCurrResult.eType == EuVarType._CallClass && cast(_oCurrResult,VarCallClass).bScopeOwner && !cast(_oToType,VarCallClass).bScopeOwner ) {
									var _oModExt : VarResultModifier = new VarResultModifier(_oToType);
									if(_oCurrResult ==  _oToType){ //TODO SClass == CallClass
										_oModExt.oRef = EuVar.VarNone;
									}
									_oModExt.bScopeExtract = true;
									return _oModExt;
									
								}
								
								
							}else {
								if(_oCurrResult !=  _oToType){ ///Todo check if realluy same // not goood
									return _oToType;
								}else {
									return EuVar.VarNone;
								}
							}
							
						//break;
						default:
					}
				}
			}
			
	
			if(_oCurrResult !=  _oToType){ ///Todo check if realluy same // not goood
				return _oToType;
			}else {
				return EuVar.VarNone;
			}
			
		}
		
		
		
		
		public static function resolveVarTypeInLineObj(_oLine : LineObj, _oVarInput:VarObj):Void {
			//var _oLineInput: LineInput = LineInput(_oLine);
		
			//_oLine.oResultingType = _oLine.oConvertInType; //We change it after (eResultingType maybe just for lineinput)
			var _oResultingType : VarObj = _oLine.oResultingType;
			
			
			var _oInputType  : VarObj =  getResultingType( _oVarInput );
			var _eResultType : EuVarType = _oResultingType.eType;
			var _eInputType : EuVarType = _oInputType.eType;
			

			if (	_oResultingType  == null) {
				Debug.fError("Type resolve result is null");
				var _aTruc2 : Array<Dynamic>=[];_aTruc2= _aTruc2[5];
			}
			
			var _bLineReturn : Bool = false;
			if (_oLine.eType == EuVarType._LineReturn) {
				_bLineReturn = true;
			}
			
			_oLine.oConvertInType = resolveVarConvertion(_oResultingType, _oInputType, _oLine.bNewCreation, null, _bLineReturn);
			
			
			
			
			
		}
		
	
		
		public static function resolveDominantVar(_oLine : LineObj):Void {
			
			var _oType : VarObj = findDominantVar(_oLine);

			_oLine.oConvertInType = _oType;
			_oLine.oResultingType = _oType;
			
			//applyConcatOp(_oLine, _oType); Old string use concat

			//Apply convertion to all var 
			applyVarConvertion(_oLine , _oType);
			
			applyResultType(_oLine);
		}
		
		//Make reulting type for every var and subline
		private static function applyResultType(_oLine : LineObj):Void {
				
			var _oVar : VarObj;
			var _oVarLine : LineObj;
			var _aVarObjList : Array<Dynamic>;
			_aVarObjList = _oLine.aVarList;
			
			//Find var dominant
			var _i:UInt = _aVarObjList.length;
			for (i in 0 ..._i) {
				var _oType : VarObj = getResultingType(_aVarObjList[i]);
				_oLine.aResultTypeList.push(_oType);
			
			}	
		}
		
		
		public static function getResultingType(_oVar : VarObj):VarObj {

	
	
			
			switch(_oVar.eType) {
				
				case  EuVarType._ResultModifier :
					return getResultingType(cast(_oVar,VarResultModifier).oRef);
				//break;	
	
				case  EuVarType._LineReturn 
				|  EuVarType._Line :
					//return LineObj(_oVar).oConvertInType;
					return cast(_oVar,LineObj).oResultingType;
				//break;
		
				
				case  EuVarType._NativeFuncCall 
				|  EuVarType._ExtendFuncCall 
				|  EuVarType._CallDelgate 
				|  EuVarType._FuncCall :
					return getResultingType(cast(_oVar,FuncCall).oFunction.oReturn);
				//break;
				
				case  EuVarType._Function :  
					return getResultingType(cast(_oVar,SFunction).oReturn);
				//break;
				
				case EuVarType._ExtendFunction :
					return cast(_oVar,ExtendFunc).oSFunc.oReturn; //Not sure but seam work
				//break;
				
				case  EuVarType._LineLoc :
					return cast(_oVar,LineLoc).oResultingType;
				//break;
				
				
				case  EuVarType._Thread :
						return _oVar;
				//break;
				case  EuVarType._This :
					//return VarThis(_oVar).oSBloc.oSClass;
						return cast(_oVar,VarThis);
				//break;
				case  EuVarType._Parent :
					//return VarThis(_oVar).oSBloc.oSClass;
						return cast(_oVar,VarParent);
				//break;
				
				
				
				case  EuVarType._AnyClass 
				|  EuVarType._CallClass :
					//return VarCallClass(_oVar).oCallRef;
					return cast(_oVar,VarCallClass);
				//break;
				
			/*case  EuVarType._AnyClass :
					//return VarCallClass(_oVar).oCallRef;
					return _oVar;
				//break;
				*/
				
				case EuVarType._RtuMap:
					return cast(_oVar,VarRtuMap);
				//break;
				
				case  EuVarType._Rtu :
					return cast(_oVar,VarRtu).oUnitRef; 
				//break;
				
				case  EuVarType._String :
					return _oVar;
				//break;
				
				case  EuVarType._QueueArray : //Not sure maybe is returning type ??
					return _oVar;
				//break;
				
				case  EuVarType._DataArr 
				|  EuVarType._FixeArray 
				|  EuVarType._DArray :
					return cast(_oVar,VarArray).oResultLineArray;
				//break;
				
				
				case  EuVarType._LineArray :
					var _oLineArray : LineArray = cast(_oVar);
					if (_oLineArray.nDimReq == 0) {
						//return _oLineArray.oArray.oVarsType;
						return getResultingType(_oLineArray.oArray.oVarsType);
					}
					return _oVar; //Reuslt an array
				//break;
				
				case  EuVarType._New :
					return cast(cast(_oVar,VarNew).oNewRef,VarStaticClass).oRefClass;
					//return _oVar);
				//break;
				
				case  EuVarType._PtrFunc :
					return _oVar;
				//break;
			
				case  EuVarType._SNatAttribut :
					return cast(_oVar,SNatAttribut).oAttType;
				//break;
				
				case  EuVarType._ExtendVar :
					return getResultingType(cast(_oVar,ExtendVar).oVar);
				//break;
				
				case  EuVarType._QElement :
					return _oVar;
				//break;
				
				case  EuVarType._NewArraySquare :
					return _oVar;
				//break;
				
				case  EuVarType._Any :
					return _oVar;
				//break;
				case  EuVarType._Type :
					return _oVar;
				//break;
				case  EuVarType._Null :
					return _oVar;
				//break;
				
				case  EuVarType._CallDelgate :
					return _oVar;
				//break;
				case  EuVarType._Delegate :
					return _oVar;
				//break;
				default:
				
			}
			
			
			if (TypeResolve.isVarCommon(_oVar)) {
				return _oVar;
				//return CommonVar(_oVar).eType;
			}

			return EuVar.VarNone; //TODO VarError
		}
		
		
		private static function applyConcatOp(_oLine : LineObj, _oDominantVar : VarObj):Void {
			//Change all op by concatenation if String (all is string) 
			if (_oDominantVar.eType == EuVarType._String) {
				var _aChangeOpList : Array<Dynamic> =  _oLine.aOpList;
				var _j:Int = _aChangeOpList.length;
				for (j in 0 ... _j) {
					_aChangeOpList[j] = EuOperator.Concat;
				}
			}
			///////
		}
		
		
		//Retrun the dominant var whitch has the highest priority
		public static function findDominantVar(_oLine : LineObj ):VarObj {
			
			//TODO resolve subline, rtu and array
			
			var _oVar : VarObj;
			var _oType : VarObj;
			var _oVarLine : LineObj;
			var _aVarObjList : Array<Dynamic> = _oLine.aVarList;
			
			_oVar = _aVarObjList[0];
			if (_oVar == null){
				Debug.fError("Unable to resolve types in line");
				Debug.fBreak();
			}
			
			_oType =  getResultingType(_oVar);
			
			/*
			if (_eType == EuVarType._Line) {
	
				 _oVarLine   = LineObj(_oVar);
				_eType = _oVarLine.eConvertInType;
			}
				*/
			var _oWinnerType : VarObj = _oType;
		
			
			//Find var dominant
			var _i:UInt = _aVarObjList.length;
			for ( i in 1 ...  _i) {
				_oVar = _aVarObjList[i];
				_oType =  getResultingType(_oVar);
				
				/*
				
				if (_eType == EuVarType._Line) {
		
					 _oVarLine   = LineObj(_oVar);
					_eType = _oVarLine.eConvertInType;
				}*/
				
				
				
				if (_oType.eType.getIndex() > _oWinnerType.eType.getIndex()) {
					_oWinnerType =_oType;
				}
			}	
			return _oWinnerType;
			
		}
		
		public static function findDominantResultBetween(_oLeft : VarObj, _oRight : VarObj):VarObj {

			_oLeft = getResultingType(_oLeft);
			_oRight  = getResultingType(_oRight);
			
			/*
			if (_oRight == null) {
				_oRight = EuVar.VarNone;
			}*/
			
			
			var _oDominant : VarObj;
			var _oSecond : VarObj;

			if (_oLeft.eType.getIndex() > _oRight.eType.getIndex()) {
				_oDominant = _oLeft;
				_oSecond = _oRight;
			}else {
				_oDominant = _oRight;
				_oSecond = _oLeft;
			}
			/*
			if (_oDominant.eType == EuVarType._Null) {
				return EuVar.VarNone;
			}*/
	
			if (_oDominant.eType == EuVarType._QElement) {  //Special case for queu array if the two arre same (queau)
				
				if (_oSecond.eType == EuVarType._Null) {
					return EuVar.VarNone;
				}
				
				return cast(_oDominant,VarQElement).oResultVarsType;  //TODO chek different type between the two
				
				
			}
			return _oDominant;
		}
	
		
		//Retrun the dominant var whitch has the highest priority
		public static function applyVarConvertion(_oLine : LineObj, _oDominantType : VarObj ):Void {
			
			//TODO resolve subline, rtu and array

			var _oVar : VarObj;
			var _eGetType : EuVarType;
			var _aVarObjList : Array<Dynamic> = _oLine.aVarList;
			var _aVarConvertIn : Array<Dynamic> = _oLine.aConvertInTypeList;
			
			var _i:UInt = _aVarObjList.length;
			for (i in 0 ..._i) {
				_oVar = _aVarObjList[i];
				_eGetType = getResultingType(_oVar).eType;
				/////////////
				if (_eGetType == _oDominantType.eType) { //Todo get nore precise not good --> temp
					if (_eGetType == EuVarType._String) { ///Convert 2 string additions
						if(_i != 1){ //More than one string we convert
							_aVarConvertIn[i] = _oDominantType;
						}
					}else {
						_aVarConvertIn[i] = EuVar.VarNone;
					}
					
				}else {
					///////////////////////Apply different type convertion /////////////
					_aVarConvertIn[i] = _oDominantType; 
					//if ( _oDominantType.eType == EuVarType._UInt){
					if ( _oDominantType.eType == EuVarType._Int && cast(_oDominantType,VarInt).bUnsigned){
						if ( _eGetType == EuVarType._Hex  ||  _eGetType == EuVarType._Int ) {  //Special case for UInt with fixe integer like : _nPixTR & UInt(16711935)
							_aVarConvertIn[i] = EuVar.VarNone;
						}
					}
					/////////////////////////////////////////////////////////////////////
				}
				///////
			}	
		}
		
		//Create priority with multiple vars between string ex:
		// var _sTest : String =    5  -  7 - 8 + 5 +  sAppName  + 5 + sAppName   + sAppName + sAppName + 4 + 5 + sAppName + sAppName  + sAppName ;
		//_sTest = (5 - 7 - 8 + 5) + sAppName + 5 + sAppName + sAppName + sAppName + (4 + 5) + sAppName + sAppName + sAppName;
		public static function doAutomatiqueStringPriority(_oLine : LineObj):Void {
			var _oVar : VarObj;
			var _aVarObjList : Array<Dynamic> = _oLine.aVarList;
			var _aVarOpList : Array<Dynamic> = _oLine.aOpList;

			
			var _aNewVarList : Array<Dynamic> = [];
			var _aNewOpList : Array<Dynamic> = [];
			
			var _nStart : UInt = 0;
			var _bConsecutiveVar : Bool = false;
			var _bCreateGroup : Bool = false;
			var _bJustOne : Bool = false;
			var _oNewLine : LineObj;
			var _bHaveString : Bool = false;
			
			var _bGroupCreated : Bool = false;
			
			var i : Int = 0;
			var _i:UInt = _aVarObjList.length;
			while (i  < _i) {
				_oVar = _aVarObjList[i];
				
				if (_oVar.eType == EuVarType._String) {
					_bHaveString = true;
					_bConsecutiveVar = false;
					
					//Create last group -- Same as below -------
					if (_bJustOne) {
						_bJustOne = false;
						//Just push previous alone var
						pushVarFromLineToArray(_aNewVarList, _aNewOpList, _oLine, i - 1, i - 1);
						
					}else if (_bCreateGroup) {
						_bCreateGroup = false;
						
						//Create the group
						_bGroupCreated = true;
						_oNewLine = createAutomatiquePriority(_oLine, _nStart, i - 1);
							doAutomatiqueHighOpPriority(_oNewLine);
							resolveDominantVar(_oNewLine);
						_aNewVarList.push( _oNewLine );
					// ---------------------------------
						_aNewOpList.push( _aVarOpList[i-1] );
					}
					
					//Just push the string
					pushVarFromLineToArray(_aNewVarList, _aNewOpList, _oLine, i, i);
			
					
				}else {
					if (_bConsecutiveVar == true) {
						//Create a group with consecutive vars, wait to next string or the end
						_bCreateGroup = true;	
						_bJustOne = false;
					}else {
						_bJustOne = true;
						_nStart = i; //Frist possible var of group
					}
					_bConsecutiveVar = true;

				}
				i++;
			}
			
	
		//	var i : Int  = _i;//???CW
			
			if (_bHaveString) {
				
				//Create last group -- Same as above -------
				if (_bJustOne) {
					_bJustOne = false;
					//Just push previous alone var
					pushVarFromLineToArray(_aNewVarList, _aNewOpList, _oLine, i - 1, i - 1);
						
				}else if (_bCreateGroup) {
					_bCreateGroup = false;
					
					//Create the group
					_bGroupCreated = true;
					_oNewLine = createAutomatiquePriority(_oLine, _nStart, i - 1);
						doAutomatiqueHighOpPriority(_oNewLine);
						resolveDominantVar(_oNewLine);
					_aNewVarList.push( _oNewLine );
				 // --------------------------------------
				}

				if(_bJustOne || _bCreateGroup){ //CW?
				//Delete?
				//Push new array var in the current line
				 _oLine.aVarList = _aNewVarList;
				 _oLine.aOpList = _aNewOpList;
				 }

				
			}else { //No String found Do nothing
				 _aNewVarList = null;
				 _aNewOpList = null;
			}


		}
		
		
		
		public static function doAutomatiqueHighOpPriority(_oLine : LineObj):Void {
			
			//Detect if we have both high and low togheter to separate them
			if (fHaveHighOpPriority(_oLine) && fHaveLowOpPriority(_oLine)){ //Have Some operation (+ - (& |) (* /))
				var _oNewLine : LineObj = new LineObj();
				
				
				var _eOp : EuOperator;
				var _oVar : VarObj;
				var _aVarObjList : Array<Dynamic> = _oLine.aVarList;
				var _aVarOpList : Array<Dynamic> = _oLine.aOpList;

				
				var _aNewVarList : Array<Dynamic> = [];
				var _aNewOpList : Array<Dynamic> = [];
				
				var _nStart : UInt = 0;
				var _bHighFound : Bool = false;
				//var _oNewLine : LineObj;
				
				var _bGroupCreated : Bool = false;
				
				//Do first high op test 
				_eOp = _aVarOpList[0];
				if (!EuOperator_.fAsLowPriority(_eOp) ) { 
					_bHighFound  = true;
						//_nStart = i;
						_nStart = 0;
				}
				
				var _i:UInt = _aVarOpList.length;
				for (i in  0 ...  _i + 1) {  //Op end with "0" 
					
			
					
					if (i < _i && !EuOperator_.fAsLowPriority(_aVarOpList[i]) ) {  //Multiplication and more
	
						if (!_bHighFound) {
							_bHighFound  = true;
							_nStart = i;
						}
						
					}else { //Adition substraction
						
						//Create last group -- Same as below -------
						if (_bHighFound) {
							_bHighFound = false;
							
							//Create the group
							_oNewLine = createAutomatiquePriority(_oLine, _nStart, i);
							resolveDominantVar(_oNewLine);
							_aNewVarList.push( _oNewLine );
							_aNewOpList.push( _aVarOpList[i] );
						}else{
							
							//Just push the adition / substration
							pushVarFromLineToArray(_aNewVarList, _aNewOpList, _oLine, i, i);
						}
						// --------------------------------------
				
					}
				
				}
			
				//Sure to have group
				//Delete?
				 //Push new array var in the current line
				 _oLine.aVarList = _aNewVarList;
				 _oLine.aOpList = _aNewOpList;
			

			}//if (fHaveHighOpPriority(_oLine) && fHaveLowOpPriority(_oLine)){
		}
		
		
		
		
		
		
		public static function fHaveHighOpPriority(_oLine : LineObj):Bool {
		
			var _eOp : EuOperator;
			var _aOpObjList : Array<Dynamic>;
			_aOpObjList = _oLine.aOpList;
	
			//Find var dominant
			var _i:UInt = _aOpObjList.length;
			for (i in 0 ..._i) {
				_eOp = _aOpObjList[i];
				
				if (!EuOperator_.fAsLowPriority(_eOp) ) { 
					return true;
				}
			}	
			return false;
		}
		public static function fHaveLowOpPriority(_oLine : LineObj):Bool {
		
			var _eOp : EuOperator;
			var _aOpObjList : Array<Dynamic>;
			_aOpObjList = _oLine.aOpList;
	
			//Find var dominant
			var _i:UInt = _aOpObjList.length;
			for (i in 0 ..._i) {
				_eOp = _aOpObjList[i];
				
				if (EuOperator_.fAsLowPriority(_eOp) ) { 
					return true;
				}
			}	
			return false;
		}
		
		
		
		public static function createAutomatiquePriority(_oRefLine : LineObj, _nStart:UInt, _nEnd:UInt):LineObj {
			
			var _oLine : LineObj = new LineObj();
			_oLine.nLine = _oRefLine.nLine; 
			_oLine.oSBloc = _oRefLine.oSBloc; 
			//_oLine.oSClass = _oRefLine.oSClass;
			//_oLine.oSFunction = _oRefLine.oSFunction;

			var _oVar : VarObj;

			var _aRefVarObjList : Array<Dynamic> = _oRefLine.aVarList;
			var _aRefVarOpList : Array<Dynamic> = _oRefLine.aOpList;
	
			//var _i:UInt = _nEnd;
			for ( i in _nStart ...  (_nEnd +1)) {
				_oVar = _aRefVarObjList[i];
	
				_oLine.aVarList.push(_oVar);
				if (i < _nEnd) { //Not the last

					_oLine.aOpList.push(_aRefVarOpList[i]);
				}
			}
			
			return _oLine;
		}
		
		
		public static function pushVarFromLineToArray(_aNewVarList : Array<Dynamic>, _aNewOpList:Array<Dynamic>,  _oRefLine : LineObj, _nStart:UInt, _nEnd:UInt):Void {
			
			var _oVar : VarObj;
//var _nOpp : UInt;
			var _aRefVarObjList : Array<Dynamic> = _oRefLine.aVarList;
			var _aRefVarOpList : Array<Dynamic> = _oRefLine.aOpList;
			var _nLineLimit:UInt  = _aRefVarObjList.length-1;
			
			//var _i:UInt = _nEnd +1;
			for ( i in  _nStart ... (_nEnd +1)) {
				_oVar = _aRefVarObjList[i];
				
				_aNewVarList.push(_oVar);
				
				if (i < _nLineLimit) { //Not the last
				//	_nOpp = ;
					_aNewOpList.push(_aRefVarOpList[i]);
				}
			}
		}
		
		
		public static function isVarCommon(_oVar : VarObj):Bool {
			if (_oVar.eType.getIndex() < EuVarType._BeforeIsCommun.getIndex()) {
				return true;
			}
			return false;
		}
		public static function isTypeCommon(_eType : EuVarType):Bool {
			if (_eType.getIndex() < EuVarType._BeforeIsCommun.getIndex()) {
				return true;
			}
			return false;
		}
		
		
		public static function fNoExtend(_oVar : VarObj ):VarObj {
			if (_oVar.eType ==  EuVarType._ExtendVar) {
				return  cast(_oVar,ExtendVar).oVar;
			}
			return _oVar;
		}
		
		
		/*
		public static function resolveTypePriority( ):CommonVar {
			
			
		}*/
		
		
		public static function fStringToClass(_oResultString:VarString, _oRcClass:SClass ,  _oToCallClass:VarCallClass ):VarObj {
			
			
			
				var _oResultRc : VarRc = new VarRc(_oResultString.oSBloc);
				_oResultRc.oResultStringRef = _oResultString;
				_oResultRc.oToCallClass = _oToCallClass;
				_oResultRc.oRcClass = _oRcClass;
			
				var _aVDrive : Array<Dynamic> =  _oResultString.sValue.split(":");
				if (_aVDrive.length == 0) {
					Debug.fError("Ressource require Drive or Virtual Drive, you need a first sentence followed by ':' ");
					return EuVar.VarNone;
				}
				var _sVDrive : String =  _aVDrive[0];
				if (_aVDrive.length == 1 || _aVDrive[1] == "") {
					Debug.fError("Ressource require a Path");
					return EuVar.VarNone;
				}
				if (_sVDrive == "Exe"){ //Ok exe will be load dynamicly
					_oResultRc.bPureVirtual = true;
					return _oResultRc;
				}
				
				
				var _sPath : String = _aVDrive[1];
				var _sName : String =  _sPath.split("/").join("_").split(".").join("_");
				
				
			
				
				var _oRc : Rc = SFind.findRcVDrive( _oResultString.oSBloc.oSClass.oSProject, _sVDrive);
				if (_oRc == null) {
					Debug.fError("Ressource not found"); //only if static
					_oResultRc.bPureVirtual = true;
					return _oResultRc;
				}
				
				_oResultRc.sEmbedRc = "oRcObj_Rc_" +  _oRc.sIdName + "_" + _oRc.sRcName  + _sName ;
				_oResultRc.bEmbedObj = true;
				//Add to the include list
				_oResultString.oSBloc.oSClass.aEmbedFileList.push(_oResultRc);
				
				
	
				
				return _oResultRc;
		}
		
		
	}

