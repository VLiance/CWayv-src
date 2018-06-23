package language;
	import language.enumeration.EuBetween;
	import language.enumeration.EuBit;
	import language.enumeration.EuOperator;
	import language.enumeration.EuSharing;
	import language.enumeration.EuVarType;
	import language.vars.varObj.CommonVar;
	import language.base.Debug;
	

	class TextType {
		
			public static function iniAllTypeVar(_oVar : CommonVar,  _sIniType:String ):Void  {
			

			/*
			//Check for class call. Class is now initialised
			if (_aCurrentVar[cVarListType] == cTypeCallClass) {
				//Put in cVarListClass 	class num
				//ex : private var oTest2 : Test2;
				
				var _sClass : String = _sIniType;
			
				//Priority to current project class if they have same name
				 if (aClassName[_sClass]  != null) {
					 
					  _aCurrentVar[cVarListClass] = aClassName[_sClass]; //Set the class id
					
				//Cpp check
				}else if(aCppClassName[_sClass] != null){
					 _aCurrentVar[cVarListClass] = aCppClassName[_sClass]; 
					_aCurrentVar[cVarListLocation] = cLocCPP

				 }else {
					 Debug.trac("Error, no class found for Global var ini : " + _aCurrentVar[cVarListName])
				 }
				
				

				
			}else if (_aCurrentVar[cVarListType] == cTypeRtu) {
				
				//rtuIni 
				_aCurrentVar[cVarListUnitRef] = getRtuInput( _sIniType );
				//_aCurrentVar[cVarListUnitLength] = nReturnRtuLength;
		
			}else if (_aCurrentVar[cVarListType] == cTypeQueueArray) {
				if(aCurrentClassQueueName[_sIniType] != null){
					var _nQueuId : UInt =  aCurrentClassQueueName[_sIniType];
					_aCurrentVar[cVarListQueueRef] = _nQueuId;
					_aCurrentVar[cVarListQueueBaseVar] = aCurrentClassQueue[_nQueuId][cQueueBaseVar];
				}else {
					Debug.fError("queueArray notfound : " + _sIniType);
					gbug();
				}
				
				
			}else if (_aCurrentVar[cVarListType] == cTypeQueueElement) {
				if(aCurrentClassQueueName[_sIniType] != null){
					var _nQueuId2 : UInt =  aCurrentClassQueueName[_sIniType];
					_aCurrentVar[cVarListQueueRef] = _nQueuId2;
					_aCurrentVar[cVarListQueueBaseVar] = aCurrentClassQueue[_nQueuId2][cQueueBaseVar];
				}else {
					Debug.fError("queuElement notfound : " + _sIniType);
					gbug();
				}
				
			}else{
			
				//Initialisation
				if (_aCurrentVar[cVarListIniInString] != null) {
					var _sInitialistion : String = _aCurrentVar[cVarListIniInString];
				
					 precalculateLine( _sInitialistion);
					_aCurrentVar[cVarListValue] = oCalcuValue;
					
				}
				
			}
		*/	
			
		}
		
		
		
		public static function convertSharingToIndex(_sSharing:String):EuSharing {
			if (_sSharing == "private") {
				
				return EuSharing.Private;
				
			}else if (_sSharing == "public") {
				
				return  EuSharing.Public;
				
			}else if (_sSharing == "macro") {
				return  EuSharing.Public;
				
			}
			/*
			else if (_sSharing == "overable") {
				return  EuSharing.Overable;
			}*/
			
			Debug.fError("invalid sharing type : " + _sSharing);
			return  EuSharing.SharingInvalid;
		}
		
		
		
		
		public static var eTypeNbBit : EuBit ;
		public static var aLastClassLoc : Array<Dynamic>;
		public static function stringToType(_sType:String, _sLine:String = "", _nCurrentIndex : UInt = 0):EuVarType {
		
			aLastClassLoc = []; //Tested in var creation
			//Extract all localisation suite word.word (Inside Class) note only one normaly :S
			if (_nCurrentIndex != 0 &&  _sLine.charAt(_nCurrentIndex) == ".") {
				aLastClassLoc.push(_sType);
				while (_sLine.length > _nCurrentIndex && _sLine.charAt(_nCurrentIndex) == ".") { //Maybe only one is possible for enumation
					var _sNew : String = Text.between3(_sLine, _nCurrentIndex + 1, EuBetween.Word);
					_nCurrentIndex = Text.nCurrentIndex ;
					aLastClassLoc.push(_sNew);
				}
				_sType = aLastClassLoc[aLastClassLoc.length - 1];
			}
			
			/*
			//Take last word type
			var _aList : Array<Dynamic> = _sType.split(".");	
			_sType = _aList[_aList.length - 1];
			if (_aList.length > 1) {
				Debug.trace1("aaaaaaaaaaa: " + _sType);
			}*/
			
			/////////// NB bit //////////////////
			eTypeNbBit = EuBit.nFast;
			if (_sType.length > 3) {
				var i : Int = _sType.length - 1;
				var _nTotal : Int = 0;
				
				if (_sType.charAt(i) == "X") {
					_nTotal ++;
					i--;	
				}else{
					while (_sType.charAt(i) > "0" && _sType.charAt(i) < "9") {
						_nTotal ++;
						i--;
					}
				}
				
				if (_nTotal > 0) {
					switch ( _sType.substring(i + 1, _sType.length) ) {
						
						case "8":
							eTypeNbBit = EuBit.n8;
						//break;	
						case "16":
							eTypeNbBit = EuBit.n16;
						//break;
						case "32":
							eTypeNbBit = EuBit.n32;
						//break;
						case "64":
							eTypeNbBit = EuBit.n64;
						//break;
						case "128":
							eTypeNbBit = EuBit.n128;
						//break;
						case "X":
							eTypeNbBit = EuBit.nX;
						//break;
					}
								
					_sType = _sType.substring(0, i + 1);
				}
			}
			//////////////////////////////////////////
			
			
			switch (_sType) {
				
				case "Gate"  :
					return EuVarType._Gate;
				//break;
				
				case "Val"  :
					return EuVarType._Val;
				//break;
				
				case "Int"  :
					return EuVarType._Int;
				//break;
				
				case "UInt"  :
					return EuVarType._UInt;
				//break;
				/*
				case "long"  :
					return EuVarType._Long;
				//break;
				
				case "ulong"  :
					return EuVarType._ULong;
				//break;
				*/
				
				case "Float"  :
					return  EuVarType._Float;
				//break;
				
				case "Bool"  :
					return  EuVarType._Bool;
				//break;
				
				case "String"  :
					return EuVarType._String;
				//break;
				
				case "Array"  :
					return  EuVarType._DArray;
				//break;
				
				case "DArray"  :
					return  EuVarType._DataArr;
				//break;
				
				case "QArray"  :
					return EuVarType._QueueArray;
				//break;
				
				case "CArray" :
					return EuVarType._FixeArray;
				//break;
				
				case "QElement"  :
					return EuVarType._QElement;
				//break;
				
				case "Void"  :
					return EuVarType._Void;
				//break;
				
				case "Delegate"  :
					return EuVarType._Delegate;
				//break;
				
				case "Mapped"  :
					return EuVarType._RtuMap;
				//break;
				
				case "iu"  :
					return EuVarType._IU;
				//break;
				/*
				case "Class"  :
					return EuVarType._AnyClass;
				//break;
					*/
				case "Any"  :
					return EuVarType._Any;
				//break;
				
				case "Type"  :
					return EuVarType._Type;
				//break;
			
			}
			//Check first letter
			var _sChar : String = _sType.charAt(0);
			
			switch (_sChar) {
				case "u":
					return EuVarType._Rtu;
				//break;
				
				case "e":
					return EuVarType._HoldEnum;
				//break;
				
			//Queue array
				case "q":

					return EuVarType._QElement;
				//break;
				/*
				case "x":
					return EuVarType._ExClass;
				//break;
				*/
		
			//Enum
				//case "e":
				//	return EuVarType._Enum;
				////break;
			}
			
			return EuVarType._CallClass;
		}
		
					
		public static function operatorType(_sCharOpp : String):EuOperator{
		
			switch (_sCharOpp) {
				case "+" : 
					return EuOperator.Add;
				//break;
				case "-" : 
					return EuOperator.Substract;
				//break;
				case "/" : 
					return EuOperator.Divide;
				//break;
				case "*" : 
					return EuOperator.Multiply;
				//break;
				case "%" : 
					return EuOperator.Modulo;
				//break;
				default :
					return EuOperator.None;
				//break;
			}
		
		}
		
		
		
	}	
