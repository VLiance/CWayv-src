package language.project.packLib;
import language.project.convertSima.TypeResolve;
import language.base.Debug;
import language.base.InObject;
import language.base.Root;
import language.enumeration.EuClassType.EuClassType_;
import language.enumeration.EuFuncType;
import language.enumeration.EuSharing;
import language.enumeration.EuVarType;
import language.project.convertCpp.ConvertLines;
import language.project.convertCpp.FileForm;
import language.project.convertCpp.TypeText;
import language.project.convertSima.SClass;
import language.project.convertSima.SFunction;
import language.vars.varObj.CommonVar;
import language.vars.varObj.ParamInput;
import language.vars.varObj.VarExClass;
import language.vars.varObj.VarObj;

/**
 * ...
 * @author Maeiky
 */
class PackLib  extends FileForm
{
	public var oProject : ProjectData;
	public var oSProject : SProject;
	public var sPlaformTarget : String;	
				
		public function new(_Main:Root) {super(_Main);}
		
		
		public function fIni(_oProject:ProjectData,  _oSProject:SProject, _sPath:String, _sLibPath:String, _sAppName : String, _bConvertFullDebug : Bool, _sPlaformTarget : String, _sBuildType:String) {
			
			sPlaformTarget = _sPlaformTarget;
			oProject = _oProject;
			oSProject = _oSProject;
			Debug.fTrace("INI PACK LIB " + oProject.oCWaveMake.sExportBasePath  );
			//Create all class
			//var _i:UInt = oSProject.aClass.length;
			//for (i in 0 ..._i) {
			for (_oPckg in oSProject.aPackage) {
				var _sCwPath : String = _oPckg.oSLib.sIdName + "." +  _oPckg.sPath.split("/").join(".");
				_sCwPath = _sCwPath.substring(0, _sCwPath.length - 1); //Remove last dot
				
				pushLine("package " + _sCwPath  + "{");
					addTab();
				for (_oSClass in  _oPckg.aClassList) {

					//	var _oSClass : SClass =  oSProject.aClass[i];
						var _sClassDef : String = "public " + EuClassType_.fGet(_oSClass.eClassType) + " " +  _oSClass.sName + " " + fGetExtendList(_oSClass) + "{"; //always public?
						pushLine(_sClassDef);
						addTab();
						fGetFunctionList(_oSClass);
						subTab();
						pushLine("}");
					//	Debug.fTrace(_oSClass.sName);
				}
				subTab();
				pushLine("}");
			}
			
			Debug.fTrace("output: "  + _oProject.oCWaveMake.sExportBasePath );
			
			
				
			Debug.fTrace(aFile);
			var _sFile : String =  _oProject.oCWaveMake.sExportBasePath;
			
			MyFile.fwritefile(_sFile, aFile);
			
			
		}
		
		public function fGetExtendList(_oSClass: SClass ): String {
		
			if (_oSClass.aExtendClass.length == 0){
				return "";
			}
			
			var _sResult : String = "";
			
			var _aList : Array<Dynamic> = _oSClass.aExtendClass;
			
			var _i:UInt = _aList.length;
			for (i in 0 ..._i) {
				var _oExClass : SClass = _aList[i];
				if (_sResult != ""){_sResult += ", "; }
				_sResult +=  _oExClass.sName;
			}
			
			
			return "extends " + _sResult;
		}
		
		
		public function fGetFunctionList(_oSClass: SClass ): String {

		//	var _sResult : String = "";
			for ( _oFunction  in _oSClass.aFunctionList){//SFunction
			//	_sResult += fGetFunction(_oFunction);
				fGetFunction(_oFunction);
			}
			
			//return _sResult;
			return "";
		}
		
		public function fGetFunction(_oFunction: SFunction ): String {
			//var _sResult : String = "";
			pushLine( EuFuncType_.fGet( _oFunction.eFuncType)  +  EuSharing_.fGet(_oFunction.eSharing) + "function " + _oFunction.sName + "(" +fGetFunctionParam(_oFunction)  + ");"  );
			
	
			return "";
		}
		
		
	
		

		public function fGetFunctionParam(_oFunction: SFunction ): String {
			var _sParam : String = "";
			var _sInputVarString : String = "";

			var _aParam : Array<Dynamic> = _oFunction.aParamList;
			var _i : UInt = _aParam.length;
			for (i in 0 ...  _i) {
								
				if (_sParam != "") { //Not the last
					_sParam += ", ";
				}
				
				var _oParam : VarObj = _aParam[i];
				
				if (_oParam.eType == EuVarType._ParamInput) {

					var _oParamInput : ParamInput = cast(_oParam);
					//_sInputVarString  = fGetVarType(_oParamInput.oVarInput) + " ";
					
					// _sParam +=   _sInputVarString + ConvertLines.convertCppVarType( _oParamInput.oVarInput, _oFunction.nLine);
					  
					//line after =

					_sParam +=  _oParamInput.oVarInput.sName + ": " + fGetVarType(_oParamInput.oVarInput)  + " = " + _oParamInput.sOriLine;
					 
				}else {

					_sParam +=  fGetVarName(_oParam) + ": " + fGetVarType(_oParam);
				}
			
			}
			return _sParam;
			
		}
		
		
		public function fGetVarName(_oVar: VarObj ): String {
			
			return _oVar.fGetName();
		}
		public function fGetVarType(_oVar: VarObj ): String {
			return _oVar.fGetType();
		//	return EuVarType_.fGetName(_oVar.eType);
		}
		
		
		
		
		
		
		
}



