package language.vars.varObj ;
	import language.pck.FileImport;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	
	
	class VarStaticClass extends CommonVar {

		public var oImport : FileImport;
		public var oRefClass : SClass;
		
		public function new(_oSBloc:SBloc, _oImport:FileImport) {
			super(_oSBloc, EuVarType._StaticClass);
			oImport = _oImport;
			sName = _oImport.sName;
			oRefClass = _oImport.oRefClass;
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVarStaticClass(new VarStaticClass(_oSBloc, oImport) );
		}		
					
		private function copyVarStaticClass(_oCopy:VarStaticClass):VarObj {
			
			_oCopy.oImport = oImport;
			_oCopy.oRefClass = oRefClass;
			
			return copyCommonVar(_oCopy);
		}
		
		
	}
	
	
		
