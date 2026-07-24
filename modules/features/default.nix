{myLib, ...}:
{
	imports = 
		myLib.importAllFrom ./. { inheritModuleInfo = true; } ++
		myLib.importAllFrom ./overlays {} ++
		myLib.importAllFrom ./drivers {};
}
