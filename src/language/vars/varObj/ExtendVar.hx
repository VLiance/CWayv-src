package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	

	class ExtendVar extends VarObj {

		public var oVar  : VarObj;
		public var oSClass  : SClass;
		public var oClassExtend  : SClass;

		
		override public function fGetName():String {
			return oVar.fGetName();
		}
		
		
		public function new(_oSClass:SClass, _oVar:VarObj, _oClassExtend:SClass) {
			super();
			eType =  EuVarType._ExtendVar;
			oSClass = _oSClass;
			oVar = _oVar;
			oClassExtend = _oClassExtend;
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyExtendVar(new ExtendVar(oSClass, oVar,oClassExtend) );
		}		
					
		private function copyExtendVar(_oCopy:ExtendVar):VarObj {
			_oCopy.oVar = oVar; //Just to be sure
			_oCopy.oSClass = oSClass; //Just to be sure
			_oCopy.oClassExtend = oClassExtend; //Just to be sure
			return _oCopy;
		}
		
	}
	
		
