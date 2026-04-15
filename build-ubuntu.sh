#!/usr/bin/env bash

set -euo pipefail

PACKAGE_NAME="maliit-keyboard"
FORK_URL="https://github.com/vitovt/keyboard.git"
DEFAULT_BUILD_ROOT="${HOME}/build/maliit-community"
INSTALL_BUILD_DEPS=0
BUILD_KCM=0
BUILD_ROOT=""
KCM_BUILD_DEP_PACKAGES=(
    extra-cmake-modules
    libkf6config-dev
    libkf6coreaddons-dev
    libkf6i18n-dev
    libkf6kcmutils-dev
    qt6-base-dev
    qt6-declarative-dev
)

usage() {
    cat <<'EOF'
Usage: build-ubuntu.sh [options]

Build KDE neon/Ubuntu .deb package(s) for maliit-keyboard from the current
fork checkout, preserving Debian packaging from the current source package in
apt repositories.

Options:
  --build-root PATH         Directory for all build artifacts.
                            Default: ~/build/maliit-community
  --install-build-deps      Run sudo apt-get build-dep -y maliit-keyboard
                            and install optional KCM build deps when enabled.
  --with-kcm                Build the Plasma 6 Maliit System Settings module
                            and bundle it into the main maliit-keyboard .deb.
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
            --with-kcm)
                BUILD_KCM=1
                shift
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

install_build_deps_if_requested() {
    if [[ "$INSTALL_BUILD_DEPS" -eq 1 ]]; then
        log "Installing build dependencies with sudo"
        sudo apt-get update
        sudo apt-get build-dep -y "$PACKAGE_NAME"
        if [[ "$BUILD_KCM" -eq 1 ]]; then
            sudo apt-get install -y "${KCM_BUILD_DEP_PACKAGES[@]}"
        fi
    else
        log "Skipping build-dependency installation"
        printf '    If the build fails on missing deps, run:\n'
        printf '    sudo apt-get update && sudo apt-get build-dep -y %s\n' "$PACKAGE_NAME"
        if [[ "$BUILD_KCM" -eq 1 ]]; then
            printf '    sudo apt-get install -y %s\n' "${KCM_BUILD_DEP_PACKAGES[*]}"
        fi
    fi
}

set_debian_plasma_kcm_option() {
    local rules_file="$1"
    local enable_flag="$2"

    perl -0pi -e 's/-DCMAKE_INSTALL_PREFIX=\/usr\b/-DCMAKE_INSTALL_PREFIX=\/usr -Denable-plasma-kcm='"$enable_flag"'/g' "$rules_file"

    grep -Fq -- "-Denable-plasma-kcm=${enable_flag}" "$rules_file" \
        || fail "Failed to set -Denable-plasma-kcm=${enable_flag} in debian/rules"
}

