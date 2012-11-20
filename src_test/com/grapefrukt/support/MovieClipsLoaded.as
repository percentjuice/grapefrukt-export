package com.grapefrukt.support
{
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.handleSignal;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class MovieClipsLoaded extends Sprite
	{
		protected static var loadComplete : Boolean;
		
		private static var classToFramerateMap : Dictionary;
		private static var mcLoader : EmbeddedMovieClipLoader;
		private static var embeddedMovieClips : Array = [EmbeddedMovieClips.TESTMC_ROBOT, EmbeddedMovieClips.TESTMC_CHANGING_ALPHA];
		private static var moviesLoadedCount : int;

		[Before(async, order=1)]
		public function loadAssets() : void
		{
			if (loadComplete)
				return;

			mcLoader = new EmbeddedMovieClipLoader();
			moviesLoadedCount = 0;

			handleSignal(this, mcLoader.loadComplete, handleMovieLoaded, 5000);

			for each (var movieClass : Class in embeddedMovieClips)
				mcLoader.load(movieClass);
		}

		private function handleMovieLoaded(event : SignalAsyncEvent, passThroughData : *) : void
		{
			++moviesLoadedCount;
			
			var assetRequest : Class = event.args[0];
			var loader : Loader = event.args[1];
			var frameRate : int = loader.contentLoaderInfo.frameRate;

			classToFramerateMap ||= new Dictionary();
			classToFramerateMap [assetRequest] = frameRate;

			if (moviesLoadedCount < embeddedMovieClips.length)
				handleSignal(this, mcLoader.loadComplete, handleMovieLoaded, 5000);
		}

		public function hasLoadedClassNamed(name : String) : Boolean
		{
			return EmbeddedMovieClipLoader.loaderContext.applicationDomain.hasDefinition(name);
		}

		public function getLoadedClassNamed(name : String) : Class
		{
			return EmbeddedMovieClipLoader.loaderContext.applicationDomain.getDefinition(name) as Class;
		}
		
		public function getFrameRateForClass(movieClass:Class):int
		{
			return classToFramerateMap[movieClass];
		}
	}
}
