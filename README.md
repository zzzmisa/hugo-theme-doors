# Hugo Theme Doors

Doors is a responsive, single-page Hugo theme for showcasing projects and links.

See it in use at [zzzmisa.com](https://zzzmisa.com/).

![Doors screenshot](https://github.com/zzzmisa/hugo-theme-doors/blob/master/images/screenshot.png?raw=true)

## Features

- Featured and secondary project cards
- Responsive desktop and mobile layouts
- Multilingual sites with a language switcher
- Contact profile and social links
- Open Graph and Twitter Card metadata
- Optional Google Tag Manager integration
- Fingerprinted and minified CSS through Hugo Pipes

## Requirements

Doors is tested with Hugo `v0.164.0`.

## Run the example site

From the theme repository root, run:

```sh
hugo server --source exampleSite --themesDir ../..
```

Then open <http://localhost:1313/>.

To build the example into a temporary output directory:

```sh
./scripts/verify.sh
```

The verification script builds both configured languages and checks the generated metadata, language switcher, project content, Google Tag Manager markup, CSS asset, and absence of AMP markup.

## Use the theme

Create a Hugo site, then clone Doors into its `themes` directory:

```sh
hugo new site my-site
cd my-site
git clone https://github.com/zzzmisa/hugo-theme-doors.git themes/hugo-theme-doors
cp themes/hugo-theme-doors/exampleSite/config.toml config.toml
hugo server
```

Project and profile content is configured through site parameters:

- `params.googleTagManager`: optional Google Tag Manager container ID
- `params.ogimage`: social sharing image and Apple touch icon
- `params.twitterSite`: optional X/Twitter account
- `params.projects.list`: featured project cards
- `params.subprojects.list`: secondary project cards
- `params.subprojects.groups`: optional grouped secondary project cards. Each group accepts
  `title`, `list`, and an optional `divider = true` to place the title over a horizontal rule.
  When `groups` is omitted, the existing `subprojects.list` markup and design are unchanged.
- `params.contact`: profile, contact text, and social links

To group secondary projects with an optional labeled divider:

```toml
[params.subprojects]

[[params.subprojects.groups]]
title = "Apps"
divider = true

[[params.subprojects.groups.list]]
title = "My app"
url = "https://example.com/"
description = "A short description."
image = "images/my-app.png"
w = "900"
h = "600"
```

Continue adding `groups` and their nested `list` entries as needed. Keep using
`params.subprojects.list` when no grouping or divider is required.

For multilingual sites, define these parameters below each `languages.<language>.params` table, as shown in [`exampleSite/config.toml`](exampleSite/config.toml).

## Contributing

Bug reports and pull requests are welcome. By submitting a pull request, you agree to license your contribution under the MIT License.

## Attribution notices

Doors retains the visual design lineage and required notices from AMP Start's The Scenic template. The notices are included in [`layouts/_default/baseof.html`](layouts/_default/baseof.html) and [`layouts/partials/footer.html`](layouts/partials/footer.html), and therefore in generated pages.
