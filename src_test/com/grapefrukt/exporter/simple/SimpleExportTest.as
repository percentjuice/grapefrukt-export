package com.grapefrukt.exporter.simple
{
	import com.grapefrukt.exporter.extractors.AnimationExtractor;
	import com.grapefrukt.exporter.extractors.TextureExtractor;
	import com.grapefrukt.exporter.textures.TextureSheet;
	import com.grapefrukt.support.MovieClipsLoaded;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	import flash.events.Event;

	public class SimpleExportTest extends MovieClipsLoaded
	{
		private static const CLASSNAME_FROM_FLA:String = "RobotCharacterMc";		
		private static const NUM_ROBOT_PARTS:Number = 14;
		
		private var export : SimpleExport;

		[Before]
		public function setup() : void
		{
			export = new SimpleExport(this, "robot");
		}
		
		[Test]
		public function should_export_one_asset_for_each_timeline_movieclip() : void
		{
			var loadedClass:Class = getLoadedClassNamed(CLASSNAME_FROM_FLA);		
			
			AnimationExtractor.extract(export.animations, new loadedClass());
			var textureSheetRetina : TextureSheet = TextureExtractor.extract(new loadedClass());
			export.textures.add(textureSheetRetina);

			export.exportWithCompleteHandler(handleExportCompleteEvent);
		}

		private function handleExportCompleteEvent(event:Event) : void
		{
			assertThat(NUM_ROBOT_PARTS, equalTo(export.textures.head.textures.length));
		}
	}
}