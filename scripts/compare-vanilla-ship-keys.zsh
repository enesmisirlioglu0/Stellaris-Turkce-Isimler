#!/bin/zsh

set -euo pipefail

script_dir="${0:A:h}"
project_dir="${script_dir:h}"
name_list="${project_dir}/mod/common/name_lists/turkish_tr.txt"
game_dir="${STELLARIS_GAME_DIR:-${HOME}/Library/Application Support/Steam/steamapps/common/Stellaris}"
vanilla_dir="${game_dir}/common/name_lists"

[[ -f "${name_list}" ]] || { print -u2 -- "HATA: Proje isim listesi bulunamadı."; exit 1; }
[[ -d "${vanilla_dir}" ]] || { print -u2 -- "HATA: Stellaris bulunamadı. STELLARIS_GAME_DIR ile yolu belirt."; exit 1; }

extract_ship_keys() {
	awk '
		BEGIN { inside = 0; depth = 0 }
		/^[[:space:]]*ship_names[[:space:]]*=[[:space:]]*\{/ { inside = 1; depth = 1; next }
		inside {
			original = $0
			if (depth == 1 && match(original, /^[[:space:]]*[[:alnum:]_]+[[:space:]]*=[[:space:]]*\{/)) {
				key = original
				sub(/^[[:space:]]*/, "", key)
				sub(/[[:space:]]*=.*/, "", key)
				print key
			}
			line = original
			opens = gsub(/\{/, "{", line)
			closes = gsub(/\}/, "}", line)
			depth += opens - closes
			if (depth <= 0) exit
		}
	' "$1"
}

missing="$(comm -23 \
	<(for file in "${vanilla_dir}"/*.txt; do extract_ship_keys "${file}"; done | sort -u) \
	<(extract_ship_keys "${name_list}" | sort -u))"

if [[ -n "${missing}" ]]; then
	print -- "Vanilla'da olup pakette sınıfa özel adı olmayan anahtarlar:"
	print -- "${missing}"
	print -- "Not: generic havuz bunlar için geri dönüş sağlar; istersen ayrı blok ekleyebilirsin."
	else
	print -- "Tamam: Kurulu vanilla isim listelerindeki tüm gemi anahtarları pakette karşılanıyor."
fi
