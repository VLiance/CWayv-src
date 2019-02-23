package language.project.convertCpp ;

	import language.project.convertCpp.FileForm;
	import language.project.convertSima.SClass;
	import language.project.CppProject;
	import language.base.Root;
	/**
	 * ...
	 * @author ...
	 */
	class CppMainFile extends FileForm
	{
		
		private var oCppProject : CppProject;
		private var oSClass : SClass;
		
		public function new(_Main:Root, _oCppProject : CppProject, _oSClass : SClass) {
			super(_Main);
			oCppProject = _oCppProject;
			oSClass = _oSClass;
			
			createMainFile();
		}
		
		
		
		private function includeMainHeader():Void {
			//Include basic class of cpp
		//	pushLine("#include \"" +  oSClass.sPathBack  + oCppProject.sLibRelativePath +  oCppProject.sCppMainHeader + "\"");
			//pushLine("#include \"MainHeader" +  oSClass.oSLib.sWriteName + ".h\"");
			
			//pushLine("#include \"MainHeader" +  oSClass.oSLib.sWriteName + ".h\"");
			
			/*
			//Debug
			if(bConvertDebug){
				aCurrentConvert[nConvertLine] = "#include \"" +  aCurrentClass[cClassPathBack] + sLibCppRelativePath  + "Debug.h\"";
			}*/
		}
		
		public function createMainFile():Void {

			includeMainHeader();
			
			//include Global var class
				//pushLine("#include \"" +  oCppProject.sLibRelativePath + "Global.h" + "\"");
			
			//Include MainClass
			//pushLine("#include \""  + "..\\_Src\\" + oSClass.sName + ".h\"");
			//pushLine("#include \"" +   oCppProject.oSProject.oCppLib.sWriteName + "\\Global.h\"");
			
			
			//pushLine("#include \""  + "../_Src/" + oSClass.sName + ".h\"");
			
			pushLine("#ifndef GZ_tGenerate_Embed_Files");
			pushLine("#include \""  + oSClass.sName + ".h\"");
			pushLine("#endif");
			
			pushLine("#include \"GZ/File/Embed.h\"");
			pushLine("#include \"GZ/Debug.h\"");
			
			pushLine("#include \"" +   oCppProject.oSProject.oGzLib.sWriteName + "/Global.h\"");
			pushLine("#include \"" +   oCppProject.oSProject.oGzLib.sWriteName + "/System.h\"");
			
			addSpace();
			
			//Instance
			//pushLine(oSClass.oSLib.sWriteName  + "_" + oSClass.sName + "*oMain;");
			
			addSpace();
			//Entry point in Windows
			pushLine("gzInt WINAPI WinMain(HINSTANCE _hInstance, HINSTANCE _hNull, LPSTR _lpCmdLine, gzInt _nShowCmd){");
			
			addSpace();
			addTab();

			//Make entry global
			//pushLine(sCppBaseLib + "_Global::iniEntryVars(&_hInstance, _lpCmdLine, _nShowCmd, 0);")
			//pushLine(oCppProject.oSProject.oCppLib.sWriteName + "_Global::iniEntryVars(_hInstance, _lpCmdLine, _nShowCmd, 0);")
			pushLine(oCppProject.oSProject.oGzLib.sWriteName + "_System::fIni(_hInstance, _lpCmdLine, _nShowCmd);");

			addSpace();
		
			
			pushLine("#ifdef GZ_tGenerate_Embed_Files");
			addTab();
			pushLine("new GZ_Debug(1680, 500, 1, 1);");
			pushLine("new GZ_Embed();");
			
			subTab();
			pushLine("#else");
			addTab();
			addSpace();
			
			pushLine("////  Main class call ////");
			//Create main class
			//pushLine("oMain = new " + oSClass.oSLib.sWriteName + "_" +  oSClass.sName + "();");
			
			pushLine("new " + oSClass.sNsAccess  +  oSClass.sName + "();");
			pushLine("/////////////////////////");
			
			subTab();
			addSpace();	
			pushLine("#endif");
				
			//Create main loop
			addSpace();

			
			pushLine("while( GZ_Global::bIsAlive){");
			addTab();
			pushLine("GZ_Global::fMainUpdate();");
			subTab();
			pushLine("}");
			/*
			
			
			pushLine("GZ_Global::bIniFinish = true;");
			addSpace();
			pushLine("//Main Loop")
			//pushLine("if(" + oCppProject.oSProject.oCppLib.sWriteName + "_Global::nNumWindows != 0){")
			//addTab();
			pushLine("MSG msg;");
			pushLine("while(" + oCppProject.oSProject.oCppLib.sWriteName + "_Global::nNumWindows > 0 && GetMessage(&msg, NULL, 0, 0)) {")
			addTab();
			pushLine("TranslateMessage(&msg);")
			pushLine("DispatchMessage(&msg);")
		//	subTab();
			//pushLine("}")
			//pushLine( oCppProject.oSProject.oCppLib.sWriteName  + "_Global::set_nAppReturn( (Int)msg.wParam );")
			subTab();
			pushLine("}")
		*/
			//Close function
			addSpace();
			pushLine("return " + oCppProject.oSProject.oGzLib.sWriteName  + "_Global::nAppReturn;");
			subTab();
			pushLine("}");
		}
		/*
		    #ifdef GZ_tGenerate_Embed_Files
				new GZ_Debug(1680, 500, 1, 1);
				new GZ_Embed();
			#else

				///  Main class call ///
				new Example_Example();
				///////////////////////

			#endif
*/
		
	}

