package com.grapefrukt.support
{
	import org.osflash.signals.utils.SignalAsyncEvent;
	import org.osflash.signals.utils.handleSignal;

	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class MovieClipsLoaded extends Sprite
	{
		protected static var loadComplete : Boolean;
		private static var mcLoader : EmbeddedMovieClipLoader;
		private static var embeddedMovieClips : Array = [EmbeddedMovieClips.TESTMC_ROBOT, EmbeddedMovieClips.TESTMC_CHANGING_ALPHA];
		private static var moviesLoaded : Vector.<MovieClip> = new <MovieClip>[];

		[Before(async, order=1)]
		public function loadAssets() : void
		{
			if (loadComplete)
				return;

			mcLoader = new EmbeddedMovieClipLoader();
				
			handleSignal(this, mcLoader.loadComplete, handleMovieLoaded, 5000);

			for each (var movieClass : Class in embeddedMovieClips)
				mcLoader.load(movieClass);
		}

		private function handleMovieLoaded(event : SignalAsyncEvent, passThroughData : *) : void
		{
			moviesLoaded[moviesLoaded.length] = MovieClip(event.args[1]);

			if (moviesLoaded.length < embeddedMovieClips.length)
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
	}
}
