--should make this config work outside of nix
--if loaded through nix module, then it replaces values with nix store paths
--if value wasn't replaced (or used outside nix), then it removes @ from the values
local pkgs = {
	["hyprpaper"] = "@hyprpaper@",
	["dbus-update-activation-environment"] = "@dbus-update-activation-environment@"
};
for k,v in pairs(pkgs) do
	if (string.sub(v, 1, 1) == "@" and string.sub(v, v.len(), v.len()) == "@") then
		pkgs[k] = string.sub(v, 2, v.len() - 2);
	end
end

hl.animation({
	leaf = "windows",
	enabled = false
})

hl.config({
	general = {
		layout = "scroll"
	},
	misc = {
		disable_splash_rendering = true,
		disable_hyprland_logo = true
	}
})


local mainMod = "SUPER"
local binds = {
	{mainMod.." + R", hl.dsp.exec_cmd("rofi -show drun")},
	{mainMod.." + Q", hl.dsp.window.close()},
	{mainMod.." + T", hl.dsp.exec_cmd("kitty")}
}

hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd(pkgs["hyprpaper"])
	hl.exec_cmd(pkgs["dbus-update-activation-environment"] .. " --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target")
end)

for k,v in pairs(binds) do
	hl.bind(v[1],v[2])		
end
