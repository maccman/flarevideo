package
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	[SWF(width="800", height="600", backgroundColor="#000", frameRate="40")]
	public class FlareVideo extends Sprite
	{
		private var connection:NetConnection;
		private var stream:NetStream;
		private var video:Video;
		private var sound:SoundTransform;
		private var duration:Number = 0;
		private var interval:Number;
		private var flashID:Number;
		private var source:String;
		
		public function FlareVideo()
		{
		  stage.scaleMode = StageScaleMode.NO_SCALE;
		  stage.align     = StageAlign.TOP_LEFT

			flashID = this.root.loaderInfo.parameters.flashID;
			
			connection = new NetConnection();
			connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			connection.connect(null);

			stream = new NetStream(connection);
			stream.checkPolicyFile = true;
			stream.client = {};
			stream.client.onMetaData = metaDataHandler;
			stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, errorHandler);
			stream.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);

			sound = new SoundTransform(1,0);
			stream.soundTransform = sound;
			
			video = new Video();
			video.width  = stage.stageWidth;
			video.height = stage.stageHeight;
			video.attachNetStream(stream);
			addChild(video);
			
			if (ExternalInterface.available) {
			  ExternalInterface.marshallExceptions = true;
        
				ExternalInterface.addCallback("loadSource", loadSource);
				ExternalInterface.addCallback("getStartTime", getStartTime);
				ExternalInterface.addCallback("getCurrentTime", getCurrentTime);
				ExternalInterface.addCallback("setCurrentTime", setCurrentTime);
				ExternalInterface.addCallback("getEndTime", getEndTime);
				ExternalInterface.addCallback("getVolume", getVolume);
				ExternalInterface.addCallback("setVolume", setVolume);
				ExternalInterface.addCallback("play", play);
				ExternalInterface.addCallback("pause", pause);
				
				ExternalInterface.call("FlareVideo.eiTriggerReady", flashID);
			} else {
				trace("ExternalInterface not available");
			}			
		}
		
		public function loadSource(src:String):void {
			source = src;
			stream.play(source);
			stream.pause();
			trigger("canplay");
		}
		
		public function getStartTime():Number {
			return 0;
		}
		
		public function getCurrentTime():Number {
			return stream.time;
		}
		
		public function setCurrentTime(val:Number):void {
			stream.seek(val);
			play();
		}
		
		public function getEndTime():Number {
			return duration;
		}
		
		public function getVolume():Number {
			return sound.volume;
		}
		
		public function setVolume(val:Number):void {
			sound.volume = val;
			stream.soundTransform = sound;
			trigger("volumechange");
		}
		
		public function play():void {
			stream.resume();
			if (interval) clearInterval(interval);
			interval = setInterval(timeUpdate, 500);
			trigger("play");
		}
		
		public function pause():void {
			stream.pause();
			clearInterval(interval);
			trigger("pause");
		}
				
		public function enterFullScreen():void {
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		public function exitFullScreen():void {
			stage.displayState = StageDisplayState.NORMAL;
		}
		
		private function timeUpdate():void {
			trigger("timeupdate");
		}
		
		private function metaDataHandler(i:Object):void {
			duration = i.duration;
			
			var aspectRatio:Number = (video.width / i.width);
			video.height = i.height * aspectRatio;
			video.y      = (stage.stageHeight - video.height) / 2;
			
			trigger("durationchange");
			trigger("loadedmetadata");
			trigger("loadeddata");
		}
		
		private function trigger(name:String):void {
			trace("Triggering event :" + name);
			ExternalInterface.call("FlareVideo.eiTrigger", flashID, name);
		}
		
		private function netStatusHandler(event:NetStatusEvent):void {
			switch (event.info.code) {
				case "NetStream.Play.Stop":
  			  clearInterval(interval);
  			  trigger("ended");
  				break;
				case "NetStream.Play.StreamNotFound":
					trace("Unable to locate video");
				case "NetStream.Play.Failed":
					trigger("error");
					if (interval) clearInterval(interval);
					break;
			}
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
		
		private function errorHandler(event:ErrorEvent):void {
			trace("errorHandler: " + event);
		}
	}
}