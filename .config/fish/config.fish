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
	set -gx VISUAL fresh

	set -x MANPATH $HOME/.nix-profile/share/man $MANPATH

	# if status is-interactive
	# 	if not set -q ZELLIJ
	# 			exec zellij
	# 	end
	# end
	# if status is-interactive # предупреждение перед выходом
  #   zellij setup --generate-auto-start fish | source
	# end

end