patch_debian_control_for_kcm() {
    local control_file="$1"

    perl -0pi -e 's/sqlite3\nStandards-Version:/sqlite3,\n               extra-cmake-modules,\n               libkf6config-dev,\n               libkf6coreaddons-dev,\n               libkf6i18n-dev,\n               libkf6kcmutils-dev,\n               qt6-base-dev,\n               qt6-declarative-dev\nStandards-Version:/s' "$control_file"

    grep -Fq 'qt6-base-dev' "$control_file" \
        || fail "Failed to add Qt 6/KF 6 build dependencies to debian/control"

    perl -0pi -e 's/qml-module-qtquick2,\n         \$\{misc:Depends\}/qml-module-qtquick2,\n         kf6-kcmutils,\n         kf6-kconfig,\n         kf6-kcoreaddons,\n         kf6-ki18n,\n         kf6-kirigami,\n         qt6-base,\n         qt6-declarative,\n         \$\{misc:Depends\}/s' "$control_file"

    grep -Fq 'kf6-kcmutils' "$control_file" \
        || fail "Failed to add KCM runtime dependencies to debian/control"
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
    [[ "$before_hash" != "$after_hash" ]] || fail "Keyboard_uk.qml was not modified. Upstream layout format may have changed."

    grep -Fq 'extended: ["5", "ё"]' "$qml_file" || fail "Failed to apply 'ё' change to Keyboard_uk.qml"
    grep -Fq 'extended: ["ъ", "ʼ"]' "$qml_file" || fail "Failed to apply 'ъ' change to Keyboard_uk.qml"
    grep -Fq 'extended: ["ы"]' "$qml_file" || fail "Failed to apply 'ы' change to Keyboard_uk.qml"
    grep -Fq 'extended: ["э"]' "$qml_file" || fail "Failed to apply 'э' change to Keyboard_uk.qml"
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

    local build_stamp
    build_stamp="$(date -u +%Y%m%d-%H%M%S)"

    local session_root
    session_root="${BUILD_ROOT}/build-${build_stamp}"

    local output_dir
    output_dir="${session_root}/output"

    mkdir -p "$session_root" "$output_dir"
    cd "$session_root"

    install_build_deps_if_requested
    download_source_package "$source_version"

    local source_tree
    source_tree="${session_root}/${PACKAGE_NAME}-${upstream_version}"
    [[ -d "$source_tree" ]] || fail "Expected extracted source tree not found: $source_tree"

    local saved_debian_dir
    saved_debian_dir="${session_root}/debian.saved"
    mv "${source_tree}/debian" "$saved_debian_dir"

    local fork_dir
    fork_dir="${session_root}/maliit-keyboard-fork"
    log "Cloning current fork from GitHub"
    git clone --depth 1 "$FORK_URL" "$fork_dir"

    local fork_short_sha
    fork_short_sha="$(git -C "$fork_dir" rev-parse --short HEAD)"

    rm -rf "$source_tree"
    mv "$fork_dir" "$source_tree"
    rm -rf "${source_tree}/.git"
    mv "$saved_debian_dir" "${source_tree}/debian"

    local uk_qml_file
    uk_qml_file="$(find "$source_tree" -type f -name 'Keyboard_uk.qml' -print -quit)"
    [[ -n "$uk_qml_file" ]] || fail "Could not find Keyboard_uk.qml in forked source tree"

    log "Applying local Ukrainian keyboard layout changes"
    apply_local_uk_layout_changes "$uk_qml_file"

    log "Configuring Debian build flags"
    set_debian_plasma_kcm_option "${source_tree}/debian/rules" "$([[ "$BUILD_KCM" -eq 1 ]] && printf 'ON' || printf 'OFF')"
    if [[ "$BUILD_KCM" -eq 1 ]]; then
        log "Patching Debian packaging to bundle the Maliit KCM"
        patch_debian_control_for_kcm "${source_tree}/debian/control"
    fi

    cd "$source_tree"

    local base_version
    base_version="$(dpkg-parsechangelog -SVersion)"
    [[ -n "$base_version" ]] || fail "Could not read Debian package version from changelog"

    local custom_version_suffix
    custom_version_suffix="+community1+git${fork_short_sha}"
    if [[ "$BUILD_KCM" -eq 1 ]]; then
        custom_version_suffix="${custom_version_suffix}+kcm1"
    fi

    local custom_version
    custom_version="${base_version}${custom_version_suffix}"

    local changelog_message
    changelog_message="Build current fork for KDE neon/Ubuntu with local Ukrainian layout customizations."
    if [[ "$BUILD_KCM" -eq 1 ]]; then
        changelog_message="Build current fork for KDE neon/Ubuntu with local Ukrainian layout customizations and bundle the optional Plasma 6 Maliit KCM."
    fi

    log "Updating Debian changelog to ${custom_version}"
    DEBEMAIL="${DEBEMAIL:-local@localhost}" DEBFULLNAME="${DEBFULLNAME:-Local Builder}" \
        dch --newversion "$custom_version" \
            "$changelog_message"

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
