package language.project.convertCpp ;
	import language.enumeration.EuConstant;
	import language.pck.FileImport;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuSharing;
	import language.enumeration.EuVarType;
	import language.MyFile;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.project.convertSima.TypeResolve;
	import language.project.CppProject;
	import language.Text;
	import language.vars.special.EnumObj;
	import language.vars.special.UnitObj;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.Delegate;
	import language.vars.varObj.EaseOut;
	import language.vars.varObj.LineObj;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.VarCppLine;
	import language.vars.varObj.VarGate;
	import language.vars.varObj.VarObj;
	import language.base.Root;
	import language.base.Debug;
	/**
	 * ...
	 * @author ...
	 */
	class HeaderFile extends CommonCpp
	{

		private var bUseDefineIN : Bool = false;
		
		public function new(_Main:Root, _oCppProject : CppProject, _oSClass : SClass) { 
	
			super(_Main,_oCppProject, _oSClass);
			
			//Debug.trac("Header file : "  + _oSClass.sName)
			convertHeader();		
		}
		
		public function convertHeader():Void {
				
			pushHeaderDefine();
					pushLine(oSClass.sCNamespace + "class c"  + oSClass.sName +";" + oSClass.sCEndNamespace);
			addSpace();
			if(oSClass.oSLib.sName == "GZ"){
				pushLine(fAddLicence());
			}else if(oSClass.oSLib.sName == "SimaCode"){
				pushLine("//GroundZero Engine Demo File -- An example to show the capabilities of GZE, modify this file as you like --");
			}
			/*
			pushLine("//Enable Overplace");
			pushLine("#include \"" + oSClass.oSLib.sWriteName + "/" + oSClass.sPath + "__" + oSClass.sName + ".h\"");
			addSpace();
			*/
			//pushLine("//GroundZero Engine");
			 // pushLine("class " + oSClass.oSLib.sWriteName + "_" + oSClass.sName +";" );
			// pushLine( "namespace " + oSClass.oSLib.sWriteName + "{class c"  + oSClass.sName +";}" );
			
				
			
			
			
			//class Example {
			//Extend
			var _sExtend  : String  = "";
			if(!oSClass.bIsPod){
				_sExtend   = " : "+ getExtendClassToString(oSClass); //return bUseDefineIN
			}
			
			
			
			//#ifndef tHDef_Example
			//#define tHDef_Example
		
			
			//#include "mainHeader.h"
			//includeMainHeader();
			pushLine("#include \"" + oSClass.oSLib.sWriteName + "/" + oSClass.oSLib.sWriteName + ".h\"");
			if(oSClass.sName != "Class"){ //Base class exemption (recursive inclusion), todo only in GZ lib
				pushLine("#include \"Lib_GZ/GZ.h\"");
			}
			pushLine("#include \"Lib_GZ/Thread.h\""); //Temp
			
			if (oSClass.aEnumList.length > 0 || oSClass.aConstList.length > 0 ) {	
				 //////////////// Have Lite _.h ////////////
				pushLine("#include \"_" + oSClass.sName + ".h\"");
			}
			
			includeExtention();
			
			//AddCppCode
			fAddCppLines(oSClass.aCppLineListHeader);
			
			
			//pushLine("namespace " +  oSClass.oSLib.sWriteName + "{namespace " +  oSClass.sName  + "{");
			pushLine(oSClass.sNamespace);
			getUnitDefinition(); //TODO Only local
			pushLine(oSClass.sEndNamespace);
		//	pushLine("}}");
			
		
			
			//Include class() //////////////////////////////////
			includeClass();
			/////////////////////////////
			
			listDlgConvertible();
			
			//ClassId
			pushLine(oSClass.sNamespace);
		//	pushLine("extern gzUInt _nId;");
			
			//getGateList(oSClass);
			getVarToConvert(oSClass.aAtomicVarList, EuSharing.Public, true,false,EuConstant.Normal);
		
			//pushLine(oSClass.sEndNamespace);
			
						//pushLine("class " + oSClass.oSLib.sWriteName + "_"  + oSClass.sName + _sExtend +" {");
			//pushLine("namespace " +  oSClass.oSLib.sWriteName + "{");
			//pushLine("namespace " +  oSClass.sName  + "{");
			addTab();
			addSpace();	
			
			listDelegateTypeDef();
			
			getUnitToConvert(); //TODO Only local
			//getEnumDefinition(); Remove now in _ClassName.h
			addSpace();	
			//pushLine("//Static function");
			//getStaticFunctionToConvert(oSClass);
			
			//Create unit function
			getUnitFunction(oSClass);
			fAddCppLines(oSClass.aCppLineListNamespace_H);
			
			subTab();
			pushLine("}");
			
			////////////////////////////
			///////// Pure Static //////
			////////////////////////////
			pushLine("class tApi_" + oSClass.oSLib.sWriteName + " p" + oSClass.sName + " {");
			addTab();
			addSpace();
			pushLine("public:");
		
			pushLine("//Pure Function");
			getPureFunctionToConvert(oSClass);
			
			subTab();
			subTab();
			pushLine("};");
			
			addSpace();	
			///////////////////////////////
			
			
			

			pushLine("class tApi_" + oSClass.oSLib.sWriteName + " c" + oSClass.sName + _sExtend +" {");
			
			addTab();
			addSpace();
			
			//Var list
			
			
			/////////////////////
			//Get only public ///
			/////////////////////
			pushLine("public:");
			addTab();
			addSpace();
			
			if(oSClass.bIsPod){
				fAddPodExtends(oSClass);
			}
			
			fAddCppLines(oSClass.aCppLineListClass_H);
			
			//!!!!!!!!!!!!!!!!! Important keep same order as in the CPP backward heritage !!!!!!!!!!!!!!
			//Delegate
			getAllDelegateRef(oSClass);
			
			//////////////////////
			//Get only static // 
			/////////////////////
			

			addSpace();
			pushLine("//Var");
			getVarToConvert_(oSClass.aGlobalVarList, EuSharing.Public);
			
			/*
			//Static public var
			pushLine("//Static Var")
			aVarIdList = aCurrentClass[cClassStaticVarList];
			getVarToConvert(cPublic, true);
			*/
			
			//Get public function
			getFunctionToConvert(oSClass, EuSharing.Public);
			//Default Copy func
			if(!oSClass.bIsPod){
				fDefaultCopyFunc(oSClass);
			}
			//Destructeur
			//pushLine("virtual ~" + oSClass.oSLib.sWriteName + "_"  + oSClass.sName + "();")
			if(!oSClass.bIsPod){
				pushLine("virtual ~c"  + oSClass.sName + "();");
			}
			addSpace();
			


			//Create associateVar
			getAssociateVar(oSClass);
			
			//!!!!!!!!!!!!!!!!! Important keep same order as in the CPP backward heritage !!!!!!!!!!!!!!
			
			pushLine("//Static singleton function");
			getStaticFunctionToConvert(oSClass);
			
			subTab();
			//////////////////////
			//Get only private //
			/////////////////////
			pushLine("private:");
			addTab();
			addSpace();
			pushLine("//Var");
			getVarToConvert_(oSClass.aGlobalVarList, EuSharing.Private);
	
			
			/*
			//Static public var
			pushLine("//Static Var")
			aVarIdList = aCurrentClass[cClassStaticVarList];
			getVarToConvert(cPrivate, true);
			*/
			
			//Get private function
			getFunctionToConvert(oSClass, EuSharing.Private);
	
		
			
			subTab();
			subTab();
			subTab();
			pushLine("};");
			
			
			
			///////////////////////////////
			///////// Thread Static //////

			pushLine("class tApi_" + oSClass.oSLib.sWriteName + " cs" + oSClass.sName + getOverplaceString(oSClass)  + "  {");
	
			addTab();
			addSpace();
			pushLine("public:");
			addTab();
			//AddCppCode
			fAddCppLines(oSClass.aCppLineListStatic_H);
			
			
		//	pushLine("inline cs" + oSClass.sName + "(Lib_GZ::cClass* _parent):cStThread(_parent){};");
		//	pushLine("inline ~cs" + oSClass.sName + "(){};");
			
			fCreateConstrutorWrapper();
			
			pushLine("//Public static"); //Only public
			getVarToConvert(oSClass.aStaticVarList, EuSharing.Public, false, false,EuConstant.Normal);
			
			addSpace();
	//		pushLine("//Static function");
	//		getStaticFunctionToConvert(oSClass);
			
			
			
			getVarToConvert(oSClass.aStaticVarList, EuSharing.Private, false, false,EuConstant.Normal);
			
		//	pushLine("//Auto Singleton");
		//	pushLine("gzSp<" + "c" + oSClass.sName  + "> zInst;");
			
			//subTab();
			if(oSClass.bHaveOverplace == false){
			//	pushLine("inline cs" + oSClass.sName +"(Lib_GZ::cClass* _parent): Lib_GZ::cStThread(_parent), zInst(0) {};");
				pushLine("inline cs" + oSClass.sName +"(Lib_GZ::cClass* _parent): Lib_GZ::cStThread(_parent) {};");
			}else {
				var _oSClassOp : SClass =  cast(oSClass.aExtendClass[0]);
				//pushLine("inline cs" + oSClass.sName +"(Lib_GZ::cClass* _parent): " +   _oSClassOp.sNsAccess + "cs"  + _oSClassOp.sName  + "(_parent), zInst(0) {};");
				pushLine("inline cs" + oSClass.sName +"(Lib_GZ::cClass* _parent): " +   _oSClassOp.sNsAccess + "cs"  + _oSClassOp.sName  + "(_parent) {};");
			}
			pushLine("inline ~cs" + oSClass.sName +"(){};");
			
			subTab();
			//pushLine("private:");
			subTab();
			pushLine("};");
			
			if(oSClass.bHaveOverplace == false){
				pushLine("GZ_mStaticClass(" + oSClass.sName + ")");
			}else {
				var _oSClassOp : SClass =  cast(oSClass.aExtendClass[0]);
				pushLine("GZ_mStaticClassOp(" + oSClass.sName + ", " + _oSClassOp.sNsAccess  + _oSClassOp.sName  + ");");
			}

			/////////////////////////////
			/////////////////////////////
			
			
			
			pushLine("namespace " +  oSClass.sName  + "{");
		//	fCreateConstrutorWrapper();
			fAddThreadFonction();
			
			pushLine(oSClass.sEndNamespace);
			
			//pushLine("}")
			//pushLine("}")
			
			if (oSClass.bExtension) { //For extention
				pushLine("#undef tHDef_IN_" +  oSClass.sHeaderName);
			}
			
			
	
			pushLine("#endif");
			/*
			if (bUseDefineIN) { //Resolve problem of recursive extented class linking
				pushLine("#endif");
			}*/
		}
		
		//#ifndef tHDef_LibName_Example
		//#define tHDef_LibName_Example
		private function pushHeaderDefine():Void {
			
			//pushLine("#pragma once");
			pushLine("#if !( defined tHDef_" +  oSClass.sHeaderName + getClassExtendDefine(oSClass) + ")"); //Resolve problem of recursive extented class linking !Very important!
			pushLine("#pragma once");
			
			//pushLine("#ifndef tHDef_" + oSClass.oSLib.sName + "_" + oSClass.sName);
			pushLine("#define tHDef_" +  oSClass.sHeaderName);

			if (oSClass.bExtension) { //For extention
				pushLine("#define tHDef_IN_" +  oSClass.sHeaderName);
			}

		}
		
		private function getClassExtendDefine(_oSClass:SClass):String {
			var _oExtend : SClass;
			var _sIN_define : String = "";
			var _aList:Array<Dynamic> =  _oSClass.aExtendClass;
			var _i : UInt = _aList.length;
			for (i in 0 ...  _i) {
	
				_sIN_define += " || ";
				_oExtend = _aList[i];
				_sIN_define += "defined  tHDef_IN_" +  _oExtend.sHeaderName ; 
			}
			for (i in 0 ... _i) {
				_oExtend = _aList[i];
				_sIN_define += getClassExtendDefine(_oExtend);
			}
		
			return _sIN_define;
		}
		
		/*
		private function includeMainHeader():Void {
		
			//Include basic class of cpp
			//pushLine("#include \"" + oSClass.sPathBack +  oCppProject.sLibRelativePath + oCppProject.sCppMainHeader + "\"");
			//pushLine("#include \"" + oSClass.sPathBack +   oSClass.oSLib.sWriteName HCommonStructFile.sHeader + "\"");
			 var _sPath : String;
		
			
			//pushLine("#include \"" + _sPath +   oCppProject.sCppMainHeader + "\"");
			if (oSClass.oSLib == oCppProject.oSProject.oCppLib) {
				_sPath = mFile.getRelativePath( oSClass.oSLib.sWritePath + oSClass.sPath, oCppProject.oSProject.oCppLib.sWritePath   , false);
				_sPath = _sPath.split("\\").join("/");  
				
				pushLine("#include \"" + _sPath +  "Main" + oSClass.oSLib.sWriteName + ".h\"");
			}else {
		
				pushLine("#include \"" +  oSClass.sPathBack  +  "Main" + oSClass.oSLib.sWriteName + ".h\"");
			}

			//pushLine("#include \"" + oSClass.sPathBack +  oCppProject.sCppMainHeader + "\"");
			//pushLine("#include \"" + oSClass.sPathBack +  "Common" + oSClass.oSLib.sWriteName + ".h\"");
		
			//if ( oSClass.aExtendClass.length == 0) {
			//	pushLine("#include \"" + _sPath +  "Delegate.h"  + "\""); 
			//}
			
			
			//Debug
			//if(bConvertDebug){
			//	aCurrentConvert[nConvertLine] = "#include \"" +  aCurrentClass[cClassPathBack] + sLibCppRelativePath  + "Debug.h\"";
			//}
		}
		*/
		private function includeExtention():Void {
			
			var _aList : Array<Dynamic> = oSClass.aExtendClass;
			var _i:UInt = _aList.length;
			for (i in 0 ..._i) {
				var _oExtend : SClass  = _aList[i];
				var _sPath : String = _oExtend.sPath; 
				_sPath = _sPath.split("\\").join("/");  
				pushLine("#include \"" + _oExtend.oSLib.sWriteName + "/" + _sPath + _oExtend.sName + ".h\"");
			}
		}
		
		
		
		private function includeClass():Void {
			
			 var _oImport : FileImport;
			 var _sPath : String;
			 var _sLib : String;
			 var _sName : String;
			 var _sClassPath : String = oSClass.sPath;
			 var _sClassLib : String = oSClass.oSLib.sWritePath;
			 
			 addSpace();
			var i:Int;
						
			var _i:UInt = oSClass.aSImportList.length;
			
			if (_i > 0) { 
				pushLine("//Optimised Class include -> direct class or header of header (Constants)");
			}
			//Normal class
			for ( i in 0 ... _i) {
				_oImport = 	oSClass.aSImportList[i];
				
				_sName = _oImport.sName;
	
					
				var _oCurrSClass : SClass = _oImport.oRefClass;
				
				if (oSClass.aSImportListRequireFullDefinition[i] == true) {
					 //Full definition required
					_sLib  = _oImport.oSLib.sWritePath;
					_sPath = _oImport.sPath; 
					_sPath =  _oImport.oSLib.sWriteName + "\\"+ _sPath;
					
					_sPath = _sPath.split("\\").join("/");  
					pushLine("#include \""   + _sPath + _sName + ".h\"");
					
				}else{
					if (_oCurrSClass.aEnumList.length > 0  || _oCurrSClass.aConstList.length > 0) {
										
						 //////////////// Have Lite _.h ////////////
						_sLib  = _oImport.oSLib.sWritePath;
						_sPath = _oImport.sPath; 
						_sPath =  _oImport.oSLib.sWriteName + "\\"+ _sPath;
						
						_sPath = _sPath.split("\\").join("/");  
						pushLine("#include \""   + _sPath + "_" + _sName + ".h\"");
						
					}else { 
						////////////// Optimised //////////////////
						_sLib  = _oImport.oSLib.sWriteName;
						//pushLine("class " + _sLib + "_" + _sName + ";" + listUnit(_oCurrSClass) );
						if (_oCurrSClass.aUnitList.length != 0) {
							pushLine(_oCurrSClass.sCNamespace + "class c" + _sName + "; namespace " + _sName + " {" + listUnit(_oCurrSClass) + "}" + _oCurrSClass.sCEndNamespace);
							//pushLine("namespace " + _sLib + "{class c" + _sName + "; namespace " + _sName + " {" + listUnit(_oCurrSClass) + "}}" );
						}else {
							pushLine(_oCurrSClass.sCNamespace + "class c" + _sName + ";" + _oCurrSClass.sCEndNamespace );
						}
						
			
						
					}
				}
			}
			addSpace();
		}
		
				
	
		
		/*
		 * 
		 * 
	 typedef Int Example_GroundZero_eWindow;
        #define Example_GroundZero_eWindow_EnumnCenter 5
        #define EnumnCenters 2

        GZ_Window_eWinState_  _EnumnCenter
		 */
		
		private function getEnumDefinition():Void {
			
			var _sLine : String = "";
			
			addSpace();
			pushLine("//Enum");
			var _aEnumList:Array<Dynamic> = oSClass.aEnumList;
			var _i : UInt = _aEnumList.length;
			for (i in 0 ...  _i) {
				var _oEnum : EnumObj = _aEnumList[i];
				if(!_oEnum.isExtend()){ //Extend type don't need to be converted
					var _sPrefix :String = _oEnum.getCppName();
					_sLine = "typedef Int " + _sPrefix  + ";";
					pushLine(_sLine);
					_sPrefix += "::";
					getEnumSubVar(_oEnum, _sPrefix);
				}
			}
			
	
		}
		
		private function getEnumSubVar(_oEnum : EnumObj, _sPrefix:String):Void {
			addTab();
				var _aEnumVar:Array<Dynamic> = _oEnum.aVarList;
				var _i : UInt = _aEnumVar.length;
				var _sInput : String = "";
				for (i in 0 ...  _i) {
					
					//Always paramInput
					var _oVar : VarObj = cast(_aEnumVar[i]); 
					_sInput = ConvertLines.checkVarConvertIn( _oVar , cast(_oVar,ParamInput).oConvertInType, ConvertLines.convertLineToCpp(cast(_oVar,LineObj))); //Todo type resolve
					_oVar = cast(_oVar,ParamInput).oVarInput;  //TODO made initialisation with the input
		
					pushLine("#define " +  _sPrefix + cast(_oVar,CommonVar).sName + " " + _sInput) ;
				}
			subTab();
		}
		
		
		private function getUnitDefinition():Void {
			
			var _sLine : String = "";
			
			addSpace();
			pushLine("//Structure Definition");
			var _aUnitList:Array<Dynamic> = oSClass.aUnitList;
			var _i : UInt = _aUnitList.length;
			for (i in 0 ...  _i) {
				var _oUnit : UnitObj = _aUnitList[i];
				if(!_oUnit.isExtend()){ //Extend type don't need to be converted
					var _sName : String = _oUnit.sName;
					//_sLine += "struct " + _sName + "; "
					_sLine += "struct " + _sName + "; " + "struct " + "_" + _sName + "; ";
					
				}
			}
			
			pushLine(_sLine);
		}
		
		
		private function listUnit(_oSClass : SClass):String {
			var _sLine : String = "";
			var _aUnitList:Array<Dynamic> = _oSClass.aUnitList;
			var _i : UInt = _aUnitList.length;
			for (i in 0 ...  _i) {
				var _oUnit : UnitObj = _aUnitList[i];
				if(!_oUnit.isExtend()){ //Extend type don't need to be converted
					var _sName : String = _oUnit.sName;
					_sLine += "struct " + _sName + "; " + "struct " + "_" + _sName + "; ";
					
				}
			}
			return _sLine;
		}
		
				
		private function getUnitToConvert():Void {

			addSpace();
			pushLine("//Structure Implementation");
			var _aUnitList:Array<Dynamic> = oSClass.aUnitList;
			var _i : UInt = _aUnitList.length;
			for (i in 0 ...  _i) {
				var _oUnit : UnitObj = _aUnitList[i];
				if(!_oUnit.isExtend()){ //Extend type don't need to be converted
					convertUnit(_oUnit);
				}
			}
		}
		
		private var sBaseStruct : String = "gzUInt nNbIns; ";
		private function convertUnit(_oUnit:UnitObj):Void {
			
			var _sName : String = _oUnit.sName;
			
			//Get all var
			var _sSubVars : String = "";
			
			var _aVarList : Array<Dynamic> = _oUnit.aVarList;
			var _i:UInt = _aVarList.length;
			for (i in 0 ..._i) {
				var _oVar : VarObj = _aVarList[i]; //See SFIND findUnitSubVar() maybe do same func
				switch(_oVar.eType) {
					case EuVarType._ParamInput:
						_oVar = cast(_oVar,ParamInput).oVarInput;  //TODO made initialisation with the input
					//break;
					
					default :
					
					//break;
					
				}
				
				_sSubVars += convertVar(cast(_oVar,CommonVar)) + "; ";
			}
			//push
			//pushLine( "struct " + _sName + " { " + _sSubVars + "};");
			pushLine( "struct " + _sName + " { "+ sBaseStruct + _sSubVars + "};"  + "struct _" + _sName + " { " + _sSubVars + "};" );
		}	
		
		
		public function listDlgConvertible():Void {
			var _aList: Array<Dynamic> = oSClass.aDelegateUniqueList;
			var _i : Int = _aList.length;
			if (_aList.length > 0) {
				pushLine("/////Delegate InterCompatible  /////");
				addSpace();
			}
			for (i in 0 ..._i) {
				var _oDlg: Delegate = _aList[i];
				pushLine("#ifndef GZ" + _oDlg.sDelegateString);
				pushLine("#define GZ" + _oDlg.sDelegateString);
				pushLine("namespace Lib_GZ{GZ_mIComp(" +  _oDlg.sDelegateString + ");}");
				pushLine("#endif");
				addSpace();
			}
			if (_aList.length > 0) {
				pushLine("/////////////////////////////////");
				addSpace();
			}
		}
			
		public static var sPrefix : String = "_d";
		public function listDelegateTypeDef():Void {
			var _aList: Array<Dynamic> = oSClass.aDelegateUniqueList;
			var _i : Int = _aList.length;
			for (i in 0 ..._i) {
				var _oDlg: Delegate = _aList[i];
				var _oFunc : SFunction = _oDlg.oSFunc;
				
				var _sReturn : String = TypeText.getGeneralStringType(_oFunc.oReturn);
				
				var _sParam : String = "";
				var _aParam : Array<Dynamic> = _oFunc.aParamList;
				if (_aParam.length > 0) {
					for ( j in 0 ... _aParam.length) {
						if (j != 0) {
							_sParam += ", ";
						}
						_sParam +=  TypeText.typeToCPP(_aParam[j]); 
					}
					
				}else {
					_sParam  = "void";
				}
				

				var _sDefaultReturn : String = "0";
				var _sHaveReturn : String = "return ";
				if (_oFunc.oReturn.eType == EuVarType._Void) {
					_sDefaultReturn = "";
					_sHaveReturn = "";
				}
				if (_oFunc.oReturn.eType == EuVarType._Bool) {
					_sDefaultReturn = "false";
				}
	
				_sParam = getFunctionParam(_oFunc);
				var _sParamIni : String = getFunctionParam(_oFunc, true);
				var _sParamNoType : String = getFunctionParam(_oFunc, false, true);
				if (_sParamNoType != "") {
					_sParamNoType = ", " + _sParamNoType;
				}
				
				var _sParamDlgIni : String;
				if (_sParam != "") {
					_sParamDlgIni = ", " + _sParam;
				}else {
					_sParamDlgIni = _sParam;
				}
				
				addSpace();
				pushLine("namespace " + _oDlg.sDelegateStringFull + "{");
				addTab();
				pushLine("///////");
				pushLine("GZ_mDlgIni(" + _sReturn + ", GZ_PARAM" + _sParamDlgIni + "){return " + _sDefaultReturn + ";};"); 
				pushLine(" class Dlg { GZ_mDlgClass(" + _oDlg.sDelegateString + ")");
				addTab();
				pushLine("///////////////////");
				pushLine("inline  " + _sReturn + " fCall(" + _sParam + "){"); 
				addTab();
				pushLine(_sHaveReturn + "GZ_mDlgCall(GZ_PARAM" + _sParamNoType + ");");
				subTab();
				pushLine(" }");
				subTab();
				pushLine("};"); 
				subTab();
				pushLine("}"); 
			}
			
			//	pushLine("typedef " + _sReturn + "(GZ::Delegate::*" + sPrefix + "Fp" + _oFunc.sDelegateString + ")" + "(" + _sParam + ");");
			//	pushLine("struct " +  sPrefix + "Str" + _oFunc.sDelegateString + " { " + sPrefix + "Fp" + _oFunc.sDelegateString + " fCall; GZ::Delegate* oClass; };");
			
		}
		
	
		
		public function fCreateConstrutorWrapper():Void {
			
			if( !oSClass.bThread && oSClass.aFunctionList.length > 0 ){ //oSClass.aFunctionList.length > 0 useless?
				var _sLoc : String =  "c" + oSClass.sName;
				var _sLocOp : String = _sLoc;
				var _sStatLoc : String =  "cs" + oSClass.sName;
				
				//Get the lowest level of overplace, for multiple op
				if (oSClass.bHaveOverplace) {
					var _oSClassOp : SClass = cast(oSClass.aExtendClass[0]);
					while (_oSClassOp.bHaveOverplace) {
						_oSClassOp = _oSClassOp.aExtendClass[0];
					}

					_sLocOp = _oSClassOp.sNsAccess + "c"  + _oSClassOp.sName;
				}
				
				/*
				pushLine("inline gzSp<" + _sStatLoc + "> Get(Lib_GZ::cThread* _oCurrThread){");
				pushLine("if(_oCurrThread->st(_nId) == 0){");
				pushLine("	_oCurrThread->st[_nId] = gzSp<Lib_GZ::cStThread>(new  " + _sStatLoc + "(_oCurrThread));");
				pushLine("}");
				pushLine("return gzSCastSelf<"+ _sStatLoc +">((_oCurrThread->st(_nId)->get()));");
				pushLine("}");
				*/
			//	pushLine("inline " + _sStatLoc  + "(Lib_GZE::cClass* _parent): " + oSClass.oExtend.oSClass.sNsAccess  + "(_parent){};");

				pushLine("//Object Creation Wrapper");
			//	pushLine("#ifndef tNew_" + oSClass.sHeaderName);
				//var _sLoc : String =  oSClass.oSLib.sWriteName + "::c" + oSClass.sName;
		
				if (oSClass.oFuncConstructor == null ) {
					Debug.fError("No constructor in : " + oSClass.sName);
				}
				
				if (oSClass.bIsPod) {
					pushLine("inline virtual gzPod<" + _sLocOp  + "> New(Lib_GZ::cClass* _parent"  + getFunctionParam( oSClass.oFuncConstructor , true, false, false) + "){" );
					//	pushLine("inline virtual gzPod<" + _sLocOp  + "> New("  + getFunctionParam( oSClass.oFuncConstructor , true, false, true) + "){" );
					addTab();
					pushLine("gzPod<" + _sLoc  + ">_oTemp = gzPod<" + _sLoc + ">(" + _sLoc + "());");
					pushLine("_oTemp->Ini_c" +  oSClass.sName + "(" + getFunctionParam(oSClass.oFuncConstructor , false, true)  + ");");
					pushLine("return _oTemp;");
					subTab();
					pushLine("}");
					
				}else{
					pushLine("inline virtual gzSp<" + _sLocOp  + "> New(Lib_GZ::cClass* _parent"  + getFunctionParam( oSClass.oFuncConstructor , true, false, false) + "){" );
					addTab();
					pushLine("gzSp<" + _sLoc  + ">_oTemp = gzSp<" + _sLoc + ">(new " + _sLoc + "(_parent));");
					pushLine("_oTemp->Ini_c" +  oSClass.sName + "(" + getFunctionParam(oSClass.oFuncConstructor , false, true)  + ");");
					pushLine("return _oTemp;");
					subTab();
					pushLine("}");
				//	pushLine("#endif");
				
				//	pushLine("//Auto Singleton");
				//	pushLine("gzSp<" + _sLocOp  + "> zInst;");
					/*
					pushLine("inline gzSp<" + _sLocOp  + "> NewSingleton(" + getFunctionParam( oSClass.oFuncConstructor , true, false, true) + "){" );
					addTab();
					pushLine("zInst = New(parent" + getFunctionParam(oSClass.oFuncConstructor , false, true, false)  + ");");
					pushLine("return zInst;");
					subTab();
					pushLine("}");*/
					
					addSpace();
				}
			}
			
		}
		
		public function fAddThreadFonction():Void {
			if( oSClass.bThread ){
				//pushLine("GZ_mNewThreadH(" + oSClass.oSLib.sWriteName  +  ", " +  oSClass.sName + ");");
				pushLine("GZ_mNewThreadH();");
			}
		}
		
		
		public function getGateList(_oSClass : SClass) :Void { 
			for( _oGate  in _oSClass.aGateVarList) {//VarGate
				pushLine("extern gzGate<Void*> " + _oGate.sName + ";"); 
			}
		}

		
		public function fDefaultCopyFunc(_oSClass : SClass) :Void {
			
		//	pushLine("#define Cpy_" + _oSClass.sHeaderName  + " "  + getExtendClassToString(oSClass, "(_o)") + fCopyAllVar(oSClass);
		//	pushLine("#define DCpy_" + _oSClass.sHeaderName  + " "  + getExtendClassToString(oSClass, "(_o)") + fCopyAllVar(oSClass, true);
			
		//	pushLine("inline c" + _oSClass.sName + "(var c" + _oSClass.sName + " &_o)" + " : " + Cpy_" + _oSClass.sHeaderName + "{};" );
		//	pushLine("inline c" + _oSClass.sName + "(var c" + _oSClass.sName + " &_o, gzBool _b)" + " : "+ getExtendClassToString(oSClass,"(_o, _b)") + fCopyAllVar(oSClass, true)  + "{};" ); 
			
			
			//pushLine("inline c" + _oSClass.sName + "(var c" + _oSClass.sName + " &_o)" +  getExtendClassToString(oSClass,"(_o)") + fCopyAllVar(oSClass)  + "{};" ); 
			//pushLine("inline c" + _oSClass.sName + "(var c" + _oSClass.sName + " &_o, gzBool _b)" + getExtendClassToString(oSClass,"(_o, _b)") + fCopyAllVar(oSClass, true)  + "{};" ); 
			
			
			//pushLine("inline Void iniCpy(const c" + _oSClass.sName + " &_o){" +    + "};" ); 
			
			
			
			
			
			//TODO copy
		//!!/pushLine("inline c" + _oSClass.sName + "(const c" + _oSClass.sName + " &_o) " +  getAllExtendClassToString(oSClass,"(_o)") + fCopyAllVar(oSClass)  + "{};" ); 



			//DeepCopy not sure??
		//			pushLine("inline c" + _oSClass.sName + "(const c" + _oSClass.sName + " &_o, gzBool _b) " + getAllExtendClassToString(oSClass,"(_o, _b)") + fCopyAllVar(oSClass, true)  + "{};" ); 
			
			
			
			if(!_oSClass.bExtension && !_oSClass.bIsPod){
				pushLine("virtual gzAny MemCopy();"); 
		//		pushLine("virtual gzAny DeepCopy();");
			}
		}
		
		
		
		public function fCopyAllVar(_oSClass : SClass, _bDeepCopy : Bool = false) :String {
			var _sCopy : String = "";
			for ( _oVar in _oSClass.aGlobalVarList) {//CommonVar
				var _sSetTo : String = "";
		
				if (_oVar.bEmbed || TypeResolve.isTypeCommon( _oVar.eType) ||  _oVar.eType == EuVarType._String || _oVar.eType == EuVarType._Gate ) { //Is a base type? Then copy
					_sSetTo = "_o." + _oVar.sName;
					if (_bDeepCopy && _oVar.eType == EuVarType._String) {
						_sSetTo += ",_b";
					}	
				}
				_sCopy += ", " + _oVar.sName + "(" + _sSetTo + ")";
			}
			return _sCopy;
		}
		
		
		
		/*  To have legal code **
		 http://stackoverflow.com/questions/26560311/whats-the-structs-initial-sequence/26560424#26560424
		 * 
		If a standard-layout union contains several standard-layout structs that share a common initial sequence (9.2), and if an object of this standard-layout union type contains one of the standard-layout structs, it is permitted to inspect the common initial sequence of any of standard-layout struct members;
		
		union U {
			struct S {
				Int a;
				Int b;
				Int c;
			}
			struct T {
				Int x;
				Int y;
				float f;
			}
		};
				
		t's saying that it's OK to access either U.S.a or U.T.x and that they will be equivalent. Ditto for U.S.b and U.T.y of course. But accessing U.T.f after setting U.S.c would be null behaviour.
		*/
		

		
		public function fAddPodExtends(_oSClass:SClass):Void {
			if (!oSClass.bIsPod) { //Error if not found before
				Debug.fError("Extend class for pod must be pod : " + _oSClass.sName);
			}
			
			
			for( _oExt   in _oSClass.aExtendClass) { //SClass   only one
				fAddPodExtends(_oExt);
				
				pushLine("//Extend " + _oExt.sName);
				pushLine("union {");
				addTab();
		
					pushLine("c" + _oExt.sName + " ptr" + _oExt.sName + ";");
					
					pushLine("struct {");
					getVarToConvert_(_oExt.aGlobalVarList, EuSharing.Public);
					pushLine("};");
					
				subTab();
				pushLine("};");

			}
			
			
		}

	}
