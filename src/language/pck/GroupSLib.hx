package language.pck ;
	import language.CwmLib;
	import language.project.convertSima.SClass;
	import language.project.run.ArrayLocation;
	import language.vars.special.TypeDef;
	import language.base.Debug;
	//import ssp.filesystem.File;
	

	class GroupSLib  {

		public var aSubLibList : Array<Dynamic> = [];
		public var sName : String;
		public var sWritePath : String; //Not 100% sure
		public var sReadPath : String; //Not 100% sure
		
		public function new() {

		}
		
		public function fAdd(_oSLib:SLib):Void {
			aSubLibList.push(_oSLib);
		}
		
	}
	
		
