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
	
		public function new(_Main:Root, _oSLib : SLib) { 
	
			super(_Main);
			oLib = _oSLib;
			convertClass();
		}
		
		private function convertClass():Void {
			
		//	pushLine("//GroundZero Engine Demo File -- An example to show the capabilities of GZE, modify this file as you like --");
			pushLine("#include \"" + oLib.sWriteName + "/" + oLib.sWriteName + ".h\"");
			
			for( _oSClass in oLib.aClass ) {//SClass
				pushLine("#include \"" + _oSClass.sFilePath + ".h\"");
			}
			
			pushLine("extern \"C\" Int IniLib_" +  oLib.sWriteName  +"(){");
			
			pushLine("if(" +  oLib.sWriteName + "::rLastClass != 0){return 0;}");
  			
		//	pushLine(oLib.sWriteName + "::zpLib = " +  oLib.sWriteName  +"::NewLib();");
			
			for( _oSClass in oLib.aClass ) {//SClass
				pushLine( _oSClass.sNsAccess + _oSClass.sName + "::NewClass();" );
			}
			pushLine("return 1;");
			pushLine("}");
		}
		
		
		
	}
