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

grep -qE '^supported_version="v4\.\*"$' "${descriptor}" || fail "4.x uyumluluk etiketi eksik."
grep -qE '^TURKISH_TR[[:space:]]*=' "${name_list}" || fail "Benzersiz TURKISH_TR isim listesi kimliği eksik."

for key in generic corvette frigate destroyer cruiser battleship titan colossus juggernaut ion_cannon sponsored_colonizer constructor colonizer science transport; do
	grep -qE "^[[:space:]]*${key}[[:space:]]*=" "${name_list}" || fail "Eksik gemi sınıfı: ${key}"
done

balance="$(awk '{ line=$0; opens+=gsub(/\{/, "{", line); closes+=gsub(/\}/, "}", line) } END { print opens - closes }' "${name_list}")"
[[ "${balance}" == "0" ]] || fail "İsim listesindeki süslü parantez dengesi bozuk: ${balance}"

for locale in "${mod_dir}"/localisation/*.yml; do
	[[ -f "${locale}" ]] || fail "Yerelleştirme dosyası bulunamadı."
	grep -q 'name_list_TURKISH_TR:' "${locale}" || fail "Yerelleştirme anahtarı eksik: ${locale:t}"
done

print -- "Tamam: descriptor, isim listesi ve yerelleştirme kontrolleri başarılı."
