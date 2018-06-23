package language.project.convertCpp ;

	import language.base.InObject;
	import language.base.Root;
	import language.base.Debug;
	/**
	 * ...
	 * @author ...
	 */
	class FileForm  extends InObject
	{
			
		
		private var nLine : UInt = 0; //CurrentLineReference
		public var aFile : Array<Dynamic>= [];
		public var aHeader: Array<Dynamic> = [];
		public var aClass : Array<Dynamic> = [];
		private var sTab : String; 
		
		public function new(_Main:Root) {
			super(_Main);
	
			//
			iniTab();
			
		}
		
		
		////// ------------------------  FILE FORMAT  ----------------------------///////
		
		public function addSpace():Void {
			aFile[nLine] = "";
			nLine ++;
		}
		
		public function iniTab():Void {
			sTab = "";
		}
		public function addTab():Void {
			sTab += "	";
		}
		
		public function subTab():Void {
			sTab = sTab.substring(0, sTab.length-1);
		}
		
		private var bInsert  : Bool = false;
		public function pushLine(_sLine : String):Void {
			if (bInsert) {
				bInsert = false;
				nLine ++;
			}
			aFile[nLine] = sTab + _sLine;
			nLine ++;
		}
		public function insertLine(_sLine : String):Void {
			if (aFile[nLine] == null) {
				aFile[nLine] = sTab;
			}
			
			aFile[nLine] += _sLine;
			bInsert = true;
		}
		
		//InsertMod
		public function getCurrentLine():String {
			if (aFile[nLine] != null) {
				return	aFile[nLine];
			}else {
				return "";
			}
		}
		public function setCurrentLine(_sLine : String):Void {
			aFile[nLine] = _sLine;
		}
		
		///////////////////////////////////////////////////////////////////////////////////
		
		
		
	}

