package language.project.optimization;
	import language.enumeration.EuBetween;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuOperator;
	import language.enumeration.EuVarType;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFind;
	import language.project.convertSima.SFunction;
	import language.Text;
	import language.TextType;
	import language.vars.special.NativeFuncCall;
	import language.vars.special.SNatFunction;
	import language.vars.special.VarArray;
	import language.vars.special.VarQElement;
	import language.vars.special.VarQueueArray;
	import language.vars.varObj.CallDelegate;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.Delegate;
	import language.vars.varObj.ExtendFunc;
	import language.vars.varObj.ExtendFuncCall;
	import language.vars.varObj.ExtendVar;
	import language.vars.varObj.FuncCall;
	import language.vars.varObj.LineArray;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.LineInputMod;
	import language.vars.varObj.LineLoc;
	import language.vars.varObj.LineObj;
	import language.vars.varObj.LineReturn;
	import language.vars.varObj.LineVarIni;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.VarBoolean;
	import language.vars.varObj.VarCallClass;
	import language.vars.varObj.VarDec;
	import language.vars.varObj.VarFloat;
	import language.vars.varObj.VarHex;
	import language.vars.varObj.VarInc;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarNew;
	import language.vars.varObj.VarNewArraySquare;
	import language.vars.varObj.VarNull;
	import language.vars.varObj.VarObj;
	import language.vars.varObj.VarRtu;
	import language.vars.varObj.VarStaticClass;
	import language.vars.varObj.VarString;
	import language.vars.varObj.VarThis;
	import language.base.Debug;
	/**
	 * ...
	 * @author ...
	 */
	class Optimize
	{
		//Select all function of one class to optimize each lines
		public static function optimizeClassFunctions(_oSClass:SClass):Void {
			//Extract all line in each function 
			var _aFunctionList : Array<Dynamic> = _oSClass.aFunctionList;
			var _i:UInt = _aFunctionList.length;
			for (i in 0 ..._i) {
				var _oFunction : SFunction = _aFunctionList[i];
				if(!_oFunction.bNoLine){
					if(_oFunction.eFuncType != EuFuncType.Extend){ //Do not make empty extend function list
						//Debug.fTrace("--Function optimize : " + _oFunction.sName);
						allLineInFunction(_oSClass,  _oFunction);
					}
				}
			}
		}
		
		
		private static function allLineInFunction(_oSClass:SClass, _oFunction : SFunction):Void {
			var _i : UInt = _oFunction.aLineList.length;
			for (i in 0 ..._i) {
				
				
			}
		//	Debug.trace3("--Finish lines : " + _oFunction.sName);
		}
		
		
		public static function optimizeInline(_oSClass:SClass):Void {
			var _aInlineBloc : Array<Dynamic> = _oSClass.aInlineBloc;
			var _aInlineIndex : Array<Dynamic> = _oSClass.aInlineIndex;
			var _i:UInt = _aInlineBloc.length;
			for (i in 0 ..._i) {
				var _oSBloc : SBloc = _aInlineBloc[i];
				var _nIndex : UInt = _aInlineIndex[i];
				var _oLine : LineObj =  cast( _oSBloc.aLineList[_nIndex]);
				var _oFunc : FuncCall = getFunctionToInline(_oLine);
				
				_oSBloc.aLineList.splice(_nIndex, 1);//TODO delete must be before? But todo check for index they will cahnge on multiple inline!!
				
				doInline(_oSBloc, _nIndex, _oFunc);
				
				
				//_oLine.oSBloc
				//_oSBloc.insertLine(_nIndex+1, _oSBloc.aLineList[_nIndex]);
				//Debug.trace3("Line Index : " + _nIndex );
			}
		}
		
		
		public static function getFunctionToInline(_oLine:LineObj ):FuncCall {
			var _aList : Array<Dynamic> = _oLine.aVarList;
			var _i:UInt = _aList.length;
			for (i in 0 ..._i) {
				var _oVar : VarObj = _aList[i];
				switch (_oVar.eType) {
					case EuVarType._FuncCall:
						return cast(_oVar);
					//break;
					default:
				}
			}
			
			Debug.fError("no inline function found for optimise");
			Debug.fStop();
			return null;
		}
		
		
		
		public static function doInline(_oSBloc:SBloc, _nIndex : UInt, _oFunc:FuncCall):Void {
			
			SFind.oInlineFuncCall = _oFunc;
			SFind.bInlineMode = true;
			var _aList : Array<Dynamic> = _oFunc.oFunction.aLineList;
			var _i:UInt = _aList.length;
			for (i in 0 ..._i) {
				var _oLine : VarObj = _aList[i];
				
				var _oNewLine : VarObj = _oLine.copy(_oSBloc);
				if(_oNewLine != null){
					_oSBloc.insertLine(_nIndex, _oNewLine);
					_nIndex++;
				}
			}
			SFind.bInlineMode = false;
		}
		
		
		
		/*
		public static function getLineIndex(_oLine:LineObj):UInt {
			var _oSBloc : SBloc =  _oLine.oSBloc;
			
			var _aLineList : Array<Dynamic> = _oSBloc.aLineList;
			var _i:UInt = _aLineList.length;
			for (i in 0 ..._i) {
				if (_aLineList[i] == _oLine) {
					return i;
				}
			}
			Debug.fError("line in bloc not found")
			Debug.fStop();
			return 0;
		}*/
		
		
		
		
	}

