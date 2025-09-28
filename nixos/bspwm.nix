{ config, pkgs, ... }: { 
services.xserver.displayManager.defaultSession = "none+bspwm";
services.xserver.windowManager = {
	bspwm.enable = true; bspwm.configFile = "/home/tibor/.config/bspwm/bspwmrc";
	bspwm.sxhkd.configFile = "/home/tibor/.config/sxhkd/sxhkdrc";
	}; 
}
