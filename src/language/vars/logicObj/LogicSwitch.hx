package language.vars.logicObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.ExtractLines;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.project.convertSima.TypeResolve;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.VarObj;
	import language.base.Debug;
	

	class LogicSwitch extends SBloc {
		
		
		public var oSwitchLine  : VarObj;

		public function new(_oSParentBloc:SBloc, _sLine, _nLineNum):Void {
			super(_oSParentBloc);
			eType = EuVarType._LogicSwitch;
			oSwitchLine = TypeResolve.fNoExtend(  ExtractLines.extractLine( this, _sLine, _nLineNum)); //Todo test if its a LineInput
			
			
		}
	}
