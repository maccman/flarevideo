
###Features

  * HTML5 video with Flash fallback
  * Easy CSS/JS/HTML customization and theming
  * Full screen support
  * Completely open source and free for commercial use

###Formats

Format supported depends on your browser. 

  - All browsers: MP4, FLV
  - Firefox: Ogg
  - Safari: MP4, MOV

###Browser support

  * Safari
  * Firefox
  * IE 7 >=

###Examples

    jQuery(function($){
      var fv = $("#video").flareVideo();
      fv.load([
        {
          src:  'http://your/site.mp4',
          type: 'video/mp4'
        },
      ]);
    });
    
###Requirements

* [jQuery](http://jquery.com)
* [jquery.flash.js](http://jquery.lukelutman.com/plugins/flash)
* [jquery.ui.slider](http://jqueryui.com)

###Usage

To use, you need to include all the required JavaScript libraries (above), and then flarevideo.js. 
You then need to include flarevideo.css, and a theme - such as flarevideo.default.css.
Once that is sorted you may need to fix the path to the images in the CSS files, and the path to the swf (flashSrc option).

Then, just follow the examples or API below.

###API

New FlareVideo. Options:

 * autoplay
 * width
 * height
 * poster      (src to poster image)
 * preload
 * autobuffer
 * keyShortcut (add listeners for space/escape key events)
 * flashSrc    (path to flash file)
 * useNative
 
Called on a jQuery element.

    jQuery.flareVideo(options);

Load sources:
e.g.
 flareVideo.load([{
  src: 'video.mp4',
  type: 'video/mp4'
 }]);

    FlareVideo#load(sources)

Self explanatory:

    FlareVideo#play
    FlareVideo#pause
    FlareVideo#stop
    FlareVideo#togglePlay
    FlareVideo#fullScreen(state = true)
    FlareVideo#toggleFullScreen

Seek to position in video
    
    FlareVideo#seek(position)

Set video volume, number between 0.0 and 1.0

    FlareVideo#setVolume(volume)

Remove video from the DOM
    
    FlareVideo#remove

##Events

Add callback for when FlareVideo is setup
    
    FlareVideo#ready(func)

Bind callback to event

    FlareVideo#bind(name, callback)

Bind single callback to event
    
    FlareVideo#one(name, callback)

Event types:

  * click
  * dblclick
  * onerror
  * onloadeddata
  * oncanplay
  * ondurationchange
  * ontimeupdate
  * onpause
  * onplay
  * onended
  * onvolumechange
  
You can also access the events on the FlareVideo instance. e.g.
  
    FlareVideo#onplay(callback)
    
###Theming

Take a look at flarevideo.default.css and flarevideo.spotify.css for tips.

You'll need to style both the input range element, and the jQuery UI slider fallback.

When the video player is idle, a class of idle will be added to it. You can hide the controls using that class.

When the video player is playing, a class of playing will be added to it.

The state of the video player is available under the data-state attribute.

###Flash

Flash is, by default, a fallback when HTML5 video is not supported. 

If you pass a relative path as a video file src, Flash will take that relative path from the SWF.

If the video source path you pass is on a separate domain, you will need to set up a [crossdomain.xml](http://www.adobe.com/devnet/articles/crossdomain_policy_file_spec.html) file.