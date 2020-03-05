package language.project ;
	import language.CwmLib;
	import language.enumeration.EuBit;
	import language.pck.FileImport;
	import language.enumeration.EuVarType;
	import language.MyFile;
	import language.pck.GroupSLib;
	import language.pck.SLib;
	import language.project.convertSima.ExtractBlocs;
	import language.project.convertSima.LoadVarContent;
	import language.project.convertSima.SDelegate;
	import language.project.convertSima.SFrame;
	import language.project.convertSima.SGlobal;
	import language.project.convertSima.SPackage;
	import language.project.optimization.Optimize;
	//import language.projectData;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	import language.base.InObject;
	import language.base.Root;
	import language.base.Debug;
	import language.project.convertSima.SClass;
	
	//import sys.io.File;
	/**
	 * ...
	 * @author ...
	 */
	class SProject extends InObject 
	{
		
		
		public var oEntryPoint : SClass = null;
		
		
		public var bConvertDebug : Bool = true;
			
		public var bAddDebugUndefObjTest : Bool = false;
		
		
		public var nStringType : EuBit = EuBit.n32;
		//public var sStringType : String = "U";
		
		
		public var sMainFile : String;
		public var bClassLoaded : Bool = false;
		public var oSDelegate : SDelegate;
		public var oMainSPackage : SPackage;
	//	public var aClass : Array<Dynamic> = [];
		public var aPackage : Array<SPackage> = [];
	
		public var aClassName : Array<Dynamic> = [];
		
		//public var sCppBaseLibName : String;
		//public var sMainLib : String;
		public var oMainLib : SLib;
		public var oGzLib : SLib;
		//public var oGzCppLib : SLib;
		//public var oGzSysLib : SLib;
		
		//public var sProjectFile : String;
		public var aLibList : Array<SLib> = [];
		public var aGroupLib : Array<GroupSLib> = [];
		//public var aGroup : Array<Dynamic> = [];
		

		public var aGroupLibPresent : Array<Dynamic> = [];
		public var aGroupLibObj  : Map<String,GroupSLib> = [""=>null];
		
		public var aLibLoadAllList : Array<SLib> = [];
		public var aImportCreated : Map<String,SPackage> = [""=>null];
		public var aImportCppLoc : Map<String,SPackage> = [""=>null];
		
		public var oProjectData : ProjectData;
		
		public static var oCurr : SProject;
		
		public function new(_Main:Root,  _oProjectData:ProjectData) {
			super(_Main);
			oProjectData = _oProjectData;
			oCurr = this;
	

			/*
			var _nbFolder : UInt = mFile.countFolder(_sLibCPPPath)
			sCppBaseLibPathBack= mFile.getStringBackFolder(_nbFolder);
			*/
			

			//sCppBaseLibName = mFile.getLastFolder(_sLibCPPPath, true);
			//Debug.trace3("sCppBaseLibName : " + sCppBaseLibName);

			EuVar.VarNone = new VarObj();
			EuVar.VarNone.eType = EuVarType._None; //Create empty non var type //easiest to manipulate		
			EuVar.VarAny = new CommonVar(null, EuVarType._Any);
			EuVar.VarAny.sName = "Any";
			EuVar.VarUInt = new VarInt(null);
			EuVar.VarUInt.sName = "UInt";
			cast(EuVar.VarUInt,VarInt).bUnsigned = true;
			EuVar.VarType = new CommonVar(null, EuVarType._Type);
			EuVar.VarType.sName = "Type";

			
				
			oSDelegate = new SDelegate(this); //Create Delegate class
			
			/*
			//Get main lib
			var _nLastIndex : Int = _sProjectFile.lastIndexOf("\\", _sProjectFile.length);
			if (_nLastIndex ==  -1) {
				Debug.fError("project msut be in a folder")
				//return false;
			}
			*/
			//var _nBeginIndex : Int = _sProjectFile.lastIndexOf("\\", _nLastIndex-1);  //Temp
			//sMainLib = _sProjectFile.substring(_nBeginIndex, _nLastIndex);   //Temp
			
			//Insert lib
			//oMainLib = addLib(sMainLib,  _sCppPath, "SimaCode", false, "Example"); //Example temps
			//oCppLib = addLib(_sLibCPPPath, _sLibCPPPath, sCppBaseLibName, true, "GZ");
	
				
		}
		

		
		public function extract():Void {
			
			Debug.fTrace("eXTRACT");
			/*
			switch(nStringType) {
				case EuBit.n8:
					sStringType = "";
				//break;
				case EuBit.n16:
					sStringType = "L";
				//break;
				case EuBit.n32:
					sStringType = "U";
				//break;
			}*/
			//oProjectData.sRootPath
			//Read
			
			//Resolve parent lib
			for (_oLib in aLibList){
				_oLib.fResolveParent(this);
			}

			
			if(oMainLib != null){
				//var _aRead : Array<Dynamic> = mFile.readFile(oProjectData.sRootPath + sProjectFile + sMainFile + ".as");
				var _sReadFile : String =  oMainLib.sReadPath + sMainFile + Setting.sFileExtention;
				var _aRead : Array<Dynamic> = MyFile.readFile(_sReadFile);
				
				oMainSPackage = insertFile(_aRead, oMainLib, "", sMainFile, _sReadFile); //Load first file of the project Test.as  //Todo change test
				var _sMainFile : String = oMainLib.sReadPath + sMainFile + Setting.sFileExtention;
				_sMainFile = _sMainFile.split("\\").join("/");
				aImportCreated[_sMainFile] = oMainSPackage;    //Don't reload first file of the project Test.as	
				aImportCppLoc[oMainLib.sIdName + "/" +  sMainFile + ".cpp"] = oMainSPackage; //TODO Import?
			
			
				//Load first one then it will import all other
				loadFileImport(oMainSPackage.aSImportList);
				//loadFileImport(oMainSClass.aCppImportList, true); //Cpp
			}else{
				//dummy package
				oMainSPackage = new SPackage(Main, this, null, null, "", "", "");
				
			}
			bClassLoaded = true;
		
			////////////////////////////
			//After all class loaded////  See SClass fReload same?
			///////////////////////////
		
			
			
			SGlobal.iniGlobal(Main, this);
			Debug.fTrace("loadClassVarContent");
			LoadVarContent.loadClassVarContent(this, aPackage);
			
			
			extractAllFunctionLine();
			optimizeAll(); //TODO desactivate?
		}
		
		
		
		public function setGZE_lib():Void {
			
			//oGzLib = fFindLib("Engine_(GZ)");
			oGzLib = fFindLib("Lib_GZ");
			
			//oGzCppLib = fFindLib("Wrapper_(GZ)");
		}
		
		public function setMainLib(_oMainLib:SLib, _oSLib:SLib, _oSysLib:SLib, _sMainFile : String):Void {	
			oMainLib = _oMainLib;
			
			//Search for GZ lib
			//oGzLib = fFindLibId("GzCw");
			
			//oGzSysLib = fFindLibId("GZsys");
			
			//sProjectFile = _oMainLib.sReadPath;
			sMainFile = _sMainFile;
			//sCppBaseLibName = oCppLib.sName;
			
		
			
		}
			
		public function fTestAddFullImport():Void {	 //Add all files
/*
			for( _oLib  in aLibLoadAllList) {
				var _oTempClass : SClass = new SClass(Main, this, null,_oLib, "", "LibClass");
				for ( _sPath  in _oLib.aFileList  ) {
					SFrame.extractImport(_oLib.sName + "." + _sPath, _oTempClass, 0, _oLib); //Focre create a import from itself file to include all file, Ugly lib import TODO
				}
				
				loadFileImport( _oTempClass.aSImportList );
			}
*/
			
			for( _oLib  in aLibList) {
				var _oTempPackage : SPackage = new SPackage(Main, this, null,_oLib, "", "LibClass", "TempClass");
				for ( _oFile  in _oLib.aFileList  ) {
					//Debug.fTrace(_oFile.sPath + " ||  " + _oFile.bIsProbablyOverPlace);
		
										//	Debug.fInfo(_oFile.sPath + ":" + _oLib.bForceLoadAll + ":" +   _oFile.bIsProbablyOverPlace +  ":" + _oFile.bIsLibFile);
							
					/*
					var _bIsProbablyOverPlace : Bool = false;
					var _nIndexOp : Int = _sPath.lastIndexOf(".") + 1;
					if (_nIndexOp + 2 < _sPath.length && _sPath.charAt(_nIndexOp) == "O" && _sPath.charAt(_nIndexOp+1) == "p" && _sPath.charAt(_nIndexOp+2) >= "A"  && _sPath.charAt(_nIndexOp+2) <= "Z" ){
						_bIsProbablyOverPlace = true; //TODO  verify if this is really an overplace class
					}*/
					//Debug.fTrace("aa " + _sPath.substring(_sPath.lastIndexOf(".")+1));
					if (_oLib.bForceLoadAll || _oFile.bIsProbablyOverPlace || _oFile.bIsLibFile){
						
			
					//	Debug.fTrace("bForceLoadAll ");
						SFrame.extractImport(_oLib.sName + "." + _oFile.sCwPath, _oTempPackage, 0, _oLib, _oFile.bIsProbablyOverPlace,  _oFile.bIsLibFile); //Focre create a import from itself file to include all file, Ugly lib import TODO
					}
				}
				
				loadFileImport( _oTempPackage.aSImportList );
			}




			/*
			var _oGzEmsc : SLib = fFindLibId("GzLite");
		//	var _oGzEmsc : SLib = fFindLibId("GZemsc");
						
			var _oTempClass : SClass = new SClass(Main, this, null,_oGzEmsc, "", "LibClass");
			for (var _sPath : String in _oGzEmsc.aFileList  ) {
				SFrame.extractImport(_oGzEmsc.sName + "." + _sPath, _oTempClass, 0);
			}
			loadFileImport( _oTempClass.aSImportList );*/
		}
		
		
		
		public function fFindLib(_sLib_Name : String):SLib {
			for (i in 0 ...  aLibList.length){
				var _oSLib : SLib = aLibList[i];
			//	if (_oSLib.sIdName == _sLib_Id) {
				if (_oSLib.sName == _sLib_Name) {
					return _oSLib;
				}
			}
			Debug.fError("\"" + _sLib_Name + "\" lib not found");
			Debug.fStop();
			return null;
		}
		
		
		
		//public function addLib(_oCWMLib : CwmLib, _sReadPath:String, _sWritePath:String, _sLibName:String, _bReadOnly:Bool, _sWriteName:String = "", _sIdName:String = "", _bLoadAll : Bool = false, _sPlatform:String = ""):SLib {	
		public function addLib(_oCWMLib : CwmLib):SLib {	
			//aLibList[_sLibName] = ".as";

			var _oSLib : SLib = _oCWMLib.oLib;
			aLibList.push(_oSLib);

		
			/////** Group List **//////
			if (aGroupLibObj[_oSLib.sName] == null) {
				var _oGroup : GroupSLib = new GroupSLib();
				aGroupLibObj[_oSLib.sName] = _oGroup;
				_oGroup.sName = _oSLib.sName;
				_oGroup.sWritePath = _oSLib.sWritePath;
				_oGroup.sReadPath = _oSLib.sReadPath;
				aGroupLib.push(_oGroup);
			}
			var _oGroupSLib : GroupSLib = aGroupLibObj[_oSLib.sName];
			_oGroupSLib.fAdd(_oCWMLib.oLib);
			/////////////////////////////
			_oSLib.oGroup = _oGroupSLib;
			
			_oSLib.fIni(this);
			
			
			if (_oCWMLib.bLoadAll) {
				Debug.fTrace("bLoadAll");
				_oSLib.bForceLoadAll = true;
				aLibLoadAllList.push(_oSLib);
			}
			
			return _oSLib;
		}
		
		public function fFindLibIdName(_sLibName:String, _sPath:String):SLib {	
			var _bLibExist : Bool = false;
			var _i:UInt = aLibList.length;
			for (i in 0 ..._i) {
				var _oSLib : SLib = aLibList[i];
			
				//if (_oSLib.sName == _sLibName) { 
				if (_oSLib.sIdName == _sLibName) {
					_bLibExist = true;
					if(_oSLib.aFileListKey[_sPath]){
						return _oSLib;
					}
				}
			}
			
			if (!_bLibExist ) {
				Debug.fError("No lib ID name found for : " + _sLibName);
			}else {
				Debug.fError("In lib: " + _sLibName + ", file not found: " + _sPath);
				//Debug.fFatal("In lib: " + _sLibName + ", file not found: " + _sPath);
			}
			
			return null;
		}
		
		
		private function insertFile(_aFile:Array<Dynamic>, _oLib:SLib, _sPath:String, _sName:String, _sFilePath:String):SPackage {
			
			
			
			var _oPackage : SPackage = new SPackage(Main, this, _aFile, _oLib, _sPath, _sName, _sFilePath);
			aPackage.push(_oPackage);
			//var _oSClass : SClass = new SClass(Main, this, _aFile, _oLib, _sPath, _sName, _sFilePath);
			//if (!_oSClass.oSFrame.bSkipFile){
			//	aClass.push(_oSClass);
			//}
			return _oPackage;
			

		}
		
		

		//Step 2 --> load all other file with import list
		public function loadFileImport(_aImport:Array<FileImport>):Void {
			
			for(_oImport in _aImport){
				
				
				if (_oImport.sName == "" || _oImport.bVirtual){ //TODO _oImport.sName == "" ?? 
					continue;
				}
				
				var _oSLib : SLib = _oImport.oSLib;
				var _sLibPath : String  = _oSLib.sReadPath;
				var _sPath : String = _oImport.sPath;
				var _sName : String = _oImport.sName;
				
			
				var _sFilePath : String  = _sLibPath +_sPath + _sName + Setting.sFileExtention;
				_sFilePath = _sFilePath.split("\\").join("/");


				//Don't reImporte files already imported
				if (aImportCreated[_sFilePath] == null) { ///Dont reload same classe //Array<Dynamic> with string index, check if work in c++

					//var _aRead : Array<Dynamic> = File.getContent(_sFilePath).split("\n");
					
					var _aRead : Array<Dynamic> = MyFile.readFile(_sFilePath);
					
					
					//var _aRead : Array<Dynamic> = mFile.readFile(_sFilePath);
				//	var _oSClass : SClass = insertFile(_aRead, _oSLib, _sPath, _sName, _sFilePath); //aCurrentImport reseted
					var _oSPck : SPackage = insertFile(_aRead, _oSLib, _sPath, _sName, _sFilePath); //aCurrentImport reseted
				//	if(!_oSClass.oSFrame.bSkipFile){
						aImportCreated[_sFilePath] = _oSPck; //No repeat
						_oImport.oRefPackage = _oSPck; 
					//	loadFileImport( _oSClass.aSImportList ); //Recursive import load
						loadFileImport( _oSPck.aSImportList ); //Recursive import load
						
						aImportCppLoc[_oSLib.sIdName + "/" + _sPath + _sName + ".cpp"] = _oSPck;
				//	}

				
				}else {
					_oImport.oRefPackage = aImportCreated[_sFilePath]; 
				}
			}
		}
		
	
		
		
		//Step 4 --> extract all lines in all function
		private function extractAllFunctionLine():Void {
			
			//Debug.trace3("---Begin extract line in function---");
			//Extract all line in each function of all class 
	//			for(_oPck in aPackage){for(_oSClass in _oPck.aClassList){
				/*
				if(!_oSClass.oSLib.bReadOnly){ //Optimisation don't extract useless fonction
					Debug.trace3("--------------------------");
					Debug.trace3("In class : " + _oSClass.sName);
					
					ExtractBlocs.extractClassFunctions(_oSClass);
					
					Debug.trace3("--------------------------");
				}*/
				
			///}}
			
			//Debug.fTrace("---FinishImport----");
		}
		
		
		//Step 5 -->optimize
		private function optimizeAll():Void {
		//	Debug.fTrace("---Begin optimize line in function---");
			//Extract all line in each function of all class 
			for(_oPck in aPackage){for(_oSClass in _oPck.aClassList){

				//Debug.trace3("--------------------------");
				//Debug.trace3("In class : " + _oSClass.sName);
	
				Optimize.optimizeInline(_oSClass);
				
				//Optimize.optimizeClassFunctions(_oSClass);
			//	Debug.trace3("--------------------------");
			}}
			
			//Debug.fTrace("---FinishOptimisation----");
		}
		
		
	}
	

