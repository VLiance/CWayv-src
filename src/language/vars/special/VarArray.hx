package language.vars.special ;
	import language.enumeration.EuBetween;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.TypeResolve;
	import language.Text;
	import language.TextType;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.LineArray;
	import language.vars.varObj.VarObj;
	import language.base.Debug;
	

	class VarArray extends CommonVar {

		public var nStartSize   : UInt = 0;
		public var nDimention   : UInt = 1;
		public var oVarsType   : CommonVar;
		public var oResultVarsType   : VarObj;
		public var oResultLineArray   : LineArray;
		
		public function new(_oSBloc:SBloc, _sParam:String, _eType : EuVarType) {
			if(_oSBloc != null){ //Array<Dynamic> copy
				//if (_eType == null) {
				//	_eType = EuVarType._DArray; //Normal
			//	}
				super(_oSBloc, _eType);
				
				var _aParamList : Array<Dynamic> = _sParam.split(",");
				var _sLineType : String = _aParamList[0];
				
				var _sVarListType : String = Text.between3(_sLineType, 0, EuBetween.Word);
				var _eInType : EuVarType = TextType.stringToType(_sVarListType);
				if (_eInType != EuVarType._DArray) {
					oVarsType = TypeResolve.createVarWithType(_oSBloc, _sVarListType, _sLineType, Text.nCurrentIndex,true);  //TODO create only one vartype and reuseit
				}else {
					Debug.fError("Array cannot contain array, use multiple dimention");
				}
				
				if ( _aParamList[1] != null) {
					nDimention = cast(_aParamList[1]);
				}
				
				if ( _aParamList[2] != null) {
					nStartSize = cast(_aParamList[2]);
				}
				
				//For Type Resolve
				oResultLineArray = new LineArray(_oSBloc);
				oResultLineArray.oArray = this;
				oResultLineArray.getResultType();

				if (_oSBloc.oSClass.oSProject.bClassLoaded ) {
					iniVarArray();
				}
			}
		}
		
		public function iniVarArray():Void {

			oResultVarsType = TypeResolve.getResultingType(oVarsType);  //Bulle maybe useless
			//Debug.trace2("oResultVarsType : " + sName + oResultVarsType);
		}
		
		
		
		override public function fGetType(_eOpt:UInt = 0):String {
			return "Array<Dynamic>";
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			var _oArray : VarArray = new VarArray(null, "", EuVarType._None);
			_oArray.oSBloc = _oSBloc;
			return copyVarArray(_oArray);
		}		
					
	
		private function copyVarArray(_oCopy:VarArray):VarObj {
			_oCopy.eType = eType;
			
			_oCopy.nStartSize = nStartSize;
			_oCopy.nDimention = nDimention;
			_oCopy.oVarsType = oVarsType;
			_oCopy.oResultVarsType = oResultVarsType;
			_oCopy.oResultLineArray = oResultLineArray; //Todo Copy

			return copyCommonVar(_oCopy);
		}
		
		
		
		
	}
	
		
