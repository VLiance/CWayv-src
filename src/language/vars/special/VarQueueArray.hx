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
	

	class VarQueueArray extends VarArray {

		public function new(_oSBloc:SBloc, _sParam:String) {
			super(_oSBloc, _sParam, EuVarType._QueueArray);
		}

	}
	
		
