package com.grapefrukt.support
{
	public class EmbeddedMovieClips
	{
		[Embed(source="./assets/robot_no_timeline_code.swf", mimeType="application/octet-stream")]
		public static const TESTMC_ROBOT:Class;

		private var getAssetClass:Function;
		private var _assetLabels:Vector.<String>;

		public function EmbeddedMovieClips(getAssetClass:Function, assetLabels:Vector.<String>)
		{
			this.getAssetClass = getAssetClass;
			_assetLabels = assetLabels;
		}

		public function get assetClass():Class
		{
			return getAssetClass();
		}

		public function get assetLabels():Vector.<String>
		{
			return _assetLabels;
		}
	}
}


