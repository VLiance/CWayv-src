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
	class GpuFuncCpp extends CppFile
	{

		private var bUseDefineIN : Bool = false;
		
		public function new(_Main:Root, _oCppProject : CppProject, _oSPck : SPackage) { 
	
			super(_Main,_oCppProject, _oSPck);
			
			for(_oSClass in _oSPck.aClassList){
				convertGpuFunctions(_oSClass);
			}
		//	convertClass(); already called in extended
			
		}
		/*
		Void* _SysGpuFunc::fGetFuncGL(var char *_cName, gzBool _bRequired){
			_System::fResetLastError();
			Void *p = (Void *)wglGetProcAddress(_cName);
			//if(p == 0 || (p == (Void*)0x1) || (p == (Void*)0x2) || (p == (Void*)0x3) ||  (p == (Void*)-1) ){
			gzUInt _nErr = GetLastError();
			if(_nErr == 127){
				SetLastError(0);
				HMODULE _pModule = LoadLibraryA("opengl32.dll");
				p = (Void *)GetProcAddress(_pModule, _cName);
				if(p == 0 && _bRequired){
					GZ_Debug_fError(gzU8("Error OGL function Missing: ") + gzStrC(_cName));
				}
			}else{
				if(_nErr){
					SetLastError(0);
					GZ_Debug_fError(gzU8("Error loading OGL function (")  + gzStrUI(_nErr)  + gzU8("): ") +  _System::fGetLastErrorString(_nErr) + gzStrC(_cName));
				}
			}
			return p;
		}
		*/
		
		private function convertGpuFunctions(_oSClass:SClass):Void {
		
			pushLine(fAddLicence());
			pushLine("#include \"Lib_GzOpenGL/OpenGL.h\"");
			pushLine("#include \"Lib_GzOpenGL/OpGpuInfo.h\"");
			pushLine("namespace Lib_GzOpenGL{namespace OpenGL{extern void fResetLastError();}}");
			pushLine("namespace Lib_GzOpenGL{namespace OpenGL{extern gzStr fGetLastErrorString(gzUInt _nError);}}");
	
	/*
			pushLine("#include \"SysGpuInfo.h\"");
			pushLine("#include \"SysGpuFunc.h\"");
			pushLine("#include <Windows.h>");
			pushLine("#include \"GZ/GZ.h\"");
			
			addSpace();	
			pushLine("using namespace GZ;");
			addSpace();	
					
			pushLine("Void* SysGpuFunc::fGetFuncGL(var char *_cName, gzBool _bRequired){");
			addTab();
			pushLine("System::fResetLastError();");
			pushLine("Void *p = (Void *)wglGetProcAddress(_cName);");
			pushLine("gzUInt _nErr = GetLastError();");
			pushLine("if(_nErr == 127){");
			//pushLine("if(p == 0 || (p == (Void*)0x1) || (p == (Void*)0x2) || (p == (Void*)0x3) ||  (p == (Void*)-1) ){");
			addTab();
			pushLine("SetLastError(0);");
			pushLine("HMODULE _pModule = LoadLibraryA(\"opengl32.dll\");");
			pushLine("p = (Void *)GetProcAddress(_pModule, _cName);");
			pushLine("if(p == 0 && _bRequired){");
			addTab();
			pushLine("GZ_Debug_fError(gzU8(\"Error OGL function Missing: \") + gzStrC(_cName));");
			subTab();
			pushLine("}");	
			subTab();
			pushLine("}else{");
			addTab();
			pushLine("if(_nErr){ "); addTab();
			
			pushLine("SetLastError(0);");
			pushLine("GZ_Debug_fError(gzU8(\"Error loading OGL function (\")  + gzStrUI(_nErr)  + gzU8(\"): \") +  System::fGetLastErrorString(_nErr) + gzStrC(_cName));");
			subTab();
			pushLine("}");
			subTab();
			pushLine("}");
			pushLine("return p;");
			subTab();
			pushLine("}");
			
			pushLine("static gzStr fGetFile(var char *_cFile){");
			addTab();
			pushLine("gzStr _sFile = gzStrC(_cFile);");
			pushLine("_sFile.fReplaceAll(gzU8(\"\\\\\"), gzU8(\"/\"));");
			pushLine("return _sFile;");
			subTab();
			pushLine("}");
			
			*/
			addSpace();
			
			pushLine("#if !( defined D_Platform_Web_Emsc ||  defined  D_Platform_CpcDos  ||  defined D_Platform_Lite ) ");
				pushLine("FUNC_fGetError glCall_fGetError = 0;");
				gpuFunctionToConvert(_oSClass);
								
				addSpace();
				pushLine("gzBool Lib_GzOpenGL::SysGpuFunc::fGetGpuFunctions(){");
				addSpace();
				

				pushLine("using namespace SysGpuFunc;");
				pushLine("glCall_fGetError = (FUNC_fGetError)fGetFuncGL(\"glGetError\");");
				gpuFunctionToAssign(_oSClass);
				pushLine("return true;");
				

				subTab();
				
				pushLine("}");

				addSpace();
				gpuCreateDbg(_oSClass);
			pushLine("#else");
				pushLine("gzBool Lib_GzOpenGL::SysGpuFunc::fGetGpuFunctions(){return false;}");
			pushLine("#endif");
			
			
			
		}
		

		

		private function gpuFunctionToConvert(_oSClass:SClass):Void {
		
			var _aFunction : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt = _aFunction.length;
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function
				//if(_oSFunction.bSpecialGenerate && _oSFunction.bStatic  && _oSFunction.sName != "fGetError"){
				if(_oSFunction.bSpecialGenerate   && _oSFunction.sName != "fGetError"){
					gpuConvertFunctionCpp(_oSClass, _oSFunction);
				}
			}
			
			addSpace();
		}
		
		
		private function gpuConvertFunctionCpp(_oSClass:SClass, _oSFunction:SFunction):Void {
			//var _sReturn : String;
			var _sFuncNameFunc : String = "FUNC_" + _oSFunction.sName;
			var _sFuncNameGL : String = "glCall_" + _oSFunction.sName;
			var _sLib : String = _oSClass.oSLib.sWriteName;
	
			//_sReturn = TypeText.typeToCPP(_oSFunction.oReturn, true) + " "; //TODO
			
			//Param
			//var _sParam : String = getFunctionParam(_oSFunction, true);

			//Normal push
			pushLine( _sFuncNameFunc + " " + _sFuncNameGL + " = 0;");
			//addSpace();
		}
		
		
		
		
		
		private function gpuFunctionToAssign(_oSClass:SClass):Void {
		
			var _aFunction : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt = _aFunction.length;
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function
				//if(_oSFunction.bSpecialGenerate && _oSFunction.bStatic  && _oSFunction.sName != "fGetError"){
				if(_oSFunction.bSpecialGenerate  && _oSFunction.sName != "fGetError"){
					gpuAssignFunctionCpp(_oSClass, _oSFunction);
				}
			}
			
			addSpace();
		}
		
		
		private function gpuAssignFunctionCpp(_oSClass:SClass, _oSFunction:SFunction):Void {
			var _sReturn : String;
			var _sFuncNameFunc : String = "FUNC_" + _oSFunction.sName;
			var _sFuncNameGL : String = "glCall_" + _oSFunction.sName;
			var _sLib : String = _oSClass.oSLib.sWriteName;
	

			_sReturn = TypeText.typeToCPP(_oSFunction.oReturn, true) + " "; //TODO
			
			
			//Param
			var _sParam : String = CommonCpp.getFunctionParam(_oSFunction, true);
			var _sSpecifique : String = "";
			if (_oSFunction.bSpecifiquePlatforme) {
				_sSpecifique = "w";
			}
			
			//Normal push
			pushLine( _sFuncNameGL  + " = (" + _sFuncNameFunc + ")fGetFuncGL(\"" + _sSpecifique + "gl" + _oSFunction.sName.substring(1) + "\");" );
			//addSpace();
			
		}
		
		
		
		
		
		private function gpuCreateDbg(_oSClass:SClass):Void {
		
			pushLine("#ifdef D_Debug");
			addTab();
			var _aFunction : Array<Dynamic> = _oSClass.aFunctionList;
			var _i : UInt = _aFunction.length;
			for (i in 0 ...  _i) {
				var _oSFunction : SFunction = _aFunction[i];
				//Only private/public function
				//if(_oSFunction.bSpecialGenerate && _oSFunction.bStatic && _oSFunction.sName != "fGetError"){
				if(_oSFunction.bSpecialGenerate && _oSFunction.sName != "fGetError"){
					gpuCreateDbgFunc(_oSClass, _oSFunction);
				}
			}
			subTab();
			pushLine("#endif");
		
			
			addSpace();
		}
		
		
		/*
		
		gzBool  glDbg_fSwapIntervalEXT(gzInt _nInterval, var char* _file , gzUInt _line){
     _System::fResetLastError();
	gzBool _Ret = glCall_fSwapIntervalEXT(_nInterval);

	gzInt nErr = GetLastError();
	if(nErr){
	_Debug::fError(_System::fGetLastErrorString(nErr) + gzU8(": glSwapIntervalEXT( ") + gzU8("_nInterval|") + gzStrI(_nInterval) + gzU8("| ") + gzU8(") ") + gzU8(" File: ") + fGetFile(_file) + gzU8(" Line: ") + gzStrUI(_line) );
	}
	return _Ret;

		*/
		
		private function gpuCreateDbgFunc(_oSClass:SClass, _oSFunction:SFunction):Void {
			
			var _sReturn : String;
			var _sFuncNameDbg : String = "glDbg_" + _oSFunction.sName;
			var _sFuncNameGL : String = "glCall_" + _oSFunction.sName;
			var _sLib : String = _oSClass.oSLib.sWriteName;
			
			
			_sReturn = TypeText.typeToCPP(_oSFunction.oReturn, true) + " "; //TODO
			
			
			//Param
			var _sParam : String = CommonCpp.getFunctionParam(_oSFunction, false, false, true, false, true);
			if (_sParam != "") {
				_sParam = ", " + _sParam;
			}
			pushLine(_sReturn + " " + _sFuncNameDbg +  "(Lib_GZ::Base::Thread::cThread* thread" + _sParam + " GZ_DbgArg){");
					//	pushLine( _sReturn + " " + _sFuncNameDbg +  "(Lib_GZ::Base::Thread::cThread* thread" + _sParam + " GZ_DbgArg);");
			
				addTab();
				if (_oSFunction.bSpecifiquePlatforme) {
						
					pushLine(" #ifdef D_Platform_Windows");
					pushLine(" Lib_GzOpenGL::OpenGL::fResetLastError();");
				}
				if(_oSFunction.oReturn.eType != EuVarType._Void){
					pushLine(_sReturn + "_Ret = " + _sFuncNameGL + "(" + CommonCpp.getFunctionParam(_oSFunction, false, true, true, false, true) + ");");
				}else {
					pushLine( _sFuncNameGL  + "(" + CommonCpp.getFunctionParam(_oSFunction, false, true, true, false, true) + ");");
				}
				pushLine("gzInt nErr = GL_fGetError();" );
				pushLine("if(nErr){" );
				var _sParamValue : String = getFunctionParamToStringOGL(_oSFunction, true);
				if (_sParamValue != "") {
					_sParamValue = " + "  + _sParamValue;
				}
				//Lib_GZ::Debug::Debug::GetInst(thread)->fError(
				//GZ_Debug_fError(
				pushLine("Lib_GZ::Debug::Debug::GetInst(thread)->fError(Lib_GzOpenGL::pOpGpuInfo::fGetErrorString(nErr) + gzU8(\": gl" + _oSFunction.sName.substring(1) + "( \")" +  _sParamValue + " + gzU8(\") \") + gzU8(\" File: \") + Lib_GzOpenGL::cOpGpuInfo::fGetFile(_file) + gzU8(\":\") + gzStrUI(_line) );");
				//pushLine("MessageBox(0,TEXT(\"GL Error : GL_" + _oSFunction.sName + " : \"),TEXT(\"GL Error : GL_" + _oSFunction.sName + " : \"),MB_OK | MB_ICONINFORMATION);");
				pushLine("}");
				
				if(_oSFunction.bSpecifiquePlatforme){
					pushLine("nErr = GetLastError();");		
					pushLine("if(nErr){" );
					pushLine("Lib_GZ::Debug::Debug::GetInst(thread)->fError(Lib_GzOpenGL::OpenGL::fGetLastErrorString(nErr) + gzU8(\": gl" + _oSFunction.sName.substring(1) + "( \")" +  _sParamValue + " + gzU8(\") \") + gzU8(\" File: \") + Lib_GzOpenGL::cOpGpuInfo::fGetFile(_file) + gzU8(\":\") + gzStrUI(_line) );");
					pushLine("}");
				}

				if(_oSFunction.oReturn.eType != EuVarType._Void){
					pushLine("return _Ret;");
				}
				if(_oSFunction.bSpecifiquePlatforme){
					pushLine(" #endif");
					pushLine(" return false;");
				}
				subTab();
			pushLine("}");
			
		}
		
		
		override public function addOverrideFunctionLines(_oSFunction : SFunction) :Void {
			if (!_oSFunction.bConstructor && _oSFunction.bSpecialGenerate) {
				var _sReturn : String = "";
				if (_oSFunction.oReturn.eType != EuVarType._Void) {
					_sReturn = "return ";
				}
				var _sFuncNameGL : String = "GL_" + _oSFunction.sName;
				pushLine(_sReturn + _sFuncNameGL  + "(" + CommonCpp.getFunctionParam(_oSFunction, false, true, true,false,true) + ");");
			}
		}
		
		
	
	}

