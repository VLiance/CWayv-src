package language.project.convertCpp ;
	import language.pck.FileImport;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuSharing;
	import language.enumeration.EuVarType;
	import language.MyFile;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.project.CppProject;
	import language.Text;
	import language.project.convertSima.SPackage;
	import language.vars.special.EnumObj;
	import language.vars.special.UnitObj;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.EaseOut;
	import language.vars.varObj.LineObj;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.VarObj;
	import language.base.Root;
	import language.base.Debug;
	/**
	 * ...
	 * @author ...
	 */
	class GpuFunctions extends HeaderFile
	{

	//	private var bUseDefineIN : Bool = false;
		
		public function new(_Main:Root, _oCppProject : CppProject, _oSPckg: SPackage) { 
	
			super(_Main,_oCppProject, _oSPckg);
			
			
						//		pushLine( "#warning aaaaaa");
			pushLine( "#ifndef tHDEFgen_" +  _oSPckg.oSLib.sWriteName);
			pushLine( "#define tHDEFgen_" +  _oSPckg.oSLib.sWriteName);
			//	pushHeaderDefine(_oSPckg); //TODO ? With tHDEFgen_?
				
							//	pushLine( "#warning bb");
				
			pushLine(fAddLicence());
		
		
			pushLine( "namespace " + _oSPckg.oSLib.sWriteName + "{class c"  + _oSPckg.sName +";}" );
	
			
			
						

			
			pushLine("#include \"Lib_GZ/GZ_inc.h\"");
			
			pushLine("#ifdef D_Platform_Windows");
			pushLine("#ifndef D_Platform_CpcDos");
			pushLine("#include \"Lib_GzOpenGL_Windows/GlWin.h\"");
			pushLine("#endif");
			pushLine("#endif");
			
			pushLine("#include \"Lib_GZ/Debug/Debug.h\"");
			
			
			for(_oSClass in _oSPckg.aClassList){
				convertGpuFunctions(_oSClass);
			}
			//convertHeader();already called in extended
			
			
			//pushLine( "#endif");
		}
		
		
		private function convertGpuFunctions(_oSClass:SClass):Void {
		
			//Header must be converrt first
	
		


				/*
			
			pushLine("#include \"Lib_GZ/Base/GzTypes.h\"");
			pushLine("#include \"Lib_GZ/System.h\"");
	
				*/
	
				
		//	pushLine( "namespace " + _oSClass.oSLib.sWriteName + " {namespace "  + _oSClass.sName +"{" );
			pushLine( "namespace " + _oSClass.oSLib.sWriteName + " {namespace SysGpuFunc"  +"{" ); //Temp
			pushLine("void* fGetFuncGL(const char *_cName, gzBool _bRequired = true);");
			pushLine("gzBool fGetGpuFunctions();");
			pushLine( "}}");

			//addTab();
			addSpace();	
		
			pushLine("#if !( defined D_Platform_Web_Emsc ||  defined D_Platform_Android ||  defined D_Platform_CpcDos  ||  defined D_Platform_Lite  ) ");
				pushLine("#define GL_fGetError glCall_fGetError");
				pushLine("typedef gzUInt (APIENTRY* FUNC_fGetError)();");
				pushLine("extern FUNC_fGetError glCall_fGetError;");
			pushLine("#else");
				//pushLine("#define GL_fGetError "); //TODO
			pushLine("#endif");
				
			addSpace();	
			

			
			pushLine("#if !( defined D_Platform_Web_Emsc ||  defined D_Platform_Android  ||  defined D_Platform_CpcDos  ||  defined D_Platform_Lite  ) ");
			gpuFunctionToConvert(_oSClass);
			pushLine("#endif");
					
			pushLine("#ifdef D_Platform_Web_Emsc");
			gpuWebFunctionToConvert(_oSClass);
			pushLine("#endif");
			
			//TODO THIS is platform with no OGL support -> use a define for that
			pushLine("#if (defined D_Platform_CpcDos ||  defined D_Platform_Lite ) ");
			//pushLine("#ifdef GZ_tCpcDos");
		//	pushLine("gzBool gzN(bool _bVal){return false;};");
		//	pushLine("gzUInt gzN(gzUInt _bVal){return 0;};");
		//	pushLine("gzInt gzN(gzInt _bVal){return 0;};");
		//	pushLine("gzFloat gzN(gzFloat _bVal){return 0.0;};");
		
		///	pushLine("#inl fGetGpuFunctions() false");
			gpuEmptyFunctionToConvert(_oSClass);
			pushLine("#endif");
			
			//TODO Other are  platform with default OGL function -> use a define for that
			pushLine("#if (defined D_Platform_Android ) ");
			gpuStandardFunctionToConvert(_oSClass);
			pushLine("#endif");
			
			
			
			
			
			//subTab();
	
			
			pushLine("#endif");
		

		}
		
		
		

		
		
		
		//#ifndef tHDef_LibName_Example
		//#define tHDef_LibName_Example
		override function pushHeaderDefine(_oSPck:SPackage):Void {

			pushLine("#ifndef tHDef_Generate_OpenGL_" + _oSPck.oSLib.sWriteName + "_" + _oSPck.sName); //Resolve problem of recursive extented class linking !Very important!
			
			//pushLine("#ifndef tHDef_" + _oSClass.oSLib.sName + "_" + _oSClass.sName);
			pushLine("#define tHDef_Generate_OpenGL_" +  _oSPck.oSLib.sWriteName + "_" + _oSPck.sName);
		}
		

		private function gpuFunctionToConvert(_oSClass:SClass):Void {
					
		
			
			var _aFunction : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt = _aFunction.length;
			
			
			///Both
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function

				//if (_oSFunction.bSpecialGenerate &&  _oSFunction.bStatic && _oSFunction.sName != "fGetError"){
				if (_oSFunction.bSpecialGenerate  && _oSFunction.sName != "fGetError"){
					gpuConvertFunctionHeader(_oSClass, _oSFunction);
				}
			}
			
			pushLine("#ifdef D_Debug");
			addTab();
			///Release
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function

				//if (_oSFunction.bSpecialGenerate &&  _oSFunction.bStatic && _oSFunction.sName != "fGetError"){
				if (_oSFunction.bSpecialGenerate  && _oSFunction.sName != "fGetError"){
					gpuConvertFunctionHeaderDebug(_oSClass, _oSFunction);
				}
			}
			subTab();
			pushLine("#else");
			addTab();
			///Debug
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function

				//if (_oSFunction.bSpecialGenerate &&  _oSFunction.bStatic && _oSFunction.sName != "fGetError"){
				if (_oSFunction.bSpecialGenerate  && _oSFunction.sName != "fGetError"){
					gpuConvertFunctionHeaderRelease(_oSClass, _oSFunction);
				}
			}
			subTab();
			pushLine("#endif");
		
			
			
			
			
			addSpace();
		}
		
		private function gpuWebFunctionToConvert(_oSClass:SClass):Void {
		
			var _aFunction : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt = _aFunction.length;
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function
			//	if(_oSFunction.bSpecialGenerate &&  _oSFunction.bStatic && _oSFunction.sName != "fGetError"){
				if(_oSFunction.bSpecialGenerate && _oSFunction.sName != "fGetError"){
					gpuConvertWebFunctionHeader(_oSClass, _oSFunction);
				}
			}
			
			addSpace();
		}
		


		private function gpuConvertFunctionHeader(_oSClass:SClass, _oSFunction:SFunction):Void {
	
			var _sReturn : String;
			var _sFuncNameFunc : String = "FUNC_" + _oSFunction.sName;
			var _sFuncNameGL : String = "glCall_" + _oSFunction.sName;
			var _sFuncNameDbg : String = "glDbg_" + _oSFunction.sName;
			var _sFuncNameUSE : String = "GL_" + _oSFunction.sName;
			var _sLib : String = _oSClass.oSLib.sWriteName;
	
			//Return
			if (_oSFunction.bConstructor) {
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
			if (_oSClass.bExtension  && !_oSFunction.bConstructor  ) { // _nFuncId != 0  
				_sReturn = "virtual " + _sReturn;
			}
			

			//Param
			var _sParam : String = CommonCpp.getFunctionParam(_oSFunction, false,false,true,false, true);

			//Normal push
			//pushLine("#define " + _sFuncNameUSE + " " + _sFuncNameGL);
			var _sCallParam1 : String = CommonCpp.getFunctionParam(_oSFunction, false, true, true,false, true);
			var _sCallParam2 : String = _sCallParam1;
			if (_sCallParam2 != "") {
				_sCallParam2 = ", " + _sCallParam2;
			}
			
			//pushLine("#define " + _sFuncNameUSE + "(" + _sCallParam1 + ") " + _sFuncNameDbg + "(thread," + _sCallParam2 + "__FILE__, __LINE__)");
			//pushLine("#define " + _sFuncNameUSE + "(" + _sCallParam1 + ") " + _sFuncNameDbg + "(thread," + _sCallParam2 + "_cFile, _nLine)");
			//pushLine("#define " + _sFuncNameUSE + "(" + _sCallParam1 + ") " + _sFuncNameDbg + "(thread" + _sCallParam2 + " GZ_DbgParam)");
			pushLine("typedef " + _sReturn +  "(APIENTRY* " + _sFuncNameFunc + ")(" + _sParam + ");");
			pushLine("extern " +   _sFuncNameFunc + " " + _sFuncNameGL + ";");
			//if (_sParam != "") {
			//	_sParam = ", " + _sParam;
			//}
			
			
			//pushLine( _sReturn + " " + _sFuncNameDbg +  "(Lib_GZ::Base::Thread::cThread* thread" + _sParam + " GZ_DbgArg);");
			//pushLine( _sReturn + " " + _sFuncNameDbg +  "(Lib_GZ::Base::Thread::cThread* thread," + _sParam + "const char* _cFile , gzUInt _nLine);");
			addSpace();
			
		}
		
		private function gpuConvertFunctionHeaderRelease(_oSClass:SClass, _oSFunction:SFunction):Void {
			var _sFuncNameGL : String = "glCall_" + _oSFunction.sName;
			var _sFuncNameUSE : String = "GL_" + _oSFunction.sName;
			
			pushLine("#define " + _sFuncNameUSE + " " + _sFuncNameGL);
		}
		private function gpuConvertFunctionHeaderStandard(_oSClass:SClass, _oSFunction:SFunction):Void {
			
			var _sFuncNameGL : String = "gl" + _oSFunction.sName.substring(1);
			var _sFuncNameUSE : String = "GL_" + _oSFunction.sName;
			
			
			var _sParam : String = CommonCpp.getFunctionParam(_oSFunction, false, false, true, false, true);
			var _sReturn  : String = TypeText.typeToCPP(_oSFunction.oReturn, true) + " "; //TODO
			
			pushLine("GL_APICALL " + _sReturn + _sFuncNameGL + "(" + _sParam + ");");
			
			
			pushLine("#define " + _sFuncNameUSE + " " + _sFuncNameGL);
			
			

		}
		
		
		private function gpuConvertFunctionHeaderDebug(_oSClass:SClass, _oSFunction:SFunction):Void {
	
			var _sReturn : String;
			var _sFuncNameFunc : String = "FUNC_" + _oSFunction.sName;
			var _sFuncNameGL : String = "glCall_" + _oSFunction.sName;
			var _sFuncNameDbg : String = "glDbg_" + _oSFunction.sName;
			var _sFuncNameUSE : String = "GL_" + _oSFunction.sName;
			var _sLib : String = _oSClass.oSLib.sWriteName;
	
			//Return
			if (_oSFunction.bConstructor) {
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
			if (_oSClass.bExtension  && !_oSFunction.bConstructor  ) { // _nFuncId != 0  
				_sReturn = "virtual " + _sReturn;
			}
			

			//Param
			var _sParam : String = CommonCpp.getFunctionParam(_oSFunction, false,false,true,false, true);

			//Normal push
			//pushLine("#define " + _sFuncNameUSE + " " + _sFuncNameGL);
			var _sCallParam1 : String = CommonCpp.getFunctionParam(_oSFunction, false, true, true,false, true);
			var _sCallParam2 : String = _sCallParam1;
			if (_sCallParam2 != "") {
				_sCallParam2 = ", " + _sCallParam2;
			}
			
			//pushLine("#define " + _sFuncNameUSE + "(" + _sCallParam1 + ") " + _sFuncNameDbg + "(thread," + _sCallParam2 + "__FILE__, __LINE__)");
			//pushLine("#define " + _sFuncNameUSE + "(" + _sCallParam1 + ") " + _sFuncNameDbg + "(thread," + _sCallParam2 + "_cFile, _nLine)");
			pushLine("#define " + _sFuncNameUSE + "(" + _sCallParam1 + ") " + _sFuncNameDbg + "(thread" + _sCallParam2 + " GZ_DbgParam)");
			//pushLine("typedef " + _sReturn +  "(APIENTRY* " + _sFuncNameFunc + ")(" + _sParam + ");");
			//pushLine("extern " +   _sFuncNameFunc + " " + _sFuncNameGL + ";");
			if (_sParam != "") {
				_sParam = ", " + _sParam;
			}
			
			
			pushLine( _sReturn + " " + _sFuncNameDbg +  "(Lib_GZ::Base::Thread::cThread* thread" + _sParam + " GZ_DbgArg);");
			//pushLine( _sReturn + " " + _sFuncNameDbg +  "(Lib_GZ::Base::Thread::cThread* thread," + _sParam + "const char* _cFile , gzUInt _nLine);");
			addSpace();
			
		}
		
		
		
		
		private function gpuConvertWebFunctionHeader(_oSClass:SClass, _oSFunction:SFunction):Void {
	
			var _sFuncNameFunc : String = "FUNC_" + _oSFunction.sName;
			var _sFuncNameGL : String = "glCall_" + _oSFunction.sName;
			

			
			var _sFuncNameUSE : String = "GL_" + _oSFunction.sName;
			var _sLib : String = _oSClass.oSLib.sWriteName;
	
			//Param
			var _sParam : String = CommonCpp.getFunctionParam(_oSFunction, false);

			//Normal push
			var _sCallParam1 : String = CommonCpp.getFunctionParam(_oSFunction, false, true, true, false, true );
			var _sCallParam2 : String = CommonCpp.getFunctionParam(_oSFunction, false, true, false, true, true);
			//var _sCallParam2 : String = _sCallParam1;
			
			/*
			if (_sCallParam2 != "") {
				_sCallParam2 = ", " + _sCallParam2;
				_sCallParam2 = _sCallParam2.split(",").join("), val(");
				_sCallParam2 = _sCallParam2.substring(1) + ")";
			}*/
	
			
			
			var _sReturn : String = "";
			_sReturn = TypeText.typeToCPP(_oSFunction.oReturn, true) + " "; //TODO
			//Remap return
			switch(_oSFunction.oReturn.eType) {

				case EuVarType._Void:
					_sReturn = "void";
				//break;
				
				case EuVarType._Bool:
					_sReturn = "bool";
				//break;
				
				case EuVarType._UInt:
					_sReturn = "unsigned int";
				//break;
				case EuVarType._Int:
					_sReturn ="int";
				//break;
					
				case EuVarType._Float: //double
					_sReturn = "float";	
				//break;
				
				case EuVarType._String: //double
					_sReturn = "std::string";	
				//break;
				
				case EuVarType._Val:
					_sReturn = "val";
				//break;
				
				default:
					_sReturn = "val";
				//break;
			}
			
			var _sFirstLetter : String  =  _oSFunction.sName.charAt(1);
			_sFirstLetter = _sFirstLetter.toLowerCase();
			var _sName : String =  _oSFunction.sName.substring(2); //Remove f letter
			_sName = _sFirstLetter + _sName;
			
			var _sFuncNameDbg : String = "oGL.call<" + _sReturn + ">(\"" +_sName + "\"";
			
			pushLine("#define " + _sFuncNameUSE + "(" + _sCallParam1 + ") " + _sFuncNameDbg  + _sCallParam2 + ")");
			
		}
		
		
		
		private function gpuStandardFunctionToConvert(_oSClass:SClass):Void {
		
			var _aFunction : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt = _aFunction.length;
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function
				//if(_oSFunction.bSpecialGenerate &&  _oSFunction.bStatic && _oSFunction.sName != "fGetError"){
				if (_oSFunction.bSpecifiquePlatforme){
					gpuEmptyFunctionToConvertHeader(_oSClass, _oSFunction); //TODO Only if it not is platform
					
				}else{
					
					if( _oSFunction.bSpecialGenerate  && _oSFunction.sName != "fGetError"){
						gpuConvertFunctionHeaderStandard(_oSClass, _oSFunction);
					}
				}
			}
			
			addSpace();
		}
		
		
		
		private function gpuEmptyFunctionToConvert(_oSClass:SClass):Void {
		
			var _aFunction : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt = _aFunction.length;
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function
				//if(_oSFunction.bSpecialGenerate &&  _oSFunction.bStatic && _oSFunction.sName != "fGetError"){
				if(_oSFunction.bSpecialGenerate && _oSFunction.sName != "fGetError"){
					gpuEmptyFunctionToConvertHeader(_oSClass, _oSFunction);
				}
			}
			
			addSpace();
		}
		
		
		
		private function gpuEmptyFunctionToConvertHeader(_oSClass:SClass, _oSFunction:SFunction):Void {

			var _sFuncNameFunc : String = "FUNC_" + _oSFunction.sName;
			var _sFuncNameGL : String = "glCall_" + _oSFunction.sName;
			
			var _sFuncNameUSE : String = "GL_" + _oSFunction.sName;
			var _sLib : String = _oSClass.oSLib.sWriteName;
	
			//Param
			//var _sParam : String = getFunctionParam(_oSFunction, false);
			var _sParam : String = CommonCpp.getFunctionParam(_oSFunction, false, false, true, false, true);

			
			var _sReturn : String = "aasss";
			//_sReturn = TypeText.typeToCPP(_oSFunction.oReturn, true) + " "; //TODO
			//Remap return
			switch(_oSFunction.oReturn.eType) {

				case EuVarType._Void:
					_sReturn = "";
				//break;
				
				case EuVarType._Bool:
					_sReturn = "false";
				//break;
				
				case EuVarType._UInt:
					_sReturn = "0";
				//break;
				case EuVarType._Int:
					_sReturn = "0";
				//break;
					
				case EuVarType._Float: //double
					_sReturn = "0.)";	
				//break;
				
				case EuVarType._String: //double
					_sReturn = "0";	
				//break;
				
				case EuVarType._Val:
					_sReturn = "0";
				//break;
				
				default:
					_sReturn = "";
				//break;
			}
			
			
			//Normal push
			//var _sCallParam1 : String = getFunctionParam(_oSFunction, false, true);
			var _sCallParam1 : String = CommonCpp.getFunctionParam(_oSFunction, false, true, true, false,true);
			pushLine("#define " + _sFuncNameUSE + "(" + _sCallParam1 + ") " + _sReturn);
		}
		
		
		
		
		
		
		
		
		
	
	}

