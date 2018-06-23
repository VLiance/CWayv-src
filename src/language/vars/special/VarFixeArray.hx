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
	

	class VarFixeArray extends VarArray {

		public var sNbDimStar : String = "";
		
		public function new(_oSBloc:SBloc, _sParam:String) {
			if(_oSBloc != null){ //If Copy
				super(_oSBloc, _sParam, EuVarType._FixeArray);
				
				for (i in 0 ... nDimention) {
					sNbDimStar += "*";
				}
				
			}
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			var _oArray : VarFixeArray = new VarFixeArray(null, "");
			_oArray.oSBloc = _oSBloc;
			return copyVarFixeArray(_oArray );
		}		
					
		private function copyVarFixeArray(_oCopy:VarFixeArray):VarObj {
			_oCopy.eType = eType;
			_oCopy.sNbDimStar = sNbDimStar;
			return copyVarArray(_oCopy);
		}
		

	}
	
		
