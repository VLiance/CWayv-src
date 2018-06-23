package language.vars.varObj ;
	import language.pck.FileImport;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFind;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	
	
	class VarExClass extends VarObj {


		public var oExCallRef : SClass;
		public var oSBloc : SClass;
		
		public function new(_oSBloc:SClass, _oExCallRef:SClass) {
			super();
			eType =  EuVarType._ExClass;
			oExCallRef = _oExCallRef;
			oSBloc = _oSBloc;
		}
		
		public function getCppName():String {
			//return oSClass.oSLib.sWriteName + "::" +  oSClass.sName + "::" + sName;
			return oExCallRef.sNsAccess + "c" + oExCallRef.sName + "::";
		}
		
		/*
		public function applyCallClass(_sType:String):Void {
			
			var _oVaObj : VarObj = SFind.findExtendClass(oSBloc.oSClass, _sType);
			
			if (_oVaObj.eType ==  EuVarType._ExtendVar) {
				_oVaObj =  ExtendVar(_oVaObj).oVar;
			}
			
			Debug.fError(_oVaObj.eType);
			
			//if (_oVaObj.eType == EuVarType._StaticClass) {
				oExCallRef = SClass(_oVaObj);
				
			//}


		}*/
		
		
		/*
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVarStaticClass(new VarExClass(_oSBloc, null) );
		}		
					
		private function copyVarStaticClass(_oCopy:VarExClass):VarObj {
			
			_oCopy.oSBloc = oSBloc;
			_oCopy.oExCallRef = oExCallRef;
			
			return copyCommonVar(_oCopy);
		}
		*/
		
	}
	
	
		
