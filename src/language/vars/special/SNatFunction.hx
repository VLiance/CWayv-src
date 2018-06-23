package language.vars.special ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.LoadVarContent;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFrame;
	import language.project.convertSima.SFunction;
	import language.vars.varObj.VarObj;
	

	class SNatFunction extends SFunction {
		
		public var eFromType : EuVarType;
		public var sConvertName : String;
		public var sBeforeSource : String;
		public var bIntegrateFunc : Bool;
		public var sAddToParam : String;
		

		public function new(_oSBloc:SClass, _eFromType:EuVarType, _sAdd:String, _sName:String, _aParam:Array<Dynamic>, _sReturn:String, _sBeforeSource:String = "", _bIntegrateFunc : Bool = false, _sAddToParam:String = "") {
			super(null, _oSBloc);
			eType =  EuVarType._SNatFunction;
			bIntegrateFunc = _bIntegrateFunc;
			sName = _sName;
			eFromType = _eFromType;
			sConvertName = _sAdd +  _sName;
			sBeforeSource = _sBeforeSource;
			aParamNotIni = _aParam;
			sIniReturn =  _sReturn;
			sAddToParam = _sAddToParam;
			LoadVarContent.extractFunctionInfoParam(this);
			LoadVarContent.extractFunctionInfoReturn(this);

		}
		
		
		
		
	}
	
		
