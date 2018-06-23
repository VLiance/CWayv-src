package language.project.convertCpp {
	

	class CClass {
		
		
		public var cVarListValue   : UInt = 0; //Lineset
		public var cVarListType	  : UInt = 3; //New mod some thing ight not work (same as line array)
		public var cVarListLocation : UInt = 2;
		public var cVarListClass	  : UInt = 30; //To be sure not interfere
		
		public var cVarListInputType	  : UInt = 14;//Array<Dynamic> //4 bug??
		public var cVarListLength	  : UInt = 5;//Array<Dynamic> 
		public var cVarListDimention	  : UInt = 6;//Array<Dynamic>
		public var cVarListResultingType  : UInt = 25; 
		public var cVarListResultingDim  : UInt = 26; 
		public var cVarListResultingInputType  : UInt = 27;
		
		public var cVarListEnumRef	  : UInt = 12;//Enum
		public var cVarListUnitRef	  : UInt = 12;//unit
		public var cVarListQueueRef	  : UInt = 12;//unit
		public var cVarListQueueBaseVar	  : UInt = 0;//like cVarListValue
		public var cVarListQArrayRef	  : UInt = 13;//unit
		public var cVarListInsideUnit	  : UInt = 14;//unit
		
		
		public var cVarListSharing : UInt = 7;
		public var cVarListConst	  : UInt = 8;
		public var cVarListLine 	  : UInt = 9; //LineNum
		public var cVarListName	  : UInt = 10;
		public var cVarListIniInString : UInt = 11; //To order staic and normal var initialistion


	}
	
		