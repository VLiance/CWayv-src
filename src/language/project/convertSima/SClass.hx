package language.project.convertSima;

	import language._system.FileSys;
	import language.enumeration.EuBetween;
	import language.enumeration.EuClassType;
	import language.enumeration.EuConstant;
	import language.enumeration.EuCppLineType;
	import language.enumeration.EuSharing;
	import language.MyFile;
	import language.enumeration.EuOperator;
	import language.pck.FileImport;
	import language.enumeration.EuLocation;
	import language.enumeration.EuVarType;
	import language.pck.SLib;
	import language.project.convertCpp.ConvertLines;
	import language.project.convertCpp.DefHeaderFile;
	import language.project.convertCpp.HeaderFile;
	import language.project.SProject;
	import language.Text;
	import language.vars.special.EnumObj;
	import language.vars.special.UnitObj;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.Delegate;
	import language.vars.varObj.ExtendFunc;
	import language.vars.varObj.ExtendVar;
	import language.vars.varObj.LineObj;
	import language.vars.varObj.VarCallClass;
	import language.vars.varObj.VarCppLine;
	import language.vars.varObj.VarExClass;
	import language.vars.varObj.VarObj;
	import language.vars.varObj.VarStaticClass;
	import language.base.Root;
	import language.base.Debug;
	//import sys.io.File;


	class SClass extends SBloc {

		
		public var sPtrCFuncName : String;
		public var sCFuncName : String;
		public var sNamespace : String;
		public var sEndNamespace : String;
		public var sNsAccess : String; 
		public var sCNamespace : String;
		public var sCEndNamespace : String; 
		
		
		
		public var eClassType : EuClassType = EuClassType.Invalid;
				
		public var bDefaultConstrutorGenereted : Bool = false;
		public var sConstructLineToExtract : String = "";
		

		public var bIsProcessed : Bool = false; //Generic flag to not process multiple time the same class
		
		public var bExtension : Bool = false;
		public var bOverclass : Bool = false;
		public var bAtomic : Bool = false;
		public var bIsPod : Bool = false;
		public var bIsVector : Bool = false;
		public var bIsResults : Bool = false;
		public var bThread : Bool = false;
		public var sThreadClass : String = "";
		public var oThreadClass : SClass;
		public var bCpp : Bool = false;
		public var bIsCustomCppString : Bool = false;

		
		//public var oSFrame : SFrame;
	
		public var sName : String;
		public var oSLib : SLib;
	//	public var sPath : String;
		public var nBeginLine : UInt;
		public var oStaticClass : VarStaticClass;
		
		
	//	public var aSImportList : Array<Dynamic> = [];
		//public var aSImportListRequireFullDefinition : Array<Dynamic> = [];
	

		public var aDelegateList: Array<Dynamic> = [];
		public var aDelegateListIni: Array<Dynamic> = [];
		public var aDelegateUniqueList: Array<Dynamic> = [];
		public var aDelegateUniqueHash: Map<String, Delegate> = [""=>null] ;
		public var aDelegateExist: Array<Dynamic> = [];
		
		public var aFixeVarList: Array<Dynamic> = [];
		public var aGlobalVarList: Array<CommonVar> = [];
		public var aHashGlobalVarList: Map<String,Bool> = [""=>false];
		
		public var aStaticVarList: Array<Dynamic> = [];
		public var aClassVarList: Array<Dynamic> = [];
		public var aGateVarList: Array<Dynamic> = [];
		
		public var aAtomicVarList: Array<Dynamic> = [];
		public var aAtomicVarListIniString: Array<Dynamic> = [];
		
		public var aAtomicFunc: Array<SFunction> = [];
		
		public var aAssociateVarList: Array<Dynamic> = [];
		
		public var aGlobalVarListIniString : Array<Dynamic> = [];
		public var aStaticVarListIniString : Array<Dynamic> = [];
		
		public var aIniConstVarList: Array<Dynamic> = [];
		public var aIniStaticVarList: Array<Dynamic> = [];
		public var aIniGlobalVarList: Array<Dynamic> = [];
				
		public var aNotIniConstVarList: Array<Dynamic> = []; //Todo do error?
		public var aNotIniStaticVarList: Array<Dynamic> = [];
		public var aNotIniGlobalVarList: Array<Dynamic> = [];
		
		public var aFunctionList : Array<SFunction> = [];
		public var aFunctionExtend : Array<Dynamic> = [];
		
		public var aPtrFuncList : Array<Dynamic> = [];
		public var aSubClassUsedList : Array<Dynamic> = [];
		public var aSubClassUsedListNotImport : Array<Dynamic> = [];
		
		
		public var aEmbedFileList: Array<Dynamic> = [];
		
		public var aInlineBloc: Array<Dynamic> = [];
		public var aInlineIndex : Array<Dynamic> = [];
		
		public var aEmbedVarList: Array<Dynamic> = [];

		public var aAllVarList: Array<Dynamic> = [];
		public var aUnitList: Array<Dynamic> = [];
		public var aEnumList: Array<Dynamic> = [];
		public var aHashEnumList: Map<String,Bool> = [""=>false];
		public var aConstList: Array<Dynamic> = [];

		public var aUseEnumIniStringFirst : Array<Dynamic> = [];
		public var aUseEnumIniStringAfter : Array<Dynamic> = [];
		
		public var aUseUnitIniStringFirst : Array<Dynamic> = [];
		public var aUseUnitIniStringAfter : Array<Dynamic> = [];
		
		
		public var aUseUnitList: Array<Dynamic> = [];
		public var aUseEnumList: Array<Dynamic> = [];
		
		public var aExtendVarList: Array<Dynamic> = [];

		public var aExClassList: Array<Dynamic> = [];
		
		
		public var sExtendNotIni : String = "";
		public var aExtendClass : Array<SClass> = []; //Current class extend
		public var aExtendAllClassList: Array<SClass> = []; //Full extend list of currnent class
		
		public var sPathBack : String;
		public var nNbFolder : UInt;
		

		public var bHaveExtend : Bool = false;
		public var bHaveOverplace : Bool = false;

		
		
		public var aWhoExtendClass : Array<Dynamic> = [];
		
		public var oExtend : SClass;

	
		public var oFuncConstructor : SFunction;
		public var oFuncDestrutor : SFunction;
		
		public var oHeaderFile : HeaderFile;
		
		public var oSProject : SProject;

		

		public var bFuncExtracted : Bool = false;
		
		//public var sHeaderName : String;
		public var sFilePath : String;
		public var aFolderList : Array<Dynamic>; //<String>
		

//		public var sNamespace : String;
//		public var sEndNamespace : String;
		
//		public var sNsAccess : String; 
		
		
		public var aCppLineListNormal : Array<Dynamic> = [];
		public var aCppLineListHeader : Array<Dynamic> = [];
		public var aCppLineGlsl : Array<Dynamic> = [];
		
		public var aCppLineListClass : Array<Dynamic> = [];
		public var aCppLineListClass_H : Array<Dynamic> = [];
		public var aCppLineListClass_H_aft : Array<Dynamic> = [];
		public var aCppLineInitializerList_H : Array<VarCppLine> = [];
		public var aCppLinePreInitializerList_H : Array<VarCppLine> = [];
		public var aCppLineInitializer_H : Array<VarCppLine> = [];
		
		public var aCppLineListNamespace : Array<Dynamic> = [];
		public var aCppLineListNamespace_H : Array<Dynamic> = [];
		public var aCppLineListNamespace_End_H : Array<Dynamic> = [];
		
		public var aCppLineListStatic : Array<Dynamic> = [];
		public var aCppLineListStatic_H : Array<Dynamic> = [];
		public var aCppVecUnion : Array<Dynamic> = [];
		
		
		public var oPackage : SPackage;

		
		public var aFile : Array<Dynamic>;				
		public var isImport : FileImport;
		
	//	public var aCppLineListClassStatic : Array<Dynamic> = [];
		
	//	public var oOverplace : SClass; 
		
	//	public var sReadedFilePath:String = ""; //Todo useless?
	//	public function new(_Main:Root, _oSProject : SProject, _aFile:Array<Dynamic>, _oSLib:SLib, _sPath:String, _sName:String, _sReadedFilePath:String) {
		public function new(_Main:Root, _oSProject : SProject, _oPackage: SPackage, _sName:String) {
			super(null);
			oSProject = _oSProject;
		//	sReadedFilePath = _sReadedFilePath;
			oPackage = _oPackage;
			
			eType = EuVarType._SClass;
			sName = _sName;
			
			oSClass = this;
			oSLib = _oPackage.oSLib;
			
			sCFuncName = fGetCFuncName();
			
			sPtrCFuncName = fGetNsCFuncName(); //See also fGetObjFPtrName
			
			sNamespace = fGetNamespace();
			sEndNamespace = fGetEndNamespace();
			sCNamespace = fGetCNamespace();
			sCEndNamespace = fGetCEndNamespace();
			sNsAccess = fGetNsAccess();
			
			
			
		//	if (_aFile != null) {
/*
				sName = _sName;
				sPath = _sPath;
				aFile = _aFile;
				oSLib = _oSLib;
		
				
				if (oSLib.bReadOnly) {//CPP TODO MAY change
					bCpp = true;
				}
				super(null);
				//oSFrame = new SFrame(_Main, _oSProject, this, _aFile, _sPath);	
				//if (oSFrame.bSkipFile){
				//	return;
				//}
				
				oSLib.aClass.push(this);
				*/

			
/*
				//Default itself import
				isImport = newSImport();
				isImport.sPath = _sPath;
				isImport.sName = _sName;
				isImport.nLine = 0;
				isImport.oSLib = _oSLib;
				isImport.oRefPackage = oPackage;
	*/			
				oStaticClass = new VarStaticClass(this, oPackage.isImport, this);//itself
				pushClassVar(oStaticClass); //itself

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
		//	}
			/*
			if (oSProject.oGzLib == null) {
				Debug.fError("Lib null!");	
			}*/
			
			/*
			oDebugImport = newSImport();
			oDebugImport.sPath = "Sys/";
			oDebugImport.sName = "Debug";
			oDebugImport.nLine = 0;
			//oDebugImport.oSLib = oSProject.oGzLib;
			oDebugImport.oSLib = oSProject.oGzCppLib;//ReadOnly
			
			oClassImport = newSImport();
			oClassImport.sPath = "";
			oClassImport.sName = "Class";
			oClassImport.nLine = 0;
			//oClassImport.oSLib = oSProject.oGzLib;
			oClassImport.oSLib = oSProject.oGzCppLib;//ReadOnly

			
			oThreadMsgImport = newSImport();
			oThreadMsgImport.sPath = "";
			oThreadMsgImport.sName = "ThreadMsg";
			oThreadMsgImport.nLine = 0;
		//	oThreadMsgImport.oSLib = oSProject.oGzLib; //Temp?
			oThreadMsgImport.oSLib = oSProject.oGzCppLib;//ReadOnly
			*/
			
			
		}
		
		
		
		
		//Cpp optimise compilation must know all sub class used
		public function addSubClassUsed(_oSClass:SClass):Bool {
			var _i : Int = aSubClassUsedList.length;
			for (i in 0 ... _i) {
				if (_oSClass == aSubClassUsedList[i]) {
					return false;
				}
			}
			aSubClassUsedList.push(_oSClass);
			

			for (_oFileImport in oPackage.aSImportList_Full) {
				
				if ( _oFileImport.oRefPackage.fHaveClass(_oSClass) ) {
					return false;
				}
			}
			aSubClassUsedListNotImport.push(_oSClass);
			
			return true;
		}
		
		
		public function pushGlobalVar(_oVar:CommonVar, _sInitialistion:String):Void {
			
			if (_oVar == null){
				Debug.fBreak();
			}
			
			_oVar.nId = aGlobalVarList.length;
			_oVar.eLocation = EuLocation.Global;
			aGlobalVarList.push(_oVar);
			aHashGlobalVarList[_oVar.sName] = true;
			aGlobalVarListIniString.push(_sInitialistion);
			aAllVarList.push(_oVar);
			if (_oVar.eType == EuVarType._CallClass) { //Spécial case
				cast(_oVar,VarCallClass).bScopeOwner = true;
			}
		}
		public function pushStaticVar(_oVar:CommonVar, _sInitialistion:String):Void {
			
			if (_oVar == null){
				Debug.fBreak();
			}
			
			_oVar.nId = aStaticVarList.length;
			_oVar.eLocation = EuLocation.Static;

			aStaticVarList.push(_oVar);
			aStaticVarListIniString.push(_sInitialistion);
			if (_oVar.eType == EuVarType._Gate) {
				aGateVarList.push(_oVar);
			}


			aAllVarList.push(_oVar);
			if (_oVar.eType == EuVarType._CallClass) { //Spécial case
				cast(_oVar,VarCallClass).bScopeOwner = true;
			}
			if (_oVar.eConstant == EuConstant.Constant) {
				aConstList.push(_oVar);
			}
		}
		
		public function pushAtomicVar(_oVar:CommonVar, _sInitialistion:String):Void {
			if (_oVar == null){
				Debug.fBreak();
			}
			

			_oVar.nId = aAtomicVarList.length;
			_oVar.eLocation = EuLocation.Atomic;
			
			aAtomicVarList.push(_oVar);
			aAtomicVarListIniString.push(_sInitialistion);
			if (_oVar.eType == EuVarType._Gate) {
				aGateVarList.push(_oVar);
			}

			aAllVarList.push(_oVar);
			//aStaticVarList.push(_oVar); //Not sure
		}
		
		
		
		
		public function pushClassVar(_oVar:CommonVar):Void {
			if (_oVar == null){
				Debug.fBreak();
			}
			
			_oVar.nId = aClassVarList.length; //Maybe change to class id 
			_oVar.eLocation = EuLocation.DispoClass;
			aClassVarList.push(_oVar);
			aAllVarList.push(_oVar);
		}
		public function pushFixeVar(_oVar:CommonVar):Void {
			
			_oVar.nId = aFixeVarList.length; //Maybe change to class id 
			_oVar.eLocation = EuLocation.Constant;
			aFixeVarList.push(_oVar);
		}
		public function pushAssociateVar(_oVar:VarObj):Void {
			aAssociateVarList.push(_oVar);
		}
		
		
		public function pushEnum(_oVar:EnumObj):Void {

			aEnumList.push(_oVar);
			aHashEnumList[_oVar.sName] = true;
			_oVar.oSClass = this;
		}
		
		
		public function pushUnit(_oVar:UnitObj):Void {
			//Make esdy find?
			//	aCurrentUnit[cUnitListName] = _sUnitName
			//aCurrentClassUnitName[_sUnitName] = _nId; //Easy find
			aUnitList.push(_oVar);
			_oVar.oSClass = this;
			//aAllVarList.push(_oVar);
		}
		
		
		
		
		public function pushIniVar(_aLoc:Array<Dynamic>, _oVar:VarObj, sIni:String, _aLocNotIni:Array<Dynamic>):Void {
			
			if (Text.stringNotEmpty(sIni)) {
				var _oLine : VarObj  = ExtractLines.newLineSet(this, sIni, cast(_oVar,CommonVar).nLine, EuVarType._LineInput, _oVar,false,EuOperator.None);
				_aLoc.push(_oLine);
			}else {
				var _eType : EuVarType = _oVar.eType;
				//ADD TO INITIALISATION
				if(_eType == EuVarType._String || _eType == EuVarType._Rtu ||  _eType == EuVarType._RtuMap || _eType == EuVarType._DArray || _eType == EuVarType._DataArr|| _eType == EuVarType._ArrayView   || _eType == EuVarType._FixeArray  || _eType == EuVarType._QueueArray  ||  _eType ==  EuVarType._QElement){
					_aLoc.push(_oVar);
				}else {
					_aLocNotIni.push(_oVar);
				}
			}
		}
	
			/*
		public function newSImport() : FileImport {
			var _oImport : FileImport = new FileImport();
			aSImportList.push(_oImport );
			_oImport.oClass = this;
			_oImport.bCpp = false;
			return _oImport;
		}
*/
		
		
		
		public function getClassExtends():Void {
			if (sExtendNotIni == "") {
				
				if(sName != "Class" && !bIsPod && !bIsResults  && !bIsVector){
					var oExtend : SClass = SFind.findClass(this, "Class");
					aExtendClass.push(oExtend);
				}
				
				if (sName != "Result" && bIsResults ){
				
						var oExtend : SClass = SFind.findClass(this, "Result");
						aExtendClass.push(oExtend);
					
				}

				
			//}else if (sExtendNotIni.indexOf("\"") != -1) {	
			}else if (sExtendNotIni.charAt(0) == '"') {

					var oExtend : SClass =  new SClass(oSProject.Main, oSProject, oPackage, Text.between3(sExtendNotIni, 1, EuBetween.EndString));
					
					
					oExtend.bIsCustomCppString = true;
					//SFind.findClass(this, "Class");
					aExtendClass.push(oExtend);
				
			}else{

				var _aStrList : Array<Dynamic> = sExtendNotIni.split(",");
			
				var _i:UInt = _aStrList.length;
				for (i in 0 ..._i) {
					var _sExtend : String = Text.between3(_aStrList[0], 0, EuBetween.Word);
					if(_sExtend != ""){
						var _oExtend : SClass = SFind.findClass(this, _sExtend);
						aExtendClass.push(_oExtend);
						_oExtend.aWhoExtendClass.push(this);
						if (bHaveOverplace && !_oExtend.bOverclass) {
							Debug.fError("To overplace class, this one must be specified as 'overclass' : " + _oExtend.sName );
							ExtractBlocs.oCurrSClass = _oExtend;
							ExtractBlocs.nCurrLine = _oExtend.nLine;
							Debug.fError("--> Here: It must be 'overclass " + _oExtend.sName + "'"); //SubError?
							ExtractBlocs.oCurrSClass = this; //Reset
							ExtractBlocs.nCurrLine = nLine; //Reset
						}
						if (!bHaveOverplace && _oExtend.bOverclass) {
							Debug.fError("Cannot extend an 'overclass' : " + _oExtend.sName );
							ExtractBlocs.oCurrSClass = _oExtend;
							ExtractBlocs.nCurrLine = _oExtend.nLine;
							Debug.fError("--> Here: " + _oExtend.sName + "'"); //SubError?
							ExtractBlocs.oCurrSClass = this; //Reset
							ExtractBlocs.nCurrLine = nLine; //Reset
						}
						
						if (_oExtend.sName == "EntryPoint"){
							var _oLib : SLib = _oExtend.oSLib;
							if (_oLib.sIdName == "GZ"){
							//	Debug.fFatal("aaok");
								if (oSProject.oEntryPoint == null){
									oSProject.oEntryPoint = this;
								}else{
									Debug.fFatal("Multiple Entry Point in: " + oSClass.sName + " & " + oSProject.oEntryPoint.sName );
								}
								
							}
						}
						

					}
				}
			}
		}
		
				
		public function loadAllExtended():Void {
			
			
			//Debug.fTrace("--InClass : " + this.sName);
			loadExtended(this);
			//Debug.fTrace("-----------" );
			//fCreateVarExClass();
			
		}
		
		
		
		public function fCreateVarExClass():Void {
			

			var _i:UInt = aExtendAllClassList.length;
			for (i in 0 ..._i) {
				var _oSClass : SClass = aExtendAllClassList[i];
				aExClassList.push(new VarExClass(this, _oSClass)); 
				loadExtendedClassVar(_oSClass);
				loadExtendedClassFunction(_oSClass);
			}
			
		}
		
		
		private function loadExtended(_oSourceClass : SClass):Void {
			var _aExtend : Array<SClass> = _oSourceClass.aExtendClass;

			var _i:UInt = _aExtend.length;
			for (i in 0 ..._i) {
				var _oClass : SClass = _aExtend[i];
			
				
				aExtendAllClassList.push(_oClass);
				loadExtended(_oClass); //load all var in fowllowing extended class
			}
		}
		
		private function loadExtendedClassVar(_oClassExtend:SClass):Void {
			
			var _aList : Array<Dynamic> = _oClassExtend.aGlobalVarList;
			var _aAtomicList : Array<Dynamic> = _oClassExtend.aAtomicVarList;
			
			_aList = _aList.concat(_aAtomicList);
			
			var _i:UInt = _aList.length;
			for (i in 0 ..._i) {
				var _oVar : CommonVar = _aList[i];
				if (_oVar.eSharing == EuSharing.Public || _oVar.bAtomic) {
					var _oExtend : ExtendVar = new ExtendVar(this, _oVar, _oClassExtend); //TODO check subextend
					aAllVarList.push(_oExtend);
					aExtendVarList.push(_oExtend);
						

				}
			}
			
		}
		
		
		private function loadExtendedClassFunction(_oClassExtend:SClass):Void {
			//Debug.trace("--ExClass : " + _oClassExtend.sName);
			var _aList : Array<Dynamic> = _oClassExtend.aFunctionList;
			var _i:UInt = _aList.length;
			for (i in 0 ..._i) {
				var _oFunc : SFunction = _aList[i];
				if (_oFunc.eSharing == EuSharing.Public) {
					var _oExtendFunc : ExtendFunc = new ExtendFunc(this, _oFunc); //TODO check subextend
					aFunctionExtend.push(_oExtendFunc);
						//Debug.trace("laod : " + _oFunc.sName);
				}
			}
		}
			
			
		
		public function pushInline(_oBloc:SBloc):Void {
			aInlineBloc.push(_oBloc);
			aInlineIndex.push(_oBloc.aLineList.length);
		}
		
		/*
		public function fIsClassImport(_oSClass:SClass):Bool {
			var _i:UInt = aSImportList.length;
			for (i in 0 ..._i) {
				var _oFileImport : FileImport  = aSImportList[i];
			//	if (_oFileImport.oRefClass == _oSClass) {
				if (_oFileImport.oRefPackage.fHaveClass(_oSClass)) {
					return true;
				}
			}
			return false;
		}*/
		
		public function fIsBackwardHeritage(_oBackClass:SClass):Bool {
			var _aList : Array<Dynamic> = _oBackClass.aExtendClass;
			var _i:UInt = _aList.length;
			for (i in 0 ..._i) {
				var _oSCurr : SClass  = _aList[i];
				if (_oSCurr == oSClass) {
					return true;
				}
				if (fIsBackwardHeritage(_oSCurr)) {
					return true;
				}
			}
			return false;
		}
		
		public function fAddEmbedVar(_oVar : VarCallClass):Void {
			
			aEmbedVarList.push(_oVar);
		//	oPackage.fAddImportFullDefinition(_oVar.oCallRef);
		}
		
		
		public function fAddAtomicFunc(_oFunc : SFunction):Void {
			aAtomicFunc.push(_oFunc);
		}
		
		

			
		public function fReload():Void {
			
			//TODO
			oSProject.bClassLoaded = false;
			fRemoveClassData();
			
			/* TODO
			aSImportList.push(oDebugImport);
			aSImportList.push(oClassImport);
			aSImportList.push(oThreadMsgImport);
			*/
			
			fIniBloc(); //Useless?
			pushClassVar(new VarStaticClass(this, isImport, this)); //itself
				
/*			TODO
			
			
			
			var _sReadFilePath : String  = oSLib.sReadPath + sPath + sName + Setting.sFileExtention;
			_sReadFilePath = _sReadFilePath.split("\\").join("/");
		//	var _aRead : Array<Dynamic> = mFile.readFile(_sReadFilePath);
			var _aRead : Array<Dynamic> = FileSys.fGetContent(_sReadFilePath).split("\n"); // .readFile(_sReadFilePath);
			
			
*/	
			
			
			
			
		//	try{
		//TODO		oSFrame = new SFrame(oSFrame.Main, oSProject, this, _aRead, sPath);
			
				/*	
			 }catch(err:Error){
					Debug.fError("SFrame Error: " + err.message);
			}	*/
				
				
			
			//SGlobal.iniGlobal(oSFrame.Main, this); //useless?
			
			oSProject.bClassLoaded = true;
			
			var _aClassList : Array<SClass> = [];
			_aClassList.push(this);
			
			try{
				
	//TODO			LoadVarContent.loadClassVarContent(oSProject, _aClassList);
				
				
			} catch (err:String) {
				
				if (err.charAt(0) == ":") { //My errors
					Debug.fError("Internal Error: " + err);
				}else {
					throw err; //throw away
				}
			}
					
			
			if(!oSLib.bReadOnly){ //Optimisation don't extract useless fonction 
				//Debug.trace3("--------------------------");
				//Debug.trace3("In class : " + _oSClass.sName);
				
				ExtractBlocs.extractClassFunctions(this);  //Todo -> not always??
				
				//Debug.trace3("--------------------------");
			}
		
			//optimizeAll();
		}
		
		
		public function fRemoveClassData():Void {
			bFuncExtracted = false;
							
			bDefaultConstrutorGenereted  = false;
			sConstructLineToExtract  = "";
			oFuncConstructor = null;
		
			sExtendNotIni = "";
			
			fRemmoveBlocData();

			aCppLineListNormal = [];
			aCppLineListHeader  = [];
			aCppLineGlsl  = [];
			aCppLineListClass  = [];
			aCppLineListClass_H  = [];
			aCppLineListClass_H_aft  = [];
			aCppLineInitializerList_H  = [];
			aCppLinePreInitializerList_H  = [];
			aCppLineInitializer_H  = [];
			aCppLineListNamespace  = [];
			aCppLineListNamespace_H = [];
			aCppLineListNamespace_End_H = [];
			aCppLineListStatic = [];
			aCppLineListStatic_H  = [];
			aCppVecUnion  = [];
			
		//	aSImportList  = [];
		//	aSImportListRequireFullDefinition  = [];
			
			aEmbedVarList  = [];
			aAtomicFunc = [];

			aDelegateList = [];
			aDelegateListIni = [];
			aDelegateExist = [];
			
			aConstList = [];
			aFixeVarList = [];
			aGlobalVarList = [];
			aHashGlobalVarList = ["" => false ];
			aStaticVarList = [];
			aClassVarList = [];
			
			aGateVarList = [];
			
			aAtomicVarList = [];
			aAtomicVarListIniString = [];
	
			aAssociateVarList = [];

			
			aGlobalVarListIniString  = [];
			aStaticVarListIniString  = [];

			aIniConstVarList = [];
			aIniStaticVarList = [];
			aIniGlobalVarList = [];
				
			aNotIniConstVarList = [];
			aNotIniStaticVarList = [];
			aNotIniGlobalVarList = [];

			aFunctionList  = [];
			aFunctionExtend  = [];

			aPtrFuncList  = [];
			aSubClassUsedList  = [];
			aSubClassUsedListNotImport  = [];

			aEmbedFileList = [];

			aInlineBloc = [];
			aInlineIndex  = [];

			aAllVarList = [];
			aUnitList = [];
			aEnumList = [];
			aHashEnumList = [""=>false];

			aUseEnumIniStringFirst  = [];
			aUseEnumIniStringAfter  = [];

			aUseUnitIniStringFirst  = [];
			aUseUnitIniStringAfter  = [];

			aUseUnitList = [];
			aUseEnumList = [];

			aExtendVarList = [];
			aExtendAllClassList = [];
			aExClassList = [];

			aExtendClass  = [];
			aWhoExtendClass  = [];
		}
		
		public function fGetNsAccess() :String {
			return oPackage.sNsAccess; //TODO Class different name
		}
		
		public function fGetCFuncName() :String {
			var _sFuncName : String = "";
			//var _sFirstIsLib: String = "Lib_";
			if(oPackage.aFolderList != null){
				for ( _sFolder  in oPackage.aFolderList) {
					_sFuncName += _sFolder + "_";
				//	_sFirstIsLib = "";
				}
			}
			return _sFuncName + "c" + sName + "_";
		}
		
			
		public function fGetNsCFuncName() :String {
			var _sFuncName : String = "::";
			//var _sFirstIsLib: String = "Lib_";
			if(oPackage.aFolderList != null){
				for ( _sFolder  in oPackage.aFolderList) {
					_sFuncName += _sFolder + "::";
				//	_sFirstIsLib = "";
				}
			}
			return _sFuncName + sName + "::Func_";
		}
		
		
		public function fGetNamespace() :String {
			return oPackage.sNamespace; //TODO Class different name
		}
		public function fGetEndNamespace() :String {
			return oPackage.sEndNamespace; //TODO Class different name
		}
		
		
		public function fGetCNamespace() :String {
			return oPackage.sCNamespace; //TODO Class different name
		}
		public function fGetCEndNamespace() :String {
			return oPackage.sCEndNamespace; //TODO Class different name
		}
		
		public function fPushCppLine(_sCppLine : String, _eCppLineType : EuCppLineType) :Void {
				var _oCpp : VarCppLine = new VarCppLine(null, _sCppLine, _eCppLineType);
				switch(_eCppLineType) {
					
					case EuCppLineType.Normal : 
						aCppLineListNormal.push(_oCpp);
					//break;
					
					case EuCppLineType.Header : 
						aCppLineListHeader.push(_oCpp);
					//break;
					
					case EuCppLineType.Glsl : 
						aCppLineGlsl.push(_oCpp);
					//break;
					
					
					case EuCppLineType.Class : 
						aCppLineListClass.push(_oCpp);
					//break;
					
					case EuCppLineType.Class_H : 
						aCppLineListClass_H.push(_oCpp);
						
					case EuCppLineType.Class_H_Aft : 
						aCppLineListClass_H_aft.push(_oCpp);
						
					//break;
					
					case Initializer_list :
						aCppLineInitializerList_H.push(_oCpp);
						
					case PreInitializer_list :
						aCppLinePreInitializerList_H.push(_oCpp);
						
						
						
					case Initializer :
						aCppLineInitializer_H.push(_oCpp);
						
					case EuCppLineType.Namespace : 
						aCppLineListNamespace.push(_oCpp);
					//break;
					
					case EuCppLineType.Namespace_H : 
						aCppLineListNamespace_H.push(_oCpp);
						
					case EuCppLineType.Namespace_End_H : 
						aCppLineListNamespace_End_H.push(_oCpp);
					//break;
					
					case EuCppLineType.Static : 
						aCppLineListStatic.push(_oCpp);
					//break;
					
					case EuCppLineType.Static_H : 
						aCppLineListStatic_H.push(_oCpp);
					//break;

					case EuCppLineType.VecUnion:
						aCppVecUnion.push(_oCpp);
					//break;
					
					case EuCppLineType.ClassStatic : //NotUsed
						aCppLineListStatic_H.push(_oCpp);
					//break;
					default:
				}
			
		}
		
		
		
		
		
	}
