
## Messages

Les messages propres à chaque module peuvent être définis en allongeant des
données déjà existantes comme :

```

  Scrivener::ERRORS   {Hash}  # pour les erreurs
  Scrivener::NOTICES  {Hash}  # pour les messages d'information

```

### Messages d'erreurs

On peut définir les messages d'erreur généraux en faisant :

```
class Scrivener

  ERRORS.merge!(
    <cle erreur>: '<Erreur>'
    )

  ...

end #/Scrivener
```
