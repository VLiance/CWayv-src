package language.project.convertSima;
import language.base.Debug;
import language.base.Root;
import language.enumeration.EuVarType;
import language.pck.FileImport;
import language.pck.SLib;
import language.project.convertCpp.DefHeaderFile;
import language.vars.varObj.VarCallClass;
import language.vars.varObj.VarStaticClass;

/**
 * ...
 * @author Maeiky
 */
class SPackage extends SBloc
{
		public var sGenerateTag : String = "";
	
		public var nPackageLine : UInt;
				public var bGenerated : Bool = false;
		
	public var oSFrame : SFrame;
		
	public var aClassList : Array<SClass> = [];
	public var oSProject : SProject;
			
	public var sReadedFilePath:String = ""; //Todo useless?
	
	public var sName : String;
	public var oSLib : SLib;
	public var sPath : String;
	public var aFile : Array<Dynamic>;
	public var bCpp : Bool = false;
	
		public var bDefHeader : Bool = false;
		public var oDefHeader : DefHeaderFile;
		
	public var isImport : FileImport;
	
	public var sHeaderName : String;
	public var sFilePath : String;
	public var aFolderList : Array<Dynamic>; //<String>
	
			public var sCppModTime : String = "";
		public var sCppGetTime : String = "";
		
		
		public var oDebugImport : FileImport;
		public var oClassImport : FileImport;
		public var oThreadMsgImport : FileImport;
		public var oResult_SearchImport : FileImport;

		public var aLibImport : Array<FileImport> = [];
		
	public var aSImportList : Array<FileImport> = [];
	public var aSImportListRecursive : Array<FileImport> = [];
	
	public var aSImportList_Full : Array<FileImport> = [];
	
	public var aSImportListRequireFullDefinition : Array<Bool> = [];
	
			
		public var sNamespace : String;
		public var sEndNamespace : String;
		public var sNsAccess : String; 
		public var sCNamespace : String;
		public var sCEndNamespace : String; 
		
		
		public var oMain:Root;
			
