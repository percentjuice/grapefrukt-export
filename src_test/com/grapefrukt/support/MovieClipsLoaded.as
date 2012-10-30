package com.grapefrukt.support
{
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.handleSignal;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class MovieClipsLoaded extends Sprite
	{
		protected static var loadComplete:Boolean;
		protected static var mcRobot:MovieClip;

		private static var mcLoader:EmbeddedMovieClipLoader;

		[Before(async, order=1)]
		public function loadAssets():void
		{
			if (loadComplete)
				return;

			mcLoader = new EmbeddedMovieClipLoader();
			handleSignal(this, mcLoader.loadComplete, handleMovieLoaded, 5000);
			mcLoader.load(EmbeddedMovieClips.TESTMC_ROBOT);
		}

		private function handleMovieLoaded(event:SignalAsyncEvent, passThroughData:*):void
		{
			mcRobot = MovieClip(event.args[1]);
		}
		
		public function getLoadedClassNamed(name:String):Class
		{
			return EmbeddedMovieClipLoader.loaderContext.applicationDomain.getDefinition(name) as Class;
		}
	}
}
