package language.vars.varObj ;
	import language.enumeration.EuLocation;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.project.convertSima.TypeResolve;
	import language.vars.special.VarArray;
	import language.base.Debug;
	

	class LineArray extends LineObj {
		
		public var nDimReq  : UInt; //Nb de diention requis
		public var nDimCount  : UInt;
		public var oArray  : VarArray;
		public var oArrayFull  : VarObj;
		public var bWrite  : Bool = false;
		//public var oResultVar  : VarObj;
		
		public function new(_oSBloc:SBloc):Void {
			super();
			eType = EuVarType._LineArray;
			oSBloc = _oSBloc;
			
		}
		
		public function getResultType():Void {
			nDimCount  = aVarList.length;
			nDimReq = oArray.nDimention - nDimCount;
	
			if (nDimReq == 0) {	
				oResultingType = oArray.oResultVarsType;
				//oResultingType = oArray.oVarsType;
				//oResultingType = TypeResolve.getResultingType(oArray);
			}else {
				oResultingType = this;
			}
			
		}
		
		public function applyVarArray(_oVar:VarObj):Void {
			oArrayFull = _oVar;  //Maybe an extended var
		//	try{
				
				if (oArrayFull.eType == EuVarType._ExtendVar) {
					oArray = cast(cast(_oVar,ExtendVar).oVar);
				}else {
					oArray = cast(oArrayFull);
				}
				/*
			} catch (err : String ) {
				Debug.fError("Can't convert to array: " + err);
				throw err; //throw away
			}*/
		}
		
		
		
		override public function copy(_oSBloc:SBloc):VarObj {
			return copyLineArray(new LineArray(_oSBloc));
		}	
		
		private function copyLineArray(_oCopy:LineArray):VarObj {

			_oCopy.nDimReq = nDimReq;
			_oCopy.nDimCount = nDimCount;
			_oCopy.oArray = oArray;
			_oCopy.oArrayFull = oArrayFull;
			_oCopy.bWrite = bWrite;
		
			return copyLineObj(_oCopy);
		}
		
		
		
		
			
	
	}
	
		
