#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_dir="$(mktemp -d "${TMPDIR:-/tmp}/hugo-theme-doors-verify.XXXXXX")"

cleanup() {
  rm -rf -- "$output_dir"
}
trap cleanup EXIT

assert_file() {
  local path="$1"

  if [[ ! -f "$path" ]]; then
    printf 'Expected generated file was not found: %s\n' "$path" >&2
    exit 1
  fi
}

assert_contains() {
  local path="$1"
  local expected="$2"

  if ! grep -Fq -- "$expected" "$path"; then
    printf 'Expected text was not found in %s: %s\n' "$path" "$expected" >&2
    exit 1
  fi
}

assert_not_contains() {
  local path="$1"
  local unexpected="$2"

  if grep -Fq -- "$unexpected" "$path"; then
    printf 'Unexpected text was found in %s: %s\n' "$path" "$unexpected" >&2
    exit 1
  fi
}

hugo \
  --source "$repo_root/exampleSite" \
  --themesDir "$repo_root/.." \
  --destination "$output_dir" \
  --cleanDestinationDir \
  --panicOnWarning

english_page="$output_dir/index.html"
japanese_page="$output_dir/ja/index.html"

assert_file "$english_page"
assert_file "$japanese_page"

assert_contains "$english_page" 'lang="en-US"'
assert_contains "$english_page" '<title>Hugo Theme Doors</title>'
assert_contains "$english_page" '<link rel="canonical" href="https://example.org/">'
assert_contains "$english_page" '<link rel="alternate" hreflang="ja-JP" href="https://example.org/ja/">'
assert_contains "$english_page" 'aria-label="Language"'
assert_contains "$english_page" 'aria-current="page">English</span>'
assert_contains "$english_page" 'Name of the work 1'
assert_contains "$english_page" 'The work 4'
assert_contains "$english_page" 'Jane Doe'
assert_contains "$english_page" 'googletagmanager.com/ns.html?id=GTM-xxxxxxxx'
assert_contains "$english_page" '<img'
assert_contains "$english_page" 'href="/css/main.min.'
assert_contains "$english_page" 'integrity="sha256-'

assert_contains "$japanese_page" 'lang="ja-JP"'
assert_contains "$japanese_page" '<title>Hugoテーマ Doors</title>'
assert_contains "$japanese_page" '<link rel="canonical" href="https://example.org/ja/">'
assert_contains "$japanese_page" '<link rel="alternate" hreflang="en-US" href="https://example.org/">'
assert_contains "$japanese_page" 'aria-label="言語"'
assert_contains "$japanese_page" 'aria-current="page">日本語</span>'
assert_contains "$japanese_page" '作品名1'
assert_contains "$japanese_page" '作品4'
assert_contains "$japanese_page" '山田 花子'

for page in "$english_page" "$japanese_page"; do
  assert_not_contains "$page" '<html ⚡'
  assert_not_contains "$page" 'cdn.ampproject.org'
  assert_not_contains "$page" 'amp-boilerplate'
  assert_not_contains "$page" 'amp-custom'
  assert_not_contains "$page" '<amp-img'
  assert_not_contains "$page" 'ampstart-'
done

if ! find "$output_dir/css" -type f -name 'main.min.*.css' -print -quit | grep -q .; then
  printf 'Fingerprint CSS asset was not generated.\n' >&2
  exit 1
fi

printf 'Theme verification passed.\n'