	public function new(_Main:Root, _oSProject : SProject, _aFile:Array<Dynamic>, _oSLib:SLib, _sPath:String, _sName:String, _sReadedFilePath:String) {
			oMain = _Main;
			oSProject = _oSProject;
			sReadedFilePath = _sReadedFilePath;
	

			if (_aFile != null) {

				sName = _sName;
				sPath = _sPath;
				aFile = _aFile;
				oSLib = _oSLib;
		
				
				if (oSLib.bReadOnly) {//CPP TODO MAY change
					bCpp = true;
				}
				super(null);
			
				//if (oSFrame.bSkipFile){
				//	return;
				//}
				
			//	oSLib.aClass.push(this);
				oSLib.aPackage.push(this);
				
				eType = EuVarType._SClass;
			
		

				
			//	oStaticClass = new VarStaticClass(this, isImport);//itself
			//	pushClassVar(oStaticClass); //itself

		/*			
		sHeaderName = oSLib.sWriteName + "_" + sPath.split("/").join("_") + sName;
		sFilePath = oSLib.sWriteName + "/" + sPath + sName;
		aFolderList = sFilePath.split("/");
		sNamespace = fGetNamespace();
		sEndNamespace = fEndNamespace();
		aFolderList.pop();
		sCNamespace = fGetNamespace();
		sCEndNamespace = fEndNamespace();
		sNsAccess = fGetNsAccess();
		//sFilePath = "Lib_" + sFilePath;
		*/
				
				sHeaderName = oSLib.sWriteName + "_" + sPath.split("/").join("_") + sName;
				sFilePath = oSLib.sWriteName + "/" + sPath + sName;
				aFolderList = sFilePath.split("/");
				
				sNamespace = fGetNamespace();//TODO SClass Only??
				sEndNamespace = fEndNamespace();//TODO SClass Only??
				
				aFolderList.pop();
					
				sCNamespace = fGetNamespace();
				sCEndNamespace = fEndNamespace();
				sNsAccess = fGetNsAccess();
				//sFilePath = "Lib_" + sFilePath;
				
			}
			
			
			//Default itself import
			isImport = newSImport();
			isImport.sPath = _sPath;
			isImport.sName = _sName;
			isImport.nLine = 0;
			isImport.oSLib = _oSLib;
		//	isImport.oRefClass = this;
			isImport.oRefPackage = this;
			
			if (_aFile == null){
				isImport.bVirtual = true;
			}

						

		
	

			
			if (oSProject.oGzLib == null) {
				Debug.fError("Lib null!");	
			}
			
			/* TODO INCLUDE --> recursive import
			oDebugImport = newSImport();
			oDebugImport.sPath = "Debug/";
			oDebugImport.sName = "Debug";
			oDebugImport.nLine = 0;
			oDebugImport.oSLib = oSProject.oGzLib;
			//oDebugImport.oSLib = oSProject.oGzCppLib;//ReadOnly
			*/
			/*

			oClassImport = newSImport();
			oClassImport.sPath = "Base/";
			oClassImport.sName = "Class";
			oClassImport.nLine = 0;
			oClassImport.oSLib = oSProject.oGzLib;
			//oClassImport.oSLib = oSProject.oGzCppLib;//ReadOnly
*/
						
			/*
			oThreadMsgImport = newSImport();
			oThreadMsgImport.sPath = "Base/";
			oThreadMsgImport.sName = "Class";
			oThreadMsgImport.nLine = 0;
			oThreadMsgImport.oSLib = oSProject.oGzLib; //Temp?
			*/
			
			oThreadMsgImport = newSImport();
			oThreadMsgImport.sPath = "Base/Thread/";
			oThreadMsgImport.sName = "ThreadMsg";
			oThreadMsgImport.nLine = 0;
			oThreadMsgImport.oSLib = oSProject.oGzLib; //Temp?
			//oThreadMsgImport.oSLib = oSProject.oGzCppLib;//ReadOnly
			
			oResult_SearchImport = newSImport();
			oResult_SearchImport.sPath = "Base/Result/";
			oResult_SearchImport.sName = "Result_Search";
			oResult_SearchImport.nLine = 0;
			oResult_SearchImport.oSLib = oSProject.oGzLib; //Temp?
			
			
			
			oSClass = new SClass(_Main, _oSProject,this, _sName); ///Default class (Same name as package)
			aClassList.push(oSClass); //Default class
			
					
			
			if (_aFile != null){
				oSFrame = new SFrame(_Main, _oSProject, this, _aFile, _sPath);	
			
				//if (oSLib.oLibFileImport != null){ //Copy --> TODO make other lib importe
				
				for (_oLib in oSProject.aLibList){
					
					if ( _oLib.oLibFileImport != null){ //Copy --> TODO make other lib importe
						var _oLibImport:FileImport = newSImport();
						//Debug.fTrace("¸**Lib " + oSClass.sName + " " +  oSLib.oLibFileImport.sName);
						_oLibImport.sPath = _oLib.oLibFileImport.sPath;
						_oLibImport.sName = _oLib.oLibFileImport.sName;
						_oLibImport.oSLib = _oLib.oLibFileImport.oSLib;
						_oLibImport.nLine = 0;
						
						aLibImport.push(_oLibImport);
					}
				}
			}
			
	
		}
		
		public  function fImportAs(_aList : Array<FileImport>, _sPath:String, _sName:String) :Bool {
			for (_oImport  in _aList){
				if (_oImport.sName == _sName){
					if (_oImport.sPath == _sPath){
						return true;
					}
				}
			}
			return false;
		}
		
		public function fAddRecursiveImportList(_aList : Array<FileImport>, _bRecursiveSImport = false){ //TODO don't import same file?

			for (_oImport  in aSImportListRecursive){
				if (!fImportAs(_aList, _oImport.sPath, _oImport.sName) ){
					_aList.push(_oImport);
					_oImport.oRefPackage.fAddRecursiveImportList(_aList);
					
				}
			}
			for (_oImport  in aSImportList){
				if (!fImportAs(_aList, _oImport.sPath, _oImport.sName) ){
					if (_bRecursiveSImport){
						_aList.push(_oImport);
						_oImport.oRefPackage.fAddRecursiveImportList(_aList);
					}
				}
			}
		}
	
		public function fBuildFullImportList(){
		//	Debug.fTrace("----------------------------------------------SPackage: " + sName);
			aSImportList_Full = [];
			fAddRecursiveImportList(aSImportList_Full,true);

		}
		
