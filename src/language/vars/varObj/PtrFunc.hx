package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	

	class PtrFunc extends VarObj { //CommonVar not sure???
		
		public var oPtrClass : SClass;
		public var oFunc : SFunction;
		
		public function new(_oSClass:SClass, _sFunc:SFunction) {
			super();
			oPtrClass = _oSClass;
			eType =  EuVarType._PtrFunc;
			oFunc = _sFunc;
		}
		
		public function addInUseList():Void {
		 //oFunc.oSClass.oSProject.oSDelegate.addDelegate(oFunc);
		 //	oFunc.oSClass.addDelegate(oFunc);
		 oFunc.bAddDlgWrapper = true;
		}
		
		
	}
	
		
