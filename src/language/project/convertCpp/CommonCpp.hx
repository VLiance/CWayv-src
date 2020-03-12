package language.project.convertCpp ;
	import language.enumeration.EuClassType;
	import language.enumeration.EuConstant;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuVarType;
	import language.enumeration.EuSharing;
	import language.enumeration.EuOperator;
	import language.project.convertSima.ExtractBlocs;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.pck.SLib;
	import language.project.convertSima.SFunction;
	import language.project.CppProject;
	import language.project.convertSima.SPackage;
	import language.project.convertSima.TypeResolve;
	import language.vars.special.UnitObj;
	import language.vars.special.VarFixeArray;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.Delegate;
	import language.vars.varObj.EaseOut;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.VarCallClass;
	import language.vars.varObj.VarCppLine;
	import language.vars.varObj.VarHoldEnum;
	import language.vars.varObj.VarObj;
	import language.base.InObject;
	import language.base.Root;
	import language.base.Debug;
	/**
	 * ...
	 * @author ...
	 */
	class CommonCpp extends FileForm
	{
		public var oCppProject : CppProject;
		//public var oSClass : SClass;
		public var oSPackage : SPackage;
		
		public function new(_Main:Root, _oCppProject : CppProject, _oSPackage : SPackage) {
			super(_Main);
			oCppProject = _oCppProject;
			oSPackage = _oSPackage;
		}
		
		
		private function getVarToConvert_(_aVarList : Array<Dynamic>, _nSharing:EuSharing):Void {
			
				getVarToConvert(_aVarList, _nSharing , false, false,  EuConstant.Normal);
		}
		
		
		private function getVarToConvert(_aVarList : Array<Dynamic>, _nSharing:EuSharing, _bStatic:Bool = false, _bStaticInClass:Bool = false, _nConstant : EuConstant, _bInHeader : Bool = false):Void {
			//addTab();
		
			
			var _sExtern : String = "";
			var _sIni : String = "";
			var _bAddLib : Bool = false;
			if (_bStatic) {
				if (_bStaticInClass) {
					//_bAddLib = true;
				}else {
					_sExtern = "extern ";
				}
			}
	
			var _i : UInt = _aVarList.length;
			for (i in 0 ...  _i) {
				
				
				var  _oVar : VarObj = _aVarList[i];
			
				
				if (_oVar.eType == EuVarType._LineInput) {
					var  _oLineInput :LineInput = cast(_oVar,LineInput);
					_sIni = " = " + ConvertLines.convertInputLine(null, _oLineInput, EuOperator.None, true);//LineInput
					_oVar = _oLineInput.oVarInput;
				}
					
					var  _oCommonVar :CommonVar = cast(_oVar,CommonVar);
				//Only private/public var
				
				
				
				if (_oCommonVar.eSharing == _nSharing && _oCommonVar.eConstant == _nConstant) {
					/*
					if (_bStatic ) {
					//	_sIni = " = " +  _oVar.;
					}*/
					
					if (_oCommonVar.bAtomicComplexe) {
						if(_bInHeader ){ //Inline header only
							pushLine("gzAtom(" + TypeText.typeToCPP(_oVar) + ", " +  _oCommonVar.sName   + ");");
						}
						
					}else{
						pushLine(_sExtern + convertVar(_oCommonVar, _bAddLib) + _sIni + ";");
					}
					 
					 
					 
				}
				
				
				
				
			}
		
			

			//addSpace();
		}
		
		
		private function convertFunctionClass(_oSFunction : SFunction, _nFuncIndex : Int , _bInline : Bool = false ):Void {

			
			if ( _oSFunction.eFuncType == EuFuncType.Pure){
				//Pure are inlined in header now --> //Change my mind (Maybe when inlined)
			//	return;
			}
			
			
				var _oSClass : SClass = _oSFunction.oSClass;
			ExtractBlocs.oCurrSClass = _oSFunction.oSClass;
			ExtractBlocs.nCurrLine = _oSFunction.nLine;
			//Return
			//ConvertLines.oCurrClass = oSClass; //Warning -> Global
			var _sStack : String = " gz_(" + _nFuncIndex + ")";
			
			
			var _sMainFunctionLib : String = "";
			var _sReturn : String;
			var _sInline : String = "";
			var _sIni : String;
			
			var _sLib : String = _oSClass.oSLib.sWriteName;
			//var _sExtendClass : String = "";
	
			//var _sClass : String = _sLib + "_" +  oSClass.sName + "::";
			var _sClass : String =    _oSClass.sName + "::";
			if (_bInline){
				_sInline = "inline ";
				_sClass = "";
			}
			
			
			
			if (_oSFunction.bConstructor) {
				//Constructor
				//_sMainFunctionLib = _sLib + "_"
				_sMainFunctionLib = "c";
				//_sReturn = "";
				//_sExtendClass =  getExtendClassToString(oSClass);
				//_sIni = convertConstructorIni();
				
			}else {
				//_sIni = "";
				//Todo useClass param
				/*
				var _nRet :UInt = _oSFunction.oReturn;
				
				if (_nRet == cTypeArray || _nRet == cTypeCallClass || _nRet ==  cTypeIU || _nRet ==  cTypeRtu) {
					_sReturn = _sClass + typeToCPP(aCurrentClassFunction[_nFuncId], false,true) + " ";
					
				}else {
					//Basic type
					_sReturn = numTypeToCPP(_nRet, false) + " ";
				}*/
				
				//Basic type
				//_sReturn = TypeText.typeToCPP(_oSFunction.oReturn, true) + " ";
			}

			_sReturn = TypeText.typeToCPP(_oSFunction.oReturn, true) + " ";
			var _sMustReturn = "return ";
			if (_oSFunction.oReturn.eType == EuVarType._Void  ){
				_sMustReturn = "";
			}
			
			
			
			
			var _sFuncName : String = _sMainFunctionLib + _oSFunction.sName;
			
			
			//Param
			var _sParam : String;
			if ( _oSFunction.eFuncType == EuFuncType.Pure || _sInline != ""){
				_sParam  =  getFunctionParam(_oSFunction);	
			}else{
				_sParam  =  "c" + _oSClass.sName +  "* _this" + getFunctionParam(_oSFunction,false,false,false);	
			}
			
			

			//Static
			var _sStatic : String =  "c";
			 //In lib def with namwspace now
			 
		
			if ( _oSFunction.eFuncType == EuFuncType.Pure){
				_sStatic = "p";
				pushLine("#ifndef tFDef_" + _oSFunction.oSClass.oPackage.sHeaderName + "_" + _oSFunction.sName);
			}else if (_oSFunction.bStatic ) {
				//_sStatic = "cs";
				_sStatic = "c"; //Now auto sigleton, mabe make pure static?
			}
			
			if (_bInline){
				_sStatic = "";
			}
			
			var _sClassFuncName: String = "";
			var _sFuncExport: String = "";
			var _sPtrFuncName : String = "";
			var _sPtrFuncNameNs : String = "";
			
			//if (_oSFunction.eFuncType == EuFuncType.Main &&  oSClass.bExtension) { //Special case for class extension They have no param
		///	if (_oSFunction.bConstructor ) {
			if (_oSFunction.bConstructor ) {
				
		/* Use inline constructor instead for performances, TODO Verify  
				var _sEmbedIni :String = fGetEmbedVarIni(oSClass);
				
				
				if( !oSClass.bIsPod){
				
					//pushLine(_sReturn + _sClass + _sFuncName + "()" + _sIni + "{");

					if(!fIsHaveStack(oSClass)){
						//pushLine(_sReturn + "c" + _sClass + _sFuncName + "(Lib_GZ::Base::cClass* _parent)" + getExtendClassToStringIni(oSClass) + _sEmbedIni +"{");
						pushLine(_sReturn + "c" + _sClass + _sFuncName + "(Lib_GZ::Base::cClass* _parent)" + getAllExtendClassToString(oSClass, "(_parent)") + _sEmbedIni +"{");
					}else {
						//pushLine(_sReturn + "c" + _sClass + _sFuncName + "(Lib_GZ::Base::cClass* _parent)" + getExtendClassToStringIni(oSClass) + _sEmbedIni );
						pushLine(_sReturn + "c" + _sClass + _sFuncName + "(Lib_GZ::Base::cClass* _parent)" + getAllExtendClassToString(oSClass, "(_parent)") + _sEmbedIni );
						//pushLine(":");
						fGetStackIniAll(_oSFunction);
						pushLine("{" + _sStack);
					}
				}else {
					pushLine(_sReturn + "c" + _sClass + _sFuncName + "()" +  _sEmbedIni );
					fGetStackIniAll(_oSFunction);
					pushLine("{" + _sStack);
				}
				
			 */	
			}else {
				//pushLine(_sReturn + _sClass + _sFuncName + "(" + _sParam + ")" + _sIni + "{");
				var _sAddNamespace : String = "";
				if (_oSFunction.bHaveCpp){ //Have Cpp
					//Add Namespace for extended class constant //TODO add if they avec <namespace> code
					_sAddNamespace = "using namespace " + _oSFunction.oSClass.sName +  ";";
					for (_oClass in _oSFunction.oSClass.aExtendAllClassList){
						if (_oClass.aConstList.length != 0){
								_sAddNamespace +=  "using namespace " + _oClass.sNsAccess + _oClass.sName +  ";";
						}
					}
				}
				
				
				if( _oSFunction.eFuncType == EuFuncType.Pure || _sInline != ""){
					pushLine(_sInline + _sReturn + _sStatic + _sClass  + _sFuncName + "(" + _sParam + "){" + _sStack + _sAddNamespace);
				}else{
				///	pushLine("GzExport "   + _sReturn +   _sStatic +	_oSClass.sCFuncName  + _sFuncName  + "(" + _sParam + ")" + "{" + _sStack +  _sAddNamespace); //_sInline/_sStatic? just for tests
					_sPtrFuncName = _oSClass.sCFuncName  + _sFuncName  + getFunctionSignature(_oSFunction);
					_sPtrFuncNameNs = _sFuncName;
					//pushLine("GzExport "   + _sReturn  +	_sPtrFuncName + "(" + _sParam + ")" + "{" + _sStack +  _sAddNamespace); //_sInline/_sStatic? just for tests
					_sFuncExport = "GzExport "   + _sReturn  +	_sPtrFuncName  + "(" + _sParam + ")" + "{" + _sStack +  _sAddNamespace;
					
					_sClassFuncName =   "c" + _sClass  + "FB_" +  _sFuncName;
					pushLine("inline " + _sReturn  + _sClassFuncName+ "(" + getFunctionParam(_oSFunction) + "){" + _sStack + _sAddNamespace);
				
				}
				
			
				
			}
			
			
			addTab();
			//addSpace();
			
			
			if (  !_oSClass.bIsResults && !_oSClass.bIsPod){ //TODO put it, in a inlined func
			
				
				if (_oSFunction.bConstructor ) {//TODO 
			
					//if(!oSClass.bIsPod){
					
				/* Use inline constructor instead for performances, TODO Verify  
						iniGlobalVar();
				
						//pushLine("//Special var ini");
						ConvertLines.convertSpecialVarConstructorIni(this, _oSFunction);
						iniAssociateVar();
						
						//Special for calss extention type, we don't initialise constructor now becauswe we have an illogical execution order
						//if( oSClass.bExtension){ //Now Always
							addSpace();
							subTab();
							pushLine("}");
							addSpace();
					//}
				*/
					
				
					_sPtrFuncName =	_oSClass.sCFuncName  + Setting.sConstructorKeyword + getFunctionSignature(_oSFunction);
					_sPtrFuncNameNs = Setting.sConstructorKeyword ;
					//pushLine(_sInline + _sReturn + "c" + _sClass + Setting.sConstructorKeyword  + "(" + _sParam + ")" + "{" + _sStack);
					
					
					_sClassFuncName =  "c" + _sClass + "FB_" +  Setting.sConstructorKeyword ;
					pushLine("inline "  + _sReturn + _sClassFuncName + "(" + getFunctionParam(_oSFunction)  + ")" + "{" + _sStack);
					//pushLine("GzExport "  + _sReturn + _sPtrFuncName  + "(" + _sParam + ")" + "{" + _sStack);
					_sFuncExport = "GzExport "  + _sReturn + _sPtrFuncName  + "(" + _sParam + ")" + "{" + _sStack;
					
					
					
					
					addTab();
				//	pushLine("//Special var ini");
				//	ConvertLines.convertSpecialVarConstructorIni(this, _oSFunction); //TODO must be before Cpp section initilizer
						
					//}
					iniEmbedVar(_oSClass); //TODO?
				}
				//addSpace();
				
				//Do all function lines
				ConvertLines.convertFunctionLines(this, _oSFunction);
			//	ConvertLines.convertBlocLines(this, _oSFunction);
				addOverrideFunctionLines(_oSFunction); //Exmple Opengl generated function
				

				fAddMissingReturnInFunction(_oSFunction);
			
				
				
				subTab();
				
				//ConvertLines.oCurrClass = null;  //Warning -> Global
				pushLine("}");
				
				//Warpper
				if (  !_bInline && _oSFunction.eFuncType != EuFuncType.Pure && !_oSClass.bIsResults && !_oSClass.bIsPod){

					pushLine(_sFuncExport);
					pushLine(_sMustReturn + "_this->" + _sClassFuncName + "(" +  getFunctionParam(_oSFunction,false,true) + ");");
					pushLine("}");
				}
			}
		
			//Function table
			if ( _sPtrFuncName != "") {
				
				// void (*fun_ptr)(int) = fun; 
		//		pushLine( "namespace "  + 	_oSClass.sName + "{" +  fGetObjFPtrName(_oSFunction, _sReturn, _sPtrFuncNameNs, _sParam) + " = " + _sPtrFuncName + ";" + "}");
	
			}
		
			
			
			
			if (_oSFunction.eFuncType == EuFuncType.Pure){
				pushLine("#endif");
			}
			addSpace();
		}
		
		
		public function addOverrideFunctionLines(_oSFunction : SFunction):Void {
			
			
		}
		
		public  function fAddMissingReturnInFunction(_oSFunc:SFunction):Void { //Add nullable retrun to give cpp compiler happy
			if (_oSFunc.oReturn.eType != EuVarType._Void) {
				//var _bRet : Bool = false;
				for(  _oLineRet   in  _oSFunc.aLineReturnList  ) {//LineReturn
					//pushLine("_oLineRet;" + _oLineRet.eType);
					if (_oLineRet.oSBloc ==  _oSFunc) {
						return;
						//_bRet = true;
					}
			
				}
				//pushLine("return " + fFixReturnCallType(_oSFunc.oReturn) + ";" + _oSFunc.oReturn.eType);
				pushLine("return " + fFixReturnCallType(_oSFunc.oReturn) + ";");

			}
		}
		public  function fFixReturnCallType(_oType : VarObj):String {
			switch(_oType.eType) {
				case EuVarType._Bool :
					return "false";
				//break;
				
				case EuVarType._UInt 
				| EuVarType._Int :
					return "0";
				//break;
				case EuVarType._Float :
						return "0.0";
				//break;
				case EuVarType._String :
						return "gzU8(\"\")";
				//break;
				
				case EuVarType._Val :
					return "GzNullVal";
				//break;
				default :
					return "NULL";
					//return "zNull";
				//break;
			}
			return "";
		}
		
		
		
		private function iniEmbedVar(_oSClass:SClass):Void {
			var _aList : Array<Dynamic> = _oSClass.aEmbedVarList;
			var _i : UInt = _aList.length;
			var _sIni : String = "";
			for (i in 0 ...  _i) {
				var _oVar : VarCallClass = _aList[i];
				pushLine(_oVar.sName + "->Ini_c" +  _oVar.oCallRef.sName + "(" +  fGetDefaultParam(_oVar.oCallRef) + ");");
			}
		}
		
		private function fGetDefaultParam(_oSClass:SClass):String {
			var _defaultIni : String = "";
			for (  _oVar in _oSClass.oFuncConstructor.aParamList ) {//VarObj
				switch (_oVar.eType) {
					case EuVarType._String :
						_defaultIni += "";
					//break;
					
					default :
						_defaultIni += "0";
					//break;
					
					
				}
				_defaultIni += ",";
			}
			return _defaultIni.substring(0, _defaultIni.length-1);
			
		}
		
		
				
		
		public function freeAll(_oSClass:SClass):String {
			
			var _sResult : String = "";
			//addTab();
			var _aVarList  : Array<Dynamic>  = _oSClass.aIniGlobalVarList;
			var _i:UInt = _aVarList.length;
			for (i in 0 ...  _i) {
				_sResult += freeAllVarObj(_aVarList[i]);
			}
			//subTab();
			return _sResult;
		}
	
		public function freeAllVarObj(_oVar:VarObj):String {
			switch (_oVar.eType) {
				case EuVarType._FixeArray :
					var _oVarFixeArray : VarFixeArray = cast(_oVar);
					if (_oVarFixeArray.nStartSize != 0) { //only if we have setted size
						return "GZ_fFree(" + _oVarFixeArray.sName + ");";
					}
				//break;
				default:
			}
			return "";
		}
		
		
		
		private function convertVar(_oVar : CommonVar, _bAddLib:Bool = false):String {
			var _sLine : String = "";
			var _sLib: String = "";
			if (_bAddLib) {
				//_sLib = oSClass.oSLib.sWriteName + "::" + oSClass.sName + "::";
				_sLib = oSPackage.sNsAccess;
			}
			
	
			if (_oVar.eConstant == EuConstant.Constant) {
				_sLine += "const "; 
			}
			
			
			//Get type
			//Ex: Int nExample;
			_sLine += TypeText.typeToCPP(_oVar);
			
			
		
		
			
			
			_sLine += " ";
			
			
			//Name
			_sLine +=  _sLib + _oVar.sName;
			
			//Add Initialisation for static var
			//if (_bAddLib && _oVar. _aCurrentVar[cVarListValue] != null) {
			//	_sLine += " = " + _aCurrentVar[cVarListValue];
			//}
		
			//push
			return _sLine;

		}
		
		
		public static function  getFunctionSignature(_oSFunction:SFunction):String{
			var _aParam : Array<VarObj> = _oSFunction.aParamList;
			
			var _sSignatrue : String = "_";
			if (_oSFunction.oReturn != null){
				_sSignatrue += _oSFunction.oReturn.fGetSingature();
			}else{
				_sSignatrue += "v"; //v for void
			}
			//var _sSignatrue : String = "_"; //Return affect signature
			for (_oObj in _aParam) {
				_sSignatrue += _oObj.fGetSingature();
			}
			return _sSignatrue;
		 }
		
		 
		 
		public static function getFunctionParam(_oSFunction:SFunction, _bHeader:Bool = false, _bOnlyVar:Bool = false, _bFirst:Bool = true, _bWebGL:Bool = false, _bNotClassFunc:Bool = false):String {//, _bOnlyType:Bool = false
			var _sInputVarString : String = "";
			var _sParam : String = "";
			var _aParam : Array<Dynamic> = _oSFunction.aParamList;
			var _i : UInt = _aParam.length;
			for (i in 0 ...  _i) {
								
				if (i != 0 || !_bFirst) { //Not the last
					_sParam += ", ";
				}
				
				var _oParam : VarObj = _aParam[i];
				
				if (_oParam.eType == EuVarType._ParamInput) {

					var _oParamInput : ParamInput = cast(_oParam);
					if(!_bOnlyVar){
						_sInputVarString  =  TypeText.typeToCPP(_oParamInput.oVarInput, false,false,false,true) + " ";
					}
					 _sParam +=   _sInputVarString + ConvertLines.convertCppVarType( _oParamInput.oVarInput, _oSFunction.nLine,false,null, _oSFunction);
					  
					 if(_bHeader){ //line after =
						 var _sParamInput : String = ConvertLines.convertCppVarType(_oParamInput, _oParamInput.nLine); 
						 _sParam +=  " = " + _sParamInput;
					 }
					 
				}else {
					if(!_bOnlyVar){
						_sInputVarString =  TypeText.typeToCPP(_oParam, false, false, false, true) + " " ;
					}
					
					if (_bWebGL) {
						_sParam +=   fConvertWebGL(_sInputVarString + ConvertLines.convertCppVarType(_oParam,  _oSFunction.nLine,false,null, _oSFunction), _oParam);
					}else {
						_sParam +=   _sInputVarString + ConvertLines.convertCppVarType(_oParam,  _oSFunction.nLine,false,null, _oSFunction);
					}
				}
			
			}
			
			var _bEmpty : Bool = false;
			if (_sParam == "" && _bFirst ){
				_bEmpty = true;
			}
			
			if (!_oSFunction.bConstructor &&  !_bNotClassFunc  &&  _oSFunction.oSClass.oPackage.oSFrame.bAddDebugFile){ //!TODO add a "pragma to auto add debug line --> OGL temps get line info
				
				if(_bOnlyVar){
					_sParam += "  GZ_DbgFile";
				}else{
					if (_bHeader){
						_sParam += "  GZ_DbgArgP";
					}else{
						_sParam += "  GZ_DbgArg";
					}
					
				}
				
				if(_bEmpty){
					_sParam += "_";
				}
				
			}

			return _sParam;
		}
		
		private static function fConvertWebGL(_sParamString, _oParam:VarObj):String {
			switch(_oParam.eType) {
				case EuVarType._HoldEnum :
					_sParamString = "gzInt(" + _sParamString + ")";
				//break;
				default:
				
			}
			
			return "gzVal(" + _sParamString + ")";
		}
		
		
		
		//For OGL Func
		private function getFunctionParamToStringOGL(_oSFunction:SFunction, _bOnlyVar:Bool = false):String {
			var _sInputVarString : String = "";
			var _sParam : String = "";
			var _aParam : Array<Dynamic> = _oSFunction.aParamList;
			var _i : UInt = _aParam.length;
			for (i in 0 ...  _i) {
								
				if (i != 0) { //Not the last
					_sParam += "gzU8(\"|, \") + ";
				}
				var _oParam : VarObj = _aParam[i];
				
				if (_oParam.eType == EuVarType._ParamInput) {

					var _oParamInput : ParamInput = cast(_oParam);
					if(!_bOnlyVar){
						_sInputVarString  =  TypeText.typeToCPP(_oParamInput.oVarInput, false,false,false,true) + " ";
					}
					 _sParam += "gzU8(\"" + _oParamInput.oVarInput.sName + "|\") + " +  TypeText.getStringFuncOGL(_oParamInput.oVarInput , _sInputVarString + ConvertLines.convertCppVarType( _oParamInput.oVarInput, _oSFunction.nLine)) + " + " ;
					  
				
					 
				}else {
					if(!_bOnlyVar){
						_sInputVarString =  TypeText.typeToCPP(_oParam, false, false, false, true) + " " ;
					}
					_sParam += "gzU8(\"" + cast(_oParam,CommonVar).sName + "|\") + " +  TypeText.getStringFuncOGL(_oParam , _sInputVarString + ConvertLines.convertCppVarType(_oParam,  _oSFunction.nLine)) + " + ";
				}
			}
			return _sParam + "gzU8(\"| \")";
		}
		

		private function getAllDelegateRef(_oSClass:SClass) :Void {
			var _aVarList  : Array<Dynamic>  = _oSClass.aDelegateList;
			if(_aVarList.length > 0){				
				pushLine("//Delegate Ref");
				var _i:UInt = _aVarList.length;
				for (i in 0 ...  _i) {
					//pushLine(getDelegateRef(_aVarList[i]));
				}
				addSpace();
			}
		}
		/*
		private function getDelegateRef(_oFunc:SFunction):String {
			var _sRef : String = HDelegateFile.sPrefix  + "Ref_" +  _oFunc.sName;
			var _sStruc : String = HDelegateFile.sPrefix + "Str" + _oFunc.sDelegateString ;
			return _sStruc + "* " + _sRef + ";";
		}*/
		
		var _bAllVirtual : Bool = false;
		
		private  function getAllExtendClassToString(_oSClass:SClass, _sCopy:String = ""):String {
			var _sExtend : String = "";
			var i : Int = 0;

			var _alist : Array<SClass> =  _oSClass.aExtendAllClassList;

			if (_bAllVirtual) {
				_alist = _oSClass.aExtendAllClassList;
			}else {
				_alist = _oSClass.aExtendClass;
			}
			
			for( _oExtend  in _alist) {//SClass
				
				if (!_oExtend.bIsCustomCppString){
					
					
					//if (_oExtend.sName != "Class" || i == 0) { //0 is a direct extend and must be ini
				
					if (i != 0) {
						_sExtend +=  ",";
					}
					_sExtend += _oExtend.sNsAccess + "c" +  _oExtend.sName + _sCopy;
			
				}else{
					//_sExtend += _oExtend.sName + "()"; //TODO parma? //We can have no constructor in c++ //TODO make syntax to add it
		
				}
				i++;
			}
			/*
			if (i == 0) {

				if (_oSClass.sName == "Class" && _oSClass.oSLib.sIdName == "Gz" ) { //TODO only in lib GZE
					//_sExtend +=   "Lib_GZ::Base::cClass" + _sCopy; //New delegate for all class
					_sExtend +=   ""; //New delegate for all class
				}
			}*/
			if(_sExtend != ""){
				_sExtend = " : " + _sExtend;
			}

			return _sExtend;
		}
		
		
		private  function getExtendClassToString(_oSClass:SClass, _sCopy:String = ""):String { //Execute

			for (_oExtend  in  _oSClass.aExtendClass) {
				if (_oExtend.bIsCustomCppString){
					return " : " + _oExtend.sName;
				}
			}
			if (_oSClass.bIsPod) {
				return "";
			}
			
			
			
			var _sShared : String = "public ";
			if (_bAllVirtual) {
				_sShared = "public virtual ";
			}
			
			
			if (_sCopy != "") {
				_sShared = "";
			}
			
			var _sExtend : String = "";
			var _sIN_define : String = "";
			var _aList:Array<Dynamic> =  _oSClass.aExtendClass;
			var _i : UInt = _aList.length;
			
			if (_i == 0 ) {
				if (_sCopy == ""){
					 if (_oSClass.bIsResults){
				
						 return " : " + _sShared + "cResult" + _sCopy; //New delegate for all class
						 
					 }else {
						//return "";
						//return  _sShared + "::" + _oSClass.oSProject.oSDelegate.sLib_Name + _sCopy; //New delegate for all class
						if (_sShared != "" &&  _oSClass.sName == "Class") { //!TODO only in lib GZE!!
							
							return  ""; //New delegate for all class
								
							//return  "public Lib_GZ::Base::cClass" + _sCopy; //New delegate for all class
						
						}else{
							return " : " + _sShared + "Lib_GZ::Base::cClass" + _sCopy; //New delegate for all class
						}
					}
				}
			}
		
			
			
			for (i in 0 ...  _i) {
				if (i != 0) {
					_sExtend += ", ";
				}
				var _oExtend : SClass = _aList[i];
				
				//var _sResultShared :String = "";
				
				var _sResultShared :String = _sShared;
			
				
				/*
				if (_oExtend.sName == "Class") {
					_sResultShared = "public ";
				}*/
				
				
				
				//_sExtend +=  "public " +  _oExtend.oSLib.sWriteName + "::c" +  _oExtend.sName;
				_sExtend +=  _sResultShared +  _oExtend.sNsAccess + "c" +  _oExtend.sName + _sCopy;
				
			}

			return " : "+ _sExtend;
		}	
		
		private  function getOverplaceString(_oSClass:SClass):String { //Execute

				var _aList:Array<Dynamic> =  _oSClass.aExtendClass;
				var _i : UInt = _aList.length;
				if (!_oSClass.bHaveOverplace ||  _i == 0) {//TODO, better way
					//return " : public Lib_GZ::cStThread"; //New delegate for all class
					return " : public Lib_GZ::Base::csClass"; //New delegate for all class
				}
				
				var _sExtend : String = "";
				var _sIN_define : String = "";

				for (i in 0 ...  _i) {
					if (i != 0) {
						_sExtend += ", ";
					}
					var _oExtend : SClass = _aList[i];
					//_sExtend +=  "public " +  _oExtend.oSLib.sWriteName + "::c" +  _oExtend.sName;
					_sExtend +=  "public " +  _oExtend.sNsAccess + "cs" +  _oExtend.sName;
					
				}

				return " : " + _sExtend;
		}
		
		private  function getExtendClassToStringIni(_oSClass:SClass):String { //Execute
			var _sExtend : String = "";
			var _sIN_define : String = "";
			var _aList:Array<Dynamic> =  _oSClass.aExtendClass;
			var _i : UInt = _aList.length;
			if (_i == 0) {
				//return "";
				return ": " + _oSClass.oSProject.oSDelegate.sLib_Name + "(_parent)"; //New delegate for all class
			}
			
			for (i in 0 ...  _i) {
				if (i != 0) {
					_sExtend += ", ";
				}
				var _oExtend : SClass = _aList[i];
				//_sExtend +=  "public " +  _oExtend.oSLib.sWriteName + "::c" +  _oExtend.sName;
				_sExtend +=   _oExtend.sNsAccess + "c" +  _oExtend.sName +  "(_parent)";
				
			}

			return ": " + _sExtend;
		}
		
		
		
		private function getFunctionPtr(_oSClass:SClass):Void {
			if (_oSClass.bIsPod || _oSClass.bIsVector || _oSClass.bIsResults){
				return;
			}
			addTab();	
			
			var _aFunction : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt = _aFunction.length;
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function
				//if(!_oSFunction.bStatic && _oSFunction != _oSClass.oFuncDestrutor){
				if( _oSFunction != _oSClass.oFuncDestrutor){
				
					var _sReturn: String = TypeText.typeToCPP(_oSFunction.oReturn, true) + " "; //TODO
		
					
					var _sPtrFuncName : String =	 _oSFunction.sName;
								
					if(_oSFunction.bConstructor){
						 _sPtrFuncName =	 Setting.sConstructorKeyword ;
					}
					
					
					var _sParam : String =  "c" +  _oSClass.sName + "*" + getFunctionParam(_oSFunction, false, false, false,false,false);
					
					pushLine("extern " + fGetObjFPtrName(_oSFunction, _sReturn, _sPtrFuncName, _sParam) + ";");
				}
			}
			subTab();	
			//addSpace();
		}
		
		
		
		public static function fGetFuncPtr(_oSFunction:SFunction, _bUnamed :Bool = false):String{
			//var _sReturn: String = TypeText.typeToCPP(_oSFunction.oReturn, true) + " "; //TODO
			var _sReturn: String = TypeText.typeToCPP(_oSFunction.oReturn, true); //TODO
			var _sPtrFuncName : String =	 _oSFunction.sName;
			if(_oSFunction.bConstructor){
				 _sPtrFuncName =	 Setting.sConstructorKeyword ;
			}
			var _sParam : String = "c" +  _oSFunction.oSClass.sName + "*" + getFunctionParam(_oSFunction, false, false, false, false, false);
			if(_bUnamed){
				return _sReturn + "(*)(" +  _sParam + ")";
			}else{
				return _sReturn + " (*FPtr_" + _sPtrFuncName +  getFunctionSignature(_oSFunction) + ")(" +  _sParam + ")";
			}
			
		}
		
		
		private function getClassFPtr(_oSClass:SClass):Void {
			if (_oSClass.bIsPod || _oSClass.bIsVector || _oSClass.bIsResults){
				return; 
			}
			addTab();	
			
			var _aFunction : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt = _aFunction.length;
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function
				if(!_oSFunction.bStatic && _oSFunction != _oSClass.oFuncDestrutor){
					
					if (_oSFunction.oOverrideFunc == null){
						pushLine(fGetFuncPtr(_oSFunction) + ";" + "//" + _oSFunction.sTest);
					}
					
					//if ( !(_oSFunction.bConstructor && _oSFunction.oSClass.aExClassList.length != 0) ){ //Constructor is always override
						//pushLine(fGetFuncPtr(_oSFunction) + ";");
						/*
						var _sReturn: String = TypeText.typeToCPP(_oSFunction.oReturn, true) + " "; //TODO
						var _sPtrFuncName : String =	 _oSFunction.sName;
						if(_oSFunction.bConstructor){
							 _sPtrFuncName =	 Setting.sConstructorKeyword ;
						}
						var _sParam : String = "c" +  _oSClass.sName + "*" + getFunctionParam(_oSFunction, false, false, false,false,false);
						pushLine(_sReturn + " (*FPtr_" + _sPtrFuncName +  getFunctionSignature(_oSFunction) + ")(" +  _sParam + ");");
						*/
				//	}
					
				}
			}
			subTab();	
			//addSpace();
		}
		

		private function getClassFBody(_oSClass:SClass):Void {
			if (_oSClass.bIsPod || _oSClass.bIsVector){
				return;
			}
			addTab();	
			
			var _aFunction : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt = _aFunction.length;
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function
				//if(!_oSFunction.bStatic && _oSFunction != _oSClass.oFuncDestrutor){
				if( _oSFunction != _oSClass.oFuncDestrutor){
				
					var _sReturn: String = TypeText.typeToCPP(_oSFunction.oReturn, true) + " "; //TODO
		
					var _sPtrFuncName : String =	 _oSFunction.sName;
								
					if(_oSFunction.bConstructor){
						 _sPtrFuncName =	 Setting.sConstructorKeyword ;
					}
					
					var	_sClassFuncName : String =   "FB_" +  _sPtrFuncName;
					pushLine("inline " + _sReturn  + _sClassFuncName+ "(" + getFunctionParam(_oSFunction, true) + ");");
					
				}
			}
			subTab();	
			
		}
		
		private function getFunctionToConvert(_oSClass:SClass, _eSharing:EuSharing,  _bOutsideClass: Bool = false):Void {
		
			var _aFunction : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt = _aFunction.length;
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function
				if(!_oSFunction.bStatic &&  _oSFunction.eSharing  == _eSharing){
					convertFunctionHeader(_oSClass, _oSFunction, _bOutsideClass);
				}
			}
			
			addSpace();
		}
		
		private function getStaticFunctionToConvert(_oSClass:SClass):Void {
		
			var _aFunction : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt = _aFunction.length;
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function
				if(_oSFunction.bStatic && _oSFunction.eFuncType != EuFuncType.Pure){
					convertFunctionHeader(_oSClass, _oSFunction);
				}
			}
			
			addSpace();
		}
		
		private function getPureFunctionToConvert(_oSClass:SClass):Void {
		
			var _aFunction : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt = _aFunction.length;
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function
				if(_oSFunction.eFuncType == EuFuncType.Pure){
					convertFunctionHeader(_oSClass, _oSFunction);
				}
			}
			
			addSpace();
		}
		
		
		private function convertFunctionHeader(_oSClass:SClass, _oSFunction:SFunction,  _bOutsideClass: Bool = false):Void {
			
			if (_bOutsideClass &&  (_oSFunction.bStatic || _oSClass.bIsPod || _oSClass.bIsResults) ){
				return; //Test for Func Ptr Only
			}
			
			var _sReturn : String;
			var _sFuncName : String = _oSFunction.sName;
			var _sLib : String = _oSClass.oSLib.sWriteName;
	/*
			//Return
			if (_oSFunction.eFuncType ==  EuFuncType.Main) {
				//_sReturn = _sLib +"_"; //Main function	
				_sReturn = ""; //Main function	
			}else {*/
				//_sReturn = "Void "; //temp
				_sReturn = TypeText.typeToCPP(_oSFunction.oReturn, true) + " "; //TODO
				
			//}
			
			var _sMustReturn = "return ";
			if (_oSFunction.oReturn.eType == EuVarType._Void  ){
				_sMustReturn = "";
			}
			
			
			/* Namespace
			if (_oSFunction.eFuncType  == EuFuncType.Static) {
				_sReturn = "static " + _sReturn;
			}*/
		
			//Virtual function (extend class)
			
			//Static
			var _sStatic : String =  "";
			if (_oSFunction.eFuncType == EuFuncType.Pure) {
				_sStatic = "static ";
				
			//}else if (oSClass.bExtension  && _oSFunction.eFuncType !=  EuFuncType.Main  && !_oSFunction.bAddDlgWrapper || _oSFunction.bStatic) { // _nFuncId != 0  
			}else if (  !_oSFunction.bConstructor  && !_oSFunction.bAddDlgWrapper || _oSFunction.bStatic && !_oSClass.bIsPod) { // _nFuncId != 0  
			
			//	_sReturn = "virtual " + _sReturn;
			}
			
			
	
			
			//Param
			var _sParam : String = getFunctionParam(_oSFunction, true);
			
		
			
			if (_oSFunction.bAddDlgWrapper) {
				var _sFuncType : String;
				var _sInstance : String = "";
				if (_oSFunction.bStatic) {
					_sFuncType = "GZ_FuncWrapD";
				}else {
					_sFuncType = "GZ_FuncWrapM";
					_sInstance = "((c" + _oSFunction.oSClass.sName +  "*)_w)->";
				}
				if (_sParam != "") {
					_sFuncType += ", ";
				}
				
				var _sHaveRetrun : String = "";
				if (_oSFunction.oReturn.eType != EuVarType._Void) {
					_sHaveRetrun = "return ";
				}
				pushLine("inline static " + _sReturn  + "w" + _sFuncName.substring(1) + "(" + _sFuncType + _sParam + "){" + _sHaveRetrun +  _sInstance + _oSFunction.sName + "(" +  getFunctionParam(_oSFunction, true, true) + ");}");
			}
			
			
			var _sPtrFuncName : String = "";
			//Special case for class extension type  //X Now -> Always
			//if (oSClass.bExtension  && _oSFunction.eFuncType == EuFuncType.Main ) {  
			if ( _oSFunction.bConstructor ) {
				
				if(!_oSClass.bIsResults){
				
					//pushLine(_sReturn + "c" + _sFuncName + "(Lib_GZ::Base::cClass* _parent);");
					//pushLine("inline " + _sReturn + "c" + _sFuncName + "(Lib_GZ::Base::cClass* _parent)" + getAllExtendClassToString(oSClass, "(_parent)")  +"{};");
					//pushLine("inline " + _sReturn + "c" + _sFuncName + "(Lib_GZ::Base::cClass* _parent)" + getAllExtendClassToString(_oSClass, "(_parent)"));
					pushLine("inline c" + _sFuncName + "(Lib_GZ::Base::cClass* _parent)" + getAllExtendClassToString(_oSClass, "(_parent)"));
				}else {
					
					//pushLine("inline c" + _sFuncName + "()" + getAllExtendClassToString(_oSClass, "(_parent)"));
					var _sExtend : String = getAllExtendClassToString(_oSClass, "()");
					if (_sExtend == ""){
						_sExtend = ":cResult(false)";
					}
					pushLine("inline c" + _sFuncName + "()" + _sExtend);
				}
					
					
					
					fAddCppLines(_oSClass.aCppLinePreInitializerList_H);
					fGetInitializerList(_oSFunction);
					fAddCppLines(_oSClass.aCppLineInitializerList_H);
					pushLine("{");
					
					
					fAssociateFFPtr(_oSFunction.oSClass);
					pushLine("//Special var ini"); //TODO create function to call for complexe initiliazation (in .cpp)
					
				
					
					ConvertLines.convertSpecialVarConstructorIni(this, _oSFunction, _oSFunction.oSClass.aIniGlobalVarList); //TODO must be before Cpp section initilizer
				
					fAddCppLines(_oSClass.aCppLineInitializer_H);
					pushLine("};");
					//pushLine("virtual void Ini_" +  _sReturn + "c" + _sFuncName + "(" + _sParam + ");");
					var _sIsRideFunc : String = "";
					if (_oSFunction.eFuncType == EuFuncType.Riding){
				//		_sIsRideFunc = "virtual ";
					}
					
					
					_sPtrFuncName =	_oSClass.sCFuncName  + Setting.sConstructorKeyword ;
					
					
					if(!_oSClass.bIsResults && !_oSClass.bIsVector  ){
					
					///pushLine(_sIsRideFunc  + _sReturn  + " "+ Setting.sConstructorKeyword + "(" + _sParam + ");");
					//pushLine("//" + _sIsRideFunc  + _sReturn  + " "+ Setting.sConstructorKeyword + "(" + _sParam + ");");
					//pushLine("inline " + _sIsRideFunc  + _sReturn  + " "+ Setting.sConstructorKeyword + "(" + _sParam + "){" + _oSClass.sPtrCFuncName +  Setting.sConstructorKeyword + "();" +"};");
						pushLine("inline " + _sIsRideFunc  + _sReturn  + " "+ Setting.sConstructorKeyword + "(" + _sParam + "){" + _sMustReturn + "FPtr_" + Setting.sConstructorKeyword  +  getFunctionSignature(_oSFunction) + "(this" + getFunctionParam(_oSFunction, false, true,false) + ");" +"};");
					}
					
					/*
				}else {
					pushLine(_sReturn + "c" + _sFuncName + "();"); //Default constructor only
					pushLine("void Ini_" +  _sReturn + "c" + _sFuncName + "(" + _sParam + ");");
					
				}*/
				
				
			}else {
				//Normal push
				if (_oSFunction.eFuncType == EuFuncType.Pure) { //And inlined
					var _bInline = false;
					
					if(_bInline){
						pushLine("inline static " +  _sReturn  + _sFuncName + "(" + _sParam + "){" );
						addTab();
						
						ConvertLines.convertFunctionLines(this, _oSFunction);
						//	addOverrideFunctionLines(_oSFunction); //Exmple Opengl generated function
						fAddMissingReturnInFunction(_oSFunction);
						
						subTab();
						pushLine("};");
					}else{
						pushLine("static " +  _sReturn  + _sFuncName + "(" + _sParam + ");" );
					}
					
				}else{ //Simulate virtual
					//pushLine(_sStatic + _sReturn + _sFuncName + "(" + _sParam + ");");
					pushLine("inline " +  _sReturn  + _sFuncName + "(" + _sParam + "){" + _sMustReturn + "FPtr_" + _sFuncName+   getFunctionSignature(_oSFunction) +"(this" + getFunctionParam(_oSFunction, false, true,false) + ");" +"};");
				}
			}
			
			if (!_oSClass.bIsResults && !_oSClass.bIsPod && !_oSClass.bIsVector && _oSFunction.eFuncType != EuFuncType.Pure) {
				pushLine("inline " +  _sReturn  + "c" + _oSFunction.oSClass.sName + "_" +  _oSFunction.sRealName + "(" + _sParam + "){" + _sMustReturn +  _oSFunction.oSClass.sName  + "::Func_" + _oSFunction.sRealName +   getFunctionSignature(_oSFunction) +"(this" + getFunctionParam(_oSFunction, false, true,false) + ");" +"};");
			}
			
			
		}
		
		public static function fGetObjFPtrName(_oSFunction:SFunction, _sReturn : String,  _sFuncName: String, _sParam):String {
			return _sReturn + "(*Func_" +   _sFuncName + _oSFunction.sSignature + ")(" + _sParam + ")";
			//return _sReturn + "(*" +   _sFuncName  + ")(" + _sParam + ")";
		}
		public static function fGetObjFPtrNameFull(_oSFunction:SFunction):String {
			return TypeText.typeToCPP(_oSFunction.oReturn, true) + "(*Func_" +   _oSFunction.sRealName + _oSFunction.sSignature + ")(" +  "c" + _oSFunction.oSClass.sName +  "* _this" + getFunctionParam(_oSFunction,false,false,false) + ")";
			//return _sReturn + "(*" +   _sFuncName  + ")(" + _sParam + ")";
		}

		
		private function getUnitFunction(_oSClass:SClass):Void {
		
			pushLine("//Unit creation");
			var _oUnit : UnitObj;
			var _aUnitList:Array<Dynamic> = _oSClass.aUnitList;
			var _i : UInt = _aUnitList.length;
			for (i in 0 ...  _i) {
				 _oUnit  = _aUnitList[i];
				//if(!_oUnit.isExtend()){ //Extend type don't need to be converted
					createUnitFunction(_oUnit);
				//}
			}
			
			pushLine("//Unit destruction");
	
			_aUnitList = _oSClass.aUnitList;
			 _i  = _aUnitList.length;
			for ( i in 0 ... _i) {
				 _oUnit  = _aUnitList[i];
				createUnitFunctionDestruction(_oUnit);
			}
			
			pushLine("//Unit array write");
			for (i in 0 ... _i) {
				 _oUnit  = _aUnitList[i];
				//if(!_oUnit.isExtend()){ //Extend type don't need to be converted
					createUnitFunctionArrayWrite(_oUnit);
				//}
			}
			addSpace();
			
		}
		
			
		private function createUnitFunction(_oUnit : UnitObj):Void {
			//pushLine("static " + _oUnit.sName + "* tNew_" + _oUnit.sName + "();"); //Static??
			pushLine( _oUnit.sName + "* tNew_" + _oUnit.sName + "();"); //Static??
		}
		
		private function createUnitFunctionDestruction(_oUnit : UnitObj):Void {
			//pushLine("static Void tDel_" + _oUnit.sName + "(Void* _oRtu);");
			pushLine("void tDel_" + _oUnit.sName + "(void* _oRtu);");
		}
		
		
		private function createUnitFunctionArrayWrite(_oUnit : UnitObj):Void {
			//pushLine("static " + _oUnit.sName + "* tAw_" + _oUnit.sName + "(ArrayPtr* _aArray, unsigned Int _nIndex);");
			pushLine(_oUnit.sName + "* tAw_" + _oUnit.sName + "(ArrayPtr* _aArray, unsigned int _nIndex);");
		}
		
		
		private function getAssociateVar(_oSClass:SClass):Void {
			if(_oSClass.aAssociateVarList.length > 0 ){
				addSpace();
				pushLine("//Associate:");
				var _aAssociate:Array<Dynamic> = _oSClass.aAssociateVarList;
				var _i : UInt = _aAssociate.length;
				for (i in 0 ...  _i) {
					var _oAssociate : VarObj = _aAssociate[i];
					switch(_oAssociate.eType) {
						case EuVarType._EaseOut:
							var _oOriVar : CommonVar = cast(_oAssociate,EaseOut).oAssociate;
							pushLine("GZ_uEase_" + TypeText.typeToCPP(_oOriVar, false, false, true) + " ua_" +  _oOriVar.sName + ";");
							
						default:
					}
				}
			
			}
		}
	
		public function fAddCppLines(_aSource:Array<Dynamic>) :Void {
			if(!oSPackage.oSFrame.bSkipContent && !oSPackage.oSLib.bSkipLibContent){ //TODO only when we are in function (not outside?)
					if (_aSource.length > 0) {
						pushLine("// ------  Cpp section  ------ //");
						for (  _oLine  in _aSource) {//VarCppLine
							pushLine(_oLine.sCppLine);
						}
						pushLine("// --------------------------- //");
						addSpace();
					}
			}
		}
		

		
		public function fGetInitializerList(_oSFunction : SFunction):Void { 
			  preiniGlobalVar(_oSFunction.oSClass);
			 convertDelegateIni(this, _oSFunction);
			// fAssociateFFPtr(_oSFunction.oSClass);
		}
		
		
		public function fAssociateFFPtr(_oSClass: SClass):Void {
			if (_oSClass.bIsPod || _oSClass.bIsResults || _oSClass.bIsVector){
				return;
			}
			
			pushLine("//VTable");
			for (_oSFunc in _oSClass.aFunctionList){
				if (_oSFunc.eFuncType != EuFuncType.Pure ){
				if (_oSFunc != _oSClass.oFuncDestrutor){//Temp
					var _sTest : String = "";
					var _sFunc : String;
					if (_oSFunc.bConstructor){
						_sFunc = Setting.sConstructorKeyword  +  getFunctionSignature(_oSFunc);
						
						//_sTest = "Lib_GZ::Base::cClass::";
					}else{
						_sFunc = _oSFunc.sName +  getFunctionSignature(_oSFunc);
					}
					//_oSFunc.o
					
					//pushLine("," + _sTest + "FPtr_" +  _sFunc + "(" + _oSClass.sName + "::Func_" +  _sFunc  + ")");
					
					var _oCastFunc : SFunction = _oSFunc.oOverrideFunc;
					if (_oCastFunc == null){
						_oCastFunc = _oSFunc;
					}
					
					pushLine("FPtr_" +  _sFunc + " = "  + "(" +  fGetFuncPtr(_oCastFunc,true) + ")"+ _oSClass.sName + "::Func_" +  _sFunc  + ";");
					//pushLine("FPtr_" +  _sFunc + " = " + _oSClass.sName + "::Func_" +  _sFunc  + ";");
					//'void (*)(Lib_GZ::Base::Thread::cThread*)' to 'void (*)(Lib_GZ::Base::cClass*)' [-fpermissive]
				}
				}
				
			}
			
			
		}
		
		
		private function preiniGlobalVar(_oSClass:SClass):Void {
					
			var _aList : Array<Dynamic> = _oSClass.aNotIniGlobalVarList;
			var _i : UInt = _aList.length;
			//var _sIni : String = "";
			for (i in 0 ...  _i) {
				var _oVar : VarObj = _aList[i];
				
				switch(_oVar.eType){
					
					case EuVarType._Gate:
						
					case EuVarType._HoldEnum:
						
						pushLine(","+ cast(_oVar,CommonVar).sName + "(" + cast(_oVar,VarHoldEnum).oEnumRef.fGetCppDefaultVar() +")");
						
					case EuVarType._CallClass:
						if(cast(_oVar, VarCallClass ).oCallRef.bIsVector ){
							pushLine(","+ cast(_oVar,CommonVar).sName + "({0})");
						}
						
					default:
						if (Std.is(_oVar, CommonVar)) {
							//_sIni += cast(_oVar,CommonVar).sName + ",(0)";
							pushLine(","+ cast(_oVar,CommonVar).sName + "(0)");
						}

				}
			}
			/*
			if(_i > 0){
				pushLine(_sIni);
			}*/
		}
	
		
		
		public static function convertDelegateIni(_oFile:CommonCpp,  _oSBloc:SBloc) :Void {
			var _oSClass : SClass = _oSBloc.oSClass;
			var _aVarList  : Array<Dynamic>  = _oSClass.aDelegateListIni;
			if(_aVarList.length > 0){		
				//_oFile.pushLine("//Delegate ini");
				var _i:UInt = _aVarList.length;
				for (i in 0 ...  _i) {
					_oFile.pushLine("," + convertDelegate(_oFile, _aVarList[i]));
		
				}
				//_oFile.addSpace();
			}
			//return _sFirst;
		}
		
		public static function convertDelegate(_oFile:CommonCpp, _oDlg:Delegate):String {
			
			return _oDlg.sName + "("  + TypeText.getFuncPtrTypeIni(_oDlg, "this") + "&"  + TypeText.getFuncLocWrapper(_oDlg.oInputPtrFunc.oFunc) + ")";
		}
		
		
	private function fAddLicence():String {
		var sLicence : String = "//This file is part of \"GZE - GroundZero Engine\"";
		sLicence += "\n";
		sLicence += "\n//The permisive licence allow to use GZE for free or commercial project (Apache License, Version 2.0).";
		sLicence += "\n//For conditions of distribution and use, see copyright notice in Licence.txt, this license must be included with any distribution of the code.";
		sLicence += "\n";
		sLicence += "\n//Though not required by the license agreement, please consider the following will be greatly appreciated:";
		sLicence += "\n//- We would like to hear about projects where GZE is used.";
		sLicence += "\n//- Include an attribution statement somewhere in your project.";
		sLicence += "\n//- If you want to see GZE evolve please help us with a donation.";
		sLicence += "\n";
		return sLicence;
	}
		
	
	
	
	
		
	}

