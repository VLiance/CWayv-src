package language.project.convertSima ;
	//import flash.text.StaticText;
	import language.enumeration.EuLocation;
	import language.enumeration.EuSharing;
	import language.enumeration.EuVarType;
	import language.project.SProject;
	import language.vars.special.SNatAttribut;
	import language.vars.special.SNatFunction;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.VarObj;
	import language.vars.varObj.VarStaticClass;
	import language.base.Root;
	import language.base.Debug;
	/**
	 * ...
	 * @author ...
	 */
	class SGlobal {
		
		
		public static function iniGlobal(_Main:Root, _oSProject : SProject):Void {
			//_oSProject.oMainSPackage ... not sure
			//var _oSClassNative : SClass = new SClass(_Main, _oSProject, null, "ClassNative");
			var _oSClassNative : SClass = new SClass(_Main, _oSProject, _oSProject.oMainSPackage, "ClassNative");
			_oSProject.loadFileImport( _oSClassNative.oPackage.aSImportList );
			_oSClassNative.aAllVarList.push(new VarStaticClass(_oSClassNative, _oSClassNative.oPackage.oThreadMsgImport,  _oSClassNative.oPackage.oThreadMsgImport.oRefPackage.oSClass));
			_oSClassNative.aAllVarList.push(new VarStaticClass(_oSClassNative, _oSClassNative.oPackage.oResult_SearchImport,  _oSClassNative.oPackage.oResult_SearchImport.oRefPackage.oSClass));
			
		//	Debug.fError("awqwwsName : " + VarStaticClass(_oSClassNative.aClassVarList[0]).sName );
			createNativeAttribut(_Main, _oSProject, _oSClassNative);
			createNativeFunction(_Main, _oSProject, _oSClassNative);
		}
		
		
				
		public static var aNFNumber : Array<Dynamic> = [];
		public static var aNFQueueArray : Array<Dynamic> = [];
		public static var aNFArray : Array<Dynamic> = [];
		public static var aNFDataArr : Array<Dynamic> = [];
		public static var aNFString : Array<Dynamic> = [];
		public static var aNFEaseNumber : Array<Dynamic> = [];
		public static var aNFVector : Array<Dynamic> = [];
		public static var aNFFixeArray : Array<Dynamic> = [];
		
		public static var aNFGate: Array<Dynamic> = [];
		
		public static function createNativeFunction(_Main:Root, _oSProject : SProject, _oSClassNative : SClass):Void {
			
			
			var _aLoc : Array<Dynamic> = aNFQueueArray;
			var _eType : EuVarType = EuVarType._QueueArray;
			var _sAdd : String = "GZ_uQA_";
			//_aLoc.push(new SNatFunction(_oSClassNative, _eType, "", "fPush", ["aQueue : QElement<Int>"], "Void","",true));
			_aLoc.push(new SNatFunction(_oSClassNative, _eType, "", "fPush", ["aQueue : QElement<Type>"], "Void","",true));
			_aLoc.push(new SNatFunction(_oSClassNative, _eType, "", "fUnshift", ["aQueue : QElement<Any>"], "Void","",true));
			_aLoc.push(new SNatFunction(_oSClassNative, _eType, "", "fShort", ["Delegate(Bool, QElement, QElement)"], "Void","",true));
			_aLoc.push(new SNatFunction(_oSClassNative, _eType, "", "fClear", [], "Void","",true));
			//_aLoc.push(new SNatFunction(_eType, _sAdd, "remove"));
			
			
			aNFArray.push(new SNatFunction(_oSClassNative, EuVarType._DArray, "", "fPush", ["_Element : Type"], "Void", "", true));
			aNFArray.push(new SNatFunction(_oSClassNative,  EuVarType._DArray, "", "fClear", [], "Void", "", true));
			
			
			aNFDataArr.push(new SNatFunction(_oSClassNative, EuVarType._DataArr, "", "fPush", ["_Element : Type"], "Void","",true));
			aNFDataArr.push(new SNatFunction(_oSClassNative, EuVarType._DataArr, "", "fResize", ["_nSize : UIntX"], "Void","",true));
	
						
			
			aNFNumber.push(new SNatFunction(_oSClassNative,  EuVarType._Float, "GZ_uEase_", "fTo", ["nDest : Float"], "Void", "("));  //TODO multiple type
			aNFNumber.push(new SNatFunction(_oSClassNative,  EuVarType._Float, "GZ_uEase_", "fSpeed", ["fSpeed : Float"], "Void", "&("));
			aNFNumber.push(new SNatFunction(_oSClassNative,  EuVarType._Float, "GZ_uEase_", "fLimit", ["fLimit : Float"], "Void", "&("));
			aNFNumber.push(new SNatFunction(_oSClassNative,  EuVarType._Float, "GZ_uEase_", "fStep", [], "Void", "&("));
			//aNFNumber.push(new SNatFunction(_oSClassNative,  EuVarType._Int, "GZ_uEase_", "fTo", ["nDest : Int"], "Void", "("));  //TODO multiple type
			//aNFNumber.push(new SNatFunction(_oSClassNative,  EuVarType._Int, "GZ_uEase_", "fSpeed", ["fSpeed : Float"], "Void", "("));//TODO multiple type
			//aNFNumber.push(new SNatFunction(_oSClassNative,  EuVarType._Int, "GZ_uEase_", "fStep", [], "Void", "&("));//TODO multiple type
			/*
			aNFNumber.push(new SNatFunction(_oSClassNative,  EuVarType._Int, "cEaOut_", "to", ["nDest : Int"], "Void", "&("));
			aNFNumber.push(new SNatFunction(_oSClassNative,  EuVarType._Int, "cEaOut_", "speed", ["fSpeed : Float"], "Void", "&("));
			aNFNumber.push(new SNatFunction(_oSClassNative,  EuVarType._Int, "cEaOut_", "step", [], "Void", "&("));
			*/
			_aLoc.push(new SNatFunction(_oSClassNative, _eType, "", "fPush", ["aQueue : QElement<Type>"], "Void","",true));
			
			
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fBegin", [], "String","", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fEnd", [], "String","", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fPrev", [], "Bool","", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fNext", [], "Bool","", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fCharAt", ["nIndex : Int"], "Int","", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fFind", ["sSearch : String", "_nStartIndex : Int = 0"], "Result_Search","", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fRevFind", ["sSearch : String", "_nStartIndex : Int = 0"], "Int","", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fSplit", ["_sDelimiter : String"], "DArray<String>","", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fReplace", ["sSearch : String","sReplace : String","_nStartIndex : Int = 0"], "Int","", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fReplaceAll", ["sSearch : String","sReplace : String","_nFromIndex : Int = 0"], "String","", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fRevReplace", ["sSearch : String","sReplace : String","_nStartIndex : Int = 0"], "Int","", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fRevReplaceAll", ["sSearch : String","sReplace : String","_nStartIndex : Int = 0"], "Int","", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fPathGetRelative", ["sRelative : String"], "String", "", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fRevSubStr", ["_sFind : String", "_bExclude : Bool = false"], "String", "", true));
			//aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fSubStr", ["_sFind : String", "_bExclude : Bool = false"], "String", "", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fSubStr", ["_nBeginIndex : UIntX", "_nEndIndex : UIntX"], "String", "", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fPathGetCurrFolder", [], "String", "", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fPathFindPrecFolder", [], "Bool", "", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fPathGetFileName", [], "String", "", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fPathGetFileExtention", [], "String", "", true));
			aNFString.push(new SNatFunction(_oSClassNative, EuVarType._String, "", "fToUInt", [], "UInt", "", true));
			
			aNFGate.push(new SNatFunction(_oSClassNative, EuVarType._Gate, "", "Execute", [], "Bool", "", true, "this"));
			aNFGate.push(new SNatFunction(_oSClassNative, EuVarType._Gate, "", "ExecuteAll", [], "UInt", "", true, "this"));
			aNFGate.push(new SNatFunction(_oSClassNative, EuVarType._Gate, "", "Receive", [], "ThreadMsg", "", true, "this"));
			aNFGate.push(new SNatFunction(_oSClassNative, EuVarType._Gate, "", "Send", ["_oMsgToCopy : ThreadMsg"], "Int", "", true));
			
			aNFEaseNumber.push(new SNatFunction(_oSClassNative, EuVarType._Float, "", "fTo", ["_nDest:Number"], "Void", "", true));
			aNFEaseNumber.push(new SNatFunction(_oSClassNative, EuVarType._Float, "", "fStep", ["_nSpeed:Float=10", "_nLimit:Float = 999999999"], "Void", "", true));
			
		//	aNFVector.push(new SNatFunction(_oSClassNative, EuVarType._CallClass, "", "fStep", [], "Void", "", true));
			aNFVector.push(new SNatFunction(_oSClassNative, EuVarType._CallClass, "", "fStep", ["_nSpeed:Number = 0", "_nLimit:Number = 0"], "Void", "", true));
			aNFVector.push(new SNatFunction(_oSClassNative, EuVarType._CallClass, "", "fSetSpeed", ["_nSpeed:Number"], "Void", "", true));
			aNFVector.push(new SNatFunction(_oSClassNative, EuVarType._CallClass, "", "fSetLimit", ["_nLimit:Number"], "Void", "", true));
			
			
		  //aNFFixeArray.push(new SNatFunction(_oSClassNative,  EuVarType._Float,    "GZ_uEase_", "fLimit", ["fLimit : Float"], "Void", "&("));
			aNFFixeArray.push(new SNatFunction(_oSClassNative, EuVarType._LineArray, "GZ_CArray_", "fToStr", ["_nSize:UIntX"], "String",  ""));
			
		}
		
		//Attribut
		public static var aNANumber : Array<Dynamic> = [];
		public static var aNAQueueElement : Array<Dynamic> = [];
		public static var aNAQueueArray : Array<Dynamic> = [];
		public static var aNAString : Array<Dynamic> = [];
		public static var aNAArray : Array<Dynamic> = [];
		public static var aNADataArr : Array<Dynamic> = [];
		public static function createNativeAttribut(_Main:Root, _oSProject : SProject, _oSClassNative : SClass):Void {
			/*
			var _aLoc : Array<Dynamic> = aNAQueueArray;
			var _eType : UInt = EuVarType._QueueArray;
			var _oVar : CommonVar =  TypeResolve.createVarWithType(_oSClassNative, "QElement",  "(Any)", 0);
			_oVar.sName  = "qeFirst";
			_oVar.sIniInString =  "rFirst"; //For convertion
			_oVar.eLocation = EuLocation.NativeAttribut;
			_oVar.eSharing = EuSharing.Public;
			_aLoc.push(_oVar);
			
			
			 _aLoc = aNAQueueElement;
			_oVar  =  TypeResolve.createVarWithType(_oSClassNative, "QElement",  "(Any)", 0);
			_oVar.sName  = "qeNext";
			_oVar.sIniInString =  "rNext"; //For convertion
			_oVar.eLocation = EuLocation.NativeAttribut;
			_oVar.eSharing = EuSharing.Public;
			_aLoc.push(_oVar);
			*/
			
			new SNatAttribut(_oSClassNative, aNAQueueArray,  EuVarType._QueueArray, "qeFirst", "rFirst", "QElement",  "(Any)"  );
			new SNatAttribut(_oSClassNative, aNAQueueArray,  EuVarType._QueueArray, "qeLast", "rLast", "QElement",  "(Any)"  );
			new SNatAttribut(_oSClassNative, aNAQueueArray,  EuVarType._QueueArray, "nSize", "GnTotal()", "Int",  ""  );
			new SNatAttribut(_oSClassNative, aNAArray, 		 EuVarType._DArray, "nSize", "GnSize()", "UIntX",  ""  );
			new SNatAttribut(_oSClassNative, aNADataArr, 	 EuVarType._DataArr, "nSize", "GnSize()", "UIntX",  ""  );
			
			
			
			new SNatAttribut(_oSClassNative, aNAQueueElement,  EuVarType._QueueArray, "qeNext", "rNext", "QElement",  "(Any)"  );
			new SNatAttribut(_oSClassNative, aNAQueueElement,  EuVarType._QueueArray, "qePrev", "rPrev", "QElement",  "(Any)"  );
			
			
			
			new SNatAttribut(_oSClassNative, aNAString,  EuVarType._String, "nSize", "GnSize()", "Int",  ""  );
			new SNatAttribut(_oSClassNative, aNAString,  EuVarType._String, "nChar", "GnCurrChar()", "UInt",  ""  );
			new SNatAttribut(_oSClassNative, aNANumber,  EuVarType._Int, "hex", "", "Hex",  ""  );

			//_aLoc.push(new SNatAttribut(_oSClassNative, _eType, _sAdd, "push", ["aQueue : QElement(Any)"], "Void"));
			
		
		}
	}
