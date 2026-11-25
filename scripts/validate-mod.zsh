#!/bin/zsh

set -euo pipefail

script_dir="${0:A:h}"
project_dir="${script_dir:h}"
mod_dir="${project_dir}/mod"
descriptor="${mod_dir}/descriptor.mod"
name_list="${mod_dir}/common/name_lists/turkish_tr.txt"

fail() {
	print -u2 -- "HATA: $*"
	exit 1
}

[[ -f "${descriptor}" ]] || fail "descriptor.mod bulunamadı."
[[ -f "${name_list}" ]] || fail "Türkçe isim listesi bulunamadı."

if grep -qE '^[[:space:]]*remote_file_id[[:space:]]*=' "${descriptor}"; then
	fail "Paket eski Steam Workshop kimliği içeriyor."
fi

grep -qE '^supported_version="v4\.6\.\*"$' "${descriptor}" || fail "4.6 uyumluluk etiketi eksik."
grep -qE '^TURKISH_TR[[:space:]]*=' "${name_list}" || fail "Benzersiz TURKISH_TR isim listesi kimliği eksik."

[[ "$(xxd -p -l 3 "${name_list}")" != "efbbbf" ]] || fail "İsim listesi UTF-8 BOM içeriyor; Stellaris bunu kabul etmiyor."

for key in generic corvette destroyer cruiser battleship titan colossus juggernaut ion_cannon sponsored_colonizer constructor colonizer science transport military_station_small; do
	grep -qE "^[[:space:]]*${key}[[:space:]]*=" "${name_list}" || fail "Eksik gemi sınıfı: ${key}"
done

grep -qE '^[[:space:]]*ship_class_names[[:space:]]*=' "${name_list}" || fail "Gemi sınıfı adları eksik."
grep -qE '^[[:space:]]*fleet_names[[:space:]]*=' "${name_list}" || fail "Filo adları eksik."
grep -qE '^[[:space:]]*army_names[[:space:]]*=' "${name_list}" || fail "Ordu adları eksik."
grep -qE '^[[:space:]]*planet_names[[:space:]]*=' "${name_list}" || fail "Gezegen adları eksik."
grep -qE '^[[:space:]]*character_names[[:space:]]*=' "${name_list}" || fail "Karakter adları eksik."

balance="$(awk '{ line=$0; opens+=gsub(/\{/, "{", line); closes+=gsub(/\}/, "}", line) } END { print opens - closes }' "${name_list}")"
[[ "${balance}" == "0" ]] || fail "İsim listesindeki süslü parantez dengesi bozuk: ${balance}"

for locale in "${mod_dir}"/localisation/*.yml; do
	[[ -f "${locale}" ]] || fail "Yerelleştirme dosyası bulunamadı."
	grep -q 'name_list_TURKISH_TR:' "${locale}" || fail "Yerelleştirme anahtarı eksik: ${locale:t}"
done

while IFS= read -r key; do
	[[ -n "${key}" ]] || continue
	for locale in "${mod_dir}"/localisation/*.yml; do
		grep -qE "^[[:space:]]*${key}:" "${locale}" || fail "İsim anahtarı eksik: ${key} (${locale:t})"
	done
done < <(rg --no-filename --only-matching 'TRK_(CHR_[A-Za-z0-9_]+|FLEET_SEQUENTIAL|ARMY_SEQUENTIAL)' "${name_list}" | sort -u)

print -- "Tamam: descriptor, isim listesi ve yerelleştirme kontrolleri başarılı."
