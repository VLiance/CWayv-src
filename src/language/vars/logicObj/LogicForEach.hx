package language.vars.logicObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.ExtractLines;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.project.convertSima.TypeResolve;
	import language.Text;
	import language.vars.special.VarQueueArray;
	import language.vars.varObj.ExtendVar;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.LineObj;
	import language.vars.varObj.LineVarIni;
	import language.vars.varObj.VarObj;
	import language.base.Debug;
	

	class LogicForEach extends SBloc {
		
		
		public var oEachLine  : VarObj;
		public var oEach  : VarObj;
		public var oIn  : VarObj;	
		public var oInType  : VarObj;	
		public var bQElementBypass  :Bool =  false;	
		public var bQElementNew  :Bool =  false;	
		
		public function new(_oSParentBloc:SBloc, _sLine : String, _nLineNum:UInt):Void {
			super(_oSParentBloc);
			eType = EuVarType._LogicForEach;

			var _nIndex : Int = Text.search(_sLine, " in ") ;
			if (_nIndex != -1) {

				var _sEach : String = _sLine.substring(0, _nIndex);
				var _sIn : String = _sLine.substring(_nIndex + 3);
				oEachLine =  ExtractLines.extractLine( this, _sEach, _nLineNum); //Todo test if its a LineInput
				oIn = TypeResolve.fNoExtend( ExtractLines.extractLine( this, _sIn, _nLineNum) );
				
			
				
				if (oIn.eType == EuVarType._QueueArray) {
					oInType = cast(oIn,VarQueueArray).oVarsType;
				}else {
					Debug.fError("Invalid type 'in' statement in forEach : " + oIn.eType );
					Debug.fStop();
				}
				
				if (oEachLine.eType == EuVarType._LineVarIni) { //Todo, direct var
					bQElementNew = true;
					oEach = cast(oEachLine,LineVarIni).oVarToIni;
				}
				
				if (oEach.eType != EuVarType._QElement ) {
					bQElementBypass = true;
				}
				
			}else {
				Debug.fError("no 'in' statement in forEach");
				Debug.fStop();
			}
			
		
	
		}
	}
	
		
