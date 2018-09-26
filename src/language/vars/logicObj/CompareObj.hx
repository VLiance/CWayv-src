package language.vars.logicObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.vars.varObj.LineObj;
	import language.vars.varObj.VarObj;
	import language.base.Debug;
	

	class CompareObj extends VarObj {
		
		
		public var oLineLeft  : VarObj;	
		public var oLineRight  : VarObj;	
		
		public var  eOpp : EuOperator;
		
		
		public var oVarInput  : VarObj;
		public var oResultingType  : VarObj;
		public var oConvertLeft  : VarObj;
		public var oConvertRight  : VarObj;
		public var oSFunction : SFunction;	

	//	public var nLine  : UInt;
			
		
		public function new():Void {
			super();
			eType = EuVarType._Compare;
		}
			


		public function setOperaor(_eOperator:UInt):Void {
		
		}
		
	}
	
		
