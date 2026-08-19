#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_dir="$(mktemp -d "${TMPDIR:-/tmp}/hugo-theme-doors-verify.XXXXXX")"
legacy_output_dir="$(mktemp -d "${TMPDIR:-/tmp}/hugo-theme-doors-legacy-verify.XXXXXX")"

cleanup() {
  rm -rf -- "$output_dir"
  rm -rf -- "$legacy_output_dir"
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

assert_occurs_before() {
  local path="$1"
  local first="$2"
  local second="$3"
  local first_match
  local second_match

  first_match="$(grep -nFm1 -- "$first" "$path")"
  second_match="$(grep -nFm1 -- "$second" "$path")"

  if (( ${first_match%%:*} >= ${second_match%%:*} )); then
    printf 'Expected text to occur before another in %s: %s / %s\n' "$path" "$first" "$second" >&2
    exit 1
  fi
}

hugo \
  --source "$repo_root/exampleSite" \
  --themesDir "$repo_root/.." \
  --destination "$output_dir" \
  --cleanDestinationDir \
  --noBuildLock \
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
assert_not_contains "$english_page" '<p class="site-description">'
assert_contains "$english_page" '<meta name="description" content="A collection of my works.">'
assert_contains "$english_page" '<meta property="og:image" content="https://example.org/images/work1.jpg">'
assert_contains "$english_page" '<meta name="twitter:site" content="@username">'
assert_contains "$english_page" 'Name of the work 1'
assert_contains "$english_page" 'class="featured-projects"'
assert_contains "$english_page" '<section class="project-group" aria-labelledby="featured-work">'
assert_contains "$english_page" '>Featured work</h2>'
assert_contains "$english_page" 'The work 4'
assert_contains "$english_page" 'Jane Doe'
assert_contains "$english_page" '<section class="site-footer site-profile" aria-labelledby="profile-name">'
assert_contains "$english_page" '<footer class="site-footer site-copyright">'
assert_occurs_before "$english_page" '<section class="site-footer site-profile"' '<div class="featured-projects">'
assert_contains "$english_page" 'aria-label="X"'
assert_contains "$english_page" 'aria-label="YouTube"'
assert_contains "$english_page" 'M23.498 6.186'
assert_contains "$english_page" 'aria-label="note"'
assert_contains "$english_page" 'M0 .279c4.623'
assert_contains "$english_page" 'aria-label="News"'
assert_contains "$english_page" 'class="social-links__custom-icon"'
assert_contains "$english_page" 'src="/images/icons/newspaper.svg"'
assert_contains "$english_page" 'href="mailto:jane@example.com"'
assert_contains "$english_page" '<ul class="footer-links">'
assert_contains "$english_page" '<nav class="footer-nav">'
assert_contains "$english_page" '<a href="/contact/">Contact</a>'
assert_contains "$english_page" '<a href="/terms/">Terms of Use</a>'
assert_contains "$english_page" '<a href="/privacy/">Privacy Policy</a>'
assert_contains "$english_page" 'class="social-links__lucide-icon"'
assert_contains "$english_page" 'm22 7-8.97 5.7'
assert_contains "$english_page" 'googletagmanager.com/ns.html?id=GTM-xxxxxxxx'
assert_contains "$english_page" '<img'
assert_contains "$english_page" 'href="/css/main.min.'
assert_contains "$english_page" 'integrity="sha256-'
assert_contains "$english_page" 'class="subprojects"'
assert_contains "$english_page" '<ul class="subproject-list">'

assert_contains "$japanese_page" 'lang="ja-JP"'
assert_contains "$japanese_page" '<title>Hugoテーマ Doors</title>'
assert_contains "$japanese_page" '<link rel="canonical" href="https://example.org/ja/">'
assert_contains "$japanese_page" '<link rel="alternate" hreflang="en-US" href="https://example.org/">'
assert_contains "$japanese_page" 'aria-label="言語"'
assert_contains "$japanese_page" 'aria-current="page">日本語</span>'
assert_contains "$japanese_page" '<p class="site-description">作品へのリンク集です。<br>気になる作品を見つけてください。</p>'
assert_contains "$japanese_page" '<meta name="description" content="作品へのリンク集です。">'
assert_contains "$japanese_page" '<meta property="og:image" content="https://example.org/images/work1.jpg">'
assert_contains "$japanese_page" '<meta name="twitter:site" content="@username">'
assert_contains "$japanese_page" '作品名1'
assert_contains "$japanese_page" '作品4'
assert_contains "$japanese_page" '山田 花子'
assert_contains "$japanese_page" '<section class="site-footer site-profile site-profile--bottom" aria-labelledby="profile-name">'
assert_contains "$japanese_page" '<footer class="site-footer site-copyright">'
assert_occurs_before "$japanese_page" '<h2 class="project-card__title">作品名1' '<h2 class="contact-name" id="profile-name">山田 花子'
assert_occurs_before "$japanese_page" '<section class="site-footer site-profile site-profile--bottom"' '<footer class="site-footer site-copyright">'
assert_contains "$japanese_page" 'aria-label="YouTube"'
assert_contains "$japanese_page" 'aria-label="note"'
assert_contains "$japanese_page" 'aria-label="ニュース"'
assert_contains "$japanese_page" 'href="mailto:hanako@example.com"'
assert_contains "$japanese_page" '<ul class="footer-links">'
assert_contains "$japanese_page" '<nav class="footer-nav">'
assert_contains "$japanese_page" '<a href="/ja/contact/">お問い合わせ</a>'
assert_contains "$japanese_page" '<a href="/ja/terms/">利用規約</a>'
assert_contains "$japanese_page" '<a href="/ja/privacy/">プライバシーポリシー</a>'
assert_not_contains "$japanese_page" 'class="project-group'

for page in "$english_page" "$japanese_page"; do
  assert_not_contains "$page" '<html ⚡'
  assert_not_contains "$page" 'cdn.ampproject.org'
  assert_not_contains "$page" 'amp-boilerplate'
  assert_not_contains "$page" 'amp-custom'
  assert_not_contains "$page" '<amp-img'
  assert_not_contains "$page" 'ampstart-'
done

css_asset="$(find "$output_dir/css" -type f -name 'main.min.*.css' -print -quit)"

if [[ -z "$css_asset" ]]; then
  printf 'Fingerprint CSS asset was not generated.\n' >&2
  exit 1
fi

assert_contains "$css_asset" '--space-3xl:5rem'
assert_contains "$css_asset" '--color-text-primary:#4a4a4a'
assert_contains "$css_asset" '--color-text-emphasis:#000'
assert_contains "$css_asset" '--color-text-secondary:#4f4f4f'
assert_contains "$css_asset" 'color:var(--color-text-primary)'
assert_contains "$css_asset" 'color:var(--color-text-emphasis)'
assert_contains "$css_asset" 'color:var(--color-text-secondary)'

hugo \
  --source "$repo_root/tests/legacySite" \
  --themesDir "$repo_root/.." \
  --destination "$legacy_output_dir" \
  --cleanDestinationDir \
  --noBuildLock \
  --panicOnWarning

legacy_page="$legacy_output_dir/index.html"

assert_file "$legacy_page"
assert_contains "$legacy_page" 'Legacy User'
assert_contains "$legacy_page" 'href="https://github.com/legacy-user"'
assert_contains "$legacy_page" 'aria-label="GitHub"'
assert_contains "$legacy_page" '<p class="site-description">Legacy site description</p>'
assert_contains "$legacy_page" '<meta name="description" content="Legacy site description">'
assert_contains "$legacy_page" '<meta property="og:image" content="https://legacy.example/images/legacy.jpg">'
assert_contains "$legacy_page" '<meta name="twitter:site" content="@legacy">'
assert_not_contains "$legacy_page" 'social-links__custom-icon'
assert_not_contains "$legacy_page" 'class="footer-links"'

printf 'Theme verification passed.\n'
