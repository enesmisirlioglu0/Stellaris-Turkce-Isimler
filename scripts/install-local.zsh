#!/bin/zsh

set -euo pipefail

script_dir="${0:A:h}"
project_dir="${script_dir:h}"
source_mod_dir="${project_dir}/mod"
template="${project_dir}/local-descriptor.mod.template"
game_data_dir="${STELLARIS_USER_DIR:-${HOME}/Documents/Paradox Interactive/Stellaris}"
mods_dir="${game_data_dir}/mod"
mod_slug="stellaris_turkce_isimler_4x"
target_mod_dir="${mods_dir}/${mod_slug}"
target_descriptor="${mods_dir}/${mod_slug}.mod"

[[ -f "${source_mod_dir}/descriptor.mod" ]] || { print -u2 -- "HATA: Kaynak mod paketi bulunamadı."; exit 1; }
[[ -f "${template}" ]] || { print -u2 -- "HATA: Yerel descriptor şablonu bulunamadı."; exit 1; }

if [[ -e "${target_mod_dir}" || -e "${target_descriptor}" ]]; then
	print -u2 -- "HATA: Yerel test kopyası zaten var; hiçbir dosya değişmedi."
	print -u2 -- "Hedef: ${target_mod_dir}"
	exit 1
fi

mkdir -p "${mods_dir}"
cp -R "${source_mod_dir}" "${target_mod_dir}"
sed "s|__MOD_PATH__|${target_mod_dir}|g" "${template}" > "${target_descriptor}"

print -- "Yerel test modu hazır: ${target_mod_dir}"
print -- "Paradox Launcher'da ayrı bir Playset oluşturup 'Türkler' modunu ekle."
