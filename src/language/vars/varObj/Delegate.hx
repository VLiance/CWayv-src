package language.vars.varObj ;
	import language.enumeration.EuBetween;
	import language.enumeration.EuVarType;
	import language.project.convertCpp.ConvertLines;
	import language.project.convertSima.LoadVarContent;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SDelegate;
	import language.project.convertSima.SFind;
	import language.project.convertSima.SFunction;
	import language.Text;
	import language.TextType;
	import language.vars.special.UnitObj;
	import language.base.Debug;
	

	class Delegate extends CommonVar {


		public var oSFunc : SFunction; 
		public var oInputPtrFunc : PtrFunc ; 
		public var sDelegateString : String;
		public var sDelegateStringFull : String;
		
		private var sIniDelegateString : String;
		private var sIniInputDelegateString : String = "";
		private var oIniSBloc: SBloc;
		
		
		public function new(_oSBloc:SBloc, _sDelegateParam : String) {
			super(_oSBloc, EuVarType._Delegate);
			
			sIniDelegateString = _sDelegateParam;
			oIniSBloc = _oSBloc;
			
			_oSBloc.oSClass.aDelegateList.push(this);
			 /*
			
			oSFunc = new SFunction(null, null);
			oSFunc.eType =  EuVarType._Delegate;
			oSFunc.oSFunction = oSFunc;
			oSFunc.oSClass = _oSBloc.oSClass;
			
			var _aParamSrtingList : Array<Dynamic> = [];
			var _sReturnType : String = "Void";
			if (Text.stringNotEmpty(_sDelegateParam)) {

				_aParamSrtingList = _sDelegateParam.split(",");
				_sReturnType  = Text.between3(_aParamSrtingList[0], 0, EuBetween.Word);
			}
			

			_aParamSrtingList.shift(); //Remove the return param
			oSFunc.aParamNotIni = _aParamSrtingList; 
			oSFunc.sIniReturn =  _sReturnType;
			
			oSFunc.sName = "DgTODO";
			oSFunc.nLine = nLine;
			
			if (_oSBloc.oSClass.oSProject.bClassLoaded ) {
				iniDelegate();
			}
			*/
			
		}
		
		public function iniInputDelegate(_sIni:String):Void {
			if(Text.stringNotEmpty(_sIni)){
				sIniInputDelegateString = Text.between3(_sIni, 0,EuBetween.Word);
			}
		}
		
		public function iniDelegate():Void {
			var _oSClass : SClass = oIniSBloc.oSClass;
			var _oGetFunc : VarObj = SFind.findFuncObj( _oSClass, sIniDelegateString);
			if (Std.is(_oGetFunc, ExtendFunc)){
				oSFunc = cast(_oGetFunc, ExtendFunc).oSFunc;
			}else{
				oSFunc = cast(_oGetFunc,SFunction);
			}
			//oSFunc = cast(SFind.findFuncObj( _oSClass, sIniDelegateString),SFunction);
			
			//loadVarContent.extractFunctionInfoParam(oSFunc);i
			//loadVarContent.extractFunctionInfoReturn(oSFunc);
			sDelegateString =  SDelegate.createDelegateString(oSFunc.oReturn, oSFunc.aParamList); 
			sDelegateStringFull = "Dlg_" + oSFunc.sName +  sDelegateString;
					
			if(_oSClass.aDelegateUniqueHash[sDelegateStringFull] == null ){
					_oSClass.aDelegateUniqueHash[sDelegateStringFull] = this;
					_oSClass.aDelegateUniqueList.push(this);
			}
			
			
			if (sIniInputDelegateString != "") {
				
			
				
				//findVarGlobalSClass //OtrFunc TODO
				
				//oInputPtrFunc = SFunction(SFind.findFuncObj(oIniSBloc.oSClass, sIniInputDelegateString));
			
				var _oFind : VarObj = SFind.findVarObj(_oSClass, sIniInputDelegateString);
				if (_oFind.eType == EuVarType._PtrFunc) {
					oInputPtrFunc = cast(_oFind);
					_oSClass.aDelegateListIni.push(this);
				}else {
					//Error
				}
				
				
			
			}
		}
		
		
		
		
		
		
		
		
		
	
	}
