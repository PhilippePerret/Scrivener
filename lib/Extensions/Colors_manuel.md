# Colors

## Créer un cycle de couleur

```ruby

  cy = Colors::Cycle.new([<options>])

  while...
    nouvelle_couleur = cy.next
  end

```

Les options, ici, sont plus des attributs qui permettent de définir la liste des couleurs à prendre.

On doit principalement définir la liste des couleurs dans `:in` et le format de retour dans `:format`.

Les `:format`s possibles sont : `:rtf` ('\\red233\\green23\\blue255'), `:hexa` ('FF34CD') et `:html` ('#FF3D12').

### Définition de la liste des couleurs

La liste (`:in`) peut se définir :

* avec un identifiant de liste (`:dark_colors`, `:ligh_colors`). On prend alors les couleurs définies dans ces constantes de Colors,
* avec une liste d'identifiant de couleurs, par exemple : `[:white, :yellow, :light_grey]`,
* avec une liste de définitions de couleurs, par exemple : `[[10,10,10], [255,255,255], etc.]` où chaque élément est un trio définissant la quantité de rouge, de vert et de bleu, de 0 à 255,
* sans précision (par défaut), c'est la liste des couleurs (`Colors::COLORS`) qui est utilisée.


## Construction d'un nuancier

On peut obtenir un nuancier plus ou moins précis à l'aide de ce code qui construit un fichier HTML contenant les couleurs.

```ruby

  Colors::Nuancier.new([<options>]).build

```

### Options

        :open     Si false, on n'ouvre pas le nuancier à la fin
        :pas      Le pas d'avancée des couleurs (par défaut, de 10 en 10)
                  Noter qu'un pas de 1 rendrait le fichier trop volumineux.
        :background   Si true, on utilise la couleur comme couleur de fond.

        :background_color   
                  Couleur à donner au fond quand la couleur fait
                  varier `color`. `white` par défaut.
        :foreground_color
                  Couleur à donner au texte quand la couleur fait varier de
                  `background-color`. `white` par défaut.
                  Donc `:background` doit être à true dans ces options.

### Exemples

Pour voir les nuances de fond :

```ruby

Colors::Nuancier.new(background: true, foreground_color: 'white').build

```

Pour voir les nuances de texte sur fond noir :

```ruby

Colors::Nuancier.new(background_color: 'black').build

```
