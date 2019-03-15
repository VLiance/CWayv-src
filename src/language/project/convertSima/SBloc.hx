
package language.project.convertSima ;

	import language.enumeration.EuVarType;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.VarObj;
	import language.vars.varObj.VarRtu;

	import language.base.Root;
	/**
	 * ...
	 * @author ...
	 */
	class SBloc extends VarObj
	{
	
		
		//public var aLineList   : Array<Dynamic>;
		public var oParentBloc : SBloc;
		public var oSFunction   : SFunction;
		public var oSClass     : SClass;
		
		
	//	public var nLine : UInt;
		public var nLastLine : UInt;
		
		public var aBlocList : Array<Dynamic> = [];
		
		public var aLineList : Array<Dynamic> = [];
		public var aVarList : Array<Dynamic> = [];
		public var aVarListNormal : Array<Dynamic> = [];
		public var aVarListSpecial : Array<Dynamic> = [];
		
		public var aVarEndSubRtuPtr: Array<Dynamic> = [];
		

		
		public function new(_oSParentBloc:SBloc):Void {
			super();
			if(_oSParentBloc != null){
				oParentBloc = _oSParentBloc;
				oSFunction = _oSParentBloc.oSFunction;
				oSClass = _oSParentBloc.oSClass;
				fIniBloc();
			}
			eType = EuVarType._SBloc;
		}
		public function fIniBloc():Void { 
			if(oParentBloc != null){
				oParentBloc.aBlocList.push(this);
			}
		}
		
		
		public function pushLine(_oLine : VarObj):Void { 
			aLineList.push(_oLine);
		}
		
		public function pushBlocVar(_oVar : CommonVar):Void { 
			aVarList.push(_oVar);
			
			//if (TypeResolve.isVarCommon(_oVar)) { //TODO Maybe error if not
			//	var _oCommonVar : CommonVar = CommonVar(_oVar);
			if(_oVar.bSpecial){
				aVarListSpecial.push(_oVar);		
			}else {
				aVarListNormal.push(_oVar);
			}
	
			pushChildBlocVar(_oVar);
		}
		
		public function pushEndSubRtuPtr(_oRtuPtr : VarRtu):Void { 
			aVarEndSubRtuPtr.push(_oRtuPtr);
		}
		
		private function pushChildBlocVar(_aVar : VarObj):Void {} //Will be overrited
		
		
		public function insertLine(_nIndex: UInt, _oLine : VarObj):Void { 
			//aLineList.splice(_nIndex, 0, _oLine);
			aLineList.insert(_nIndex, _oLine);
		}
		
		
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return null; //Not possible 
		}		
					
		private function copySBloc(_oCopy:SBloc):VarObj {
			
			_oCopy.oParentBloc = oParentBloc;
			_oCopy.oSFunction = oSFunction;
			_oCopy.oSClass = oSClass;
			
			_oCopy.nLine = nLine;
			_oCopy.nLastLine = nLastLine;
			
			_oCopy.aLineList = copyArrayVars(aLineList, _oCopy);
			_oCopy.aVarList = aVarList.copy();
			_oCopy.aVarListNormal = aVarListNormal.copy();
			_oCopy.aVarListSpecial = aVarListSpecial.copy();
			
			_oCopy.aVarEndSubRtuPtr = aVarEndSubRtuPtr.copy();
			
			return _oCopy;
		}
		
		
		public function fRemmoveBlocData():Void { 
			aBlocList  = [];
			aLineList = [];
			aVarList = [];
			aVarListNormal = [];
			aVarListSpecial = [];
			aVarEndSubRtuPtr = [];
		}

		
	}

