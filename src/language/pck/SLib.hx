package language.pck ;
	import language.CwmLib;
	import language._system.FileSys;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SPackage;
	import language.project.run.ArrayLocation;
	import language.vars.special.TypeDef;
	import language.base.Debug;
	
	/*
	import sys.FileSystem;
	import sys.io.File;
//	import ssp.filesystem.File;
	*/

	class SLib  {

		public var bPackMe  	: Bool = false; 
		public var bSkipLibContent : Bool = false; 
		
		public var oCwmLib  	: CwmLib;
		
		public var sName  	: String;
		public var sIdName  	: String;
		public var sWriteName  	: String;
		public var sReadPath  	: String;
		//public var sCommunStructPath  : String = "";
		public var sWritePath  	: String = "LibOut/"; //TODO
		public var bReadOnly  	: Bool;
		public var aTypeDef  	: Array<Dynamic> = [];
	//	public var aClass	  	: Array<Dynamic> = [];
		public var aPackage	  	: Array<SPackage> = [];
		
		
		//public var aMerge  		: Array<Dynamic> = []; //List of Slib with same result path
		//public var oMergeSource : SLib;  //Of wicth is merge from
		public var bDynLink  	: Bool = true;
	
		//public var sCompModTime : String = "";
		public var sCompGetTime : String = "";
		
		public var aFileList  	: Array<FileProperty> = [];
		public var aFileListKey : Map<String,Bool> = [""=>false];
		
		public var sPlatform  	: String = "";
				
		public var sCppModTime : String = "";
		public var sCppGetTime : String = "";
		
		public var oGroup : GroupSLib ;
		
		public var bForceLoadAll : Bool = false;

		
		public function new() {

		}
		
		public function addTypeDef(_sTypeDef : String):Void {
			
			var _oTypeDef : TypeDef = new TypeDef(this, _sTypeDef);
			aTypeDef.push(_oTypeDef);
			
		}
		
		public function fIni():Void {
			
			fGetFolderFileList(sReadPath);
			
			for ( i in 0 ...  aFileList.length) {
				aFileListKey[aFileList[i].sCwPath] = true;
			}
			
			//Debug.trace3("List "+ sIdName + ": " + aFileList );
		}
		
		public function fGetFolderFileList(_sFolder:String, _sRelative : String = ""):Void { 
			
			
			var _aFileDir: Array<String> = FileSys.fReadOneDirectory(_sFolder + _sRelative );
			for (i in 0 ...   _aFileDir.length) {
				var _sFile : String = _aFileDir[i];
				var _sPath =  _sRelative + _sFile;
				if (FileSys.fIsDirectory(_sFolder + _sPath)  ){
					//_sRelative +=  _aFileDir[i] + "/";
				//	fGetFolderFileList(_sPath + "/" );
					fGetFolderFileList(_sFolder , _sPath +  "/");
					
				}else{ //It's a file
					
					aFileList.push(new FileProperty(this, _sPath));
					
	
				}
			}
			
		}
		
		
	}
	
		
