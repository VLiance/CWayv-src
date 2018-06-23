package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.base.Debug;
	

	class LineObj extends VarObj {
		
		
		public var aVarList  : Array<Dynamic> = [];
		
	//	public var aLocList  : Array<Dynamic> = []; //For run code  --> class(Global)/function(Local)/Static/Constant pointer  
		//								   //-> loclist will be loaded first then we will laod one varId list while operatior are "." then laod another loclist
		
		public var bNewCreation  : Bool = false;

		//public var aVarIdList  : Array<Dynamic> = []; //For run code								   
		public var aOpList  : Array<Dynamic> = [];		
	
		//public var eLineType  : UInt;
		
		public var oSBloc : SBloc;	
		//public var nId : UInt;
		
		
		public var nLine  : UInt;
		
		
		public var aConvertInTypeList  : Array<Dynamic> = [];	
		public var aResultTypeList  : Array<Dynamic> = [];	
		
		public var oResultingType  : VarObj;
		public var oConvertInType : VarObj;
		public var oCastInType : VarObj;
		
		public var nAutoCreation : Bool = false; //TODO for string priority and multiplication
		
		public var bInline : Bool = false;	
		
		//public var nFuncLine  : UInt;
			
		
		public function new():Void {
			super();
			eType = EuVarType._Line;
		}
			
		public function pushVar(_oVar:VarObj, _oType:VarObj = null):Void {
			aVarList.push(_oVar);
			if(_oType == null){
				aConvertInTypeList.push(EuVar.VarNone);
			}else {
				aConvertInTypeList.push(_oType); //Like : Array<Dynamic>[Here]  to UInt TODO check if is already in UInt
				
		
			}
			
			//Cpp optimise compilation must know all sub class used
			if (_oVar.eType == EuVarType._CallClass) {
				oSBloc.oSClass.addSubClassUsed(cast(_oVar,VarCallClass).oCallRef);
			}	
		
			/*
			if (bNextVarIsLocation) { //For running we need location to load var from ID
				bNextVarIsLocation = false;
				aLocList.push(_oVar.eLocation);
			}
			//aVarIdList.push(_oVar.nId);
			*/
		}

					
		public function pushFixeVar(_oVar:CommonVar):Void {
			//aVarIdList.push(oSClass.aFixeVarList.length);
			oSBloc.oSClass.pushFixeVar(_oVar);
			aVarList.push(_oVar);
			aConvertInTypeList.push(EuVar.VarNone);
		}
		
		public function pushOperaor(_eOperator:EuOperator):Void {
		
			if(_eOperator != EuOperator.Dot){
				aOpList.push(_eOperator);
			}
		}
		
		
		public function destroy():Void {
//			delete this;
		}
		
		override public function copy(_oSBloc:SBloc):VarObj {
			var _oLine : LineObj = new LineObj();
			_oLine.oSBloc = _oSBloc;
			return copyLineObj(_oLine );
		}		
					
		private function copyLineObj(_oCopy:LineObj):VarObj {
			
			_oCopy.aVarList = copyArrayVars(aVarList, _oCopy.oSBloc);
			_oCopy.aOpList = aOpList.copy();
				
			_oCopy.nLine = nLine;
			_oCopy.aConvertInTypeList = aConvertInTypeList.copy();
			_oCopy.aResultTypeList = aResultTypeList.copy();
			_oCopy.oResultingType = oResultingType;
			_oCopy.oConvertInType = oConvertInType;
			_oCopy.oCastInType = oCastInType;
			_oCopy.nAutoCreation = nAutoCreation;
			_oCopy.bInline = bInline;
			
			return _oCopy;
		}
		
		
		
		
	}
	
		
