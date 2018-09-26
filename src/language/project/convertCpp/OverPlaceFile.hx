package language.project.convertCpp ;
	import language.pck.FileImport;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuSharing;
	import language.enumeration.EuVarType;
	import language.MyFile;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.project.CppProject;
	import language.Text;
	import language.project.convertSima.SPackage;
	import language.vars.special.EnumObj;
	import language.vars.special.UnitObj;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.Delegate;
	import language.vars.varObj.EaseOut;
	import language.vars.varObj.LineObj;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.VarObj;
	import language.base.Root;
	import language.base.Debug;
	/**
	 * ...
	 * @author ...
	 */
	class OverPlaceFile extends CommonCpp
	{

		private var bUseDefineIN : Bool = false;
		
		public function new(_Main:Root, _oCppProject : CppProject, _oSPackage : SPackage) { 
	
			super(_Main,_oCppProject, _oSPackage);
			
			convertOverPlaceFile();		
		}
		
		
		private function convertOverPlaceFile():Void {
			pushLine("//This file is to enable overplacement for this class");
		}

	}
