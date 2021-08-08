#if polymod
package mod;

import lime.utils.AssetLibrary;
import polymod.backends.LimeBackend.LimeModLibrary;
import polymod.backends.OpenFLBackend;
import lime.utils.Assets;

class CustomLibraryBackend extends OpenFLBackend
{
	static var library:String;
	static var assetsLibrary:AssetLibrary;

	public function new(library:String = "mods")
	{
		CustomLibraryBackend.library = library;
		super();
	}

	override function init()
	{
		super.init();
		fallback = getDefaultAssetLibrary();
		modLibrary = new LimeModLibrary(this);
		Assets.registerLibrary(library, modLibrary);
	}

	private static function getDefaultAssetLibrary()
	{
		if (assetsLibrary == null)
			assetsLibrary = Assets.getLibrary(library);
		return assetsLibrary;
	}
}
#end
