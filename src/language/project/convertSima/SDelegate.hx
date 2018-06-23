
package language.project.convertSima ;

	import language.enumeration.EuVarType;
	import language.pck.SLib;
	import language.project.convertCpp.TypeText;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.project.SProject;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.VarObj;
	import language.base.Debug;

	import language.base.Root;
	
	/**
	 * ...
	 * @author ...
	 */
	class SDelegate
	{
		
		//public var oLib  : SLib
		public var sName  : String = "Base";
		public var sLib_Name : String;
		
		public var aDelegateList : Array<Dynamic> = [];
		public var aDelegateExist : Array<Dynamic> = [];

		
		public function new(_oSProject:SProject):Void { 
		//	oLib = _oLib;
			//sLib_Name = oLib.sName + "_"  + sName;
			//sLib_Name =_oSProject.oCppLib.sWriteName + "::3c"  + sName;
			sLib_Name ="GZ::c"  + sName;
		}
		
		public function addDelegate(_oSFunc:SFunction):Void { 
			//Debug.trace("------ADD : " + _oSFunc.sName  );
		/*
			//Check if a same type is already in the list
			if (_oSFunc.oSClass.aDelegateExist[_oSFunc.sName] == null) { //Use func name, if doing function overloading, add with param/retrun
				_oSFunc.oSClass.aDelegateExist[_oSFunc.sName] = 1;
				_oSFunc.oSClass.aDelegateList.push(_oSFunc);
				//Debug.trace1("------ADD : " + _oSFunc.sName  );
			}
				
			//Push function general definition
			var _sDelegate : String =  _oSFunc.getDelegateString();
			//Check if a same type is already in the list
			if (aDelegateExist[_sDelegate] == null) {
				aDelegateExist[_sDelegate] = 1;
				//Debug.trace("------Del : " + _sDelegate  );
				//NewDelegate!!!
				aDelegateList.push(_oSFunc);
			}
			*/
		}
		
		
		public static function createDelegateString( _oReturn:VarObj, _aParamTypeList:Array<Dynamic> ):String {
			
		
			
			var _sDelegateString :String = "_r_";
			_sDelegateString += TypeText.getStringTypeBaseStrict( _oReturn );
			
			_sDelegateString += "_p";
			if (_aParamTypeList.length > 0) {
				var _i:UInt = _aParamTypeList.length;
				for (i in 0 ..._i) {
					var _oParam : VarObj = _aParamTypeList[i];
					_sDelegateString += "_" + TypeText.getStringTypeBaseStrict(_oParam);
				}
			}else {
				_sDelegateString += "_No";
			}
			
			
			return _sDelegateString;
			
			
			/*			
			var _sDelegateString :String = "_r_";
			_sDelegateString += TypeText.getGeneralStringType(_eReturnType);
			
			_sDelegateString += "_p";
			if (_aParamTypeList.length > 0) {
				var _i:UInt = _aParamTypeList.length;
				for (i in 0 ..._i) {
					var _eParamType : UInt = _aParamTypeList[i];
					_sDelegateString += "_" + TypeText.getGeneralStringType(_eParamType);
				}
			}else {
				_sDelegateString += "_No";
			}
			
			
			return _sDelegateString;
			*/
		}
		
		
	}




/* CPP Implementation -->
 * 

/// EACH CLASS EXTEND SAME DELEGATE CLASS ////  CREATE BASE DELAGE FOREACH DELEGATE TYPE FONCTION (RETURN AND PARAM)
   //.h
	typedef Int (SimaCode_Ext1::*SimCallback)(Void);
    struct uCalls { SimCallback nCall; SimaCode_Ext1* prtClass; };
    uCalls* rTest;
	

 /// INI IN EACH CLASS ////

//INI delegate for function that will being a call back
m_iniStructureN(rTest,uCalls);
rTest->prtClass = this;
rTest->nCall = (SimCallback)&SimaCode_Test::fTestQueueShort;

 /// CREATE DELEGATE ////

Void* nDelagate = rTest;//New delegate -> ptr sur callback

 /// CALL DELEGATE ////

//My delegate calls
((((SimaCode_Ext1::uCalls*)nDelagate)->prtClass)->*((SimaCode_Ext1::uCalls*)nDelagate)->nCall)();

// Long version
//(this->*_rTest->nCall)();
//uCalls* nKnow = (SimaCode_Test::uCalls*)nDelagate;
//((nKnow->prtClass)->*nKnow->nCall)();





//////////////////////////////////
//////REAL NAME VERRSION//////////
////////////////////////////////

/// EACH CLASS EXTEND SAME DELEGATE CLASS ////  CREATE BASE DELAGE FOREACH DELEGATE TYPE FONCTION (RETURN AND PARAM)
   //.h
    typedef Int (SimaCode_Ext1::*dptr_int_Void)(Void);
    struct dstr_int_Void { dptr_int_Void nCall; SimaCode_Ext1* prtClass; };
	

 /// INI IN EACH CLASS ////

  
//INI delegate for function that will being a call back

dstr_int_Void* dref_FuncName; //Each function
m_iniStructureN(dref_FuncName, dstr_int_Void);
dref_FuncName->prtClass = this;
dref_FuncName->nCall = (dptr_int_Void)&SimaCode_Test::fTestQueueShort;


 /// CREATE DELEGATE ////

Void* nDelagate = dref_FuncName;//New delegate -> ptr sur callback

 /// CALL DELEGATE ////

//My delegate calls
((((SimaCode_Delegate::_dStr_r_Void_p_No*)nDelagate)->oClass)->*((SimaCode_Delegate::_dStr_r_Void_p_No*)nDelagate)->fCall)();




*/
