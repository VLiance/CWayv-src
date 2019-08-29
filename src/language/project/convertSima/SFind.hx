package language.project.convertSima 
;
	import language.cwMake.line.CWaveArg;
	import language.cwMake.line.Rc;
	import language.CwmFile;
	import language.enumeration.EuLocation;
	import language.enumeration.EuVarType;
	import language.pck.FileImport;
	import language.pck.SLib;
	import language.project.SProject;
	import language.vars.logicObj.CompareObj;
	import language.vars.special.EnumObj;
	import language.vars.special.SNatAttribut;
	import language.vars.special.SNatFunction;
	import language.vars.special.TypeDef;
	import language.vars.special.UnitObj;
	import language.vars.special.UseEnum;
	import language.vars.special.UseUnit;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.ExtendFunc;
	import language.vars.varObj.ExtendVar;
	import language.vars.varObj.FuncCall;
	import language.vars.varObj.GateFunc;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.LineLoc;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.PtrFunc;
	import language.vars.varObj.VarCallClass;
	import language.vars.varObj.VarExClass;
	import language.vars.varObj.VarGate;
	import language.vars.varObj.VarHoldEnum;
	import language.vars.varObj.VarObj;
	import language.vars.varObj.VarStaticClass;
	import language.vars.varObj.VarString;
	import language.base.Debug;
	/**
	 * ...
	 * @author ...
	 */
	class SFind 
	{
		
		
		
		
		public static function findRcVDrive(_oSProject:SProject, _sCheckName:String):Rc { 
			var _sRcList : String = "";
			for ( _oSLib  in _oSProject.aLibList) {
				var _oCwmFile : CwmFile = _oSLib.oCwmLib.oCwmFile;
				for ( _oRc in _oCwmFile.aRc ) {
					if (_oRc.sRcName  == _sCheckName) {  //Todo detect if unused, detect from all cwm file?
						return _oRc;
					}
				}
			}
			///	Debug.fError("--");
		//	Debug.fError("Virtual Drive not found : " +_sCheckName )
		
			return null;
		}
	
		/*
		public static function findClass(_oCurrentClass:SClass, _sClassName: String):SBloc {
			
			_oCurrentClass
			return null;
		}*/
		
		public static function findExtendEnum(_oSClass:SClass, _sVar:String):VarObj { //Todo copy&fill in one current class?
			var _aExtend : Array<Dynamic> = _oSClass.aExtendAllClassList;

			var _j:UInt = _aExtend.length;
			for (j in 0 ... _j) {
				var _oExtClass : SClass = _aExtend[j];
			/*	
			if (_oSClass.sName == "OpContext") {
				Debug.fError("Ex:" + _oExtClass.sName);
			}*/
				
				var _aList : Array<Dynamic> =  _oExtClass.aEnumList;
				var _k:UInt = _aList.length;
				for (k in 0 ...  _k) {
					var _oVar : EnumObj = _aList[k];
					if (_oVar.sName == _sVar) {
						return _oVar;
					}
				}
				return findExtendEnum(_oExtClass, _sVar);
			}
			return null;
		}
		
		public static function findEnum(_oSBloc:SBloc, _sVar:String, _bIncludeUseEnum:Bool = true):VarObj {
				
			var _oClass : SClass = _oSBloc.oSClass; //Get real class
			var _aVarObjList : Array<Dynamic> =  _oClass.aEnumList;
			var _i:UInt = _aVarObjList.length;
			for (i in 0 ..._i) {
				var _oEnum : EnumObj = _aVarObjList[i];
				
				if (_oEnum.sName == _sVar) {
					return _oEnum;
				}
			}
			
			var _oVar : VarObj = findExtendEnum(_oClass, _sVar);
			if (_oVar != null && _oVar.eType != EuVarType._None) {
				return _oVar;
			}
			
			if (_bIncludeUseEnum) {
				
				_aVarObjList =  _oClass.aUseEnumList;
				var _j:UInt = _aVarObjList.length;
				for (j in 0 ... _j) {
					var _oUseEnum : UseEnum = _aVarObjList[j];
					if (_oUseEnum.oEnum.sName == _sVar) {
						return _oUseEnum;
					}
				}
			}
			
			Debug.fError("Enum not found: " + _sVar);
			return null;
		}
		
		
		public static function findUnit(_oSBloc:SBloc, _sVar:String, _bIncludeUseUnit:Bool = true):VarObj {
			
			var _oClass : SClass = _oSBloc.oSClass; //Get real class
			var _aVarObjList : Array<Dynamic> =  _oClass.aUnitList;
			var _i:UInt = _aVarObjList.length;
			for (i in 0 ..._i) {
				var _oVar : UnitObj = _aVarObjList[i];
				if (_oVar.sName == _sVar) {
					return _oVar;
				}
			}
			
			if (_bIncludeUseUnit) {
				_aVarObjList =  _oClass.aUseUnitList;
				var _j:UInt = _aVarObjList.length;
				for (j in 0 ... _j) {
					var _oUseUnit : UseUnit = _aVarObjList[j];
					var _oUnit : UnitObj = _oUseUnit.oUnit;
					if (_oUnit.sName == _sVar) {
						return _oUseUnit;
					}
				}
			}
			
			Debug.fError("can't find unit : " + _sVar + " in class: " + _oSBloc.oSClass.sName );
			Debug.fStop();

			return null;
		}
		
		
			
		public static function findEnumSubVar(_oEnum:EnumObj, _sVar:String):CommonVar {
			//		Debug.trace3("Find Enum : " + _sVar);
			//		Debug.trace3("Find Length : " +  _oEnum.aVarList.length);
			
			var _aVarObjList : Array<Dynamic> =  _oEnum.aVarList;
			var _j:UInt = _aVarObjList.length;
			for (j in 0 ... _j) {
				var _oVar : VarObj = _aVarObjList[j];
				switch(_oVar.eType) {
					case EuVarType._ParamInput:
					_oVar = cast(_oVar,ParamInput).oVarInput;
					//break;
					default:
				}
			//			Debug.trace3("Enum : " + CommonVar(_oVar).sName);
				if (cast(_oVar,CommonVar).sName == _sVar) {
					return cast(_oVar);
				}
			}
			return null;
		}
	
		public static function findUnitSubVar(_oUnit:UnitObj, _sVar:String):CommonVar {
			
			
			var _aVarObjList : Array<Dynamic> =  _oUnit.aVarList;
			var _j:UInt = _aVarObjList.length;
			for (j in 0 ... _j) {
				var _oVar : VarObj = _aVarObjList[j];
				switch(_oVar.eType) {
					case EuVarType._ParamInput:
					_oVar = cast(_oVar,ParamInput).oVarInput;
					//break;
					default:
				}
			
				if (cast(_oVar,CommonVar).sName == _sVar) {
					return cast(_oVar);
				}
			}
			return null;
		}
		
		public static function findNativeAttribut(_aLoc:Array<Dynamic>, _sVar:String):VarObj {
			
			var _j:UInt = _aLoc.length;
			for (j in 0 ... _j) {
				var _oVar : SNatAttribut = _aLoc[j];
				//PAramInput???
				//	Debug.trace2("OKAY : "  + _oVar.sName)
				if (_oVar.sName == _sVar) {
					//Debug.trace2("Found:" + _sVar)
					return _oVar;
				}
			}
			
			return null;
		}
		
		
		
		
		public static function findFuncObj(_oSource: VarObj, _sFunc:String, _bDontFail :Bool = false):VarObj {
		
			var _oFunc : SFunction;
			var _oSClass : SClass;
			var _bStatic : Bool = false;
			
			
			switch (_oSource.eType) {
				case EuVarType._StaticClass:
					_oSource = cast(_oSource,VarStaticClass).oRefClass;
					_bStatic = true;
				//break;	
				
				case EuVarType._DataArr:
					//var _aBdug : Array<Dynamic> = _aBdug[6];
					return findNativeFunction(SGlobal.aNFDataArr, _sFunc);
				//break;
				
				
				case EuVarType._DArray:
					//var _aBdug : Array<Dynamic> = _aBdug[6];
					return findNativeFunction(SGlobal.aNFArray, _sFunc);
				//break;
				
				case EuVarType._QueueArray:
					//var _aBdug : Array<Dynamic> = _aBdug[6];
					return findNativeFunction(SGlobal.aNFQueueArray, _sFunc);
				//break;

				case EuVarType._Float
				| EuVarType._Int:
					return findNativeFunction(SGlobal.aNFNumber, _sFunc);
				//break;
				
				case EuVarType._Gate:
					return findGate(cast(_oSource), _sFunc);
				//break;
				
				
				case EuVarType._String:
					return findNativeFunction(SGlobal.aNFString, _sFunc);
				//break;
				
				//case EuVarType._LineArray:
				//	return findNativeFunction(SGlobal.aNFLineArray, _sFunc);
					
				case EuVarType._FixeArray:
					return findNativeFunction(SGlobal.aNFFixeArray, _sFunc);	
				//break;
				

				case EuVarType._Number:
					return findNativeFunction(SGlobal.aNFEaseNumber, _sFunc);
				//break;
				
				
				case EuVarType._SClass:
					var _oSClass : SClass = cast(_oSource);
					if (_oSClass.bIsVector){
					
						var _oFound : VarObj = findNativeFunction(SGlobal.aNFVector, _sFunc, false);
						if (_oFound != null){
							return _oFound;
						}
					}
				default:

			}
			
			
			_oSClass =  cast(_oSource,SBloc).oSClass;
			if ((_sFunc.charAt(0) == "d") || (_sFunc.charAt(0) == "_" && _sFunc.charAt(1) == "d" )   ) { //CallFunction //todo maybe chek local 
				/*  ||  (_oSource.eType == EuVarType._LineLoc && _sFunc.charAt(0) >= "A" && _sFunc.charAt(0) <=  "Z")   A - Z Attribute Function
				if ((_oSource.eType == EuVarType._LineLoc && _sFunc.charAt(0) >= "A" && _sFunc.charAt(0) <=  "Z") ) {
					Debug.trace3("AAAAAAAAAAA : " + _sFunc);
				}*/
				return findVarObj(_oSource, _sFunc);
			
			}else if (_sFunc.charAt(0) == "t" ) { //TypeDef
				
				return findTypeDef(cast(_oSource,SBloc).oSClass.oSLib, _sFunc);
				
			}else {
				
				//Normal function
				
				//Get Extend before (important for delegate ) //TODO check if this afect other things
				//////////// Search in Entends function ////////////////
				var _aFuncObjExt : Array<Dynamic> = _oSClass.aFunctionExtend;
				var _j:UInt = _aFuncObjExt.length;
				for (j in 0 ... _j) {
					var _oFuncExt : ExtendFunc = _aFuncObjExt[j];
					if (_oFuncExt.oSFunc.sName == _sFunc) {
						if (_bStatic == _oFuncExt.oSFunc.bStatic) { //Same static/orNot loc
							return _oFuncExt;
						}else {
							//Semi found Todo better error management
						//	Debug.fError("Warning Extend function not shared are not static " + _sFunc + " in class " + _oSClass.sName )
						}
					}
				}
				///////////////////////////////////////////////////////
				
				
				//////////// Search ////////////////////////////
				var _aFuncObjList : Array<Dynamic> = _oSClass.aFunctionList;
				var _i:UInt = _aFuncObjList.length;
				for (i in 0 ..._i) {
					_oFunc = _aFuncObjList[i];
					if (_oFunc.sName == _sFunc) {
						
						//return _oFunc;
						
					
						if (_bStatic == _oFunc.bStatic) { //Same static/orNot loc
							return _oFunc;
						}else {
							
							//Semi found Todo better error management
							//Maybe a class call for non-overited fonction with same name
							return _oFunc;//	  "static_REMOVED" : //Disable static func because it break polymorphisme (sor return funct)
						}
					}
				}
				//////////////////////////////////////////////////
				
			
			}
			
			if (_bDontFail){return null; };

			//maybe a Function type
			//Debug.fError("can't find func obj for func : " + _sFunc + " in class " + _oSClass.sName  + " " + _oSource.fGetType());
			Debug.fError("can't find func obj for func : " + _sFunc + " in class " + _oSClass.sName );
			Debug.fStop();
			
			return null;
		}
		
		
			
		
		public static function findVarObj(_oSource: VarObj, _sVar:String, _oKnowToType:VarObj = null):VarObj {

			var _oVar : VarObj = EuVar.VarNone;//CW?
			var _aVarObjList : Array<Dynamic>;
			//Debug.trac("FindObj: " +_oSource.eType)
			
			if (_oKnowToType != null) { //Auto seach, exemple for enum find in the right place first ex: 	OpenGL.fGetIntegerv(MAJOR_VERSION, _nMaj); vs OpenGL.fGetIntegerv(OpenGL.eGetName.MAJOR_VERSION, _nMaj);
				switch (_oKnowToType.eType) { 

					case EuVarType._HoldEnum:
						var _oHoldEnum: VarHoldEnum = cast(_oKnowToType);
						var _oEnum : EnumObj = _oHoldEnum.oEnumRef;
						//Debug.fError("Look : " + _oEnum.sName);
						var _oSubVar : VarObj =  findEnumSubVar(_oEnum, _sVar);
						
						if (_oSubVar != null) { //Reconstruc structure
							var _oLineLoc : LineLoc = new LineLoc();
							//_oLineLoc.oSBloc = ; TODO ?
							_oLineLoc.oResultVar = _oSubVar;
							_oLineLoc.oResultingType = TypeResolve.getResultingType(_oSubVar);
							_oLineLoc.pushVar(_oEnum.oSClass.oStaticClass);
							_oLineLoc.pushVar(_oEnum);
							_oLineLoc.pushVar(_oSubVar);
							return _oLineLoc;
						}
						
					//break;
					default:
					
				}
				if (_oVar != null  && _oVar.eType != EuVarType._None) {
					return _oVar;
				}
			}
			

			//Debug.trace3("Search");
			switch (_oSource.eType) {
				
				
				case EuVarType._StaticClass:
				
					_oVar = findVarGlobalSClassStatic( cast(_oSource,VarStaticClass), _sVar);
					
				//break;
				
				case EuVarType._SClass:

					_oVar = findVarGlobalSClass( cast(_oSource,SClass), _sVar);

				//break;
				

				case EuVarType._CallClass:
					
					_oVar = findVarGlobalSClass( cast(_oSource,VarCallClass).oCallRef.oSClass, _sVar);
				//break;
				
				case EuVarType._ExClass:
					//_oVar = findVarGlobalSClass( VarExClass(_oSource).oSBloc.oSClass, _sVar);
				//break;
				
				case EuVarType._Enum:
					
					_oVar = findEnumSubVar( cast(_oSource,EnumObj), _sVar);

				//break;
				
				case EuVarType._Unit:
					
					_oVar = findUnitSubVar( cast(_oSource,UnitObj), _sVar);

				//break;
				
				case EuVarType._QueueArray:
				
					_oVar = findNativeAttribut( SGlobal.aNAQueueArray, _sVar);
				//break;	
				

				case EuVarType._QElement:
					_oVar = findNativeAttribut( SGlobal.aNAQueueElement, _sVar);
				//break;	
				
				case EuVarType._String:
					
					_oVar = findNativeAttribut( SGlobal.aNAString, _sVar);
					if (_oVar == null) {
						Debug.fError("Can't find var " + _sVar + " in " + cast(_oSource,VarString).sName);
						Debug.fStop();
					}
					
				//break;	
				
				
				case EuVarType._DataArr:
					_oVar = findNativeAttribut( SGlobal.aNADataArr, _sVar);
				//break;	
				
				case EuVarType._DArray:
					_oVar = findNativeAttribut( SGlobal.aNAArray, _sVar);
				//break;	
				
				case EuVarType._Int:
					
					_oVar = findNativeAttribut( SGlobal.aNANumber, _sVar);
				//break;	
				
				default : //Normal bloc
					
					//	var _nCharCode : Int  = _sVar.charAt(0)
				
					//1 char OR _ is local
					if (((_sVar.length == 1  && _sVar.charCodeAt(0) >  90 /*"Z"*/)  || _sVar.charCodeAt(0) == "_".code)) { //1 char minuscule
						
						/////////////
						/// LOCAL ///
						/////////////

						var _oSBloc : SBloc =  cast(_oSource);
						//////// Search in all parent bloc ////////////
						while (_oSBloc != null) { 
							_aVarObjList = _oSBloc.aVarList;
							var _i:UInt = _aVarObjList.length;
							for (i in 0 ..._i) {
								_oVar = _aVarObjList[i];
								switch(_oVar.eType) {
									case EuVarType._ParamInput:
										_oVar = cast(_oVar,ParamInput).oVarInput;
										//break;
										default:
								}
							
								if (cast(_oVar,CommonVar).sName == _sVar) {
								
									return cast(_oVar);
								}
								
							}
							_oSBloc = _oSBloc.oParentBloc;
						}
						
						//////////////////////////////////////////////
						_oVar = null;

					}else {
						
						_oVar = findVarGlobalSClass( cast(cast(_oSource,SBloc).oSClass,SClass), _sVar);
						
					}
							
							
				//break;
				
			}
			
			
			if (_oVar != null && _oVar.eType != EuVarType._None) {
				return _oVar;
			}
			
			//maybe a Function type
			//if(!CWaveArg.bManaged){
			//Debug.fError("Can't find var obj for var : " + _sVar + " in class " + SClass(SBloc(_oSource).oSClass).sName );
			Debug.fError("Can't find var obj for var : " + _sVar  );
			Debug.fFatal("Can't find var obj for var : " + _sVar  );
			//Debug.fError();
			//}
			Debug.fStop();
			
			return null;

		}

		
		
		
		private static function  findVarGlobalSClassStatic(_oStaticClass:VarStaticClass, _sVar:String):VarObj {
			
			var _aVarObjList : Array<Dynamic> =  _oStaticClass.oRefClass.aStaticVarList;
			var _j:UInt = _aVarObjList.length;
			for (j in 0 ... _j) {
				var _oVar : VarObj = _aVarObjList[j];
				switch(_oVar.eType ) {
					case EuVarType._ExtendVar :
						if (cast(cast(_oVar,ExtendVar).oVar,CommonVar).sName == _sVar) {
							return _oVar;
						}
					//break;
					
					default : 
						if (cast(_oVar,CommonVar).sName == _sVar) {
							return _oVar;
						}
					//break;
					
				}
			}
			
			
			//Search in atomic
			_aVarObjList =  _oStaticClass.oRefClass.aAtomicVarList;
			var _i:UInt = _aVarObjList.length;
			for (i in 0 ..._i) {
				var _oVar : VarObj = _aVarObjList[i];
				if (cast(_oVar,CommonVar).sName == _sVar) {
					return _oVar;
				}
			}
			
			
			//Search in enum
			_aVarObjList = _oStaticClass.oRefClass.aEnumList;
			var _i:UInt = _aVarObjList.length;
			for (i in 0 ..._i) {
				var _oEnum : EnumObj = _aVarObjList[i];
				if (_oEnum.sName == _sVar ) {
					return _oEnum;
				}
			}
			
			var _oVar : VarObj = findVarGlobalSClass(_oStaticClass.oRefClass, _sVar, false);
			if (_oVar != null){
				return _oVar;
			}
			
			Debug.fError("static var not found : " + _sVar);
			Debug.fStop();
			return null;
		}
	
		
		private static function findVarGlobalSClass(_oClass:SClass, _sVar:String, _bManageError:Bool = true):VarObj {
			
			
			if (_sVar.charAt(0) == "f") {  //PtrFunction maybe not best method
				
				var _aFuncObjList : Array<Dynamic> =  _oClass.aPtrFuncList;
				var _i:UInt = _aFuncObjList.length;
				for (i in 0 ..._i) {
					var _oPtrFunc : PtrFunc = _aFuncObjList[i];
					if (_oPtrFunc.oFunc.sName == _sVar) {
						_oPtrFunc.addInUseList(); //TODO work only if we search in convertion sima
						return _oPtrFunc;
					}
				}
			
			}else if (_sVar.charAt(0) == "e") { //Enum
					return findEnum(_oClass, _sVar, true);
					
			}else if (_sVar.charAt(0) == "x") { //ExClass
				//Debug.fStop();
					return findExClass(_oClass, _sVar);// _sVar.substring(1)); //Remove the x and search for classe
		
			}else {
				//Normal
			
				var _aVarObjList : Array<Dynamic> =  _oClass.aAllVarList;
				var _j:UInt = _aVarObjList.length;
				for (j in 0 ... _j) {
					var _oVar : VarObj = _aVarObjList[j];
					switch(_oVar.eType ) {
						case EuVarType._ExtendVar :
							if (cast(cast(_oVar,ExtendVar).oVar,CommonVar).sName == _sVar) {
								return _oVar;
							}
						//break;
						
						default : 
							if (cast(_oVar,CommonVar).sName == _sVar) {
								return _oVar;
							}
						//break;
						
					}
				}
			}
			
			if(_bManageError){
				Debug.fTrace("----");
				for ( _oVar in _oClass.aAllVarList){
					Debug.fTrace(_oVar.fGetName());
				}
				
				
				Debug.fFatal("Var not found : " + _sVar + " in class : "  + _oClass.sName);
			//	Debug.fError("Var not found : " + _sVar + " in class : "  + _oClass.sName);
				Debug.fStop();
			}
			return null;
		}
		
				
		private static function  findTypeDef(_oSLib:SLib,  _sSearch:String):VarObj {
			var _aLoc:Array<Dynamic> = _oSLib.aTypeDef;
			var _j:UInt = _aLoc.length;
			for (j in 0 ... _j) {
				var _oVar : TypeDef = _aLoc[j];
				if (_oVar.sName == _sSearch) {
					return _oVar;
				}
			}
			Debug.fError("Typedef not found : " + _sSearch + " in lib : "  +_oSLib.sName);
			return null;
		}
		
			
		//ex: 	MainThreadPlatformMsg.gMainThreadGate.fSend(new cfCreateForm(5,5)); 
		//to
		//ex: 	MainThreadPlatformMsg.gMainThreadGate.fCreateForm(5,5);
		private static function findGate(_oGate: VarGate, _sSearch:String):VarObj {
		

			
		
			var _oReturn =  findFuncObj( _oGate.oRslTemplate, _sSearch,true);
			if (_oReturn != null && Std.is(_oReturn,SFunction)) {
				return new GateFunc( _oGate.oRslTemplate,cast(_oReturn)); 
			}
			//if (_oReturn != null) {return _oReturn; }
			

			var _oResult : VarObj =  findNativeFunction(SGlobal.aNFGate, _sSearch,false); //Enable Send?
			if (_oResult == null){
				Debug.fError("Gate function not found : " + _sSearch + " in "  + _oGate.oRslTemplate.sName);
			}
			return _oResult;
		}
		
		
		private static function findNativeFunction(_aLoc:Array<Dynamic>, _sSearch:String, _bManageError:Bool = true ):VarObj {
			
			var _i:UInt = _aLoc.length;
			for (i in 0 ..._i) {
				var _oFunc : SNatFunction = _aLoc[i];
				if (_oFunc.sName == _sSearch) {
					return _oFunc;
				}
			}
			
			if(_bManageError){
				Debug.fError("Native func not found : " + _sSearch);
				Debug.fStop();
			}
			return null;
		
		}
		
		
		public static function findClass(_oSClass:SClass,  _sSearch:String):SClass {
			
		//	var _oSProject :SProject = _oSClass.oSProject;
		//	var _aList : Array<Dynamic> = _oSProject.aClass;
			
			var _aList : Array<Dynamic> = _oSClass.oPackage.aSImportList_Full;
			//var _aList : Array<Dynamic> = _oSClass.oPackage.aSImportList;
			
			
			var _i:UInt = _aList.length;
			for (i in 0 ..._i) {
				
				var _oImport : FileImport = _aList[i];
				/*
				var _oSClass : SClass = _oImport.oRefClass;
				if (_oSClass.sName == _sSearch) {
					return _oSClass;
				}*/
				var _oSClass : SClass = _oImport.oRefPackage.fGetClassName(_sSearch);
				if(_oSClass != null){
					return _oSClass;
					
				}
				
			}
			
			Debug.fError("Class not found : " + _sSearch + " in " + _oSClass.sName + " on line " + ExtractBlocs.nCurrLine );
			Debug.fStop();
			return null;
			
		}
		
		
		
		public static function findExClass(_oSClass:SClass,  _sSearch:String):VarExClass {
			_sSearch = _sSearch.substring(1); // Remove x
			
			var _aList : Array<Dynamic> = _oSClass.aExClassList;
			
			var _i:UInt = _aList.length;
			for (i in 0 ..._i) {
				var _oExClass : VarExClass = _aList[i];
				if (_oExClass.oExCallRef.sName == _sSearch) {
					return _oExClass;
				}
			}
			
			Debug.fError("ExClass not found : x" + _sSearch);
			Debug.fStop();
			return null;
		}
		
		public static function findExtendClass(_oSClass:SClass,  _sSearch:String):SClass {
			var _aList : Array<Dynamic> = _oSClass.aExtendAllClassList;
			
			var _i:UInt = _aList.length;
			for (i in 0 ..._i) {
				var _oSClass : SClass = _aList[i];
				if (_oSClass.sName == _sSearch) {
					return _oSClass;
				}
			}
			
			Debug.fError("ExClass not found : " + _sSearch);
			Debug.fStop();
			return null;
		}
		
		
		public static var bInlineMode : Bool = false;
		public static var oInlineFuncCall : FuncCall;
		public static function getParamInCopy(_oSBloc:SBloc, _oFindVar:CommonVar):VarObj {
			
			//Get parma no
			var oGetFunc : SFunction = _oFindVar.oSBloc.oSFunction;
	
			var _aList : Array<Dynamic> = oGetFunc.aParamList;
			var _i:UInt = _aList.length;
			var _nParamNo = 0;
			for ( nParamNo in 0 ... _i) {
				_nParamNo = nParamNo;
				if ( _aList[nParamNo] == _oFindVar) {
					break;
				}
			}
		
			var oLinkVar : VarObj = oInlineFuncCall.aParamList[_nParamNo];
			return oLinkVar;
		
		}
	
		
		
		
	}
	
	

