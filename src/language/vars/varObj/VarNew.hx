package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertCpp.TypeText;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	
	
	//FuncCall with param else we have SFunction (EuVarType._Function) direcly

	class VarNew extends FuncCall {
		
	
		public var oNewRef  : VarObj;
		public var eNewTemplateType  : EuVarType = EuVarType._None;
		public var oVarSetObj  : VarObj;

		
		override public function fGetType():String {
			return "New";
		}
		
		public function new(_oSBloc:SBloc,  _oVarSetObj:VarObj = null):Void {
			super(_oSBloc, null);
			eType = EuVarType._New;
			oVarSetObj = _oVarSetObj;
		}
		
	
		public function extractTemplate(_sParam:String):Void {
			eNewTemplateType = TextType.stringToType(_sParam);

			if (oVarSetObj.eType == EuVarType._CallClass){
				cast(oVarSetObj, VarCallClass).eTemplateType = eNewTemplateType;
			//	Debug.fFatal("!!! " + cast(oVarSetObj, VarCallClass).sName);
				
			}
		}
	

	}
	
		
