if status is-interactive
# Commands to run in interactive sessions can go here
  function y
		set tmp (mktemp -t "yazi-cwd.XXXXXX")
		command yazi $argv --cwd-file="$tmp"
		if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
			builtin cd -- "$cwd"
		end
		command rm -f -- "$tmp"
	end

	zoxide init fish | source

  set -gx EDITOR fresh
  set -gx VISUAL "fresh --wait"

	set -x MANPATH $HOME/.nix-profile/share/man $MANPATH
end
