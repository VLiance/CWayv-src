package language.project.assist;

	import language.cwMake.line.Rc;
	import language.CWaveMake;
	import language.CwmFile;
	import language.CwmLib;
	import language.enumeration.EuSharing;
	import language.enumeration.EuVarType;
	import language.enumeration.EuOperator;
	import language.pck.FileImport;
	import language.pck.GroupSLib;
	import language.pck.SLib;
	import language.project.convertSima.ExtractBlocs;
	import language.project.convertSima.ExtractLines;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.project.convertSima.SGlobal;
	import language.project.SProject;
	import language.vars.special.SNatAttribut;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.FuncCall;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.VarCallClass;
	import language.vars.varObj.VarExClass;
	import language.vars.varObj.VarObj;
	import language.vars.varObj.VarStaticClass;
	import language.base.Debug;
	/**
	 * ...
	 * @author ...
	 */
	class CwInfo 
	{
		
	
		
		public function new() {
		}
		
		
		public static function fGetLibInfo(_oProject: SProject):String {
			var _sResult : String = "";
			var _oSLib : SLib;
			
			var _oMainGroup : GroupSLib =   _oProject.oMainLib.oGroup; //MainGroup is first
			
			_sResult += fGetGroupInfo(_oMainGroup);
			
			
			for( _oGroup   in _oProject.aGroupLib  ) {//GroupSLib
				if(_oGroup != _oMainGroup){
					_sResult += fGetGroupInfo(_oGroup);
				}
			}
			
			return _sResult + "|" + _oProject.oProjectData.oCWaveMake.sExportBasePath + "|";
		}
		
		public static function fGetGroupInfo( _oGroup : GroupSLib):String {
			var _sResult : String = "";
			
			_sResult += _oGroup.sName + "<" + _oGroup.sReadPath  + "<" + _oGroup.sWritePath + "<";
			for( _oSLib   in _oGroup.aSubLibList  ) {//SLib
				_sResult += "Lib," + _oSLib.sIdName  + "," + _oSLib.bReadOnly +  "," + _oSLib.oCwmLib.sRelativeCWavePath  + "," + _oSLib.sWriteName +  "," + _oSLib.sWritePath + "*";
				if(_oSLib.sIdName !=   _oGroup.sName){ //Do not double include
					_sResult += fGetRcInfo(_oSLib.oCwmLib, _oSLib.sIdName);//Not used for now?
				}
			}
			
			_sResult += fGetRcInfo(cast(_oGroup.aSubLibList[0],SLib).oCwmLib,  _oGroup.sName); //TODO  better way to get rc
			return _sResult + ";";
		}
		
		
		public static function fGetRcInfo(_oCwmLib: CwmLib, _sCheckName:String):String {
			
			var _sRcList : String = "";
			var _oCwmFile : CwmFile = _oCwmLib.oCwmFile;
			for ( _oRc  in _oCwmFile.aRc ) {//Rc
				//if(_oRc.sIdName  == _oSLib.sName){  //Todo detect if unused, detect from all cwm file?
				if (_oRc.sIdName  == _sCheckName) {  //Todo detect if unused, detect from all cwm file?
					
					//_sRcList += _oRc.sIdName + "*";
					_sRcList += "Rc,";
					_sRcList += _oRc.sRcName + ",";
					_sRcList += _oRc.sReadCWavePath + ",";
					_sRcList += _oRc.sWriteCppPath + ","; //TODO write path
					_sRcList += _oRc.bEmbed + "*"; //TODO write path
					
				}
			}
				
			return _sRcList;
		}
		
		
		public static function fGetClassFromFile(_oProject: SProject,  _sSClass:String):SClass {
			if (_oProject.aImportCreated[_sSClass.split("\\").join("/")] == null) {
			//	Debug.fError("Class not found : " + _sSClass.split("\\").join("/"));
			}

			return 	_oProject.aImportCreated[_sSClass.split("\\").join("/")];
		}
		
		
		public static function fGetClassInfo(_oSClass:SClass):String {
			var _sResult : String = "";
			
			_sResult += fGetCurClassInfo(_oSClass);
			_sResult += fGetCurClassExtend(_oSClass);
			_sResult += fGetClassImport(_oSClass);
			_sResult += fGetGlobalVar(_oSClass.aGlobalVarList);
			_sResult += fGetFunction(_oSClass.aFunctionList);
			
			return _sResult;
		}
		
		
				
		public static function fGetClassPath(_oSClass:SClass):String {
			var _sPath : String  = _oSClass.sPath; 
			_sPath = _sPath.split("\\").join(".");  
			return _sPath;
		}
		
		public static function fGetFullClassPath(_oSClass:SClass):String {
			var _sPath : String  = _oSClass.sPath; 
			_sPath = _sPath.split("\\").join(".");  
			var _sFilePath : String =   _oSClass.oSLib.sReadPath + _sPath;
			_sFilePath = _sFilePath.split("\\").join("/");
			_sFilePath = _sFilePath.split(".").join("/");
			_sFilePath += _oSClass.sName + Setting.sFileExtention;
			return _sFilePath;
		}
		
			
		
		public static function fGetCurClassInfo(_oSClass:SClass):String {
			var _sResult : String = "";
			_sResult += _oSClass.sName + ":" + fGetFullClassPath(_oSClass) + ":" + _oSClass.nLine;
			
			return _sResult += "#";
		}
		
		public static function fGetCurClassExtend(_oSClass:SClass):String {
			var _sResult : String = "";
			
			var _i:UInt = _oSClass.aExtendClass.length;
			for (i in 0 ..._i) {
				//var _oExtClass : SClass = VarExClass(_oSClass.aExClassList[i]).oExCallRef;
				var _oExtClass : SClass = _oSClass.aExtendClass[i];
/*
				var _sPath : String  = _oExtClass.sPath; 
				_sPath = _sPath.split("\\").join(".");  
				
				var _sFilePath : String =   _oExtClass.oSLib.sReadPath + _sPath;
				_sFilePath = _sFilePath.split("\\").join("/");
				_sFilePath = _sFilePath.split(".").join("/");
				_sFilePath += _oExtClass.sName + ".lnx";*/
				
				_sResult +=  _oExtClass.oSLib.sName + "." + fGetClassPath(_oExtClass) + _oExtClass.sName + ","  + _oExtClass.nLine + "," + fGetClassPath(_oExtClass);
				
				_sResult += ";";
			}
					
			return _sResult += "#";
		}
		
		
		
		public static function fGetGlobalVar(_aList:Array<Dynamic>):String {
			var _sResult : String = "";
			
			//var _aList : Array<Dynamic> = _oSClass.aGlobalVarList;
			for (j in 0 ..._aList.length) {
				var _oVar : VarObj = _aList[j];
				if (_oVar.eType == EuVarType._LineInput) {
					_oVar = cast(_oVar,LineInput).oVarInput;
				}
				if (_oVar.eType == EuVarType._SNatAttribut) {
					_oVar = cast(_oVar,SNatAttribut).oAttType;
				}
				
				var _oComVar : CommonVar = cast(_oVar);
				_sResult += _oComVar.sName + ":" + _oComVar.fGetType()  + ":" + _oComVar.nLine +  ":" + EuSharing_.fGetSharingLite(_oComVar.eSharing) + ";";
			}

			return _sResult += "#";
		}
		
		
		
		public static function fGetClassImport(_oSClass:SClass):String {
			var _sResult : String = "";
			var _aList : Array<Dynamic> = _oSClass.aSImportList;		
			
			for (i in 0 ...  _aList.length) {
				var _oImport : FileImport  = _aList[i];
				var _sPath : String  = _oImport.sPath; 
				
				_sPath = _sPath.split("\\").join(".");  
				
				var _sFilePath : String =   _oImport.oSLib.sReadPath + _sPath;
				_sFilePath = _sFilePath.split("\\").join("/");
				_sFilePath = _sFilePath.split(".").join("/");
				_sFilePath += _oImport.sName + Setting.sFileExtention;
				
				_sResult +=  _oImport.oSLib.sName + "." + _sPath + _oImport.sName + ","  + _oImport.oRefClass.nLine + "," + _sFilePath + ";";
			}
			return _sResult + "#";
		}
		
		
		public static function fGetFunction(_aList:Array<Dynamic>):String {
			var _sResult : String = "";
			//var _aList : Array<Dynamic> = _oSClass.aFunctionList;
			for (i in 0 ...  _aList.length) {
				var _oFunction : SFunction  = _aList[i];
	
				//_sResult +=  _oFunction.sName + "&" + _oFunction.nLineNum + "&" + CommonVar(_oFunction.oReturn).fGetType() + "&"  + fGetFunctionParam(_oFunction.aParamList)  + ";";
				_sResult +=  fGetFunctionVar(_oFunction);
				
			}
			return _sResult + "#";
		}
		
		public static function fGetFunctionVar( _oFunction : SFunction ):String {
			if (_oFunction != null) {
				//return  _oFunction.sName + "&" + _oFunction.nLineNum + "&" + CommonVar(_oFunction.oReturn).fGetType() + "&"  + fGetFunctionParam(_oFunction.aParamList)  + ";";
				var _oReturn : VarObj = _oFunction.oReturn;
				if (_oReturn != null) { //TODO
					return  _oFunction.sName + "&" + _oFunction.nLineNum + "&" + _oReturn.fGetType() + "&"  + fGetFunctionParam(_oFunction.aParamList)  + ";";
				}
				
			}
			
			return "";
			
		}
		
		
		
		public static function fGetFunctionParam(_aParam:Array<Dynamic>):String {
			
			var _sResult : String = "";

			for (i in 0 ...  _aParam.length) {
				var _oParam : VarObj  = _aParam[i];
				if(Std.is(_oParam, CommonVar)){
					var _oComVar : CommonVar = cast(_oParam);
					_sResult +=  _oComVar.sName + ":"  + _oComVar.fGetType() + ":" + _oComVar.nLine;
					
					_sResult += ",";
				}
			}
			return _sResult;
		}
		
		
		
		//public static var nScopeLevel : Int = 0;
		public static function fIsScopeChange(_oSClass:SClass, _nLine:UInt, _nLastLine:UInt):String {
		//	nScopeLevel = -1;
			oLastBloc = null;
			//var _sResult : String = "";
			var _oFunc : SFunction = null;
			ExtractBlocs.extractClassFunctions(_oSClass);
			
			for ( _oFunction  in _oSClass.aFunctionList){//SFunction
				if (_oFunction) {
					//Debug.fAssist("FuncLine " +  _oFunction.nLine + " <=  " + _oFunction.nLastLine +  " : "  +_nLine );
				//	_sResult += _oFunction.sName + " "  + _oFunction.nLine + " L " + _oFunction.nLastLine + " ";
					if (_nLine >= _oFunction.nLine && _nLine <= _oFunction.nLastLine) {
						_oFunc = _oFunction;
					//		Debug.fAssist("OKi " + _oFunc.sName);
						break;
					}
				}
			}

			if (_oFunc != null) {
		//		nScopeLevel = 1;
				return _oFunc.sName + ":" + _oFunc.nLine + ":" +  _oFunc.nLastLine + "|" +  fGetBlocScope(_oFunc, _nLine) ;
			}
			return "";
		}
		

		public static var oLastBloc : SBloc = null;
		public static function fGetBlocScope(_oContainer:SBloc, _nLine : UInt):String {
		//	nScopeLevel++;
			var _sResult : String = "";
			if (_oContainer.nLine <= _nLine && _oContainer.nLastLine >= _nLine) {
				oLastBloc = _oContainer;
				for (  _oContVar   in _oContainer.aVarList) {//VarObj
					var _oCommonVar : CommonVar;
					if (_oContVar.eType == EuVarType._ParamInput) {
						_oCommonVar = cast(_oContVar,ParamInput).oVarInput;
					}else {
						_oCommonVar = cast(_oContVar);
					}
					
					if (_oCommonVar.nLine <= _nLine) {
						_sResult +=  _oCommonVar.sName + ":"  + _oCommonVar.fGetType() + ":" + _oCommonVar.nLine + ",";
					}
				}
				for (  _oSBloc   in _oContainer.aBlocList) {//SBloc
					
					_sResult += fGetBlocScope(_oSBloc, _nLine);
				}
			}
			return _sResult;
		}
		
		
		
		
		
		public static var bNoErrror : Bool = false;
		public static function fGetRelScope(_oSClass: SClass, _nLine : UInt, _sLine:String):String {
			//Debug.fError("Test fGetRelScope   " +_sLine);
			bNoErrror = true;

			var _sResult : String = _sLine + "|";
			fIsScopeChange(_oSClass, _nLine, 0);
			var _oSBloc : SBloc = oLastBloc;
			
			ExtractBlocs.oCurrSClass = _oSClass;
			ExtractBlocs.nCurrLine = _nLine;
			ExtractLines.oLastLookInBloc = null;
			
			if (oLastBloc == null) {
				Debug.fError("Scope not found" );
				return _sResult;
			}else {
				//Debug.fError("Scope found " + oLastBloc.oSClass.sName );
			}
			
			_sLine += "_"; //Be sure to bug to the curr expression  //Todo remove to the dot if not xxx._
			
			try{
				ExtractLines.newLineSet(_oSBloc, _sLine, _nLine,EuVarType._None,null,false,EuOperator.None);
				
			} catch (err:String) {

				if (err.charAt(0) == ":") { //My errors
					//Debug.fError("Func Internal Error: " + err.message);
					Debug.fAssist("RelScope Internal Error: " + _sLine);
				}else {
					//	Debug.fAssist("RelScope Internal Error: " + _sLine)
					Debug.fError("RelScope Internal Error: " + err);
					throw err; //throw away
				}
			}
			if(ExtractLines.oLastLookInBloc != null){
				_sResult += fGetVarObjInfo(ExtractLines.oLastLookInBloc);
			}else {
				Debug.fError("oLastLookInBloc was null : " + _sLine );	
			}
			
			bNoErrror = false;
			return _sResult;
			//return _sResult += "|" + _sLine;
		}
		
		public static function fGetFunctionInfo(_oSClass: SClass, _nLine : UInt, _sLine:String):String {
			fGetRelScope(_oSClass, _nLine, _sLine + "()");
			var _sResult : String = "Error2 on : " + _sLine;
			var _oSFunc : SFunction = null;
			if (ExtractLines.oLastLookInBloc == null) {
				return  "Error1 on : " + _sLine;
			}
			if (ExtractLines.oLastLookInBloc.eType == EuVarType._FuncCall) {
				_oSFunc = cast(ExtractLines.oLastLookInBloc,FuncCall).oFunction;
			}else if (ExtractLines.oLastLookInBloc.eType == EuVarType._Function) {
				_oSFunc = cast(ExtractLines.oLastLookInBloc);
			}
			if (_oSFunc == null) {
				return  "Error2 on : " + _sLine;
			}
			var _oSClass : SClass = _oSFunc.oSClass;
			var _sClassInfo : String = fGetCurClassInfo(_oSClass);
			_sClassInfo = _sClassInfo.substring(0, _sClassInfo.length - 1); //Remove #
			_sResult = _sClassInfo + "|" +   fGetFunctionVar(_oSFunc);
			
			return _sResult;
		}
		
		
		
		public static function fGetVarObjInfo(_oVar: VarObj):String {
			switch(_oVar.eType) {
				case EuVarType._SClass :
					return "Class|" + fGetClassInfo(cast(_oVar,SClass));
				//break;
				case EuVarType._CallClass :
					return "Class|" +  fGetClassInfo(cast(_oVar,VarCallClass).oCallRef);
				//break;
				case EuVarType._StaticClass :
					return "Class|" +  fGetClassInfo(cast(_oVar,VarStaticClass).oRefClass);
				//break;
				
				case EuVarType._String :

					return fGetNativeInfo(SGlobal.aNAString,  SGlobal.aNFString);	
				//break;
				default:
				
			}
			return "Unknow LocVar: " + _oVar.eType;
		}
		
		
		
		public static function fGetNativeInfo(_aAtt:Array<Dynamic>, _aFunc:Array<Dynamic>):String {
			
			var _sReturn : String = "Native|";
			_sReturn += fGetGlobalVar(_aAtt);
			_sReturn += fGetFunction(_aFunc);
			return _sReturn;
		}
		
		
		
		
		
		
		
		
		/*
		public static function fGetFuncParam(_oFunc:SFunction):String {
			var _sResult : String = "";
			for (var _oVar : CommonVar in _oFunc.aParamList) {
				_sResult += _oVar.sName + ", ";
			}
			return _sResult;
		}*/
		
		
		
	}

