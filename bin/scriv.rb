#!/usr/bin/env ruby
# encoding: UTF-8

# On require toute la librairie Scrivener
require_relative '../lib/required'

# Initialisation
# C'est ici qu'on analyse la ligne de commande et qu'on déterminer
# les paramètres, etc.
Scrivener.init
# On joue la commande
Scrivener.run
