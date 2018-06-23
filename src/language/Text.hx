package language;
	import language.enumeration.EuBetween;
	import language.enumeration.EuCppLineType;
	import language.enumeration.EuMultiLogical;
	import language.enumeration.EuOperator;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.vars.logicObj.ScopeBalise;
	import language.vars.varObj.VarCppLine;
	import language.base.Debug;
	

	class Text {
		
		private static var aLogicalList : Array<Dynamic> = ["==", "!=", "<=", ">=", ">", "<"]; //Must be in "length" order
		private static var aCodeList : Array<Dynamic> = [".", "(", ")", "{", "}", "[", "]", "+", "-", "/", "%", "*", "&", "|", "\"", ",", "<", ">"];


		public static var sBaliseEnder : String = ""; // </Cpp , </glsl
		
		public static var oCurrentBalise : ScopeBalise ; //if <Cpp> </Cpp> is encoutered
		
		
		public static var bCppFlag : Bool = false; //if <Cpp> </Cpp> is encoutered
		public static var bCommentFlag : Bool = false; //if /* is encoutered
		public static var nCurrentIndex : UInt = 0;
		
		public static var sShowComment : String = "";
		public static var sCppLine : String = "";
		public static var eCppLineType : EuCppLineType ;
		public static var nBaliseEnd : Int = 0;
		
		
		public static function fIniFile(){
			bCppFlag = false;
			bCommentFlag = false;
			sShowComment = "";
			sCppLine = "";
			eCppLineType = EuCppLineType.Normal;
			nBaliseEnd  = 0;
		}
		
		//Return the string without comments
		public static function removeComments(_sLine : String, _oSBloc : SBloc = null, _bInsideClass:Bool = false, _bInfunction : Bool = false ) : String {
			var _nId : Int;
			sShowComment = ""; //Remove strange bogue (OK?)
			sCppLine = "";
	
			//If we are inside a comment found the end */
			if (bCommentFlag == true) {
				_nId = search(_sLine, "*/");
				
				//Found a */
				if (_nId >= 0) {
					_sLine =  _sLine.substr(_nId + 2, _sLine.length);
					bCommentFlag = false;
				}else {
					//Else is nothing
					return "";
				}
			}
			//If we are inside a cpp code found the end </Cpp>
			if (bCppFlag == true) {
				
				_nId = search(_sLine, sBaliseEnder);
		
				//Found a </cpp>
				if (_nId >= 0) {
					eCppLineType = EuCppLineType_.fTextToType(Text.between3(_sLine, _nId + 2, EuBetween.Template), _bInsideClass);
					sCppLine +=  _sLine.substr(0, _nId);
					
					var _nEndedEnd : Int =  Text.search(_sLine, ">", _nId);
					if (_nEndedEnd < 0) {
						Debug.fError("Ender Tag without ending '>'");
					}
					_nEndedEnd += 1;
						
					_sLine =  _sLine.substr(_nEndedEnd, _sLine.length);
					bCppFlag = false;
					
				}else {
					sCppLine +=  _sLine;
					//Else is nothing
					fPushClassCode(_oSBloc,_bInfunction);
					return "";
				}
			}
			
			
			//If we are not inside a comment /* */
			if (bCommentFlag == false) {
				_nId = search(_sLine, "//");
				
				//Found a //
				if (_nId >= 0) {
					if (_sLine.length > 2 && _sLine.charAt(_nId + 2) == "!") { //Show Comment
						  sShowComment = _sLine.substr(_nId + 3);
					}
					_sLine = _sLine.substr(0, _nId);
				}
				

				//Found a /* after string cutted (//)
				_nId  = search(_sLine, "/*");
				while (_nId >= 0) {
					
					//check if we not have */ just after in same line
					var _nIdEnd : Int = search(_sLine, "*/");
					if (_nIdEnd >= 0) {
						
						//Save last part
						_sLine = _sLine.substr(0, _nId) + _sLine.substr(_nIdEnd + 2, _sLine.length);
						
					}else {
						
						_sLine = _sLine.substr(0, _nId);
						bCommentFlag = true;
						break;
					
					}
					
					//Loop 
					_nId  = search(_sLine, "/*", _nId);
				}
				
				//Found a /* after string cutted (//)
				_nId  = fFindStartBalise(_oSBloc, _sLine); //Todo thest prec word if not word for template
			
				
				
				
				while (_nId >= 0) { //Find a starting Tag  (In one line recursive)
					
					
					//var _nBaliseEnd : Int = search(_sLine, sBaliseEnder);
					eCppLineType = EuCppLineType_.fTextToType(Text.between3(_sLine, _nId + 1, EuBetween.Template), _bInsideClass); //+1 <
					
					
					
					
					//check if we not have */ just after in same line
					var _nIdEnd : Int = search(_sLine, sBaliseEnder, nBaliseEnd); //Search for ender balise </cpp>
					if (_nIdEnd >= 0) {
						eCppLineType = EuCppLineType_.fTextToType(Text.between3(_sLine, _nId + 2, EuBetween.Template), _bInsideClass); //+2 </
						
						sCppLine +=  _sLine.substr(nBaliseEnd, _nIdEnd);
						
						
					
						var _nEndedEnd : Int =  Text.search(_sLine, ">", _nId);
						if (_nEndedEnd < 0) {
							Debug.fError("Ender Tag without ending '>'");
						}
						_nEndedEnd += 1;
						
						
						//Save last part
					//	_sLine = _sLine.substr(0, _nId) + _sLine.substr(_nIdEnd + 6, _sLine.length); //+6? </cpp>
						_sLine = _sLine.substr(0, _nId) + _sLine.substr(_nEndedEnd, _sLine.length); //+6? </cpp>
						
						
						
					}else { //No ender balise </ after <cpp>
					
						sCppLine +=  _sLine.substr(nBaliseEnd, _sLine.length);
									
						_sLine = _sLine.substr(0, _nId); //Save what was before  <cpp>
						
						bCppFlag = true;
						break;
					
					}
					
					//Loop 
					_nId  = fFindStartBalise(_oSBloc, _sLine, _nId); //Todo thest prec word if not word for template
				}
			}
			
			fPushClassCode(_oSBloc,_bInfunction);
			return _sLine;
		}
		
		
		public static function fFindStartBalise(_oSBloc:SBloc, _sLine:String, _nStartIndex:UInt = 0):UInt { //If _oSClass is set class specified by param
			var _nId : Int  = search(_sLine, "<cpp",  _nStartIndex); //Todo thest prec word if not word for template
			if (_nId < 0) {
				_nId = search(_sLine, "<glsl",  _nStartIndex); //also glsl
				if (_nId >= 0) { //Is Glsl
					sBaliseEnder =  "</glsl";
				}
			}else { 			//Is Cpp
				sBaliseEnder =  "</cpp";
			}
			
			//We found a balise
			if (_nId >= 0) {
				if (_oSBloc != null) {
					oCurrentBalise = new ScopeBalise(_oSBloc, _sLine, _nId + 1);
					_oSBloc.pushLine(oCurrentBalise);
				}
			}
			if (_nId < 0 ) {
					return _nId;
				
			}
			
			nBaliseEnd =  Text.search(_sLine, ">", _nId);
			if (nBaliseEnd < 0) {
				Debug.fError("Tag without ending '>'");
			}
			nBaliseEnd += 1;
			
			return _nId;
		}
		
		
		
		public static function fPushClassCode(_oSBloc:SBloc, _bInFunction:Bool) { //If _oSClass is set class specified by param
			if (!_bInFunction && _oSBloc != null && 	_oSBloc.oSFunction == null) { //not in a function
				var _oSClass : SClass = _oSBloc.oSClass;
				if (Text.sCppLine != "") {
					Text.sCppLine = Text.fTrim(Text.sCppLine);
					if (Text.sCppLine != "") {
						_oSClass.fPushCppLine(Text.sCppLine, eCppLineType);
						Text.sCppLine = ""; //Usless?
					}
				}
			}
		}
		
																					//EuBetween.Word
		public static function between1(_sString : String, _sBegin:String, _eBetween:EuBetween, _sEnd_Custom_Word : String = "", _nMinLetter : UInt = 1):String {
			
			var _nIndex : Int = search(_sString, _sBegin);
			if (_nIndex >= 0) {
				_nIndex += _sBegin.length;
				
				return uBetween(_sString, _nIndex, _eBetween , _sEnd_Custom_Word, _nMinLetter);
				
			}else {
				return null;
			}
			
			
		}
		
																										//EuBetween.Word
		public static function between2(_sString : String, _sBegin:String, _nBeginIndex:UInt, _eBetween:EuBetween, _sEnd_Custom_Word : String = "", _nMinLetter : UInt = 1):String {
			nCurrentIndex = _nBeginIndex;
			var _nIndex : Int = search(_sString, _sBegin, _nBeginIndex);
			if (_nIndex >= 0) {
				_nIndex += _sBegin.length;
				return uBetween(_sString, _nIndex, _eBetween, _sEnd_Custom_Word, _nMinLetter);
			}else {
				return null;
			}
		}
																						//EuBetween.Word
		//public static function between3(_sString : String, _nBeginIndex:UInt, _eBetween:EuBetween = 0, _sEnd_Custom_Word : String = "", _nMinLetter : UInt = 1):String {
		public static function between3(_sString : String, _nBeginIndex:UInt, _eBetween:EuBetween , _sEnd_Custom_Word : String = "", _nMinLetter : UInt = 1):String {
			nCurrentIndex = _nBeginIndex;
			return uBetween(_sString, _nBeginIndex, _eBetween, _sEnd_Custom_Word, _nMinLetter);
		}
																				//EuBetween.Word
		private static function uBetween(_sString : String, _nIndex:UInt, _eBetween:EuBetween, _sEnd_Custom_Word : String = "", _nMinLetter : UInt = 1):String {
			
			var _nStringLength : UInt = _sString.length;
				
			if (_nStringLength >= _nIndex + _nMinLetter) {
				
				var _sPart : String =  _sString.substring(_nIndex, _nStringLength);
				nCurrentIndex = _nIndex;
				
				switch (_eBetween) {
					
					case EuBetween.CodeDelim :
						return searchCode(_sPart, _nMinLetter);
					//break;
					case EuBetween.Word :
						return searchWord(_sPart, _nMinLetter);
					//break;
					case EuBetween.EndString :
						return searchEndString(_sPart, _nMinLetter);
					//break;
					case EuBetween.Numbers :
						return searchNumber(_sPart, _nMinLetter);
					//break;
					case EuBetween.Line :
						//LineEnd
						return searchEndLine(_sPart, _nMinLetter);
						//return _sPart;
					//break;
					case EuBetween.Priority :
						//Priority search ()
						return searchPriority(_sPart, _nMinLetter);
					//break;
					case EuBetween.Square :
						//Priority search ()
						return searchSquare(_sPart, _nMinLetter);
					//break;
					case EuBetween.Logical :
						//Priority search ()
						return searchLogical(_sPart, _nMinLetter);
					//break;
					case EuBetween.MultiLogical :
						//Priority search ()
						return searchMultiLogical(_sPart, _nMinLetter);	
					//break;
					case EuBetween.Template :
						//Priority search ()
						return searchTemplate(_sPart, _nMinLetter);
					//break;
					
					case EuBetween.Custom :
						//Custom end
						_nIndex = search(_sPart, _sEnd_Custom_Word);
						if (_nIndex >= 0) {
							nCurrentIndex += _nIndex;
							return _sPart.substring(0, _nIndex);
						}else {
							return null;
						}
					//break;
					
				}

			}
			return null;
		}
		
		public static function stringNotEmpty(_sPart : String):Bool {
			if (_sPart == null) {
				return false;
			}
			var _i:UInt = _sPart.length;
			for (i in 0 ..._i) {
				 var _sChar:String = _sPart.charAt(i);
				if (_sPart.charAt(i) != " " && _sPart.charCodeAt(i) != 9) { //9 For tab
					return true;
				}
			}
			
			return false;
		}
		
							 
					 /*
					 //Test if this if priority is not a function
					 var _sPrevChar : String = "(";
					 if (i != 0) {
						 _sPrevChar =_sPart.charAt(i-1);
					 }
			
					 
					 //If previous char is not from a function name then its a priority
					 if( !( (_sPrevChar > "A" && _sPrevChar < "Z") || (_sPrevChar > "a" && _sPrevChar < "z") || (_sPrevChar > "0" && _sPrevChar < "9")  ||  _sPrevChar == "_" )  ){
						 nCurrentIndex += i + 1; 
						 nMultiLogical = EuMultiLogical.Priority;  
						 return null;
					 }*/
					 
		
		public static var nMultiLogical : EuMultiLogical;
		private static function searchMultiLogical(_sPart : String, _nMinLetter:UInt):String {
			
			//Word end
			var  _sWord : String = "";
			var  _sChar : String = "";
			var  _sChar2 : String = "";
			var _bFound : Bool = false;
			var _sLogical : String;
			var _i:UInt = _sPart.length-1; //-1 because we seach a 2 caracter in a string
			nMultiLogical = EuMultiLogical.None;
		
			var _nInsidePriorityCount : UInt  = 0;
			
			
			for (i in 0 ..._i) {
				 _sChar = _sPart.charAt(i);
				if(_nInsidePriorityCount == 0){
					
					if (_sChar == "(") {
					  _nInsidePriorityCount ++;
					}
					if (_sChar == ")") {
					  Debug.fError("prematured end ) in searchMultiLogical : " + _sPart);
					  Debug.fStop();
					}
	
					 if (_sChar == "&" && _sPart.charAt(i + 1) == "&") {
						 nMultiLogical = EuMultiLogical.And;
						 
						 nCurrentIndex += i + 2;
						if (_sWord.length >=  _nMinLetter){
							return _sWord;
						}else {
							return null;
						}
						 
					 }
					 
					 if (_sChar == "|" && _sPart.charAt(i + 1) == "|") {
						  
						nMultiLogical = EuMultiLogical.Or;  
						  
						 nCurrentIndex += i + 2;
						if (_sWord.length >=  _nMinLetter){
							return _sWord;
						}else {
							return null;
						}
					 }

				}else {
					
					if (_sChar == "(") {
					  _nInsidePriorityCount ++;
					}
					if (_sChar == ")") {
					  _nInsidePriorityCount --;
					}
					
				}
				
				_sWord += _sChar;	
				
			}
			 
			return null;
	
		}
		
		//public static var eLogicalOpp : EuOperator = 0;
		public static var eLogicalOpp : EuOperator ;
	
		private static function searchLogical(_sPart : String, _nMinLetter:UInt):String {

				//Word end
				var  _sWord : String = "";
				var  _sChar : String = "";
				var  _sChar2 : String = "";
				var _bFound : Bool = false;
				var _sLogical : String = "";
				
				
				var i : Int = 0;
				var _i:UInt = _sPart.length;
				eLogicalOpp = EuOperator.None;
			
				while (i < _i) {
					 _sChar = _sPart.charAt(i);
					 
					 var j:UInt = 0;
					 var _j:UInt = aLogicalList.length;
					while (j < _j) {
					    _sLogical  =  aLogicalList[j];
						
						if (_sChar == _sLogical.charAt(0)) {
			
							if (_sLogical.length == 1) {
								if (_sPart.charAt(i + 1) == ">" || _sPart.charAt(i + 1) == "<") { //Shift instead of < > comparator
									_sWord += _sChar;
									i++;
									break;
								}
								_bFound = true;
								break;
							}else if(i + 1 < _i){
								_sChar2  = _sPart.charAt(i + 1);
								//Second char
								if (_sChar2 == _sLogical.charAt(1)) {
									_bFound = true;
									break;
								}
							}
								
						}
						j++;
					}
					
					if (_bFound) {
						//Convert to enum value
						switch(j) {
							case 0 :
								eLogicalOpp = EuOperator.LogicEgal;
							//break;			
							case 1 :
								eLogicalOpp = EuOperator.LogicNotEgal;
							//break;
							case 2 :
								eLogicalOpp = EuOperator.LogicInfEgal;
							//break;
							case 3 :
								eLogicalOpp = EuOperator.LogicSupEgal;
							//break;
							case 4 :
								eLogicalOpp = EuOperator.LogicSup;
							//break;
							case 5 :
								eLogicalOpp = EuOperator.LogicInf;
							//break;
						}
						
						nCurrentIndex += i + _sLogical.length;
						if (_sWord.length >=  _nMinLetter){
							return _sWord;
						}else {
							return null;
						}
					}else {
						_sWord += _sChar;
					}
					i++;
				}
	
				return null;	
		}
		
		
		public static var bCode : Bool = false;
		private static function searchCode(_sPart : String, _nMinLetter:UInt):String {
			
				//Word end
				var _sWord : String = "";
				
				var _i:UInt = _sPart.length;
				
				//Remove space before
				var i:Int = 0;
				while (_sPart.charAt(i) == " " || _sPart.charCodeAt(i) == 9) { //For tab
					i++;
				}
				
				
				//Code compare
				var _sChar : String = _sPart.charAt(i);
				var _j:UInt = aCodeList.length;
				for (j in 0 ... _j) {
					if (_sChar == aCodeList[j]) {
						bCode = true;
						nCurrentIndex += i + 1;
						return _sChar;
					}
				}
				
				bCode = false;
				
				
				while (i <  _i) {
					 _sChar = _sPart.charAt(i);
					if ((_sChar >= "a" && _sChar <= "z")|| (_sChar >= "A" && _sChar <= "Z") || (_sChar >= "0" && _sChar <= "9") || _sChar == "_") {
						_sWord += _sChar;
					}else {
						break;
					}
					i++;
				}
				nCurrentIndex += i;
				if (_sWord.length >=  _nMinLetter){
					return _sWord;
				}else {
					return null;
				}

			
		}
		
		private static function searchEndString(_sPart : String, _nMinLetter:UInt):String {
			
				//Word end
				var _sWord : String = "";
				var _sLastChar : String;
				var _sChar : String  = "";
				var _i:UInt = _sPart.length;
				
				//Check correct start
				var i:Int = 0;
				
				while (i < _i) {
					_sLastChar = _sChar;
					_sChar = _sPart.charAt(i);
					if (_sChar ==  "\"" && _sLastChar != "\\" ) {
						break;
					}else {
						_sWord += _sChar;
					}
					i++;
				}
				nCurrentIndex += i + 1;
				return _sWord;
		}
		
		private static function searchEndLine(_sPart : String, _nMinLetter:UInt):String {
			
				//Word end
				var _sWord : String = "";
				
				var _i:UInt = _sPart.length;
				
				//Check correct start
				var i:Int = 0;
				
				while (i < _i) {
					var _sChar : String = _sPart.charAt(i);
					if (_sChar !=  ";") {  //Todo check if it's not a ; in a String like ";"  TODO just check if we need ;
						_sWord += _sChar;
					}else {
						break;
					}
					i++;
				}
				nCurrentIndex += i + 1;
				return _sWord;
		}
		
		
		
		
		
		private static function searchPriority(_sPart : String, _nMinLetter:UInt):String {
	
				var _nIndex : Int  = 0;
				
				//Word end
				var _sWord : String = "";
				
				var _i:UInt = _sPart.length;
				
				//Check correct start
				var i:Int = 0;
				
				while (i < _i) {
					var _sChar : String = _sPart.charAt(i);
					if (_sChar ==  "("  ) {
						_nIndex ++;
					}else if (_sChar ==  ")" ) {
						if (_nIndex > 0) {
							_nIndex --;
						}else {
							break;
						}
					}	
					_sWord += _sChar;
					i++;
				}
				if (i == _i) {
					Debug.fError("error: no end ) in : " + _sPart);
					Debug.fStop();
					
				}
				
				nCurrentIndex += i + 1;
				return _sWord;
				
			
		}
		
		
		
		private static function searchTemplate(_sPart : String, _nMinLetter:UInt):String {
	
				var _nIndex : Int  = 0;
				
				//Word end
				var _sWord : String = "";
				
				var _i:UInt = _sPart.length;
				
				//Check correct start
				var i:Int = 0;
				
				while (i < _i) {
					var _sChar : String = _sPart.charAt(i);
					if (_sChar ==  "<") {
						_nIndex ++;
					}else if (_sChar ==  ">") {
						if (_nIndex > 0) {
							_nIndex --;
						}else {
							break;
						}
					}	
					_sWord += _sChar;
					i++;
				}
				if (i == _i) {
					Debug.fError("error: no end > in : " + _sPart);
					Debug.fStop();
					
				}
				
				nCurrentIndex += i + 1;
				return _sWord;
		}
		
		
		private static function searchSquare(_sPart : String, _nMinLetter:UInt):String {
	
				var _nIndex : Int  = 0;
				
				//Word end
				var _sWord : String = "";
				
				var _i:UInt = _sPart.length;
				
				//Check correct start
				var i:Int = 0;
				
				while (i < _i) {
					var _sChar : String = _sPart.charAt(i);
					if (_sChar ==  "[") {
						_nIndex ++;
					}else if (_sChar ==  "]") {
						if (_nIndex > 0) {
							_nIndex --;
						}else {
							break;
						}
					}	
					_sWord += _sChar;
					i++;
				}
				if (i == _i) {
					Debug.fError("error: : no end )");
				}
				
				nCurrentIndex += i + 1;
				return _sWord;
				
			
		}
		
		
		private static function searchWord(_sPart : String, _nMinLetter:UInt):String {
			
				//Word end
				var _sWord : String = "";
				
				var _i:UInt = _sPart.length;
				
				//Remove space before
				var i:Int = 0;
				while (_sPart.charAt(i) == " " || _sPart.charCodeAt(i) == 9) { //For tab
					i++;
				}
				
				while (i < _i) {
					var _sChar : String = _sPart.charAt(i);
					if ((_sChar >= "a" && _sChar <= "z")|| (_sChar >= "A" && _sChar <= "Z") || (_sChar >= "0" && _sChar <= "9") || _sChar == "_") {
						_sWord += _sChar;
					}else {
						break;
					}
					i++;
				}
				nCurrentIndex += i;
				if (_sWord.length >=  _nMinLetter){
					return _sWord;
				}else {
					return null;
				}
			
		}
		
		private static function searchNumber(_sPart : String, _nMinLetter:UInt):String {
			
				//Word end
				var _sWord : String = "";
				
				var _i:UInt = _sPart.length;
				
				//Remove space before
				var i:Int = 0;
				while (i < _i) {
					var _sChar : String = _sPart.charAt(i);
					if (_sChar >= "0" && _sChar <= "9") {
						_sWord += _sChar;
					}else {
						break;
					}
					i++;
				}
				nCurrentIndex += i;
				if (_sWord.length >=  _nMinLetter){
					return _sWord;
				}else {
					return null;
				}
			
		}
		
		
		public static function search(_sString : String, _sSearch:String, _nIndex : UInt = 0, _bAnalyseLString = false):Int {
			var _i:UInt = _sString.length;
			var _sFirst :String = _sSearch.charAt(0);
			var _nSearchLength : UInt = _sSearch.length;
			var _sChar1 : String;
			var _sChar2 : String;
			var _bInString : Bool = false;
	
			
			if (_nIndex > _sString.length) { //Error
				Debug.fError(" " + _sString + " Search : " +  _sSearch + " Index : " + _nIndex + " Length : " + _sString.length);
				Debug.fStop();
				return -2;
			}

			var i:Int = _nIndex;
			while (i < _i) {
				_sChar1 = _sString.charAt(i);
				
				if (_bInString) {
					if (_sChar1 ==  "\"") {
						_bInString = false;
					}
					
				}else{ 
					if (_sChar1 ==  "\"" && !_bAnalyseLString) {
						_bInString = !_bAnalyseLString;
					}else {
						
						//NORMAL
						if (_sChar1 == _sFirst) {
							
							var j:Int = 0;
							var _j:UInt = _nSearchLength;
							while(j < _j) {
								_sChar1 =  _sString.charAt(i + j);
								_sChar2 =  _sSearch.charAt(j);

								if (_sChar1 != _sChar2) {
									break;
								}
								
								j++;
							}
							if (j >= _j) {
								break;
							}
							
						}
					}
				}
				i++;
			}
			
			
			if (i == _i) {
				//Debug.trac("NotFound!!!");
				return -1;
			}else {
				return i;
			}	
		}
		
			/*
		public static function search2(_sString : String, _sSearch:String, _nIndex : UInt = 0):Int {
			var _i:UInt = _sString.length;
			var _sFirst :String = _sSearch.charAt(0);
			var _nSearchLength : UInt = _sSearch.length;
			var _sChar1 : String;
			var _sChar2 : String;
			
			for (var i:Int = _nIndex; i < _i) {
				_sChar1 = _sString.charAt(i);
				if (_sChar1 == _sFirst) {
					break
					
				}
				
			}
			if (i == _i+1) {

				return -1;
			}else {
				return i;
			}	
		}*/
		
		public static function surfaceSplit(_sLine : String, _sDelemiter : String):Array<Dynamic> {   //AVoid priority sub () like param
			var _aArray : Array<Dynamic> = [];
			var _sChar : String;
			var _nLevel : UInt = 0;
			var _nBegin : UInt = 0;
			var _bInString : Bool = false;
			
			var i : Int = 0;
			var _i:UInt = _sLine.length;
			while (i < _i) {
				_sChar =  _sLine.charAt(i);
				
				if (_bInString) {
					if (_sChar ==  "\"") {
						_bInString = false;
					}
					
				}else{ 
					if (_sChar ==  "\"") {
						_bInString = true;
					}else {
						//////////////////////////////////
						if (_sChar == ",") {
							if (_nLevel == 0) {
								_aArray.push(_sLine.substring(_nBegin, i) );
								_nBegin = i + 1;
							}
						}else if (_sChar == "("  || _sChar == "<") {
							_nLevel++;
							
						}else if (_sChar == ")" || _sChar == ">") {
							
							if(_nLevel > 0){
								_nLevel--;
							}else {
								Debug.fError("error: too much level of )");
								Debug.fStop();
							}
						}
						//////////////////////////////////
					}
				}
				i++;
			}
			
			//last
			_aArray.push(_sLine.substring(_nBegin, i) );
			return _aArray;
		}
		
		
		public static function removeSpaceBefore(_sString : String):String {
			if (_sString == null) {
				return "Null";
			}
		
			var i : UInt = 0;
			while (_sString.charCodeAt(i) < 33 && i < _sString.length) { //For tab
					i++;
			}
			return _sString.substring(i, _sString.length);
		}
				
		public static function removeSpaceAfter(_sString : String):String {
			if (_sString == null) {
				return "Null";
			}
		
			var i : Int = _sString.length-1;
			while (_sString.charCodeAt(i) < 33 && i >= 0) { // _sString.charCodeAt(i) == 9 &For tab
					i--;
			}
			return _sString.substring(0, i + 1);
		}
		
		public static function fTrim(_sString : String):String {
			return removeSpaceAfter(removeSpaceBefore(_sString));
		}
		
		
		public static function testNumber(_sString:String):Bool {
			
			//Hexadecimal
			if (_sString.charAt(0) == "0" && _sString.charAt(1) == "x") {
				return true;
			}
			
			var _i:UInt = _sString.length;
			for (i in 0 ..._i) {
				var _sChar : String = _sString.charAt(i);
				if (!(_sChar >= "0" && _sChar <= "9") && _sChar != "p") {  //p means convert to pixel TODO p must be last char
					return false;
				}

			}
			
			return true;
		}
		
		//Get length in "" of a string "abcd" 
		public static function getStringLength(_sString:String):Int {
			var  _nLength : UInt= 0;
			for (i in 0 ... _sString.length) {
				if (_sString.charAt(i) != "\\") {
					_nLength ++;	
				}
			}
			return _nLength;
		}
		
		
	
	}	
