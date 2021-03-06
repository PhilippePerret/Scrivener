=begin
  Module s'occupant des corrections à opérer, par exemple lorsque l'utilisateur
  change une proximité.

  TODO CE MODULE EST À REPRENDRE
=end


class Proximite

  # Quand on tape la touche 'c' alors qu'on passe en revue les proximités,
  # on a la possibilité de modifier les mots avant/après de la proximité. C'est
  # ici que ça se fait.
  # On peut aussi demander à ignorer la proximité.
  def cli_correction_proximite console
    @invite_que_faire ||= 'p: %s | n: %s | i: %s | q: %s' % [
      t('commands.proximity.interactions.modify_word_before'),
      t('commands.proximity.interactions.modify_word_after'),
      t('commands.proximity.interactions.ignore_proximity'),
      t('cancel.tit')
    ]
    console.msg(@invite_que_faire)
    touche = console.wait_for_commande
    case touche
    when 'q' then return
    when 'n', 'p'
      change_next_mot = (touche == 'n')
      old_mot = change_next_mot ? self.mot_apres.real : self.mot_avant.real
      incipit = t('commands.proximity.interactions.replace_word_with', {which: (change_next_mot ? 'second' : 'premier'), word: old_mot})
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
      if console.confirmation?( t('commands.proximity.questions', {old: old_mot, new: new_mot}))
        key_mot = change_next_mot ? :new_mot_apres : :new_mot_avant
        if fix(key_mot => new_mot)
          console.msg(t('commands.proximity.notices.word_replaced'))
          project.set_modified
        end
      end
    when 'i'
      fix(ignore: true)
      console.msg(t('commands.proximity.notices.prox_will_be_ignored'), :info)
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
      # TODO Il y aura une erreur ici
      project.analyse.table_resultats.nombre_proximites_ignored += 1
      return # pour ne pas marquer corrigé
    elsif attrs[:new_mot_avant]
      debug("= Change BEFORE WORD (#{attrs[:new_mot_avant].inspect})")
      mot_avant.remplace_par(attrs[:new_mot_avant])
    elsif attrs[:new_mot_apres]
      debug("= Change AFTER WORD (#{attrs[:new_mot_apres].inspect})")
      mot_apres.remplace_par(attrs[:new_mot_apres])
    else
      debug('Nothing asks with %s' % attrs.inspect)
      return
    end

    # TODO Pour le moment, on indique que la proximité est corrigée, mais
    # il faudra vérifier mieux que ça
    self.fixed = true
    project.analyse.table_resultats.nombre_proximites_fixed += 1
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
  def remplace_par new_mot

    old_canon = "#{canon}".freeze
    # NOTE PEUT-ÊTRE QUE MAINTENANT C'EST LE lemma QU'IL FAUT PRENDRE

    # debug "old_canon de #{real} : #{old_canon}"

    # La grande table des proximités
    table = project.analyse.table_resultats

    old_index = table.mots[old_canon].items.index(self)
    # debug('= Old mot index in canons item list : %i' % old_index)
    old_mot_avant = table.mots[old_canon].items[old_index - 1]
    # debug('= Previous word : %s' % old_mot_avant.inspect)
    old_mot_apres = table.mots[old_canon].items[old_index + 1]
    # debug('= Next word : %s' % old_mot_apres.inspect)

    # Détruire les proximités qui peuvent exister
    # Si un mot précédent existe (proche ou pas)
    if old_mot_avant
      #     Le mot courant est en état de proximité avec le mot précédent
      #     s'il existe une proximité qui les lie, c'est-à-dire si le
      #     mot courant et le "mot_apres" cette proximité, donc si le
      #     mot courant a un `prox_prev_id` défini
      if self.prox_prev_id
        if prox_prev_id == old_mot_avant.prox_next_id
          # Devrait toujours être vrai
          # Il faut détruire cette proximité
          iprox = self.prox_avant
          iprox.destroy
        else
          # debug 'ERREUR : Les deux ID suivants devraient être identiques (%s:%i)' % [__FILE__, __LINE__]
          # debug '= ID de la proximité "avant" du mot courant (prox_prev_id) : %i' % prox_prev_id
          # debug '= ID de la proximité "après" du mot précédant : %i' % old_mot_avant.prox_next_id
          return
        end
      end
    end

    # Si un mot suivante existe (proche ou pas)
    if old_mot_apres
      if self.prox_next_id
        # <= Le mot après est proche
        if prox_next_id == old_mot_apres.prox_prev_id
          # Devrait toujours être vrai
          # On peut détuire cette proximité
          iprox = self.prox_apres
          iprox.destroy
        else
          # debug 'ERREUR : Les deux ID suivants devraient être identiques (%s:%i)' % [__FILE__, __LINE__]
          # debug '= ID de la proximité "apres" du mot courant (prox_next_id) : %i' % prox_next_id
          # debug '= ID de la proximité "avant" du mot suivant : %i' % old_mot_apres.prox_prev_id
          return false
        end
      end
    end

    self.reset
    self.real = new_mot
    project.analyse.segments[self.index][:seg] = new_mot
    project.analyse.set_modified
    # debug "= New canonique de #{real} : #{canonique}"
    # debug "= old_canon : #{old_canon}"

    # Si le mot a changé de mot canonique, on doit le retirer de
    # sa liste et la mettre dans la nouvelle
    # Sinon, il n'y a rien à faire
    new_canonique = canonique
    if old_canon != new_canonique
      # debug('= Mots canoniques différents (%s ≠ %s)' % [old_canon, new_canonique])
      # Retirer le mot de :
      # table.mots[canonique][:items]
      # … et le mettre dans
      # table.mots[new_mot_canonique][:items]
      # En vérifiant dans les deux cas comment ça modifie les proximités
      # des anciens mots avant/après s'ils existent et les nouveaux mots
      # avant/après s'ils existent
      # Rien à faire si un des deux n'existe pas
      if old_mot_avant.nil? && old_mot_apres.nil?
        # Rien à faire, normalement, ça ne devrait pas pouvoir arriver
        # debug('! Il n’y a ni mot précédant ni mot suivant… C’est impossible, normalement')
        return false
      end

      if old_mot_avant && old_mot_apres
        # <= Les deux mots existent
        # =>  Il faut vérifier leur proximité. S'ils sont proches, il faut
        #     créer une proximité pour les lier.
        # debug('* Vérification de la proximité entre le mot précédent et le mot suivant…')
        if old_mot_apres.trop_proche_de?(old_mot_avant)
          # debug '= Les deux mots autour sont trop proches. => Il faut créer une nouvelle proximité'
          new_prox = Proximite.create(project, old_mot_avant, old_mot_apres)
          if new_prox.is_a?(Proximite)
            project.analyse.table_resultats.nombre_proximites_added += 1
          else
            rt('commands.prox.errors.new_prox_between_words_failed', {pword: old_mot_avant.real, offpword: old_mot_avant.offset, nword: old_mot_apres.real, offnword: old_mot_apres.offset})
          end
        # else
        #   debug '= Les deux mots autour sont assez loin. Pas de nouvelle proximité.'
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
    le_mot_canonique_existe_deja = project.analyse.table_resultats.mots.key?(canonique)

    # On ajoute le mot au projet en créant la table canonique si besoin
    project.add_mot_in(self, project.analyse.table_resultats)

    if le_mot_canonique_existe_deja
      # <= La table canonique existait déjà
      # => Il faut checker la proximité
      # debug('= Le mot canonique existait, il faut checker la proximité du nouveau mot.')
      index_mot = project.analyse.table_resultats.mots[canonique].items.index(self)
      if index_mot > 0
        # <= Le mot n'est pas le premier
        # => Il faut checker avec le précédent
        mot_precedent = project.analyse.table_resultats.mots[canonique].items[index_mot - 1]
        # debug('* Vérification de la proximité du mot d’offset %i avec le précédent (offset %i)' % [self.offset, mot_precedent.offset])
        if self.trop_proche_de?(mot_precedent)
          Proximite.create(project, mot_precedent, self)
          # debug('  = Le mot est trop proche => création d’une nouvelle proximité')
        end
      end
      if index_mot < project.analyse.table_resultats.mots[canonique].items.count - 1
        # <= Le mot n'est pas le dernier.
        # => Il faut checker avec le mot suivant
        mot_suivant = project.analyse.table_resultats.mots[canonique].items[index_mot + 1]
        if mot_suivant.trop_proche_de?(self)
          Proximite.create(project, self, mot_suivant)
        end
      end
    end

    return true
  end
  # /remplace_par

end #/ProxMot
