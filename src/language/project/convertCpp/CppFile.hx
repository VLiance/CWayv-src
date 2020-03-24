package language.project.convertCpp ;

	import language.enumeration.EuConstant;
	import language.pck.FileImport;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuSharing;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SPackage;
	import language.vars.varObj.VarRc;
	import language.MyFile;
	import language.project.convertSima.ExtractBlocs;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.project.convertSima.TypeResolve;
	import language.project.CppProject;
	import language.vars.special.EnumObj;
	import language.vars.special.UnitObj;
	import language.vars.special.VarFixeArray;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.Delegate;
	import language.vars.varObj.EaseOut;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.LineReturn;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.VarCallClass;
	import language.vars.varObj.VarCppLine;
	import language.vars.varObj.VarGate;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	import language.vars.varObj.VarString;
	import language.base.Root;
	import language.base.Debug;
	/**
	 * ...
	 * @author ...
	 */
	
	 
	class CppFile extends CommonCpp
	{
		
		public static var  sEmbedFolder : String = "_Rc/";
		
		public var nTest : Int;
		public var aClassIncluded : Map<String, Bool>;
	
		public function new(_Main:Root, _oCppProject : CppProject, _oSPackage : SPackage) { 
	
			super(_Main,_oCppProject, _oSPackage);
			
			try{
				ExtractBlocs.oCurrPackage = _oSPackage;
				
				
				aClassIncluded = new Map<String, Bool>(); 
				
				//include Header {
				if(_oSPackage.oSLib.sName == "GZ"){
					pushLine(fAddLicence());
				}else if(_oSPackage.oSLib.sName == "SimaCode"){
					pushLine("//GroundZero Engine Demo File -- An example to show the capabilities of GZE, modify this file as you like --");
				}
				//pushLine("//GroundZero Engine");   //First line cause wrong recompile state  Prevent non view file change
				//pushLine("#include \""  + _oSPackage.sFilePath + ".h\"");
				//aClassIncluded[_oSPackage.sFilePath] = true;
				addSpace();
				//////////////////////////////
				includeClass(_oSPackage);
				
				
				
				for (_oSClass in _oSPackage.aClassList){
					ExtractBlocs.oCurrSClass = _oSClass;
					ExtractBlocs.nCurrLine = _oSClass.nLine;
					convertClass(_oSClass);
				}
				
				
			} catch (err:String) {
				
					if (err.charAt(0) == ":") { //My errors
						//trace("Er");
						Debug.fError("Internal Error: " + err);
					}else {
						throw err; //throw away
					}
			}
			
		}
		
		public function convertClass(_oSClass:SClass):Void {
			

			//Include Extendclass
			includeExtendImportClass(_oSClass);
			
			includeSubClass(_oSClass);
			/////////////////////////////
			listEmbedFilesInclude(_oSClass);
			
			//addSpace();
			//Backward heritage
	
			//listBackwardHeritage(oSClass);
			/*
			if(oSClass.aExtendClass.length > 0){
				pushLine("//Force recompilation if heritage change");   //Wrong recompile state correction Prevent null reference
				listHeritage(oSClass); 
				addSpace();
			}*/
			addSpace();
			getDefHeaderDefinition(_oSClass);
			
			
			fAddThreadFonction(_oSClass);
			addSpace();
			

			//AddCppCode
			fAddCppLines(_oSClass.aCppLineListNormal);
			
		
			fAddEntryPoint(_oSClass);
			
			//ClassId
			pushLine(_oSClass.sNamespace);
		//	pushLine("gzUInt _nId = Lib_GZ::Lib::nClass++;");
			//getGateList(oSClass);
			getVarToConvert(_oSClass.aAtomicVarList, EuSharing.Public ,false,false,EuConstant.Normal);
			getVarToConvert(_oSClass.aAtomicVarList, EuSharing.Private,false,false,EuConstant.Normal);
			getVarToConvert(_oSClass.aStaticVarList, EuSharing.Public,false,false,EuConstant.Normal);
			getVarToConvert(_oSClass.aStaticVarList, EuSharing.Private,false,false,EuConstant.Normal);
			

			pushLine("////// Current Lib Access  ////");
			//pushLine("namespace " + oSClass.oSLib.sWriteName + "{"); 
			//pushLine("using namespace _" + oSClass.sName + "; //Current Class Access"); 
			pushLine("//// Current Static Access ////");
			pushLine("#undef _");
			pushLine("#define _ " + _oSClass.sName);
			fAddIniClass(_oSClass);
			fAddFunctionName(_oSClass);
			pushLine("///////////////////////////////");
				
			//pushLine("using namespace _" + oSClass.sName + ";");
			
			addSpace();


			
			//Add class cpp
			fAddCppLines(_oSClass.aCppLineListNamespace);
			
			pushLine("}");
			addSpace();
			
			
			if (_oSClass.bIsVector){
				pushLine(_oSClass.sCEndNamespace);
				return;
			}
			
			if (!_oSClass.bIsPod && !_oSClass.bExtension && !_oSClass.oPackage.oSFrame.bSkipStatic && !_oSClass.bIsResults ){
			//if (!_oSClass.oPackage.oSFrame.bSkipStatic){
				
			//if(oSClass.bHaveOverplace == false){
				//pushLine("GZ_mCppClass(::" + oSClass.oSLib.sWriteName + ", "  + oSClass.sName + ")");
				pushLine("GZ_mCppClass(" + _oSClass.oSLib.sWriteName + ", " + _oSClass.sName + ")");
			//}else{
			//	var _oSClassOp : SClass =  SClass(oSClass.aExtendClass[0]);
			//	pushLine("GZ_mCppClassExt(::" + oSClass.oSLib.sWriteName + ", " + oSClass.sName + ", " + _oSClassOp.sNsAccess + _oSClassOp.sName + ");");
			//}
			
			}
			addSpace();

			fAddCppLines(_oSClass.aCppLineListClass);
			fAddCppLines(_oSClass.aCppLineListStatic);
		

			//Get all function
			var _aFunctionList : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt =   _aFunctionList.length;
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunctionList[i];
				
				//if(_oSFunction.eFuncType != EuFuncType.Extend && _oSFunction.eSharing != EuSharing.Destructor){
				if(_oSFunction.eFuncType != EuFuncType.Extend ){
					convertFunctionClass(_oSFunction, i);
				}
			}
			
			//Create Func Table
			fCreateFuncTable(_oSClass);
			
			
			fDefaultCopyFunc(_oSClass);

			
			if(!_oSClass.bIsPod){
				//Destructor
				//pushLine(oSClass.oSLib.sWriteName + "_"  + oSClass.sName + "::~" + oSClass.oSLib.sWriteName + "_"  + oSClass.sName + "(){")
				
				var _sAutoFree : String = freeAll(_oSClass);
				if (_oSClass.oFuncDestrutor != null ||  _sAutoFree != ""){ //Must be same as header
					
					pushLine( "//TODO Call destructor");
					pushLine( "/*");
					pushLine( "c" + _oSClass.sName + "::~" +  "c" + _oSClass.sName + "(){");
					addTab();
						extractDestructor(_oSClass);
						pushLine( _sAutoFree );
					subTab();
					pushLine("}");
					pushLine( "*/");
					
				}
			}
			addSpace();
			
			
			subTab();
			addSpace();
			
		//	convertUnitFunction(); //TODO UNIT??
			pushLine(_oSClass.sCEndNamespace);
			//pushLine("}");
			
		}
		
		
		public function 	fAddEntryPoint(_oSClass:SClass){
			if ( _oSClass.oSProject.oEntryPoint == _oSClass){
				pushLine("extern \"C\" Lib_GZ::uLib* IniLib_Lib_" + _oSClass.oSLib.sIdName + "();");
				var _sEntry : String = "new " + _oSClass.sNsAccess + "c"  + _oSClass.sName  + "(NULL)";
				var _sIniLib : String = "Lib_GZ::uLib* _rLib =  IniLib_Lib_" + _oSClass.oSLib.sIdName + "();if(_rLib != NULL){Lib_GZ::Lib::fAllClass(*_rLib->_rLastClass);}";
				pushLine("Lib_GZ::cEntryPoint*  GZ_CreateEntryPointClass(){ " +   _sIniLib +  "  return (Lib_GZ::cEntryPoint*)" + _sEntry + ";}");
		
				//pushLine("Lib_GZ::cEntryPoint*  GZ_CreateEntryPointClass(){ return (Lib_GZ::cEntryPoint*)" + _sEntry + ";}");
			//	pushLine("Lib_GZ::cEntryPoint*  GZ_IniEntryPointClass(Lib_GZ::cEntryPoint* _oEntry){("+ oSClass.sNsAccess + "c" + oSClass.sName  "*)(_oEntry)->Ini_" +  oSClass.sName + "()" ;}");
			}
		}
		
		private function extractDestructor(_oSClass:SClass):Void {
			//pushLine("printf(\"\\n --Destroy:" +  _oSClass.sName +"\"); ");
			if (_oSClass.oFuncDestrutor != null) {
				ConvertLines.convertBlocLines(this, _oSClass.oFuncDestrutor);
			}
		}
		
		
		private function includeClass(_oSPck:SPackage):Void {
			
			 var _oImport : FileImport;
			 var _sPath : String;
			 var _sLib : String;
			 var _sName : String;
			 var _sClassPath : String = _oSPck.sPath;
			 var _sClassLib : String = _oSPck.oSLib.sWritePath;
			
			// addSpace();
			var i:Int;
							
			var _i:UInt = _oSPck.aSImportList_Full.length;
			
			/*
			if (_i > 0) { //Some include
				pushLine("//Class include");
			}*/

			//Normal class
			for ( i in 0 ... _i) {
				_oImport = 	_oSPck.aSImportList_Full[i];
				
				_sName = _oImport.sName;
				_sPath = _oImport.sPath; 
				_sLib  = _oImport.oSLib.sWritePath;
				
				_sPath =  _oImport.oSLib.sWriteName + "\\"+ _sPath;
				
				_sPath = _sPath.split("\\").join("/");  
				var _sFullPath : String =  _sPath + _sName;
	
				if (aClassIncluded[_sFullPath] == null) { //Todo check only used class
					aClassIncluded[_sFullPath] = true;
					pushLine("#include \""   + _sFullPath + ".h\"");
				}
				
			}

		}
		
		private function includeSubClass(_oSClass:SClass):Void {
	
			 var _sPath : String;
			 var _sLib : String;
			 var _sName : String;
			
		
			var i:Int;
							
			var _i:UInt = _oSClass.aSubClassUsedListNotImport.length;
			
			
			if (_i > 0) { //Some include
				 addSpace();
				pushLine("//Sub Class include");
			}

			//Normal class
			for ( i in 0 ... _i) {
				var _oSubClass : SClass = _oSClass.aSubClassUsedListNotImport[i];
				/*
				_sName = _oSubClass.sName;
				_sPath = _oSubClass.sPath; 
				_sLib  = _oSubClass.oSLib.sWriteName;
				
				//_sPath =  _oImport.oSLib.sWriteName + "\\"+ _sPath;
				
				_sPath = _sPath.split("\\").join("/");  
				*/
				pushLine("#include \"" + _oSubClass.oPackage.sFilePath + ".h\"");
			}
		}
		
		
		
		
	
		
		
		
	
		
		
		
		
		
	
		
	
		private function iniGlobalVar(_oSClass:SClass):Void {
					
			var _aList : Array<Dynamic> = _oSClass.aNotIniGlobalVarList;
			var _i : UInt = _aList.length;
			var _sIni : String = "";
			for (i in 0 ...  _i) {
				var _oVar : VarObj = _aList[i];
				if (TypeResolve.isVarCommon(_oVar)) {
					_sIni += cast(_oVar,CommonVar).sName + "=0;";
				}
				
			}
			if(_i > 0){
				pushLine(_sIni);
			}
		}
				
		/*
		 * 			var _bOne : Bool = false;
			var _aList : Array<Dynamic> = oSClass.aNotIniGlobalVarList;
			var _i : UInt = _aList.length;

			var _sIni : String = "";
			for (i in 0 ...  _i) {
				var _oVar : VarObj = _aList[i];
				if (_bOne) {
					_sIni +=  ",";
				}
				if (TypeResolve.isVarCommon(_oVar)) {
					_sIni += CommonVar(_oVar).sName;
					_bOne = true;
				}
			}
			if(_bOne){
				 pushLine(_sIni + " = 0;");
			}*/
		
		private function convertUnitFunction(_oSClass:SClass):Void {
			addSpace();
	
			var _oUnit : UnitObj;
			var _aUnitList:Array<Dynamic> = _oSClass.aUnitList;
			var _i : UInt = _aUnitList.length;
			if (_i > 0) {
				pushLine("//Unit creation");
			}
			for (i in 0 ...  _i) {
				_oUnit = _aUnitList[i];
				//if(!_oUnit.isExtend()){ //Extend type don't need to be converted
					createUnitFunction(_oUnit);
				//}
			}
			if (_i > 0) {
				pushLine("//Unit array write");
			}
			for ( i in 0 ... _i) {
				_oUnit  = _aUnitList[i];
				//if(!_oUnit.isExtend()){ //Extend type don't need to be converted
					createUnitFunctionArrayWrite(_oUnit);
				//}
			}
			if (_i > 0) {
				pushLine("//Unit destruction");
			}
			for ( i  in 0 ... _i) {
				_oUnit = _aUnitList[i];
				//if(!_oUnit.isExtend()){ //Extend type don't need to be converted
					createUnitFunctionDestruction(_oUnit);
				//}
			}
			
			
		}
		
	
		override function createUnitFunction( _oUnit : UnitObj):Void {
			var  _sBaseName : String = "_oRtu";
			//var _sClassDef :String = oSClass.oSLib.sWriteName + "_" + oSClass.sName + "::";
			var _sClassDef :String = _oUnit.oSClass.sName + "::";
			//pushLine( _sClassDef + _oUnit.sName + "* " + _sClassDef + "u_" + _oUnit.sName + "(){"); //TODO MAYbe for local unit
			pushLine( _oUnit.getCppName() + "* " + _sClassDef + "tNew_" + _oUnit.sName + "(){");
			
			addTab();
			pushLine("GZ_mIniStructureNV(" + _sBaseName + "," + _oUnit.sName + ");");
			var _sLoc  : String = _sBaseName + "->";
			addTab();
			//Search for subUnit
			var _i : UInt = _oUnit.aVarList.length;
			for (i in 0 ...  _i) {
				var _oVar :VarObj =  _oUnit.aVarList[i];
				ConvertLines.createSpecialVar(this, _oVar, null, _sLoc);
			}
			subTab();
			
			pushLine("//Var Ini : ");
			
			
			
			pushLine("return "+ _sBaseName + ";");
			subTab();
			pushLine("}");
		}
		override function createUnitFunctionDestruction(_oUnit : UnitObj):Void {
			
			var  _sBaseName : String = "((" + _oUnit.sName + "*)_oRtu)";
			var _sClassDef :String =  _oUnit.oSClass.sName + "::";
			//pushLine( _sClassDef + _oUnit.sName + "* " + _sClassDef + "u_" + _oUnit.sName + "(){"); //TODO MAYbe for local unit
			pushLine(  "void " + _sClassDef + "tDel_" + _oUnit.sName + "(void* _oRtu){");
			addTab();
			
		
			var _sLoc  : String = _sBaseName + "->";
			
			addTab();
			//Search for subUnit
			var _i : UInt = _oUnit.aVarList.length;
			for (i in 0 ...  _i) {
				var _oVar :VarObj =  _oUnit.aVarList[i];
				ConvertLines.destroySpecialVar(this, _oVar, _sLoc);
			}
			subTab();
			
			pushLine("GZ_fFree(" + _sBaseName + ");");

			subTab();
			pushLine("}");
		}
		
		override function createUnitFunctionArrayWrite(_oUnit : UnitObj):Void {
			var _sClassDef :String =  _oUnit.oSClass.sName + "::";
			//pushLine( _sClassDef + _oUnit.sName + "* " + _sClassDef + "GZ_tAw_" + _oUnit.sName + "(ArrayPtr* _aArray, unsigned Int _nIndex){"); //TODO MAYbe for local unit
			pushLine(  _oUnit.getCppName() + "* " + _sClassDef + "tAw_" + _oUnit.sName + "(ArrayPtr* _aArray, unsigned int _nIndex){");
			addTab();
			
			pushLine("if(_nIndex >  _aArray->size){"); //Resize array
			pushLine("}");
			
			pushLine("if(_aArray->array[_nIndex] == 0){ //null");
				pushLine( _oUnit.sName + "* _rNewRtu = tNew_" +  _oUnit.sName  + "();");
				pushLine("_aArray->array[_nIndex] = (ArrayPtr*)_rNewRtu;");
				pushLine("return _rNewRtu;");
			pushLine("}");
			
			pushLine("return (" + _oUnit.sName +"*)_aArray->array[_nIndex];");
			
			subTab();
			pushLine("}");
		}
		
	/*
		private function getExtendClassToString(_oSClass:SClass):String { //Execute
			var _sExtend : String = "";
			var _aList:Array<Dynamic> =  _oSClass.aExtendClass;
			var _i : UInt = _aList.length;
			if (_i == 0) {
				return "";
			}
			
			for (i in 0 ...  _i) {
				if (i != 0) {
					_sExtend += ", ";
				}
				var _oExtend : SClass = _aList[i];
				_sExtend += _oExtend.oSLib.sName + "_" +  _oExtend.sName
			}
	
			return " : " + _sExtend + " ";
		}
		*/
		
		
		
		private function iniAssociateVar(_oSClass:SClass):Void {
			
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
							var _sName : String = " ua_" +  _oOriVar.sName;
							//if (_oOriVar.eType == EuVarType._UInt) {
							
							if (_oOriVar.eType == EuVarType._Int && cast(_oOriVar,VarInt).bUnsigned){
								pushLine(_sName + ".nVal = (" + TypeText.typeToCPP(_oOriVar, false, false, true) +"*)&" +  _oOriVar.sName + ";" );
							}else{
								pushLine(_sName + ".nVal = &" +  _oOriVar.sName + ";" );
							}
							pushLine(_sName + ".nFracVal = 0;" );
							pushLine(_sName + ".nTo = " +  _oOriVar.sName  + ";" ); //Verifie that 16 is same as the libcpp
							pushLine(_sName + ".nSpeed = 1;" );
							pushLine(_sName + ".nLimit = GZ_nMaxFloat;" );
							
						
							
						//break;
						default:
					}
				}
			}
		}
		
		
		private function listEmbedFilesInclude(_oSClass:SClass):Void {
		
			var _aList:Array<Dynamic> = _oSClass.aEmbedFileList;
			var _i : UInt = _aList.length;
			for (i in 0 ...  _i) {
				var _oRc : VarRc = _aList[i];
				var _sFile : String =  _oRc.sEmbedRc;
			//	_sFile = _sFile.substring( _sFile.search(":") + 1, _sFile.length);
				_sFile = _sFile.substring( _sFile.indexOf(":") + 1, _sFile.length);
				
				//pushLine("extern gzEmbed<Lib_GZ::File::c" + _oRc.oRcClass.sName + "> " + _oRc.sEmbedRc + ";");
				pushLine("extern gzPod<Lib_GZ::File::c" + _oRc.oRcClass.sName + "> " + _oRc.sEmbedRc + ";");
					
					
				
			}
		}
		
		
		private function fIsIsInHeretiage(_oSClass:SClass):Void {
		}
		
		private function listBackwardHeritage(_oSClass:SClass):Void {
			var _bOne  : Bool = false;
			var _aList : Array<Dynamic> =  _oSClass.oPackage.aSImportList_Full;
			var _i:UInt = _aList.length;
			if ( _i > 0) {
			
				for (i in 0 ..._i) {
					var _oFileImport : FileImport  = _aList[i];
					var _oSPackage : SPackage  =  _oFileImport.oRefPackage;
					for(_oBackwardTest in _oSPackage.aClassList){
							//var _oBackwardTest : SClass =  _oFileImport.oRefClass;
							if (_oSClass.fIsBackwardHeritage(_oBackwardTest)) {
								if (!_bOne) {
									pushLine("//Backward heritage");
									_bOne = true;
								}
								pushLine("#include \"" +  _oBackwardTest.oSLib.sWriteName + "/" + _oBackwardTest.oPackage.sPath    + _oBackwardTest.oPackage.sName + ".h\"") ;
							}
					}
				}
				if(_bOne){
					addSpace();
				}
			}
		}

		
		private function listHeritage(_oSClass:SClass):Void {
			var _aList : Array<Dynamic> = _oSClass.aExtendClass;
			var _i:UInt = _aList.length;

				for (i in 0 ..._i) {
					var _oSCurr : SClass  = _aList[i];
					var _sPath : String = "#include \"" + _oSCurr.oSLib.sWriteName + "/" + _oSCurr.oPackage.sPath  + _oSCurr.oPackage.sName + ".h\"";
					_sPath = _sPath.split("\\").join("/");  
					pushLine(_sPath);
					listHeritage(_oSCurr);
				}
		}
		
				
		private function includeExtendImportClass(_oSClass:SClass):Void {
			var _aList : Array<Dynamic> = _oSClass.aExtendClass;
			var _i:UInt = _aList.length;

				for (i in 0 ..._i) {
					var _oSCurr : SClass  = _aList[i];
					
					//var _sPath : String = "#include \"" + _oSCurr.oSLib.sWriteName + "/" + _oSCurr.sPath  + _oSCurr.sName + ".h\"";
				
					//pushLine(_sPath);
					includeClass(_oSCurr.oPackage);
					includeExtendImportClass(_oSCurr);
				}
		}
		
		
		private function  fGetEmbedVarIni(_oSClass:SClass):String {
			var _sResult : String = "";
			for ( _oVar  in _oSClass.aEmbedVarList) {//VarCallClass
				_sResult += "," + _oVar.sName + "(this)";
			}
			return _sResult;
		}
		
		
		
		
		private function getDefHeaderDefinition(_oSClass:SClass) {
			if (_oSClass.aEnumList.length > 0) {
				//pushLine("namespace " +  oSClass.oSLib.sWriteName + "{namespace " +  oSClass.sName  + "{");
				pushLine(_oSClass.sNamespace);
				
				addTab();
				//pushLine("//Enum");
				//listEnumDefinition();
				subTab();
				pushLine(_oSClass.sEndNamespace);
				//pushLine("}}");
				addSpace();
			}
		}
		
		
		private function listEnumDefinition(_oSClass:SClass) {
			var _aEnumList:Array<Dynamic> = _oSClass.aEnumList;
			var _i : UInt = _aEnumList.length;
			for (i in 0 ...  _i) {
				var _oEnum : EnumObj = _aEnumList[i];
				if (!_oEnum.isExtend()) { //Extend type don't need to be converted
					
					pushLine(_oEnum.sName + "::" +  _oEnum.sName + "(){};");
				}
			}
		}
		

		
		public function fAddThreadFonction(_oSClass:SClass):Void {
			if ( _oSClass.bThread ) {
				if(_oSClass.oThreadClass != null){
					pushLine("GZ_mNewThreadCpp(" + _oSClass.oSLib.sWriteName  +  ", " +  _oSClass.sName + ", " + _oSClass.oThreadClass.sNsAccess.substring(0, _oSClass.oThreadClass.sNsAccess.length-2) + ", " + _oSClass.oThreadClass.sName + ");");
				}else {
					pushLine("GZ_mNewThreadCpp(" + _oSClass.oSLib.sWriteName  +  ", " +  _oSClass.sName + ");");
				}
			}
		}
		
		public function fIsHaveStack(_oSClass:SClass) : Bool{ 
			if (_oSClass.aDelegateListIni.length > 0) {
				return true;
			}
			return false;
		}
		
		
		
		/*
		public function getGateList(_oSClass : SClass) :Void { 
			for(var _oGate : VarGate in _oSClass.aGateVarList) {
				pushLine("gzGate<Void*> " + _oGate.sName + ";"); 
			}
		}
		*/
		
		public function fCreateFuncTable(_oSClass : SClass) :Void {
			if (!_oSClass.bIsResults && !_oSClass.bIsPod && !_oSClass.bIsVector ){
				
				//qwer
				
				pushLine("//FuncTable " );
				pushLine("namespace " + _oSClass.sName + "{");
				addTab();
				
					/*
					pushLine("struct FuncTable {" );
						for (_oSFunc in _oSClass.aFunctionList){
							if ( _oSFunc.eFuncType != EuFuncType.Pure && _oSFunc.oSClass.oFuncDestrutor != _oSFunc) {
								pushLine(CommonCpp.fGetObjFPtrNameFull(_oSFunc) + ";");
							}
						}

					pushLine("}  FTable = {");
					*/
					
					pushLine("FuncTable Func = {");
						var _sDelim : String = " ";
						for (_oSFunc in _oSClass.aFunctionList){
						//	if ( _oSFunc.eFuncType != EuFuncType.Pure && _oSFunc.oSClass.oFuncDestrutor != _oSFunc) {
							if ( _oSFunc.eFuncType != EuFuncType.Pure) {
								pushLine( _sDelim + _oSClass.sCFuncName  + _oSFunc.sRealName + _oSFunc.sSignature );
								_sDelim = ",";
							}
						}
						
						
					pushLine("};");

					
				
				/*
				for (_oSFunc in _oSClass.aFunctionList){
					if ( _oSFunc.eFuncType != EuFuncType.Pure && _oSFunc.oSClass.oFuncDestrutor != _oSFunc) {
						//pushLine("//FuncTable" + _oSFunc.sName);
						
						//pushLine(_oSClass.sNamespace);
						var _sPtrFuncName : String =	_oSClass.sCFuncName  + _oSFunc.sRealName + _oSFunc.sSignature;
						pushLine(CommonCpp.fGetObjFPtrNameFull(_oSFunc) + " = "  + _sPtrFuncName +  ";");
						//pushLine(_oSExt.sEndNamespace);
					}
				}*/
				subTab();
				pushLine("}");
			}
		}

		public function fDefaultCopyFunc(_oSClass : SClass) :Void {
			/*
			if (!_oSClass.bExtension && !_oSClass.bIsPod) {
				
				pushLine( "gzAny c" + _oSClass.sName + "::MemCopy(){");
				
				if(_oSClass.bAtomic){
					pushLine( "return (gzAny)this;"); //Todo inline
				}else {
					pushLine( "return (gzAny)new c" +  _oSClass.sName  + "(*this);");		
				}
				

				pushLine( "}");
				
			}*/
		}
		
		public function fAddFunctionName(_oSClass : SClass):Void {
		
			
			var _sFuncList : String = "gzFuncStack zFuncName[] = {";
			for(_oFunc  in _oSClass.aFunctionList) {//SFunction
				_sFuncList += "{0,\"" + _oFunc.sName + "\"},";
			}
			_sFuncList = _sFuncList.substring(0, _sFuncList.length - 1);
			_sFuncList += "};";
			pushLine("#ifdef GZ_tHaveCallStack");
			pushLine(_sFuncList);
			pushLine("#endif");
		}
		public function fAddIniClass(_oSClass:SClass) {
			
			
			pushLine("void Ini_Class(){");
			
			ConvertLines.convertSpecialVarConstructorIni(this, _oSClass, _oSClass.aIniStaticVarList);
			/**
			for ( _oVar  in _oSClass.aAtomicVarList) {//VarObj
			//	if (_oVar is CommonVar) {
				if ( Std.is(_oVar, CommonVar))  {
					var _oStaticVar : CommonVar = cast(_oVar);
					//pushLine( _oStaticVar.sName + ".Ini();");
					
					pushLine( _oStaticVar.sName + "=0;");//Todo make true ini
					
				
				}
			}
			*/
			
			//pushLine("GZ_printf(\"\\nIniClass: " + _oSClass.sName + "\");");
			if(_oSClass.bExtension){
				pushLine("//Warning! Extention InClass Not called!!: " + _oSClass.sName );
			}
			pushLine("}");
			
		}
		
		
		
		
	}
