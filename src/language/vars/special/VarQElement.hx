package language.vars.special ;
	import language.enumeration.EuBetween;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.TypeResolve;
	import language.Text;
	import language.TextType;
	import language.vars.logicObj.CompareObj;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.VarCallClass;
	import language.vars.varObj.VarObj;
	import language.base.Debug;
	

	class VarQElement extends CommonVar {
		
		public var oType : VarObj;
		public var oResultVarsType : VarObj;
		
		public function new(_oSBloc:SBloc, _sParam:String) {
			super(_oSBloc, EuVarType._QElement);
			
			var _aParamList : Array<Dynamic> = _sParam.split(",");
			var _sLineType : String = _aParamList[0];
			
			var _sVarListType : String = Text.between3(_sLineType, 0, EuBetween.Word);
			if(_sVarListType != null){
				var _eType : EuVarType = TextType.stringToType(_sVarListType);
				if (_eType != EuVarType._DArray) {
					oType = TypeResolve.createVarWithType(_oSBloc, _sVarListType, _sLineType, Text.nCurrentIndex);
					/*
					if (oType.eType == EuVarType._Any) {
						
						
							if (_sVarListType !="Any") {
						Debug.trace3("---_sVarListType : " + _sVarListType);
						Debug.trace3("---_sLineType : " + _sLineType);
						Debug.fStop();
						oType = EuVar.VarNone;
							}
					}*/
						
					
				}else {
					Debug.fError("queue element cannot contain array, use multiple dimention");
				}
			}else {
				//Any type
				oType = EuVar.VarAny;
			}
	
	
			if (_oSBloc.oSClass.oSProject.bClassLoaded ) {
				iniQueue();
			}
		}
		
		public function iniQueue():Void {
	
			oResultVarsType = TypeResolve.getResultingType(oType);  //Bulle maybe useless
			if (oResultVarsType == null) {
				//Debug.trace(VarCallClass(oType). + "  " + VarCallClass(oType).oCallRef);
				Debug.fError("queue type not found : " + oType.eType);
				Debug.fStop();
			}
			//Debug.trace2("oResultVarsType : " + sName + oResultVarsType);
		}
	
	}
