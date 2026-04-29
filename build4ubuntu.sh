#!/usr/bin/env bash

set -euo pipefail

PACKAGE_NAME="maliit-keyboard"
#FORK_URL="https://github.com/cwt/maliit-keyboard-robust.git"
#FORK_URL="https://github.com/snetsplit/keyboard.git"
#FORK_URL="https://github.com/vitovt/keyboard/tree/dev-kcm_module"
FORK_URL="https://github.com/vitovt/keyboard.git"
DEFAULT_BUILD_ROOT="${HOME}/build/maliit-vitovt"
INSTALL_BUILD_DEPS=0
BUILD_ROOT=""
REUSE_BUILD_ID=""

usage() {
    cat <<'EOF'
Usage: build4ubuntu.sh [options]

Build a KDE neon/Ubuntu .deb package for maliit-keyboard from the current
selected FORK branch, preserving Debian packaging from the
current source package in apt repositories.

Options:
  --build-root PATH         Directory for all build artifacts.
                            Default: ~/build/maliit-vitovt
  --reuse BUILD_ID          Reuse an existing build session directory instead
                            of creating a new build-YYYYMMDD-HHMMSS directory.
                            BUILD_ID is the final directory name, for example:
                            build-20260429-190621
                            Existing apt source/debian packaging and source
                            git checkout are reused when possible. If the
                            source tree already has FORK_URL as its git origin,
                            the script updates it instead of cloning again.
  --install-build-deps      Run sudo apt-get build-dep -y maliit-keyboard
  -h, --help                Show this help

The script does not install the resulting packages.
EOF
}

log() {
    printf '[*] %s\n' "$*"
}

fail() {
    printf '[!] %s\n' "$*" >&2
    exit 1
}

require_cmd() {
    command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"
}

