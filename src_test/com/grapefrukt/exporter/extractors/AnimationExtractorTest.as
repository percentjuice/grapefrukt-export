package com.grapefrukt.exporter.extractors
{
	import com.grapefrukt.exporter.animations.Animation;
	import com.grapefrukt.exporter.animations.AnimationFrame;
	import com.grapefrukt.exporter.animations.AnimationPart;
	import com.grapefrukt.exporter.collections.AnimationCollection;
	import com.grapefrukt.support.MovieClipsLoaded;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	/**
	 * @author Chad Stuempges
	 */
	public class AnimationExtractorTest extends MovieClipsLoaded
	{
		private static const LABEL_FROM_FLA:String = "static";
		private static const INSTANCE_FROM_FLA:String = "Head";
		private static const CLASSNAME_FROM_FLA:String = "RobotCharacterMcAlpha";
		
		private var animationCollection:AnimationCollection;

		[Before]
		public function setup() : void
		{
			animationCollection = new AnimationCollection();
		}

		[Test]
		public function should_track_timeline_alpha_changes() : void
		{
			var movieTimelineAlphas:Vector.<Number> = getMovieClipTimelineAlphas();
			var ftcParsedAlphas:Vector.<Number> = getFtcParsedTimelineAlphas();
			
			assertThat(ftcParsedAlphas.length, equalTo(movieTimelineAlphas.length));
			for (var i:int = 0; i<ftcParsedAlphas.length; i++)
				assertThat(ftcParsedAlphas[i], equalTo(movieTimelineAlphas[i]));
		}
		
		private function getMovieClipTimelineAlphas() :Vector.<Number>
		{
			var alphaTimelineMC:MovieClip = getMovieClipForAlphaTest();
			var movieTimelineAlphas:Vector.<Number> = new Vector.<Number>(alphaTimelineMC.framesLoaded, true);

			var fromFrame:int = getFromFrame(LABEL_FROM_FLA);
			var frameCount:int = getToFrame(fromFrame) - fromFrame;
			
			for (var i:int = 0; i <= frameCount; i++)
			{
				alphaTimelineMC.gotoAndStop(fromFrame + i);
				movieTimelineAlphas[i] = alphaTimelineMC.getChildByName(INSTANCE_FROM_FLA).alpha;
			}
			
			return movieTimelineAlphas;
		}
		
		private function getFromFrame(atLabel:String) : int
		{	
			var fromFrame:int = -1;

			var alphaTimelineMC:MovieClip = getMovieClipForAlphaTest();
			alphaTimelineMC.gotoAndStop(atLabel);
			fromFrame = alphaTimelineMC.currentFrame;
			
			return fromFrame;
		}
		
		private function getToFrame(fromFrame:int) : int
		{	
			var toFrame:int = -1;
			var alphaTimelineMC:MovieClip = getMovieClipForAlphaTest();

			var i:int = 0;
			while (toFrame == -1 && i < alphaTimelineMC.currentLabels.length) {
				
				if (i + 1 == alphaTimelineMC.currentLabels.length)
					toFrame = alphaTimelineMC.totalFrames;
				else if (FrameLabel(alphaTimelineMC.currentLabels[i]).frame == fromFrame)
					toFrame = FrameLabel(alphaTimelineMC.currentLabels[i + 1]).frame;

				++i;
			}
			return toFrame;
		}
		
		private function getMovieClipForAlphaTest():MovieClip
		{
			var classInstance:Class = getLoadedClassNamed(CLASSNAME_FROM_FLA);
			return new classInstance();
		}
		
		private function getFtcParsedTimelineAlphas() :Vector.<Number>
		{
			var alphaTimelineMC:MovieClip = getMovieClipForAlphaTest();
			
			AnimationExtractor.extract(animationCollection, alphaTimelineMC);
			
			var frames:Vector.<AnimationFrame> = getAnimationPart(LABEL_FROM_FLA, INSTANCE_FROM_FLA).frames;
			var frameCount:int = frames.length;			
			var ftcParsedTimelineAlphas:Vector.<Number> = new Vector.<Number>(frameCount, true);		

			for (var i:int = 0; i < frameCount; i++)
				ftcParsedTimelineAlphas[i] = frames[i].alpha;
			
			return ftcParsedTimelineAlphas;
		}
		
		private function getAnimationPart(atLabel:String, partName:String) : AnimationPart
		{
			var staticLabelAnimation:Animation = animationCollection.getByName(atLabel);

			var headPart:AnimationPart;
			for each (headPart in staticLabelAnimation.parts) {
				if (headPart.name == partName)
					continue;
			}
			
			return headPart;
		}
	}
}
