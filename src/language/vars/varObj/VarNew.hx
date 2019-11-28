package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertCpp.TypeText;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	import language.project.convertSima.TypeResolve;
	
	
	//FuncCall with param else we have SFunction (EuVarType._Function) direcly

	class VarNew extends FuncCall {
		
	
		public var oNewRef  : VarObj;
		public var eNewTemplateType  : EuVarType = EuVarType._None;
		public var oTemplateVar  : VarObj;
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
			
			oTemplateVar = TypeResolve.createVarWithType(oSBloc, _sParam, "", Text.nCurrentIndex,true);  //TODO create only one vartype and reuseit
			
			if (oVarSetObj != null){ //Can be null like: 	var _oRegion : Rect<Float> = new Rect<Float>(_oSrcPos , new Dim<Float>(_oTileset.nTileWidth,_oTileset.nTileHeight));
				if (oVarSetObj.eType == EuVarType._CallClass){
					var _oCallClass : VarCallClass = cast(oVarSetObj, VarCallClass);
					
					
				
					
					_oCallClass.eTemplateType = eNewTemplateType;
					_oCallClass.bEaseType = TextType.bEaseType;
				//	Debug.fFatal("!!! " + cast(oVarSetObj, VarCallClass).sName);
					
					
				}
			}
		}
	

	}
	
		
