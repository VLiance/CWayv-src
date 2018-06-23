package language.project.convertCpp ;

	import language.enumeration.EuConstant;
	import language.pck.FileImport;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuSharing;
	import language.enumeration.EuVarType;
	import language.MyFile;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.project.CppProject;
	import language.Text;
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
	class DefHeaderFile extends CommonCpp
	{

		private var bUseDefineIN : Bool = false;
		
		public function new(_Main:Root, _oCppProject : CppProject, _oSClass : SClass) { 
	
			super(_Main,_oCppProject, _oSClass);
			
			convertDefHeader();		
		}
		
		
		private function convertDefHeader():Void {
			if(oSClass.oSLib.sName == "GZ"){
				pushLine(fAddLicence());
			}else if(oSClass.oSLib.sName == "SimaCode"){
				pushLine("//GroundZero Engine Demo File -- An example to show the capabilities of GZE, modify this file as you like --");
			}
			
			pushLine(oSClass.sCNamespace + "class c"  + oSClass.sName +";" + oSClass.sCEndNamespace );
			

			pushHeaderDefine();
			
			pushLine("#include \"Lib_GZ/Base/GzTypes.h\"");
			
			/*
			pushLine("namespace " +  oSClass.oSLib.sWriteName + "{namespace _" +  oSClass.sName  + "{");
			getUnitDefinition(); //TODO Only local
			pushLine("}}");
					listDelegateTypeDef();
		
			
	
			
			//Include class() //////////////////////////////////
			includeClass();
			/////////////////////////////
				*/
						//pushLine("class " + oSClass.oSLib.sWriteName + "_"  + oSClass.sName + _sExtend +" {");
		//	pushLine("namespace " +  oSClass.oSLib.sWriteName + "{");
			//pushLine("namespace " +  oSClass.sName  + "{");
			pushLine(oSClass.sNamespace);
			
			addTab();
			addSpace();	
					
			//Get constant		
			pushLine("//Public var"); //Only public
			getVarToConvert(oSClass.aIniConstVarList, EuSharing.Public, false, false, EuConstant.Constant);
	
			pushLine("//Private var");
			getVarToConvert(oSClass.aIniConstVarList, EuSharing.Private, false, false, EuConstant.Constant);
			
			getEnumDefinition();
			
			subTab();
			pushLine(oSClass.sEndNamespace);
			//pushLine("}");
			//pushLine("}")
			
			pushLine("#endif");
		}
		
		//#ifndef tHDef_LibName_Example
		//#define tHDef_LibName_Example
		private function pushHeaderDefine():Void {

			pushLine("#ifndef tHDef_HH_" +  oSClass.sHeaderName); //Resolve problem of recursive extented class linking !Very important!
			
			//pushLine("#ifndef tHDef_" + oSClass.oSLib.sName + "_" + oSClass.sName);
			pushLine("#define tHDef_HH_" +  oSClass.sHeaderName);
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

			addSpace();
			pushLine("//Enum");
			var _aEnumList:Array<Dynamic> = oSClass.aEnumList;
			var _i : UInt = _aEnumList.length;
			for (i in 0 ...  _i) {
				var _oEnum : EnumObj = _aEnumList[i];
				if(!_oEnum.isExtend()){ //Extend type don't need to be converted

					pushLine( "struct " +  _oEnum.sName  + "{");
					addTab();
					pushLine("enum Type {");
					getEnumSubVar(_oEnum);
					pushLine("};");
					pushLine("Type t_;inline " + _oEnum.sName + "(Type t) : t_(t) {}operator Type () const {return t_;}");
					pushLine("inline " +  _oEnum.sName  + "(){};");
					subTab();
					pushLine("};");
				}
			}
		}
		
		private function getEnumSubVar(_oEnum : EnumObj):Void {
			addTab();
				var _aEnumVar:Array<Dynamic> = _oEnum.aVarList;
				var _i : UInt = _aEnumVar.length;
				var _sInput : String = "";
				for (i in 0 ...  _i) {
					
					//Always paramInput
					var _oVar : VarObj = cast(_aEnumVar[i]); 
					_sInput = ConvertLines.checkVarConvertIn( _oVar , cast(_oVar,ParamInput).oConvertInType, ConvertLines.convertLineToCpp(cast(_oVar,LineObj))); //Todo type resolve
					_oVar = cast(_oVar,ParamInput).oVarInput;  //TODO made initialisation with the input
					if(i != _i - 1){
						pushLine(cast(_oVar,CommonVar).sName + " = " + _sInput + ",");
					}else {
						pushLine(cast(_oVar,CommonVar).sName + " = " + _sInput);
					}
				}
			subTab();
		}
		
		/*
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
					_sLine += "struct " + _sName + "; " + "struct " + "_" + _sName + "; "
					
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
					_sLine += "struct " + _sName + "; " + "struct " + "_" + _sName + "; "
					
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
						_oVar = ParamInput(_oVar).oVarInput;  //TODO made initialisation with the input
					//break;
					
					default :
					
					//break;
					
				}
				
				_sSubVars += convertVar(CommonVar(_oVar)) + "; ";
			}
			//push
			//pushLine( "struct " + _sName + " { " + _sSubVars + "};");
			pushLine( "struct " + _sName + " { "+ sBaseStruct + _sSubVars + "};"  + "struct _" + _sName + " { " + _sSubVars + "};" );
		}	
		
			*/

		/*
		public static var sPrefix : String = "_d";
		public function listDelegateTypeDef():Void {
			var _aList: Array<Dynamic> = oSClass.aDelegateList;
			var _i : Int = _aList.length;
			for (i in 0 ..._i) {
				var _oFunc : SFunction = _aList[i];
				
				var _sReturn : String = TypeText.getGeneralStringType(_oFunc.oReturn);
				
				var _sParam : String = "";
				var _aParam : Array<Dynamic> = _oFunc.aParamList;
				if (_aParam.length > 0) {
					for (var j:Int = 0; j < _aParam.length; j++) {
						if (j != 0) {
							_sParam += ", "
						}
						_sParam +=  TypeText.typeToCPP(_aParam[j]); 
					}
					
				}else {
					_sParam  = "Void";
				}
				
				addSpace();
				pushLine("#ifndef " +  sPrefix + "Def" + _oFunc.sDelegateString);
				pushLine("#define " +  sPrefix + "Def" + _oFunc.sDelegateString);
				pushLine("typedef " + _sReturn + "(GZ::Delegate::*" + sPrefix + "Fp" + _oFunc.sDelegateString + ")" + "(" + _sParam + ");");
				pushLine("struct " +  sPrefix + "Str" + _oFunc.sDelegateString + " { " + sPrefix + "Fp" + _oFunc.sDelegateString + " fCall; GZ::Delegate* oClass; };");
				pushLine("#endif"); 
			}
		}
		*/
	
		
	
	}

