package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	
	//Line Var Ini
	class LineVarIni extends VarObj { //TODO Rename in VarIni beacause it can be a LineInput
		
		public var oVarToIni : VarObj;	
		public var bEmpty  : Bool = false;
		
		public var oSBloc : SBloc;
	//	public var nLine  : UInt;
	
		public function new(_oSBloc : SBloc, _oVar:VarObj):Void {
			super();
			oSBloc = _oSBloc;
			oVarToIni = _oVar;
			eType = EuVarType._LineVarIni;
			
			fCheckIfNewVarIsValidScope(_oSBloc, _oVar);
		}
		
		public static function fCheckIfNewVarIsValidScope(_oSBloc : SBloc, _oVar:VarObj):Bool {
			var _nStart : Int = 0;
			//if(_oVar is CommonVar){		//Always Commun Var ?
				var _oCommun : CommonVar = cast(_oVar);
				var _sName : String = _oCommun.sName;
				
				var _sFirstChar : String  = _sName.charAt(0);
				
				//Test if its local -> local require underscore, global no underscore
				if (_oSBloc.oSFunction != null) { //Local
					_nStart = 1;
					if (_sName.length != 1 && _sFirstChar != "_") { //OKi
						Debug.fError("Local var " + _sName+ " require the local scope underscopre prefix '_'");
					}
					
				}else { //Global
					if(_sName.length == 1 ) {
						Debug.fError("Global var: " + _sName + " require to have a length > 1 char");
					}
					if (_sFirstChar == "_") { //OKi
						Debug.fError("Global var: " + _sName + " require to have no local scope underscopre prefix '_'");
					}

				}
			//}
			
			if (_oCommun.sName.length == 1) { //Local one char
						return true;
			}
			
			var _sPrefix : String = "";
			//Verifie know prefix
			for ( i in  _nStart ...  _sName.length) {
				//var _sLetter : Char = _sName.charAt(i);
			//	var _nLetter : Int = cast(_sName[i]);
				var _nLetter : Int = _sName.charCodeAt(i);
				//if ( !(_nLetter >= cast('a') && _nLetter <= cast('z')) ) { //shitty Haxe does not compare upper case
				if ( !(_nLetter >= 97 && _nLetter <= 122) ) {
					break;
				}
				_sPrefix += _sName.charAt(i);
			}
			switch (_sPrefix) {
				
				case "a"  
				| "b"  
				| "d"  
				| "h"  
				| "s"  
				| "n"  
				| "qa"  
				| "qe"  
				| "o"  
				| "g"  
				| "r"  //Temp
				| "v"  //Temp
				| "m" : //Temp
					fTestValidPrefix(_oCommun, _sPrefix);
				//break;
				
				default : 
					Debug.fError("Var: " + _sName + ", Unknow prefix: " + _sPrefix + ", this object type require this prefix: " + fGetPrefixFromType(_oVar));
				//break;
				
			}
			return true;
		}
		
		public static function fTestValidPrefix( _oVar:CommonVar, _sCurrPrefix:String):Bool {
			
			var _sPrefix : String = fGetPrefixFromType(_oVar);
			
			if (_sCurrPrefix != "m" && _sCurrPrefix != "v") { ///TODO TEMp
				
				if (_sPrefix != "?" && _sPrefix != _sCurrPrefix) {
					Debug.fError("Var: " + _oVar.sName + ", Invalid prefix: " + _sCurrPrefix + ", this object type require this prefix: " + fGetPrefixFromType(_oVar));
					return false;
				}
				
				
			}
			
			/*
			var _nType : UInt = _oVar.eType;
			
			switch (_sPrefix) {
				
				case "a" : 
					if (_nType == EuVarType._FixeArray || _nType == EuVarType._DArray || _nType == EuVarType._DataArr) {
						return true;
					}
				//break;
				
				case "b" : 
				case "d" : 
				case "h" : 
				case "s" : 
				case "n" : 
				case "qa" : 
				case "qe" : 
				case "o" : 
				case "g" : 
				case "r" : //Temp
				case "v" : //Temp
				case "m" : //Temp
					
				//break;
				
			}
			Debug.fError("Var: " + _oVar.sName + ", Invalid prefix: " + _sPrefix + ", this object type require this prefix: " + fGetPrefixFromType(_oVar));
			*/
			
			return true;
		}
		
		public static function fGetPrefixFromType( _oVar:VarObj):String {
			
			switch (_oVar.eType) {
				case EuVarType._Bool:
					return "b";
				//break;
				case EuVarType._String:
					return "s";
				//break;
				
				case EuVarType._Float
				| EuVarType._Int
				| EuVarType._UInt:
					return "n";
				//break;
		
				case EuVarType._FixeArray
				| EuVarType._DArray:
					return "a";
				//break;
				case EuVarType._QueueArray:
					return "qa";
				//break;
				case EuVarType._QElement:
					return "qe";
				//break;
				case EuVarType._Delegate:
					return "d";
				case EuVarType._CallDelgate:
					return "d";
				//break;
				case EuVarType._CallClass:
					return "o";
				//break;
				case EuVarType._HoldEnum:
					return "h";
				//break;
				case EuVarType._Gate:
					return "g";
				//break;
				
				default:
					return "?";
				//break;
				
			}
		}
	
			
	
		
	}
	
		
