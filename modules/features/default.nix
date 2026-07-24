{myLib, ...}:
{
	imports = myLib.importAllFrom ./. { inheritModuleInfo = true; };
}
