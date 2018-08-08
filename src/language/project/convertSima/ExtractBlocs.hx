package language.project.convertSima ;
	import language.enumeration.EuBetween;
	import language.enumeration.EuCppLineType;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuMultiLogical;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.CppProject;
	import language.Text;
	import language.vars.logicObj.CompareObj;
	import language.vars.logicObj.LogicalObj;
	import language.vars.logicObj.LogicCase;
	import language.vars.logicObj.LogicElse;
	import language.vars.logicObj.LogicFor;
	import language.vars.logicObj.LogicForEach;
	import language.vars.logicObj.LogicIf;
	import language.vars.logicObj.LogicSwitch;
	import language.vars.logicObj.LogicSwitchCast;
	import language.vars.logicObj.LogicWhile;
	import language.vars.special.VarQElement;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.LineReturn;
	import language.vars.varObj.VarComment;
	import language.vars.varObj.VarCppLine;
	import language.vars.varObj.VarObj;
	import language.base.Debug;
	/**
	 * ...
	 * @author ...
	 */
	class ExtractBlocs
	{
		public static var oCurrSClass : SClass = null;
		public static var nCurrLine : Int = 0;
		
		//Select all function of one class to extract each lines
		public static function extractClassFunctions(_oSClass:SClass):Void {
			if (_oSClass.bFuncExtracted) {
				return;
			}
			_oSClass.bFuncExtracted = true;
			
			oCurrSClass = _oSClass;
			//Extract all line in each function 
			var _aFunctionList : Array<Dynamic> = _oSClass.aFunctionList;
			var _i:UInt = _aFunctionList.length;
			for (i in 0 ..._i) {
				var _oFunction : SFunction = _aFunctionList[i];
				if(!_oFunction.bNoLine){
					if(_oFunction.eFuncType != EuFuncType.Extend){ //Do make empty extend function list
					//	Debug.trace3("--Function analyse : " + _oFunction.sName);
						allLineInFunction(_oSClass,  _oFunction);
					}
				}
			}
			if (_oSClass.oFuncDestrutor != null) { //special case for destructor
				allLineInFunction(_oSClass,  _oSClass.oFuncDestrutor);
			}
			
			fExtractBetweenFunction(_oSClass);

			oCurrSClass = null;
		}
		
		
		private static function allLineInFunctionTry(_oSClass:SClass, _oFunction : SFunction):Void {
		
				//New function main bloc
				var _oSBloc : SBloc = cast(_oFunction);
				//_oSBloc.oFunction = _oFunction;
				//_oSBloc.oSClass = _oFunction.oSClass;
				//_oFunction.oMainBloc = _oSBloc;
				
				var _aFile : Array<Dynamic> = _oSClass.aFile;
				var _nCurentLine : UInt = _oFunction.nLineNum - 1;
				var _nTotalLines : UInt = _aFile.length;
				
			
			
				//Read file until reach end of function or the end of file
				while (_nCurentLine < _nTotalLines) {
					_nCurentLine ++;
					nCurrLine = _nCurentLine + 1; //Extractbloc.nCurrLine
					
					_oSBloc = extractLine( _oSBloc, Text.removeComments( _aFile[_nCurentLine], _oSBloc, false, true), _nCurentLine + 1);
					if (_oSBloc == null) {
						break;
					}
				}

				if (_nCurentLine == _nTotalLines) {
					Debug.fError("Endless function");
				}
				
				//fTestErrorNoReturnInFunction(_oFunction); *Auto nullable
				nCurrLine = -1;
			
		}
	
		
		
		
		private static function allLineInFunction(_oSClass:SClass, _oFunction : SFunction):Void {
		
			if(Setting.bDoTryCatch){
	
				try {

					allLineInFunctionTry(_oSClass, _oFunction);

				} catch (err:String) {

					if (err.charAt(0) == ":") { //My errors
						//trace("Er");
						Debug.fError("Func Internal Error: " + err);
					}else {
						throw err; //throw away
					}
				}
				
			}else{
				
				allLineInFunctionTry(_oSClass, _oFunction);
			}
		}
		
		
		/*
		private static function fTestErrorNoReturnInFunction(_oFunction : SFunction) {
			if(_oFunction.oReturn.eType != EuVarType._Void){
				var _bRet : Bool = false;
				for( var _oLineRet : LineReturn  in  _oFunction.aLineReturnList  ) {
					_bRet = true;
				}
				if (!_bRet) {
					Debug.fError("Fonction " + _oFunction.sName + " require return line, type: " + _oFunction.fGetType() );
				}
			}
			
		}*/
		
		
		public static function extractLineObjTry( _oSBloc : SBloc, _sLine:String, _nLineNum : UInt, _sWord:String):Void {

				var _oLine : VarObj = ExtractLines.extractLineObj(_oSBloc, _sLine, _sWord, Text.nCurrentIndex, _nLineNum); //var //return 
				if(_oLine != null){ //Ex : new Var eithout ini
					_oSBloc.pushLine(_oLine);
				}
						
						/*
						if (_nLineId == -2) {//Just initialisation :: var _oObj : Object;
							return _oSBloc;
						}
						if (_nLineId != -1) {
							analyseLine(aCurrentClassVar[_nLineId] );
							aCurrentBloc[cLineList].push(_nLineId);
						}else {
							Debug.fError("in extractLineId returning negative id : " + _sLine)
							var _aBug : Array<Dynamic> = _aBug[6];
						}*/
		}

		
		
		public static function extractLine( _oSBloc : SBloc, _sLine:String, _nLineNum : UInt):SBloc {
			if(_sLine != ""){
				var _sWord : String = Text.between3(_sLine, 0,EuBetween.Word);
				var _nIndex : Int;

				if(_sWord != null){ //Empty line
					
					var _oHaveNewBloc : SBloc = extractSBlocHeader(_oSBloc, _sLine, _sWord, _nLineNum );
					if ( _oHaveNewBloc != null) {  //New bloc (IF/ELSE/FOR/ETC)
						return _oHaveNewBloc; 		//Change current bloc to the new one
					}else{
						//Normal line    Not( For //while //if )
								
						if (Setting.bDoTryCatch){
							
							try {
					
								extractLineObjTry(_oSBloc, _sLine, _nLineNum, _sWord);
							} catch (err:String) {
								Debug.fBreak();
								if (err.charAt(0) == ":") { //My errors
								}else {
									throw err; //throw away
								}
							}
							
						}else{
							
							extractLineObjTry(_oSBloc, _sLine, _nLineNum, _sWord);
							
						}
						
					
					}
				
				}else {
					
					//Check if is an end bloc "}"
					_nIndex = Text.search(_sLine, "}");
					if (_nIndex >= 0) {
						_oSBloc.nLastLine = _nLineNum;
						//End of bloc, if it's not the main bloc goto parent
						if (_oSBloc.oParentBloc != null) {
							
							//Search for else
							_sWord = Text.between3(_sLine, _nIndex + 1,EuBetween.Word);
				
							if (_sWord == "else") { 
								_sWord = Text.between3(_sLine, Text.nCurrentIndex + 1,EuBetween.Word);
								if (_sWord == "if") { //else if wit space
									_oSBloc = makeElseIfStatement(_oSBloc, _sLine, _nLineNum);
								}else {
									_oSBloc = makeElseStatement(_oSBloc, _nLineNum);
								}
								
							} else if (_sWord == "elseIf") { //Not used for now
								_oSBloc = makeElseIfStatement(_oSBloc, _sLine, _nLineNum);
								
							}else { //No else
								
								//pushLastLineOfBloc();
					
								//Go to current bloc parent
								//nBlocIndex --;
								//aCurrentBloc = aCurrentBloc[cLineConBlocParent];
								_oSBloc = _oSBloc.oParentBloc;
							}
								
						}else { //Main bloc end of function
				
							//Debug.trac("END FUNCTION!!!")
							return null;
						}
					}
				}

			}	
			
			//Show comment
			if (Text.sShowComment != "") {
				var _oComment : VarComment = new VarComment(Text.sShowComment);
				_oSBloc.pushLine(_oComment);
				Text.sShowComment = ""; //Usless?
			}
			if (Text.sCppLine != "") {
				Text.sCppLine = Text.fTrim(Text.sCppLine);
				if (Text.sCppLine != "") {
					var _oCpp : VarCppLine = new VarCppLine(Text.oCurrentBalise, Text.sCppLine, Text.eCppLineType);
					if(Text.eCppLineType == EuCppLineType.Glsl){ //Glsl
						Text.oCurrentBalise.pushLine(_oCpp);
					}else { //Cpp
						_oSBloc.pushLine(_oCpp);
					}
					
					Text.sCppLine = ""; //Usless?
				}
			}
			
			return _oSBloc;
		}
		
		//If found new bloc then return it
		private static function extractSBlocHeader(_oSBloc:SBloc, _sLine:String, _sFirstWord : String, _nLineNum : UInt):SBloc {
			
			try {
			
				var _nIndex : Int;
				switch (_sFirstWord) {
				
					//Make condition if while for
					case "if" :
						//Todo Find "{" else create an error
						//nBlocIndex ++;
						_nIndex  = Text.search(_sLine, "(", Text.nCurrentIndex);
						if (_nIndex >= 0) {
							var _oNewBloc : SBloc = makeIfStatement(_oSBloc, Text.between3(_sLine, _nIndex + 1, EuBetween.Priority ),_nLineNum );
							_oSBloc.pushLine(_oNewBloc);
							return _oNewBloc;
							
						}else {
							Debug.fError("No () after If statement");
						}
						
						

					
					//break;
					
					case "for" :
			
						_nIndex  = Text.search(_sLine, "(", Text.nCurrentIndex);
						if (_nIndex >= 0) {
							var _oNewBlocFor : SBloc = makeForStatement(_oSBloc, Text.between3(_sLine, _nIndex + 1, EuBetween.Priority ),_nLineNum );
							_oSBloc.pushLine(_oNewBlocFor);
							return _oNewBlocFor;
							
						}else {
							Debug.fError("No () after For statement");
						}
				
						
				
						
					//break;
					
					case "forEach" :
					
						_nIndex  = Text.search(_sLine, "(", Text.nCurrentIndex);
						if (_nIndex >= 0) {
							var _oNewBlocForEach : SBloc = makeForEachStatement(_oSBloc, Text.between3(_sLine, _nIndex + 1, EuBetween.Priority ),_nLineNum );
							_oSBloc.pushLine(_oNewBlocForEach);
							return _oNewBlocForEach;
						}else {
							Debug.fError("No () after ForEach statement");
						}
						
						
					//break;
					
					
					case "switch" :
						_nIndex  = Text.search(_sLine, "(", Text.nCurrentIndex);
						if (_nIndex >= 0) {
							var _oBlocNewSwitch : SBloc = makeSwitchStatement(_oSBloc, Text.between3(_sLine, _nIndex + 1, EuBetween.Priority ),_nLineNum );
							_oSBloc.pushLine(_oBlocNewSwitch);
							return _oBlocNewSwitch;
						} else {
							Debug.fError("No () after switch statement");
						}
						
					
					//break;
					case "switchCast" :
						_nIndex  = Text.search(_sLine, "(", Text.nCurrentIndex);
						if (_nIndex >= 0) {
							var _oBlocNewSwitch : SBloc = makeSwitchCastStatement(_oSBloc, Text.between3(_sLine, _nIndex + 1, EuBetween.Priority ),_nLineNum );
							_oSBloc.pushLine(_oBlocNewSwitch);
							return _oBlocNewSwitch;
						} else {
							Debug.fError("No () after switch statement");
						}
				
					
					//break;
					
							
					case "case" :
						_nIndex  = Text.search(_sLine, "(", Text.nCurrentIndex);
						if (_nIndex >= 0) {
							var _oBlocNewSwitch : SBloc = makeCaseStatement(_oSBloc, Text.between3(_sLine, _nIndex + 1, EuBetween.Priority ),_nLineNum );
							_oSBloc.pushLine(_oBlocNewSwitch);
							return _oBlocNewSwitch;
						} else {
							Debug.fError("No () after case statement");
						}
						
					
					
					/*
						var _nStartIndex : UInt = Text.nCurrentIndex;
						_nIndex  = Text.search(_sLine, ":", Text.nCurrentIndex);
						if (_nIndex >= 0) {
							var _oBlocNewSwitch : SBloc = makeCaseStatement(_oSBloc, _sLine.substring(_nStartIndex, _nIndex) ,_nLineNum );
							_oSBloc.pushLine(_oBlocNewSwitch);
						} else {
							Debug.fError("No ':' on the case statement");
						}
						return _oBlocNewSwitch;
					*/
					//break;
					
					
					
										
					case "while" :

						_nIndex  = Text.search(_sLine, "(", Text.nCurrentIndex);
						if (_nIndex >= 0) {
							var _oNewBlocWhile : SBloc = makeWhileStatement(_oSBloc, Text.between3(_sLine, _nIndex + 1, EuBetween.Priority ),_nLineNum );
							_oSBloc.pushLine(_oNewBlocWhile);
							return _oNewBlocWhile;

							
						}else {
							Debug.fError("No () after For statement");
						}
			
						
						
					//break;

				}
				return null;
			
			} catch (err:String) {
				if (err.charAt(0) == ":") { //My errors
					//Debug.fError("Func Internal Error: " + err.message);
				}else {
					throw err; //throw away
				}
			}
			
			return null;
		}
				
		
		
		
		private static function makeIfStatement(_oSParentBloc:SBloc, _sLine : String, _nLineNum:UInt):LogicIf {
			
			var _oLogicIf : LogicIf = new LogicIf(_oSParentBloc);
			_oLogicIf.oObjIf = logicalToLine(_oLogicIf, _sLine, _nLineNum);
			return _oLogicIf;
			
			//Insert
			//aCurrentBloc[cLineList].push(_nLineId);
				
		//	newConditionnalBloc(_nLineId, aCurrentBloc);
			//aCurrentLine[cSBlocPushToEnd] = []; //Important
		}
		
		private static function makeElseStatement(_oIfBloc:SBloc, _nLineNum:UInt):LogicElse {
			var _oLogicIf : LogicIf = cast(_oIfBloc);
			var _oLogicElse : LogicElse = new LogicElse( _oLogicIf.oParentBloc );
			_oLogicElse.oPrecIf = _oLogicIf;
			
			_oLogicIf.oBlocElse = _oLogicElse;
			if(	_oLogicIf.eType  ==  EuVarType._LogicIf){ //little optimisation for only if else on runtime later
				_oLogicIf.eType = EuVarType._LogicIfElse; //Change type, maybe recreate is better??
			}
			return _oLogicElse;
		}
		
		
		private static function makeElseIfStatement(_oIfBloc:SBloc, _sLine : String, _nLineNum:UInt):LogicIf {
			var _nIndex : Int  = Text.search(_sLine, "(", Text.nCurrentIndex);
			if (_nIndex >= 0) {
			
				var _oPrecIf : LogicIf = cast(_oIfBloc);
				
				var _oNewElseIf : LogicIf = new LogicIf(_oPrecIf.oParentBloc);
				_oNewElseIf.oObjIf = logicalToLine(_oNewElseIf,  Text.between3(_sLine, _nIndex + 1, EuBetween.Priority ) , _nLineNum);
				_oNewElseIf.eType = EuVarType._LogicElseIf;
				_oNewElseIf.oPrecIf = _oPrecIf;
				
				_oPrecIf.oBlocElse = _oNewElseIf;
				if(	_oPrecIf.eType  ==  EuVarType._LogicIf){ //Normal if change state ElseIf keeep same state
					_oPrecIf.eType =  EuVarType._LogicIfElseIf;
				}
				
				return _oNewElseIf;
			}
			var _aError : Array<Dynamic>=[];_aError = _aError[5];//Bug
			return null;
		}
		
		
		
		
		private static function makeForStatement(_oSParentBloc:SBloc, _sLine : String, _nLineNum:UInt):LogicFor {
			
			var _oLogicFor : LogicFor = new LogicFor(_oSParentBloc);
			
			var _aSplit  :Array<Dynamic> = _sLine.split(";");
			
			var _sIni : String  = _aSplit[0];
			
			_oLogicFor.oIni = ExtractLines.extractLine( _oLogicFor, _sIni, _nLineNum); //Todo test if its a LineInput
			
			
			var _sCond : String  = _aSplit[1];
			_oLogicFor.oCond = logicalToLine(_oLogicFor, _sCond, _nLineNum);
			
			var _sIncDec : String  = _aSplit[2];//Todo test if _sIncDec is empty
			_oLogicFor.oIncDec = ExtractLines.extractLine( _oLogicFor, _sIncDec, _nLineNum);
			
			return _oLogicFor;
		}
		
		
		private static function makeForEachStatement(_oSParentBloc:SBloc, _sLine : String, _nLineNum:UInt):LogicForEach {
			return  new LogicForEach(_oSParentBloc, _sLine, _nLineNum);
		}
		
		private static function makeSwitchStatement(_oSParentBloc:SBloc, _sLine : String, _nLineNum:UInt):LogicSwitch {
			return  new LogicSwitch(_oSParentBloc, _sLine, _nLineNum);
		}
				
		private static function makeSwitchCastStatement(_oSParentBloc:SBloc, _sLine : String, _nLineNum:UInt):LogicSwitchCast {
			return  new LogicSwitchCast(_oSParentBloc, _sLine, _nLineNum);
		}
			
		private static function makeCaseStatement(_oSParentBloc:SBloc, _sLine : String, _nLineNum:UInt):LogicCase {
			return  new LogicCase(_oSParentBloc, _sLine, _nLineNum);
		}
		
		private static function makeWhileStatement(_oSParentBloc:SBloc, _sLine : String, _nLineNum:UInt):LogicWhile {
			
			var _oLogicWhile : LogicWhile = new LogicWhile(_oSParentBloc);
			_oLogicWhile.oCond = logicalToLine(_oLogicWhile, _sLine, _nLineNum);
			return _oLogicWhile;
		}
		
		
		/*
		
		private static function newConditionnalBloc(_nLineId : UInt, _aSetParentBloc:Array<Dynamic>):Void {
			
			//New conditionnal Bloc "{"	
			aCurrentLine = aCurrentClassVar[_nLineId]; 
			
			aCurrentLine[cLineConBlocParent] = _aSetParentBloc;
			aCurrentBloc = aCurrentLine;
			aCurrentBloc[cLineList] = [];
		}
		*/
		
		
		private static function logicalToLine(_oSBloc:SBloc, _sLine : String, _nLineNum:UInt):VarObj {
			
			try{
			
				var _sFirstPart : String;
				var _bHaveOrOpp : Bool = false;
				var _sFullAndSecondPart : String;
				var _aMultilogical : Array<Dynamic> = []; //LogicalObj
				var _aOpperator : Array<Dynamic> = [];
				
				
				//var _oCurrentLine : LogicalObj = new LogicalObj();
				
				//Make multiple if (&& ||)
				
				var bGo : Bool = true;
				_sFullAndSecondPart = _sLine; //if(   (_sPriority)  &&  etc   )
				while (bGo) {
					
				
					_sFirstPart = Text.between3(_sFullAndSecondPart, 0, EuBetween.MultiLogical);  //search for "&& || (" else is Null
					
					
					///////////////Priority///////////////////
				/*
					if (Text.nMultiLogical == EuMultiLogical.Priority) { //if(  (
																															 //if(  (5 == 0 && 8 == 2)  &&  etc   )
						var _sPriority : String = Text.between3(_sFullAndSecondPart, Text.nCurrentIndex, EuBetween.Priority); //if(   (_sPriority)  &&  etc   )
						var _nIndex : Int =  Text.nCurrentIndex;
					
						 var _oInsidePriorityLine : VarObj  = logicalToLine(_oSBloc, _sPriority, _nLineNum); //if(  5 + _oInsidePriorityLine  &&  etc   )    //Recursive priority
						
						 _sFirstPart = Text.between3(_sFullAndSecondPart, _nIndex,  EuBetween.MultiLogical);  //  search for  && or || etc   )
						 Debug.trace3("_sFullAndSecondPart : " + _sFullAndSecondPart);
						 Debug.trace3("_sFirstPart : " + _sFirstPart);
						 Debug.trace3("Text.nMultiLogical  : " + Text.nMultiLogical );
						 
						 //TODO test _sFirstPart, it must be null
						if (Text.nMultiLogical == EuMultiLogical.Priority) {
							//bug
							Debug.fError("another Conditionnal priority follow a priority")
							 var _aBug:Array<Dynamic> = _aBug[8];
						 }
						 
						 //PushVar
						 _aMultilogical.push(_oInsidePriorityLine);
						 _aOpperator.push(Text.nMultiLogical);
						 
						 //NextCycle
						 _sFullAndSecondPart =  _sFullAndSecondPart.substring(Text.nCurrentIndex, _sFullAndSecondPart.length); //Get part after  "&& || "
						  Debug.trace3("Next  : " + _sFullAndSecondPart );
						 
					}else{
					*/
					/////////////////////////////////////////
					 
					//TODO Useless () make buf
						
						if (_sFirstPart != null) { //Get "&& || " else is Null     
							//////////////////////
							//We have && / ||	//
							//////////////////////
							_sFullAndSecondPart =  _sFullAndSecondPart.substring(Text.nCurrentIndex, _sFullAndSecondPart.length); //Get part after  "&& || "
							
							//Normal
							var _oCompare : CompareObj  = logicalCompareExtract(_oSBloc, _sFirstPart, _nLineNum); //Recursive function priority
							_aMultilogical.push(_oCompare);
							_aOpperator.push(Text.nMultiLogical);
						
							if (Text.nMultiLogical ==  EuMultiLogical.Or) {
								_bHaveOrOpp = true;
							}
							
							
						}else {     //No "&& || " 
							/////////////
							//One logic//
							/////////////
							
							//Normal
							var _oSingleCompare : CompareObj  = logicalCompareExtract(_oSBloc, _sFullAndSecondPart, _nLineNum); //Recursive function priority
							_aMultilogical.push(_oSingleCompare);
							
							bGo = false; //End
						}
					//}
					
				}
				
		
				//Make multi
				//var _oLogicalAndGroup : LogicalObj;
				var _oLogicalAndGroup : LogicalObj  = new LogicalObj();
				if (_aMultilogical.length > 1) {
					
					if (_bHaveOrOpp) {
						/////////////////
						//Make OR group//
						/////////////////
						
						//Create logical OR group
						var _oLogicalOrGroup : LogicalObj = new LogicalObj();
						_oLogicalOrGroup.eType = EuVarType._LogicalOR;
						if(_aOpperator[0] ==  EuMultiLogical.Or){
							_oLogicalOrGroup.pushVar(_aMultilogical[0]); //Push firstVar
						}
						
						//Convert in subgroup for OR opperator (makeAndPriority) ///////////////
						//Convert	if(  6 == 6  ||   1 == 1 && 1 == 1  ||   2 == 2 && 2 == 2	)	
						//To		if(  6 == 6  ||  (1 == 1 && 1 == 1) ||  (2 == 2 && 2 == 2)	)										

						var bAndFound : Bool = false;
						var _i:UInt = _aOpperator.length;
						for (i in 0 ..._i) {
							
							if (_aOpperator[i] ==  EuMultiLogical.And) {
								
								if (!bAndFound) {
									bAndFound = true;
									//Create logical AND group
									_oLogicalAndGroup  = new LogicalObj();
									_oLogicalAndGroup.eType = EuVarType._LogicalAnd;
									_oLogicalAndGroup.pushVar(_aMultilogical[i]);
									
									
									//Push it in the OR group
									_oLogicalOrGroup.pushVar(_oLogicalAndGroup);
								}
								_oLogicalAndGroup.pushVar(_aMultilogical[i+1]);
								
							}else  { //bAndFound + EuMultiLogical.Or --> create AND group
								bAndFound = false;
								//Next is not AND or last var 
								if( i+1  == _aOpperator.length || _aOpperator[i+1] !=  EuMultiLogical.And){
									//Push in the OR group
									_oLogicalOrGroup.pushVar(_aMultilogical[i + 1]);
								}
							}
						}
						return _oLogicalOrGroup;
						
						
					}else {
						/////////////////////
						///Only AND group ///
						/////////////////////
						
						//Create logical AND group
						var _oLogicalOnlyAndGroup : LogicalObj = new LogicalObj();
						_oLogicalOnlyAndGroup.eType = EuVarType._LogicalAnd;
						var _i : Int = _aMultilogical.length;
						for (i in 0 ... _i) {
							_oLogicalOnlyAndGroup.pushVar(_aMultilogical[i]);
						}
						return _oLogicalOnlyAndGroup;
						///////////////////////////////////////
					}
					
			
				}else { 
					/////////////////////
					///Single Compare ///
					/////////////////////
		
					//No multilogical
					return _aMultilogical[0]; //Return CompareObj
				}
				
			
			} catch (err : String ) {

				if (err.charAt(0) == ":") { //My errors
					//Debug.fError("Func Internal Error: " + err.message);
				}else {
					throw err; //throw away
				}
			}

			return null;
		}
		

		
		private static function logicalCompareExtract(_oSBloc:SBloc, _sLine : String, _nLineNum:UInt):CompareObj {
			
			var _oCompare : CompareObj = new CompareObj();
			
			var _sFirstPart : String = Text.between3(_sLine, 0, EuBetween.Logical);
			if (_sFirstPart != null) {
				
				
				var _sSecondPart : String = _sLine.substring(Text.nCurrentIndex, _sLine.length);
				
				
				
				_oCompare.eOpp = Text.eLogicalOpp;
				
				_oCompare.oLineLeft = ExtractLines.newLineSet(_oSBloc, _sFirstPart, _nLineNum, EuVarType._None,null,false,EuOperator.None);
				_oCompare.oLineRight =  ExtractLines.newLineSet(_oSBloc, _sSecondPart, _nLineNum,EuVarType._None,null,false,EuOperator.None);
				
				//Type resolve //
				_oCompare.oResultingType = TypeResolve.findDominantResultBetween(_oCompare.oLineLeft, _oCompare.oLineRight);
				if (TypeResolve.getResultingType(_oCompare.oLineLeft).eType !=  _oCompare.oResultingType.eType ) {
					_oCompare.oConvertLeft = _oCompare.oResultingType;
				}
				if (TypeResolve.getResultingType(_oCompare.oLineRight).eType !=  _oCompare.oResultingType.eType ) {
					_oCompare.oConvertRight = _oCompare.oResultingType;
				}
				///////////////
	
				
				 return _oCompare;
				 

			}else {
				//SingleValue push
				//add != 0 
				//TODO check if its the nagate version like : if (!oWindow.keyIsDown( 0x25 ) ) { //LEFT
				
				_oCompare.eOpp = EuOperator.LogicNotEgal;
				_oCompare.oLineLeft = ExtractLines.newLineSet(_oSBloc, _sLine, _nLineNum, EuVarType._None,null,false,EuOperator.None);
				_oCompare.oLineRight =  ExtractLines.newLineSet(_oSBloc, "0", _nLineNum, EuVarType._None,null,false,EuOperator.None); //TODO optimize this put direcly the var
				
				return _oCompare;
				
			}
		}
		
		
		public static function fExtractBetweenFunction(_oSClass : SClass):Void {
			
			oCurrSClass = _oSClass;
			//Extract all line in each function 
			var _aFile : Array<Dynamic>  =   _oSClass.aFile;
			var _nTotalLine : UInt = _aFile.length;
			var _aFunctionList : Array<Dynamic> = _oSClass.aFunctionList;
			var _i:UInt = _aFunctionList.length;
			for (i in 0 ..._i) {
				var _oFunction : SFunction = _aFunctionList[i];
				if(!_oFunction.bDefaultConstructor){
					var _nLastLine : UInt = _nTotalLine;
					if (i + 1 < _i) {
						_nLastLine = cast(_aFunctionList[i + 1],SFunction).nLine;
					}
					var _nStartLine : UInt = _oFunction.nLastLine + 1;
					for (j in _nStartLine ... _nLastLine) {
						Text.removeComments(_aFile[j], _oSClass, true); //To get special cpp between fonctions
						Text.bCommentFlag = false;
					}
				}
			}
		}
		
		
		
		
		/////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////// PreExtract //////////////////////
		
		/*
		public static function fPreExtractFunction(_oSFunction:SFunction) {
			if (_oSFunction.eFuncType != EuFuncType.Extend) { //Do make empty extend function list
					//New function main bloc
				var _oSClass : SClass = _oSFunction.oSClass;
				var _oSBloc : SBloc = SBloc(_oSFunction);
				ExtractBlocs.oCurrSClass = _oSClass;
				
				var _aFile : Array<Dynamic> = _oSClass.aFile;
				var _nCurentLine : UInt = _oSFunction.nLineNum - 1;
				var _nTotalLines : UInt = _aFile.length;
					
			
				//Read file until reach end of function or the end of file
				while (_nCurentLine < _nTotalLines) {
					_nCurentLine ++;
					ExtractBlocs.nCurrLine = _nCurentLine;
					
					_oSBloc = fPreExtractLine( _oSBloc, Text.removeComments( _aFile[_nCurentLine]), _nCurentLine + 1);
					if (_oSBloc == null) {
						//break;
					}
				}

				if (_nCurentLine == _nTotalLines) {
					Debug.fError("Endless function")
				}
				
				ExtractBlocs.nCurrLine = -1;
			}
		}
		
		private static function fPreExtractLine( _oSBloc : SBloc, _sLine:String, _nLineNum : UInt):SBloc {
			if(_sLine != ""){
				var _sWord : String = Text.between3(_sLine, 0);
				var _nIndex : Int;

				if(_sWord != null){ //Empty line
					
					var _oHaveNewBloc : SBloc = ExtractBlocs.extractSBlocHeader(_oSBloc, _sLine, _sWord, _nLineNum );
					if ( _oHaveNewBloc != null) {  //New bloc (IF/ELSE/FOR/ETC)
						return _oHaveNewBloc; 		//Change current bloc to the new one
					}else{
						//Normal line    Not( For //while //if )
					}
				}else {
					
					//Check if is an end bloc "}"
					_nIndex = Text.search(_sLine, "}");
					if (_nIndex >= 0) {
						_oSBloc.nLastLine = _nLineNum;
						//End of bloc, if it's not the main bloc goto parent
						if (_oSBloc.oParentBloc != null) {
							
							//Search for else
							_sWord = Text.between3(_sLine, _nIndex + 1);
				
							if (_sWord == "else") { 
								_sWord = Text.between3(_sLine, Text.nCurrentIndex + 1);
								if (_sWord == "if") { //else if wit space
									_oSBloc = makeElseIfStatement(_oSBloc, _sLine, _nLineNum);
								}else {
									_oSBloc = makeElseStatement(_oSBloc, _nLineNum);
								}
								
							} else if (_sWord == "elseIf") { //Not used for now
								_oSBloc = makeElseIfStatement(_oSBloc, _sLine, _nLineNum);
								
							}else { //No else
								
								//pushLastLineOfBloc();
					
								//Go to current bloc parent
								//nBlocIndex --;
								//aCurrentBloc = aCurrentBloc[cLineConBlocParent];
								_oSBloc = _oSBloc.oParentBloc;
							}
								
						}else { //Main bloc end of function
				
							//Debug.trac("END FUNCTION!!!")
							return null;
						}
					}
				}
			}	
			
			//Show comment
			if (Text.sShowComment != "") {
				var _oComment : VarComment = new VarComment(Text.sShowComment);
				_oSBloc.pushLine(_oComment);
				Text.sShowComment = ""; //Usless?
			}
			if (Text.sCppLine != "") {
				Text.sCppLine = Text.fTrim(Text.sCppLine);
				if (Text.sCppLine != "") {
					var _oCpp : VarCppLine = new VarCppLine(Text.sCppLine, Text.eCppLineType);
					_oSBloc.pushLine(_oCpp);
					Text.sCppLine = ""; //Usless?
				}
			}
			
			return _oSBloc;
		}*/
		

		

	}

