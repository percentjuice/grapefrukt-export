package com.grapefrukt.support
{
	import org.osflash.signals.Signal;

	import flash.display.MovieClip;
	import flash.system.LoaderContext;

	/**
	 * Asynchronous Loading of Embedded SWF's.
	 */
	public class EmbeddedMovieClipLoader
	{
		public static var loaderContext : LoaderContext;
		public var loadComplete : Signal;
		private var loaders : Vector.<LoaderHandler>;

		public function EmbeddedMovieClipLoader()
		{
			if (loaderContext == null)
			{
				loaderContext = new LoaderContext;
				loaderContext.allowCodeImport = true;
			}

			loadComplete = new Signal(Class, MovieClip);
			loaders = new <LoaderHandler>[];
		}

		public function load(assetClass : Class) : void
		{
			var loader : LoaderHandler = new LoaderHandler(assetClass);
			loaders[loaders.length] = loader;
			loader.loadComplete.addOnce(loadCompleteListener);
		}

		private function loadCompleteListener(assetRequest : Class, loadedMC : MovieClip, loaderHandler : LoaderHandler) : void
		{
			loaders.splice(loaders.indexOf(loaderHandler), 1);
			loadComplete.dispatch(assetRequest, loadedMC);
		}
	}
}
import com.grapefrukt.support.EmbeddedMovieClipLoader;

import org.osflash.signals.Signal;

import mx.core.ByteArrayAsset;

import flash.display.Loader;
import flash.display.MovieClip;
import flash.events.Event;

/**
 * Handles Embedded Assets so that we know when they are actually loaded.
 * Flash will load them with a slight delay & using a proxy object.
 * ByteArrayAsset method is the solution.
 */
class LoaderHandler
{
	public var loadComplete : Signal;
	private var AssetClass : Class;
	private var byteArrayAssetInstance : ByteArrayAsset;
	private var loader : Loader;

	public function LoaderHandler(AssetClass : Class)
	{
		this.AssetClass = AssetClass;
		byteArrayAssetInstance = new AssetClass();
		loader = new Loader();
		loadComplete = new Signal(Class, MovieClip, LoaderHandler);

		loader.contentLoaderInfo.addEventListener(Event.INIT, loadCompleteListener);
		loader.loadBytes(byteArrayAssetInstance, EmbeddedMovieClipLoader.loaderContext);
	}

	private function loadCompleteListener(event : Event) : void
	{
		loader.contentLoaderInfo.removeEventListener(Event.INIT, loadCompleteListener);
		var content : MovieClip = MovieClip(loader.content);
		loadComplete.dispatch(AssetClass, content, this);
	}
}

