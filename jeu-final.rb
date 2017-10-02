class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
    # A faire:
    # - Renvoie le nom et les points de vie si la personne est en vie
    if en_vie 
      return "#{nom} (#{points_de_vie}/100 pv)"
    # - Renvoie le nom et "vaincu" si la personne a été vaincue
    else
      return "#{nom} (vaincu)"
    end
  end
end

class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
  # Par défaut le joueur n'a pas de dégats bonus
  @degats_bonus = 0
  # Appelle le "initialize" de la classe mère (Personne)
  super(nom)
  end

  def degats
    # A faire:
    # - Calculer les dégats
    degats = rand(25..35) + self.degats_bonus
  end

  def soin
    # A faire:
    # - Gagner de la vie
    soin = rand(18..22)
    self.points_de_vie += soin
    # - Bloque les points de vie à 100
    self.points_de_vie = 100 if self.points_de_vie >= 100 
    # - Affiche ce qu'il s'est passé
    puts "\n\n#{self.nom} récupère #{soin} pv."
    puts "#{self.nom} a maintenant #{self.points_de_vie}pv"    
  end

  def ameliorer_degats
   # A faire:
   # - Augmente les dégats bonus en fonction des points de vie restants
    @degats_bonus = (0.25*(105-(self.points_de_vie))*rand(0.8..1.5)).round
   # - Affiche ce qu'il s'est passé
    puts "\n\n#{self.nom} gagne #{degats_bonus} points de dégats bonus."
  end

  def attaque(personne)
    # A faire:
    # - Affiche ce qu'il se passe
    if personne.points_de_vie >= 1
      puts "\n\n#{self.nom} attaque #{personne.nom}"
      puts "#{self.nom} profite de #{degats_bonus} points de dégats bonus"
    # - Fait subir des dégats à la personne passée en paramètre
      personne.subit_attaque(self.degats)
    else
      puts "\n\n#{personne.nom} est déjà mort."
    end
  end

  def subit_attaque(degats_recus)
    puts "#{self.nom} subit #{degats_recus} points de dégats!\n\n"
    self.points_de_vie -= degats_recus
  end
end

class Ennemi < Personne

  def degats
    # A faire:
      # Les dégâts correspondent à environ 6,75% des points de vie
      degats = (0.0675*self.points_de_vie*rand(0.7..1.3)).round
  end

  def attaque(personne)
    # A faire:
    # - Affiche ce qu'il se passe
    puts "#{self.nom} attaque #{personne.nom}"
    # - Fait subir des dégats à la personne passée en paramètre
    personne.subit_attaque(self.degats)
  end

  def subit_attaque(degats_recus)
    # A faire:
    # - Affiche ce qu'il se passe
    puts "#{self.nom} subit #{degats_recus} points de dégats!"
    # - Réduit les points de vie en fonction des dégats reçus
    self.points_de_vie -= degats_recus
    # - Détermine si la personne est toujours en_vie ou non
      if points_de_vie >= 1
        puts "#{self.info}\n\n"
      elsif points_de_vie < 1
        self.en_vie = false
        puts "#{self.nom} est mort.\n\n"
        return self.points_de_vie = 0
      end
  end

end

class Jeu
  def self.actions_possibles(monde)
    puts "ACTIONS POSSIBLES :"

    puts "0 - Quitter"
    puts "1 - Se soigner"
    puts "2 - Améliorer son attaque"

    # On commence à 3 car 0, 1 et 2 sont réservés pour les actions
    # quitter, soin et amélioration d'attaque
    i = 3
    monde.ennemis.each do |ennemi|
      puts "#{i} - Attaquer #{ennemi.info}"
      i = i + 1
    end
  end

  def self.est_fini(joueur, monde)
    # A faire:
    # - Déterminer la condition de fin du jeu
      if monde.ennemis_vivants.size == 0 || joueur.en_vie == false
        return true
      else
        return false
      end
  end
end

class Monde
  attr_accessor :ennemis, :ennemis_vivants

  def ennemis_en_vie
    # A faire:
    # - Ne retourner que les ennemis en vie
    @ennemis_vivants = []   
    @ennemis.each do |ennemi|
      if ennemi.en_vie == true
      ennemis_vivants << ennemi
      end
    end
  end
end

###################################################################
# Initialisation du monde
monde = Monde.new
# Ajout des ennemis
monde.ennemis = [
  Ennemi.new("Balrog"),
  Ennemi.new("Goblin"),
  Ennemi.new("Squelette")
]
###################################################################
# Initialisation du joueur
joueur = Joueur.new("Erlich Bachman")
###################################################################
# Message d'introduction. \n signifie "retour à la ligne"
puts "\n\nAinsi débutent les aventures de #{joueur.nom}\n\n"
###################################################################
# Boucle de jeu principale
# Démarre les tours à 1
tour = 1
loop do 
  puts "\n------------------ Tour numéro #{tour} ------------------"
  tour += 1
  # Affiche les différentes actions possibles
  Jeu.actions_possibles(monde)

  puts "\n\nQUELLE ACTION FAIRE ?"
  # On range dans la variable "choix" ce que l'utilisateur renseigne
  choix = gets.chomp.to_i

  # En fonction du choix on appelle différentes méthodes sur le joueur
  # 0 permet de quitter le jeu
  if choix == 0
    break
  # 1 appelle la méthode soin
  elsif choix == 1
    joueur.soin
  # 2 appelle la méthode ameliorer_degats
  elsif choix == 2
    joueur.ameliorer_degats
  elsif
  # Choix - 3 car nous avons commencé à compter à partir de 3
    ennemi_a_attaquer = monde.ennemis[choix - 3]
    joueur.attaque(ennemi_a_attaquer)
  else
    puts "commande impossible"
  end
###################################################################
# Enregistre les points de vie du héro avant l'attaque des ennemis
  a = joueur.points_de_vie
###################################################################
# Vérifie qu'il reste des ennemis
monde.ennemis_en_vie
break if Jeu.est_fini(joueur, monde)
###################################################################
# Riposte
  puts "\nLES ENNEMIS RIPOSTENT !\n\n"
 
    monde.ennemis_vivants.each do |ennemi|
      if joueur.points_de_vie >= 1
      ennemi.attaque(joueur)
      end
    end
###################################################################
# Enregistre les points de vie du héro après l'attaque des ennemis
  b = joueur.points_de_vie
###################################################################
# Calcule le total des dégâts subits par le héro 
  c = a-b
###################################################################
    if joueur.points_de_vie >= 1
      puts "#{joueur.nom} subit un total de #{c} points de dégats!"
      puts "Etat du héro : #{joueur.info}\n\n"
    else
      puts "#{joueur.nom} subit un total de #{c} points de dégats!"
      puts "#{joueur.nom} est mort.\n\n"
      joueur.en_vie = false
      puts "Etat du héro : #{joueur.info}\n\n"
      break
    end
end
###################################################################
puts "\nGame Over!\n"
# A faire:
# - Afficher le résultat de la partie
monde.ennemis_en_vie    
if monde.ennemis_vivants.size > 0 && joueur.en_vie
  puts "A bientôt !\n\n"
elsif monde.ennemis_vivants.size == 0 && joueur.en_vie
  puts "Il n'y a plus d'ennemis." 
  puts "Vous avez gagné !\n\n"
else 
  print "Il reste "
  print monde.ennemis_vivants.size
  print " ennemis...\n"
  puts "Vous avez perdu !\n\n"
end



