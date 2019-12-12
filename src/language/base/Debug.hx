
package language.base ;
import haxe.CallStack;
import language._system.System;
import language.cwMake.line.CWaveArg;
import language.project.assist.CwInfo;
import language.project.convertSima.ExtractBlocs;


	class Debug  {
	
		///////////////////////////////////////////////////////////////////
		//                      PUBLIC METHODS                           //
		///////////////////////////////////////////////////////////////////
/*
		public static function trace1(_oText:Dynamic, _nColor:UInt = 0):Void {
			Sys.println(_oText);
		}
		public static function trace2(_oText:Dynamic, _nColor:UInt = 0):Void {
			Sys.println(_oText);
		}
		public static function trace3(_oText:Dynamic, _nColor:UInt = 0):Void {
			Sys.println(_oText);
		}*/
		public static function error(_oText:Dynamic, _nColor:UInt = 0):Void {
			//Sys.println(_oText);
			System.fPrint(_oText);
		}
		
		
		
				
		public static function fTrace(_oText:Dynamic):Void {
			//#if debug
				System.fPrint(_oText);
				//Sys.println(_oText);
			//#end
		}
		
		public static function fBreak():Void {
			#if debug
				throw  "Break Point ";
			#end
		}
		
		
		
		///////
		
		public static function fStop():Void {
		
			/*
			if (!CWaveArg.bManaged) {
				bStopped = true;
				var _aBug : Array<Dynamic> = _aBug[5];
			}else {
				*/
				//var e:Error = new Error();
				//var _sCallStack : String = e.getStackTrace();
				//throw new Error(":Bloc error : " + _sCallStack);
				throw  ":Bloc error : ";
				
			//}
		}
		
		public static function fAssist(_sMsg:String):Void {
			/*
			if (CWaveArg.nAssist) {
				System.sendStringMessage(CWaveArg.nAssistHandle, "A: " + _sMsg);
				
			}else {*/
			fTrace("A| " + _sMsg);
		//		debugTrace(oListBox3, "A: " + _sMsg, 0);
		//	}
			
			
		}
	
		
	
		
	
		
		public static function fError(_oText:Dynamic):Void {
			
		
			
			if (CwInfo.bNoErrror) {
				fAssist(cast(_oText)); //Todo don't send?
				return;
			}
			
			var _sPath : String = "";
			if(ExtractBlocs.oCurrSClass != null){
				//_sPath = ExtractBlocs.oCurrSClass.sPath + ExtractBlocs.oCurrSClass.sName + Setting.sFileExtention;
				//_sPath = ExtractBlocs.oCurrSClass.oSLib.sReadPath + _sPath;
				_sPath = ExtractBlocs.oCurrSClass.oPackage.sReadedFilePath;
				
				_sPath = _sPath.split("\\").join("/");
				
				//_sPath += ":" + (ExtractBlocs.nCurrLine + 1) + ": error: ";
				_sPath += ":" + (ExtractBlocs.nCurrLine ) + ": error: ";
			}else {
				_sPath = "Unknow Location:0: error:";
				
			}
		
				
				
				
			
			
			if (CWaveArg.bManaged) {
				if (CWaveArg.nAssist > 0) {
				//	System.sendStringMessage(CWaveArg.nAssistHandle, "E: " + _sPath + String(_oText));
				}else{
					//System.sendStringMessage(CWaveArg.nHandleID, "E: " + _sPath + String(_oText));
				}
			}else {
			
				System.fPrint("E| " + _sPath + cast(_oText) + " ");
			//	debugTrace(oListBox3, "E: " + _sPath + String(_oText), 0);
			}
			
			
		}
			
			
			
		public static function fInfo(_oText:Dynamic):Void {
			//	Sys.println("W: " +_oText);
				System.fPrint("I| " +_oText);
				/*
			if(CWaveArg.bManaged){
				System.sendStringMessage(CWaveArg.nHandleID, "W: " + String(_oText));
			}else {
				debugTrace(oListBox3, _oText, 0);
			}*/
		}
		
		public static function fWarning(_oText:Dynamic):Void {
			//	Sys.println("W: " +_oText);
				System.fPrint("W| " +_oText);
				/*
			if(CWaveArg.bManaged){
				System.sendStringMessage(CWaveArg.nHandleID, "W: " + String(_oText));
			}else {
				debugTrace(oListBox3, _oText, 0);
			}*/
		}
		

		public static function fFatal(_oText:Dynamic):Void {
			System.fFatal(_oText);
			fError(_oText);
			//Sys.println(_oText);
			/*
			if(CWaveArg.bManaged){
				System.sendStringMessage(CWaveArg.nHandleID, "F: " + String(_oText));
			}else {
				debugTrace(oListBox3, _oText, 0);
			}*/
			//var _aStopExecution 
			//fTrace("Fatal error : " +_oText );
			#if !js
				throw  "Fatal error : " +  _oText  + " : " + CallStack.callStack();
			#else
				throw  "Fatal: execution stopped";
			#end
			
		}
		
		
	
		
		
	}
