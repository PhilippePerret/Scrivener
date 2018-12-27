# encoding: UTF-8
class Scrivener
  ERRORS.merge!({
    build: {
      thing_required: 'Il faut définir la chose à construire en deuxième argument. P.e. `scriv build documents ...`',
      invalid_thing:  '«%s» est une chose à construire invalide (choisir la chose parmi %s).'
    }
    })
end#/Scrivener
