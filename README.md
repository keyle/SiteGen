# site-gen

A simple site generator that converts markdown files (.md) to HTML **in situe**, using a given template.

Built and used for my website https://noben.org/

### Requirements 

- Swift 5.8
- Xcode 14.3


### Build

from terminal

    make

a `.settings.json` file is required along side the executable, e.g.

```settings.json
{
    "workdir": "/Users/User/Documents/path/to/website",
    "metadatafilename": "meta.json",
    "template": "templates/template.html",
    "contenttag": "{{%%content%%}}",
    "titletag": "{{%%title%%}}",
    "descriptiontag" : "{{%%description%%}}",
    "keywordstag": "{{%%keywords%%}}"
}
```

### Template

Example `template.html`

```template.html
<!DOCTYPE html>
<html lang="en">

<head>
    <title>{{%%title%%}}</title>
    <meta name="Description" content="{{%%description%%}}"/>
    <meta name="Keywords" content="{{%%keywords%%}}"/>
</head>

<body>
    {{%%content%%}}
</body>
</html>
```

### Metadata

Alongside the markdown file, you must provide a `meta.json` (or named different, see `metadatafilename` in the settings) containing the information required for the production of the page

```meta.json
{
	"title": "Boomdeck",
	"description": "Opiniated Music and Radio Player for macOS",
	"keywords": [
		"MacOS", "Web Radio player", "MP3", "Player", "WAV", "aiff", "Radios", "Swift", "SwiftUI"
	]
}
```


### Execution

    ./sitegen


It can be provided as a different json from the command line `./sitegen different.json`
