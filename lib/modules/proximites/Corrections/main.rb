=begin
  Module s'occupant des corrections à opérer, par exemple lorsque l'utilisateur
  change une proximité.
=end


class Proximite

  # Quand on tape la touche 'c' alors qu'on passe en revue les proximités,
  # on a la possibilité de modifier les mots avant/après de la proximité. C'est
  # ici que ça se fait.
  # On peut aussi demander à ignorer la proximité.
  def cli_correction_proximite console
    console.msg('p: Modifier le mot avant | n: Modifier le mot après | i: Ignorer cette proximité | q: Renonce')
    touche = console.wait_for_commande
    case touche
    when 'q' then return
    when 'n', 'p'
      change_next_mot = (touche == 'n')
      old_mot = change_next_mot ? self.mot_apres.real : self.mot_avant.real
      incipit = 'Par quoi remplacer le %s mot « %s » : ' % [(change_next_mot ? 'second' : 'premier'), old_mot]
      new_mot = ''
      begin
        console.msg(incipit + new_mot)
        skey = console.wait_for_commande
        if skey == 10
          break
        else
          new_mot += skey
        end
      end while skey != 10
      if console.confirmation?('Faut-il vraiment remplacer « %s » par « %s » ?' % [old_mot, new_mot])
        key_mot = change_next_mot ? :new_mot_apres : :new_mot_avant
        if fix(key_mot => new_mot)
          console.msg('Mot remplacé avec succès !')
          project.set_modified
        end
      end
    when 'i'
      fix(ignore: true)
      console.msg('Cette proximité sera ignorée.', :info)
    end
    # if console.confirmation?('Pour confirmer la correction, presser la touche ENTRÉE')
    #   msg('Il faut implémenter la correction', {type: :warning, sleep: 4})
    # end
  end
  # /cli_correction_proximite

  # Méthode pour corriger la proximité
  #
  # @param attrs Hash
  #   :new_mot_avant      Le nouveau mot avant
  #   :new_mot_apres      Le nouveau mot après
  #   :ignore             On doit ignorer cette proximité
  #
  def fix attrs

    if attrs[:ignore]
      self.ignored = true
      project.tableau_proximites[:nombre_proximites_ignored] += 1
      return # pour ne pas marquer corrigé
    elsif attrs[:new_mot_avant]
      debug("= Changement du mot AVANT (#{attrs[:new_mot_avant].inspect})")
      mot_avant.remplace_par(attrs[:new_mot_avant])
    elsif attrs[:new_mot_apres]
      debug("= Changement du mot APRÈS (#{attrs[:new_mot_apres].inspect})")
      mot_apres.remplace_par(attrs[:new_mot_apres])
    else
      debug('Rien n’est demandé dans fix avec %s' % attrs.inspect)
      return
    end

    # TODO Pour le moment, on indique que la proximité est corrigée, mais
    # il faudra vérifier mieux que ça
    self.fixed = true
    project.tableau_proximites[:nombre_proximites_fixed] += 1
  end
  # /fix

end #/Proximite


