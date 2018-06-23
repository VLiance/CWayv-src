package language.vars.varObj ;
	import language.enumeration.EuConstant;
	import language.enumeration.EuLocation;
	import language.enumeration.EuSharing;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SFind;
	
	
	
	class CommonVar extends VarObj {
		
		public var eConstant    : EuConstant;
		public var sName	  	: String;
		public var nLine	  	: UInt;
		public var oSBloc    	: SBloc;
		//public var oExtendClass : SClass;
		public var eSharing 	: EuSharing;
		public var bStatic	    : Bool;
		public var bSpecial	    : Bool = false;
		public var bWeak	    : Bool = false;
		public var bEmbed	    : Bool = false;
		public var bAtomic	    : Bool = false;
		
		public var oAssociate  : VarObj; //Easing
		///public var eResultingType  : UInt;
		
		public var sIniInString : String;
		
		
		public var eLocation 	: EuLocation; //For execution
		public var nId	  		: UInt;	//For execution
		
		public function new(_oSBloc:SBloc, _eType:EuVarType) {
			super();
			oSBloc = _oSBloc;
			eType = _eType;
		}
		

		
		
		/*
		public function isExtend():Bool {
			if (oExtendClass == null) {
				return false;
			}
			return true;
		}
		*/
		
		override public function fGetType(_eOpt:UInt = 0):String {
			if (eType == EuVarType._Void) {
				return "void";
			}
			
			return "NI";
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return null; //Not possible -->
			//return copyCommonVar(new CommonVar(oSBloc, eType));
		}		
					
		private function copyCommonVar(_oCopy:CommonVar):VarObj {
			
			_oCopy.eConstant = eConstant;
			_oCopy.sName = sName;
			_oCopy.nLine = nLine;
			_oCopy.eSharing  = eSharing;
			_oCopy.bStatic = bStatic;
			_oCopy.bSpecial = bSpecial;
			_oCopy.oAssociate = oAssociate;
			_oCopy.sIniInString = sIniInString;
			_oCopy.eLocation = eLocation;
			_oCopy.nId = nId;
	
	
			return _oCopy;
		}
		
	}
		
