package language;
	//////////////////////////////////////////////////////////////
	//						 	IMPORT 							//
	//////////////////////////////////////////////////////////////


	import language.project.CppProject;
	import language.base.InObject;
	import language.base.Root;
	import language.base.Debug;
	import language._system.FileSys;
	
	/*
	//import sys.io.FileInput;
	import sys.FileSystem;
	import sys.io.File;
	import sys.io.FileOutput;
	*/


	class MyFile extends InObject {
		
		//////////////////////////////////////////////////////////////
		//						 CONSTANTES VARS					//
		//////////////////////////////////////////////////////////////
		
		//////////////////////////////////////////////////////////////
		//						 PRIVATES VARS						//
		//////////////////////////////////////////////////////////////

		public var sRootPath : String;
		
		private var aFile : Array<Dynamic>;
		private var aRead : Array<Dynamic>;
	
		private var nLine : Int = 0;
		
		public function new(_Main : Root, _sRootPath:String = "") {
			super(_Main);
			aFile = [];
			sRootPath = _sRootPath;
		}
		
		public static function readFile(_sFile:String, _bUseRootFolder:Bool = true):Array<String> {
			/*
			if (_bUseRootFolder) {
				_sFile = sRootPath + _sFile;
			}	*/

			var _aRead : Array<String> = [];

			//if(FileSystem.exists(_sFile)){
			if(FileSys.fExist(_sFile) ){
				
				//var sText : String = File.readText(_sFile, "\n");
			// FileInput _oFile = 	File.read(_sFile,false);
			 
				var sText : String =  FileSys.fGetContent( _sFile );
				_aRead = sText.split("\n");

				
			}else {
				Debug.fError("file not exist : " + _sFile);
				var aTruc : Array<Dynamic>=[];aTruc = aTruc[5];//bug
			}
			return _aRead;
		}
		
		/*	
		public static function isFileExist():Bool {
			
		}*/
			
		
		
		public function  readLength():UInt {
			return aRead.length;
		}
		
		

	
		public function addLine(_sText:String):Void {
			aFile.push(_sText);
		}
		
		public function clear():Void {
			aFile = [];
		}
		
		public function writefile(_sFile:String, _bUseRootFolder:Bool = true, _aLines: Array<Dynamic> = null):Void {
			if (_aLines == null) {
				_aLines = aFile;
			}
			
			if (_bUseRootFolder) {
				_sFile = sRootPath + _sFile;
			}
			MyFile.fwritefile(_sFile, _aLines);
		}
		
		public static function fwritefile(_sFile:String, _aLines: Array<Dynamic>):Void {
					

		//	_sFile = _sFile.replace("/", "\\");
			_sFile = _sFile.split("/").join("\\"); 
			
			var _sData : String = "";
			
			_sData = _aLines.join("\n");
					
			/*
			var _i:UInt = _aLines.length;
			for (i in 0 ..._i) {
				if ( _aLines[i] != null) {
					
					_sData += _aLines[i] + "\n";
				}else {
					_sData +=  "\n"; 
				}
			}
			*/
				
		//	if (!File.fileExists(_sFile)) {
			if (!FileSys.fExist(_sFile)) {
				createFolderTree(_sFile);
			}
			
		//	 File.encoding =  "utf8";
			//var _bResult : Bool = File.writeText(_sData, _sFile);
		//	var _bResult : Bool = File.writeText(_sData, _sFile);
				
			FileSys.fWrite(_sFile,_sData);
	
			/*
			if (!_bResult) {
				Debug.fStop();
				Debug.trace1("Error writing file");
			}*/
				
		}
		
		/*
		public function listFiles(_sPath:String, fFile_sName : Function, fFinish : Function,_sSearchMask : String = "*.*", _sOptions_All_Top : String = "All", _sPath_Root_Local_Full_None : String = "Root"):Void {
			var _bFullName : Bool = true;
			var _nLength : UInt = sRootPath.length;
			
			
			if (_sPath_Root_Local_Full_None == "None") {
				_bFullName = false;
			}else if (_sPath_Root_Local_Full_None == "Local") {
				_nLength += _sPath.length;
			}
			
			
			var aFile:Array<Dynamic> = File.listFileNames(sRootPath + _sPath, _sSearchMask, _sOptions_All_Top, _bFullName);
			var i : Int;
			var _i:UInt = aFile.length;
			
			if (_bFullName) {
				for (i in 0 ... _i) {
					
					fFile_sName(removeRootPath(aFile[i], _nLength));
				}
			}else{
				for (i in 0 ... _i) {
					fFile_sName(aFile[i]);
					
				}
			}
			
			fFinish();
			
			
		}
		*/
		private function removeRootPath(_sPath:String, _nLength:Int):String {
			return _sPath.substring(_nLength, _sPath.length);
		}

		public function changePath(_sPath:String, _sSearch:String, _sChange:String):String {
			var _nIndex : Int = _sPath.indexOf(_sSearch);
			if(_nIndex != -1){
				_sPath = _sPath.substring(0, _nIndex);
				
			//TODO check if really a folder /Folde/ not /lalalFoler/
				return _sPath + _sChange + "\\";
			}else {
				Debug.fError("Search path in changePath() not found : " + _sSearch);
				return null;
			}
			
		}
		
		//BackSlash to slash
		public function convertSlash(_sPath:String):String {
			var _sResult : String = "";
			var _aPath : Array<Dynamic> = _sPath.split("\\");
			
			var i : Int = 0;
			var _i:UInt = _aPath.length - 1;
			while (i < _i) {
				_sResult += _aPath[i] + "/";
				i++;
			}
			_sResult += _aPath[i];
			
			return _sResult;
		}
		
		
		//For Import file like : 
		//import SimaCode.Test2 
		//To SimaCode\\Test2.as
		public static function convertPathWithDot(_sPath:String, _sExtention:String):String {
			var _sResult : String = "";
			var _aPath : Array<Dynamic> = _sPath.split(".");
			var i : Int = 0;
			var _i:UInt = _aPath.length - 1;
			while (i < _i) {
				_sResult += _aPath[i] + "\\";
				i++;
			}
			_sResult += _aPath[i] + _sExtention;
			
			return _sResult;
		}
		
		//TO Import file like : 
		//SimaCode\\Test2.as
		//To SimaCode.Test2 
		public function reversePathWithDot(_sPath:String):String {
			var _sResult : String = "";
			var _aPath : Array<Dynamic> = _sPath.split("\\");
			
			var i : Int = 0;
			var _i:UInt = _aPath.length - 1;
			while (i < _i) {
				_sResult += _aPath[i] + ".";
				i++;
			}
			//Without extention
			var _aEnd : Array<Dynamic> =  _aPath[i].split(".");
			_sResult += _aEnd[0]; 
			
			return _sResult;
		}
		
		
		
		//Get shortcut of two path on same drive
		//Z:\_Flash\MyEngine\CPPcode
		//Z:\_Flash\MyEngine\LibCPP
		//To : ..\LibCPP
		public static function getRelativePath(_sInputPath:String, _sFullPath:String, _bFullPath : Bool = true):String { //TODO check if already relative path
			var _sFile : String = ""; 
			
			if (!_bFullPath) {
				//Simulate drive
				_sInputPath = "x:\\" + _sInputPath;
				_sFullPath = "x:\\" + _sFullPath;
			}
			
			
			//If we have a file
			if (_sInputPath.charAt(_sInputPath.length - 1)  != "\\") {
				Debug.fError("input getRelativePath must be a folder : " + _sInputPath);
				return "";
				//_sFullPath += "\\";
			}
				
			
			//Check if this is a file
			if (_sFullPath.charAt(_sFullPath.length - 1) != "\\") {
				//Get the file
			
				var _nLastIndex : Int = _sInputPath.lastIndexOf("\\", _sFullPath.length);
				if (_nLastIndex ==  -1) {
					Debug.fError("getRelativePath path msut be in a folder");
					return "";
				}
			
				_sFile = _sFullPath.substring(_nLastIndex, _sFullPath.length);
				_sFullPath = _sFullPath.substring(0, _nLastIndex);
			}
						

			
			var _nIndex1 : Int = _sInputPath.indexOf("\\", 0);
			var _nIndex2 : Int = _sFullPath.indexOf("\\", 0);

			
			var _s1: String = _sInputPath.substr(0, _nIndex1);
			var _s2: String = _sFullPath.substr(0, _nIndex2);

			
			if (_s1 ==_s2) {
				//Same Drive

				//Get folder idem
				while (true) {
					_sInputPath = _sInputPath.substring(_nIndex1+1, _sInputPath.length);
					_sFullPath = _sFullPath.substring(_nIndex2+1, _sFullPath.length);
					
			    	_nIndex1 = _sInputPath.indexOf("\\", 0);
					if (_nIndex1 == -1) {
						break;
					}
					
					_nIndex2 = _sFullPath.indexOf("\\", 0);
					if (_nIndex2 == -1) {
						break;
					}
					
					_s1 = _sInputPath.substr(0, _nIndex1);
					_s2 = _sFullPath.substr(0, _nIndex2);
			
					if (_s1 != _s2 ) {
						break;
					}

				}
				
				//Debug.trace("_sInputPath : " + _sInputPath);
				
				var _sResult : String = "";
				if (_sInputPath == "") {
					//Path2 is Inside
					
					_sResult += ".\\";
					
				}else{
					//Count prveious subfolder
					var _i:UInt = _sInputPath.length;
					for (i in 0 ..._i) {
						if (_sInputPath.charAt(i) == "\\") {
							
							_sResult += "..\\";
						}
					}
				}
					//Debug.trac("return : " + _sResult + _sFullPath + _sFile)

				
				return 	_sResult + _sFullPath + _sFile;

			}else {
					//Debug.trac("difDrive : " + _sResult + _sFullPath + _sFile)

				//DifferentDrive;
				return _sFullPath;
			}

		}
		
		
		
		public static function getFullPathFromRelative(_sFullPath:String, _sRelativePath:String):String {
			_sFullPath = _sFullPath.split("/").join("\\");
			_sRelativePath = _sRelativePath.split("/").join("\\");
			
			var _nCount : Int = 0;
			var _nIndex : Int = Text.search(_sRelativePath, "..\\", 0);
			var _nLastIndex : Int = 0;
			while ( _nIndex > -1 ) {
				_nCount ++;
				_nLastIndex = _nIndex + 3;
				_nIndex = Text.search(_sRelativePath, "..\\", _nLastIndex ) ;
			}

			//Sub # of folder
			var i : Int = _sFullPath.length - 1;
			while (_nCount > 0 ) {
				i--;
				while (i > 0  && _sFullPath.charAt(i) != "\\") { //>=?
					i--;
				}
				_nCount--;
			}
			
			var _sReturn : String =   _sFullPath.substring(0, i + 1) +  _sRelativePath.substring(_nLastIndex);
			_sReturn = _sReturn.split("\\").join("/");
			return _sReturn;
		}
		
		public static function getLastFolder(_sPath:String, _bJustName:Bool = false):String {
			_sPath = StringTools.rtrim(_sPath.split("\\").join("/"));
			
			if (_sPath.charAt(_sPath.length-1) == "/") {
				var _nIndex:Int = _sPath.lastIndexOf("/", _sPath.length - 2);
				if (_nIndex == -1) {
					_nIndex = 0;
				}else if (_bJustName) {
					_nIndex ++;
				}
				
				return _sPath.substring(_nIndex, _sPath.length-1);
			}else {
				Debug.fError("export path must be a folder : " + _sPath);
				return "";
			}
		}
		
		

		
		public static function createFolderTree(_sPath : String):Bool {
			
			var _sNextFolder : String = lastExistingFolder(_sPath);
			//	Debug.fTrace("_sNextFolder " + _sNextFolder);
			/*	if (_sNextFolder == "None") {
				return false;
			}*/
			
			var _nIndex : Int = _sNextFolder.length;
			var _nLength : Int = _sPath.length;
			
			while (_nIndex > 0) {
				_nIndex  = _sPath.indexOf("\\", _nIndex + 2);
				if (_nIndex != -1) {
				
					_sNextFolder = _sPath.substring(0, _nIndex);

					FileSys.fCreateDirectory(_sNextFolder);

				}
			}
			
			
			return true;
		}
		
		
		
		private static function lastExistingFolder(_sPath : String):String {

			var _nIndex : Int  =  _sPath.length;
			var _sPreviousFolder : String = _sPath;
			
			while (_nIndex > 0) {
				_nIndex  = _sPreviousFolder.lastIndexOf("\\", _nIndex);
				_sPreviousFolder = _sPreviousFolder.substring(0, _nIndex);
			//	if (File.folderExists(_sPreviousFolder)) {
				if (FileSys.fExist(_sPreviousFolder)) {
					break;
				}
			}
			
			if (_nIndex == -1) {
				return "None";
			}
		
			return _sPreviousFolder;
			
		}
	

		//_Flash\MyEngine\CPPcode = 3 folder
		public static function countFolder(_sInputPath:String):UInt {

			//var _nIndex : Int = _sInputPath.indexOf("\\", _nIndex + 2);
			var _nIndex : Int = _sInputPath.indexOf("\\", 0 + 2);
			var _nCount : UInt = 0;
			while (_nIndex > 0) {
				_nCount++;
				_nIndex  = _sInputPath.indexOf("\\", _nIndex + 2);
			}
			return _nCount;
		}
		
		//_Flash\MyEngine\CPPcode = ..\..\..\ 
		public static function getStringBackFolder(_nCount:UInt):String { 
			var _sFolderBack : String = "";
			for (i in 0 ... _nCount) {
				_sFolderBack += "..\\";
			} 

			return _sFolderBack;
		}
		
		 /*
		public function getFileModification(_sPath:String, _bUseRootFolder:Bool = true):Float {
			if (_bUseRootFolder) {
				_sPath = sRootPath + _sPath;
			}
		//	if(File.fileExists(_sPath)){
			if (FileSystem.exists(_sPath)){
				
				 
			//	return File.getFileInfo(_sPath).modificationTime;
				return FileSystem.stat(_sPath).mtime.getTime();
			}else {
				return -1;
			}
			
		}*/
	
	
		public function setReadLine(_nLine:UInt):Void {
			nLine = _nLine;
		}
		
		
		public function  getLine():String {
			return aRead[nLine];
		}
		
		public function  isOpenFunction():Bool {
			var _sLine : String = aRead[nLine];	
			
			if (_sLine.charAt(_sLine.length-1) == "{") {
				return true;
			}else {
				return false;
			}
		}
	
		
	
		
		
		
	
		

	}

