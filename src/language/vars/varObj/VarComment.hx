package language.vars.varObj ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	

	class VarComment extends VarObj {  //Maybe not commonvar

		public var sComment : String;
		
		public function new(_sComment:String) {
			super();
			sComment = _sComment;
			eType = EuVarType._Comment;
		}
	}
	
		
