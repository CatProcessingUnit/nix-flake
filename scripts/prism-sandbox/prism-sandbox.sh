#!/run/current-system/sw/bin/bash

# bwrap sandbox for prism launcher instances

set -x

args=()

if [[ -n "$WAYLAND_DISPLAY" ]]; then
	args+=(--ro-bind-try "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" "/tmp/$WAYLAND_DISPLAY")
fi

while true; do
	case $1 in
		-n | --nvidia)
			args+=(	
				--dev-bind-try /dev/nvidia0 /dev/nvidia0 \
				--dev-bind-try /dev/nvidiactl /dev/nvidiactl \
				--dev-bind-try /dev/nvidia-modeset /dev/nvidia-modeset \
				--dev-bind-try /dev/nvidia-uvm /dev/nvidia-uvm \
				--dev-bind-try /dev/nvidia-uvm-tools /dev/nvidia-uvm-tools \
				)
			shift
			;;
		--no-network)
			args+=(
				--unshare-net
				)
			shift
			;;
		-x | --xdisplay)
			if [[ "$DISPLAY" == :* ]]; then
				socket="/tmp/.X11-unix/X${DISPLAY#:}"
				args+=(--ro-bind-try "$socket" "$socket")
				args+=(--ro-bind-try "$XAUTHORITY" "$XAUTHORITY")
			else
				echo "display is unset!"
				exit 1
			fi
			shift
			;;
		--)
			shift
			break
			;;
		*)
			echo "unknown option $1"
			exit 1
			;;

	esac
done

bwrap \
	--unshare-user \
	--unshare-pid \
	--unshare-ipc \
	--unshare-uts \
	--unshare-cgroup \
	--new-session \
	--tmpfs /tmp \
	--proc /proc \
	--ro-bind /nix /nix \
	--ro-bind /etc /etc \
	--dev /dev \
	--share-net \
	--die-with-parent \
	--ro-bind /run/opengl-driver /run/opengl-driver \
	--bind "$INST_DIR" "$INST_DIR" \
	--ro-bind "$HOME/.local/share/PrismLauncher/libraries" "$HOME/.local/share/PrismLauncher/libraries" \
	--ro-bind "$HOME/.local/share/PrismLauncher/assets" "$HOME/.local/share/PrismLauncher/assets" \
	--unsetenv XDG_CONFIG_DIRS \
	--unsetenv DBUS_SESSION_BUS_ADDRESS \
	--unsetenv XDG_DATA_HOME \
	--setenv XDG_RUNTIME_DIR /tmp \
	--ro-bind-try "$XDG_RUNTIME_DIR/pulse" /tmp/pulse \
	--ro-bind-try "$XDG_RUNTIME_DIR/pipewire-0" /tmp/pipewire-0 \
	--ro-bind-try /sys/devices/pci0000:00 /sys/devices/pci0000:00 \
	--ro-bind-try /sys/devices/system/cpu /sys/devices/system/cpu \
	--ro-bind-try /sys/class /sys/class \
	--ro-bind-try /sys/dev/char /sys/dev/char \
	--ro-bind-try "$HOME/.config/MangoHud" "$HOME/.config/MangoHud" \
	--dev-bind-try /dev/dri /dev/dri \
	"${args[@]}" \
	-- \
	"$@"
