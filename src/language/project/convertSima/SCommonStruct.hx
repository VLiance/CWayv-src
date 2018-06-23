
package language.project.convertSima 
{

	import language.enumeration.EuVarType;
	import language.pck.SLib;
	import language.project.convertCpp.TypeText;
	import language.project.convertSima.SClass;
	import language.project.convertSima.SFunction;
	import language.vars.varObj.CommonVar;
	import language.vars.varObj.VarObj;
	import language.base.Debug;

	import language.base.Root;
	/**
	 * ...
	 * @author ...
	 */
	class SCommonStruct
	{
		
		public static var sName  : String = "CommonSruct";
		public static var sHeader  : String = "#include " + sName + ".h";
		
		public var aStructureList : Array<Dynamic> = [];
		
		public function new():Void { 

		}
		
		
		
	}




