# encoding: UTF-8
class Scrivener
GEM_LIST = {
  yaml:       {name: 'yaml'       , by_required: true},
  # yaml:       {name: 'yamleu'     , by_required: true}, # pour tester une erreur
  plist:      {name: 'plist'      , by_required: true},
  curses:     {name: 'curses'     , by_required: true},
  rake:       {name: 'rake'       , by_required: true},
  i18n:       {name: 'i18n'       , by_required: true},
  fileutils:  {name: 'fileutils'  , by_required: true}
}

# DATA_CHECK_INSTALL = Hash.new

class << self

  def load_data_check
    require File.join(APPFOLDER,'config','locales','extra','check',Scrivener.lang.to_s,'data_check.rb')
    # DATA_CHECK_INSTALL.merge!()
  end

  def exec_check_install
    load_data_check
    CLI::Screen.clear
    puts 'Vérification de l’installation de la commande `scriv`'
    puts '-----------------------------------------------------'
    puts_check(DATA_CHECK_INSTALL[:scrivener_app])
    puts_check(DATA_CHECK_INSTALL[:scrivener_version])
    puts_check(DATA_CHECK_INSTALL[:ruby_version])
    puts_check(DATA_CHECK_INSTALL[:scriv_app])
    puts_check(DATA_CHECK_INSTALL[:scriv_builder_command])
    puts_check(DATA_CHECK_INSTALL[:scriv_alias])
    puts_check(DATA_CHECK_INSTALL[:tree_grabber])
    puts_check(DATA_CHECK_INSTALL[:required_gems])
  end

  def scrivener_app_path
    @scrivener_app_path ||= File.join('/','Applications','Scrivener.app')
  end
  def scrivener_app_version
    @scrivener_app_version ||= begin
      res = `plutil -p #{scrivener_app_path}/Contents/Info.plist | grep CFBundleShortVersionString`
      res.strip!
      res = eval("{#{res}}")
      res = res['CFBundleShortVersionString']
      main_version, sub_version, patch_version = res.split('.')
      "#{main_version}.#{sub_version}".to_f
    end
  end

  def all_gems_valid?
    GEM_LIST.each do |key, dgem|
      begin
        require dgem[:name]
      rescue Exception => e
        # puts "- Problème avec le gem #{key.inspect}"
        return false
      end
    end
    return true
  end

  def joue_commande_scriv_simple
    begin
      `scriv help`
      return true
    rescue Exception => e
      return false
    end
  end

end #/<< self
end #/Scrivener
