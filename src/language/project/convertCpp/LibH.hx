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
	
	 
	class LibH extends FileForm
	{
		var oLib : SLib;
	
		public function new(_Main:Root, _oSLib : SLib) { 
	
			super(_Main);
			oLib = _oSLib;
			convertClass();
		}
		
		private function convertClass():Void {
			
			pushLine("#ifndef tHDef_" +  oLib.sWriteName);
			pushLine("#define tHDef_" +  oLib.sWriteName);
		//	pushLine("#include \"Lib_GZ/GZ.h\""); Recursive inlcude
			addSpace();
			pushLine("#ifdef tLibExport_" +  oLib.sWriteName);
			pushLine("	#define tApi_" +  oLib.sWriteName  + " __declspec(dllexport)");
			pushLine("#elif tLibImport_" +  oLib.sWriteName);
			pushLine("	#define tApi_" +  oLib.sWriteName  + " __declspec(dllimport)");
			pushLine("#else");
			pushLine("	 #define tApi_" +  oLib.sWriteName);
			pushLine("#endif"); 
			addSpace();
			
	
			//pushLine("namespace Lib_GZ{class uOverplace;}"); 
			//pushLine("#include \"Lib_GZ/GzTypes.h\""); 
			pushLine("#include \"Lib_GZ/GzOverplace.h\""); 
			pushLine("#include \"Lib_GZ/Macro.h\""); 
			pushLine("GZ_mHLib(" + oLib.sWriteName  + ")");
			pushLine("#endif"); 
			
		}
		
		
		
	}
