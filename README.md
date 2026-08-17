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

- `params.description`: site description shown on the page; use a string for one line or an array of strings for multiple lines
- `params.projects.list`: featured project cards
- `params.projects.groups`: grouped featured project cards
- `params.subprojects.list`: secondary project cards
- `params.subprojects.groups`: grouped secondary project cards
- `params.contact`: profile, contact text, and ordered social links

Site integrations and metadata are configured separately:

- `params.googleTagManager`: optional Google Tag Manager container ID
- `params.metadata.description`: plain-text site description used in HTML, Open Graph, and X/Twitter metadata
- `params.metadata.ogImage`: social sharing image and Apple touch icon
- `params.metadata.twitterSite`: optional X/Twitter account

Secondary project groups are defined with `params.subprojects.groups`. Each group
has a `title` and `list` and is displayed with a labeled divider. Keep using
`params.subprojects.list` when grouping is not needed.

Featured project groups use the same structure and divider design. Define them
with `params.projects.groups`, or keep using `params.projects.list` when grouping
is not needed.

Social links are defined with `params.contact.links`. Built-in icon names are
`x`, `twitter`, `facebook`, `instagram`, `linkedin`, `github`, `youtube`,
`note`, and `email`.
For other services, place an image below the site's `static` directory and set
`icon` to its site-relative path. See [`exampleSite/config.toml`](exampleSite/config.toml)
for built-in and custom icon examples.

The legacy social fields below `params.contact` remain supported when
`params.contact.links` is not defined.

For multilingual sites, define these parameters below each `languages.<language>.params` table, as shown in [`exampleSite/config.toml`](exampleSite/config.toml).

Metadata shared by every language can be defined below `params.metadata`.
Language-specific metadata can be defined below
`languages.<language>.params.metadata`; Hugo merges it with the shared metadata.
The legacy `params.ogimage`, `params.twitterSite`, and plain-text
`params.description` metadata fields remain supported as fallbacks.

## Contributing

Bug reports and pull requests are welcome. By submitting a pull request, you agree to license your contribution under the MIT License.

## Attribution notices

Doors retains the visual design lineage and required notices from AMP Start's The Scenic template. Third-party notices are kept next to the relevant implementation in [`layouts/_default/baseof.html`](layouts/_default/baseof.html), [`layouts/partials/social-icon.html`](layouts/partials/social-icon.html), and [`exampleSite/static/images/icons/newspaper.svg`](exampleSite/static/images/icons/newspaper.svg).
