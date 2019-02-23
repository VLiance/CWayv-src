package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFind;
	import language.base.Debug;
	

	class VarCallClass extends CommonVar {

		public var oCallRef  : SClass;
		public var eTemplateType  : EuVarType = EuVarType._None;
		public var sCallClassNotReady  : SClass;
		public var sTypeNotIni  : String;
		public var bScopeOwner  : Bool;
		
		public function new(_oSBloc:SBloc, _sType:String, _bScopeOwner:Bool = false, _bWeak:Bool = false, _sTemplate : String =  "") {
		
			super(_oSBloc, EuVarType._CallClass);
			
			
			if (_sTemplate != ""){
				eTemplateType = TextType.stringToType(_sTemplate);
			}
			
			bWeak = _bWeak;
			bScopeOwner = _bScopeOwner;
			if(_sType != null){ //Copy
				sTypeNotIni = _sType;
				if (_oSBloc.oSClass.oSProject.bClassLoaded ) {
					applyCallClass();
				}
			}
			

		}
		
		
		public function applyCallClass():Void {
			
			var _oVaObj : VarObj = SFind.findVarObj(oSBloc, sTypeNotIni);
			if (_oVaObj.eType == EuVarType._StaticClass) {
				oCallRef = cast(_oVaObj, VarStaticClass).oRefClass;
				if (oCallRef == null){
					Debug.fFatal("oCallRef is null");
				}
				
			}else if (_oVaObj.eType == EuVarType._CppStaticClass) {
		
			}else {
				Debug.fError("Error, class not found : " + sTypeNotIni);
			}
			sTypeNotIni = null; //Delete?
			
					
			if (oCallRef.bIsVector && eTemplateType == EuVarType._None ){
				Debug.fError("Vector type must specify a template type ex: '" + oCallRef.sName +  "<Float>'");
			}

		}
		
		override public function fGetType():String {
			if (oCallRef == null) {
				return "ClassRefNull";
			}
				
			return oCallRef.sName;

		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyVarCallClass( new VarCallClass(_oSBloc, null));
		}		
					
		private function copyVarCallClass(_oCopy:VarCallClass):VarObj {
		
			_oCopy.oCallRef = oCallRef;
			_oCopy.sCallClassNotReady = sCallClassNotReady;
			_oCopy.sTypeNotIni = sTypeNotIni;
			
			return copyCommonVar(_oCopy);
		}
		
		
		
		
	}