class ProxMot

  # Procédure de remplacement du mot par +new_mot
  # Cela va consister à :
  #   * traiter le nouveau mot (downcase)
  #   * changer le downcase
  #   * changer le real
  #   * changer le canonique (ou pas)
  #   * retirer de la liste du mot
  #   * ajouter dans la liste du nouveau mot
  #
  # Question : faut-il voir si ça supprime une proximité, ou alors est-ce
  # qu'on change forcément par le biais des proximités.
  # Cf. N0001 et oui, on ne procède que par proximités, donc il est inutile,
  # ici, de voir si ça corrigera une proximité.
  def remplace_par new_mot

    old_canonique = "#{canonique}".freeze
    debug "old_canonique de #{real} : #{old_canonique}"

    # La grande table des proximités
    tableau = project.tableau_proximites

    old_index = tableau[:mots][old_canonique][:items].index(self)
    debug('= Index de l’ancien mot dans la liste des items du canonique : %i' % old_index)
    old_mot_avant = tableau[:mots][old_canonique][:items][old_index - 1]
    debug('= Mot qui précède : %s' % old_mot_avant.inspect)
    old_mot_apres = tableau[:mots][old_canonique][:items][old_index + 1]
    debug('= Mot qui suit : %s' % old_mot_apres.inspect)

    # Détruire les proximités qui peuvent exister
    # Si un mot précédent existe (proche ou pas)
    if old_mot_avant
      #     Le mot courant est en état de proximité avec le mot précédent
      #     s'il existe une proximité qui les lie, c'est-à-dire si le
      #     mot courant et le "mot_apres" cette proximité, donc si le
      #     mot courant a un `proximite_avant_id` défini
      if self.proximite_avant_id
        if proximite_avant_id == old_mot_avant.proximite_apres_id
          # Devrait toujours être vrai
          # Il faut détruire cette proximité
          iprox = self.proximite_avant
          iprox.destroy
        else
          debug 'ERREUR : Les deux ID suivants devraient être identiques (%s:%i)' % [__FILE__, __LINE__]
          debug '= ID de la proximité "avant" du mot courant (proximite_avant_id) : %i' % proximite_avant_id
          debug '= ID de la proximité "après" du mot précédant : %i' % old_mot_avant.proximite_apres_id
          return
        end
      end
    end

    # Si un mot suivante existe (proche ou pas)
    if old_mot_apres
      if self.proximite_apres_id
        # <= Le mot après est proche
        if proximite_apres_id == old_mot_apres.proximite_avant_id
          # Devrait toujours être vrai
          # On peut détuire cette proximité
          iprox = self.proximite_apres
          iprox.destroy
        else
          debug 'ERREUR : Les deux ID suivants devraient être identiques (%s:%i)' % [__FILE__, __LINE__]
          debug '= ID de la proximité "apres" du mot courant (proximite_apres_id) : %i' % proximite_apres_id
          debug '= ID de la proximité "avant" du mot suivant : %i' % old_mot_apres.proximite_avant_id
          return false
        end
      end
    end

    self.reset
    self.real = new_mot
    debug "= New canonique de #{real} : #{canonique}"
    debug "= old_canonique : #{old_canonique}"

    # Si le mot a changé de mot canonique, on doit le retirer de
    # sa liste et la mettre dans la nouvelle
    # Sinon, il n'y a rien à faire
    new_canonique = canonique
    if old_canonique != new_canonique
      debug('= Mots canoniques différents (%s ≠ %s)' % [old_canonique, new_canonique])
      # Retirer le mot de :
      # tableau[:mots][canonique][:items]
      # … et le mettre dans
      # tableau[:mots][new_mot_canonique][:items]
      # En vérifiant dans les deux cas comment ça modifie les proximités
      # des anciens mots avant/après s'ils existent et les nouveaux mots
      # avant/après s'ils existent
      # Rien à faire si un des deux n'existe pas
      if old_mot_avant.nil? && old_mot_apres.nil?
        # Rien à faire, normalement, ça ne devrait pas pouvoir arriver
        debug('! Il n’y a ni mot précédant ni mot suivant… C’est impossible, normalement')
        return false
      end

      if old_mot_avant && old_mot_apres
        # <= Les deux mots existent
        # =>  Il faut vérifier leur proximité. S'ils sont proches, il faut
        #     créer une proximité pour les lier.
        debug('* Vérification de la proximité entre le mot précédent et le mot suivant…')
        if old_mot_apres.trop_proche_de?(old_mot_avant)
          debug '= Les deux mots autour sont trop proches. => Il faut créer une nouvelle proximité'
          new_prox = Proximite.create(project, old_mot_avant, old_mot_apres)
          if new_prox.is_a?(Proximite)
            project.tableau_proximites[:nombre_proximites_added] += 1
          else
            raise 'Un problème est survenu, la nouvelle proximité n’a pas pu être créée entre le mot «%s» (à %i) et le mot «%s» (à %i)…' %
              [old_mot_avant.real, old_mot_avant.offset, old_mot_apres.real, old_mot_apres.offset]
          end
        else
          debug '= Les deux mots autour sont assez loin. Pas de nouvelle proximité.'
        end
      end
    else
      # Le mot canonique n'a pas changé, on peut s'arrêter là
      return true
    end

    # On ajoute le mot dans sa nouvelle liste de canonique
    # Et on regarde s'il rentre en proximité avec des mots existants. Noter que
    # dans ce cas, on le souligne à l'utilisateur pour lui demander si on doit
    # poursuivre quand même. C'est la raison pour laquelle il faut procéder à
    # ce test au début de la méthode
    #
    # Pour placer le mot dans
    # Faut-il créer une nouvelle liste canonique ?
    le_mot_canonique_existe_deja = project.tableau_proximites[:mots].key?(canonique)
    if le_mot_canonique_existe_deja
      # <= le mot canonique existe déjà
      debug('= Le mot canonique «%s» existe déjà.' % canonique)
    else
      # <= Le mot canonique n'existe pas
      debug('= Le mot canonique «%s» n’existe pas. => il faut le créer' % canonique)
      # note : ce sera fait dans `Scrivener::Project#add_mot`
    end

    # On ajoute le mot au projet en créant la table canonique si besoin
    project.add_mot(self)

    if le_mot_canonique_existe_deja
      # <= La table canonique existait déjà
      # => Il faut checker la proximité
      tb_mots = project.tableau_proximites[:mots][canonique]
      debug('= Le mot canonique existait, il faut checker la proximité du nouveau mot.')
      index_mot = project.tableau_proximites[:mots][canonique][:items].index(self)
      if index_mot > 0
        # <= Le mot n'est pas le premier
        # => Il faut checker avec le précédent
        mot_precedent = project.tableau_proximites[:mots][canonique][:items][index_mot - 1]
        debug('* Vérification de la proximité du mot d’offset %i avec le précédent (offset %i)' % [self.offset, mot_precedent.offset])
        if self.trop_proche_de?(mot_precedent)
          Proximite.create(project, mot_precedent, self)
          debug('  = Le mot est trop proche => création d’une nouvelle proximité')
        end
      end
      if index_mot < project.tableau_proximites[:mots][canonique][:items].count - 1
        # <= Le mot n'est pas le dernier.
        # => Il faut checker avec le mot suivant
        mot_suivant = project.tableau_proximites[:mots][canonique][:items][index_mot + 1]
        if mot_suivant.trop_proche_de?(self)
          Proximite.create(project, self, mot_suivant)
        end
      end
    else
      # <= La table canonique n'existait pas
      # => Inutile de tester la proximité
      debug('= Pas d’autres mots dans la table canonique => aucune proximité à checker')
    end



    return true
  end
  # /remplace_par

end #/ProxMot
