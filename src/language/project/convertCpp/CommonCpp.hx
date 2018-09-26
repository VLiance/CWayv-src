package language.project.convertCpp ;
	import language.enumeration.EuConstant;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuVarType;
	import language.enumeration.EuSharing;
	import language.enumeration.EuOperator;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.pck.SLib;
	import language.project.convertSima.SFunction;
	import language.project.CppProject;
	import language.project.convertSima.SPackage;
	import language.vars.special.UnitObj;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.Delegate;
	import language.vars.varObj.EaseOut;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.VarCppLine;
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
		
		
		private function getVarToConvert(_aVarList : Array<Dynamic>, _nSharing:EuSharing, _bStatic:Bool = false, _bStaticInClass:Bool = false, _nConstant : EuConstant):Void {
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
					_sIni = " = " + ConvertLines.convertInputLine(_oLineInput, EuOperator.None, true);//LineInput
					_oVar = _oLineInput.oVarInput;
				}
					
					var  _oCommonVar :CommonVar = cast(_oVar,CommonVar);
				//Only private/public var
				if (_oCommonVar.eSharing == _nSharing && _oCommonVar.eConstant == _nConstant) {
					/*
					if (_bStatic ) {
					//	_sIni = " = " +  _oVar.;
					}*/
					 pushLine(_sExtern + convertVar(_oCommonVar,_bAddLib) + _sIni + ";");
				}
				
				
			}
		
			

			//addSpace();
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
		
		
		private function getFunctionParam(_oSFunction:SFunction, _bHeader:Bool = false, _bOnlyVar:Bool = false, _bFirst:Bool = true, _bWebGL:Bool = false):String {
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
					 _sParam +=   _sInputVarString + ConvertLines.convertCppVarType( _oParamInput.oVarInput, _oSFunction.nLine);
					  
					 if(_bHeader){ //line after =
						 var _sParamInput : String = ConvertLines.convertCppVarType(_oParamInput, _oParamInput.nLine); 
						 _sParam +=  " = " + _sParamInput;
					 }
					 
				}else {
					if(!_bOnlyVar){
						_sInputVarString =  TypeText.typeToCPP(_oParam, false, false, false, true) + " " ;
					}
					
					if (_bWebGL) {
						_sParam +=   fConvertWebGL(_sInputVarString + ConvertLines.convertCppVarType(_oParam,  _oSFunction.nLine), _oParam);
					}else {
						_sParam +=   _sInputVarString + ConvertLines.convertCppVarType(_oParam,  _oSFunction.nLine);
					}
				}
			
			}
			
			return _sParam;
		}
		
		private function fConvertWebGL(_sParamString, _oParam:VarObj):String {
			switch(_oParam.eType) {
				case EuVarType._HoldEnum :
					_sParamString = "gzInt(" + _sParamString + ")";
				//break;
				default:
				
			}
			
			return "val(" + _sParamString + ")";
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
			
			var _alist : Array<Dynamic> =  _oSClass.aExtendAllClassList;

			if (_bAllVirtual) {
				_alist = _oSClass.aExtendAllClassList;
			}else {
				_alist = _oSClass.aExtendClass;
			}
			
			for( _oExtend  in _alist) {//SClass
				
				if (_oExtend.sName != "Class" || i == 0) { //0 is a direct extend and must be ini
					if (i != 0) {
						_sExtend +=  ",";
					}
					_sExtend += _oExtend.sNsAccess + "c" +  _oExtend.sName + _sCopy;
					i++;
				}
			
			}
			
			if (i == 0) {

				if (_oSClass.sName == "Class") {
					_sExtend +=   "Lib_GZ::cClass" + _sCopy; //New delegate for all class
				}
			}
			if(_sExtend != ""){
				_sExtend = " : " + _sExtend;
			}

			return _sExtend;
		}
		
		
		private  function getExtendClassToString(_oSClass:SClass, _sCopy:String = ""):String { //Execute

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
				if(_sCopy == ""){
					//return "";
					//return  _sShared + "::" + _oSClass.oSProject.oSDelegate.sLib_Name + _sCopy; //New delegate for all class
					if (_sShared != "" &&  _oSClass.sName == "Class") {
						return  "public Lib_GZ::cClass" + _sCopy; //New delegate for all class
					}else{
						return  _sShared + "Lib_GZ::cClass" + _sCopy; //New delegate for all class
					}
				}
			}
		
			
			
			for (i in 0 ...  _i) {
				if (i != 0) {
					_sExtend += ", ";
				}
				var _oExtend : SClass = _aList[i];
				var _sResultShared :String = _sShared;
				if (_oExtend.sName == "Class") {
					_sResultShared = "public ";
				}
				
				//_sExtend +=  "public " +  _oExtend.oSLib.sWriteName + "::c" +  _oExtend.sName;
				_sExtend +=  _sResultShared +  _oExtend.sNsAccess + "c" +  _oExtend.sName + _sCopy;
				
			}

			return  _sExtend;
		}	
		
		private  function getOverplaceString(_oSClass:SClass):String { //Execute

				var _aList:Array<Dynamic> =  _oSClass.aExtendClass;
				var _i : UInt = _aList.length;
				if (!_oSClass.bHaveOverplace ||  _i == 0) {//TODO, better way
					//return " : public Lib_GZ::cStThread"; //New delegate for all class
					return " : public Lib_GZ::csClass"; //New delegate for all class
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
		
		
		
		
		private function getFunctionToConvert(_oSClass:SClass, _eSharing:EuSharing):Void {
		
			var _aFunction : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt = _aFunction.length;
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function
				if(!_oSFunction.bStatic &&  _oSFunction.eSharing  == _eSharing){
					convertFunctionHeader(_oSClass, _oSFunction);
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
				if(_oSFunction.bStatic){
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
		
		
		private function convertFunctionHeader(_oSClass:SClass, _oSFunction:SFunction):Void {
			var _sReturn : String;
			var _sFuncName : String = _oSFunction.sName;
			var _sLib : String = _oSClass.oSLib.sWriteName;
	
			//Return
			if (_oSFunction.eFuncType ==  EuFuncType.Main) {
				//_sReturn = _sLib +"_"; //Main function	
				_sReturn = ""; //Main function	
			}else {
				//_sReturn = "Void "; //temp
				_sReturn = TypeText.typeToCPP(_oSFunction.oReturn, true) + " "; //TODO
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
			}else if (  _oSFunction.eFuncType !=  EuFuncType.Main  && !_oSFunction.bAddDlgWrapper || _oSFunction.bStatic && !_oSClass.bIsPod) { // _nFuncId != 0  
			
				_sReturn = "virtual " + _sReturn;
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
			
			
			//Special case for class extension type  //X Now -> Always
			//if (oSClass.bExtension  && _oSFunction.eFuncType == EuFuncType.Main ) {  
			if ( _oSFunction.eFuncType == EuFuncType.Main ) {  
				if(!_oSClass.bIsPod){
					//pushLine(_sReturn + "c" + _sFuncName + "(Lib_GZ::cClass* _parent);");
					//pushLine("inline " + _sReturn + "c" + _sFuncName + "(Lib_GZ::cClass* _parent)" + getAllExtendClassToString(oSClass, "(_parent)")  +"{};");
					pushLine("inline " + _sReturn + "c" + _sFuncName + "(Lib_GZ::cClass* _parent)" + getAllExtendClassToString(_oSClass, "(_parent)"));
				
					
					fGetInitializerList(_oSFunction);
					pushLine("{};");
					pushLine("virtual void Ini_" +  _sReturn + "c" + _sFuncName + "(" + _sParam + ");");
				}else {
					pushLine(_sReturn + "c" + _sFuncName + "();"); //Default constructor only
					pushLine("void Ini_" +  _sReturn + "c" + _sFuncName + "(" + _sParam + ");");
				}
				
				
			}else {
				//Normal push
				pushLine(_sStatic + _sReturn + _sFuncName + "(" + _sParam + ");");
			}
		
			
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
	
			 convertDelegateIni(this, _oSFunction);
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

