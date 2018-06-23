package language.vars.logicObj ;
	
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.vars.varObj.VarObj;
	import language.base.Debug;
	

	class LogicalObj extends VarObj {
		
		
		public var aVarList  : Array<Dynamic> = [];						   
		
		public var oVarInput  : VarObj;
		public var eResultingType  : UInt;
		public var oSFunction : SFunction;
		public var oSClass : SClass;	
		
		public var nLine  : UInt;
		
		//public function LineObj():Void {
		public function new():Void {
			super();
			//eType = EuVarType._Logical;   //2 possibility, a logical OR || logical AND
		}
			
		public function pushVar(_oVar:VarObj):Void {
			aVarList.push(_oVar);
		}
		

		
	}
	
		
