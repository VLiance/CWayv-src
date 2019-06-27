package language.project.convertCpp ;
	import language.cwMake.line.Rc;
	import language.enumeration.EuBaliseLang;
	import language.enumeration.EuBetween;
	import language.enumeration.EuConstant;
	import language.enumeration.EuCppLineType;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuSharing;
	import language.enumeration.EuStringFormat;
	import language.enumeration.EuVarType;
	import language.project.convertSima.ExtractBlocs;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFind;
	import language.project.convertSima.SFunction;
	import language.project.convertSima.TypeResolve;
	import language.project.CppProject;
	import language.project.SProject;
	import language.Text;
	import language.TextType;
	import language.vars.logicObj.CompareObj;
	import language.vars.logicObj.LogicalObj;
	import language.vars.logicObj.LogicCase;
	import language.vars.logicObj.LogicElse;
	import language.vars.logicObj.LogicFor;
	import language.vars.logicObj.LogicForEach;
	import language.vars.logicObj.LogicIf;
	import language.vars.logicObj.LogicSwitch;
	import language.vars.logicObj.LogicWhile;
	import language.vars.logicObj.ScopeBalise;
	import language.vars.special.EnumObj;
	import language.vars.special.NativeFuncCall;
	import language.vars.special.SNatAttribut;
	import language.vars.special.SNatFunction;
	import language.vars.special.UnitObj;
	import language.vars.special.UseEnum;
	import language.vars.special.VarArray;
	import language.vars.special.VarDataArray;
	import language.vars.special.VarFixeArray;
	import language.vars.special.VarQElement;
	import language.vars.special.VarQueueArray;
	import language.vars.varObj.CallDelegate;
	import language.vars.varObj.CastTypeDef;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.Delegate;
	import language.vars.varObj.EaseOut;
	import language.vars.varObj.ExtendFunc;
	import language.vars.varObj.ExtendFuncCall;
	import language.vars.varObj.ExtendVar;
	import language.vars.varObj.FuncCall;
	import language.vars.varObj.LineArray;
	import language.vars.varObj.LineDelete;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.LineInputMod;
	import language.vars.varObj.LineLoc;
	import language.vars.varObj.LineObj;
	import language.vars.varObj.LineReturn;
	import language.vars.varObj.LineVarIni;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.PtrFunc;
	import language.vars.varObj.VarArrayInitializer;
	import language.vars.varObj.VarBoolean;
	import language.vars.varObj.VarCallClass;
	import language.vars.varObj.VarComment;
	import language.vars.varObj.VarCppLine;
	import language.vars.varObj.VarDec;
	import language.vars.varObj.VarExClass;
	import language.vars.varObj.VarFloat;
	import language.vars.varObj.VarGate;
	import language.vars.varObj.VarHex;
	import language.vars.varObj.VarHoldEnum;
	import language.vars.varObj.VarInc;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarLong;
	import language.vars.varObj.VarNew;
	import language.vars.varObj.VarNewArraySquare;
	import language.vars.varObj.VarNumber;
	import language.vars.varObj.VarObj;
	import language.vars.varObj.VarRc;
	import language.vars.varObj.VarRtu;
	import language.vars.varObj.VarStaticClass;
	import language.vars.varObj.VarString;
	import language.vars.varObj.VarULong;
	import language.vars.varObj.VarVal;
	import language.base.Debug;
	import language.vars.varObj.VarVector;
	//import ssp.filesystem.File;
	//import ssp.phone.Fax;
	/**
	 * ...
	 * @author ...
	 */
	class ConvertLines {
		
		//public static var oCurrClass = null;

		
				
		public static function convertFunctionLines(_oFile:CommonCpp, _oSFunc:SFunction, _bTab:Bool = false):Void {
		
			if (_oSFunc.aLineList.length == 0 && !_oSFunc.bConstructor && !_oSFunc.oSClass.oSLib.bReadOnly && !_oSFunc.oSClass.oPackage.oSFrame.bWrapper) {
				_oFile.pushLine("GZ_mIsImplemented(\"" +  _oSFunc.oSClass.oSLib.sIdName + "::" +  _oSFunc.oSClass.sName +  "::" + _oSFunc.sName  + "\")");
				/*
				_oFile.pushLine("static gzBool bTraced = false;");
				_oFile.pushLine("if(!bTraced){");
					_oFile.pushLine("bTraced = true;");
					_oFile.pushLine("Lib_GZ::Sys::pDebug::fConsole(gzU8(\"" + _oSFunc.sName  + "\") + gzU8(\" not implemented\"));");
				_oFile.pushLine("}");
				*/
			}else{
				convertBlocLines(_oFile, _oSFunc, _bTab);
			}
			
			//	convertBlocLines(_oFile, _oSFunc, _bTab);
		}
		
		
		
		
		public static function convertBlocLines(_oFile:CommonCpp, _oSBloc:SBloc, _bTab:Bool = false):Void {
			
			ExtractBlocs.oCurrSClass = _oSBloc.oSClass;

			
			if (_bTab) {
				_oFile.addTab();
			}
			
			///////////////////////////////////// ???
			//Check to ini special var
			if (_oSBloc.aVarListSpecial.length > 0) {
				var _aSpecialVar:Array<Dynamic> = _oSBloc.aVarListSpecial;
				_oFile.pushLine("//Special var :");
				var _i:UInt = _aSpecialVar.length;
				for (i in 0 ..._i) {
					var _oSpecialVar : CommonVar = _aSpecialVar[i];
					convertSpecialVar(_oFile, _oSBloc, _oSpecialVar);
				}
				_oFile.addSpace();
				
			}
			////////////////////////////////////
			
			
			var _aLines : Array<Dynamic> = _oSBloc.aLineList;
			var _j:UInt = _aLines.length;
			for (j in 0 ... _j) {
				var _oLine : VarObj = _aLines[j];
				convertLineType(_oFile, _oLine,_oSBloc);
			}
			
			subBlocIntelliPtr(_oFile, _oSBloc);
			
			if (_bTab) {
				_oFile.subTab();
			}
		}
		
		
		public static function convertLineType(_oFile:CommonCpp, _oLine : VarObj, _oSBloc:SBloc):Void {
			switch(_oLine.eType) {
				
		
				case EuVarType._LineInput :  //Normal line

					_oFile.pushLine( convertInputLine(_oSBloc, cast(_oLine,LineInput), EuOperator.None) + ";");
					
				//break;
				
				case EuVarType._LineReturn : 
					var _oLineReturn : LineReturn = cast(_oLine);
					//subNewRefParamIPtr(_oFile, _oLineReturn.oSBloc.oSFunction); //Substract intelli Ptr
					subBlocIntelliPtr(_oFile,  _oLineReturn.oSBloc.oSFunction); //Substract intelli Ptr with test if zero then destroy
					_oFile.pushLine( "return " + checkVarConvertIn( _oLine , _oLineReturn.oConvertInType , convertLineToCpp(cast(_oLine,LineObj), null)) + ";");
				//break;
				
				case EuVarType._LineDelete :
					var _oLineDelete : LineDelete = cast(_oLine);
					//subNewRefParamIPtr(_oFile, _oLineReturn.oSBloc.oSFunction); //Substract intelli Ptr
					subBlocIntelliPtr(_oFile,  _oLineDelete.oSBloc.oSFunction); //Substract intelli Ptr with test if zero then destroy
					_oFile.pushLine(  convertLineToCpp(cast(_oLine,LineObj), null)+ "->tDelete();");
				//break;

				
				case  EuVarType._LineInputMod :
					_oFile.pushLine( convertInputLine( _oSBloc , cast(_oLine,LineInput), cast(_oLine,LineInputMod).eOppType) + ";");
				//break;
					
				case EuVarType._LogicIf :
					var _oLogicIf : LogicIf = cast(_oLine);
					_oFile.pushLine("if (" + convertCppVarType(_oLogicIf.oObjIf, _oLogicIf.nLine) + "){");
					//pushLine(_sStart + "if (" + convertConditionnalLine(_aLine) + "){");
					//convertLineList(_aLine[cLineList], true);
					//convertFalseBloc(_aLine);
				
					convertBlocLines(_oFile, _oLogicIf , true);
					_oFile.pushLine("}");
					
				//break;
				
	
				case EuVarType._LogicIfElse 
				| EuVarType._LogicIfElseIf :
					//Same as above -----
					var _oLogicIfElse : LogicIf = cast(_oLine);
					_oFile.pushLine("if (" + convertCppVarType(_oLogicIfElse.oObjIf, _oLogicIfElse.nLine) + "){");
					convertBlocLines(_oFile, _oLogicIfElse , true);
					convertLineType(_oFile, _oLogicIfElse.oBlocElse,_oSBloc);
					///------------------
				//break;	
				
				case EuVarType._LogicElseIf :
					//Same as above -----
					var _oLogicElseIf : LogicIf = cast(_oLine);
					_oFile.pushLine("}else if (" + convertCppVarType(_oLogicElseIf.oObjIf, _oLogicElseIf.nLine) + "){");
					convertBlocLines(_oFile, _oLogicElseIf , true);
					if (_oLogicElseIf.oBlocElse != null) {
						convertLineType(_oFile, _oLogicElseIf.oBlocElse,_oSBloc);
					}else {
						_oFile.pushLine("}");
					}
					///------------------
				//break;	
				
				
					
				case EuVarType._LogicElse : 	
					_oFile.pushLine("}else{");
					var _oLogicElse : LogicElse = cast(_oLine);
					convertBlocLines(_oFile, _oLogicElse , true);
					_oFile.pushLine("}");
				//break;
				
				
				case EuVarType._LogicFor :
					var _oLogicFor : LogicFor = cast(_oLine);
					_oFile.pushLine("for(" + convertInputLine(_oSBloc, _oLogicFor.oIni, EuOperator.None) + "; "
									+  convertCppVarType(_oLogicFor.oCond, _oLogicFor.nLine) + "; "
									+ 	convertLineTypeLight(_oSBloc, _oLogicFor.oIncDec) + "){");
									
					//pushLine(_sStart + "if (" + convertConditionnalLine(_aLine) + "){");
					//convertLineList(_aLine[cLineList], true);
					//convertFalseBloc(_aLine);
				
					convertBlocLines(_oFile, _oLogicFor , true);
					_oFile.pushLine("}");
					
				//break;
				
				case EuVarType._LogicForEach : 
					var _oLogicForEach : LogicForEach = cast(_oLine);
					
					var _sEach : String = convertCppVarType(_oLogicForEach.oEach, _oLogicForEach.nLine);
					var _sEachOri : String =  _sEach;
						
					if (_oLogicForEach.bQElementNew) {
						//var _sEach : String = convertCppVarType(_oLogicForEach.oEach, _oLogicForEach.nLine);
						//var _sEachOri : String =  _sEach;
						if (_oLogicForEach.bQElementBypass) {
							_sEach = "_qe" + _sEach;
						}
						_oFile.pushLine("gzFOR_EACH_QArrayNew(" + convertCppVarType(_oLogicForEach.oIn, _oLogicForEach.nLine) + ", " +  _sEach + ", " + TypeText.typeToCPP(_oLogicForEach.oInType) + "){" );
					}else {
						_oFile.pushLine("gzFOR_EACH_QArrayFrom(" + convertCppVarType(_oLogicForEach.oIn, _oLogicForEach.nLine) + ", " +  _sEach + ", " + TypeText.typeToCPP(_oLogicForEach.oInType) + "){" );
					}
					if (_oLogicForEach.bQElementBypass) {
						if (_oLogicForEach.oInType.eType == EuVarType._CallClass) {
							_oFile.pushLine( "	"  + TypeText.typeToCPP(_oLogicForEach.oInType, false,false,false,false,true) + " " + _sEachOri + " = " + _sEach + ".val()->get();");
						}else{
							_oFile.pushLine( "	"  + TypeText.typeToCPP(_oLogicForEach.oInType, false,false,false,false,true) + " " + _sEachOri + " = " + _sEach + ".ref();");
						}
					}
					
					convertBlocLines(_oFile, _oLogicForEach , true);
					_oFile.pushLine("gzEND_QArray(" +  _sEach + ")}");
					
					
				//break;
				
				
				case EuVarType._LogicWhile :
					var _oLogicWhile : LogicWhile = cast(_oLine);
					_oFile.pushLine("while(" +  convertCppVarType(_oLogicWhile.oCond, _oLogicWhile.nLine) +  "){");
					convertBlocLines(_oFile, _oLogicWhile , true);
					_oFile.pushLine("}");
					
				//break;
				
				case EuVarType._LogicSwitchCast
				| EuVarType._LogicSwitch :
					var _oLogicSwitch : LogicSwitch = cast(_oLine);
					_oFile.pushLine("switch(" +  convertCppVarType(_oLogicSwitch.oSwitchLine, _oLogicSwitch.nLine) +  "){");
					convertBlocLines(_oFile, _oLogicSwitch , true);
					_oFile.pushLine("}");
					
				//break;
				
				case EuVarType._LogicCase :
					var _oLogicCase : LogicCase = cast(_oLine);
					_oFile.pushLine("case " +  convertCppVarType(_oLogicCase.oCaseLine, _oLogicCase.nLine) +  ":{");
					convertBlocLines(_oFile, _oLogicCase , true);
					_oFile.pushLine("}break;");
					
				//break;
				
				
				case EuVarType._Balise :
					var _oBalise : ScopeBalise = cast(_oLine);
					switch(_oBalise.eBaliseLang) {
						case EuBaliseLang.Glsl:
							
							_oFile.pushLine("// --- Tag Glsl");
							//_oFile.pushLine("oVertex->fAdd(gzU8(");
							convertBlocLines(_oFile, _oBalise, true);
							//_oFile.pushLine("));");
							_oFile.pushLine("// --- End Tag Glsl");
						//break;
						
					default:
							_oFile.pushLine("//Tag " + _oBalise.sBaliseName);
						//break;	
					}
				//break;
				
				default : 	//Simple Normal line
					var _sVarString : String = convertCppVarType(_oLine, 0);
					if(_oLine.eType != EuVarType._Comment && _oLine.eType != EuVarType._CppLine){  //Don't show ; to comment
						_oFile.pushLine( _sVarString + ";");
					}else {
						_oFile.pushLine( _sVarString );
					}
					//Debug.tra("Error, unknow line for cpp : " + _oLine.eType);
				//break;
				
			}
		}
		
		//Same as above (convertLineType) but return string intead (FOR statement and other ) ex: for (var i:Int = 0; _nBob < 40; THIS) {
		private static function convertLineTypeLight(_oSBloc : SBloc,  _oLine : VarObj):String {
			switch(_oLine.eType) {
			
				case  EuVarType._LineInputMod :
						return convertInputLine(_oSBloc, cast(_oLine,LineInputMod), cast(_oLine,LineInputMod).eOppType);
				//break;	
				
				case EuVarType._LineInput :  //Normal line
					return convertInputLine(_oSBloc, cast(_oLine,LineInput),EuOperator.None);
				//break;
				
				default : 	//Simple Normal line
					return convertCppVarType(_oLine, 0);
					//Debug.tr("Error, unknow line for cpp : " + _oLine.eType);
				//break;
			}
			
			//Debug.trac("Error convertLineTypeLight type not found : " + _oLine.eType);
			return null;
		}
		
		public static function convertInputLine(_oSBloc : SBloc , _oLineInputVar : VarObj, _eOpp : EuOperator , _bOnlyInput:Bool = false):String {
		//public static function convertInputLine(_oLineInputVar : VarObj, _eOpp : EuOperator =null, _bOnlyInput:Bool = false):String {
	//		if (_eOpp==null) _eOpp = EuOperator.None;
			
			if (_oLineInputVar == EuVar.VarNone) {
				return "";
			}
			
			var _oLineInput  : LineInput = cast(_oLineInputVar);
			ExtractBlocs.nCurrLine = _oLineInput.nLine;
					
			var _sLineInput : String = convertCppVarType(_oLineInput,_oLineInput.nLine, false, null, _oSBloc); //line after =
			_sLineInput =  TypeText.getConvertFunc(_sLineInput,  _oLineInput.oConvertInType,  _oLineInput.oResultingType);
			
			/*
			//Add cast for the input
			if (_oLineInput.oConvertInType.eType != EuVarType._None) {
				_sLineInput = fGetConvertInType(_oLineInput.oResultingType, _oLineInput.oConvertInType) +"(" + _sLineInput  + ")";
			}*/
				
			if (_bOnlyInput) {
				return _sLineInput;
			}
			
			var _sInputVarString : String = makeInputVarString( _oLineInput);
			/* SPECIAL CASE WITH NO "="
			switch(_oLineInput.oConvertInType.eType){
				case  EuVarType._PtrFunc: 
					if (_oLineInput.aVarList.length == 1) { //Only PtrFunc --> add this
						return _sInputVarString + ".bind(" +  "this" + _sLineInput + ")";
					}else{
						return _sInputVarString + ".bind(" + _sLineInput + ")";
					}
				//break;
				
			}*/
			/*
			if (_oLineInput.oVarInput.eType == EuVarType._String) {
					if (_oLineInput.bVarCreation) {
						return "GZ_fNewSet(" + _sInputVarString + ", " + _sLineInput + sMakeInputVarString_After + ")" 
					}else {
						return "GZ_fSet(" + _sInputVarString + ", " + _sLineInput + sMakeInputVarString_After + ")"	
					}
			}
			*/
			if(_eOpp == EuOperator.None){
				return _sInputVarString + " = " + _sLineInput + sMakeInputVarString_After;
			}else {
				return _sInputVarString +  " " + TypeText.opToString(_eOpp) + "= " + _sLineInput + sMakeInputVarString_After;
			}
		}
		
		
		
		private static function convertConditionnalOrAnd(_oVar : LogicalObj, _sMultiOp:String):String {
			
			var _sLine : String = "";
			//make first var
			var _aVarList : Array<Dynamic> = _oVar.aVarList;

			for (i in 0 ...   _aVarList.length) {	
				if (i == _aVarList.length-1){
					_sMultiOp = "";
				}
				_sLine += convertCppVarType(_aVarList[i], _oVar.nLine, true) + _sMultiOp;
			}
			return  _sLine;
		}
		
		
		private static function convertConditionnalCompare(_oCompare : CompareObj):String {
						
			var _oLeftLine : VarObj = _oCompare.oLineLeft;
			var _oRightLine : VarObj =  _oCompare.oLineRight;
			var _eConOpp : EuOperator = _oCompare.eOpp;
			
			
			var _sLeft : String = convertCppVarType(_oLeftLine, _oCompare.nLine, true, _oCompare.oConvertLeft);
			
			//var _sConOpp : String =// TypeText conOppTypeToString(_nConOpp);
			var _sConOpp : String = TypeText.logicOpToString(_eConOpp);


			var _sRight : String = convertCppVarType(_oRightLine, _oCompare.nLine, true, _oCompare.oConvertRight );
		
			return _sLeft + " " +_sConOpp + " " +_sRight;
		}
		
		
		
		
		public static function convertCppVarType( _oVar:VarObj, _nLineNum: UInt, _bPriority:Bool = false, _oConvertIn : VarObj = null, _oContainer:VarObj = null, _oNextVar: VarObj = null):String {

			
			/*
			if(_nType == cTypeExtendVar){
				var _nClass : UInt = _aSelectedVar[cVarListClass];
				_aSelectedVar = aClassVar[_nClass][ _aSelectedVar[cVarListValue] ];
				_nType = _aSelectedVar[cVarListType];
			}*/
			////////////////////No name var //////////////////// ex: 5421
			
			switch(_oVar.eType) {

				case  EuVarType._LineInputMod
				| EuVarType._LineInput
				| EuVarType._Line :
					
					//Recursive call
					if (_bPriority) {
					
						//return fGetConvertInType(LineObj(_oVar).oResultingType, _oConvertIn) + "(" + convertLineToCpp(LineObj(_oVar)) + ")";
						//return "(" + TypeText.getConvertFunc( convertLineToCpp(cast(_oVar,LineObj), _oContainer) , _oConvertIn, cast(_oVar,LineObj).oResultingType , null, _oContainer) + ")";
						return "(" + TypeText.getConvertFunc( convertLineToCpp(cast(_oVar,LineObj), _oContainer) , _oConvertIn, cast(_oVar,LineObj).oResultingType , null, _oVar) + ")";
					}else {
						//return convertLineToCpp(LineObj(_oVar), _oContainer);
					//	return TypeText.getConvertFunc( convertLineToCpp(cast(_oVar,LineObj), _oContainer) , _oConvertIn, cast(_oVar,LineObj).oResultingType, null, _oContainer );
						return TypeText.getConvertFunc( convertLineToCpp(cast(_oVar,LineObj), _oContainer) , _oConvertIn, cast(_oVar,LineObj).oResultingType, null, _oVar );
					}
				//break;
				
				/* MOVE TO CONVERT LINE
				case EuVarType._LineReturn : 
					var _oLineReturn : LineReturn = LineReturn(_oVar);
					return "return " + checkVarConvertIn( _oVar , _oLineReturn.oConvertInType , convertLineToCpp(LineObj(_oVar), _oContainer));
				//break;
				*/
				
				case EuVarType._ParamInput : 
					var _oParamInput : ParamInput = cast(_oVar);
					//return checkVarConvertIn( _oVar , _oParamInput.oConvertInType, convertLineToCpp(cast(_oVar,LineObj), _oContainer), _oContainer);
					return checkVarConvertIn( _oVar , _oParamInput.oConvertInType, convertLineToCpp(cast(_oVar,LineObj), _oContainer), _oVar);
				//break;
				
			
				case EuVarType._LineVarIni : 
					
					var _oVarIni : CommonVar = cast(cast(_oVar,LineVarIni).oVarToIni);
					return TypeText.typeToCPP( _oVarIni ) + " " + _oVarIni.sName + getSpecialVarIni(_oVarIni);
				//break;
				
				
				case EuVarType._LineLoc : 
					return  checkVarConvertIn(cast(_oVar,LineLoc).oResultingType, _oConvertIn, convertLineLoc(cast(_oVar,LineLoc)), _oVar);
				//break;
				
				
				case EuVarType._Compare :
					return convertConditionnalCompare(cast(_oVar,CompareObj));
				//break;
				
				case EuVarType._LogicalAnd :
					if(_bPriority){
						return "(" + convertConditionnalOrAnd(cast(_oVar,LogicalObj), " && ") + ")";
					}else {
						return convertConditionnalOrAnd(cast(_oVar,LogicalObj), " && ");
					}
				//break;
				
				case EuVarType._LogicalOR :
					if(_bPriority){
						return "(" +  convertConditionnalOrAnd(cast(_oVar,LogicalObj), " || ") + ")";
					}else {
						return  convertConditionnalOrAnd(cast(_oVar,LogicalObj), " || ");
					}
				//break;
			
				case EuVarType._Bool :
					var _oVarBool : VarBoolean = cast(_oVar);
					
					var _sStrBool : String;
					if (_oVarBool.sName == null) { //Take is value instead
						if (_oVarBool.nValue == 0) {
							_sStrBool = "false";
						}else {
							_sStrBool = "true";
						}
					}else {
						_sStrBool = _oVarBool.sName;
					}
					
					return  checkVarConvertIn(_oVar, _oConvertIn, checkIfCurStaticLoc(_oVar, _oContainer) + _sStrBool, _oContainer);
						
				//break;
				
				case EuVarType._Val :
					var _oVarVal : VarVal = cast(_oVar);
					return  checkVarConvertIn(_oVar, _oConvertIn, checkIfCurStaticLoc(_oVar, _oContainer) + _oVarVal.sName, _oContainer);
				//break;
					
				case EuVarType._Hex :
					
					var _oVarHex: VarHex = cast(_oVar);
					return  checkVarConvertIn(_oVar, _oConvertIn, checkIfCurStaticLoc(_oVar, _oContainer) + cast(_oVarHex.nValue,String), _oContainer);
					
				//break;
				/*
				case EuVarType._UInt :
					
					var _oVarUInt : VarUInt = VarUInt(_oVar);
					return checkVarConvertIn(_oVar, _oConvertIn, _oVarUInt.sName);
					
				//break;
				*/
				
				
				case EuVarType._Number :
					
					var _oVarNumber : VarNumber = cast(_oVar);
					
					var _sStrInt : String;
					if (_oVarNumber.sName == null) { //Take is value instead
						_sStrInt =  cast(_oVarNumber.nValue);
					}else {
						_sStrInt = _oVarNumber.sName;
					}
					
					return checkVarConvertIn(_oVar, _oConvertIn,  checkIfCurStaticLoc(_oVar, _oContainer) +  _sStrInt, _oContainer);
					
				
				case EuVarType._Int :
					
					var _oVarInt : VarInt = cast(_oVar);
					
					var _sStrInt : String;
					if (_oVarInt.sName == null) { //Take is value instead
						_sStrInt =  cast(_oVarInt.nValue);
					}else {
						_sStrInt = _oVarInt.sName;
					}
					
					return checkVarConvertIn(_oVar, _oConvertIn,  checkIfCurStaticLoc(_oVar, _oContainer) +  _sStrInt, _oContainer);
					
					/* No pix tranform anymore
					if (_oVarInt.bConvertInPixel) {
						if(_oVarInt.nPixfrac == 0){
							return "m_Pix(" + checkVarConvertIn(_oVar, _oConvertIn, _sStrInt) + ")";
						}else {
							return "m_PixF(" + checkVarConvertIn(_oVar, _oConvertIn, _sStrInt) + ", 0." +  _oVarInt.nPixfrac + ")";
						}
					}else {
						return checkVarConvertIn(_oVar, _oConvertIn, _sStrInt);
					}*/
				
					
				//break;
				
				case EuVarType._ULong :
					
					var _oVarULong : VarULong = cast(_oVar);
					return checkVarConvertIn(_oVar, _oConvertIn,  checkIfCurStaticLoc(_oVar, _oContainer) +  _oVarULong.sName, _oContainer);
					
				//break;
				
				case EuVarType._Long :
					
					var _oVarLong : VarLong = cast(_oVar);
					
					var _sStrLong : String;
					if (_oVarLong.sName == null) { //Take is value instead
						_sStrLong =  cast(_oVarLong.nValue);
					}else {
						_sStrLong = _oVarLong.sName;
					}
					
					return  checkVarConvertIn(_oVar, _oConvertIn,  checkIfCurStaticLoc(_oVar, _oContainer) +  _sStrLong, _oContainer);
					
				//break;
				
				
				case EuVarType._Float :
					
					var _oVarFloat : VarFloat = cast(_oVar);
					var _sStrFloat : String;
					if (_oVarFloat.sName == null) { //Take is value instead
						_sStrFloat =  cast(_oVarFloat.nValue);
						//Add dot if non (Integer value);
						if (_oVarFloat.nValue - cast(_oVarFloat.nValue,Int) == 0) { 
							_sStrFloat += ".0";
						}
						
					}else {
						_sStrFloat = _oVarFloat.sName;
					}
					
					return  checkVarConvertIn(_oVar, _oConvertIn,  checkIfCurStaticLoc(_oVar, _oContainer) +  _sStrFloat, _oContainer);
					
				//break;
				
				case EuVarType._Any :
					var _oAny : CommonVar = cast(_oVar);
					return  _oAny.sName;
				//break;
				
				
			case EuVarType._String :
				
					var _oVarString : VarString = cast(_oVar);
					
					if (_oConvertIn != null && _oConvertIn.eType == EuVarType._Rc) {
						var _oVarRc : VarRc = cast( _oConvertIn);
						if (_oVarRc.bPureVirtual) {
							
							if (!_oVarRc.oToCallClass.bScopeOwner) {
								return  "Lib_GZ::File::RcImg::Get(thread)->New(this," +  convertCppVarType(_oVar,_nLineNum, _bPriority,  _oVarRc.oResultStringRef, _oContainer, _oNextVar)   + ").get()";
							}else {
								return  "Lib_GZ::File::RcImg::Get(thread)->New(this," +  convertCppVarType(_oVar,_nLineNum, _bPriority,  _oVarRc.oResultStringRef, _oContainer, _oNextVar)   + ")";
							}
						
						}else if (_oVarRc.bEmbedObj) {
							return _oVarRc.sEmbedRc + ".get()"; //Already an object
						}
						Debug.fError("none");		
					}

					if (_oVarString.sName == null) { //Take is value instead
						
						if (_oVarString.eFormat == EuStringFormat.Embed) {
							
							return "Removed Embed -> error";
							/*
							var _aVDrive : Array<Dynamic> =  _oVarString.sValue.split(":");
							if (_aVDrive.length == 0) {
								Debug.fError("Ressource require Drive or Virtual Drive, you need a first sentence followed by ':' ");
								return "RcError";
							}
							var _sVDrive : String =  _aVDrive[0];
							if (_aVDrive.length == 1 || _aVDrive[1] == "") {
								Debug.fError("Ressource require a Path");
								return "RcError";
							}
							var _sPath : String = _aVDrive[1];
							var _sName : String =  _sPath.split("/").join("_").split(".").join("_");
							
							var _oRc : Rc = SFind.findRcVDrive( _oVarString.oSBloc.oSClass.oSProject, _sVDrive);
							if (_oRc == null) {
								return "RcError";
							}
							
							return "oRcObj_Rc_" +  _oRc.sIdName + "_" + _oRc.sRcName  + _sName + ".get()";
							*/
							
							//return  "Rc::" + _sName;
							//return  "oRcObj_Rc_GZ_RcEngine_Transform_png.get()";
							//return  "oRcObj_Rc_GZ_RcEngine_Transform_png.get()";
							
							
						}else {
							//return "GZ_fNStr(" + SProject.oCurr.sStringType + "\"" + _oVarString.sValue + "\")";
							//return  "gzLStr(" + SProject.oCurr.sStringType + "\"" + _oVarString.sValue + "\", "  +   String( Text.getStringLength( _oVarString.sValue ) ) + ")";				
							return  "gzU8(\"" + _oVarString.sValue + "\")";			
						}
					}
					
					
					return checkVarConvertIn(_oVar, _oConvertIn,   _oVarString.sName, _oContainer);
					/*
					if (_oConvertIn != null) {
						if (_oConvertIn.eType == EuVarType._String) { //TODO TODO TODO Use Convert in ?String?
							if(_oContainer == null){
								//return  "gzPStr(" + _oVarString.sName + ")";
								return   _oVarString.sName;
							}
						}
					}
					return  _oVarString.sName ;
						//_sName = convertVarToString("directName",   _aSelectedVar[cVarListName]);
				*/
		
				//break;
	

				
				case EuVarType._Function : 
					var _oVarFunction : SFunction = cast(_oVar);
					var _sBefore : String = "";  
					/* Now in namespace classe _
					if (_oVarFunction.bStatic) {  //Super constructor condition
						_sBefore = CppProject.sStaticPrefix;
					}*/
					return  _sBefore + checkVarConvertIn(_oVar, _oConvertIn,  _oVarFunction.sName + "()", _oContainer);
				//break;
				
				case EuVarType._ExtendFunction :
					var _oExtendFunc : ExtendFunc = cast(_oVar);
					var _sExFuncName : String = _oExtendFunc.oSFunc.sName;  
					if (_oExtendFunc.oSFunc.bConstructor) {  //Super constructor condition
						//_sExBefore = "Ini_" + _oExtendFunc.oSFunc.oSClass.oSLib.sWriteName + "_";
						_sExFuncName = "c" + _oExtendFunc.oSFunc.oSClass.sName + "::" + Setting.sConstructorKeyword;
					}
					return   checkVarConvertIn(_oExtendFunc.oSFunc, _oConvertIn, _sExFuncName + "()", _oContainer);
				//break;
				
				
	
				case EuVarType._GateFuncCall:{
					
					var _oVarFuncCall : FuncCall = cast(_oVar);
					var _oVarFunc : SFunction = _oVarFuncCall.oFunction;
				
					//return  "fSend(new " +  _oVarFunc.oSClass.sNsAccess + _oVarFunc.oSClass.sName + "::c" + checkVarConvertIn(_oVarFunc.oReturn, _oConvertIn,  _oVarFunc.sName + "(" +  convertFuncCallParam(_oVarFuncCall) + ")", _oContainer) + ")";
					//With Parent:
					//return  "Send(new " +  _oVarFunc.oSClass.sNsAccess + _oVarFunc.oSClass.sName + "::c" + checkVarConvertIn(_oVarFunc.oReturn, _oConvertIn,  _oVarFunc.sName + "(this" +  convertFuncCallParam(_oVarFuncCall, false) + ")", _oContainer) + ")";
					//Without Parent:
					return  "Send(new " +  _oVarFunc.oSClass.sNsAccess + _oVarFunc.oSClass.sName + "::c" + checkVarConvertIn(_oVarFunc.oReturn, _oConvertIn,  _oVarFunc.sName + "(" +  convertFuncCallParam(_oVarFuncCall) + ")", _oContainer) + ")";
					
						
				}
					
				
				
				case EuVarType._NativeFuncCall :
					var _oNativeFuncCall : NativeFuncCall = cast(_oVar);
					var _oVarNatFunc : SNatFunction  = cast(_oNativeFuncCall.oFunction);
					var _sParm : String;

					if(_oNativeFuncCall.aParamList.length > 0){
						_sParm  =  ", " + convertFuncCallParam(_oNativeFuncCall);
					}else {
						_sParm = "";
					}
					if(!_oVarNatFunc.bIntegrateFunc){
						return  checkVarConvertIn(_oVarNatFunc, _oConvertIn, _oVarNatFunc.sConvertName + "(" + _oVarNatFunc.sBeforeSource + convertCppVarType(_oNativeFuncCall.oSource, _oNativeFuncCall.nLineNum )  + _sParm +  ")", _oNativeFuncCall.oSource);	
					}else{
						return  checkVarConvertIn(_oVarNatFunc, _oConvertIn,  _oVarNatFunc.sBeforeSource + convertCppVarType(_oNativeFuncCall.oSource, _oNativeFuncCall.nLineNum , false, null, _oNativeFuncCall.oSource) + "."  + _oVarNatFunc.sConvertName + "(" + _oVarNatFunc.sAddToParam + _sParm.substring(2) +  ")", _oNativeFuncCall.oSource);	
					}
				//break;
				
				
				
				case EuVarType._ExtendFuncCall  //FuncCall with param
				| EuVarType._FuncCall : //FuncCall with param

					
					var _oVarFuncCall : FuncCall = cast(_oVar);
					var _oVarFunc : SFunction = _oVarFuncCall.oFunction;
					var _sFcName : String = _oVarFunc.sName;  
					if (_oVarFunc.bStatic) {  //Super constructor condition
						//Now with namespace
						//_sFcBefore = CppProject.sStaticPrefix;;
					}else if (_oVarFunc.bConstructor) {  //For ExtendFuncCall ONLY
						//_sFcBefore = "Ini_" + _oVarFuncCall.oFunction.oSClass.oSLib.sWriteName + "_";
						_sFcName =  "c" + _oVarFuncCall.oFunction.oSClass.sName  + "::"+ Setting.sConstructorKeyword;
					}
					/*
					if (_oVarFuncCall.bInline) {
						return "InlineFunc";
					}*/
					return   checkVarConvertIn(_oVarFunc.oReturn, _oConvertIn,  _sFcName + "(" +  convertFuncCallParam(_oVarFuncCall) + ")", _oContainer);
					
						//_sName = convertVarToString("directName",   _aSelectedVar[cVarListName]);
		
				//break;
				
				
						
				case EuVarType._This :
					return checkVarConvertIn(_oVar, _oConvertIn,  "this", _oContainer);
				//break;
				case EuVarType._Parent :
					return checkVarConvertIn(_oVar, _oConvertIn,  "parent.get()", _oContainer);
				//break;
				case EuVarType._Thread :
					return checkVarConvertIn(_oVar, _oConvertIn,  "thread", _oContainer);
				//break;
				
				
				case EuVarType._CallClass :
				
					var _oVarCallClass : VarCallClass = cast(_oVar);	
					var _sEnd:String = "";
						
					///////////////// Debug ONLY //////////////
				
					if(_oVarCallClass.oSBloc.oSClass.oSProject.bAddDebugUndefObjTest){
						if (_oContainer != null) {
							if (_oContainer.eType == EuVarType._LineLoc) {
								var _oLineLoc : LineLoc = cast(_oContainer);
								if(!_oLineLoc.bLast){
									var _oSClassLoc : SClass = _oVarCallClass.oCallRef.oSClass;
									_oLineLoc.sBefore = "((" +  _oSClassLoc.oSLib.sWriteName + "_" +   _oSClassLoc.sName + "*)c_e(" + _oLineLoc.sBefore;
									_sEnd = "))";
								}
							}
						}
					}
					//////////////////////////////////////////
					var _sName : String = _oVarCallClass.sName;
					if (!_oVarCallClass.bScopeOwner) {
						/* Keep same name finally
						if (_sName.charAt(1) == "o") {
							_sName = "_op" + _sName.substr(2);
						}*/
					}
					
					return   checkVarConvertIn(_oVarCallClass, _oConvertIn,  _sName, _oContainer) + _sEnd;
					/*
					if(_oConvertIn != null){
					return  _oConvertIn.eType + checkVarConvertIn(_oVarCallClass, _oConvertIn,  _oVarCallClass.sName) + _sEnd;
					}else {
						return "!" + checkVarConvertIn(_oVarCallClass, _oConvertIn,  _oVarCallClass.sName) + _sEnd;
					}*/
				//break;
				
				case EuVarType._New :
					
					var _oVarNew : VarNew = cast(_oVar);	
					//return "gzSp<" + convertCppVarType(_oVarNew.oNewRef, _nLineNum) + ">(new " + convertCppVarType(_oVarNew.oNewRef, _nLineNum) + "(" + convertFuncCallParam(_oVarNew)  + ") )";
					
					
					if (_oVarNew.oNewRef.eType == EuVarType._StaticClass && cast(_oVarNew.oNewRef, VarStaticClass).oRefClass.bIsPod ){
						var _sParam : String = convertFuncCallParam(_oVarNew);
					
						
						//Embed -> (gzEmbed)//	return convertCppVarType(_oVarNew.oNewRef, _nLineNum, false, null, _oVarNew) + "::c"  +   cast(_oVarNew.oNewRef, VarStaticClass).oRefClass.sName  + "(" + _sParam + ")";
						//return "new " + convertCppVarType(_oVarNew.oNewRef, _nLineNum, false, null, _oVarNew) + "::c"  +   cast(_oVarNew.oNewRef, VarStaticClass).oRefClass.sName  + "(" + _sParam + ")";
						if (_sParam > "") {
							_sParam = ", " + _sParam;
						}
						return  convertCppVarType(_oVarNew.oNewRef, _nLineNum,false,null,_oVarNew) +  "::New(this" + _sParam + ")";
					}
					
					if (_oVarNew.oNewRef.eType == EuVarType._StaticClass && cast(_oVarNew.oNewRef, VarStaticClass).oRefClass.bIsVector ){
						var _sParam : String = convertFuncCallParam(_oVarNew);
						return convertCppVarType(_oVarNew.oNewRef, _nLineNum, false, null, _oVarNew) + "::New<"  +   TypeText.typeToCPP(_oVarNew.oTemplateVar)   + ">({" + _sParam + "})";
					}

					if(_oVarNew.oNewRef.eType == EuVarType._StaticClass && cast(_oVarNew.oNewRef,VarStaticClass).oRefClass.bThread ){
						return  convertCppVarType(_oVarNew.oNewRef, _nLineNum,false,null,_oVarNew) + "::NewThread(this)";
					}else { //Normal
						//if(_oVarNew.oSBloc.eType == EuVarType._LineInput || _oVarNew.oSBloc.eType == EuVarType ){
						var _sParam : String = convertFuncCallParam(_oVarNew);
						if (_sParam > "") {
							_sParam = ", " + _sParam;
						}
						
						if (_oConvertIn.eType == EuVarType._CallClass && !cast(_oConvertIn,VarCallClass).bScopeOwner) {
							return  convertCppVarType(_oVarNew.oNewRef, _nLineNum,false,null,_oVarNew) + "::Get(thread)->New(this" + _sParam  + ").get()";//this is temp
						}else {
							return  convertCppVarType(_oVarNew.oNewRef, _nLineNum,false,null,_oVarNew) +  "::Get(thread)->New(this" + _sParam + ")"; //this is temp
						}
						
						
					}
					//return  checkVarConvertIn(_oVarCallClass, _oConvertIn,  _oVarCallClass.sName);
					
				//break;
				
				
				case EuVarType._ExClass :
					var _oVarExClass: VarExClass = cast(_oVar);
					return _oVarExClass.getCppName();
					
				//break;
		
			
				
				case EuVarType._Null :
					return  checkVarConvertIn(_oVar, _oConvertIn,  "GZ_NullObj", _oContainer);
				//break;
				
				
				case EuVarType._UseEnum :
					var _oUseEnum : EnumObj = cast(_oVar,UseEnum).oEnum;
					return _oUseEnum.getCppName() + "::";
				//break;
				case EuVarType._Enum :
					var _oEnum : EnumObj = cast(_oVar);
					//return checkVarConvertIn(_oVar, _oConvertIn, _oVarHold.sName);
					if (_oContainer != null && _oContainer.eType == EuVarType._LineLoc && cast(cast(_oContainer,LineLoc).aVarList[0],VarObj).eType == EuVarType._StaticClass ) { 
						return _oEnum.sName + "::";
					}
					return _oEnum.getCppName() + "::";
				//break;
				
				case EuVarType._HoldEnum :
					
					var _oVarHold : VarHoldEnum = cast(_oVar);
					return checkVarConvertIn(_oVar, _oConvertIn, _oVarHold.sName, _oContainer);
					
				//break;
				
				case EuVarType._RtuMap
				| EuVarType._Rtu :
					
					var _oVarRtu : VarRtu = cast(_oVar);
					return checkVarConvertIn(_oVar, _oConvertIn, _oVarRtu.sName, _oContainer);
					
				//break;
				
				case EuVarType._FixeArray :
					var _oVarFixeArray : VarFixeArray = cast(_oVar);
					return checkVarConvertIn(_oVar, _oConvertIn, _oVarFixeArray.sName, _oContainer);
				//break;
				
				case EuVarType._Gate :
					var _oVarGate : VarGate = cast(_oVar);
					return  checkVarConvertIn(_oVar, _oConvertIn, checkIfCurStaticLoc(_oVar, _oContainer) + _oVarGate.sName, _oContainer);
				//break;
				
				case EuVarType._Vector :
					var _oVarVec : VarVector = cast(_oVar);
					return  checkVarConvertIn(_oVar, _oConvertIn, checkIfCurStaticLoc(_oVar, _oContainer) + _oVarVec.sName, _oContainer);
				

				case EuVarType._NewArraySquare :
					var _oVarNewArraySquare : VarNewArraySquare = cast(_oVar);
					//return _oConvertIn;
					
					return TypeText.iniMemFixeArray( _oVarNewArraySquare.oIniArray, _oVarNewArraySquare.nSize, _oVarNewArraySquare.nDimReq);

				//break;
				
				
				case EuVarType._ArrayInitializer :
					var _oVarArrayInitializer : VarArrayInitializer = cast(_oVar);
					//return _oConvertIn;
					
					//return TypeText.iniMemFixeArray( _oVarNewArraySquare.oIniArray, _oVarNewArraySquare.nSize, _oVarNewArraySquare.nDimReq);
					return _oVarArrayInitializer.fToCpp();
				//break;
				
				
				
				
				case EuVarType._DataArr :
					var _oVarDataArr : VarDataArray = cast(_oVar);
					return checkVarConvertIn(_oVar, _oConvertIn,   checkIfCurStaticLoc(_oVarDataArr, _oContainer)  + _oVarDataArr.sName, _oContainer);
				//break;
				
				case EuVarType._DArray :
					var _oVarArray : VarArray = cast(_oVar);
					return checkVarConvertIn(_oVar, _oConvertIn,   checkIfCurStaticLoc(_oVarArray, _oContainer)  + _oVarArray.sName, _oContainer);
				//break;
				
				case EuVarType._QueueArray :
					var _oVarQueueArray : VarQueueArray = cast(_oVar);
					return checkVarConvertIn(_oVar, _oConvertIn,  checkIfCurStaticLoc(_oVarQueueArray, _oContainer)  +  _oVarQueueArray.sName, _oContainer);
				//break;

				case EuVarType._QElement :
					var _oVarQElement : VarQElement = cast(_oVar);
					var _sQueueElement : String = _oVarQElement.sName;
					/*
					if (_oConvertIn != null && _oConvertIn.eType !=  EuVarType._None && _oConvertIn.eType != EuVarType._QElement) {
						_sQueueElement += "->Val";
					}*/
					
					return checkVarConvertIn(_oVar, _oConvertIn, _sQueueElement, _oContainer);
				//break;
				
				case EuVarType._LineArray :
				
					return  checkVarConvertIn(cast(_oVar,LineArray).oResultingType, _oConvertIn,  convertLineArray( cast(_oVar,LineArray), null, _oContainer ) , _oContainer); ///NOT SURE FOR _oConvertIn of array
					//return convertLineArray( LineArray(_oVar), _oConvertIn, _oContainer ) ); // BEFORE
				//break;
				
					
				case EuVarType._VarInc :	
					var _oVarInc : VarInc = cast(_oVar);	
					return  convertCppVarType(_oVarInc.oVar, _oVarInc.nLine )  + "++";
				//break;
				
				
				case EuVarType._VarDec :	
					var _oVarDec : VarDec = cast(_oVar);	
					return  convertCppVarType(_oVarDec.oVar, _oVarDec.nLine )  + "--";
				//break;
				
				case EuVarType._StaticClass :
					var _oVarStaticClass : VarStaticClass = cast(_oVar);
					/*
					var _sNamspace : String = "::";
					if (_oNextVar != null && _oNextVar.eType == EuVarType._FuncCall && FuncCall(_oNextVar).oFunction.eFuncType == EuFuncType.Macro) {
						_sNamspace = "_";
					}
					return _oVarStaticClass.oImport.oSLib.sWriteName + _sNamspace +  _oVarStaticClass.sName;*/
				
					if (_oNextVar != null && _oNextVar.eType == EuVarType._FuncCall && cast(cast(_oNextVar,FuncCall).oFunction,SFunction).eFuncType == EuFuncType.Pure) {
						return _oVarStaticClass.oRefClass.sNsAccess +  "p"  + _oVarStaticClass.sName  ; //TODO "p" not for var
					}
					
					 //Auto singleton
					//if (_oContainer == null && _oNextVar == null && _oConvertIn == null ) {
					if (_oContainer != null && _oContainer.eType == EuVarType._LineInput && _oNextVar == null && _oConvertIn == null ) {
						return _oVarStaticClass.oRefClass.sNsAccess +  _oVarStaticClass.sName + "::SetInst(thread)";
					}
					
					return _oVarStaticClass.oRefClass.sNsAccess +  _oVarStaticClass.sName;
				

				//break;
				
				case EuVarType._Delegate :
					var _oDelegate : Delegate = cast(_oVar);	
					return checkVarConvertIn(_oVar, _oConvertIn, _oDelegate.sName, _oContainer);
				
				//break;
				
					
				case EuVarType._PtrFunc :
					var _oPtrFunc : PtrFunc = cast(_oVar);	
					//return ", " + "&" + _oPtrFunc.oPtrClass.oSLib.sName + "_" +  _oPtrFunc.oPtrClass.sName + "::" + _oPtrFunc.oFunc.sName; //Bind version 
					//Void* nDelagate = dref_FuncName;//New delegate -> ptr sur callback
					
					 //GZ::Attribute::Dlg_fRotationOrder1_r_Void_p_No::Dlg(this, & GZ::cAttribute::wRotationOrder2); //TODO
					// GZ::Dlg_r_Void_p_::Dlg(this, & GZ::cAttribute::wRotationOrder2).get();
					
				//	 return  _oPtrFunc.oPtrClass.oSLib.sName + "::Dlg" + _oPtrFunc.oFunc.getDelegateString() + "::Dlg(this, &" + _oPtrFunc.oPtrClass.oSLib.sName + "::c" +  _oPtrFunc.oPtrClass.sName + "::w" + _oPtrFunc.oFunc.sName.substr(1) + ")";
					// return  _oPtrFunc.oPtrClass.oSLib.sWriteName +"::"+ _oPtrFunc.oPtrClass.sName + "::Dlg" + _oPtrFunc.oFunc.getDelegateString() + "::Dlg(this, &" + _oPtrFunc.oPtrClass.oSLib.sName + "::c" +  _oPtrFunc.oPtrClass.sName + "::w" + _oPtrFunc.oFunc.sName.substr(1) + ")";
					 return  _oPtrFunc.oPtrClass.oSLib.sWriteName +"::"+ _oPtrFunc.oPtrClass.sName  + "::Dlg" + "_" + _oPtrFunc.oFunc.oSFunction.sName + _oPtrFunc.oFunc.getDelegateString() + "::Dlg(this, &" + _oPtrFunc.oPtrClass.oSLib.sWriteName + "::c" +  _oPtrFunc.oPtrClass.sName + "::w" + _oPtrFunc.oFunc.sName.substr(1) + ")";
					// return  "Lib_GZ::Dlg" + _oPtrFunc.oFunc.getDelegateString() + "::Dlg(this, &" + _oPtrFunc.oPtrClass.oSLib.sName + "::c" +  _oPtrFunc.oPtrClass.sName + "::w" + _oPtrFunc.oFunc.sName.substr(1) + ")";
				//break;
				
				case EuVarType._CallDelgate :
				//return CallCF(_oVar).oVarCallFunc.sName + "()";
					// ((((SimaCode_Delegate::_dStr_r_Void_p_No*)nDelagate)->oClass)->*((SimaCode_Delegate::_dStr_r_Void_p_No*)nDelagate)->fCall)();
					var _oCallDelegate : CallDelegate = cast(_oVar);
					
					//var _sDelClass : String =  _oCallDelegate.oDelegate.oSBloc.oSClass.oSProject.oSDelegate.sLib_Name;
					//var _sStruct : String = "(" + _sDelClass + "::" + HDelegateFile.sPrefix + "Str" +  _oCallDelegate.oDelegate.sDelegateString + "*)" 
					var _sStruct : String = "(" +  HDelegateFile.sPrefix + "Str" +  _oCallDelegate.oDelegate.sDelegateString + "*)" ;
				
					return _oCallDelegate.oDelegate.sName  + ".fCall("  +  convertFuncCallParam(_oCallDelegate) + ")";
				//break;
			
					
				case EuVarType._SNatAttribut :
					var _oVarNatAttribut : SNatAttribut = cast(_oVar);	
					//return _oVarNatAttribut.sConvertName;	
					
					return  checkVarConvertIn(_oVarNatAttribut, _oConvertIn, _oVarNatAttribut.sConvertName, _oContainer);	
					//return  checkVarConvertIn(_oVarNatAttribut, _oVarNatAttribut.oAttType, _oVarNatAttribut.sConvertName);	
				
				//break;
				
				
			
				case EuVarType._ExtendVar : 
					return 	convertCppVarType(cast(_oVar,ExtendVar).oVar, _nLineNum, _bPriority, _oConvertIn, _oContainer);
				//break;
				
				
				case EuVarType._EaseOut : 
					var _oEasing : EaseOut = cast(_oVar);
					return "ua_" +  _oEasing.oAssociate.sName + ")";
				//break;
				
				
				case EuVarType._CastTypeDef : 
					var _oCastTypeDef : CastTypeDef = cast(_oVar);
					return _oCastTypeDef.oTypeDef.sName + "(" + convertCppVarType(_oCastTypeDef.oVar, _nLineNum)   + ")" ;
				//break;
				
				/*
				case EuVarType._NativeFunc :
					var _oNative : VarNativeFunc = VarNativeFunc(_oVar);
					return _oNative.sConvertName + "()";
				break;*/
						
				case EuVarType._Comment : 
					var _oComment : VarComment = cast(_oVar);
					return "//" + _oComment.sComment;
				//break;
				
				case EuVarType._CppLine :
					var _oCppLine : VarCppLine = cast(_oVar);
					
					switch(_oCppLine.eCppType) {
						case EuCppLineType.Glsl:
							
							return  _oCppLine.oBalise.sParam + "->fAddLine(gzU8(\"" + _oCppLine.sCppLine + "\"));";
							//return  "\"" + _oCppLine.sCppLine + "\\n\"";
						//break;
						
						default:
							return _oCppLine.sCppLine;
						//break;
					}
					
				//break;
			/*
				case EuVarType._Balise :
					var _oBalise : ScopeBalise = ScopeBalise(_oVar);
					switch(_oBalise.eBaliseLang) {
						case EuBaliseLang.Glsl:
							
							return "//Tag Glsl"
							
						//break;
						
						default:
							return "//Tag " + _oBalise.sBaliseName;
						//break;	
					}
				break;*/
				default:
			}
			
			Debug.fFatal("ErrorVarType:" +  _oVar.eType);

			return "ErrorVarType:" +  _oVar.eType;
		}
		
		
		private static function convertLineArray( _oLineArray : LineArray, _oConvertIn : VarObj, _oContainer:VarObj) :String {
			
			var _sFunc : String = "";
			var _sBefore : String = "";
			var _sArray : String = checkVarConvertIn(_oLineArray, _oConvertIn, _oLineArray.oArray.sName, _oContainer);
			var _aVarList :Array<Dynamic> = _oLineArray.aVarList;
			
			
			///////////FIXE ARRAY///////////
		//	if (_oLineArray.oArray.eType == EuVarType._FixeArray) {
				var _j:UInt = _aVarList.length;
				for (j in 0 ..._j){
					var _oFixeSquare : VarObj  =  _aVarList[j];
					if ((j == _aVarList.length - 1  && _oLineArray.oArray.eType != EuVarType._FixeArray) &&  (_oContainer == null || _oContainer.eType != EuVarType._LineInput)) {
						//Reading operation
						_sArray +=  "(" + convertCppVarType(_oFixeSquare, _oLineArray.nLine, false,  _oLineArray.aConvertInTypeList[j]) + ")" ;
					
					}else{
						//Writing operation
						_sArray +=  "[" + convertCppVarType(_oFixeSquare, _oLineArray.nLine, false,  _oLineArray.aConvertInTypeList[j]) + "]" ;
						//if (_oContainer != null) {_oContainer.fGetType(); }
					}
					
				}
				return _sArray;
				
		//	}
			/////////////////////////////////
			
			
			
			
			
		//	return _sArray;
			
			/*
			var _sPrefix : String;
			var _sPrefixPtr : String;
			if (_oLineArray.bWrite) {
				_sPrefix = "GZ_tAw_";
				_sPrefixPtr  =  "*GZ_tAw_";
			}else {
				_sPrefix = "GZ_tAr_"
				_sPrefixPtr  =  "GZ_tAr_";
			}
			
			
			var _nLast : UInt = _oLineArray.nDimCount - 1;
			var _i:UInt = _aVarList.length;
			for (i in 0 ...  _i){
				var _oSquare : VarObj  =  _aVarList[i];
				
				if(i == _nLast){
					switch(_oLineArray.oResultingType.eType) {
						case EuVarType._Unit: 
							var _oUnit:UnitObj = UnitObj(_oLineArray.oResultingType);
							_sFunc = "tAw_" + _oUnit.sName;
							//_sFunc = _sPrefix + _oUnit.sName;
						//break;
						
						case EuVarType._Rtu:
							_sFunc = "GZ_tAw_sssss";
						//break;
						
						case  EuVarType._SClass:
							_sFunc = "GZ_tAw_Class"
						//break;
						
						case EuVarType._Int:
							_sFunc = _sPrefixPtr + "Int";
						//break;

						default:
							_sFunc =  _sPrefixPtr + "Ptr"
						//break;
					}
				}else {
					///////L'avant dernier doit etre converti en sont type de base pour le non ArrayPtr
					var _sConvResultType : String = "";
					if (i == _nLast -1 ) { //Not 100% sure but seem work
						switch(_oLineArray.oResultingType.eType) {
							case EuVarType._Int: 
								_sConvResultType = "(ArrayInt*)";
							//break;
						}
						
					}
					//////////////////////////////////////////////////////////////////////////
					
					_sFunc = _sConvResultType +  "GZ_tAr_Ptr";
					//_sFunc = _sPrefix + "ptr";
				}
				
				//_sSquares += "->array[" +  convertCppVarType(_oSquare, _oLineArray.nLine )  + "]";
				_sArray +=   ", " + convertCppVarType(_oSquare, _oLineArray.nLine ) + ")";
				_sBefore = _sFunc + "(" +  _sBefore;
				//If base array like Arrayint  we we moste cast the ArrayArray in Arrayint for prec last
			}
			
			if (_oContainer != null) {
				if(_oContainer.eType == EuVarType._LineLoc){
					var _oLineLoc : LineLoc = LineLoc(_oContainer);
					_oLineLoc.sBefore = _sBefore + _oLineLoc.sBefore;
					_sBefore = "";
				}
			}
			*/
			//If array contain a Class or rtu cast apply on last
			//Debug.trac(_oLineArray.oArray.sName + " : " +  _oLineArray.oResultingType.eType + " : "  + _oLineArray.nDimReq);
			
			/*
			switch(_oLineArray.oResultingType.eType) {
				case EuVarType._Unit: 
					var _oUnit:UnitObj = UnitObj(_oLineArray.oResultingType);
					
					_sCast += "((" + _oUnit.sName + "*)"
					_sSquares += ")";
				//break;
				
				case EuVarType._Rtu:
				_sCast += "sssss";
				//break;
				
				case  EuVarType._SClass:
					_sCast += "((Class*)"
					_sSquares += ")";
				//break;
			}*/
			
			//return  _sBefore +  _sArray;
		}
		
		/* I CHANGE THE STATIC ARRAY FOR DYNAMIC MAYBE UTILE FOR STATIC :
		 * 	private static function convertLineArray( _oLineArray : LineArray, _oConvertIn : VarObj ) :String {
			
			var _sCast : String = "";
			var _sSquares : String = "";
			var _aVarList :Array<Dynamic> = _oLineArray.aVarList;
			var _i:UInt = _aVarList.length;
			for (i in 0 ...  _i){
				var _oSquare : VarObj  =  _aVarList[i];
				_sSquares += "->array[" +  convertCppVarType(_oSquare, _oLineArray.nLine )  + "]";
				
				//If base array like Arrayint  we we moste cast the ArrayArray in Arrayint for prec last
			}
			
			//If array contain a Class or rtu cast apply on last
			Debug.trace2(_oLineArray.oArray.sName + " : " +  _oLineArray.oResultingType.eType + " : "  + _oLineArray.nDimReq);
			
			switch(_oLineArray.oResultingType.eType) {
				case EuVarType._Unit: 
					var _oUnit:UnitObj = UnitObj(_oLineArray.oResultingType);
					
					_sCast += "((" + _oUnit.sName + "*)"
					_sSquares += ")";
				//break;
				
				case EuVarType._Rtu:
				_sCast += "sssss";
				//break;
				
				case  EuVarType._SClass:
					_sCast += "((Class*)"
					_sSquares += ")";
				//break;
			}
			
			return _sCast + checkVarConvertIn(_oLineArray, _oConvertIn, _oLineArray.oArray.sName)  + _sSquares;
		}
		*/
		
		public static function checkIfCurStaticLoc(_oVar:VarObj, _oContainer:VarObj):String {
			
			//if (_oContainer == null && cast(_oVar,CommonVar).eLocation == EuLocation.Static || cast(_oVar,CommonVar).eLocation == EuLocation.Atomic ) {
			if (cast(_oVar,CommonVar).eLocation == EuLocation.Static || cast(_oVar,CommonVar).eLocation == EuLocation.Atomic ) {

				var _oCommon : CommonVar = cast(_oVar);

				if ((_oCommon.eConstant == EuConstant.Constant || _oCommon.eLocation == EuLocation.Atomic)) {
						if (Std.is(_oContainer, ExtendVar) ){
							var _oExtClass : SClass = cast(_oContainer, ExtendVar).oClassExtend;
							return  _oExtClass.sNsAccess  + _oExtClass.sName + "::";	
						}
						if(Std.is(_oContainer, SFunction) ){
							return "_::";				
						}else{
							return "";
						}
				}

				
				if (_oCommon.oSBloc.oSFunction != null && _oCommon.oSBloc.oSFunction.bStatic ) {
					return "";
				}
				
				if(Std.is(_oContainer, SFunction) ){
				//else{
				//	return "_::Get(thread)->" ;
					return "_::GetInst(thread)->" ;
				}
			}
			return "";
		}
		
		public static function checkVarConvertIn(_oResultingType:VarObj, _oConvertIn : VarObj, _sVar:String, _oContainer:VarObj = null):String {
			
		
			
			
			
			/*
			if (TypeResolve.isVarCommon(_oVar)) {
				if (CommonVar(_oVar).eLocation == EuLocation.NativeAttribut ) {
					_sVar = CommonVar(_oVar).sIniInString; //sIniInString to same one var is the second name ones converted
				}
			}*/
			
			if (_oConvertIn == null ) {
				return  _sVar;
			}
			
			/*
			if ( _oConvertIn.eType == EuVarType._None || _oConvertIn.eType == EuVarType._String) {
				return  _sVar;
			}*/
			if ( _oConvertIn.eType == EuVarType._None ) {
				return  _sVar;
			}
			
			//return TypeText.typeToCPP(_oConvertIn) +  "(" + _sVar + ")";	
			return TypeText.getConvertFunc(_sVar, _oConvertIn, _oResultingType , null, _oContainer);	 //Todo check if better way than TypeResolve.getResultingType
		}
		
		
		public static var sMakeInputVarString_After : String; //Second return, needed for itelli ptr
		private static function makeInputVarString(_oLineInput:LineInput):String {
			//Get main var
			sMakeInputVarString_After = "";//Second return, always must be reseted
			var _sInputVarString : String = convertCppVarType(_oLineInput.oVarInput, 0, false, null,_oLineInput); //line before =
			//var _sInputVarString : String = convertCppVarType(_oLineInput.oVarInput, 0, false, null,null); //line before =
			
	
			/////// Intelli PTR ////////////
			switch (_oLineInput.oResultingType.eType) {
				//case EuVarType._Rtu :
				case EuVarType._QElement : //Special case for Qelement to RTU
					if(_oLineInput.oConvertInType.eType == EuVarType._Unit){ //Not sure but work
						sMakeInputVarString_After = ";  m_IPtrAdd(" + _sInputVarString + ", " + cast(_oLineInput.oConvertInType,UnitObj).sName +")";
						if (!_oLineInput.bVarCreation ) { //Else sMakeInputVarString_After will be added for var creation
							return "GZ_mIPtrU(" + _sInputVarString + ", " + cast(_oLineInput.oConvertInType,UnitObj).sName + ")";
						}
					}
				//break;	
					
				case EuVarType._Unit :
					if(_oLineInput.oConvertInType.eType != EuVarType._QElement){ //Not sure but work
						if( !cast(_oLineInput.oResultingType,UnitObj).oSClass.oSLib.bReadOnly){ //Not for libcpp
							//sMakeInputVarString_After = ";  (" + UnitObj(_oLineInput.oConvertInType).sName +"*)(" + _sInputVarString + ")->nNbIns++";
							sMakeInputVarString_After = ";  GZ_mIPtrAdd(" + _sInputVarString + ", " + cast(_oLineInput.oResultingType,UnitObj).sName +")";
							if (!_oLineInput.bVarCreation ) { //Else sMakeInputVarString_After will be added for var creation
								return "GZ_mIPtrU(" + _sInputVarString + ", " + cast(_oLineInput.oResultingType,UnitObj).sName + ")";
							}
						}
					}
				//break;
				default:
			}
			////////////////////////////////
			
			if (_oLineInput.bVarCreation) { //TODO Normaly only one var 
				//createSpecialVar(_oFile, _oLineInput.oVarInput); //RETHINK String doesn need it
				//if(!CommonVar(_oLineInput.oVarInput).bSpecial){  //Only non special var  //RETHINK String must have it
				
					_sInputVarString =  TypeText.typeToCPP(_oLineInput.oVarInput) + " " + _sInputVarString;

				//}
			}
					
				
			/*
			switch (_oLineInput.eDominantType) {
				case EuVarType._String :
					
				//break;
			}
			*/
			return  _sInputVarString;
		}
		
		

		
		public static function convertLineToCpp(_oLine : LineObj, _oContainer:VarObj = null):String {
					

			ExtractBlocs.nCurrLine = _oLine.nLine;
			

			if (_oLine == null) {
				
				Debug.fError("Error , convertLineToCpp()  Line is null");
				Debug.fStop();
				return "";
			}
			//No var list return null
			if (_oLine.aVarList.length == 0) {
				return "";
			}
			
			
			
			var _sName : String;
			
			var _aOpList : Array<Dynamic> = _oLine.aOpList;
			var _aVarList : Array<Dynamic> = _oLine.aVarList;
			var _aConvertInTypeList : Array<Dynamic> =  _oLine.aConvertInTypeList;
			
			
			var _sLine : String = "";
			var _nLineNum : UInt = _oLine.nLine;
			
			var _nSousIndex : Int;
			var _bConcatDone : Bool = false;
			
			
			//make first var
			var _i:UInt = _aVarList.length;
			for (i in 0 ...  _i){
				
				//////////////////// Concatenation //////////////////
				if (i == 0) {
					if (_aOpList[i] == EuOperator.Concat) { //First concatenation
						_bConcatDone = true;
						_sName = convertCppVarType(_aVarList[i], _nLineNum, false, _aConvertInTypeList[i], _oContainer);
				
						//_sLine = TypeText.getConvertFunc(_sName, _oLine.oResultingType, _oLine.aResultTypeList[i] );  //First var  REALLY NOT SUR TO REMOVE THIS
						_sLine = _sName; //REALLY NOT SUR TO CHANGE THIS
					}
					
				}else {
					if (_aOpList[i - 1] == EuOperator.Concat) { //Autre concat
							_bConcatDone = true;
			
							_sName = convertCppVarType(_aVarList[i], _nLineNum, false, _aConvertInTypeList[i], _oContainer);
							
							//var _sSecondPart : String = TypeText.getConvertFunc(_sName, _oLine.oResultingType, _oLine.aResultTypeList[i] ); 
							var _sSecondPart : String = _sName;
							
							var _sConcatFonc : String = TypeText.getContatAddFunc(_oLine.oResultingType, _oLine.aResultTypeList[i]);
							_sLine =   _sConcatFonc +  "(" + _sLine + ", " + _sSecondPart + ")";
							
					}
				}
				//////////////////////////////////////////////////
				
				
				if (!_bConcatDone) { //Special case for concat
					
					_sName = convertCppVarType(_aVarList[i], _nLineNum, true, _aConvertInTypeList[i], _oContainer);
					
					if (_aOpList[i] != null) { //TODO EuOperator.NONE??
						
							_sLine += _sName + " " +  TypeText.opToString(_aOpList[i]) + " ";
					}else {
						
						_sLine += _sName; //end?   //for [ .
					}
				}
						
			}

			return _sLine;
		}
		
		
		private static function convertLineLoc(_oLineLoc : LineLoc):String {
			ExtractBlocs.nCurrLine = _oLineLoc.nLine;
			
			var _aVarList  : Array<Dynamic> = _oLineLoc.aVarList;
			var _sReturn :  String = "";
			var _aConvertInTypeList : Array<Dynamic> = _oLineLoc.aConvertInTypeList;
			
			var _bBefStaticClass:Bool = false;
			var _sCast:String = "";
			var _sFunc:String = "";
			var _nEndIndex : Int;
			var _oVar : VarObj = EuVar.VarNone;//CW not sure
			_oLineLoc.sBefore = "";
			_oLineLoc.bLast = false;
			var _i:UInt = _aVarList.length;
			var _bNoNameSpace : Bool = false;
			var _oNextVar : VarObj;
			for (i in 0 ...  _i) {
				_bNoNameSpace = false;
				if (i != 0) {
					
					var _oRealVar : VarObj = _oVar;
					if (_oRealVar.eType == EuVarType._ExtendVar){
						_oRealVar = cast(_oVar, ExtendVar ).oVar;
					}
					
					
					if (_oVar.eType == EuVarType._StaticClass) { //Must be firts var also
						 _oNextVar  = _aVarList[i];
						if ( (TypeResolve.isVarCommon( _oNextVar) && cast(_oNextVar,CommonVar ).eConstant == EuConstant.Macro ) 
							|| ( _oNextVar.eType == EuVarType._FuncCall && cast(_oNextVar,FuncCall).oFunction.eFuncType == EuFuncType.Macro )
						){ //Macro are sepcial they not need ::
							_sReturn += "_";
							_bNoNameSpace = true;
						}else if(_oNextVar.eType == EuVarType._FuncCall && cast(_oNextVar,FuncCall).oFunction.eFuncType == EuFuncType.Pure){
								_sReturn += "::";
						}else {
							if (_oNextVar.eType == EuVarType._Enum || (TypeResolve.isVarCommon( _oNextVar) && cast(_oNextVar,CommonVar ).eConstant == EuConstant.Constant)  || (Std.is(_oNextVar,CommonVar) && cast(_oNextVar,CommonVar ).eLocation == EuLocation.Atomic)  )  {
								_sReturn += "::"  ; //Normal
							}else{
								//_sReturn += "::"  ; //Normal
								//_sReturn += "->" ; //??
								//_sReturn += "::Get(thread)->";
								if ( (TypeResolve.isVarCommon( _oNextVar) && cast(_oNextVar,CommonVar ).bStatic)){
									_sReturn += "::Get(thread)->";
								}else{
								//	_sReturn += "::GetInst(thread)->" + "|"+ TypeResolve.isVarCommon( _oNextVar) +"|" +  _oNextVar.fGetName() +"|" ; 
									_sReturn += "::GetInst(thread)->"; 
								}
							
								
							}
						}
						
						
						_bBefStaticClass = true;
					}else if (_oVar.eType == EuVarType._Enum || _oVar.eType == EuVarType._UseEnum || _oVar.eType == EuVarType._ExClass ) {
						_sReturn += "";
					}else if ( (_oRealVar.eType == EuVarType._CallClass && (cast(_oRealVar, VarCallClass ).oCallRef.bIsVector || cast(_oRealVar, VarCallClass ).oCallRef.bIsResults ) )  
					||  _oVar.eType == EuVarType._Vector || _oVar.eType == EuVarType._String ||  _oVar.eType == EuVarType._DArray ||  _oVar.eType == EuVarType._QElement ||  _oVar.eType == EuVarType._Gate) {	//SNatAttribute?
						_sReturn += "."; 
					}else {
						_sReturn += "->";
					}
				}
				if (i == _i - 1) {
					_oLineLoc.bLast = true;
				}
				
				_oVar = _aVarList[i];
				if (i + 1 < _i) {
					 _oNextVar = _aVarList[i + 1];
				}else {
					_oNextVar = null;
				}
				var _sName : String = convertCppVarType(_oVar, _oLineLoc.nLine, true, _aConvertInTypeList[i], _oLineLoc, _oNextVar); //
				
				//CPP Special Case for static function
				//Change fonction name and remove class like Math.h sin(), remove LibCpp_Math:: and change fSin name 
				if (_bBefStaticClass) {
					_bBefStaticClass = false;
					var _oFunc : SFunction = null;
					if (_oVar.eType == EuVarType._Function ) {
						_oFunc = cast(_oVar,SFunction);
					}
					if (_oVar.eType == EuVarType._FuncCall ) {
						_oFunc = cast(_oVar,FuncCall).oFunction;
					}
					if(_oFunc != null){
						if (_oFunc.bRemoveStaticClass) {
							_sReturn = "";
						}
						if (_oFunc.bConvNewName) {
							var _sRealName : String = Text.between3(_sName, 0,EuBetween.Word); //To Reget the priority
							var _sPriority : String = _sName.substring(_sRealName.length, _sName.length); //Reget the priority
							_sName = _oFunc.sConvNewName + _sPriority ;
						}
					}
				}
				
				
				/*
				/////////////// REORDER CAST AND FUNC /////////////////////////////////
				//Detect cast
				if (_sName.charAt(0) == "(") { //( is obligatory a cast in a Lineloc, put it before
					 _nEndIndex  = Text.search(_sName, ")") + 1;
					_sCast =  _sName.substring(0, _nEndIndex) + _sCast;
					_sName =  _sName.substring(_nEndIndex );
				}
				//Detect array function 
				if (_sName.charAt(0) == "*" || _sName.charAt(0) == "a") { //Maybe more specefic
					/////////Find very last function index to put all before ////////////
					_nEndIndex  = Text.search(_sName, "(") + 1;
					var _nSearchIndex : UInt = _nEndIndex;
					while ( _nSearchIndex > 0 && (_sName.charAt(_nSearchIndex) == "*" || _sName.charAt(_nSearchIndex) == "a")  ) {  
						_nEndIndex = _nSearchIndex;
						_nSearchIndex  = Text.search(_sName, "(", _nSearchIndex) + 1;
					}
					/////////////////////////////////////////////////////////////////////
					_sFunc =  _sName.substring(0, _nEndIndex) + _sFunc;
					_sName =  _sName.substring(_nEndIndex );
				}
				/////////////////////////////////////////////////////////////////////////	
				*/
				
				if (_sName == "") {
					//Remove arrow if we have no aditionnal location (ex : to nTest.hex)
					_sReturn = _sReturn.substring(0, _sReturn.length-2);
				}else{
					_sReturn += _sName;
				}
			}
			_sCast += _oLineLoc.sBefore;
			_oLineLoc.sBefore = null;
			return _sCast + _sReturn;
		}
		
		
		
		private static function convertFuncCallParam(_oFuncCall:FuncCall, bIsFirst : Bool = true):String {
			var _sReturn : String = "";
			var _aParamList  : Array<Dynamic>  = _oFuncCall.aParamList;
			var _aConvertInList  : Array<Dynamic>  = _oFuncCall.aConvertInTypeList; 
			var _i:UInt = _aParamList.length;
			for (i in 0 ...  _i) {
				var _oConvertIn : VarObj = _aConvertInList[i];
				
				if (!bIsFirst || i != 0) {
					_sReturn += ", ";
				}
				var _oVar : VarObj = _aParamList[i];
				
				
				var _sLine : String = convertCppVarType(_oVar, _oFuncCall.nLineNum, false ,  _oConvertIn);
				/*
				if (_bForceCast && _oConvertIn.eType == EuVarType._None) {
					_oConvertIn = _oVar;
				}*/
				
				//_sReturn  +=  TypeText.getConvertFunc(_sLine,  _oConvertIn,  _oFuncCall.aResultTypeList[i]);
				_sReturn  +=  _sLine;
				/*
				if(_oConvertIn.eType != EuVarType._None){
					_sReturn += fGetConvertInType(_oVar,_oConvertIn) +"(" + _sLine  + ")" ;
				}else {
					_sReturn += _sLine;
				}*/
				
			}
			return _sReturn;
		}
		
		
		private static function convertSpecialVar(_oFile:CommonCpp, _oSBloc:SBloc, _oSpecialVar:CommonVar):Void {

			switch(_oSpecialVar.eType) {
				case EuVarType._String : 
					//_oFile.pushLine("");
					
				//break;
				default:
			}
		}
		
	
		
		public static function addNewRefParamIPtr(_oFile:CommonCpp,  _oSBloc:SBloc) :Void {
			var _oSFunc : SFunction = cast(_oSBloc);
			var _aVarList  : Array<Dynamic>  = _oSFunc.aAddRefParamU;
			if(_aVarList.length > 0){				
				_oFile.pushLine("//Intelli ptr RTU ini");
				var _i:UInt = _aVarList.length;
				for (i in 0 ...  _i) {
					addNewRefParamIPtrVar(_oFile, _aVarList[i]);
				}
				_oFile.addSpace();
			}
		}
		public static function subNewRefParamIPtr(_oFile:CommonCpp,  _oSBloc:SBloc) :Void {
			var _oSFunc : SFunction = cast(_oSBloc);
			var _aVarList  : Array<Dynamic>  = _oSFunc.aAddRefParamU;
			if(_aVarList.length > 0){				
				_oFile.pushLine("//Intelli ptr RTU ini");
				var _i:UInt = _aVarList.length;
				for (i in 0 ...  _i) {
					subNewRefParamIPtrVar(_oFile, _aVarList[i]);
				}
				_oFile.addSpace();
			}
		}
		public static function addNewRefParamIPtrVar(_oFile:CommonCpp,  _oVar:VarObj) :Void {
			_oFile.pushLine("GZ_mIPtrAdd(" + cast(_oVar,VarRtu).sName  + ", " + cast(_oVar,VarRtu).oUnitRef.sName + ");");
 		}

		public static function subNewRefParamIPtrVar(_oFile:CommonCpp,  _oVar:VarObj) :Void {
			_oFile.pushLine("GZ_mIPtrSub(" + cast(_oVar,VarRtu).sName  + ", " + cast(_oVar,VarRtu).oUnitRef.sName + ");");
 		}
		
		
		
		
		/*	
		dstr_int_Void* dref_FuncName; //Each function
		m_iniStructureN(dref_FuncName, dstr_int_Void);
		dref_FuncName->oClass = this;
		dref_FuncName->fCall = (dptr_int_Void)&SimaCode_Test::fTestQueueShort;
		*/
		public static function convertDelegate(_oFile:CommonCpp, _oDlg:Delegate):Void {
			
			_oFile.pushLine(_oDlg.sName + "("  + TypeText.getFuncPtrTypeIni(_oDlg, "this") + "&"  + TypeText.getFuncLocWrapper(_oDlg.oSFunc) + ")" );
			
			/*
			_oFile.pushLine("// " + _oFunc.sName);
			var _sRef : String = HDelegateFile.sPrefix  + "Ref_" +  _oFunc.sName;
			var _sStruc : String = HDelegateFile.sPrefix + "Str" + _oFunc.sDelegateString ;
			var _sPtr : String = HDelegateFile.sPrefix + "Fp" + _oFunc.sDelegateString ;
			_oFile.pushLine("GZ_mIniStructureN(" + _sRef + ", " + _sStruc + ");");
			_oFile.pushLine(_sRef + "->oClass = this;");
			_oFile.pushLine(_sRef + "->fCall = (" +  _sPtr + ")&" + _oFunc.oSClass.oSLib.sWriteName + "::" + _oFunc.oSClass.sName + "::" + _oFunc.sName + ";");
			*/
		}
		
		
		
		public static function convertSpecialVarConstructorIni(_oFile:CommonCpp,  _oSBloc:SBloc, _aVarList  : Array<Dynamic>) :Void {
			var _oSClass : SClass = _oSBloc.oSClass;
			//var _aVarList  : Array<Dynamic>  = _oSClass.aIniGlobalVarList;
			var _i:UInt = _aVarList.length;
			for (i in 0 ...  _i) {
				createSpecialVar(_oFile, _aVarList[i], _oSBloc);
			}
		}
		
		
		public static function createSpecialVar(_oFile:CommonCpp, _oVar:VarObj,  _oSBloc:SBloc, _sLoc:String = ""):Void {
			//List special var creation
			switch(_oVar.eType) {
				
				case  EuVarType._LineInputMod 
				| EuVarType._LineInput :
					convertLineType(_oFile, cast(_oVar,LineInput),_oSBloc);
					//_oFile.pushLine("LineInput");
					//createSpecialVarLineInput(_oFile, LineInput(_oVar));
				//break;
				
				case EuVarType._Rtu :
					var _oVarRtu : VarRtu = cast(_oVar);
					
					if (_sLoc != "") { //Inside Unit creation
						//_oFile.pushLine("GZ_mIniStructureN(" + _sLoc  + _oVarRtu.sName + "," + _oVarRtu.oUnitRef.sName  + ");");
						_oFile.pushLine(_sLoc + _oVarRtu.sName + " = " + _oVarRtu.oUnitRef.getCppClassDef() + "tNew_" +  _oVarRtu.oUnitRef.sName + "();");
					}else {  //Inside Class construtor Ini*/
						//_oFile.pushLine(_oVarRtu.oUnitRef.sName + "* " +  _oVarRtu.sName + " = u_" +  _oVarRtu.oUnitRef.sName + "();");
						_oFile.pushLine(  _oVarRtu.sName + " = " +  _oVarRtu.oUnitRef.getCppClassDef() + "tNew_" +  _oVarRtu.oUnitRef.sName + "();");
					}
				//break;
				
				case EuVarType._String :
					var _oVarString : VarString = cast(_oVar);
					if(_oVarString.eLocation == EuLocation.Global){
						_oFile.pushLine("//GZ_mArray_NewStringE("  + _sLoc  + _oVarString.sName + "); //Todo"); //Todo initialse var in constructor
					}else {
						_oFile.pushLine("//GZ_mArray_NewStringVE("  + _sLoc  + _oVarString.sName + "); //Todo"); //Todo initialse var in constructor
					}
				//break;

				case EuVarType._FixeArray :
					var _oVarFixeArray : VarFixeArray = cast(_oVar);
					if (_oVarFixeArray.nStartSize != 0) { //only if we have setted size
						
						_oFile.pushLine( _oVarFixeArray.sName + " = " +  TypeText.iniMemFixeArray(_oVarFixeArray, _oVarFixeArray.nStartSize, _oVarFixeArray.nDimention) + ";");
					
					}else{
						_oFile.pushLine( _oVarFixeArray.sName + " = 0;" );
					}
	
				//break;
				/*
				case EuVarType._Array<Dynamic> :
					var _oVarArray : VarArray = VarArray(_oVar);
					_oFile.pushLine(TypeText.getIniFuncSpecialVarArray(_oVarArray) + "(" + _sLoc + _oVarArray.sName + ", 10);");
				//break;
				*/
				case EuVarType._QueueArray :
				/*
					var _oVarQueueArray : VarQueueArray = VarQueueArray(_oVar);
					var _sDestructionFunction : String = "";
					var _oVarsType : VarObj = VarQueueArray(_oVar).oResultVarsType;
					switch(_oVarsType.eType) {
						case EuVarType._Unit:
							var _oUnit : UnitObj = UnitObj(_oVarsType);
							_sDestructionFunction =  _sLoc + _oVarQueueArray.sName + "->fDestruct = " + _oUnit.oSClass.oSLib.sWriteName + "::" + _oUnit.oSClass.sName + "::tDel_" + _oUnit.sName + ";";
						//break;
						
					}
					
					_oFile.pushLine("GZ_mIniStructureN(" + _sLoc + _oVarQueueArray.sName + ", "  +"QueueRoot);" + _sDestructionFunction);
				*/
				//break;
				
				case EuVarType._QElement :
					var _oVarQElement : VarQElement = cast(_oVar);
					var _sQEType : String = TypeText.getQElementType(_oVarQElement);

					_oFile.pushLine("GZ_mIniStructureN(" + _sLoc + _oVarQElement.sName + ", " +  _sQEType + ");" + _sLoc + _oVarQElement.sName + "->nType = TQ_" + _sQEType + ";"); 
	
				//break;	
				
				case EuVarType._ParamInput :
					var _oParamInput : ParamInput = cast(_oVar);
					var _sInputString : String = checkVarConvertIn( _oVar , _oParamInput.oConvertInType, convertLineToCpp(cast(_oVar,LineObj))); //Todo type resolve
					
					var _oInput : CommonVar = _oParamInput.oVarInput;
					
					_oFile.pushLine(_sLoc + _oInput.sName + " = "  + _sInputString + ";");
				//break;
				default:
				
			}
		}
		
		
		public static function destroySpecialVar(_oFile:CommonCpp, _oVar:VarObj,  _sLoc:String = ""):Void {
			//List special var creation
			switch(_oVar.eType) {
					case EuVarType._Rtu :
						var _oVarRtu : VarRtu = cast(_oVar);
						//_oFile.pushLine("u_r_" +  _oVarRtu.oUnitRef.sName + "(" + _sLoc + VarRtu(_oVar).sName + ");");
						_oFile.pushLine("GZ_mIPtrCondU(" +   _sLoc + cast(_oVar,VarRtu).sName +   ", " + _oVarRtu.oUnitRef.sName + ")");
					//break;
					
					case EuVarType._QElement :
						var _oVarQElement : VarQElement = cast(_oVar);
						var _sQEType : String = TypeText.getQElementType(_oVarQElement);
						//+ ", " +  _sQEType +
						_oFile.pushLine("GZ_fFree(" + _sLoc + _oVarQElement.sName  + ");"); 
					//break;	
					default:
			}
		}
		
		
		private static function getSpecialVarIni(_oVar:VarObj):String {
			switch (_oVar.eType) {
				case EuVarType._Rtu : 
					var _oVarRtu : VarRtu = cast(_oVar);
					return " = " + _oVarRtu.oUnitRef.getCppClassDef() + "tNew_" +  _oVarRtu.oUnitRef.sName + "()";
				//break;
				default:
			}
			return "";
		}
		
		
		private static function subBlocIntelliPtr(_oFile:CommonCpp, _oSBloc:SBloc):Void {
			var _i : Int =  _oSBloc.aVarEndSubRtuPtr.length;
			if (_i > 0) {
				for ( i in 0 ... _i) {
					var _oRtuPtr : VarRtu =  _oSBloc.aVarEndSubRtuPtr[i];
					_oFile.pushLine("GZ_mIPtrCondU(" + _oRtuPtr.sName + ", " + _oRtuPtr.oUnitRef.sName +  ")");
					
				}
			}
		}
		
		
		
		
		/*
		private static function createSpecialVarLineInput(_oFile:CommonCpp, _oLine:LineInput):Void {
			
			var _oVarInput : VarObj = _oLine.oVarInput;
			var _sLineInput : String = convertCppVarType(_oLine, _oLine.nLine); //line after =
				
			//List special var creation
			switch(_oVarInput.eType) {
				
				case EuVarType._String :
					var _oVarString : VarString = VarString(_oVarInput);
					
					var _sInputVarString : String = makeInputVarString(_oFile, _oLineInput);
					_oFile.pushLine(_sInputVarString + " = " + _sLineInput + ";");
					//_oFile.pushLine("GZ_mArray_NewStringE(" + _oVarString.sName + ");" + _sLineInput );
					//_oFile.pushLine("GZ_mArray_NewString(" + _oVarString.sName + ", " + _sLineInput +  ");");
				//break;
				
			}
		}*/
		
		
		
	}