		public function newSImport(_bRecursive : Bool = false) : FileImport {
			var _oImport : FileImport = new FileImport();
			aSImportList.push(_oImport );
			if (_bRecursive){
				aSImportListRecursive.push(_oImport);
			}
			
		//	_oImport.oClass = this;
			_oImport.oRefPackage = this;
			_oImport.bCpp = false;
			return _oImport;
		}
		
		
		public function fHaveConstant() : Bool {
			for (_oClass in aClassList){
				if ( _oClass.aEnumList.length > 0  || _oClass.aConstList.length > 0){
					return true;
				}
			}
			return false;
		}
		
			
		public function fHaveUnit() : Bool {
			for (_oClass in aClassList){
				if ( _oClass.aUnitList.length != 0){
					return true;
				}
			}
			return false;
		}
		
		
		public function fHaveClass(_oSCompare:SClass) : Bool {
			for (_oClass in aClassList){
				if ( _oClass == _oSCompare){
					return true;
				}
			}
			return false;
		}
		public function fHaveStackType() : Bool {
			for (_oClass in aClassList){
				if ( _oClass.bIsPod  || _oClass.bIsVector  || _oClass.bIsResults ){
					return true;
				}
			}
			return false;
		}
		public function fHaveIsAllStackType() : Bool {
			for (_oClass in aClassList){
				//if ( !( _oClass.bIsVector  || _oClass.bIsResults) ){
				if ( !( _oClass.bIsResults) ){
					return false;
				}
			}
			return true;
		}
		
		public function fGetClassName(_sSearch:String) : SClass {
				for (_oClass in aClassList){
				if ( _oClass.sName == _sSearch){
					return _oClass;
				}
			}
			return null;
			
		}
		public function fGetNsAccess() :String {
		//	var _sNamespace : String = "::";
			//var _sNamespace : String = "Lib_";
			var _sNamespace : String = "";
			for ( _sFolder in aFolderList) {
				_sNamespace +=  _sFolder + "::";
			}
			return _sNamespace;
		}
		
		public function fGetNamespace() :String {
			var _sNamespace : String = "";
			//var _sFirstIsLib: String = "Lib_";
			
			for ( _sFolder  in aFolderList) {
				_sNamespace += "namespace "  + _sFolder + "{";
			//	_sFirstIsLib = "";
			}
			return _sNamespace;
		}
		public function fEndNamespace() :String {
			var _sNamespace : String = "";
			for ( _sFolder in aFolderList) {
				_sNamespace += "}";
			}
			return _sNamespace;
		}
		
		public  var bHaveExtractedDefaultClass : Bool = false;
		public function fAddClass(_sName :String){
			
			if (_sName == "" || _sName == sName){
				if (!bHaveExtractedDefaultClass){
					bHaveExtractedDefaultClass = true;
				//	Debug.fTrace("------ADD " + sName + " : " + _sName );
					return oSClass; //This is the default class package, //todo test if we already associtate?
				}else{
					Debug.fFatal("Already extract default class " + sName + " : " + _sName );
					return null;
				}
			}else{
				var _oSClass : SClass =  new SClass(oMain, oSProject, this, _sName);
				aClassList.push(_oSClass);
				return _oSClass;
			}
			
			
		}
		
		
		public function fReload(){
			oSProject.loadFileImport(aSImportList);
			for (_oClass in aClassList){
				_oClass.fReload();
			}
		}
		public function fExtractClasFunction(){
			for (_oClass in aClassList){
				ExtractBlocs.extractClassFunctions(_oClass);
			}
		}
		
		/*fHaveStackType()){
				aSImportListRequireFullDefinition[aSImportList.length - 1] = true;
			}*/
		
			
		public function fAddImportFullDefinitionFromStrackType():Void {
			for (i in 0 ... aSImportList_Full.length) {
				var _oImport : FileImport = aSImportList_Full[i];
				if (_oImport.oRefPackage.fHaveStackType()) {
					aSImportListRequireFullDefinition[i] = true; //TODO break?
				}
			}
		}
		
		public function fAddImportFullDefinition(_oSClass:SClass):Void {
			for (i in 0 ... aSImportList_Full.length) {
				var _oImport : FileImport = aSImportList_Full[i];
				if (_oImport.oRefPackage.fHaveClass(_oSClass)) {
					aSImportListRequireFullDefinition[i] = true; //TODO break?
				}
			}
		}
		
		public function fAddImportFullDefinition_AtomicFunc():Void {

			for (_oSClass in aClassList){
				for ( _oFunc  in _oSClass.aAtomicFunc) {
					
					for ( _oParam  in _oFunc.aParamList) {
									
						if (_oParam.eType == EuVarType._CallClass && !cast(_oParam, VarCallClass).oCallRef.bIsVector ){
						//	Debug.fFatal("here:"  +   _oParam.fGetName() + " :  " +  _oSClass.sName);
							fAddImportFullDefinition(cast(_oParam, VarCallClass).oCallRef);
						}
					}
				}
			}
		}
		
		
}