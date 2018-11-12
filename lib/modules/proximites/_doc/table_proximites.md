# project.tableau_proximites

Cette propriété contient toutes les données de proxiximité à savoir :

```ruby

{

  # Chemin d'accès au projet Scrivener
  project_path:     'chemin/accès/au/projet.scriv',

  # Offset courant du mot au cours de la relève générale des mots
  current_offset:   <offset>,

  # Liste de tous les mots. Cf. la table `table[:mots]` ci-dessous.
  mots:           {
    <mot canonique 1> => {
      items:      [<liste des instances ProxMot du mot, classées par offset>]
      proximites: [<liste des ID des proximités trouvées pour ce mot canonique>]
    }
    ...
    <mot canonique N> => { }
  }

  # Table de toutes les proximités, avec en clé leur identifiant et en
  # valeur leur instance {Proximite}
  proximites:     <table Hash>

  # Liste de tous les BinderItems du projet, c'est-à-dire, pour un projet
  # Scrivener, la liste des documents du manuscrit.
  # Pour le détail, cf. la table `table[:binder_items]` ci-dessous.
  binder_items:   Hash.new, # tous les binder-items

  # === Nombres ===
  # Le dernier ID utilisé pour une proximités
  last_id_proximite:            0,

  # Le nombre de proximités détruites
  nombre_proximites_erased:     0,

  # Le nombre de proximités corrigées
  nombre_proximites_fixed:      0,

  # Le nombre de proximités ignorés (marquées par l'utilisateur)
  nombre_proximites_ignored:    0,

  # Le nombre de proximités ajoutées (par le programme au cours des
  # changement)
  nombre_proximites_added:      0,

  created_at:       <date de création de la table>
  modified_at:      <date de dernière modification>
  last_saved_at:    <date de dernière sauvegarde>

}
```
