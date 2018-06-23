package language.vars.special ;
	import language.enumeration.EuVarType;
	import language.project.convertSima.LoadVarContent;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFrame;
	import language.project.convertSima.SFunction;
	import language.project.convertSima.TypeResolve;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.VarHex;
	import language.vars.varObj.VarObj;
	

	class SNatAttribut extends VarObj {
		
		public var eFromType : UInt;
		public var sName : String;
		public var sConvertName : String;
		public var oAttType : VarObj;
		public var oLoc : Array<Dynamic>;

		public function new(_oSClass:SClass, _oLoc:Array<Dynamic>,_eFromType:EuVarType, _sName:String, _sConvertName:String, _sType:String, _sParam:String ) {
			super();
			//////// Special type ///////
			if (_sType == "Hex") {
				oAttType = new VarHex(_oSClass);
			}else{
			/////////////////////////
			
				oAttType =  TypeResolve.createVarWithType(_oSClass, _sType,  _sParam, 0);
				//if(oAttType is CommonVar){
				if(Std.is(oAttType, CommonVar)){
					cast(oAttType,CommonVar).sName = _sName;
				}
			}
			eType = EuVarType._SNatAttribut;
			//oAttType.eLocation = EuLocation.NativeAttribut;
			//oAttType.eSharing = EuSharing.Public;
			
			sName  = _sName;
			sConvertName = _sConvertName;
			oLoc = _oLoc;
			
			
			oLoc.push(this);
			
			/*
			super(null, _oSBloc);
			eType =  EuVarType._SNatAttribut;
			eFromType = _eFromType;
			eAttType = _eAttType;
			*/
		}
		
		
		
		
	}
	
		
