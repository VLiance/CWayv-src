package language.project.convertSima ;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuSharing;
	import language.enumeration.EuOperator;
	import language.pck.FileImport;
	import language.enumeration.EuBetween;
	import language.enumeration.EuConstant;
	import language.enumeration.EuVarType;
	import language.project.SProject;
	import language.Text;
	import language.TextType;
	import language.project.convertCpp.CommonCpp;
	import language.vars.special.EnumObj;
	import language.vars.special.UnitObj;
	import language.vars.special.UseEnum;
	import language.vars.special.UseUnit;
	import language.vars.special.VarArray;
	import language.vars.special.VarQElement;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.Delegate;
	import language.vars.varObj.ExtendFunc;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.VarCallClass;
	import language.vars.varObj.VarGate;
	import language.vars.varObj.VarHex;
	import language.vars.varObj.VarHoldEnum;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	import language.vars.varObj.VarRtu;
	import language.vars.varObj.VarStaticClass;
	import language.base.Debug;
	/**
	 * ...
	 * @author ...
	 */
	class LoadVarContent 
	{
		
			//Step 3 --> load all content var
		public static function loadClassVarContent(_oSProject : SProject, _aPackage:Array<SPackage>):Void {
			var _oSClass : SClass;
			var _i:UInt;
			var i:Int;
			
			for (_oSPck in _aPackage){for (_oSClass in _oSPck.aClassList){
				_oSPck.fBuildFullImportList();
			}}
			
			for(_oSPck in _aPackage){for(_oSClass in _oSPck.aClassList){
				ExtractBlocs.oCurrSClass = _oSClass;
				ExtractBlocs.nCurrLine = _oSClass.nLine;
				
				//Plus -+- Get extend instance
				//if ( _oSClass.bHaveExtend ) { Always have class
					_oSClass.getClassExtends(); //String to extend obj
				//}
			}}
			
			//Create default constructors
			for(_oSPck in _aPackage){for(_oSClass in _oSPck.aClassList){
				fCreateDefaultConstructor(_oSClass);
			}}
			

			
			//Create default destroy
			for(_oSPck in _aPackage){for(_oSClass in _oSPck.aClassList){
				fCreateDefaultDestroy(_oSClass);
				fCreateDefaultCopy(_oSClass);
			}}
			
			
			for(_oSPck in _aPackage){for(_oSClass in _oSPck.aClassList){
				ExtractBlocs.oCurrSClass = _oSClass;
				ExtractBlocs.nCurrLine = _oSClass.nLine;
				
				//Plus -+- Get extend instance
				//if ( _oSClass.bHaveExtend ) {
					_oSClass.loadAllExtended();  //Regroup all extend recursivly
				//}
			}}
			

			
			for(_oSPck in _aPackage){for(_oSClass in _oSPck.aClassList){
				ExtractBlocs.oCurrSClass = _oSClass;
				ExtractBlocs.nCurrLine = _oSClass.nLine;
				
			//	if ( _oSClass.bHaveExtend ) {
					_oSClass.fCreateVarExClass(); //Add all extend var/ extend function definition to be dispo
					fVerifyCollisionNameExtended(_oSClass);
					
			//	}
			}}
			
				
			//Extract all enum sub var of all class
			for(_oSPck in _aPackage){for(_oSClass in _oSPck.aClassList){
				ExtractBlocs.oCurrSClass = _oSClass;
				ExtractBlocs.nCurrLine = _oSClass.nLine;
				
				extractAllEnumSubVar( _oSClass);
			}}
			
				//	Debug.fBreak();


			//Load all global var initilisation 
			//In extractVariable();
			//private var nExample : Int = _aCurrentVar[cVarListIniInString];
			for(_oSPck in _aPackage){for(_oSClass in _oSPck.aClassList){
				ExtractBlocs.oCurrSClass = _oSClass;
				ExtractBlocs.nCurrLine = _oSClass.nLine;
				//Debug.fTrace("IniiniGlobalVar " +_oSClass.sName );
				iniThreadTemplate(_oSClass);
				iniUseUnit(_oSClass);
				iniUseEnum(_oSClass);
				iniClassVar(_oSClass, _oSClass.oPackage.aSImportList_Full, EuVarType._StaticClass);
				//iniClassVar(_oSClass, _oSClass.aCppImportList, EuVarType._CppStaticClass);
				iniGlobalVar(_oSClass, _oSClass.aAtomicVarList, _oSClass.aAtomicVarListIniString);
				iniGlobalVar(_oSClass, _oSClass.aStaticVarList, _oSClass.aStaticVarListIniString); //Static before make global (sometime global depend on static)
				iniGlobalVar(_oSClass, _oSClass.aGlobalVarList, _oSClass.aGlobalVarListIniString);
				
	
			}}
			
			//Create default destructor (must be after global var ini)
			for(_oSPck in _aPackage){for(_oSClass in _oSPck.aClassList){
				fCreateDefaultDestructor(_oSClass);
			}}
			
			
			for(_oSPck in _aPackage){for(_oSClass in _oSPck.aClassList){
				ExtractBlocs.oCurrSClass = _oSClass;
				ExtractBlocs.nCurrLine = _oSClass.nLine;
				
				extractFunctionInfo( _oSClass);
				extractFunctionInfoSignature(_oSClass);
			}}
			
			for(_oSPck in _aPackage){for(_oSClass in _oSPck.aClassList){
				ExtractBlocs.oCurrSClass = _oSClass;
				ExtractBlocs.nCurrLine = _oSClass.nLine;

				extractFunctionInfoOverride(_oSClass);
			}}
			
			
			//Ini Embed (oCallRef from _CallClass must be initialised, maybe initiale this before iniGlobalVar????)
			for (_oSPck in _aPackage){
				_oSPck.fAddImportFullDefinitionFromStrackType();
				_oSPck.fAddImportFullDefinition_AtomicFunc();
				
				for (_oSClass in _oSPck.aClassList){
				
					for (_oVar in _oSClass.aEmbedVarList){
						if(_oVar.eType == EuVarType._CallClass){
							if (cast(_oVar,VarCallClass).bEmbed ){ 
								_oSPck.fAddImportFullDefinition(_oVar.oCallRef);
							}
						}
					}
				}
			}		

			
	
			
			for(_oSPck in _aPackage){for(_oSClass in _oSPck.aClassList){
				ExtractBlocs.oCurrSClass = _oSClass;
				ExtractBlocs.nCurrLine = _oSClass.nLine;
				
				extractAllDelegate(_oSClass);
			}}
			
			
			/*
			//Ini all function Param
			 _i = aClass.length;
			for (i in 0 ... _i) {
				selectClass(i);
				iniAllFunctionParamAndReturn();
			}
			*/
	
			
			
	
			//Extract all unit sub var of all class
			for(_oSPck in _aPackage){for(_oSClass in _oSPck.aClassList){
				ExtractBlocs.oCurrSClass = _oSClass;
				ExtractBlocs.nCurrLine = _oSClass.nLine;
				
				extractAllUnitUnitSubVar( _oSClass);
			}}
			
			
			
	
			
			//Create default constructors
			for (_oSPck in _aPackage){for (_oSClass in _oSPck.aClassList){
					ExtractBlocs.oCurrSClass = _oSClass;
				ExtractBlocs.nCurrLine = _oSClass.nLine;
				fLoadDefaultConstructorLine(_oSClass);
				fLoadGeneratedLine(_oSClass);
				
			}}
			
			
			
			/*
			//Extract all Enum sub var of all class
			 _i = aClass.length;
			for (i in 0 ... _i) {
				selectClass(i);
				aFile = aFileList[nClassId];
				extractAllEnumEnumSubVar();
			}
			
			//Ini all Array<Dynamic> Enum of all class ex. var aEnumArray : Array<Dynamic>(eType);, must be done after enum subvar
			 _i = aClass.length;
			for (i in 0 ... _i) {
				selectClass(i);
				aFile = aFileList[nClassId];
				
				iniListArrayEnum();
			}
			*/
		}
		
		
		public static function fCreateDefaultConstructor(_oSClass:SClass):Void {
			//Order was important when accessing extended class
			 if ( _oSClass.oFuncConstructor != null || _oSClass.bDefaultConstrutorGenereted == true) {
				 return;
			 }
			 _oSClass.bDefaultConstrutorGenereted = true;
			 
			 ExtractBlocs.oCurrSClass = _oSClass;
			 ExtractBlocs.nCurrLine = _oSClass.nLine;
			 
			var _oSFunction : SFunction = new SFunction(null, _oSClass); 
			_oSClass.oFuncConstructor = _oSFunction;
			/*
			 if (_oPrecLevel != null) {
				var _oExtendFunc : ExtendFunc = new ExtendFunc(_oSClass, _oSFunction); //TODO check subextend
				_oPrecLevel.aFunctionExtend.push(_oExtendFunc);
				 
			 }*/
	
			_oSFunction.sName = _oSClass.sName;
			_oSFunction.sRealName = Setting.sConstructorKeyword;//bConstructor?
			
			var  _nLineNum : UInt  = _oSClass.nLine;
			_oSFunction.nLineNum = _nLineNum;
			_oSFunction.nLine = _nLineNum;
			_oSFunction.nLastLine = _nLineNum; //If has no line
			
			_oSFunction.bFuncGenerated = true;
			_oSFunction.bDefaultConstructor = true;
		
			_oSFunction.eSharing = EuSharing.Public;
			_oSFunction.sIniReturn = "Void";
			extractFunctionInfoReturn(_oSFunction);
			_oSFunction.bConstructor = true;
			//_oSFunction.sRealName = Setting.sConstructorKeyword;
			//_oSFunction.eFuncType  = EuFuncType.Main; 

			
			_oSFunction.bNoLine = true; //If have no extention
			
			//Call default extends function
			if (_oSClass.aExtendClass.length > 0) {
				var _oExtClass : SClass = _oSClass.aExtendClass[0]; //only one extend
				fCreateDefaultConstructor(_oExtClass); //recursive if not already analysed
				ExtractBlocs.oCurrSClass = _oSClass;
				ExtractBlocs.nCurrLine = _oSClass.nLine;
				
				fSetDefaultConstructLineToExtract(_oSFunction, _oExtClass);
			}
		}
		
		
		
		public static function fCreateDefaultDestroy(_oSClass:SClass):Void {
			
			 if ( _oSClass.oFuncDestroy != null || _oSClass.bExtension || _oSClass.bDefaultDestroyGenereted == true || _oSClass.bIsPod || _oSClass.bIsVector || _oSClass.bIsResults) { //No need for extention
				 return;
			 }
			 
			  _oSClass.bDefaultDestroyGenereted = true;
			 
			 ExtractBlocs.oCurrSClass = _oSClass;
			 ExtractBlocs.nCurrLine = _oSClass.nLine;
			 
			var _oSFunction : SFunction = new SFunction(null, _oSClass); 
			_oSClass.oFuncDestroy = _oSFunction;
	
			_oSFunction.sName = Setting.sDestroyKeyword;
			_oSFunction.sRealName = _oSFunction.sName;//bConstructor?
			
			var  _nLineNum : UInt  = _oSClass.nLine;
			_oSFunction.nLineNum = _nLineNum;
			_oSFunction.nLine = _nLineNum;
			_oSFunction.nLastLine = _nLineNum; //If has no line
			
			_oSFunction.bFuncGenerated = true;
			_oSFunction.bDefaultDestroy = true;
		
			_oSFunction.eSharing = EuSharing.Public;
			_oSFunction.eFuncType = EuFuncType.Override;
			
			_oSFunction.sIniReturn = "Void";
			extractFunctionInfoReturn(_oSFunction);
			//_oSFunction.bConstructor = true;
			//_oSFunction.sRealName = Setting.sConstructorKeyword;
			//_oSFunction.eFuncType  = EuFuncType.Main; 

			
			_oSFunction.bNoLine = true; //If have no extention
			
			_oSFunction.aGeneratedLine.push("<cpp>");
			
			_oSFunction.aGeneratedLine.push("//GZ_printf(\"\\nDelete: " + _oSClass.sName + "\");");
			
			_oSFunction.aGeneratedLine.push("c" +  _oSClass.sName + "_destructor();");
			_oSFunction.aGeneratedLine.push("delete this;");
			_oSFunction.aGeneratedLine.push("</cpp>");
			
			/*
			//Call default extends function
			if (_oSClass.aExtendClass.length > 0) {
				
				var _oExtClass : SClass = _oSClass.aExtendClass[0]; //only one extend
				fCreateDefaultDestroy(_oExtClass); //recursive if not already analysed
				ExtractBlocs.oCurrSClass = _oSClass;
				ExtractBlocs.nCurrLine = _oSClass.nLine;
				
				fSetDefaultConstructLineToExtract(_oSFunction, _oExtClass);
			}*/
		}

		public static function fCreateFuncDestructor(_oSFunction:SFunction):Void {

			_oSFunction.oSClass.oFuncDestrutor = _oSFunction;
	
			_oSFunction.sName = Setting.sDestructorKeyword;
			_oSFunction.sRealName = _oSFunction.sName;//bConstructor?
			
			
			_oSFunction.bDefaultDestructor = true;
		
			_oSFunction.eSharing = EuSharing.Public;
			_oSFunction.sIniReturn = "Void";
			extractFunctionInfoReturn(_oSFunction);
			//_oSFunction.bConstructor = true;
			//_oSFunction.sRealName = Setting.sConstructorKeyword;
			//_oSFunction.eFuncType  = EuFuncType.Main; 

			
			//Call default extends function
			if (_oSFunction.oSClass.aExtendClass.length > 0) {
				
				var _oExtClass : SClass = _oSFunction.oSClass.aExtendClass[0]; //only one extend
							
				_oSFunction.aGeneratedLine.push("<cpp>");
				if (_oSFunction.oSClass.oFuncDestrutorCustom != null){
					_oSFunction.aGeneratedLine.push("c" +  _oSFunction.oSClass.sName + "_destructor_custom();");
				}
				
				_oSFunction.aGeneratedLine.push("c" +  _oExtClass.sName + "_destructor();");
				var _sAutoFree : String = CommonCpp.freeAll(_oSFunction.oSClass);
				if (_sAutoFree != ""){
					_oSFunction.aGeneratedLine.push(_sAutoFree);
				}
				_oSFunction.aGeneratedLine.push("//" + _oSFunction.oSClass.aIniGlobalVarList.length);
				_oSFunction.aGeneratedLine.push("</cpp>");
				
			}
		}

		
		
		public static function fCreateDefaultDestructor(_oSClass:SClass):Void {
			
			// if ( _oSClass.oFuncDestrutor != null || _oSClass.bExtension || _oSClass.bDefaultDestructorGenereted == true || _oSClass.bIsPod || _oSClass.bIsVector || _oSClass.bIsResults) { //No need for extention
			 if ( _oSClass.oFuncDestrutor != null || _oSClass.bDefaultDestructorGenereted == true || _oSClass.bIsPod || _oSClass.bIsVector || _oSClass.bIsResults) { //No need for extention
				 return;
			 }
			 
			 _oSClass.bDefaultDestructorGenereted = true;
			 
			 ExtractBlocs.oCurrSClass = _oSClass;
			 ExtractBlocs.nCurrLine = _oSClass.nLine;
			 
			var _oSFunction : SFunction = new SFunction(null, _oSClass); 
			_oSFunction.bNoLine = true; //If have no extention
			_oSFunction.bFuncGenerated = true;
			
			
			var  _nLineNum : UInt  = _oSClass.nLine;
			_oSFunction.nLineNum = _nLineNum;
			_oSFunction.nLine = _nLineNum;
			_oSFunction.nLastLine = _nLineNum; //If has no line
			
			
			fCreateFuncDestructor(_oSFunction);
			
		}
		
		
		
		public static function fCreateDefaultCopy(_oSClass:SClass):Void {
			
			 if ( _oSClass.oFuncCopy != null || _oSClass.bExtension || _oSClass.bDefaultCopyGenereted == true || _oSClass.bIsPod || _oSClass.bIsVector || _oSClass.bIsResults) { //No need for extention
				 return;
			 }
			 
			 _oSClass.bDefaultCopyGenereted = true;
			 
			 ExtractBlocs.oCurrSClass = _oSClass;
			 ExtractBlocs.nCurrLine = _oSClass.nLine;
			 
			var _oSFunction : SFunction = new SFunction(null, _oSClass); 
			

			_oSFunction.pushParam( newVarParam(_oSFunction, "_bDeepCopy:Bool", _oSFunction.nLine));
			
			_oSClass.oFuncCopy = _oSFunction;
	 
			_oSFunction.sName = Setting.sCopyKeyword;
			_oSFunction.sRealName = _oSFunction.sName;//bConstructor?
			
			var  _nLineNum : UInt  = _oSClass.nLine;
			_oSFunction.nLineNum = _nLineNum;
			_oSFunction.nLine = _nLineNum;
			_oSFunction.nLastLine = _nLineNum; //If has no line
			
			_oSFunction.bFuncGenerated = true;
			_oSFunction.bDefaultCopy = true;
		
			_oSFunction.eSharing = EuSharing.Public;
			_oSFunction.eFuncType = EuFuncType.Override;
			
			_oSFunction.sIniReturn = "Any";
			extractFunctionInfoReturn(_oSFunction);
			//_oSFunction.bConstructor = true;
			//_oSFunction.sRealName = Setting.sConstructorKeyword;
			//_oSFunction.eFuncType  = EuFuncType.Main; 

			
			_oSFunction.bNoLine = true; //If have no extention
			
			_oSFunction.aGeneratedLine.push("<cpp>");
			//_oSFunction.aGeneratedLine.push("return new c" + _oSClass.sName  + "(*this, _bDeepCopy);");
			_oSFunction.aGeneratedLine.push("return new c" + _oSClass.sName  + "(*this, _bDeepCopy);");
			_oSFunction.aGeneratedLine.push("</cpp>");
			
			//Call default extends function
			if (_oSClass.aExtendClass.length > 0) {
				/*
				var _oExtClass : SClass = _oSClass.aExtendClass[0]; //only one extend
				fCreateDefaultConstructor(_oExtClass); //recursive if not already analysed
				ExtractBlocs.oCurrSClass = _oSClass;
				ExtractBlocs.nCurrLine = _oSClass.nLine;
				
				fSetDefaultConstructLineToExtract(_oSFunction, _oExtClass);
				*/
			}
		}
		
		
		
		public static function fSetDefaultConstructLineToExtract(_oSFunction : SFunction, _oExtClass : SClass ){
			 
				if (_oExtClass.oFuncConstructor == null){return; }
				
				_oSFunction.aParamNotIni = _oExtClass.oFuncConstructor.aParamNotIni;
				
				var _oExtFunc : SFunction =  _oExtClass.oFuncConstructor;
				
				
				var _sParamList: String = "";
				if(_oSFunction.aParamNotIni.length > 0 ){
					//extractFunctionInfoParam(_oSFunction);
					
					var _nTotalExtendRemain : Int = _oExtFunc.aParamList.length;
					var _bFirst : Bool = true;
					for( _oParam  in _oSFunction.aParamList) {
						if (!_bFirst) {
							_sParamList += ", ";
						}
						_bFirst = false;
						_sParamList += _oParam.fGetName();
						
						_nTotalExtendRemain--;
						if (_nTotalExtendRemain == 0){
							break;
						}
					}
					
					/*
					for( _sParam  in _oSFunction.aParamNotIni) {
						if (!_bFirst) {
							_sParamList += ", ";
						}
						_bFirst = false;
						_sParamList += _sParam;
					}*/
					
					
				}
				
				_oSFunction.oSClass.sConstructLineToExtract = _oExtClass.sName + "(" + _sParamList + ")";
				//ExtractBlocs.extractLine( _oSFunction,  _oExtClass.sName + "(" + _sParamList + ")", _oSFunction.nLine + 1);
		}
		
		
		
		
		public static function fLoadGeneratedLine(_oSClass:SClass):Void {
			for (_oSFunc in _oSClass.aFunctionList){
				if (_oSFunc.aGeneratedLine.length != 0){
					for (_sLine in _oSFunc.aGeneratedLine){
					//	ExtractBlocs.extractLine( _oSFunc, _sLine, _oSFunc.nLine + 1);
					
						ExtractBlocs.extractLine( _oSFunc,  Text.removeComments( _sLine, _oSFunc, false, true)      , _oSFunc.nLine + 1);
					}
				}
			}
		}
		
		public static function fLoadDefaultConstructorLine(_oSClass:SClass):Void {
			if (_oSClass.sConstructLineToExtract != ""){
				ExtractBlocs.oCurrSFunc = _oSClass.oFuncConstructor;
				//ExtractBlocs.extractLine( _oSClass.oFuncConstructor,  _oSClass.sConstructLineToExtract, _oSClass.oFuncConstructor.nLine + 1);
				
				
				var _bFound : Bool = false;
				var i : Int = 0;
				while (i <  _oSClass.oFuncConstructor.aLineList.length){
					var _oLine =  _oSClass.oFuncConstructor.aLineList[i];
					if (_oLine.eType == EuVarType._LineReturn){
						ExtractBlocs.extractLine( _oSClass.oFuncConstructor,  _oSClass.sConstructLineToExtract, _oSClass.oFuncConstructor.nLine + 1, i);
						_bFound = true;
						i++;
					}
					i++;
				}
				
				if (!_bFound){
					ExtractBlocs.extractLine( _oSClass.oFuncConstructor,  _oSClass.sConstructLineToExtract, _oSClass.oFuncConstructor.nLine + 1);
				}

				ExtractBlocs.oCurrSFunc = null;
			}
		}
		
		
		private static function iniUseEnum(_oSClass:SClass):Void {
			var _aUseEnumIniStringFirst:Array<Dynamic> = _oSClass.aUseEnumIniStringFirst;
			var _aUseEnumIniStringAfter:Array<Dynamic> = _oSClass.aUseEnumIniStringAfter;
			
			var _i:UInt = _aUseEnumIniStringFirst.length;
			for (i in 0 ..._i) {
				var _sClass  : String = _aUseEnumIniStringFirst[i];
				var _sEnum  : String = Text.between3( _aUseEnumIniStringAfter[i], 0, EuBetween.Word);
				var _oEnumSClass : SClass = SFind.findClass(_oSClass, _sClass);
				var _oEnum : EnumObj = cast(SFind.findEnum(_oEnumSClass, _sEnum, false ));
				if (_oEnum == null) {
					Debug.fError("Enum of use Enum not found : " + _sEnum);
					Debug.fStop();
				}
				var _oUseEnum : UseEnum = new UseEnum(_oEnumSClass, _oEnum);
				_oSClass.aUseEnumList.push(_oUseEnum);
			
				
			}
			//TODO delete strin g to make more space
		} 
		
		private static function iniUseUnit(_oSClass:SClass):Void {
			var _aUseUnitIniStringFirst:Array<Dynamic> = _oSClass.aUseUnitIniStringFirst;
			var _aUseUnitIniStringAfter:Array<Dynamic> = _oSClass.aUseUnitIniStringAfter;
			
			var _i:UInt = _aUseUnitIniStringFirst.length;
			for (i in 0 ..._i) {
				var _sClass  : String = _aUseUnitIniStringFirst[i];
				var _sUnit  : String = Text.between3( _aUseUnitIniStringAfter[i], 0, EuBetween.Word);
				var _oUnitSClass : SClass = SFind.findClass(_oSClass, _sClass);
				var _oUnit : UnitObj = cast(SFind.findUnit(_oUnitSClass, _sUnit, false ));
			
				var _oUseUnit : UseUnit = new UseUnit(_oUnitSClass, _oUnit);
				_oSClass.aUseUnitList.push(_oUseUnit);
				
				
			}
			//TODO delete strin g to make more space
		} 
		
		
		//Create a var that will serve to tell compile that static class exist with the import list : import SimaCode.Test;  --> Test is the static var
		private static function iniClassVar(_oSClass:SClass,  _aImport:Array<Dynamic>, _eType:EuVarType):Void {
	
			//Debug.fBreak();
			//if (_oSClass.sName == "Root"){Debug.fBreak();	}
			
			//INI Static var class
			//Create associate static var to be conforme in code
			var _i:UInt = _aImport.length;
			for (i in 0 ..._i) {
				var _oImport : FileImport =	_aImport[i];
				//if(_eType == EuVarType._StaticClass){
				
				for(_oRefClass in _oImport.oRefPackage.aClassList){
					_oSClass.pushClassVar(new VarStaticClass(_oSClass, _oImport,_oRefClass));
				}
				//}else { // EuVarType._CppStaticClass
				//	_oSClass.pushClassVar(new VarCppStaticClass(_oSClass, _oImport));
				//}
			}
		}
		
		//Load all global var initilisation after static global var and before function
		//Set in extractVariable();
		//private var nExample : Int = _aCurrentVar[cVarListIniInString];
		private static function iniGlobalVar(_oSClass:SClass,  _aVarList: Array<Dynamic>,  _aIniList: Array<Dynamic>):Void {
		
			//Check all var
			var _i:UInt = _aVarList.length ;
			for (i in 0 ..._i) {
				
				//var _oVar : CommonVar = _aVarList[i];	
				iniAllTypeVar(_oSClass, _aVarList[i], _aIniList[i]);
				//_oVar.sIniInString  = null; //Save some little memory
			}
		}
		
		
		
		
		private static function iniAllTypeVar(_oSClass:SClass, _oVar : VarObj, _sIni:String, _bClassPush:Bool = true):Void  {
			
			//if ( Text.stringNotEmpty(_sIniType)) { //Or test null
				//var _sIniType : String = _oVar.sIniInString;
				ExtractBlocs.nCurrLine = _oVar.nLine;
				
				
				switch(_oVar.eType) {
					
					
					
					case EuVarType._CallClass : 
						
					
						cast(_oVar,VarCallClass).applyCallClass();
						if(_bClassPush){
							if(cast(_oVar,VarCallClass).bStatic){
								_oSClass.pushIniVar(_oSClass.aIniStaticVarList, _oVar, _sIni, _oSClass.aNotIniStaticVarList); 
							}else {
								_oSClass.pushIniVar(_oSClass.aIniGlobalVarList, _oVar, _sIni, _oSClass.aNotIniGlobalVarList); 
							}
						}
						
					//break;
					
					case EuVarType._HoldEnum : 
						cast(_oVar,VarHoldEnum).applyRefUnit();
						//rtuIni 
						if(_bClassPush){
							if(cast(_oVar,VarHoldEnum).bStatic){
								_oSClass.pushIniVar(_oSClass.aIniStaticVarList, _oVar, _sIni, _oSClass.aNotIniStaticVarList); 
							}else {
								_oSClass.pushIniVar(_oSClass.aIniGlobalVarList, _oVar, _sIni, _oSClass.aNotIniGlobalVarList); 
							}
						}
					//break;	
					
					
					case EuVarType._RtuMap
					| EuVarType._Rtu : 
						cast(_oVar,VarRtu).applyRefUnit();
						//rtuIni 
						if(_bClassPush){
							if(cast(_oVar,VarRtu).bStatic){
								_oSClass.pushIniVar(_oSClass.aIniStaticVarList, _oVar, _sIni, _oSClass.aNotIniStaticVarList); 
							}else {
								_oSClass.pushIniVar(_oSClass.aIniGlobalVarList, _oVar, _sIni, _oSClass.aNotIniGlobalVarList); 
							}
						}
					
					//break;
					
			
					case EuVarType._FixeArray 
					| EuVarType._QueueArray  
					| EuVarType._DArray 
					| EuVarType._DataArr 
					| EuVarType._ArrayView : 
						if(cast(_oVar,CommonVar).bStatic){
							_oSClass.pushIniVar(_oSClass.aIniStaticVarList, _oVar, _sIni, _oSClass.aNotIniStaticVarList); 
						}else {
							_oSClass.pushIniVar(_oSClass.aIniGlobalVarList, _oVar, _sIni, _oSClass.aNotIniGlobalVarList); 
						}
						
						iniAllTypeVar(_oSClass, cast(_oVar,VarArray).oVarsType, "", false );//Todo maybe ini
						cast(_oVar,VarArray).iniVarArray();
					//break;
					
					
					case EuVarType._Gate : 
						if(cast(_oVar,CommonVar).bStatic){
							_oSClass.pushIniVar(_oSClass.aIniStaticVarList, _oVar, _sIni, _oSClass.aNotIniStaticVarList); 
						}else {
							_oSClass.pushIniVar(_oSClass.aIniGlobalVarList, _oVar, _sIni, _oSClass.aNotIniGlobalVarList); 
						}
						
						iniAllTypeVar(_oSClass, cast(_oVar,VarGate).oTemplate, "", false );//Todo maybe ini
					
						cast(_oVar,VarGate).iniVarGate();
					
					//break;
					

					
					case EuVarType._QElement : 
					
						//rtuIni 
						if(_bClassPush){
							if(cast(_oVar,VarQElement).bStatic){
								_oSClass.pushIniVar(_oSClass.aIniStaticVarList, _oVar, _sIni, _oSClass.aNotIniStaticVarList); 
							}else {
								_oSClass.pushIniVar(_oSClass.aIniGlobalVarList, _oVar, _sIni, _oSClass.aNotIniGlobalVarList); 
							}
						}
						
						iniAllTypeVar(_oSClass, cast(_oVar,VarQElement).oType, "", false );//Todo maybe ini
						cast(_oVar,VarQElement).iniQueue();
						
					//break;
					
					case EuVarType._Delegate : 
						cast(_oVar,Delegate).iniInputDelegate(_sIni);
					//break;
					
					
					
				default :
						if (_bClassPush) {
							
							if(cast(_oVar,CommonVar).eConstant == EuConstant.Constant){
								_oSClass.pushIniVar(_oSClass.aIniConstVarList, _oVar, _sIni, _oSClass.aNotIniConstVarList); 
								
							}else if(cast(_oVar,CommonVar).bStatic){
								_oSClass.pushIniVar(_oSClass.aIniStaticVarList, _oVar, _sIni, _oSClass.aNotIniStaticVarList); 
							}else {
								_oSClass.pushIniVar(_oSClass.aIniGlobalVarList, _oVar, _sIni, _oSClass.aNotIniGlobalVarList); 
							}
						}
						
						//Initialisation
						
							
							//TODO make line
							
							//precalculateLine( _sInitialistion);
							//_aCurrentVar[cVarListValue] = oCalcuValue;
							
						
						
					//break;
				}
				
				
				
				
				
				
			//}
	
		}
			
		private static function getClassFromName(_oSClass:SClass, _sName:String):SClass {
				/*
			var _aList : Array<Dynamic> =  _oSClass.aClassVarList;
			var _i : UInt = _aList.length;
			for (i in 0 ...  _i) {
				var _oVar : CommonVar =  _aList[i];
				
				if (_oVar.sName == _sName) {
					return _oVar.oClass;
				}
			}
			
			Debug.trace3("Error no class from name found " + _sName  +  " in : " +_oSClass.sName);
			var _aBug : Array<Dynamic> = _aBug[36];*/
			return null;
		}
		
		
		private static function extractAllEnumSubVar(_oSClass:SClass):Void {
			var _aEnumList : Array<Dynamic> = _oSClass.aEnumList;
			var _i:UInt =  _aEnumList.length;
	
			for (i in 0 ..._i) {
				var _oEnum : EnumObj = _aEnumList[i];
				if(!_oEnum.isExtend()){ //Only if addExtendUnitDefinition is before
					extractEnumSubVarHeader(_oEnum,  _oEnum.nLine);
					extractEnumSubVarHeaderSetIni(_oEnum,  _oEnum.nLine);
				}
			}
		}
		
		
		
		
		private static function extractAllDelegate(_oSClass:SClass):Void {
			var _aDlgList : Array<Dynamic> = _oSClass.aDelegateList;
			var _i:UInt =  _aDlgList.length;
	
			for (i in 0 ..._i) {
				var _oDlg : Delegate = _aDlgList[i];
				_oDlg.iniDelegate();
				
			}
			
		}
		
		
		private static function extractAllUnitUnitSubVar(_oSClass:SClass):Void {
			
			var _aUnitList : Array<Dynamic> = _oSClass.aUnitList;
			var _i:UInt =  _aUnitList.length;
	
			for (i in 0 ..._i) {
				var _oUnit : UnitObj = _aUnitList[i];
			
				
				/*
				if ( aCurrentUnit[cUnitListSharing] == cQueueUnit) { //Special case of ini
					iniQueueArray(aCurrentUnit, aCurrentUnit[cUnitListLine], i);
				}else{*/
			
					if(!_oUnit.isExtend()){ //Only if addExtendUnitDefinition is before
						if (_oUnit.sIniList != null) {  //Initialisation is different in fonction creation
							extractUnitSubVarFunc(_oUnit, _oUnit.nLine);
						}else{
							extractUnitSubVarHeader(_oUnit,  _oUnit.nLine);
						}
					}
				//}
			}
		}
		
		
		private static function extractEnumSubVarHeader( _oEnum : EnumObj, _nLineNum:UInt):Void {
			//Get all sub vars
			var _sLine : String;
			var i : UInt = _nLineNum+1;
			var _nFound : Int;
			
			
			var _aFile : Array<Dynamic> = _oEnum.oSClass.aFile;
			var _nMax : Int = _aFile.length;
			while (i < _nMax) { 
				
				_sLine = _aFile[i];
				_nFound = Text.search(_sLine, "}");
				if (_nFound >= 0) {
					break;
				}else {
					extractEnumSubVar(_oEnum, _sLine, _nLineNum);
				}
				i++;
			}
			
			if (i == _nMax) {
				Debug.fError("no end of unit }");
			}
		}
		
		private static function extractEnumSubVarHeaderSetIni( _oEnum : EnumObj, _nLineNum:UInt):Void {
			var _aSubVarList : Array<Dynamic>;
			_aSubVarList = _oEnum.aVarList;
			switch(_oEnum.oVarsType.eType ) {
				case EuVarType._Int:
					extractEnumSubVarHeaderBuilAlreadySet_Int(_oEnum, _aSubVarList, _nLineNum);
					extractEnumSubVarHeaderSetIni_Int(_oEnum, _aSubVarList, _nLineNum);
				//break;
				default:
			}
		}
		
		private static function extractEnumSubVarHeaderBuilAlreadySet_Int(_oEnum: EnumObj, _aSubVarList:Array<Dynamic>, _nLineNum:UInt):Void  {
			var _i:UInt = _aSubVarList.length;
			for (i in 0 ..._i) {
				var _oSubEnum : VarObj = _aSubVarList[i];
				if (_oSubEnum.eType == EuVarType._ParamInput) {
					
					//Only first var for now, TODO better interpretation
					var _oVar : VarObj = cast(_oSubEnum,ParamInput).aVarList[0];
					switch (_oVar.eType) {
						case EuVarType._UInt | EuVarType._Int: 
							_oEnum.aAlreadyIniVal.push(	cast(_oVar,VarInt).nValue);
						//break;
						case EuVarType._Hex: 
							_oEnum.aAlreadyIniVal.push(	cast(_oVar,VarHex).nValue);
						//break;
						default:
				
					}
					
					

				}
			}
		}
		
		private static function fGetNextNotUsedEmumVal(_oEnum : EnumObj, _nIsExist:Int):Int  {
			for (i in 0 ... _oEnum.aAlreadyIniVal.length) {
				var _nVal : Int =  _oEnum.aAlreadyIniVal[i];
				if (_nIsExist == _nVal) {
					_nIsExist ++;
					return fGetNextNotUsedEmumVal(_oEnum, _nIsExist);
				}
			}
			return _nIsExist;
		}
		
		
		
		private static function extractEnumSubVarHeaderSetIni_Int(_oEnum : EnumObj, _aSubVarList:Array<Dynamic>, _nLineNum:UInt)  :Void {
			var _i:UInt = _aSubVarList.length;
			var _nFillVal : Int = 0; 
			
			for (i in 0 ..._i) {
				var _oSubEnum : VarObj = _aSubVarList[i];
				if (_oSubEnum.eType == EuVarType._ParamInput) {
					
					
				}else { //No Input set a value chage it to a param input
					
					//Convert to ParamInput
					var _sLine : String = "= 0;"; //Force for enum Todo optimize
					_aSubVarList[i] = cast(ExtractLines.newLineSet(_oEnum.oSClass,   _sLine.substring(1, _sLine.length), _oEnum.nLine, EuVarType._ParamInput, _oSubEnum,false,EuOperator.None),ParamInput);
					_oSubEnum = _aSubVarList[i];
					var _oVar : VarInt = cast(cast(_oSubEnum,ParamInput).aVarList[0]);
					
					_nFillVal = fGetNextNotUsedEmumVal(_oEnum, _nFillVal);
					_oVar.nValue = _nFillVal;
					_nFillVal ++;
				}
			}
			
			
			
			/*
				_nIndex = _sLine.length;
				_sLine += "= 0;"; //Force for enum Todo optimize
				return ParamInput(ExtractLines.newLineSet(_oSBloc,   _sLine.substring(_nIndex + 1, _sLine.length), _oSBloc.nLine, EuVarType._ParamInput, _oVar));
				*/
			
		}
		
		
		
		//private unit uPoint {
			//nX : Int; 	//this
			//nY : uInside; //this
			//nZ : Int; 	//this
		//}
		private static function extractUnitSubVarHeader( _oUnit : UnitObj, _nLineNum:UInt):Void {
					
			//Get all sub vars
			var _sLine : String;
			var i : UInt = _nLineNum+1;
			var _nFound : Int;
			
			
			var _aFile : Array<Dynamic> = _oUnit.oSClass.aFile;
			var _nMax : Int = _aFile.length;
			while (i < _nMax) { 
				
				_sLine = _aFile[i];
				_nFound = Text.search(_sLine, "}");
				if (_nFound >= 0) {
					break;
				}else {
					extractUnitSubVar(_oUnit, _sLine, _nLineNum);
				}
				i++;
			}
			
			if (i == _nMax) {
				Debug.fError("no end of unit }");
			}
		}
		
		private static function extractUnitSubVarFunc( _oUnit : UnitObj, _nLineNum:UInt):Void {

			//Get all sub vars
			var _aLine : Array<Dynamic> = _oUnit.sIniList.split(",");
			var _i:UInt = _aLine.length;
			for (i in 0 ..._i) {
				var _sLine :  String = _aLine[i];
				extractUnitSubVar(_oUnit, _sLine, _nLineNum);
				
			}
			_oUnit.sIniList = null; //Save some memory
			
		}
		
		
		private static function extractEnumSubVar( _oEnum : EnumObj, _sLine:String, _nLineNum:UInt):Void {
			//Get vars
			var _nFound : Int = Text.search(_sLine, ":");
			if (_nFound == -1) {
				switch (_oEnum.oVarsType.eType) {
					case EuVarType._Int:
						_sLine += ": Int";
					//break;
					default:
				}
			}
			
			var _oVar : VarObj =  newVarParam(_oEnum.oSClass, _sLine, _nLineNum, true);
			_oEnum.pushVar(_oVar);
		}
		
		
		private static function extractUnitSubVar( _oUnit : UnitObj, _sLine:String, _nLineNum:UInt):Void {
			//Get vars
			var _nFound : Int = Text.search(_sLine, ":");
			if (_nFound >= 0) {
				
			
				var _oVar : VarObj =  newVarParam(_oUnit.oSClass, _sLine, _nLineNum);
				//aCurrentVar[cVarListInsideUnit] = _nUnitId;
				_oUnit.pushVar(_oVar);
			}
		}
		
		
		
		
		private static function extractFunctionInfo(_oSClass : SClass):Void {
			var _aFuncList : Array<Dynamic>;
			_aFuncList = _oSClass.aFunctionList;
			var _i:UInt = _aFuncList.length;
			for (i in 0 ..._i) {
				var _oSFunction : SFunction =  _aFuncList[i];
				
			//	if (_oSFunction.eSharing == EuSharing.Destructor){ 
			//		_oSFunction.sIniReturn = "Void";
			//	}	
				//if (_oSFunction.eSharing != EuSharing.Destructor){ //Not sure
					ExtractBlocs.oCurrSFunc = _oSFunction;
					extractFunctionInfoParam(_oSFunction);
					extractFunctionInfoReturn(_oSFunction);
					ExtractBlocs.oCurrSFunc = null;
				//}
			}
			
		}
		
		private static function extractFunctionInfoSignature(_oSClass : SClass):Void {

			for (_oSFunction in _oSClass.aFunctionList) {
				_oSFunction.fExtractFunctionInfoSignature();
			}
			
		}
		private static function extractFunctionInfoOverride(_oSClass : SClass):Void {

			ExtractBlocs.oCurrSClass = _oSClass;
			if(!_oSClass.bIsPod && !_oSClass.bIsResults && !_oSClass.bIsVector){
				//_oSFunction.fExtractFunctionInfoSignature();
				for (_oSFunction in _oSClass.aFunctionList) {
					ExtractBlocs.nCurrLine = _oSFunction.nLine;
					_oSFunction.fExtractFunctionInfoOverride();
				}
			}
			
		}
		
	
		
		
		public static function extractFunctionInfoParam(_oSFunc:SFunction):Void {
			
			var _aParam : Array<Dynamic> = _oSFunc.aParamNotIni;
			var _i:UInt = _aParam.length;
			for (i in 0 ..._i) {
				var _sParam : String = _aParam[i];
				var _oParam : VarObj = newVarParam(_oSFunc, _sParam, _oSFunc.nLine);
				_oSFunc.pushParam(_oParam);

			}
			
		}
		
		
		public static function extractFunctionInfoReturn(_oSFunc:SFunction):Void {
			
			var _sType : String = Text.between3(_oSFunc.sIniReturn, 0,  EuBetween.Word);
		
			//var _eType:UInt = TextType.stringToType(_sType);
		
			var _oReturn : CommonVar = TypeResolve.createVarWithType(_oSFunc, _sType, _oSFunc.sIniReturn, Text.nCurrentIndex );
			if (_oReturn.eType == EuVarType._CallClass) { //Return are alway scope owner with RVO
				cast(_oReturn,VarCallClass).bScopeOwner = true;
			}
			_oSFunc.oReturn = _oReturn;
			
			
		}
		
		
		
		
		public static function newVarParam(_oSBloc : SBloc,  _sLine: String, _nLineNum : UInt, _bForceParamInput : Bool = false):VarObj {
			
		
			ExtractBlocs.nCurrLine = _nLineNum;
			
			var _eConstant : EuConstant = EuConstant.Normal;
			var _sName : String;
			var _sType : String;
			
			if (Text.search(_sLine, ":") != -1) { //If ":" found
				
	
				_sName  =  Text.between3(_sLine, 0,EuBetween.Word);
					
				//Type
				_sType  =  Text.between2(_sLine, ":", Text.nCurrentIndex,EuBetween.Word);
				
				//May have a pointer * symbole ex : sNext : *uDispacher;
				if (_sType == null) { //Stopped by the star
					if (_sLine.charAt(Text.nCurrentIndex) == "*") {
						//Pointer unit to don't use any autocreation system
						_eConstant = EuConstant.Pointer;
						
						//Redo type
						_sType =  Text.between2(_sLine, "*", Text.nCurrentIndex,EuBetween.Word);
					}
				}
				
			}else { //If ":" not found -- its only a type (Ex For Delegate)
				_sType =  Text.between3(_sLine, 0,EuBetween.Word);
				_sName = "";
			}
				
			var _oVar : CommonVar = TypeResolve.createVarWithType(_oSBloc, _sType, _sLine, Text.nCurrentIndex);


			//_oVar.oClass = _oSBloc.oSClass;
			_oVar.nLine = _nLineNum;
			_oVar.sName = _sName;
			_oVar.eConstant = _eConstant;
			
			/*
			//If array
			if(aCurrentVar[cVarListType] == cTypeArray){

				createArrayVar(_sLine);
			

			}else if (aCurrentVar[cVarListType] == cTypeQueueArray) {
				//createQueueArrayUnit(_sType, aCurrentVar);
				aCurrentVar[cVarListQueueRef] =  aCurrentClassQueueName[aCurrentVar[cVarListIniInString]];
			
				
			//If rtu
			}else if (aCurrentVar[cVarListType] == cTypeRtu) {
					
				aCurrentVar[cVarListUnitRef] = getRtuInput( _sType );
				//aCurrentVar[cVarListUnitLength] = nReturnRtuLength;
				
			//ClassType
			}else if (aCurrentVar[cVarListType] == cTypeCallClass) {
				
				aCurrentVar[cVarListClass] = getClassId(_sType);
				if (nReturnGetClassLoc >= 0) { //Cpp
					aCurrentVar[cVarListLocation] = nReturnGetClassLoc;
				}
			}
			*/
			
			var _nIndex : Int = Text.search(_sLine, "=", 0);
			if (_nIndex >= 0) {
				var _oParamInput : ParamInput = cast(ExtractLines.newLineSet(_oSBloc,   _sLine.substring(_nIndex + 1, _sLine.length), _oSBloc.nLine, EuVarType._ParamInput, _oVar,false,EuOperator.None));
				return _oParamInput;
			
			}else if (_bForceParamInput) {
				/*
				_nIndex = _sLine.length;
				_sLine += "= 0;"; //Force for enum Todo optimize
				return ParamInput(ExtractLines.newLineSet(_oSBloc,   _sLine.substring(_nIndex + 1, _sLine.length), _oSBloc.nLine, EuVarType._ParamInput, _oVar));
				*/
			}
			
			return _oVar;
		}
		

		
		public static function iniThreadTemplate(_oSClass:SClass):Void { 
			//Debug.trace3("---Load Thread Template");
			if( _oSClass.sThreadClass != ""){
				_oSClass.oThreadClass = SFind.findClass(_oSClass, _oSClass.sThreadClass);
			}
			
		}
		
		//Only for error throw because this can cause stange errors (like function signature)
		public static function fVerifyCollisionNameExtended(_oSClass : SClass):Void {
			ExtractBlocs.oCurrSClass = _oSClass;
			var _aVarList : Array<Dynamic> =  _oSClass.aGlobalVarList;
			for( _oExtend  in _oSClass.aExtendAllClassList) {
				var _aExtendList : Map<String,Bool> =  _oExtend.aHashGlobalVarList;
				for( _oVar  in _aVarList) {
					if (_aExtendList[_oVar.sName] == true) {
					
						ExtractBlocs.nCurrLine = _oVar.nLine;
						Debug.fError("Extend var with same name, global var cannot be overrided : " + _oVar.sName + " in " + _oExtend.sName);
					}
				}
			}
			
			//Verify enum
			var _aEnumList : Array<Dynamic> =  _oSClass.aEnumList;
			for( _oExtend   in _oSClass.aExtendAllClassList) {
				var _aExtendEnumList :  Map<String,Bool> =  _oExtend.aHashEnumList;
				for( _oEnum  in _aEnumList) {
					if (_aExtendEnumList[_oEnum.sName] == true) {
						ExtractBlocs.nCurrLine = _oEnum.nLine;
						Debug.fError("Extend enum with same name, enum cannot be overrided : " + _oEnum.sName + " in " + _oExtend.sName);
					}
				}
			}
			
			
			
			
		}
		
		
	
		
			
	}
		

