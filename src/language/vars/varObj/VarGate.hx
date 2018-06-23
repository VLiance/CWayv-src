package language.vars.varObj ;
	import language.enumeration.EuBit;
	import language.enumeration.EuVarType;
	import language.project.convertCpp.TypeText;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.TypeResolve;
	import language.base.Debug;
	

	class VarGate extends CommonVar {
		
		
		public var oTemplate : VarObj;
		public var oRslTemplate : VarObj;
			public var sTemplate : String;
		
		public function new(_oSBloc:SBloc, _sTemplate : String) {
			super(_oSBloc, EuVarType._Gate);
			oTemplate = TypeResolve.createVarWithType(_oSBloc, _sTemplate, "", 0, false);  //TODO create only one vartype and reuseit
			if (_oSBloc.oSClass.oSProject.bClassLoaded ) {
				iniVarGate();
			}
			sTemplate = _sTemplate;
		}
		
		
		public function iniVarGate():Void {
	
			
			
			oRslTemplate = TypeResolve.getResultingType(oTemplate);  //Bulle maybe useless
			/*
			if (oRslTemplate.eType == EuVarType._CallClass) {
				oRslTemplate = VarCallClass(oRslTemplate).oCallRef;
			}*/
			
			
			
		//	Debug.fError("Ini gate oResultVarsType : "  + sTemplate  + " " + oRslTemplate.eType);
		}
		
		public function getTemplateTypeString():String {
			if (oRslTemplate.eType == EuVarType._CallClass) {
				var _oClass : SClass = cast(oRslTemplate,VarCallClass).oCallRef;
				return _oClass.sNsAccess + "c" +  _oClass.sName;
			}
			return "UnknowGateType";
			//return TypeText.typeToCPP(oRslTemplate);
		}

		
	}
