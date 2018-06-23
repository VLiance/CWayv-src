package language.vars.logicObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.vars.varObj.VarObj;
	import language.base.Debug;
	
	class LogicIf extends SBloc {  //And LogicIfElse
		
		
		public var oObjIf 	 : VarObj;
		public var oBlocElse  : SBloc = null; //Only LogicIfElse
		public var oPrecIf 	 : LogicIf = null; //Only In multiple if
		
		public function new(_oSParentBloc:SBloc):Void {
			super(_oSParentBloc);
			eType = EuVarType._LogicIf;
		}
		
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyLogicIf(new LogicIf(_oSBloc) );
		}		
					
		private function copyLogicIf(_oCopy:LogicIf):VarObj {
	
			_oCopy.oObjIf = oObjIf;
			_oCopy.oBlocElse = oBlocElse;
			_oCopy.oPrecIf = oPrecIf;

			return copySBloc(_oCopy);
		}
			
	
	}
	
		
