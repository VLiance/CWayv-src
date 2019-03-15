package language.project.convertCpp ;
	import language.enumeration.EuClassType;
	import language.enumeration.EuConstant;
	import language.pck.FileImport;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuSharing;
	import language.enumeration.EuVarType;
	import language.MyFile;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.project.convertSima.SPackage;
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
	import language.vars.varObj.VarCallClass;
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
		
		public function new(_Main:Root, _oCppProject : CppProject, _oSPackage : SPackage) { 
	
			super(_Main,_oCppProject, _oSPackage);
			
			//Debug.trac("Header file : "  + _oSClass.sName)
		
				convertHeader(_oSPackage);		
			
		}
		
		public function convertHeader(_oSPck:SPackage):Void {
				
			pushHeaderDefine(_oSPck);
			
			for (_oSClass in _oSPck.aClassList ){
				pushLine(_oSClass.sCNamespace + "class c"  + _oSClass.sName +";" + _oSClass.sCEndNamespace);
			}
			
				
			addSpace();
			if(_oSPck.oSLib.sName == "GZ"){
				pushLine(fAddLicence());
			}else if(_oSPck.oSLib.sName == "SimaCode"){
				pushLine("//GroundZero Engine Demo File -- An example to show the capabilities of GZE, modify this file as you like --");
			}
			/*
			pushLine("//Enable Overplace");
			pushLine("#include \"" + _oSClass.oSLib.sWriteName + "/" + _oSClass.sPath + "__" + _oSClass.sName + ".h\"");
			addSpace();
			*/
			//pushLine("//GroundZero Engine");
			 // pushLine("class " + _oSClass.oSLib.sWriteName + "_" + _oSClass.sName +";" );
			// pushLine( "namespace " + _oSClass.oSLib.sWriteName + "{class c"  + _oSClass.sName +";}" );
			
				
			
			
			//#ifndef tHDef_Example
			//#define tHDef_Example
		
			
			//#include "mainHeader.h"
			//includeMainHeader();
			
			
		
			if(!(_oSPck.fHaveIsAllStackType() && _oSPck.oSLib.sIdName == "GZ")) { //Just to not have circular inclusion for String --> Result --> GZ --> Result
				pushLine("#include \"" + _oSPck.oSLib.sWriteName + "/" + _oSPck.oSLib.sWriteName + ".h\"");
			}
			
			if(!_oSPck.fHaveIsAllStackType()){
				pushLine("#include \"Lib_GZ/Base/Thread/Thread.h\""); //Temp
			}
			
			
			includeClass(_oSPck);
			

		for (_oSClass in _oSPck.aClassList ){
			
			if (_oSClass.aEnumList.length > 0 || _oSClass.aConstList.length > 0 ) {	
				 //////////////// Have Lite _.h ////////////
				pushLine("#include \"_" + _oSClass.sName + ".h\"");
			}
			
			if(!_oSPck.fHaveIsAllStackType()){
				if(_oSClass.sName != "Class"){ //Base class exemption (recursive inclusion), todo only in GZ lib
					pushLine("#include \"Lib_GZ/GZ_inc.h\"");
				}
			}
					
			includeExtention(_oSClass);
			
					//class Example {
				//Extend
				var _sExtend  : String  = "";
				if(!_oSClass.bIsPod){
					_sExtend   =  getExtendClassToString(_oSClass); //return bUseDefineIN
				}
				
				if (_oSClass.sName == "Class" && _oSClass.oSLib.sIdName == "GZ"){
					
					_sExtend = ": gzAny";
				}
				

				//AddCppCode
				fAddCppLines(_oSClass.aCppLineListHeader);
				
				
				//pushLine("namespace " +  _oSClass.oSLib.sWriteName + "{namespace " +  _oSClass.sName  + "{");
				pushLine(_oSClass.sNamespace);
				getUnitDefinition(_oSClass); //TODO Only local
				pushLine(_oSClass.sEndNamespace);
			//	pushLine("}}");
				
			
				
				//Include class() //////////////////////////////////
			//	includeClass(_oSClass);
				/////////////////////////////
				
				listDlgConvertible(_oSClass);
				
				//ClassId
				pushLine(_oSClass.sNamespace);
			//	pushLine("extern gzUInt _nId;");
				
				//getGateList(_oSClass);
				getVarToConvert(_oSClass.aAtomicVarList, EuSharing.Public, true,false,EuConstant.Normal);
			
				//pushLine(_oSClass.sEndNamespace);
				
							//pushLine("class " + _oSClass.oSLib.sWriteName + "_"  + _oSClass.sName + _sExtend +" {");
				//pushLine("namespace " +  _oSClass.oSLib.sWriteName + "{");
				//pushLine("namespace " +  _oSClass.sName  + "{");
				addTab();
				addSpace();	
				
				listDelegateTypeDef(_oSClass);
				
				getUnitToConvert(_oSClass); //TODO Only local
				//getEnumDefinition(); Remove now in _ClassName.h
				addSpace();	
				//pushLine("//Static function");
				//getStaticFunctionToConvert(_oSClass);
				
				//Create unit function
				getUnitFunction(_oSClass);
				fAddCppLines(_oSClass.aCppLineListNamespace_H);
				
				subTab();
				pushLine("}");
				
				////////////////////////////
				///////// Pure Static //////
				////////////////////////////
				pushLine("class tApi_" + _oSClass.oSLib.sWriteName + " p" + _oSClass.sName + " {");
				addTab();
				addSpace();
				pushLine("public:");
			
				pushLine("//Pure Function");
				getPureFunctionToConvert(_oSClass);
				
				subTab();
				subTab();
				pushLine("};");
				
				addSpace();	
				///////////////////////////////
				
				
				
				
				if (_oSClass.bIsVector){
					/*
#define gzDef_Vec_(_Name, _nSize) \
typedef struct gzVec##_Name {  \
union{\
	gzFloat aTab[_nSize];\
	struct { gzFloat x, y, z, w;};\
	struct { gzFloat r, g, b, a; };\
	struct { gzFloat s, t, p, q; };\
};\
	gzDef_Vec_Func(_Name, _nSize) \
} gzVec##_Name;\
gzDef_Vec_Other(_Name, _nSize);
*/					
					var _sVecName : String = _oSClass.sName;
					var _sVecSize : UInt = 4;
					pushLine("template <class T>");
					pushLine("struct gzVec" + _sVecName + " {");
					pushLine("union{");
					pushLine("T aTab[" + _sVecSize + "];");
					
					var _bFirst = true;
					var _sVars : String = "";
					for (_oVar in  _oSClass.aGlobalVarList) {
						
						//if (_oVar.eType == EuVarType._Float){
							if (!_bFirst){
								_sVars += ", ";
							}_bFirst = false;
							
							_sVars += _oVar.fGetName() ;
						
							/*
						}else{
							Debug.fError("Vector require float type"); // TODO other type?
						}*/
					}

					pushLine("struct { T " + _sVars + "; };" );
					
					/////////
					pushLine("};");
					pushLine("gzDef_Vec_Func("+ _sVecName +", " +  _sVecSize +")");
					pushLine("};");
					//pushLine("} gzVec" + _sVecName +  ";");
					pushLine("gzDef_Vec_Other(" + _sVecName + ", " + _sVecSize + ");");
					
					pushLine("namespace " +  _oSClass.sName  + "{");
					pushLine("template<class T> inline gzVec" + _sVecName + "<T> New(gzVec" +  _oSClass.sName  + "<T> _oIni){return _oIni;};");
					
					pushLine(_oSClass.sEndNamespace);
					pushLine("#endif");
					return;
				}

				pushLine("class tApi_" + _oSClass.oSLib.sWriteName + " c" + _oSClass.sName + _sExtend +" {");
				
				addTab();
				addSpace();
				
				//Var list
				
				
				/////////////////////
				//Get only public ///
				/////////////////////
				pushLine("public:");
				addTab();
				addSpace();
				
				if(_oSClass.bIsPod){
					fAddPodExtends(_oSClass);
				}
				
				fAddCppLines(_oSClass.aCppLineListClass_H);
				
				//!!!!!!!!!!!!!!!!! Important keep same order as in the CPP backward heritage !!!!!!!!!!!!!!
				//Delegate
				getAllDelegateRef(_oSClass);
				
				//////////////////////
				//Get only static // 
				/////////////////////
				

				addSpace();
				pushLine("//Var");
				getVarToConvert_(_oSClass.aGlobalVarList, EuSharing.Public);
				
				/*
				//Static public var
				pushLine("//Static Var")
				aVarIdList = aCurrentClass[cClassStaticVarList];
				getVarToConvert(cPublic, true);
				*/
				
				//Get public function
				getFunctionToConvert(_oSClass, EuSharing.Public);
				
				
				//Default Copy func
				if(!_oSClass.bIsPod && !_oSClass.bIsResults){
					fDefaultCopyFunc(_oSClass);
				}
				//Destructeur
				//pushLine("virtual ~" + _oSClass.oSLib.sWriteName + "_"  + _oSClass.sName + "();")
				if(!_oSClass.bIsPod){
					pushLine("virtual ~c"  + _oSClass.sName + "();");
				}
				addSpace();
				


				//Create associateVar
				getAssociateVar(_oSClass);
				
				//!!!!!!!!!!!!!!!!! Important keep same order as in the CPP backward heritage !!!!!!!!!!!!!!
				
				pushLine("//Static singleton function");
				getStaticFunctionToConvert(_oSClass);
				
				subTab();
				//////////////////////
				//Get only private //
				/////////////////////
				pushLine("private:");
				addTab();
				addSpace();
				pushLine("//Var");
				getVarToConvert_(_oSClass.aGlobalVarList, EuSharing.Private);
		
				
				/*
				//Static public var
				pushLine("//Static Var")
				aVarIdList = aCurrentClass[cClassStaticVarList];
				getVarToConvert(cPrivate, true);
				*/
				
				//Get private function
				getFunctionToConvert(_oSClass, EuSharing.Private);
		
			
				
				subTab();
				subTab();
				subTab();
				pushLine("};");
				
				
				
				///////////////////////////////
				///////// Thread Static //////
				if (!_oSClass.bExtension && !_oSClass.oPackage.oSFrame.bSkipStatic &&  !_oSClass.bIsResults){
				//if (!_oSClass.oPackage.oSFrame.bSkipStatic){

					pushLine("class tApi_" + _oSClass.oSLib.sWriteName + " cs" + _oSClass.sName + getOverplaceString(_oSClass)  + "  {");
			
					addTab();
					addSpace();
					pushLine("public:");
					addTab();
					//AddCppCode
					fAddCppLines(_oSClass.aCppLineListStatic_H);
					
					
				//	pushLine("inline cs" + _oSClass.sName + "(Lib_GZ::Base::cClass* _parent):cStThread(_parent){};");
				//	pushLine("inline ~cs" + _oSClass.sName + "(){};");
					
					fCreateConstrutorWrapper(_oSClass);
					
					pushLine("//Public static"); //Only public
					getVarToConvert(_oSClass.aStaticVarList, EuSharing.Public, false, false,EuConstant.Normal);
					
					addSpace();
			//		pushLine("//Static function");
			//		getStaticFunctionToConvert(_oSClass);
					
					
					
					getVarToConvert(_oSClass.aStaticVarList, EuSharing.Private, false, false,EuConstant.Normal);
					
				//	pushLine("//Auto Singleton");
				//	pushLine("gzSp<" + "c" + _oSClass.sName  + "> zInst;");
					
					//subTab();
					if(_oSClass.bHaveOverplace == false){
					//	pushLine("inline cs" + _oSClass.sName +"(Lib_GZ::Base::cClass* _parent): Lib_GZ::cStThread(_parent), zInst(0) {};");
				//		pushLine("inline cs" + _oSClass.sName +"(Lib_GZ::Base::cClass* _parent): Lib_GZ::cStThread(_parent) {};");
						pushLine("inline cs" + _oSClass.sName +"(Lib_GZ::Base::Thread::cThread* _thread): Lib_GZ::Base::csClass(_thread) {};");
					}else {
						var _oSClassOp : SClass =  cast(_oSClass.aExtendClass[0]);
						//pushLine("inline cs" + _oSClass.sName +"(Lib_GZ::Base::cClass* _parent): " +   _oSClassOp.sNsAccess + "cs"  + _oSClassOp.sName  + "(_parent), zInst(0) {};");
						pushLine("inline cs" + _oSClass.sName +"(Lib_GZ::Base::Thread::cThread* _thread): " +   _oSClassOp.sNsAccess + "cs"  + _oSClassOp.sName  + "(_thread) {};");
					}
					pushLine("inline ~cs" + _oSClass.sName +"(){};");
					
					subTab();
					//pushLine("private:");
					subTab();
					pushLine("};");
					
					if(_oSClass.bHaveOverplace == false){
						pushLine("GZ_mStaticClass(" + _oSClass.sName + ")");
					}else {
						var _oSClassOp : SClass =  cast(_oSClass.aExtendClass[0]);
						pushLine("GZ_mStaticClassOp(" + _oSClass.sName + ", " + _oSClassOp.sNsAccess  + _oSClassOp.sName  + ");");
					}
				}

				/////////////////////////////
				/////////////////////////////
				
				
				
				pushLine("namespace " +  _oSClass.sName  + "{");
			//	fCreateConstrutorWrapper();
				fAddThreadFonction(_oSClass);
				fAddAtomicFonction(_oSClass);
				
				fAddCppLines(_oSClass.aCppLineListNamespace_End_H);
				pushLine(_oSClass.sEndNamespace);
				
				//pushLine("}")
				//pushLine("}")
				
				//if (_oSClass.bExtension) { //For extention
					pushLine("#undef tHDef_IN_" +  _oSClass.oPackage.sHeaderName);
				//}
				
				
		
				pushLine("#endif");
				/*
				if (bUseDefineIN) { //Resolve problem of recursive extented class linking
					pushLine("#endif");
				}*/
			}
		
		}
		//#ifndef tHDef_LibName_Example
		//#define tHDef_LibName_Example
		private function pushHeaderDefine(_oSPck:SPackage):Void {
			
			//pushLine("#pragma once");
			pushLine("#if !( defined tHDef_" +  _oSPck.sHeaderName + getClassExtendDefineAll(_oSPck) + ")"); //Resolve problem of recursive extented class linking !Very important!
			pushLine("#pragma once");
			
			//pushLine("#ifndef tHDef_" + _oSClass.oSLib.sName + "_" + _oSClass.sName);
			pushLine("#define tHDef_" +  _oSPck.sHeaderName);
			
			for (_oSClass in _oSPck.aClassList ){
			//if (_oSClass.bExtension) { //For extention --/// Always safe to keep it
				pushLine("#define tHDef_IN_" +  _oSPck.sHeaderName);
			//}
			}

		}
		
		
		private function getClassExtendDefineAll(_oSPck:SPackage):String {
			var _sResult: String = "";
			for (_oSClass in _oSPck.aClassList ){
				_sResult += getClassExtendDefine(_oSClass);
			}
			return _sResult;
		
		}
		private function getClassExtendDefine(_oSClass:SClass):String {
			var _oExtend : SClass;
			var _sIN_define : String = "";
			var _aList:Array<SClass> =  _oSClass.aExtendClass;
			var _i : UInt = _aList.length;
			for (i in 0 ...  _i) {
	
				_sIN_define += " || ";
				_oExtend = _aList[i];
				_sIN_define += "defined  tHDef_IN_" +  _oExtend.oPackage.sHeaderName ; 
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
			//pushLine("#include \"" + _oSClass.sPathBack +  oCppProject.sLibRelativePath + oCppProject.sCppMainHeader + "\"");
			//pushLine("#include \"" + _oSClass.sPathBack +   _oSClass.oSLib.sWriteName HCommonStructFile.sHeader + "\"");
			 var _sPath : String;
		
			
			//pushLine("#include \"" + _sPath +   oCppProject.sCppMainHeader + "\"");
			if (_oSClass.oSLib == oCppProject.oSProject.oCppLib) {
				_sPath = mFile.getRelativePath( _oSClass.oSLib.sWritePath + _oSClass.sPath, oCppProject.oSProject.oCppLib.sWritePath   , false);
				_sPath = _sPath.split("\\").join("/");  
				
				pushLine("#include \"" + _sPath +  "Main" + _oSClass.oSLib.sWriteName + ".h\"");
			}else {
		
				pushLine("#include \"" +  _oSClass.sPathBack  +  "Main" + _oSClass.oSLib.sWriteName + ".h\"");
			}

			//pushLine("#include \"" + _oSClass.sPathBack +  oCppProject.sCppMainHeader + "\"");
			//pushLine("#include \"" + _oSClass.sPathBack +  "Common" + _oSClass.oSLib.sWriteName + ".h\"");
		
			//if ( _oSClass.aExtendClass.length == 0) {
			//	pushLine("#include \"" + _sPath +  "Delegate.h"  + "\""); 
			//}
			
			
			//Debug
			//if(bConvertDebug){
			//	aCurrentConvert[nConvertLine] = "#include \"" +  aCurrentClass[cClassPathBack] + sLibCppRelativePath  + "Debug.h\"";
			//}
		}
		*/
		private function includeExtention(_oSClass:SClass):Void {
			
			var _aList : Array<Dynamic> = _oSClass.aExtendClass;
			var _i:UInt = _aList.length;
			for (i in 0 ..._i) {
				var _oExtend : SClass  = _aList[i];
				var _sPath : String = _oExtend.oPackage.sPath; 
				_sPath = _sPath.split("\\").join("/");  
				pushLine("#include \"" + _oExtend.oSLib.sWriteName + "/" + _sPath + _oExtend.sName + ".h\"");
			}
		}
		
		
		
		private function includeClass(_oSPck:SPackage):Void {
			
			 var _oImport : FileImport;
			 var _sPath : String;
			 var _sLib : String;
			 var _sName : String;
			 var _sClassPath : String = _oSPck.sPath;
			 var _sClassLib : String = _oSPck.oSLib.sWritePath;
			 
			 addSpace();
			var i:Int;
						
			var _i:UInt = _oSPck.aSImportList_Full.length;
			
			if (_i > 0) { 
				pushLine("//Optimised Class include -> direct class or header of header (Constants)");
			}
			//Normal class
			for ( i in 0 ... _i) {
				_oImport = 	_oSPck.aSImportList_Full[i];
				
				_sName = _oImport.sName;
	
					
				var _oCurrSPack : SPackage = _oImport.oRefPackage;
				//var _oCurrSClass : SClass = _oImport.oRefClass;
				
				if (_oSPck.aSImportListRequireFullDefinition[i] == true) {//For Embed var ... TODO
					 //Full definition required
					_sLib  = _oImport.oSLib.sWritePath;
					_sPath = _oImport.sPath; 
					_sPath =  _oImport.oSLib.sWriteName + "\\"+ _sPath;
					
					_sPath = _sPath.split("\\").join("/");  
					pushLine("#include \""   + _sPath + _sName + ".h\"");
					
				}else{
					

					if (  _oCurrSPack.fHaveConstant()) {
						
					//	_sLib  = _oImport.oSLib.sWritePath;	
						 //////////////// Have Lite _.h ////////////
						_sPath =  _oImport.oSLib.sWriteName + "\\"+ _oImport.sPath;
						_sPath = _sPath.split("\\").join("/");  
						
						pushLine("#include \""   + _sPath + "_" + _sName + ".h\"");
						
					}else { 
						////////////// Optimised //////////////////
						//_sLib  = _oImport.oSLib.sWriteName;
						//pushLine("class " + _sLib + "_" + _sName + ";" + listUnit(_oCurrSClass) );
						for (_oCurrSClass in _oCurrSPack.aClassList){
							var _sClassPrefix : String = "c";
							if (_oCurrSClass.bIsVector){
								_sClassPrefix = "gzVec";
							}
							
							if (_oCurrSClass.aUnitList.length != 0) {
								pushLine(_oCurrSClass.sCNamespace + "class "+ _sClassPrefix + _sName + "; namespace " + _sName + " {" + listUnit(_oCurrSClass) + "}" + _oCurrSClass.sCEndNamespace);
							}else {
								pushLine(_oCurrSClass.sCNamespace + "class "+ _sClassPrefix + _sName + ";" + _oCurrSClass.sCEndNamespace );
							}
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
		
		private function getEnumDefinition(_oSClass:SClass):Void {
			
			var _sLine : String = "";
			
			addSpace();
			pushLine("//Enum");
			var _aEnumList:Array<Dynamic> = _oSClass.aEnumList;
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
		
		
		private function getUnitDefinition(_oSClass:SClass):Void {
			
			var _sLine : String = "";
			
			addSpace();
			pushLine("//Structure Definition");
			var _aUnitList:Array<Dynamic> = _oSClass.aUnitList;
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
		
		/*
		private function listUnitPck(_oSPackage : SPackage):String {
			for (_oSClass in _oSPackage.aClassList){
				listUnit(_oSClass);
			}
		
		}*/
		
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
		
				
		private function getUnitToConvert(_oSClass:SClass):Void {

			addSpace();
			pushLine("//Structure Implementation");
			var _aUnitList:Array<Dynamic> = _oSClass.aUnitList;
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
		
		
		public function listDlgConvertible(_oSClass:SClass):Void {
			var _aList: Array<Dynamic> = _oSClass.aDelegateUniqueList;
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
		public function listDelegateTypeDef(_oSClass:SClass):Void {
			var _aList: Array<Dynamic> = _oSClass.aDelegateUniqueList;
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
				pushLine("GZ_mDlgIni(" + _sReturn + ", GZ_PARAM" + _sParamDlgIni + "){printf(\" (Not set) \"); return " + _sDefaultReturn + ";};");
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
		
	
		
		public function fCreateConstrutorWrapper(_oSClass:SClass):Void {
			
			if (_oSClass.bIsVector || _oSClass.bIsResults ){ //Not for vector
				return;
			}
			
			if( !_oSClass.bThread && _oSClass.aFunctionList.length > 0 ){ //_oSClass.aFunctionList.length > 0 useless?
				var _sLoc : String =  "c" + _oSClass.sName;
				var _sLocOp : String = _sLoc;
				var _sStatLoc : String =  "cs" + _oSClass.sName;
				
				//Get the lowest level of overplace, for multiple op
				if (_oSClass.bHaveOverplace) {
					var _oSClassOp : SClass = cast(_oSClass.aExtendClass[0]);
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
			//	pushLine("inline " + _sStatLoc  + "(Lib_GZE::cClass* _parent): " + _oSClass.oExtend._oSClass.sNsAccess  + "(_parent){};");

				pushLine("//Object Creation Wrapper");
			//	pushLine("#ifndef tNew_" + _oSClass.sHeaderName);
				//var _sLoc : String =  _oSClass.oSLib.sWriteName + "::c" + _oSClass.sName;
		
				if (_oSClass.oFuncConstructor == null ) {
					Debug.fError("No constructor in : " + _oSClass.sName);
				}
				
				if (_oSClass.bIsPod) {
					/*
					pushLine("inline virtual gzPod<" + _sLocOp  + "> New(Lib_GZ::Base::cClass* _parent"  + getFunctionParam( _oSClass.oFuncConstructor , true, false, false) + "){" );
					//	pushLine("inline virtual gzPod<" + _sLocOp  + "> New("  + getFunctionParam( _oSClass.oFuncConstructor , true, false, true) + "){" );
					addTab();
					pushLine("gzPod<" + _sLoc  + ">_oTemp = gzPod<" + _sLoc + ">(" + _sLoc + "());");
					pushLine("_oTemp->Ini_c" +  _oSClass.sName + "(" + getFunctionParam(_oSClass.oFuncConstructor , false, true)  + ");");
					pushLine("return _oTemp;");
					subTab();
					pushLine("}");
					*/
				}else{
					
					var _sVirtual : String  = "";
					if (_oSClass.bHaveOverplace || _oSClass.bOverclass) {
						_sVirtual = "virtual ";
					}
					
					pushLine("inline " + _sVirtual + "gzSp<" + _sLocOp  + "> New(Lib_GZ::Base::cClass* _parent"  + getFunctionParam( _oSClass.oFuncConstructor , true, false, false) + "){" );
					addTab();
					pushLine("gzSp<" + _sLoc  + ">_oTemp = gzSp<" + _sLoc + ">(new " + _sLoc + "(_parent));");
					//pushLine("_oTemp->Ini_c" +  _oSClass.sName + "(" + getFunctionParam(_oSClass.oFuncConstructor , false, true)  + ");");
					pushLine("_oTemp->" + Setting.sConstructorKeyword + "(" + getFunctionParam(_oSClass.oFuncConstructor , false, true)  + ");");
					if (_oSClass.bHaveOverplace) {
						pushLine("return _oTemp.get();");//
					}else{
						pushLine("return _oTemp;");//
					}
					
					subTab();
					pushLine("}");
				//	pushLine("#endif");
				
				//	pushLine("//Auto Singleton");
				//	pushLine("gzSp<" + _sLocOp  + "> zInst;");
					/*
					pushLine("inline gzSp<" + _sLocOp  + "> NewSingleton(" + getFunctionParam( _oSClass.oFuncConstructor , true, false, true) + "){" );
					addTab();
					pushLine("zInst = New(parent" + getFunctionParam(_oSClass.oFuncConstructor , false, true, false)  + ");");
					pushLine("return zInst;");
					subTab();
					pushLine("}");*/
					
					addSpace();
				}
			}
			
		}
		
		public function fAddThreadFonction(_oSClass:SClass):Void {
			if( _oSClass.bThread ){
				//pushLine("GZ_mNewThreadH(" + _oSClass.oSLib.sWriteName  +  ", " +  _oSClass.sName + ");");
				pushLine("GZ_mNewThreadH();");
			}
		}
		
			
		public function fAddAtomicFonction(_oSClass:SClass):Void {
			for( _oFunc  in _oSClass.aAtomicFunc) {//VarGat
					fConvertAtomicFunction(_oFunc);
			}
		}
		
		public function fConvertAtomicFunction(_oFunc:SFunction){
			pushLine("//Atomic function");
			var _sExtend : String  = ": public Lib_GZ::Base::Thread::cThreadMsg";
			pushLine("class tApi_" + _oFunc.oSClass.oSLib.sWriteName + " c" + _oFunc.sName + _sExtend +" {");
				addTab();
				pushLine("private:");
				addTab();
				for( _oParam  in _oFunc.aParamList) {//VarGat
				    pushLine(TypeText.typeToCPP(_oParam, false,false,false,false,false,true) + " "  + _oParam.fGetName() + ";");
				}
				pushLine("public:");
				//With Parent:
				// pushLine("inline " + " c" + _oFunc.sName + "(Lib_GZ::Base::cClass* _parent " + getFunctionParam(_oFunc, true, false, false) + "): Lib_GZ::Base::Thread::cThreadMsg(_parent)");
				//Without Parent:
				pushLine("inline " + " c" + _oFunc.sName + "(" + getFunctionParam(_oFunc, true) + "): Lib_GZ::Base::Thread::cThreadMsg()");
				
				 var _sIni : String = "";
				 var _aParam : Array<VarObj> = _oFunc.aParamList;

				for (_oParam in _aParam) {
					var _sName : String = _oParam.fGetName();
					var _sAdd : String = "";
					if (_oParam.eType == EuVarType._CallClass && !cast(_oParam, VarCallClass).oCallRef.bIsVector ){
						_sAdd += "->Copy(true)";
						//_sAdd += "*";
					}
					_sIni +=  ", " + _sName + "("  + _sName + _sAdd +   ")";
				}
				pushLine(_sIni);
				 pushLine("{};"); 
				 
				 pushLine("inline virtual void fRun(){");
				  pushLine("((" + "c" + _oFunc.oSClass.sName + "*)parent)->" + _oFunc.sName + "(" +  getFunctionParam(_oFunc, false, true)+ ");");
				 pushLine("};");
				 
				subTab();
				subTab();
				pushLine("};");
				
			
		}
		
		
		public function getGateList(_oSClass : SClass) :Void { 
			for( _oGate  in _oSClass.aGateVarList) {//VarGate
				pushLine("extern gzGate<Void*> " + _oGate.sName + ";"); 
			}
		}

		
		public function fDefaultCopyFunc(_oSClass : SClass) :Void {
			
		//	pushLine("#define Cpy_" + _oSClass.sHeaderName  + " "  + getExtendClassToString(_oSClass, "(_o)") + fCopyAllVar(_oSClass);
		//	pushLine("#define DCpy_" + _oSClass.sHeaderName  + " "  + getExtendClassToString(_oSClass, "(_o)") + fCopyAllVar(_oSClass, true);
			
		//	pushLine("inline c" + _oSClass.sName + "(var c" + _oSClass.sName + " &_o)" + " : " + Cpy_" + _oSClass.sHeaderName + "{};" );
		//	pushLine("inline c" + _oSClass.sName + "(var c" + _oSClass.sName + " &_o, gzBool _b)" + " : "+ getExtendClassToString(_oSClass,"(_o, _b)") + fCopyAllVar(_oSClass, true)  + "{};" ); 
			var _sInitialiserList : String = getExtendClassToString(_oSClass, "(_o)") + fCopyAllVar(_oSClass,true);
			if (_sInitialiserList == " : "){ //minimal = " : "
				_sInitialiserList = "";
			}
			
			pushLine("inline c" + _oSClass.sName + "(const c" + _oSClass.sName + "& _o, gzBool _bDCpy = false)" +  _sInitialiserList  + "{" );
			pushLine("printf(\"\\nCopy" + _oSClass.sName  +"\");");
				pushLine("};" ); 
	
			//pushLine("inline c" + _oSClass.sName + "(var c" + _oSClass.sName + " &_o, gzBool _b)" + getExtendClassToString(_oSClass,"(_o, _b)") + fCopyAllVar(_oSClass, true)  + "{};" ); 
			
			
			//pushLine("inline Void iniCpy(const c" + _oSClass.sName + " &_o){" +    + "};" ); 
			
			
			
			
			
			//TODO copy
		//!!/pushLine("inline c" + _oSClass.sName + "(const c" + _oSClass.sName + " &_o) " +  getAllExtendClassToString(_oSClass,"(_o)") + fCopyAllVar(_oSClass)  + "{};" ); 



			//DeepCopy not sure??
		//			pushLine("inline c" + _oSClass.sName + "(const c" + _oSClass.sName + " &_o, gzBool _b) " + getAllExtendClassToString(_oSClass,"(_o, _b)") + fCopyAllVar(_oSClass, true)  + "{};" ); 
			
			
			
			//if(!_oSClass.bExtension && !_oSClass.bIsPod){
				pushLine("virtual gzClass Copy(gzBool _bDeepCopy = false){return new c" + _oSClass.sName  + "(*this, _bDeepCopy);};"); //gzSp?
				//pushLine("virtual gzAny MemCopy();"); 
			//	pushLine("virtual gzAny DeepCopy();");
			//}
		}
		
		
		
		public function fCopyAllVar(_oSClass : SClass, _bDeepCopy : Bool = false) :String {
			var _sCopy : String = "";
			for ( _oVar in _oSClass.aGlobalVarList) {//CommonVar
				var _sSetTo : String = "";
				//TODO delegate are illegal + _QElement / _DArray are empty
				//if (_oVar.bEmbed || TypeResolve.isTypeCommon( _oVar.eType) ||  _oVar.eType == EuVarType._String || _oVar.eType == EuVarType._Gate ) { //Is a base type? Then copy
				if (   _oVar.eType != EuVarType._DArray    &&  _oVar.eType != EuVarType._QueueArray 
					&& _oVar.eType != EuVarType._QElement  &&  _oVar.eType != EuVarType._PtrFunc
					&& !( _oVar.eType == EuVarType._CallClass && !cast(_oVar, VarCallClass).oCallRef.bIsVector)
					&&  _oVar.eType != EuVarType._Any
				){
					_sSetTo = "_o." + _oVar.sName;
					if (_bDeepCopy && _oVar.eType == EuVarType._String) {
						_sSetTo += ",_bDCpy";
					}	
					_sCopy += ", " + _oVar.sName + "(" + _sSetTo + ")";
				}
			
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
			if (!_oSClass.bIsPod) { //Error if not found before
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
