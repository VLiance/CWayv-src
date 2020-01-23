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
		public var sParentLibName  	: String = "";
		public var sParentModule  	: String = "";
		public var sIdName  	: String;
		public var sWriteName  	: String;
		public var sReadPath  	: String;
		//public var sCommunStructPath  : String = "";
		public var sWritePath  	: String = "LibOut/"; //TODO
		public var bReadOnly  	: Bool;
		public var aTypeDef  	: Array<Dynamic> = [];
	//	public var aClass	  	: Array<Dynamic> = [];
		public var aPackage	  	: Array<SPackage> = [];
		
		public var oLibFileImport : FileImport = null;
		
		
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
		public var sClassListCheckSum : String = "";
		public var sCppGetClassListChecksum : String = "";
		
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
					if( !(_sFile.length > 3 && _sFile.charAt(0) == 'L'  && _sFile.charAt(1) == 'i'  && _sFile.charAt(2) == 'b'  && _sFile.charAt(3) == '_'  )){ //Don't include Lib_ in Lib : like Lib_GzOpenGL/_SubLib/Lib_GzOpenGL_Windows // TODO check if it's useless
						fGetFolderFileList(_sFolder , _sPath +  "/");
					}
					
				}else{ //It's a file
					
					aFileList.push(new FileProperty(this, _sPath,_sRelative));
					
	
				}
			}
			
		}
		
		
		
		public function fCalculateCheckSum(){
			sClassListCheckSum = "";
			var _nCheckSum : UInt = 0;
			
			
			for (_oPckg in aPackage) {for (_oSClass in  _oPckg.aClassList) {
				if(!_oSClass.bIsResults && !_oSClass.bIsVector && !_oSClass.bIsPod && !_oSClass.bExtension  && !_oSClass.bThread  && !_oPckg.oSFrame.bWrapper){
					//pushLine("#include \"" + _oSClass.oPackage.sFilePath + ".h\"");
					var _sPath : String = _oSClass.oPackage.sFilePath;
					for (i in 0  ... _sPath.length ){
						_nCheckSum += _sPath.charCodeAt(i);
					}

				}
			}}
						
			sClassListCheckSum =  Std.string(_nCheckSum); 
		}
		
		/*
		public function calculateCheckSum():Void {
			for (_oPckg in oLib.aPackage) {for (_oSClass in  _oPckg.aClassList) {
			
			}}
		}*/
		
		
		
		
		
		
	}
	
		