parse_args() {
    while (($# > 0)); do
        case "$1" in
            --build-root)
                (($# >= 2)) || fail "Missing value for --build-root"
                BUILD_ROOT="$2"
                shift 2
                ;;
            --install-build-deps)
                INSTALL_BUILD_DEPS=1
                shift
                ;;
            --reuse)
                (($# >= 2)) || fail "Missing value for --reuse"
                REUSE_BUILD_ID="$2"
                shift 2
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                fail "Unknown argument: $1"
                ;;
        esac
    done
}

check_apt_source_available() {
    if ! apt-cache showsrc "$PACKAGE_NAME" >/dev/null 2>&1; then
        fail "Source package metadata for $PACKAGE_NAME is unavailable. Enable deb-src repositories first."
    fi
}

get_source_version() {
    apt-cache showsrc "$PACKAGE_NAME" | awk '
        /^Version:/ && !seen {
            print $2
            seen=1
        }
        END {
            exit seen ? 0 : 1
        }
    '
}

download_source_package() {
    local source_version="$1"
    log "Downloading source package $PACKAGE_NAME=$source_version"
    apt-get source "$PACKAGE_NAME=$source_version"
}

restore_debian_packaging() {
    local source_tree="$1"
    local debian_cache="$2"

    [[ -d "$debian_cache" ]] || fail "Expected cached Debian packaging not found: $debian_cache"

    rm -rf "${source_tree}/debian"
    cp -a "$debian_cache" "${source_tree}/debian"
}

update_or_clone_source_tree() {
    local clone_url="$1"
    local fork_ref="$2"
    local source_tree="$3"

    if [[ -d "${source_tree}/.git" ]]; then
        local current_url
        local target_branch
        current_url="$(git -C "$source_tree" remote get-url origin)"
        [[ "$current_url" == "$clone_url" ]] || fail "Cached fork checkout uses a different origin: $current_url"

        log "Updating existing fork checkout"
        git -C "$source_tree" reset --hard HEAD
        git -C "$source_tree" fetch --depth 1 origin
        if [[ -n "$fork_ref" ]]; then
            target_branch="$fork_ref"
        else
            target_branch="$(git -C "$source_tree" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')"
            target_branch="${target_branch:-$(git -C "$source_tree" branch --show-current)}"
            target_branch="${target_branch:-master}"
        fi

        log "Using fork branch: $target_branch"
        git -C "$source_tree" show-ref --verify --quiet "refs/remotes/origin/${target_branch}" \
            || fail "Remote branch not found: origin/${target_branch}"
        git -C "$source_tree" checkout -B "$target_branch" "origin/$target_branch"
        git -C "$source_tree" reset --hard "origin/$target_branch"
        return
    fi

    if [[ -e "$source_tree" ]]; then
        log "Replacing non-git source tree with fork checkout"
        rm -rf "$source_tree"
    fi

    log "Cloning fork from GitHub"
    if [[ -n "$fork_ref" ]]; then
        log "Using fork branch: $fork_ref"
        git clone --depth 1 --branch "$fork_ref" "$clone_url" "$source_tree"
    else
        git clone --depth 1 "$clone_url" "$source_tree"
    fi
}

install_build_deps_if_requested() {
    if [[ "$INSTALL_BUILD_DEPS" -eq 1 ]]; then
        log "Installing build dependencies with sudo"
        sudo apt-get update
        sudo apt-get build-dep -y "$PACKAGE_NAME"
    else
        log "Skipping build-dependency installation"
        printf '    If the build fails on missing deps, run:\n'
        printf '    sudo apt-get update && sudo apt-get build-dep -y %s\n' "$PACKAGE_NAME"
    fi
}

apply_local_uk_layout_changes() {
    local qml_file="$1"
    local before_hash
    local after_hash

    before_hash="$(sha256sum "$qml_file" | awk '{print $1}')"

    perl -0pi -e '
        s/CharKey \{ label: "е"; shifted: "Е"; extended: \["5"\]; extendedShifted: \["5"\] \}/CharKey { label: "е"; shifted: "Е"; extended: ["5", "ё"]; extendedShifted: ["5", "Ё"] }/g;
        s/CharKey \{ label: "ї"; shifted: "Ї"; extended: \["ʼ"\]; extendedShifted: \["ʼ"\]; rightSide: true; \}/CharKey { label: "ї"; shifted: "Ї"; extended: ["ъ", "ʼ"]; extendedShifted: ["Ъ", "ʼ"]; rightSide: true; }/g;
        s/CharKey \{ label: "і"; shifted: "І"; \}/CharKey { label: "і"; shifted: "І"; extended: ["ы"]; extendedShifted: ["Ы"] }/g;
        s/CharKey \{ label: "є"; shifted: "Є"; rightSide: true; \}/CharKey { label: "є"; shifted: "Є"; extended: ["э"]; extendedShifted: ["Э"]; rightSide: true; }/g;
    ' "$qml_file"

    after_hash="$(sha256sum "$qml_file" | awk '{print $1}')"

    grep -Fq 'extended: ["5", "ё"]' "$qml_file" || fail "Failed to apply 'ё' change to Keyboard_uk.qml"
    grep -Fq 'extended: ["ъ", "ʼ"]' "$qml_file" || fail "Failed to apply 'ъ' change to Keyboard_uk.qml"
    grep -Fq 'extended: ["ы"]' "$qml_file" || fail "Failed to apply 'ы' change to Keyboard_uk.qml"
    grep -Fq 'extended: ["э"]' "$qml_file" || fail "Failed to apply 'э' change to Keyboard_uk.qml"

    if [[ "$before_hash" == "$after_hash" ]]; then
        log "Local Ukrainian keyboard layout changes were already present"
    fi
}

resolve_fork_source() {
    local raw_url="$1"
    local clone_url="$raw_url"
    local fork_ref=""

    if [[ "$raw_url" =~ ^https://github\.com/([^/]+)/([^/]+)/tree/(.+)$ ]]; then
        clone_url="https://github.com/${BASH_REMATCH[1]}/${BASH_REMATCH[2]}.git"
        fork_ref="${BASH_REMATCH[3]}"
    fi

    printf '%s\n%s\n' "$clone_url" "$fork_ref"
}

main() {
    parse_args "$@"

    BUILD_ROOT="${BUILD_ROOT:-$DEFAULT_BUILD_ROOT}"

    require_cmd apt-cache
    require_cmd apt-get
    require_cmd git
    require_cmd dch
    require_cmd debuild
    require_cmd dpkg-parsechangelog
    require_cmd sha256sum
    require_cmd perl
    require_cmd find
    require_cmd awk
    require_cmd sed
    require_cmd date

    check_apt_source_available

    local source_version
    source_version="$(get_source_version)"
    [[ -n "$source_version" ]] || fail "Could not determine source package version for $PACKAGE_NAME"

    local upstream_version
    upstream_version="${source_version%-*}"

    local session_root
    if [[ -n "$REUSE_BUILD_ID" ]]; then
        [[ "$REUSE_BUILD_ID" != */* ]] || fail "--reuse expects a build directory name, not a path"
        session_root="${BUILD_ROOT}/${REUSE_BUILD_ID}"
        log "Reusing build session: $session_root"
    else
        local build_stamp
        build_stamp="$(date -u +%Y%m%d-%H%M%S)"
        session_root="${BUILD_ROOT}/build-${build_stamp}"
    fi

    local output_dir
    output_dir="${session_root}/output"

    mkdir -p "$session_root" "$output_dir"
    cd "$session_root"

    install_build_deps_if_requested

    local source_tree
    source_tree="${session_root}/${PACKAGE_NAME}-${upstream_version}"
    local debian_cache
    debian_cache="${session_root}/debian.base"
    if [[ -d "$source_tree" ]]; then
        log "Using existing source tree: $source_tree"
        if [[ ! -d "$debian_cache" ]]; then
            [[ -d "${source_tree}/debian" ]] || fail "Existing source tree has no debian directory: $source_tree"
            cp -a "${source_tree}/debian" "$debian_cache"
        fi
    else
        download_source_package "$source_version"
        [[ -d "$source_tree" ]] || fail "Expected extracted source tree not found: $source_tree"
        cp -a "${source_tree}/debian" "$debian_cache"
    fi

    local fork_clone_url
    local fork_ref
    mapfile -t fork_source < <(resolve_fork_source "$FORK_URL")
    fork_clone_url="${fork_source[0]}"
    fork_ref="${fork_source[1]}"

    update_or_clone_source_tree "$fork_clone_url" "$fork_ref" "$source_tree"
    restore_debian_packaging "$source_tree" "$debian_cache"

    local fork_short_sha
    fork_short_sha="$(git -C "$source_tree" rev-parse --short HEAD)"

    local uk_qml_file
    uk_qml_file="$(find "$source_tree" -type f -name 'Keyboard_uk.qml' -print -quit)"
    [[ -n "$uk_qml_file" ]] || fail "Could not find Keyboard_uk.qml in forked source tree"

    log "Applying local Ukrainian keyboard layout changes"
    apply_local_uk_layout_changes "$uk_qml_file"

    cd "$source_tree"

    local base_version
    base_version="$(dpkg-parsechangelog -SVersion)"
    [[ -n "$base_version" ]] || fail "Could not read Debian package version from changelog"

    local custom_version
    custom_version="${base_version}+vitovt1+git${fork_short_sha}"

    log "Updating Debian changelog to ${custom_version}"
    DEBEMAIL="${DEBEMAIL:-local@localhost}" DEBFULLNAME="${DEBFULLNAME:-Local Builder}" \
        dch --newversion "$custom_version" \
            "Build selected community fork branch for KDE neon with local Ukrainian layout customizations."

    log "Building binary package(s)"
    debuild -b -uc -us

    log "Collecting resulting .deb artifacts"
    find "$session_root" -maxdepth 1 -type f \( -name '*.deb' -o -name '*.changes' -o -name '*.buildinfo' -o -name '*.ddeb' \) \
        -exec mv -t "$output_dir" {} +

    cat <<EOF

Build completed.

Artifacts:
  $output_dir

Install:
  cd "$output_dir"
  sudo apt install ./*.deb

Rollback to repository package:
  sudo apt install --reinstall "$PACKAGE_NAME"

If apt prefers the local custom version during rollback:
  sudo apt install --reinstall "$PACKAGE_NAME=$source_version"
EOF
}

main "$@"
