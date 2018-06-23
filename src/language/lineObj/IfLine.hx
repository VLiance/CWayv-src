package language.LineObj 
{
	import language.enumeration.EuVarType;
	/**
	 * ...
	 * @author ...
	 */
	class IfLine extends LineBloc
	{
		
		public var aLineTrueList   : Array<Dynamic> = [];
	
		public function new() {
			eType = EuVarType._LineIf;
		}
		
	}

