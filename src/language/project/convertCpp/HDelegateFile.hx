package language.project.convertCpp ;

	import language.project.convertCpp.FileForm;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SDelegate;
	import language.project.convertSima.SFunction;
	import language.project.CppProject;
	import language.base.Root;
	/**
	 * ...
	 * @author ...
	 */
	class HDelegateFile extends FileForm
	{
		
		private var oCppProject : CppProject;
		private var oSClass : SClass;
		private var oSDelegate : SDelegate;
		public static var sPrefix : String = "_d";

		
		public function new(_Main:Root, _oCppProject : CppProject, _oSDelegate : SDelegate) {
			super(_Main);
			oCppProject = _oCppProject;
			oSDelegate = _oSDelegate;
			createMainFile();
		}
	
		private function pushHeaderDefine():Void {
			
			pushLine("#ifndef tHDef_GZ_" +  oSDelegate.sName);
			pushLine("#define tHDef_GZ_" +  oSDelegate.sName);
		}
		
		
		private function includeMainHeader():Void {
			//Include basic class of cpp
			//pushLine("#include \"" +  oCppProject.sLibRelativePath +  oCppProject.sCppMainHeader + "\"");
			//pushLine("#include \""  + oCppProject.oSProject.oMainSClass.sPathBack +  oCppProject.sLibRelativePath +  oCppProject.sCppMainHeader + "\"");
		
		}
		
		public function createMainFile():Void {

			pushHeaderDefine();
			
			includeMainHeader();
			
			//include Global var class
			//pushLine("#include \"" +  oCppProject.sLibRelativePath + "Global.h" + "\"");

			
		
			addSpace();
			pushLine("namespace Lib_GZ{");
			pushLine("class " + oSDelegate.sName + " {");
			addTab();
			addSpace();
			
			//Var list
			pushLine("public:");
			addTab();
			
			//listDelegateTypeDef();
			//addSpace();
			//listDelegateStructure();
			//addSpace();
			//listDelegateRef();
			
			
			
			addSpace();
			subTab();
			subTab();
			pushLine("};");
			pushLine("}");
			pushLine("#endif");
		}
		
		public function listDelegateTypeDef():Void {
			var _aList: Array<Dynamic> = oSDelegate.aDelegateList;
			var _i : Int = _aList.length;
			for (i in 0 ..._i) {
				var _oFunc : SFunction = _aList[i];
				
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
				
				addSpace();
				//pushLine("#ifndef " +  sPrefix + "Def" + _oFunc.sDelegateString);
				//pushLine("#define " +  sPrefix + "Def" + _oFunc.sDelegateString);
				pushLine("typedef " + _sReturn + "(" + oSDelegate.sLib_Name + "::*" + sPrefix + "Fp" + _oFunc.sDelegateString + ")" + "(" + _sParam + ");");
				pushLine("struct " +  sPrefix + "Str" + _oFunc.sDelegateString + " { " + sPrefix + "Fp" + _oFunc.sDelegateString + " fCall; " +  oSDelegate.sLib_Name + "* oClass; };");
				//pushLine("#endif"); 
			}
		}
		
		
		/*
		public function listDelegateStructure():Void {
		var _aList: Array<Dynamic> = oSDelegate.aDelegateList;
			var _i : Int = _aList.length;
			for (i in 0 ..._i) {
				var _oFunc : SFunction = _aList[i];
	
				 //struct dstr_int_Void { dptr_int_Void nCall; SimaCode_Ext1* prtClass; };   
				pushLine("struct " +  sPrefix + "Str" + _oFunc.sDelegateString + " { " + sPrefix + "Fp" + _oFunc.sDelegateString + " fCall; " +  oSDelegate.sLib_Name + "* oClass; };");
			}
			
		}*/
		
		/*
		public function listDelegateRef():Void {
		var _aList: Array<Dynamic> = oSDelegate.aDelegateList;
			var _i : Int = _aList.length;
			for (i in 0 ..._i) {
				var _oFunc : SFunction = _aList[i];
	
				//dstr_int_Void* dref_int_Void;
				pushLine(sPrefix + "Str" + _oFunc.sDelegateString + "* " + sPrefix + "Ref" +  _oFunc.sDelegateString + ";" );
			}
			
		}*/
		
		
	}

