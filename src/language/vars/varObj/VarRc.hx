package language.vars.varObj ;
	import language.enumeration.EuBit;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	

	class VarRc extends CommonVar {

		public var oResultStringRef   : VarString;
		public var oToCallClass   : VarCallClass;
		public var oRcClass   : SClass;
		public var sEmbedRc   : String = "";
		public var bPureVirtual   : Bool = false;
		public var bEmbedObj   : Bool = false;
		
		public function new(_oSBloc:SBloc) {
			super(_oSBloc, EuVarType._Rc);
		}

		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVarRc(new VarRc(_oSBloc) );
		}		
					
		private function copyVarRc(_oCopy:VarRc):VarObj {
			_oCopy.oResultStringRef = oResultStringRef;
			return copyCommonVar(_oCopy);
		}

	}
