package language.project.convertCpp 
{
	import flash.printing.PrintJobOptions;
	import language.pck.FileImport;
	import language.enumeration.EuFuncType;
	import language.enumeration.EuSharing;
	import language.enumeration.EuVarType;
	import language.MyFile;
	import language.project.convertSima.SBloc;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.project.convertSima.TypeResolve;
	import language.project.CppProject;
	import language.vars.special.EnumObj;
	import language.vars.special.UnitObj;
	import language.vars.special.VarFixeArray;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.Delegate;
	import language.vars.varObj.EaseOut;
	import language.vars.varObj.LineInput;
	import language.vars.varObj.LineReturn;
	import language.vars.varObj.ParamInput;
	import language.vars.varObj.VarCallClass;
	import language.vars.varObj.VarInt;
	import language.vars.varObj.VarObj;
	import language.vars.varObj.VarString;
	import language.base.Root;
	/**
	 * ...
	 * @author ...
	 */
	
	 
	class NxLog extends FileForm
	{
		var  oCppProject : CppProject;
	
		public function new(_Main:Root, _oCppProject : CppProject) { 
			super(_Main);
			oCppProject = _oCppProject;
			

		}
		
	
		
	}
