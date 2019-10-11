package language.project.convertSima ;

	import language.enumeration.EuLocation;
	import language.pck.FileImport;
	import language.enumeration.EuBetween;
	import language.enumeration.EuConstant;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuSharing;
	import language.enumeration.EuVarType;
	import language.enumeration.EuClassType;
	import language.MyFile;
	import language.pck.SLib;
	import language.project.SProject;
	import language.Text;
	import language.TextType;
	import language.vars.special.EnumObj;
	import language.vars.special.SNatFunction;
	import language.vars.special.UnitObj;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.EaseOut;
	import language.vars.varObj.LineVarIni;
	import language.vars.varObj.VarCallClass;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	import language.base.InObject;
	import language.base.Root;
	import language.base.Debug;


	
	class SFrame extends InObject
	{

		public var oSProject : SProject;
	//	public var oSCurrClass : SClass;
		public var oSPackage : SPackage;
		public var bSkipContent : Bool = false;
		public var bSkipStatic : Bool = false;
		public var bAddDebugFile : Bool = false;
		public var bWrapper : Bool = false;
		public var aFile : Array<Dynamic>;
		public var aGenerate : Array<Dynamic> = [];
		
		public var oCurrSClass : SClass = null;
		
		private var cStartType: String = ":";
		private var cStartSet: String = "=";
		
		private var bConvertDebug : Bool = false;
		private static var nEndFunctionLine : Int = 0;

		
		
	//	public function new(_Main:Root, _oSProject : SProject, _oSClass:SClass, _aFile:Array<Dynamic>, _sPath:String) {
		public function new(_Main:Root, _oSProject : SProject, _oSPackage:SPackage, _aFile:Array<Dynamic>, _sPath:String) {
			super(_Main);
			oSProject = _oSProject;
			oSPackage = _oSPackage;
			
			oSProject = _oSProject;
			aFile = _aFile;
			ExtractBlocs.oCurrPackage = oSPackage;
			All( _sPath);
			ExtractBlocs.oCurrPackage = null;
		}
		
	
		
		private function All(_sPath:String) :Bool {
			
			oCurrSClass = oSPackage.oSClass;
			ExtractBlocs.oCurrSClass = oCurrSClass;
			
			var _i:UInt = aFile.length;
			//aFile = aFile;
			var _sLine : String;
			
			//Find Package
			var i : Int = 0;
			while (i < _i) {
				
				ExtractBlocs.nCurrLine = i + 1;
				if (getPackage( Text.removeComments(aFile[i], oSPackage.oSClass) , i + 1) ) { //Also Create oSClass
					//oSClass.sLib  = _sLib;
					//oSClass.sPath = _sPath;
					if (bSkipContent){
						Debug.fWarning("#skipContent: " + _sPath +  oSPackage.sName);
						//return false; 
					}
					
					//Count num of subfolder
					//var _nbFolder : UInt = MyFile.countFolder(_sPath);
					//Get string back ex : _Flash\MyEngine\CPPcode = ..\..\..\ 
					//var _sStringBack : String = MyFile.getStringBackFolder(_nbFolder);
				//	oSClass.nNbFolder = _nbFolder;
					//Debug.trac("_sPath : " + _sPath);
					//Debug.trac("_nbFolder : " + _nbFolder);
					//Debug.trac("Stringback : " + oSClass);
				//	_sStringBack = _sStringBack.split("\\").join("/");  
			//		oSClass.sPathBack = _sStringBack;	
					i++;
					break;
					
				}
				
				i++;
			}
			if (i == _i) {
				Debug.fWarning("No Package in: " + oSPackage.sName);
				return false;
			}
			
			//Get import and find startclass
			
			//Insert Default Debug class
			if (bConvertDebug) {
				/*
				var _nId : Int = aCurrentCppImport.length;
				aCurrentCppImport[_nId] = [];
				aSelectImport = aCurrentCppImport[_nId]
				//Push value
				aSelectImport[cClassImportListPath] = "";
				aSelectImport[cClassImportListName] = "Debug";
				aSelectImport[cClassImportListLine] = 0;
				aSelectImport[cClassImportListLib] =  sCppBaseLib;
				aSelectImport[cClassImportListId] = aCppClassName["Debug"];
				*/
			}
			
			
			while (i < _i) {
				ExtractBlocs.nCurrLine = i + 1;
				_sLine = Text.removeComments(aFile[i], oSPackage.oSClass);
				
				getImport(_sLine , i + 1);
				
				if (beginClass(_sLine, i + 1)) {
					//Class is initialised
					oCurrSClass.aFile = aFile; //Save in array to reusse when functions load
					i++;
					break;
				}
				
				
				
				i++;
			}
			if (i == _i) {
				Debug.fWarning("No Class in: " + oCurrSClass.sName);
				return false;
			}
			
			//Debug.trace("begin -------------------------")
			
			//Get variable and find first function
			while (i < _i) {
				ExtractBlocs.nCurrLine = i + 1;
				_sLine = Text.removeComments(aFile[i], oCurrSClass, true);
				
				getMainVariable(  _sLine , i);
				
				nEndFunctionLine = i;
				if (getFunction( _sLine, i + 1, _i)) {
					i = nEndFunctionLine;
					i ++;
					break;
				}
				
				i++;
			}
			
	
			if (i == _i) {
				Debug.fWarning("No function in: " + oCurrSClass.sName);
				return false;
			}else {
				
				//Get the all other function
				while (i < _i) {
					ExtractBlocs.nCurrLine = i + 1;
					//if (getFunction( Text.removeComments(aFile[i], oSClass, true) , i + 1, _i)) { //Todo removeComments Cpp line between functions
					nEndFunctionLine = i;
					if (getFunction( Text.removeComments(aFile[i],null,false,true) , i + 1, _i)) { //Todo removeComments Cpp line between functions --> Ok in ExtractBloc
						i = nEndFunctionLine;
					}
					
					i++;
				}
			}
			
		
			
			ExtractBlocs.nCurrLine = 0;
			return false;
		}
		
		
		private function getPackage(_sLine:String, _nLineNum : UInt) : Bool {
			
			
				
			var _nIndex : Int = _sLine.indexOf("#skipContent");
			if (_nIndex >= 0) {
				//oSClass.nLine = _nLineNum; //Pacakge line not the class??
				bSkipContent = true;
				return true;
			}
			var _nIndex : Int = _sLine.indexOf("#skipStatic");
			if (_nIndex >= 0) {
				//oSClass.nLine = _nLineNum; //Pacakge line not the class??
				bSkipStatic= true;
				return true;
			}
			var _nIndex : Int = _sLine.indexOf("#addDebugFile");
			if (_nIndex >= 0) {
				//oSClass.nLine = _nLineNum; //Pacakge line not the class??
				bAddDebugFile = true;
				return false;
			}
			
			var _nIndex : Int = _sLine.indexOf("#Wrapper");
			if (_nIndex >= 0) {
				//Debug.fError("Wrapper for " + oSPackage.sFilePath);
				//oSClass.nLine = _nLineNum; //Pacakge line not the class??
				bWrapper= true;
				return true;
			}
			
			var _nIndex : Int = _sLine.indexOf("package ");
			if (_nIndex >= 0) {
				//oSClass.nLine = _nLineNum; //Pacakge line not the class??
				oSPackage.nPackageLine = _nLineNum;
				return true;
			}
				
			var _nIndex : Int = _sLine.indexOf("generate ");
			if (_nIndex >= 0) {
				fExtractGenerate(_sLine, _nIndex);
				//oSClass.nLine = _nLineNum; //Pacakge line not the class??
				oSPackage.nPackageLine = _nLineNum;
				return true;
			}

			return false;
		}
		
		private function fExtractGenerate(_sLine:String, _nFromIndex : UInt) : Bool {
			var _nIndex : Int = Text.search(_sLine, "\"" , _nFromIndex, true);
			if (_nIndex < 0) {
				Debug.fError("Generate classs: " + oSPackage.sName + " require Tag in quote: " + _sLine);
				return false;
			}
			oSPackage.bGenerated = true;
			oSPackage.sGenerateTag = Text.between3(_sLine, _nIndex, EuBetween.EndString);
			return true;
		}
		
		
		
		
		private var cStartImport : String = "import ";
		private var cStartInclude : String = "include ";
		private function getImport(_sLine:String, _nLineNum : UInt) : Bool {
			var _bCpp : Bool = false;
			var _bRecursive : Bool = false;
	
			var _nIndex : Int 		 = _sLine.indexOf(cStartImport);
			var _nIndexInclude : Int = _sLine.indexOf(cStartInclude);
			
			if (_nIndex >= 0 || _nIndexInclude >= 0) {
				if (_nIndexInclude > _nIndex){
					_nIndex = _nIndexInclude + cStartInclude.length;
					_bRecursive = true;
				}else{
					_nIndex += cStartImport.length;
				}

				var _sPath : String = _sLine.substring(_nIndex, _sLine.length);
				_sPath = _sPath.substring(0, _sPath.indexOf(";"));

				return 	extractImport(_sPath, oSPackage, _nLineNum, null,false, false, _bRecursive);
			}else {
				
				return false;
			}
		}
		
		
		public static function extractImport(_sPath:String, _oPckg:SPackage, _nLineNum:UInt, _oSlib:SLib = null, _bTestIfIsReallyOverPlace : Bool = false, _bIsLibFile : Bool = false, _bIsRecursive : Bool = false) : Bool { //Ugly lib import TODO
			
			var _oImport : FileImport;
			
			//GetLib
			var _sLib : String = _sPath.substring( 0 , _sPath.indexOf("."));
			//Remove lib of path
			_sPath = _sPath.substring(_sLib.length + 1, _sPath.length);
			//Get fist word lib of path
			/*
			var _nFirstIndex : Int = _sPath.indexOf(".");
			if (_nFirstIndex == -1) {
				_nFirstIndex = _sPath.length;
			}
			var _sFist : String = _sPath.substring( 0 , _nFirstIndex);
			*/
			
			if (_oSlib == null ) {
				_oSlib = _oPckg.oSProject.fFindLibIdName(_sLib, _sPath);
				if (_oSlib == null) {
					return false;
				}
			}
		
			//GetName
			var _nLength : UInt = _sPath.length;
			
			var _sName : String = _sPath.substring( _sPath.lastIndexOf(".", _nLength) + 1, _nLength);
			
			
			//Convert path
			_sPath = MyFile.convertPathWithDot(_sPath, "");
			//Remove name file of path
			_sPath = _sPath.substring(0, _sPath.length - _sName.length);

			
			//Select lib type
			var _nClassId : UInt = 0; //TODO Make class import id for as
			var _nId : UInt;
			var _nType : UInt;
			

			_oImport = _oPckg.newSImport(_bIsRecursive);

			//Push value
			_oImport.sPath = _sPath.split("\\").join("/");
			_oImport.sName = _sName;
			_oImport.nLine = _nLineNum;
			_oImport.oSLib = _oSlib;
			_oImport.bRecursive = _bIsRecursive;
			
			if (_bIsLibFile){
				_oSlib.oLibFileImport = _oImport;
			}
			

			return true;
		}
		
		
		private var cStartClass : String = "class ";
		private var cStartThread : String = "public thread";
		private var cStartExends : String = "extends ";
		private var cStartOverplace: String = "overplace ";
		private var cStartExtension : String = "public extension ";
		private var cStartPublic: String = "public ";
		
		private function beginClass(_sLine:String, _nLineNum : UInt) :Bool {
			
			var _bIsFound: Bool = false;
			var _bIsExtension: Bool = false;
			var _bIsThead: Bool = false;
			var _bIsOverClass: Bool = false;
			var _bIsAtomic: Bool = false;
			var _bIsPod: Bool = false;
			var _bIsVector: Bool = false;
			
			
		var _eClassType: EuClassType = EuClassType.Invalid;
			var _nIndex : Int = Text.search(_sLine, cStartPublic); //Start class
			if (_nIndex >= 0) {
				
		
				
				var _sClassType: String = Text.between3(_sLine, _nIndex +  cStartPublic.length,EuBetween.Word);
				
			
				
				_nIndex = Text.nCurrentIndex;
				switch(_sClassType) {
					
					case "result":
						_bIsFound = true;
						_eClassType = EuClassType.Results;
						
					case "vector":
						_bIsFound = true;
						_bIsVector = true;
						_eClassType = EuClassType.Vector;
						
					case "pod":
						_bIsFound = true;
						_bIsPod = true;
						_eClassType = EuClassType.Pod;
						
					case "struct":
						_bIsFound = true;
						_bIsPod = true;
						_eClassType = EuClassType.Pod;
					
					//break; 
					
					case "class":
						_bIsFound = true;
						_eClassType = EuClassType.Class;
					//break; 
					case "overclass":
						_bIsFound = true;
						_bIsOverClass = true;
						_eClassType = EuClassType.Overclass;
					//break; 

					case "extension":
						_bIsFound = true;
						_bIsExtension = true;
						_eClassType = EuClassType.Extension;
					//break; 
					case "thread":
						_bIsFound = true;
						_bIsThead = true;
						_eClassType = EuClassType.Thread;
					//break; 
					case "atomic":
						_bIsFound = true;
						_bIsAtomic = true;
						_eClassType = EuClassType.Atomic;
					//break; 
					
					
				}
				// oCurrSClass.eClassType = _eClassType;
			}
			
			
			if (_bIsFound) {
				fClassFrame(_sLine, _nIndex, _nLineNum,_bIsExtension, _bIsThead , _bIsOverClass, _bIsAtomic, _bIsPod, _bIsVector, _eClassType);
				
				return true;
			}

			/*
			var _nIndex : Int = Text.search(_sLine, cStartClass); //Start class
	
			if (_nIndex >= 0) {
				
				fClassFrame(_sLine, _nIndex +  cStartClass.length, _nLineNum);
				return true;
				
				
			}else { //Extention
				
				//Extention type
				 _nIndex  = Text.search(_sLine, cStartExtension);
				if (_nIndex >= 0) {
					
					fClassFrame(_sLine, _nIndex +  cStartExtension.length, _nLineNum);
					oSClass.bExtension = true;
					
					return true;
					
				}else { //Thread

					 _nIndex  = Text.search(_sLine, cStartThread);
					if (_nIndex >= 0) {
						
						_nIndex += cStartThread.length;
						
						
						
						if (_sLine.charAt(_nIndex) == "<") {
							 oSClass.sThreadClass = Text.between3(_sLine,  _nIndex + 1, EuBetween.Template);
							 _nIndex = Text.nCurrentIndex;
						}
						
						//Name
						oSClass.sName = Text.between3(_sLine, _nIndex + 1, EuBetween.Custom, " ");
						oSProject.aClassName[ oSClass.sName ] = oSClass;
						
						oSClass.bThread = true;
						
						
						//Extends
						var sExtend :String  = Text.between1(_sLine, cStartExends, EuBetween.Custom, "{");
						if (sExtend != null) {
							oSClass.bHaveExtend = true;
							oSClass.sExtendNotIni = sExtend;
						}

						Debug.trace1("Begin Class : " + oSClass.sName)
						Debug.trace1("Extends : " +oSClass.sExtendNotIni )

						return true;
				
					}
				}
			}*/
			return false;
		}
		
		public function fClassFrame(_sLine:String, _nIndex : Int, _nLineNum : UInt, _bIsExtension :Bool , _bIsThead : Bool , _bIsOverclass : Bool , _bIsAtomic:Bool , _bIsPod:Bool  , _bIsVector:Bool, _eClassType : EuClassType ) :Void {
			var sExtend : String;
			var sOverplace : String;
			var _sThreadClass : String = "";
			
			if (_bIsThead) {
				if (_sLine.charAt(_nIndex) == "<") {
					_sThreadClass = Text.between3(_sLine,  _nIndex + 1, EuBetween.Template);
					 _nIndex = Text.nCurrentIndex;
				}
			}
			
			//Name
			var _sName : String = Text.between3(_sLine, _nIndex, EuBetween.Word);
			
			
			oCurrSClass = oSPackage.fAddClass(_sName); //TODO name is set after
			
			oCurrSClass.eClassType = _eClassType;
			
			
			 oCurrSClass.sThreadClass = _sThreadClass;
				
			if (oCurrSClass.eClassType == EuClassType.Results){
				oCurrSClass.bIsResults = true;
			}
			 
			 
			
			oCurrSClass.bThread = _bIsThead;
			oCurrSClass.bExtension = _bIsExtension;
			oCurrSClass.bOverclass = _bIsOverclass;
			oCurrSClass.bAtomic = _bIsAtomic;
			oCurrSClass.bIsPod = _bIsPod;
			oCurrSClass.bIsVector = _bIsVector;
			

		
			
			
			//Array<Dynamic> of name to class for quick find
			//oSProject.aClassName[ oSClass.sName ] = oSClass;
			oCurrSClass.nLine = _nLineNum;
			

			
			//Extends
			sExtend  = Text.between1(_sLine, cStartExends, EuBetween.Custom, "{");
			sOverplace  = Text.between1(_sLine, cStartOverplace, EuBetween.Custom, "{");
			if (sExtend != null || sOverplace != null) {
				
				if (sOverplace != null) {
					oCurrSClass.bHaveOverplace = true; //TODO mix extens / overplace
					sExtend = sOverplace;
					if (oCurrSClass.bExtension){
						Debug.fError("'extention' type class cannot 'overplace': " + oCurrSClass.sName );
					}
				}
				
				oCurrSClass.bHaveExtend = true;
				oCurrSClass.sExtendNotIni = sExtend;
			}
			
		
		}
		
		
		
		private var cStartVariable : String = "var ";
		private var cStartConstant : String = "const ";
		private var cStartUnit : String = "unit ";
		private function getMainVariable(_sLine:String, _nLineNum : UInt) : Bool {
			//Start with "var"
			
			var _sFirstWord:String = Text.between3(_sLine, 0, EuBetween.Word);
			var _sSecondWord:String = Text.between3(_sLine, Text.nCurrentIndex + 1, EuBetween.Word);
			
			//TODO do not search!!!
			
			var _nIndex : Int = Text.search(_sLine, cStartVariable);
			if (_nIndex >= 0) {
				
				
				if (_sFirstWord == "macro") { //Special case for CPP
					extractVariable(_sLine, _nIndex + cStartVariable.length, _nLineNum,  EuConstant.Macro);
					
				}else if (Text.search(_sLine, cStartConstant) >= 0) { //Constante
					extractVariable(_sLine, _nIndex + cStartVariable.length, _nLineNum,  EuConstant.Constant);
				}else {
					//Normal
					extractVariable(_sLine, _nIndex + cStartVariable.length, _nLineNum, EuConstant.Normal);
				}

				return true;
			}
			

			//Get enum
			 _nIndex  = Text.search(_sLine, "enum");
			if (_nIndex >= 0) {
				extractEnum(_sLine, _nIndex + cStartUnit.length, _nLineNum);  //Todo skip accolade
				return true;
			}
			
			
			//Get units
			 _nIndex  = Text.search(_sLine, "unit");
			if (_nIndex >= 0) {
				extractUnit(_sLine, _nIndex + cStartUnit.length, _nLineNum);  //Todo skip accolade
				return true;
			}	
			
			//Get use units
			if (_sFirstWord == "use") {
				var _sThirdWord : String = Text.between3(_sLine, Text.nCurrentIndex + 1, EuBetween.EndString ) ;
				
				if(_sThirdWord.charAt(0) == "u"){
					oCurrSClass.aUseUnitIniStringFirst.push( _sSecondWord  );
					oCurrSClass.aUseUnitIniStringAfter.push( _sThirdWord );
				}else if (_sThirdWord.charAt(0) == "e") {
					oCurrSClass.aUseEnumIniStringFirst.push( _sSecondWord  );
					oCurrSClass.aUseEnumIniStringAfter.push( _sThirdWord );
				}else {
					Debug.fError("unknow use var : " + _sThirdWord);
					Debug.fStop();
					
				}
				return true;
			}	
			
			//New type using for casting or TODO
			if (_sFirstWord == "typedef") {
				oCurrSClass.oSLib.addTypeDef(_sSecondWord);
				return true;
			}	

			
			/*
			//Get enum
			 _nIndex  = search(_sLine, "enum");
			if (_nIndex >= 0) {
				extractEnum(_sLine, _nIndex + cStartUnit.length, _nLineNum);
				return true;
			}	
			
			//Get queueArray
			_nIndex  = search(_sLine, "queue");
			if (_nIndex >= 0) {
				extractQueue(_sLine, _nIndex + cStartUnit.length, _nLineNum);
				return true;
			}	
			*/
			
			return false;
		}
		
		
		///Global variable
		private function extractVariable(_sLine:String, _nIndex:UInt, _nLineNum : UInt, eConstant : EuConstant):Void {
			
			
			
			var _sName : String  = Text.between3(_sLine, _nIndex,EuBetween.Word);
			var _sType :String = Text.between2(_sLine, cStartType,  Text.nCurrentIndex,EuBetween.Word);
			
			//var _eReadType : UInt = TextType.stringToType(_sType);
	
			var _oVar : CommonVar = TypeResolve.createVarWithType(oCurrSClass, _sType, _sLine, Text.nCurrentIndex);
			if (_nIndex - 5 >= 0 && _sLine.charAt(_nIndex - 5) == "w") { //"wvar "(-5) Detect WeakVar * TODO more strict check
				_oVar.bWeak = true;
			}
			if (_nIndex - 5 >= 0 && _sLine.charAt(_nIndex - 5) == "e") { //"wvar "(-5) Detect WeakVar * TODO more strict check
				_oVar.bEmbed = true;
			}
		
			
			
			//at the end to not lose nCurrentIndex
			var _sInitialistion : String =  Text.between2(_sLine, cStartSet, Text.nCurrentIndex, EuBetween.Line);
			
			//Get sharing, at the end to not lose nCurrentIndex
			var _sSharing : String = Text.between3(_sLine, 0,EuBetween.Word); 
			
			_oVar.sName = _sName;
			//_oVar.eType = _eReadType;
			_oVar.eConstant = eConstant;
			_oVar.nLine= _nLineNum;
			//_oVar.oClass = oSClass;
		//	_oVar.sIniInString = _sInitialistion; //recalculate initialisation after loading class (before)	//TODO verefy type
			_oVar.eSharing =  TextType.convertSharingToIndex(_sSharing);
				
			if ( _oVar.eSharing == EuSharing.SharingInvalid) {
				Debug.fError("invalid sharing type  in : " + _sLine );
			}
			
			
			//or not and push
			var _sNextWord : String = Text.between3(_sLine, Text.nCurrentIndex,EuBetween.Word);
			if ( _sNextWord == "static" ||  _sNextWord == "atomic" ||  eConstant == EuConstant.Macro || eConstant == EuConstant.Constant)  { 
				_oVar.bStatic = true;
				if (_sNextWord == "atomic" ){
					_oVar.bAtomic = true;
					if (!TypeResolve.isVarCommon( _oVar)){
						if( _oVar.eLocation != EuLocation.LocalParam){
							_oVar.bAtomicComplexe = true;
						}
					}
					
					//oCurrSClass.pushGlobalVar(_oVar,_sInitialistion);
					oCurrSClass.pushAtomicVar(_oVar, _sInitialistion);
				}else{
					oCurrSClass.pushStaticVar(_oVar, _sInitialistion);
				}
			} else if (_sNextWord == "ease") {	  ///TODO static var 
				var _oEaseOut: EaseOut = new EaseOut(oCurrSClass);
				_oVar.oAssociate = _oEaseOut;
				_oEaseOut.oAssociate = _oVar;
				_oVar.bStatic = false;  ///TODO static var 
				oCurrSClass.pushGlobalVar(_oVar, _sInitialistion);
				oCurrSClass.pushAssociateVar(_oEaseOut);
				
			}else {
				_oVar.bStatic = false;
				oCurrSClass.pushGlobalVar(_oVar,_sInitialistion);
			}
			
			
			
			if (_oVar.bEmbed == true) {
				if (_oVar.eType == EuVarType._CallClass) {
				
					_oVar.oSBloc.oSClass.fAddEmbedVar(cast(_oVar,VarCallClass)); 
					Debug.fWarning("TODO embed  : " + _oVar.sName );
				}else {
					Debug.fError("embed var must be a Class Type : " + _oVar.sName );
				}
			}
			
			LineVarIni.fCheckIfNewVarIsValidScope(oCurrSClass,_oVar);
			
		}
		
	
		
		private function extractEnum(_sLine:String, _nIndex:UInt, _nLineNum : UInt):Void {
			//New unit
			var _oEnum : EnumObj = new EnumObj();
			
			//Get name
			_oEnum.sName = Text.between3(_sLine, _nIndex,EuBetween.Word);
			
			
			var _nFound : Int = Text.search(_sLine, ":");
			if (_nFound >= 0) {
				var _sVarListType : String = Text.between3(_sLine, _nFound + 1, EuBetween.Word);
				_oEnum.oVarsType = TypeResolve.createVarWithType(oCurrSClass, _sVarListType, _sLine, Text.nCurrentIndex); //TODO create only one vartype and reuseit
			}else {
				Debug.fError("Error enum must have type : " + _oEnum.sName + " in " + oCurrSClass.sName);
				Debug.fStop();
			}
			
		
			//Get sharing
			_oEnum.eSharing = TextType.convertSharingToIndex(Text.between3(_sLine, 0,EuBetween.Word));
			
			_oEnum.nLine = _nLineNum;
			
			oCurrSClass.pushEnum(_oEnum);
			if (oCurrSClass.bCpp) {
				_oEnum.bCpp = true;
			}
		}
		
		private function extractUnit(_sLine:String, _nIndex:UInt, _nLineNum : UInt):Void {
			
			//New unit
			var _oUnit : UnitObj = new UnitObj();
			
			//Get name
			_oUnit.sName = Text.between3(_sLine, _nIndex,EuBetween.Word);
			
			
			//Get sharing
			_oUnit.eSharing = TextType.convertSharingToIndex(Text.between3(_sLine, 0,EuBetween.Word));
			
			_oUnit.nLine = _nLineNum;
			
			oCurrSClass.pushUnit(_oUnit);
			if (oCurrSClass.bCpp) {
				_oUnit.bCpp = true;
			}
			
		}
		
		
		
		private var cStartFunction : String = " function ";
		
		private function getFunction(_sLine:String, _nLineNum : UInt, _nTotalLines:UInt) : Bool {
			
			var _nIndex : Int = Text.search(_sLine, cStartFunction);
			if (_nIndex >= 0) {
				if(extractFunction(oCurrSClass, _nIndex + cStartFunction.length, _sLine, _nLineNum)){
					return true;
				}
			}
			 _nIndex  = Text.search(_sLine, "destructor");
			if (_nIndex >= 0) {
				if(extractFunction(oCurrSClass, _nIndex + cStartFunction.length, _sLine, _nLineNum)){
					return true;
				}
			}
			
			return false;
		}
		
		
		
		
			//1 Function Name
			//2 Function Type
			//3 Function Sharing
			//4[] Parameters
				//0 Name
				//1 Type
				//2 Initialistion
			//5[] Declared var
				//0 Name
				//1 Type
				//2 Line
			//6[] Lines id list
		public static function extractFunction(_oSClass:SClass, _nIndex:UInt, _sLine:String, _nLineNum : UInt):Bool {
			
			var _oSFunction : SFunction = new SFunction(null, _oSClass);
			_oSFunction.nLineNum = _nLineNum;
			_oSFunction.nLine = _nLineNum;
			_oSFunction.nLastLine = _nLineNum; //If has no line
			
			var _firstWord : String = Text.between3(_sLine, 0,EuBetween.Word);
			var _bTestSecondWord : Bool = true;
			
			
			if (_firstWord == "gen") {
				_oSFunction.bSpecialGenerate = true;
				_firstWord  = Text.between3(_sLine, Text.nCurrentIndex,EuBetween.Word);
			}
			
			switch (_firstWord) { //Platform Specifique
				case "Win" :
					_oSFunction.bSpecifiquePlatforme = true;
					_firstWord  = Text.between3(_sLine, Text.nCurrentIndex,EuBetween.Word);
				//break;
			}
			
			
			switch (_firstWord) {
				
				case "destructor" :
					
					_oSFunction.eSharing = EuSharing.Destructor;
					_oSFunction.sName = "destructor";
					//_oSFunction.oSClass.aFunctionList.pop(); //*Special case Remove from the list* //Keep it to garanted seach balise between functions
					_oSClass.oFuncDestrutor = _oSFunction;
			
				//	if (Text.search(_sLine, "{", _nSearchAccIndex) >= 0) {
					if (Text.search(_sLine, "{", 0) >= 0) {
						return true;
					}else {
						Debug.fError("destructor need \"{\"");
						var _aStop : Array<Dynamic>=[]; _aStop = _aStop[5];
						return false;
					}
				//break;
				
				case "private" :
					_oSFunction.eSharing = EuSharing.Private;
				//break;
				
				case "public" : 
					_oSFunction.eSharing = EuSharing.Public;
				//break;
				
				case "atomic" : 
					_oSClass.fAddAtomicFunc(_oSFunction);
					_oSFunction.bAtomic = true;
					_oSFunction.eSharing = EuSharing.Public;
				
				case "overable" : 
					_oSFunction.bOverable = true;
					_oSFunction.eSharing = EuSharing.Public;
				//break;
				
				
				case "riding" :
					
					_oSFunction.eFuncType = EuFuncType.Riding;
					_oSFunction.eSharing = EuSharing.Public;
					
				case "override" :

					_oSFunction.eFuncType = EuFuncType.Override;
					var _nextWord : String = Text.between3(_sLine, Text.nCurrentIndex,EuBetween.Word);
					if (_nextWord == "static") {
						_oSFunction.eSharing = EuSharing.Public; //Deflaut
						 //_oSFunction.eFuncType = EuFuncType.Static;
						_oSFunction.bStatic = true; //  EuFuncType.Override & Static
						_nextWord = Text.between3(_sLine, Text.nCurrentIndex + 1,EuBetween.Word);
					}
					
					
					switch (_nextWord) {
						case "private" :
							_oSFunction.eSharing = EuSharing.Private;
						//break;
						case "public" : 
							_oSFunction.eSharing = EuSharing.Public;
						//break;
						case "protected" : 
							_oSFunction.eSharing = EuSharing.Protected;
						//break;
						
						default : 
							Debug.fError("override without sharing type ");
							gbug();
						//break;
					}
					
				//break;

				case "function" :
					//Cpp class always public by default ,  maybe test if its cpp class
					_oSFunction.eSharing = EuSharing.Public;
					_bTestSecondWord = false;
				//break;
				
				case "static_REMOVED" : //Disable static func because it break polymorphisme
					//Cpp class always public by default,  maybe test if its cpp class
					_oSFunction.eSharing = EuSharing.Public;
					//_oSFunction.eFuncType = EuFuncType.Static;
					_oSFunction.bStatic = true;
					_bTestSecondWord = false;
				//break;

				
				
				case "pure" :
					//Cpp class always public by default,  maybe test if its cpp class
					_oSFunction.eSharing = EuSharing.Public;
					_oSFunction.eFuncType = EuFuncType.Pure;
					_oSFunction.bStatic = true;
					_bTestSecondWord = false;
				//break;

				case "macro" :   //Todo search for real sharing
					_oSFunction.eSharing = EuSharing.Public;
					_oSFunction.eFuncType = EuFuncType.Macro;
					_oSFunction.bStatic = true;
					_bTestSecondWord = false;
				//break;
			}
			
			
			if(_bTestSecondWord){
				//Type
				var _sType : String = Text.between3(_sLine, Text.nCurrentIndex,EuBetween.Word);
				switch (_sType) {
					case "function" :
						_oSFunction.eFuncType = EuFuncType.Normal;
					//break;
					
					case "static_REMOVED" : //Disable static func because it break polymorphisme
						//_oSFunction.eFuncType = EuFuncType.Static;
						_oSFunction.bStatic = true;
					//break;
					
					case "pure" :
						_oSFunction.eFuncType = EuFuncType.Pure;
						_oSFunction.bStatic = true;
					//break;
					
				}
			}
			
			//CPP Special Case for static function
			if (_oSFunction.bStatic == true) {
				var _sSpecialCase : String = Text.between3(_sLine, Text.nCurrentIndex,EuBetween.Word);
				var _sNewName : String = Text.between3(_sLine, Text.nCurrentIndex,EuBetween.Word);
				switch (_sSpecialCase) {
					case "changeRem": //Change fonction name and remove class like Math.h sin(), remove LibCpp_Math:: and change fSin name 
						_oSFunction.bRemoveStaticClass = true;
						_oSFunction.bConvNewName = true;
						_oSFunction.sConvNewName = _sNewName;
					//break;
					
					case "change":
						
					//break;
					
				}
			}
			
			
			
			//Name -> goto index after "function"
			Text.nCurrentIndex = _nIndex;
	
			_oSFunction.sName = Text.between3(_sLine, Text.nCurrentIndex,EuBetween.Word);
			if (_oSFunction.sName == _oSClass.sName) { //Detect constructor
				if (_oSFunction.oSClass.oFuncConstructor != null) {
					Debug.fError("Error, constructor already declared");
				}	
				
				_oSFunction.oSClass.oFuncConstructor = _oSFunction;
				_oSFunction.bConstructor = true;
				

			}
			
			//Main type
			if (_oSFunction.eFuncType == EuFuncType.Normal) {
				if (_oSFunction.sName == _oSClass.sName) { //Same name as class name(it's a constructor)
					_oSFunction.bConstructor = true;
				}
			}
			
		
			
			//PARAM
			//var _sParam :String = Text.between2(_sLine, "(", Text.nCurrentIndex, EuBetween.Custom, ")");
			var _sParam :String = Text.between3(_sLine, Text.nCurrentIndex + 1, EuBetween.Priority);
			
			var _nEndParamIndex : Int = Text.nCurrentIndex;
		
			//var _aParam : Array<Dynamic> = _sParam.split(",");
			var _aParam : Array<Dynamic> = Text.surfaceSplit(_sParam, ",");
			
			//No param
			if (Text.between3(_aParam[0], 0,EuBetween.Word) == null) {
				_aParam = [];
			}

			_oSFunction.aParamNotIni = _aParam;
			
			
			var _nSearchAccIndex : UInt = Text.nCurrentIndex;
			//Return
			_oSFunction.sIniReturn = Text.between2(_sLine, ":", _nEndParamIndex,  EuBetween.EndString);
		
			if (_oSFunction.sIniReturn  == null) {
				Debug.fError("Function must have a return type, use \":Void\" if none");
				Debug.fStop(); //Stop execution
			}

			
			//Begin {
			if (Text.search(_sLine, "{", _nSearchAccIndex) >= 0) {
				//fFastSkipFunc(_oSFunction);
				//nBlocIndex = 0;
				return true;
			}else {
				_oSFunction.bNoLine = true;
				return false;
			}
		}
		
		/*
		private static function fFastSkipFunc(_oSFunction) {
			var _bInsideFunc : Bool;
			var _nBlocCount : UInt = 1;
			
			var _oSClass : SClass = _oSFunction.oSClass;
			var _aFile : Array<Dynamic> = _oSClass.aFile;
			var _nCurentLine : UInt = _oSFunction.nLineNum - 1;
			var _nTotalLines : UInt = _aFile.length;
			
			//Read file until reach end of function or the end of file
			while (_nCurentLine < _nTotalLines) {
				_nCurentLine ++;
				nEndFunctionLine = _nCurentLine;
				var _sLine : String = Text.removeComments( _aFile[_nCurentLine]);
				var _nIndexChar : UInt = 0;
				var _nLength : UInt = _sLine.length;
				while (_nIndexChar < _nLength) {
					var _nChar : String = _sLine.charAt(_nIndexChar);
					if (_nChar == "{") {
						_nBlocCount++;
					}else if (_nChar == "}") {
						_nBlocCount--;
						if (_nBlocCount == 0) {
							//break;
						}
					}
					_nIndexChar++;
				}
			}

			if (_nCurentLine == _nTotalLines) {
				Debug.fError("Endless function")
			}
			
			//ExtractBlocs.nCurrLine = _nCurentLine;
		}
		*/
		
		
		private static function gbug():Void {
			var aTruc : Array<Dynamic>=[];aTruc = aTruc[6];
		}
		
		
		
	}

