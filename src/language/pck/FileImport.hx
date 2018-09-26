package language.pck ;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SPackage;
	

	class FileImport  {

		public var sName  	: String;
		public var sPath  	: String;
		public var oSLib   	: SLib;
		public var nLine    : UInt;
		public var oClass   : SClass;
		//public var oRefClass  : SClass;
		public var oRefPackage  : SPackage;
		public var bCpp  : Bool;
		public var bVirtual  : Bool= false; //File not really exist 

		public function new() {

			
		}
		
	}
		
