package language.project.convertSima ;
	import language.enumeration.EuBetween;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuOperator;
	import language.enumeration.EuStringFormat;
	import language.enumeration.EuVarType;
	import language.Text;
	import language.TextType;
	import language.vars.special.EnumObj;
	import language.vars.special.NativeFuncCall;
	import language.vars.special.SNatFunction;
	import language.vars.special.TypeDef;
	import language.vars.special.UseEnum;
	import language.vars.special.VarArray;
	import language.vars.special.VarQElement;
	import language.vars.special.VarQueueArray;
	import language.vars.varObj.CallDelegate;
	import language.vars.varObj.CastTypeDef;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.Delegate;
	import language.vars.varObj.ExtendFunc;
	import language.vars.varObj.ExtendFuncCall;
	import language.vars.varObj.ExtendVar;
	import language.vars.varObj.FuncCall;
	import language.vars.varObj.GateFunc;
	import language.vars.varObj.GateFuncCall;
	import language.vars.varObj.LineArray;
	import language.vars.varObj.LineDelete;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.LineInputMod;
	import language.vars.varObj.LineLoc;
	import language.vars.varObj.LineObj;
	import language.vars.varObj.LineReturn;
	import language.vars.varObj.LineVarIni;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.VarArrayInitializer;
	import language.vars.varObj.VarBoolean;
	import language.vars.varObj.VarCallClass;
	import language.vars.varObj.VarDec;
	import language.vars.varObj.VarExClass;
	import language.vars.varObj.VarFloat;
	import language.vars.varObj.VarHex;
	import language.vars.varObj.VarInc;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarNew;
	import language.vars.varObj.VarNewArraySquare;
	import language.vars.varObj.VarNull;
	import language.vars.varObj.VarObj;
	import language.vars.varObj.VarParent;
	import language.vars.varObj.VarRtu;
	import language.vars.varObj.VarStaticClass;
	import language.vars.varObj.VarString;
	import language.vars.varObj.VarThis;
	import language.vars.varObj.VarThread;
	import language.base.Debug;
	import haxe.io.Bytes;
