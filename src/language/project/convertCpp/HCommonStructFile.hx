package language.project.convertCpp ;

	import language.enumeration.EuVarType;
	import language.pck.SLib;
	import language.project.convertCpp.FileForm;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SDelegate;
	import language.project.convertSima.SFunction;
	import language.project.CppProject;
	import language.project.SProject;
	import language.vars.special.UnitObj;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.VarObj;
	import language.base.Root;
	/**
	 * ...
	 * @author ...
	 */
	class HCommonStructFile extends CommonCpp
	{
		
		
		private var oSProject : SProject;
		private var oSDelegate : SDelegate;
//		public var aClassList : Array<Dynamic>; TODO ?
		public var oLib : SLib;
		public static var sPrefix : String = "_d";
		//public static var sName : String = "CommonStruct";
		//public static var sHeader  : String = sName + ".h";
		public var sName : String;
		public var sHeader : String;
		
		public var sWritePath : String;

		
		public function new(_Main:Root, _oCppProject : CppProject, _oSDelegate : SDelegate, _oSProject:SProject, _oLib:SLib) {
			super(_Main, _oCppProject, null);
			oCppProject = _oCppProject;
			oSDelegate = _oSDelegate;
			oSProject = _oSProject;
			oLib = _oLib;
			
			/*
			if (_oLib.sCommunStructPath != "") {
				sName = "Main" + oLib.sName;
				sWritePath = oLib.sCommunStructPath;
			}else {
				sName = "Main" + oLib.sWriteName;
				sWritePath = oLib.sWritePath;
			}
			*/
			
			sHeader = sName + ".h";
			
//			aClassList = _oLib.aClass;
			
			
			
			/*
			if(oLib.aMerge.length == 0){
				aClassList = _oLib.aClass;
			}else {
				aClassList = [];
				var _i : Int = oLib.aMerge.length;
				for (i in 0 ..._i) {
					var _oSLib : SLib = oLib.aMerge[i];
					aClassList = aClassList.concat(_oSLib.aClass);
				}
			}*/
		
			createMainFile();
		}
	
		private function pushHeaderDefine():Void {
			
			//pushLine("#include \"MainHeader" + oLib.sWriteName  + ".h\"");
			pushLine("#include \"GZ/MainHeaderGZ.h\"");
			pushLine("#ifndef tHDef_"+ oLib.sWriteName + "_" + sName);
			pushLine("#define tHDef_"+ oLib.sWriteName + "_" + sName);
		}
		
		
		private function includeMainHeader():Void {
			//Include basic class of cpp
		/*
			if(oLib != oSProject.oCppLib){
			//pushLine("#include \"" +  oCppProject.sLibRelativePath +  oCppProject.sCppMainHeader + "\"");
			
				pushLine("#include \"" +   oCppProject.oSProject.oCppLib.sWriteName + "/Main" + oCppProject.oSProject.oCppLib.sWriteName + ".h\"");
				//pushLine("#include \"" +  oCppProject.sLibRelativePath + "Main" + oCppProject.oSProject.oCppLib.sWriteName + ".h\"");
			//pushLine("#include \"" +    oCppProject.oSProject.oMainSClass.sPathBack  +  oCppProject.sLibRelativePath +  oCppProject.sCppMainHeader + "\"");
			}else {*/
				pushLine("#include \"Delegate.h\"");
			//}
		}
		
		public function createMainFile():Void {

			
			pushHeaderDefine();

			includeMainHeader();
			
			
			addSpace();
			addTab();
			
			//listClassDefinition();
			//listStructuresDefinition();
			//listStructures();
			
			//listDelegateTypeDef();
			//addSpace();
			//listDelegateStructure();
			//addSpace();
			//listDelegateRef();
			
			
			addSpace();
			subTab();

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
				pushLine("#ifndef " +  sPrefix + "Def" + _oFunc.sDelegateString);
				pushLine("#define " +  sPrefix + "Def" + _oFunc.sDelegateString);
				pushLine("typedef " + _sReturn + "(" + oSDelegate.sLib_Name + "::*" + sPrefix + "Fp" + _oFunc.sDelegateString + ")" + "(" + _sParam + ");");
				pushLine("struct " +  sPrefix + "Str" + _oFunc.sDelegateString + " { " + sPrefix + "Fp" + _oFunc.sDelegateString + " fCall; " +  oSDelegate.sLib_Name + "* oClass; };");
				pushLine("#endif"); 
			}
		}
		
		
		/*
		public function listClassDefinition():Void {
				pushLine("//Class list " );
				//pushLine("class " + oSProject.oMainLib.sName + "_Delegate;" );
				pushLine("class " + oSProject.oCppLib.sWriteName + "_Delegate;" );
				
				var _aList : Array<Dynamic> = aClassList;
				var _i:UInt = _aList.length;
				for (i in 0 ..._i) {
					var _oSClass : SClass = _aList[i];
					pushLine("class " + oLib.sWriteName + "_"  + _oSClass.sName + ";");
				}
				
				addSpace();
		}
		

		
		public function listStructuresDefinition():Void {
				pushLine("//Structures definition list " );
				addSpace();
				
				var _aList : Array<Dynamic> = aClassList;
				var _i:UInt = _aList.length;
				for (i in 0 ..._i) {
					var _oSClass : SClass = _aList[i];
					pushLine("//"  + _oSClass.sName);
					getUnitDefinition(_oSClass);
				}
				addSpace();
				addSpace();
		}
		
		public function listStructures():Void {
				pushLine("//Structures list " );
				addSpace();
				
				var _aList : Array<Dynamic> = aClassList;
				var _i:UInt = _aList.length;
				for (i in 0 ..._i) {
					var _oSClass : SClass = _aList[i];
					if(!_oSClass.oSLib.bReadOnly){  //Already defined somwere
						pushLine("//"  + _oSClass.sName);
						getUnitToConvert(_oSClass);
					}
					
					
				}
		}
		*/
		
		
		////////////////////////////////////////////////
		private function getUnitDefinition(_oSClass : SClass):Void {
			
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
			
			pushLine(_sLine);
		}
		
		
		private function getUnitToConvert(_oSClass : SClass):Void {

			addSpace();
			//pushLine("//Unit");
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
			pushLine( "struct " + _sName + " { "+ sBaseStruct + _sSubVars + "};"  + "struct _" + _sName + " { " + _sSubVars + "};" );
		}	
		
		////////////////////////////////////////////////
		
		
		
		
		
		
		
		
		
		
		
	}

