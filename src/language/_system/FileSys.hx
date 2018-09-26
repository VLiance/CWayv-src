package language._system;

#if !js
	//import sys.io.FileInput;
	import sys.FileSystem;
	import sys.io.File;
	import sys.io.FileOutput;

#else
	import js.html.FileReader;
#end

	import language._system.FileSysStat;


class FileSys 
{

	public static function fExist(_sFile:String):Bool {
		#if !js
			return FileSystem.exists(_sFile);
		#else
			return false;
		#end
		
	}
	
	
	public static function fGetContent(_sFile:String):String {
		#if !js
			return File.getContent( _sFile );
		#else
			//return "TODO JS";
		//	var reader = new FileReader();
		///	reader.readAsText();
			
			/*
			var fr = new FileReader(); fr.onload = function(e) {
				console.log(e.target.result) 
				
			}; fr.readAsText(file);
			*/
			return "TODO JS";
		#end
	}

	
	
	
	public static function fStat(_sFile:String):FileSysStat {
		return new FileSysStat(_sFile);
	}
	
	
	public static function fCopy(_sSource:String, _sTo :String):Bool {
		#if !js
			File.copy(_sSource, _sTo);
		#end
		return true;
	}
	
		public static function fWrite(_sFile:String, _sData :String ):Bool {
			#if !js
				var _oOut : FileOutput = File.write(_sFile, false);
				_oOut.writeString(_sData);
				_oOut.close();
			#end
			return true;
		}
	
		
		public static function  fIsDirectory(_sFolder : String) : Bool {
			#if !js
				return FileSystem.isDirectory(_sFolder );
			#else
				return false;
			#end
		}
		
	
		public static function  fCreateDirectory(_sFolder : String) : Bool {
			#if !js
				FileSystem.createDirectory(_sFolder);
				return true;
			#else
				return false;
			#end
		}
		
			
			
				
		public static function  fReadOneDirectory(_sFolder : String) : Array<String> {
			#if !js
				return FileSystem.readDirectory(_sFolder  );
			#else
				return new Array<String>();
			#end
		}
		
		
		public static function fEndSameExtention(_sFile:String, _sExtention:String ) : Bool{
			if (_sExtention == ""){
				return true;
			}
			if (_sFile.length < _sExtention.length){
				return false;
			}
			
			var j : Int = _sFile.length;
			var i : Int = _sExtention.length;
			while (i > 0){i--; j--;
				if (_sExtention.charAt(i) != _sFile.charAt(j)){
					return false;
				}
			}
			return true;
		}
		
		public static function  fReadDirectory(_sFolder:String, _bSubFolder :Bool = true, _sExtention: String = "", _aList:Array<String> = null, _sRelative : String = "") : Array<String> {
		
			if (_aList == null){
				_aList = new Array<String>();
			}
			
			#if !js
			var _aFileDir: Array<String> = FileSystem.readDirectory(_sFolder + _sRelative );
			for (i in 0 ...   _aFileDir.length) {
				var _sFile : String = _aFileDir[i];
				var _sPath =  _sRelative + _sFile;
				if (FileSystem.isDirectory(_sFolder + _sPath)  ){
					//_sRelative +=  _aFileDir[i] + "/";
				//	fGetFolderFileList(_sPath + "/" );
					if(_bSubFolder){
						fReadDirectory(_sFolder ,  true, _sExtention, _aList, _sPath +  "/");
					}
					
				}else{ //It's a file
					
					//End with same
					if (fEndSameExtention(_sPath, _sExtention) ){
						_aList.push(_sPath);				
					}
				
				}
			}
			
			#end
			return _aList;
		}	
		
		
	
}