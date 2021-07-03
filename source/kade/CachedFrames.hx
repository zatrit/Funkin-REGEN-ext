package kade;

import LoadingState.MultiCallback;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
#if haxe4
import haxe.xml.Access;
#else
import haxe.xml.Fast as Access;
#end
import flash.geom.Rectangle;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import kade.HelperFunctions;

class CachedFrames
{
    public static var cachedInstance:CachedFrames = new CachedFrames();

    function new() {}

    public static function loadLibrary(callback:Void->Void,lib:String="shared")
    {
        cachedInstance.loadFrames(callback,lib);
    }

    public static function loadEverything(callback:Void->Void){
        var callback2:MultiCallback = new MultiCallback(callback);
        loadLibrary(callback2.add("shared"),"shared");
        loadLibrary(callback2.add("clown"),"clown");
        loadLibrary(callback2.add("week6"),"week6");
        loadLibrary(callback2.add("preload"),"preload");
    }

    // so it doesn't brick your computer lol!
    public var cachedGraphics:Map<String,FlxGraphic> = new Map<String,FlxGraphic>();

    public var loaded = false;

    public function fromSparrow(id:String, xmlName:String)
    {
        var graphic = get(id);
        // No need to parse data again
		var frames:FlxAtlasFrames = FlxAtlasFrames.findFrame(graphic);
		if (frames != null)
			return frames;

		frames = new FlxAtlasFrames(graphic);
		var Description = Assets.getText(Paths.file('images/$xmlName.xml', 'clown'));

		var data:Access = new Access(Xml.parse(Description).firstElement());

		for (texture in data.nodes.SubTexture)
		{
			var name = texture.att.name;
			var trimmed = texture.has.frameX;
			var rotated = (texture.has.rotated && texture.att.rotated == "true");
			var flipX = (texture.has.flipX && texture.att.flipX == "true");
			var flipY = (texture.has.flipY && texture.att.flipY == "true");

			var rect = FlxRect.get(Std.parseFloat(texture.att.x), Std.parseFloat(texture.att.y), Std.parseFloat(texture.att.width),
				Std.parseFloat(texture.att.height));

			var size = if (trimmed)
			{
				new Rectangle(Std.parseInt(texture.att.frameX), Std.parseInt(texture.att.frameY), Std.parseInt(texture.att.frameWidth),
					Std.parseInt(texture.att.frameHeight));
			}
			else
			{
				new Rectangle(0, 0, rect.width, rect.height);
			}

			var angle = rotated ? FlxFrameAngle.ANGLE_NEG_90 : FlxFrameAngle.ANGLE_0;

			var offset = FlxPoint.get(-size.left, -size.top);
			var sourceSize = FlxPoint.get(size.width, size.height);

			if (rotated && !trimmed)
				sourceSize.set(size.height, size.width);

			frames.addAtlasFrame(rect, sourceSize, offset, name, angle, flipX, flipY);
		}

        return frames;
    }

    public function get(id:String)
    {
        return cachedGraphics.get(id);
    }

    public function load(id:String, path:String,lib:String="clown")
    {
        if(cachedGraphics.get(id)==null){
            var graph = FlxGraphic.fromAssetKey(Paths.image(path,lib));
            graph.persist = true;
            graph.destroyOnNoUse = false;
            cachedGraphics.set(id,graph);
        }
    }


    public var progress:Float = 0;

    public function loadFrames(callback:Void->Void,lib:String="clown")
    {
        sys.thread.Thread.create(() -> {
            var toBeLoaded:Map<String,String> = new Map<String,String>();
            switch (lib){
                case "clown":
                    #if PRELOAD_ALL
                    toBeLoaded.set('left','hellclwn/Tricky/Left');
                    toBeLoaded.set('right','hellclwn/Tricky/right');
                    toBeLoaded.set('up','hellclwn/Tricky/Up');
                    toBeLoaded.set('down','hellclwn/Tricky/Down');
                    toBeLoaded.set('idle','hellclwn/Tricky/Idle');
                    toBeLoaded.set('grem','fourth/mech/HP GREMLIN');
                    toBeLoaded.set('cln','fourth/Clone');
                    toBeLoaded.set('sign','fourth/mech/Sign_Post_Mechanic');
                    #else
                    if(PlayState.SONG.song.toLowerCase()=="expurgation"){
                        toBeLoaded.set('grem','fourth/mech/HP GREMLIN');
                        toBeLoaded.set('cln','fourth/Clone');
                        toBeLoaded.set('sign','fourth/mech/Sign_Post_Mechanic');
                    }
                    else{
                        toBeLoaded.set('left','hellclwn/Tricky/Left');
                        toBeLoaded.set('right','hellclwn/Tricky/right');
                        toBeLoaded.set('up','hellclwn/Tricky/Up');
                        toBeLoaded.set('down','hellclwn/Tricky/Down');
                        toBeLoaded.set('idle','hellclwn/Tricky/Idle');
                    }
                    #end
                case "shared":
                    toBeLoaded.set('shit','shit');
                    toBeLoaded.set('bad','bad');
                    toBeLoaded.set('good','good');
                    toBeLoaded.set('sick','sick');
                    toBeLoaded.set('combo','combo');
                case "preload":
                    toBeLoaded.set('num0','num0');
                    toBeLoaded.set('num1','num1');
                    toBeLoaded.set('num2','num2');
                    toBeLoaded.set('num3','num3');
                    toBeLoaded.set('num4','num4');
                    toBeLoaded.set('num5','num5');
                    toBeLoaded.set('num6','num6');
                    toBeLoaded.set('num7','num7');
                    toBeLoaded.set('num8','num8');
                    toBeLoaded.set('num9','num9');
                case "week6":
                    toBeLoaded.set('shit-pixel',	'weeb/pixelUI/shit-pixel');
                    toBeLoaded.set('bad-pixel',		'weeb/pixelUI/bad-pixel');
                    toBeLoaded.set('good-pixel',	'weeb/pixelUI/good-pixel');
                    toBeLoaded.set('sick-pixel',	'weeb/pixelUI/sick-pixel');
                    toBeLoaded.set('combo-pixel',	'weeb/pixelUI/combo-pixel');
                    
                    toBeLoaded.set('num0-pixel',	'weeb/pixelUI/num0-pixel');
                    toBeLoaded.set('num1-pixel',	'weeb/pixelUI/num1-pixel');
                    toBeLoaded.set('num2-pixel',	'weeb/pixelUI/num2-pixel');
                    toBeLoaded.set('num3-pixel',	'weeb/pixelUI/num3-pixel');
                    toBeLoaded.set('num4-pixel',	'weeb/pixelUI/num4-pixel');
                    toBeLoaded.set('num5-pixel',	'weeb/pixelUI/num5-pixel');
                    toBeLoaded.set('num6-pixel',	'weeb/pixelUI/num6-pixel');
                    toBeLoaded.set('num7-pixel',	'weeb/pixelUI/num7-pixel');
                    toBeLoaded.set('num8-pixel',	'weeb/pixelUI/num8-pixel');
                    toBeLoaded.set('num9-pixel',	'weeb/pixelUI/num9-pixel');
            }
            // all the big sprites
            var numba = 0;
            for(i in toBeLoaded.keys())
            {
                load(i,toBeLoaded.get(i),lib);
                numba++;
                progress = HelperFunctions.truncateFloat(numba / Lambda.count(toBeLoaded) * 100,2);
            }
            loaded = true;
            callback();
        });
    }
}