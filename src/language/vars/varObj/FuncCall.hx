package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.ExtractLines;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.project.convertSima.TypeResolve;
	import language.Text;
	import language.vars.special.VarQueueArray;
	import language.base.Debug;
	
	
	//FuncCall with param else we have SFunction (EuVarType._Function) direcly

	class FuncCall extends VarObj {
		
		public var nLineNum:UInt;
		
		public var oSBloc  : SBloc;
		public var oFunction  : SFunction;
		public var aParamList  : Array<Dynamic> = [];
		
		public var aConvertInTypeList  : Array<Dynamic> = [];	
		public var aResultTypeList  : Array<Dynamic> = [];	
		
		public var oConvertInType : VarObj;
		public var oCastInType : VarObj;
		
		public var bInline  : Bool = false;
		
		
		public var oCallerType : VarObj;
		public var oTemplateType : VarObj;
		
		public function new(_oSBloc:SBloc, _oCallerType:VarObj):Void {
			super();
			oSBloc = _oSBloc;
			eType = EuVarType._FuncCall;
			
			oCallerType = _oCallerType;
			//Resolve template type
			if(oCallerType != null){
				switch (oCallerType.eType) {
					case EuVarType._QueueArray:
						oTemplateType = cast(oCallerType,VarQueueArray).oResultVarsType;
					//break;
					default:
				}
			}
			
		}
		
		
		public function extractFuncParam(_sParam:String):Void {
			var _oLookFunc  :SFunction = oFunction;
			var _aLookParamList : Array<Dynamic> = _oLookFunc.aParamList; //TODO check same number of param
			
			//var _aParamList : Array<Dynamic> = _sParam.split(",");
			var _aParamList : Array<Dynamic> = Text.surfaceSplit(_sParam, ",");
			
			var _i:UInt = _aParamList.length;
			for (i in 0 ..._i) {
			
				if (_aLookParamList[i] == null) {
					Debug.fError("LookParam not correspond in : " + _oLookFunc.sName + " for "  +_sParam + " (Total : " + i + ")");

				}
				////ParamGetType/// Maybe do direct
				var _oLookParam : VarObj = _aLookParamList[i];
				var _oLookType : VarObj = _oLookParam;
				if (_oLookParam.eType == EuVarType._ParamInput) {
					_oLookType = cast(_oLookParam,ParamInput).oVarInput;
				}
				
				//////////////////
				aParamList[i] = ExtractLines.newLineSet(oSBloc,  _aParamList[i],  oFunction.nLineNum ,EuVarType._None,null,false,EuOperator.None,false, _oLookType);
				
				
				var _oReusltType : VarObj = TypeResolve.getResultingType(aParamList[i]);
				
				aResultTypeList[i] = _oReusltType;
				
				aConvertInTypeList[i] = TypeResolve.resolveVarConvertion(_oReusltType, _oLookType, false, oTemplateType);
				
			}
		}
		
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyFuncCall(new FuncCall(_oSBloc, oCallerType) );
		}		
					
		private function copyFuncCall(_oCopy:FuncCall):VarObj {
			
			_oCopy.nLineNum = nLineNum;
		
			//_oCopy.oSBloc = oSBloc
			_oCopy.oFunction = oFunction;
			_oCopy.aParamList = copyArrayVars(aParamList, _oCopy.oSBloc);
			
			_oCopy.aConvertInTypeList = aConvertInTypeList.copy();  
			_oCopy.aResultTypeList = aResultTypeList.copy();
			
			_oCopy.oConvertInType = oConvertInType;
			_oCopy.oCastInType = oCastInType;
			
			_oCopy.bInline = bInline;

			
			return _oCopy;
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
    dstr_int_Void* dref_int_Void;
	

 /// INI IN EACH CLASS ////

//INI delegate for function that will being a call back
m_iniStructureN(dref_int_Void, dstr_int_Void);
dref_int_Void->prtClass = this;
dref_int_Void->nCall = (dptr_int_Void)&SimaCode_Test::fTestQueueShort;


 /// CREATE DELEGATE ////

Void* nDelagate = dref_int_Void;//New delegate -> ptr sur callback

 /// CALL DELEGATE ////

//My delegate calls
((((SimaCode_Ext1::dstr_int_Void*)nDelagate)->prtClass)->*((SimaCode_Ext1::dstr_int_Void*)nDelagate)->nCall)();




*/


