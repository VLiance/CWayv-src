package language.project.convertCpp ;


	import language.pck.FileImport;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuSharing;
	import language.enumeration.EuVarType;
	import language.MyFile;
	import language.pck.SLib;
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
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	import language.vars.varObj.VarString;
	import language.base.Root;
	/**
	 * ...
	 * @author ...
	 */
	
	 
	class LibIni extends FileForm
	{
		var oLib : SLib;
		var nCheckSum : UInt;
	
		public function new(_Main:Root, _oSLib : SLib) { 
	
			super(_Main);
			oLib = _oSLib;
			convertClass();
		}
		
			

		
		
		public function convertClass():Void {
			nCheckSum = 0;
			
		//	pushLine("//GroundZero Engine Demo File -- An example to show the capabilities of GZE, modify this file as you like --");
			pushLine("#include \"" + oLib.sWriteName + "/" + oLib.sWriteName + ".h\"");
			
		
			for (_oPckg in oLib.aPackage) {for (_oSClass in  _oPckg.aClassList) {
				if(!_oSClass.bIsResults && !_oSClass.bIsVector && !_oSClass.bIsPod && !_oSClass.bExtension  && !_oSClass.bThread  && !_oPckg.oSFrame.bWrapper){
					pushLine("#include \"" + _oSClass.oPackage.sFilePath + ".h\"");
				}
			}}
			
			//pushLine("class uLib;");//Temp?
			pushLine("extern \"C\" Lib_GZ::uLib* IniLib_" +  oLib.sWriteName  +"(){");
			
			pushLine("if(" +  oLib.sWriteName + "::rLastClass == 0){ //If not Already initialised");
		//	pushLine(oLib.sWriteName + "::rLastClass = 0; //Reset class list");//Reset list
  			
		//	pushLine(oLib.sWriteName + "::zpLib = " +  oLib.sWriteName  +"::NewLib();");
			
			for (_oPckg in oLib.aPackage) {for (_oSClass in  _oPckg.aClassList) {
				//pushLine("//" + _oSClass.sNsAccess + _oSClass.sName + "::AddClass();" );
				if(!_oSClass.bIsResults && !_oSClass.bIsVector && !_oSClass.bIsPod && !_oSClass.bExtension  && !_oSClass.bThread  && !_oPckg.oSFrame.bWrapper){
					pushLine(_oSClass.sNsAccess + _oSClass.sName + "::AddClass();" );
				}
			}}
			
			pushLine("}");
		
			pushLine("GZ_mCppSetLib(" + oLib.sWriteName +");");
			//pushLine("return Lib_GZ::fSetLib(&"+   oLib.sWriteName + "::zpLib)"  + ";");
			pushLine("return (&"+   oLib.sWriteName + "::zpLib)"  + ";");
			
			pushLine("}");
			
			
			//Get all others full lib
			pushLine("//DynamicLoad");
			for ( _oOther in oLib.oSProject.aLibList){_oOther.bProcessDynamicLoad = false; } //Be sur to have it disabled
			for ( _oOther in oLib.oSProject.aLibList){
				if (_oOther != oLib){
					if (_oOther.oParentLib != null){
						fCreateDynamicLinking(_oOther.oParentLib );
					}else{
						fCreateDynamicLinking(_oOther);
					}
				}
			}
		}
		
		
		public function fCreateDynamicLinking(_oLib: SLib ):Void {
			if (!_oLib.bProcessDynamicLoad ){ //Don't do it twice
				_oLib.bProcessDynamicLoad = true;
				pushLine("//Lib: " +  _oLib.sWriteName);
				pushLine("#ifdef D_RunTimeLink_" +  _oLib.sWriteName);
				addTab();
				for (_oPckg in _oLib.aPackage) {for (_oSClass in  _oPckg.aClassList) {
					
					pushLine(_oSClass.sNamespace + "gzPtrFuncRPAny Func_Get;" +  _oSClass.sEndNamespace);
					
					
				}}
				subTab();
				
				
				
				if (_oLib.sIdName == "GZ" ){
					pushLine("//Special Ini: " +  _oLib.sWriteName);
					pushLine("//TODO associate!!: " +  _oLib.sWriteName);
					pushLine("namespace Lib_GZ{namespace Lib {");
					pushLine("gzPtrFuncRBoolPAny fAllClass;");
					pushLine("gzPtrFuncRPAny fRegisterLib;");
					pushLine("}}");
					
					pushLine("//Only for Test");
					pushLine("namespace Lib_GZ{namespace EntryPoint {");
					pushLine("gzInt (*Func_Constructor_)(cEntryPoint*) = 0;//TODO");
					pushLine("}}");
					
					
				}
				
				
				//`Lib_GZ::Debug::Debug::Func_Get'
				pushLine("#endif");
				
				
				
			}	
		}

		
	}
