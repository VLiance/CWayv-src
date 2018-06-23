package language.base;
	

//	import language.base.Engine;
///	import language.base.InSprite;

	import language.base.Debug;
	
	/**
	 * @author Maeiky
	 */	
	class Root {
		
		public var Main : Root;
	
		
		public function new(_Previous:Root) {
			Main = this;
		//	Previous = _Previous;
		//	GData = _GData;
		//	mcClip = _mcClip;
		//	sDipatchType = _sDipatchType;
			
		//	sID = UniqueId.getId();
			
			/*
			if (Previous != null) {
				
				addEvent(MainEvent.UPDATE, update);
				addEvent(MainEvent.RENDER, render);
				addEvent(MainEvent.FULL_FRAME, fullFrame);
				addEvent(MainEvent.PAUSE, pause);
				addEvent(MainEvent.RESUME, resume);
				addEvent(MainEvent.DESTROY, kill);	
			}*/
		}
		/*
		private function update():Void {
		
			dispatchAll(MainEvent.UPDATE);
		}
		
		private function render():Void {
			onRender();
			
			dispatchAll(MainEvent.RENDER);
		}
		
		private function fullFrame():Void {
			dispatchAll(MainEvent.FULL_FRAME);
		}
		
		private function pause():Void {
			dispatchAll(MainEvent.PAUSE);
		}
		
		private function resume():Void {
			dispatchAll(MainEvent.RESUME);
		}
		
		private function kill():Void {
			mainDestroy();
			
			dispatchAll(MainEvent.DESTROY);
			
			removeEvent(MainEvent.UPDATE, update);
			removeEvent(MainEvent.RENDER, render);
			removeEvent(MainEvent.FULL_FRAME, fullFrame);
			removeEvent(MainEvent.PAUSE, pause);
			removeEvent(MainEvent.RESUME, resume);
			removeEvent(MainEvent.DESTROY, kill);
		}
		
		
		
		public function addEvent(_sEvent : String, _fFunction: Function, _sFunction : String= ""):Void {
			Previous.addEventManually(sID + _sFunction, _sEvent, _fFunction, sDipatchType);
		}
		
		public function removeEvent(_sEvent : String, _fFunction: Function,  _sFunction : String= ""):Void {
			Previous.removeEventManually(sID + _sFunction, _sEvent, _fFunction, sDipatchType);
		}
		
		
		
		private function mainDestroy():Void {}
		private function onUpdate():Void {}
		private function onRender():Void {}
		private function onFullFrame():Void {}
		private function onPause():Void {}
		private function onResume():Void { }
*/
		
		
	}