import haxe.crypto.BaseCode;

	/**
	 * ...
	 * @author ...
	 */
	class ExtractLines 
	{
		

		public static function extractLine(_oSBloc: SBloc, _sLine:String, _nLineNum : UInt):VarObj {
			var _sWord : String = Text.between3(_sLine, 0,EuBetween.Word); //Todo test if sIni is empty
			return extractLineObj(_oSBloc, _sLine, _sWord, Text.nCurrentIndex, _nLineNum);
		}
		
		
		public static function fLineVar(_oSBloc: SBloc, _sLine:String, _nStartIndex:UInt,  _nLineNum : UInt, _bEmbed : Bool = false):VarObj{
			
			//Create new var
			var _sVariableName :String = Text.between3(_sLine, _nStartIndex,EuBetween.Word);//After "var"
			var _nVarEndPos: UInt = Text.nCurrentIndex;//Char pos after the var name

			var _sType : String = Text.between2(_sLine, cStartType, Text.nCurrentIndex,EuBetween.Word); //Maybe all loc "word.word"
			var _oVar : CommonVar = TypeResolve.createVarWithType(_oSBloc, _sType, _sLine, Text.nCurrentIndex);
			
			_oSBloc.pushBlocVar(_oVar); //Will Ini var at begening
			_oVar.nLine = _nLineNum;
			_oVar.sName  = _sVariableName;
			_oVar.bEmbed = _bEmbed;
			
			if (_oVar.eType == EuVarType._CallClass) { //Spécial case
				cast(_oVar,VarCallClass).bScopeOwner = true;
			}
			
			var _nIndex : Int  = Text.search(_sLine, "=", 0);
			if (_nIndex >= 0) {
				//Direct _oVar.sName -> no operator + - / etc
				return inputLine(_oSBloc, _sLine.substring(_nIndex + 1, _sLine.length), _oVar.sName, _nVarEndPos, _nLineNum, _oVar, true);
			}else {
				addIntelliPtrVar(_oSBloc, _oVar, true); //Only var creation must be delete at end of bloc
			}
			
		
			return new LineVarIni(_oSBloc, _oVar); //Just var initialistion
		}
		
		
		private static var cStartType: String = ":";
		private static var cStartSet: String = "=";
		public static function extractLineObj(_oSBloc: SBloc, _sLine:String, _sWord : String, _nStartIndex:UInt, _nLineNum : UInt):VarObj {
			var _nIndex : Int;
		
			var _oSFunction : SFunction = _oSBloc.oSFunction;
			
			switch (_sWord) {
				case "wvar" :	
				//	Debug.trace3("wvar in code?");
					Debug.fStop();
				//break;
				
				case "evar" :
					return fLineVar(_oSBloc, _sLine, _nStartIndex,_nLineNum, true);
					
				//break;
				
				case "var" :
					return fLineVar(_oSBloc, _sLine, _nStartIndex,_nLineNum);
				//break;
		
				
				case "return" : 
					//New line with type retrun
					var _sReturnLine : String = Text.between3(_sLine, _nStartIndex, EuBetween.Line);		
					var _oLineReturn : LineReturn = cast(newLineSet(_oSBloc, _sReturnLine, _nLineNum, EuVarType._LineReturn,null,false,EuOperator.None)); //Todo line type
					return _oLineReturn;
					//aCurrentBloc[cLineList].push(_nReturnId);
					
				//break;
				
				
				case"Delete" : 
					var _sDeleteLine : String = Text.between3(_sLine, _nStartIndex, EuBetween.Line);		
					var _oLineDelete : LineDelete = cast(newLineSet(_oSBloc, _sDeleteLine, _nLineNum, EuVarType._LineDelete,null,false,EuOperator.None)); //Todo line type
					return _oLineDelete;
				//break;
					
				
				
				
				/*	
				case "super" :
					//New line with type retrun
					var _sSuperLineParam : String = between3(_sLine, nCurrentIndex + 1, "Priority");
				
					var _nExtendId : UInt = aCurrentClass[cClassExtendId];
					var _nReturnSuperId : UInt = functionCall(aClass[_nExtendId][cClassName], _sSuperLineParam, _nLineNum, _nExtendId );
					aCurrentClassVar[_nReturnSuperId][cLineType] = cLTypeSuper;
					//qqqqqqqqqqqq
					//var _nReturnSuperId: UInt = newLineSet(_sSuperLineParam, _nLineNum, cLTypeSuper, 0, 0, nCurrentFuncId); 
					
					return _nReturnSuperId;
					
				//break;
				*/
				default :
					
					 _nIndex  = Text.search(_sLine, "=", 0);
					if (_nIndex >= 0) {
						//Input line
						return inputLine(_oSBloc, _sLine.substring(_nIndex + 1, _sLine.length), _sLine.substring(0, _nIndex), 0,_nLineNum);
						
					}else {
	
			
						if(Text.stringNotEmpty(_sLine)){
							///////////////////////
							///// NORMAL LINE //////	include function and all		
							return newLineSet(_oSBloc, _sLine, _nLineNum, EuVarType._Line,null,false,EuOperator.None); //Todo line type
						}else {
							//Line empty
							return EuVar.VarNone;
						}
						

					}
					
				//break;
			}
			Debug.fError("unknow line : " + _sLine);
			return null;
		}
		
		 
		private static function lineVarIncrementation(_oSBloc:SBloc, _sVar : String, _sVariable : String, _nLineNum:UInt):Void {
			
			
		}
		
		
		
		//Id lines for all class
			//0 Argument List
				//0 Arg
				//1 Type
				//2 Name
				
			//cLineOpp
			//cLineOppList
			//3 Line Type //Conditional/Sequencial	
			//4 Input - id var
			//5 Class id
			//6 Func id
			//7 Line in file 
		private static function inputLine(_oSBloc:SBloc, _sInput : String, _sVariable : String, _nVarEndPos : Int, _nLineNum:UInt, _oInputVar : VarObj = null, _bVarCreation:Bool = false ) :VarObj {
			
			if (_oInputVar == null) { //Var not already created/found, we search for it
				//var _sVar : String = between3(_sVariable, 0);
				//_nId = findVarId(_sVar);
				//_nVarEndPos = nCurrentIndex;	
				_oInputVar = newLineSet(_oSBloc, _sVariable, _nLineNum,EuVarType._None, null, true,EuOperator.None);

			}
			
			
			//Check for += -= type like j += 1;
			var _eOpType : EuOperator = TextType.operatorType( _sVariable.charAt(_sVariable.length - 1) );
			
			//Create line
			var _oLine : LineInput = cast(newLineSet(_oSBloc, _sInput, _nLineNum, EuVarType._LineInput, _oInputVar, false, _eOpType, _bVarCreation)); //Todo line type
			//_oLine.bVarCreation = _bVarCreation;
			/*
			if (_bVarCreation && _oLine.bNewCreation) { 
				addIntelliPtrVar(_oSBloc, _oInputVar);
			}*/
			////// INTELLI PTR ////////////

		
		
		//////////////////////////////
			
			
			/*
			switch(_oLine.eType) {
				
				//Check functionCalling type directcall ex: cfCall = funcCall; not cfCall = "funcCall" + "5";
				case cTypeFunction :
					simplifiDirectFunctionCalling();
				//break;
			
				case cTypeArray :
					var _sNext : String = _sVariable.charAt(_nVarEndPos);
					
					if (_sNext == "[") {//TODO Not if _bIniVar 
						//Array<Dynamic> Type
						//Remplace current var id for array var type
					
						//aCurrentLine[cLineInput] = createArrayIndex(_nId, _sVariable, _nVarEndPos);
							
						aCurrentLine[cLineInput] = newLineSet(_sVariable, 0, cTypeLine);
						
					}
		
				//break;
				
				
				case cTypeRtu :
									
					_sNext = _sVariable.charAt(_nVarEndPos);

					if (_sNext == ".") {
						
						//Create new line with linevar inside
						newLineSet(_sVariable, 0, cTypeLineRtu);
						
						//TODO maybe delete unused line
						
						//Simplifi line and realloc id to the input
						 var _nRtuLineId : UInt  = aCurrentLine[cLineVarList][0];
						aCurrentVar = aCurrentClassVar[_nRtuLineId];
						aCurrentVar[cVarListType] = cTypeLineRtu;
						
						
						aCurrentClassVar[_nLineId][cLineInput] = _nRtuLineId;
					
					}else {
						 //rtu without take a element
						//Debug.trace("Error, rtu must take a element")
						//Debug.fStop();
					}
				//break;
			}*/
			
	
			
			return cast(_oLine);
		}
		

		
		
		public static function newLineSet(_oSBloc:SBloc, _sLine:String, _nFileLine:UInt, _eLineType:EuVarType , _oVarSetObj:VarObj = null, _bInputVar:Bool = false, _eOpType:EuOperator , _bVarCreation :Bool = false, _oLookType:VarObj = null):VarObj { //_oLookToType for function param reference
			
			
			
			var _oLine : LineObj;
			//NewLine depend on type
			if (_eLineType != null){
			switch (_eLineType) {
				case EuVarType._LineInput :   // or EuVarType._LineInputMod  as LineInput
					if(_eOpType == EuOperator.None){
						_oLine = new LineInput();
						cast(_oLine,LineInput).oVarInput = _oVarSetObj;
					}else {
						_oLine = new LineInputMod(_eOpType);
						cast(_oLine,LineInputMod).oVarInput = _oVarSetObj;
					}
					cast(_oLine,LineInput).bVarCreation = _bVarCreation;
					if (_bVarCreation) { //Todo make LineVarIni?aa
						LineVarIni.fCheckIfNewVarIsValidScope(_oSBloc, _oVarSetObj);
					}
				//break;
				
				case EuVarType._LineReturn : 
					_oLine = new LineReturn(_oSBloc);
					cast(_oLine,LineReturn).oVarReturn = _oSBloc.oSFunction.oReturn;
				//break;
				
				case EuVarType._LineDelete : 
					_oLine = new LineDelete();
				//break;
				
				case EuVarType._ParamInput : 
					_oLine = new ParamInput(_sLine);
					
					cast(_oLine,ParamInput).oVarInput = cast(_oVarSetObj,CommonVar);
				//break;
				
				default :		
					_oLine = new LineObj();
				//break;
			}
			}else{
				_oLine = new LineObj();
			}
		
			
			_oLine.nLine = _nFileLine; 
			//_oLine.oSClass = _oSBloc.oSClass;
			//_oLine.oSFunction = _oSBloc.oSFunction; 
			_oLine.oSBloc = _oSBloc;
			
			
			if (_sLine == "") { //Error?
				return _oLine;
			}
			
			var _bLastIsCode : Bool = true;
			var _n2Code : EuOperator = EuOperator.None;
			
			//Extract all value
			var _nCurrentIndex : Int = 0 ;//Because interferance
			var _nLastWord : String = "";
			var _sResult : String;
			//var _nLength : UInt = _sLine.length - 1;
			var _nLength : UInt = _sLine.length ;  //Change because *-1) not work
			while (true) {
				
				_sResult = Text.between3(_sLine, _nCurrentIndex,  EuBetween.CodeDelim);
				_nCurrentIndex =  Text.nCurrentIndex; //Pass by between3;
				
				if(_sResult != null){ //Blank space at end
					
					if (Text.bCode) {
						//Operator
						_nCurrentIndex = codeTest(_oSBloc, _oLine, _sLine, _sResult, _nCurrentIndex);
						if(_sResult != "(" && _sResult != "[" && _sResult !=  "\"" ){
							if (_bLastIsCode) { //2 code following maybe : its a   _nX * -1;
								//do dam thing
								_n2Code = _oLine.aOpList.pop();
							}
							_bLastIsCode = true;
						}else {
							_bLastIsCode = false;
						}
						
					}else {
						
						if (_sResult == "new") {
							linkNewClass(_oSBloc, _oLine, _sLine, _nCurrentIndex, _oVarSetObj);
							break;

						}else {
							//Variable
							_nCurrentIndex =  convertToLink(_oSBloc, _oLine, _sLine, _sResult, _nCurrentIndex, _nFileLine, _bInputVar, _n2Code, _oLookType);
						}
						
						_bLastIsCode = false;
						_n2Code = EuOperator.None;
					}
					
					if (_nCurrentIndex >= _nLength) {
						break;
					}
					
			
				
				}else {
					//Blank space
					break;
				}
				
			}
			
	
			if (_bVarCreation && _oLine.bNewCreation) { //_bVarCreation = LineInput
				addIntelliPtrVar(_oSBloc, _oVarSetObj, true);
			}
			
			//Just one var --> simplify to this var
			if (_oLine.aVarList.length == 1 && _oLine.eType == EuVarType._Line) {
				var _oReturnVar : VarObj = _oLine.aVarList[0];
				if (_oReturnVar.eType == _None){
					Debug.fFatal("aaa");
				}
				_oLine = null; //Delete obj In cpp Check if correcly delepted
				return  _oReturnVar;
			}
			
			
			TypeResolve.resolveVarTypeInLine(_oLine);
			
			
			return _oLine;
		}
		
		
		private static function codeTest(_oSBloc:SBloc, _oLine : LineObj, _sLine:String, _sWord:String, _nCurrentIndex:UInt):UInt {

			
			switch (_sWord) {
				
	
				case "\"" :
					var _oVar : VarString = new VarString(_oSBloc);
					_oLine.pushFixeVar(_oVar);
				
					//Special string
					if (_nCurrentIndex > 1 &&  _sLine.charAt(_nCurrentIndex - 2) == "E") {
						_oVar.eFormat = EuStringFormat.Embed;
						_oSBloc.oSClass.aEmbedFileList.push(_oVar);
					}
					_oVar.sValue = Text.between3(_sLine, _nCurrentIndex, EuBetween.EndString);
					_nCurrentIndex = Text.nCurrentIndex;
					
				//	Debug.fBreak();
					

				//break;
				
				
				case "<" :
					if (_sLine.charAt(_nCurrentIndex) == "<") { //TODO check max lenght
						_nCurrentIndex++;
						_oLine.pushOperaor(EuOperator.LShift);
					}
				//break;
				
				case ">" :
					if (_sLine.charAt(_nCurrentIndex ) == ">") {//TODO check max length
						_nCurrentIndex++;
						_oLine.pushOperaor(EuOperator.RShift);
					}
				//break;
				
				case "&" :
					_oLine.pushOperaor(EuOperator.Mask);
				//break;
				
				case "|" :
					_oLine.pushOperaor(EuOperator.Or);
				//break;
				
				
				case "/" :
					_oLine.pushOperaor(EuOperator.Divide);
				//break;
				
				
				case "+" :
					_oLine.pushOperaor(EuOperator.Add);
				//break;
				
				case "*" :
					_oLine.pushOperaor(EuOperator.Multiply);
				//break;
				
				case "-" :
					_oLine.pushOperaor(EuOperator.Substract);
				//break;
				
				case "%" :
					_oLine.pushOperaor(EuOperator.Modulo);
				//break;
				
				case "(" :
					
				
					//New subline
					var _sPriority : String = Text.between3(_sLine, _nCurrentIndex, EuBetween.Priority);
					_nCurrentIndex = Text.nCurrentIndex;
					
					var _oNewLine : VarObj =  newLineSet(_oSBloc, _sPriority , _oLine.nLine,EuVarType._None,null,false,EuOperator.None);
					
					//Push the new line var	
					_oLine.pushVar(_oNewLine);
				
				
				//break;
				
				 
			case "[" :  //Transfore = [55] to (Int*)malloc(sizeof(Int)*55);
					
					var  _sInsideBracket : String = Text.between3(_sLine, _nCurrentIndex, EuBetween.Square);
		
					_nCurrentIndex = Text.nCurrentIndex;
					var _oVarArrayInitializer  : VarArrayInitializer = new VarArrayInitializer(_oSBloc, _sInsideBracket);
					_oLine.pushVar(_oVarArrayInitializer);
			
				
				
				/*
					//REMOVED ... TODO ?
					var  _sSize : String = Text.between3(_sLine, _nCurrentIndex, EuBetween.Square);
					if (Text.stringNotEmpty(_sSize)) { 
						_nCurrentIndex = Text.nCurrentIndex;
						var _oNewArraySquare  : VarNewArraySquare = new VarNewArraySquare(_oSBloc, cast(_sSize));
						_oLine.pushVar(_oNewArraySquare);
					}else {
						Debug.fError("new array square size is empty");
					}
						*/
					
				//break;
				
			}
			
			return _nCurrentIndex;
			
		}
		
		//The "new" keyword like
		//oTest2 = new Test2();
		private static function linkNewClass(_oSBloc:SBloc, _oLine:LineObj, _sLine:String, _nCurrentIndex:UInt,  _oVarSetObj:VarObj = null):Void {
				
			var _oVarNew : VarNew = new VarNew(_oSBloc, _oVarSetObj);
			_oLine.pushVar(_oVarNew);
					
			var _sClassName : String = Text.between3(_sLine, _nCurrentIndex,EuBetween.Word);
			_nCurrentIndex = Text.nCurrentIndex;
			
			var _oSClassObj : VarObj = SFind.findVarObj(_oSBloc.oSClass, _sClassName);
			var _oSClass : SClass = cast(  cast(_oSClassObj,VarStaticClass).oRefClass  );
			
			if (_oSClass.bExtension) {
				Debug.fError("Cannot create an object from 'extension' (extension can only be extended): " + _oSClass.sName );
				var _oLastClass : SClass = ExtractBlocs.oCurrSClass;
				var _nLastLine : UInt = ExtractBlocs.nCurrLine;
				ExtractBlocs.oCurrSClass = _oSClass;
				ExtractBlocs.nCurrLine = _oSClass.nLine;
				Debug.fError("--> Here: It must be 'class' " + _oSClass.sName + "'"); //SubError?
				ExtractBlocs.oCurrSClass = _oLastClass; //Reset
				ExtractBlocs.nCurrLine = _nLastLine; //Reset
			}
			
			
			
			_oVarNew.oNewRef = _oSClassObj;
		//	_oVarNew.oFunction = _oSClass.aFunctionList[0]; //Get the constructor //TODO verfifie if we have constructor
			_oVarNew.oFunction = _oSClass.oFuncConstructor; //Get the constructor //TODO verfifie if we have constructor
			
			_oLine.bNewCreation = true;
			
			//Test TEMPLATE
			if(_sLine.charAt( _nCurrentIndex) == "<"){
				var _sTemplate : String = Text.between3(_sLine, _nCurrentIndex+1, EuBetween.Template);
				if (Text.stringNotEmpty(_sTemplate)) {
					//extractFuncParam(_oVarNew, _sParam, _oVarNew.oFunction);
					_oVarNew.extractTemplate(_sTemplate);
				}
				_nCurrentIndex = Text.nCurrentIndex;
			}
			
			//TODO test if error if ( have a space ex :  oTest2 = new Test2 (10);
			var _sParam : String = Text.between3(_sLine, _nCurrentIndex+1, EuBetween.Priority);
			if (Text.stringNotEmpty(_sParam)) {
				//extractFuncParam(_oVarNew, _sParam, _oVarNew.oFunction);
				_oVarNew.extractFuncParam(_sParam);
			}
			
		}
		
		
		
		
		
	
		
		private var gTest:Bool = false;
		private static function convertToLink(_oSBloc:SBloc, _oLine:LineObj, _sLine:String, _sWord:String, _nStartIndex:UInt, _nFileLine:UInt, _bInputVar:Bool, _nSecondCode:EuOperator, _oLookType:VarObj = null):UInt {
			var _nNextChar : String;
			var _nIndex : UInt;
			var _nId :  Int;
			var _oSClass : SClass = _oSBloc.oSClass;
			var _nReturnIndex : UInt = _nStartIndex;
			
			if (Text.testNumber(_sWord)) {
				/////////////////////
				////It's a Int////
				/////////////////////
				
				//Check if point next
				_nNextChar = "";
				if(_nStartIndex < _sLine.length){
					_nNextChar = _sLine.charAt(_nStartIndex);
				}
				
				if (_nNextChar == ".") {
					//Float
					var nAfterPoint : String = Text.between3(_sLine, _nStartIndex + 1, EuBetween.Numbers);
					
					if (_sLine.charAt(Text.nCurrentIndex) == "p") {
						Text.nCurrentIndex++;
						_nReturnIndex = Text.nCurrentIndex;
						//Create special Int
						var _oVarInt : VarInt = new VarInt(_oSBloc);		
						_oVarInt.bConvertInPixel = true;
						_oVarInt.nValue = cast(_sWord); //Flash converte automaticly hexa
						if (_nSecondCode == EuOperator.Substract) {
							_oVarInt.nValue *= -1;
						}
						_oVarInt.nPixfrac = cast(nAfterPoint);
						_oSClass.pushFixeVar( _oVarInt );
						_oLine.pushVar(_oVarInt);
						
					}else{
						//Float
						var _oVarFloat : VarFloat = new VarFloat(_oSBloc);
						_nReturnIndex = Text.nCurrentIndex;
						_oVarFloat.nValue =  Std.parseFloat(_sWord + "." + nAfterPoint);
						if (_nSecondCode == EuOperator.Substract) {
							_oVarFloat.nValue *= -1;
						}
						_oSClass.pushFixeVar( _oVarFloat );
						_oLine.pushVar(_oVarFloat);
					}
				
				}else if (_sWord.charAt(1) == "x") {	
					
					//Hexadecimal
					var _oVarHex : VarHex = new VarHex(_oSBloc);
					
					_oVarHex.nValue = Std.parseInt(_sWord); //Flash converte automaticly hexa
					
					
					
					_oSClass.pushFixeVar( _oVarHex );
					_oLine.pushVar(_oVarHex);
					
				}else {
					
					//Integer
					var _oVarIntP : VarInt = new VarInt(_oSBloc);		
					if (_sWord.charAt(_sWord.length - 1) == "p") {
						_sWord = _sWord.substring(0, _sWord.length - 1); //Remove last caractere
						_oVarIntP.bConvertInPixel = true;
					}
					_oVarIntP.nValue = cast(_sWord); //Flash converte automaticly hexa
						
					if (_nSecondCode == EuOperator.Substract) {
						_oVarIntP.nValue *= -1;
					}
					_oSClass.pushFixeVar( _oVarIntP );
					_oLine.pushVar(_oVarIntP);
				
				
				}	
				
			}else{
				/////////////////////
				//// It's a Word ////
				/////////////////////
				
				//Check if anything next
				_nNextChar = "";
				if(_nStartIndex < _sLine.length){
					_nNextChar = _sLine.charAt(_nStartIndex);
				}
				

				//if (_nNextChar == "." || _nNextChar == "[" ) {
				if (_nNextChar == ".") {
					//Extract multipe var path ex : aEnumArray[nBlabla][4].rPos.nY.nA
					_nReturnIndex =  convertMultipleDotPath(_oSBloc, _oLine, _sLine, _nStartIndex, _nFileLine, _sWord, null ,_bInputVar);
					/////////
					
					
				}else if (_nNextChar == "[") {
					//Extract multipe var path ex : aEnumArray[nBlabla][4]
					_nReturnIndex =  convertMultipleVarArray(_oSBloc, _oLine, _sLine, _sWord, _nStartIndex, _nFileLine, _bInputVar);
					///////////////
	
				}else if (_nNextChar == "(") {
					/////////////////
					//Function call//
					/////////////////
					_nReturnIndex = convertFunction(_oSBloc, _oLine, _sLine, _sWord, _nStartIndex);
					///////////////
	
				}else {
					
					///////////////////////////////////
					//Special specal word - variable//
					//////////////////////////////////
					switch (_sWord) {
						case  "this" :
							//This
							var _oVarThis : VarThis = new VarThis(_oSBloc);
							_oLine.pushVar(_oVarThis);
							
						//break;
						case  "parent" :
							//This
							var _oVarParent : VarParent = new VarParent(_oSBloc);
							_oLine.pushVar(_oVarParent);
							
						//break;
						
						case  "thread" :
							//This
							var _oVarTread : VarThread = new VarThread(_oSBloc);
							_oLine.pushVar(_oVarTread);
							
						//break;
						
						case  "null" :			
						
							//Null
							var _oVarNull : VarNull = new VarNull(_oSBloc);
					
							_oLine.pushVar(_oVarNull);

						//break;
						
						case  "true" :			
						
							var _oVarTrue : VarBoolean = new VarBoolean(_oSBloc);
							_oVarTrue.nValue = 1;
							_oLine.pushVar(_oVarTrue);

						//break;

						case  "false" :			

							var _oVarFalse : VarBoolean = new VarBoolean(_oSBloc);
							_oVarFalse.nValue = 0;
							_oLine.pushVar(_oVarFalse);

						//break;
						
						case  "inline" :	
						
							_oSBloc.oSClass.pushInline(_oSBloc);
							_oLine.bInline = true;
							
						//break;
						
						default :
							///////////////////////////////
							//// It's a Variable alone ////
							///////////////////////////////
					
							//Special case ignore embed file string
							if (_sWord.charAt(0) == "E" &&  (_nStartIndex < _sLine.length && _sLine.charAt(_nStartIndex ) == "\"") ) { 
								return _nStartIndex;
							}
							
							
							var _oVar : VarObj = SFind.findVarObj(_oSBloc, _sWord, _oLookType);
							_nReturnIndex = pushAndTestModifier(_oSBloc, _oLine, _oVar, _sLine  , _nReturnIndex);
							//_oLine.pushVar( testModifier(_oSBloc, _oVar, _sLine  , _nReturnIndex));

							
							/*
							if (_oVar != null  && _oVar != EuVarType._None) {
							}else {
								//Maybe a function name for call function var
								//TODO make class location
								_nId  = findFuntion(_sWord, -1, false);
								if (_nId != -1 ) {
									pushLocalVariable( _nId, cTypeNameFunction, _nPutVarInClass);
									
								}else{
									Debug.fError("can't find var/function : " + _sWord);
								}
							}
							*/
							
							///////////////////////
							///////////////////////
							
						//break;
						
						
					}
					
					
				}
				
			
			}//End of not a number
			
			
			return _nReturnIndex;
			
		}
		
		//Modifier like inc and dec
		private static function pushAndTestModifier(_oSBloc:SBloc, _oLine:LineObj, _oVar:VarObj, _sLine:String,  _nStartIndex : UInt):UInt {
			
			var _nNextChar : String = _sLine.charAt(_nStartIndex);
			var _nNextNextChar : String = _sLine.charAt(_nStartIndex + 1);
			
			if (_nNextChar == "+" && _nNextNextChar == "+") { //Like i++   incrmentation change container

				var _oVarInc : VarInc  =  new VarInc(_oSBloc);
				_oVarInc.oVar  = _oVar;
				_oLine.pushVar( _oVarInc );
				return _nStartIndex + 2;
			}
			
			if (_nNextChar == "-" && _nNextNextChar == "-") { //Like i--  decrementation change container

				var _oVarDec : VarDec  =  new VarDec(_oSBloc);
				_oVarDec.oVar  = _oVar;
				_oLine.pushVar( _oVarDec);
				return _nStartIndex + 2;
			}
			
			_oLine.pushVar( _oVar);
			return _nStartIndex;
		}
		
		private static function convertFunction(_oSBloc:SBloc , _oLine : LineObj, _sLine : String, _sWord : String, _nIndex:UInt, _oSearchInBloc:VarObj = null):UInt {
			
			if (_oSearchInBloc == null) {
				_oSearchInBloc =  cast(_oSBloc,SBloc);
			}
			
			var _sParam : String = Text.between3(_sLine, _nIndex + 1, EuBetween.Priority);
			var _nReturnIndex : UInt = Text.nCurrentIndex;
			
			//var _oFunc : SFunction = SFunction(SFind.findFuncObj(_oSBloc, _sWord));  
			var _oVar : VarObj =  SFind.findFuncObj(_oSearchInBloc, _sWord);  
			oLastLookInBloc = _oVar;
			switch(_oVar.eType) {
				case EuVarType._SNatFunction :
					var _oNativeFuncCall : NativeFuncCall = new NativeFuncCall(_oSBloc, cast(_oVar,SNatFunction), _oSearchInBloc);
					// Easing condition //
					if ( TypeResolve.isVarCommon(_oSearchInBloc) && _oSearchInBloc.eType != EuVarType._String) {
						if(cast(_oSearchInBloc,CommonVar).oAssociate != null){
							_oNativeFuncCall.oAssociate = cast(_oSearchInBloc,CommonVar).oAssociate;
							
						}else {
							Debug.fError("Interpolation fonction on Common Var with no associate var : " +  cast(_oSearchInBloc,CommonVar).sName);
							Debug.fStop();
						}
					}
					////////////////////
					
					_oLine.pushVar(_oNativeFuncCall);
		
					if (Text.stringNotEmpty(_sParam) ) {
						_oNativeFuncCall.extractFuncParam( _sParam);
					}
					
				//break;
				
				case  EuVarType._GateFunction:
				
					var _oGate : GateFunc = cast(_oVar);
				//	Debug.fError("FOUND GATE FUNC " + _oGate.oSClass.sName + " : " +_oGate.oSFunc.sName);
					
					//Debug.trace("ExtendFuncFoundParam : " + _oExt.oSFunc.sName);
					var _oGateFuncCall : GateFuncCall = new GateFuncCall(_oSBloc, _oGate.oSClass, _oGate.oSFunc, _oSearchInBloc);
					_oLine.pushVar(_oGateFuncCall);
					_oGateFuncCall.extractFuncParam( _sParam);
					
					
				case  EuVarType._ExtendFunction:
					var _oExt : ExtendFunc = cast(_oVar);
									
					if (Text.stringNotEmpty(_sParam) ) {
						//Debug.trace("ExtendFuncFoundParam : " + _oExt.oSFunc.sName);
						var _oExtendFuncCall : ExtendFuncCall = new ExtendFuncCall(_oSBloc, _oExt.oSClass, _oExt.oSFunc, _oSearchInBloc);
						_oLine.pushVar(_oExtendFuncCall);
						_oExtendFuncCall.extractFuncParam( _sParam);

					}else {
						_oLine.pushVar(_oExt);
					}
					
					if (_oExt.oSFunc.bConstructor) {
					//	Debug.fTrace("Found Constructor " +_oExt.oSFunc.sName + " "   + _oSBloc.oSFunction.sName );
						_oSBloc.oSFunction.bCallExtendConstuctor = true;
					}
					
					
				//break;
				
				case  EuVarType._Delegate:
					var _oCallDelegate : CallDelegate = new CallDelegate(_oSBloc, cast(_oVar,Delegate), _oSearchInBloc);
					//_oCallDelegate.oFunction = Delegate(_oVar).oSFunction;
					_oLine.pushVar(_oCallDelegate);
					if (Text.stringNotEmpty(_sParam) ) {
						_oCallDelegate.extractFuncParam(_sParam);
					}
					
				//break;
				
				case  EuVarType._TypeDef:
				
					var _oTypeDef : TypeDef = cast(_oVar);
					var _oSubLine : VarObj = extractLine(_oSBloc, _sParam, 0);	
					var _oCastTypeDef : CastTypeDef = new CastTypeDef(_oTypeDef, _oSubLine);
					_oLine.pushVar(_oCastTypeDef);
					
				//break;
			
				
				default :  //Normal
					var _oFunc : SFunction = cast(_oVar);
					if (Text.stringNotEmpty(_sParam) ) {
						var _oFuncCall : FuncCall = new FuncCall(_oSBloc, _oSearchInBloc);
						_oFuncCall.oFunction = _oFunc;
						_oFuncCall.bInline = _oLine.bInline;
						_oLine.pushVar(_oFuncCall);

						_oFuncCall.extractFuncParam( _sParam);
					
					}else {
						_oLine.pushVar(_oFunc); //Direcly //---> Maybe Not
					}
				//break;

			}
			
			return _nReturnIndex;
		}
		
		
		
		
		//////////////////////////////////////
		//Found a dot, make location var //
		//////////////////////////////////
		private static function convertMultipleDotPath(_oSBloc:SBloc, _oLine:LineObj, _sLine:String,  _nStartIndex:UInt, _nFileLine:UInt, _sWord:String, _oFirstVar:VarObj = null, _bInputVar:Bool = false):UInt {
		
			
			var _oLineLoc : LineLoc = new LineLoc();
			_oLineLoc.oSBloc = _oSBloc;
			_oLineLoc.bInline = _oLine.bInline;
			
			if(_oFirstVar == null){
				_oFirstVar = SFind.findVarObj(_oSBloc, _sWord);
			}
			_oLineLoc.pushVar(_oFirstVar);
			
			
			_nStartIndex = convertLocVar(_oSBloc, _oLineLoc, _nStartIndex,  _sLine, _oFirstVar, _bInputVar);
			//After found all var :
			var _oLastVar : VarObj = _oLineLoc.aVarList[ _oLineLoc.aVarList.length-1];
			_oLineLoc.oResultVar = _oLastVar;
			_oLineLoc.oResultingType = TypeResolve.getResultingType(_oLastVar);
			//("_oLineLoc.oResultingType : " + "_oLastVar : " + CommonVar(_oLastVar).sName + " " + _oLineLoc.oResultingType.eType);
			
			_nStartIndex = pushAndTestModifier(_oSBloc, _oLine, rearrangeLineLoc(_oLineLoc), _sLine, _nStartIndex);
			return _nStartIndex;
			
		}
		
		public static var oLastLookInBloc : VarObj ; //To get local scope when analyse
		//Recursive var find location with dot : oTest3.oTest.nTest2
		private static function convertLocVar(_oSBloc:SBloc, _oLineLoc:LineLoc,  _nStartIndex:UInt,  _sLine:String, _oPrecLocVar : VarObj, _bInputVar:Bool):UInt {
			
			var _oFindVar : VarObj;
			var _sVar  : String = Text.between3(_sLine, _nStartIndex + 1, EuBetween.Word);
			_nStartIndex = Text.nCurrentIndex;
			if (_sVar == null) { //Finish with . ?
				return _nStartIndex;
			}
			
			//var _oLookInBloc : VarObj ;
			var _oLookInBloc : VarObj = EuVar.VarNone;//CW??
			
			//First pass
			switch(_oPrecLocVar.eType) {
				case EuVarType._LineArray:
					var _oLineArray : LineArray = cast(_oPrecLocVar);
					_oPrecLocVar = _oLineArray.oArray.oVarsType; //Class or rtu TODO maybe test it
				//break;
				default:
			}
		
			if (_oPrecLocVar.eType ==  EuVarType._ExtendVar) { //Redirect
				_oPrecLocVar = cast(_oPrecLocVar,ExtendVar).oVar;
			}
			
			
			//Second pass
			switch(_oPrecLocVar.eType) {
							
				case EuVarType._StaticClass:  //Static class
					var _oStaticClass : VarStaticClass = cast(_oPrecLocVar);
					//_oLookInBloc = _oStaticClass.oRefClass;
					_oLookInBloc = _oStaticClass;
				
				//break;
				
				case EuVarType._CallClass:
					var _oCallClass : VarCallClass = cast(_oPrecLocVar);
					//_oCallClass.oCallRef;
					_oLookInBloc = _oCallClass.oCallRef;
					
				//break;
				
				case EuVarType._ExClass:
					var _oExClass : VarExClass = cast(_oPrecLocVar);
					//_oCallClass.oCallRef;
					_oLookInBloc = _oExClass.oExCallRef;
					
				//break;
				
				case EuVarType._FuncCall:
					
					var _oFuncCall : FuncCall = cast(_oPrecLocVar);
					//_oCallClass.oCallRef;
					//_oLookInBloc = SBloc(_oFuncCall.eConvertInType.oFunction..oReturn.oSBloc);
					_oLookInBloc = _oFuncCall.oFunction.oReturn;
				//break;
				
				case EuVarType._UseEnum:
					var _oEnum : EnumObj = cast(_oPrecLocVar,UseEnum).oEnum;
					_oLookInBloc = _oEnum;
				//break;	
				
				case EuVarType._Enum:
					var _oEnum : EnumObj = cast(_oPrecLocVar);
					_oLookInBloc = _oEnum;
				
				//break;			
				
				case EuVarType._RtuMap
				| EuVarType._Rtu:
					var _oRtu : VarRtu = cast(_oPrecLocVar);
					_oLookInBloc = _oRtu.oUnitRef;
				//break;
				
				case EuVarType._QueueArray:
					var _oQueueArray : VarQueueArray = cast(_oPrecLocVar);
					_oLookInBloc = _oQueueArray; //Native function
				//break;
				
						
				case EuVarType._QElement:
					var _oQueueElement : VarQElement = cast(_oPrecLocVar);
					_oLookInBloc = _oQueueElement; //Native function
				//break;
				
				//case EuVarType._UInt:
				case EuVarType._Float
				| EuVarType._Int:
					_oLookInBloc = _oPrecLocVar; //For Native function
				//break;
		
				case EuVarType._String:
					_oLookInBloc = _oPrecLocVar; //For Native function
				//break;
				
				case EuVarType._Gate
				| EuVarType._DataArr
				| EuVarType._DArray:
					_oLookInBloc = _oPrecLocVar; //For Native function
				//break;
				
				default :
					Debug.fError("PrecLocVar invalid type  : " + _oPrecLocVar.eType);
					Debug.fStop();
				//break;
			}
			
			oLastLookInBloc = _oLookInBloc;
					
			if ( _sLine.charAt(_nStartIndex) == "(") {
				
				_nStartIndex = convertFunction(_oSBloc, _oLineLoc, _sLine, _sVar, _nStartIndex, _oLookInBloc); //push is inside
				_oFindVar = _oLineLoc.aVarList[_oLineLoc.aVarList.length - 1]; //Maybe we can do this better
				
			}else {
				
				_oFindVar = SFind.findVarObj(_oLookInBloc, _sVar);
				if (_oFindVar.eType == EuVarType._ExtendVar) {
					_oFindVar = cast(_oFindVar,ExtendVar).oVar;
				}
				
				if ( _sLine.charAt(_nStartIndex) == "[") {
				
					var _oNewLineArray : LineArray = new LineArray(_oSBloc);
					_oNewLineArray.oArray = cast(_oFindVar,VarArray);
					_nStartIndex = convertSquareVar(_oSBloc, _oNewLineArray, _nStartIndex,  _sLine, _bInputVar);
					_oFindVar = _oNewLineArray;
				}
				
				_oLineLoc.pushVar(_oFindVar); //Normal and dot var
			}
			
			
			////////// Test atomic error ///////////
			if (_oPrecLocVar != null && _oPrecLocVar.eType == EuVarType._StaticClass) {
				if (_oSBloc.oSClass.bAtomic) {
					if (_oFindVar != null) {
						if (_oFindVar.eType == EuVarType._FuncCall) {
								if (cast(_oFindVar,FuncCall).oFunction.eFuncType != EuFuncType.Pure) {
										Debug.fError("Atomic class cannot acces to static function not 'pure': " +  cast(_oPrecLocVar,VarStaticClass).sName + " : " + _oFindVar.eType);
								}
							//	Debug.fError("Atomic class cannot acces to static function not 'pure': " +  VarStaticClass(_oPrecLocVar).sName + " : " + FuncCall(_oFindVar).oFunction.eFuncType);
								
						}else {
							//Cannot access to non-atomic var
							Debug.fError("Atomic class cannot acces to static elements: " +  cast(_oPrecLocVar,VarStaticClass).sName + " : " + _oFindVar.eType);
						}
					}
				}
			}
			/////////////////////////////////////////
			

			if ( _sLine.charAt(_nStartIndex) == ".") {
				_nStartIndex = 	convertLocVar(_oSBloc, _oLineLoc, _nStartIndex, _sLine, _oFindVar, _bInputVar);
			}
			
						

			
			return _nStartIndex;

		}
		
		//Transform Native fonction give qaQueue.push(); to cq_push(qaQueue);  //push is native function -> change lineloc to NativeFuncCall with lineloc in param
		private static function rearrangeLineLoc(_oLineLoc : LineLoc) : VarObj {
			if (_oLineLoc.oResultVar.eType == EuVarType._NativeFuncCall) {  //TODO maybe do multiple NativeFuncCall
				var _oNativeFuncCall :  NativeFuncCall = cast(_oLineLoc.oResultVar);
				_oLineLoc.aVarList.pop();
				//_oNativeFuncCall.aParamList[0] = _oLineLoc;
				
				// Easing Cond ////
				if (_oNativeFuncCall.oAssociate != null) {
					var _oVarLast : VarObj = _oLineLoc.aVarList[ _oLineLoc.aVarList.length - 1];
					if (_oVarLast.eType == EuVarType._ExtendVar) {
						_oVarLast = cast(_oVarLast,ExtendVar).oVar;  //TODO check if we must keep extend proprerty
					}
					
					if (TypeResolve.isVarCommon(_oVarLast)) {
						if (cast(_oVarLast,CommonVar).oAssociate == _oNativeFuncCall.oAssociate ) { //Maybe usless verifiaction
							 _oLineLoc.aVarList[ _oLineLoc.aVarList.length - 1] = _oNativeFuncCall.oAssociate;
						}else {
							Debug.fError("associate var mismatch on Esaing");
							Debug.fStop();
						}
					}
				}
				//////////////////
				
				if (_oLineLoc.aVarList.length == 1) { //Only one var in lineloc, delete lineloc to pur direcly the var
					//Delete
					var _oSimplify : VarObj = _oLineLoc.aVarList[0];
					_oNativeFuncCall.oSource = _oSimplify;
					_oLineLoc.destroy();
					
					//Debug.trace("Delete!");
				}else {
					_oNativeFuncCall.oSource = _oLineLoc;
					//Debug.trace("NonDelete!");
				}
				
				return _oNativeFuncCall;
			}
			return _oLineLoc;
		}
		

		////////////////////////////////////
		//Found a Square, make Array<Dynamic> var////
		////////////////////////////////////
		private static function convertMultipleVarArray(_oSBloc:SBloc, _oLine:LineObj, _sLine:String, _sWord:String, _nStartIndex:UInt, _nFileLine:UInt, _bInputVar:Bool = false):UInt {
			var _oLineArray : LineArray = new LineArray(_oSBloc);
			
			
			var _oFindVar : VarObj = SFind.findVarObj(_oSBloc, _sWord);
			
			_oLineArray.applyVarArray(_oFindVar);
			//_oLineArray.oArray = VarArray(_oFindVar);
			
			_nStartIndex = convertSquareVar(_oSBloc, _oLineArray, _nStartIndex,  _sLine, _bInputVar);
			
		
			if ( _sLine.charAt(_nStartIndex) == ".") { //_oFindVar is only call by dot precede
				_nStartIndex = convertMultipleDotPath(_oSBloc, _oLine,  _sLine, _nStartIndex, _nFileLine, "", _oLineArray);
			}else{
				//Noting after then push normaly
				_nStartIndex = pushAndTestModifier(_oSBloc, _oLine, _oLineArray, _sLine, _nStartIndex);
			}
			
			return _nStartIndex;
		}

		
		private static function convertSquareVar(_oSBloc:SBloc, _oLineArray:LineArray,  _nStartIndex:UInt,  _sFullLine:String, _bInputVar:Bool):UInt {
			
			var _sNextChar : String;
			do{
				var _sLine  : String = Text.between3(_sFullLine, _nStartIndex + 1, EuBetween.Square);
				_nStartIndex = Text.nCurrentIndex;
				
				
				var _oNewLine : VarObj =  newLineSet(_oSBloc, _sLine , _oLineArray.nLine ,null,false,EuOperator.None);
				_oLineArray.pushVar(_oNewLine,  EuVar.VarUInt);
				//_oLineArray.aConvertInTypeList.push();
				//_oLineArray.oConvertInType = EuVarType._VarUInt;
				
				_sNextChar = _sFullLine.charAt(_nStartIndex);
			} while (_sNextChar == "[");
			
			_oLineArray.bWrite = _bInputVar;
			
			_oLineArray.getResultType();
			
			return _nStartIndex;
		}
		
		
		private static function addIntelliPtrVar(_oSBloc:SBloc, _oVar : VarObj, _bVarCration: Bool = false):Void {
			
			
			switch(_oVar.eType) {
				////// INTELLI PTR ////////////
				case EuVarType._CallClass :
					var _oCallClass : VarCallClass = cast(_oVar);
				//	Debug.trace1("Add : " + _oCallClass.sName);
					_oCallClass.bScopeOwner = _bVarCration;
				//break;
				
				
				case EuVarType._Rtu :
					if (!cast(_oVar,VarRtu).oUnitRef.bCpp) {
					//if(!VarRtu(_oVar).oUnitRef.oSClass.oSLib.bReadOnly){
						_oSBloc.pushEndSubRtuPtr(cast(_oVar,VarRtu));
					}
				//break;
				default:
			}
		}
		
			
	/*
			
			//Class call
			//Debug.trace("Class/Rtu call at : " + _sLine);
		
			var _aCall : Array<Dynamic> = extractCallType(_sWord, _sLine);//
			if (nExtractType == -1) {
				Debug.fError("unable to resolve nExtractType")
				gbug();
			}
	
			if(nExtractType == cExtractCall){
				_nFuncId = linkOtherClassFunctionCall(_aCall, nExtractCallTypeReturnFirstVarLoc, false, _nFileLine);
				if (!bExtractCpp) {
					pushLocalVariable( _nFuncId, cTypeClassCallFunction, _nPutVarInClass);
				}else {
					pushLocalVariable( _nFuncId, cTypeCppClassCallFunction, _nPutVarInClass);
				}
			
			
			//ex: 	cfCall = oTest2.OutsideCall;
			}else if(nExtractType == cExtractSpecialCall){
				_nFuncId = linkOtherClassFunctionCall(_aCall, nExtractCallTypeReturnFirstVarLoc, false, _nFileLine);
				pushLocalVariable( _nFuncId, cTypeClassCallSpecialFunction, _nPutVarInClass);
			
			//ex: 	cfCall = oTest2.OutsideCall;
			}else if (nExtractType == cExtractFunction) {
			
				if (nExtractType != bExtractCpp) {
						
					//_aCall is a new array here to give to var value
					if (!bExtractStatic) {
						pushLocalVariable( _aCall, cTypeNameClassFunction, _nPutVarInClass);
					}else {
						pushLocalVariable( _aCall, cTypeNameStaticClassFunction, _nPutVarInClass);
					}
				
				}else {
					Debug.fError("cpp imposible to link function defintion (make callback)")
					
				}
				///////
				//RTU//
				///////
			}else if (nExtractType == cExtractVar) {
				
				var _nType : UInt;
				
				//Ex: nEventValue = MainEvent.nRESUME
				if (bExtractStatic && _aCall.length == 2) {
					
					_nType = cTypeStaticVar;

				//Normal rtu
				}else {
			
					_nType = cTypeRtu;
				}
				
				
				//Not sur if pushLocalVariable is the best way (for var location)
				pushLocalVariable( _aCall, _nType, _nPutVarInClass, nExtractCallTypeReturnFirstVarLoc);
				
				//Get Last var to put in rtu type  (the last egal the var type after convertion link)
				aCurrentVar[cVarListResultingType] = nExtractLastVarType;
				/////////
				//ARRAY//
				/////////
			}else if(nExtractType == cExtractSpecialVar){	
				
				pushLocalVariable( _aCall, cTypeSpecialVar, _nPutVarInClass, nExtractCallTypeReturnFirstVarLoc);
				aCurrentVar[cVarListResultingType] = nExtractLastVarType;
				if(nExtractLastVarType == cTypeCallClass){
					aCurrentVar[cVarListClass] = cAnyClass;
				}
				
			}else if(nExtractType == cExtractArray){
				///zzzzzzz 
				
				/////////////////
				//Get the resulting type
				var _aLastVar : Array<Dynamic> = aCurrentClassVar[_aCall[_aCall.length - 1]];
				var _nLastType : UInt = _aLastVar[cVarListType];
				var _nResultingDimention : UInt = 0 //Only for incomplete array
				var _nResultingInputType : UInt = 0 //Only for incomplete array
				
				
				//Do this before we shift first value  in pushLocalVariable
				//Resulting type = type of the array only if we get the egal number of dimention otherwise it will be an array
				if (_nLastType == cTypeSquare) {
					//Get last array
					var _nGetType : Int = cTypeSquare;
					var _aGetVar : Array<Dynamic>;
					 var _nGetIndex : Int = _aCall.length - 1;
					 var _nCount : Int = 0;
					while (_nGetType != cTypeArray) {
						_nCount ++;
						_nGetIndex --;
						_aGetVar = aCurrentClassVar[Math.abs(_aCall[_nGetIndex])]
						_nGetType = _aGetVar[cVarListType];
					}
					var _nGetDimention : Int = _aGetVar[cVarListDimention]
					if (_nGetDimention == _nCount) { //Match then the resulting type is the array type 
						_nLastType = _aGetVar[cVarListInputType];
					}else {
						_nResultingDimention =_nGetDimention - _nCount; //Now need how many dimention of this array
						_nLastType = cTypeArray;//If dimention is not zero the we have a array result
						_nResultingInputType = _aGetVar[cVarListInputType]; 
					}
				}
				
				if (_nLastType == cTypeArray) {
					_nResultingDimention = _aLastVar[cVarListDimention];
					_nResultingInputType = _aLastVar[cVarListInputType]; 
				}
				
				
				if (_nLastType == cTypeSquareEnum) { //Exeption for enum we must extrac is type
					var _nEnumId : Int = _aLastVar[cVarListInputType];
					var _sSubEnum : String = String( _aLastVar[cVarListValue] );
					var _aEnum : Array<Dynamic> = aCurrentClassEnum[_nEnumId];
					var _aSubEnum : Array<Dynamic> = _aEnum[cEnumListVarList][cast(_sSubEnum)]
					var _nSubId : UInt = _aSubEnum[cEnumListVarListId];
					var _aSubEnumVar : Array<Dynamic> = aCurrentClassVar[_nSubId];
					_nLastType=  _aSubEnumVar[cVarListType];
				}
				

				//Not sur if pushLocalVariable is the best way (for var location)
				pushLocalVariable( _aCall, cTypeArray, _nPutVarInClass, nExtractCallTypeReturnFirstVarLoc);
				
				//WWWWW
				aCurrentVar[cVarListResultingType] = _nLastType;
				aCurrentVar[cVarListResultingDim] = _nResultingDimention;
				aCurrentVar[cVarListResultingInputType] = _nResultingInputType;

				
				
			}else if (nExtractType == cExtractEnum) {
				
				
				//Last value is the good one
				var _nVarId : Int = _aCall[_aCall.length-1];
				
				//Push
				var  _nVarIndex : UInt  = aCurrentLine[cLineVarList].length;
				aCurrentLine[cLineVarList][_nVarIndex] = _nVarId;	
				aCurrentLine[cLineLocationList][_nVarIndex] = cLocGlobal;
			}
			
			*/
		//}
		
		
		
		/*
		private static function extractFuncParam(_oFunc:FuncCall, _sParam:String, _oSearchInBloc:SBloc):Void {
			var _oLookFunc  :SFunction = _oFunc.oFunction;
			var _aLookParamList : Array<Dynamic> = _oLookFunc.aParamList; //TODO check same number of param
			
			//var _aParamList : Array<Dynamic> = _sParam.split(",");
			var _aParamList : Array<Dynamic> = Text.surfaceSplit(_sParam, ",");
			
			var _i:UInt = _aParamList.length;
			for (i in 0 ..._i) {
				
				if (_aLookParamList[i] == null) {
					Debug.fError("LookParam not correspond in : " + _oLookFunc.sName + " for "  +_sParam);
				}
				
				////ParamGetType/// Maybe do direct
				var _oLookParam : VarObj = _aLookParamList[i];
				var _oLookType : VarObj = _oLookParam;
				if (_oLookParam.eType == EuVarType._ParamInput) {
					_oLookType = ParamInput(_oLookParam).oVarInput;
				}
				
				//////////////////
				_oFunc.aParamList[i] = newLineSet(_oSearchInBloc,  _aParamList[i],  _oFunc.oFunction.nLineNum );
				var _oReusltType : VarObj = TypeResolve.getResultingType(_oFunc.aParamList[i]);
				_oFunc.aResultTypeList[i] = _oReusltType;
			
				if(_oLookType.eType != _oReusltType.eType){
					_oFunc.aConvertInTypeList[i] = _oLookType;    //TODO bette chek in typeresolve
				}else {
					_oFunc.aConvertInTypeList[i] = EuVar.VarNone;// EuVarType._None;
				}
		
				
				
			}
		}*/
		

		
		
	}

