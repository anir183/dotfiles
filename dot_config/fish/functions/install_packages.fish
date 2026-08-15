#!/usr/bin/env fish

function install_packages --description "ensure some packages are installed"
    # create exported global variable if missing
    if not set -q PACKAGES_TO_INSTALL
        set -gx PACKAGES_TO_INSTALL \
            nvim \
            tree-sitter-cli \
            git \
            bat \
            eza \
            fzf \
            ripgrep \
            zoxide \
            fd \
            wget \
            curl \
            gcc \
            clang \
            fnm \
            uv \
            rustup
    end

    # determine package manager
    set -l aur_helper paru

    # install paru if missing
    if not command -q paru
        echo "[ensure_packages] paru not found, attempting installation..."

        if not command -q git
            sudo pacman -Sy --needed --noconfirm git
        end

        if not pacman -Q base-devel >/dev/null 2>&1
            sudo pacman -Sy --needed --noconfirm base-devel
        end

        set -l build_dir /tmp/paru-build-(random)

        git clone https://aur.archlinux.org/paru.git $build_dir

        if test $status -eq 0
            pushd $build_dir >/dev/null
            makepkg -si
            popd >/dev/null
            rm -rf $build_dir
        end

        if not command -q paru
            echo "[ensure_packages] paru installation failed, falling back to pacman"
            set aur_helper pacman
        end
    end

    # install missing packages
    for pkg in $PACKAGES_TO_INSTALL
        if not pacman -Q $pkg >/dev/null 2>&1
            echo "[ensure_packages] installing $pkg"

            switch $aur_helper
                case paru
                    paru -Sy --needed --noconfirm $pkg
                case pacman
                    sudo pacman -Sy --needed --noconfirm $pkg
            end
        end
    end
end
