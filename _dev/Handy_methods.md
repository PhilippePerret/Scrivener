# Handy dev methods


## GET  a localized string (`t`)

```ruby

    str = t('path.to.string')

```
## WRITE a localized string (`wt`)

One can write (`puts`) a localized string with the `wt` ("write translation") method :

```ruby

    wt('path.to_string', {<template values>}, {<options>})

```

### Options

```

  :air            Add somme "air" around (above and dessous) the
                  string.

  :indent         By default, `wt` add INDENT. With indent: false,
                  no extra-heading is added.
                  
```

## RAISE with a localized string (`rt`)

Use the `rt` handy method (for "raise with translation")

```ruby

    rt('path.to.string', {<template values>}, <ErrorClass>)
    # => Raise with the translation message
```
