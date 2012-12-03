package
{
	import com.grapefrukt.exporter.extractors.AnimationExtractorTest;
	import com.grapefrukt.exporter.simple.*;

	import flash.display.Sprite;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class FTCTestSuite extends Sprite
	{ 
		public var animationExtractorTest:AnimationExtractorTest;
		public var ftcSimpleExportTest:FTCSimpleExportTest;
		public var simpleExportTest:SimpleExportTest;
	}
}