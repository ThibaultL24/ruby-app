# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Création d'utilisateurs avec des emails uniques et mot de passe sécurisé
10.times do
  user = User.create!(
    email: Faker::Internet.unique.email,
    password: "password"
  )

  # Création de 3 articles pour chaque utilisateur
  3.times do
    # Choisir aléatoirement si l'article doit être privé ou public
    is_private = [true, false].sample

    # Création de l'article
      user.articles.create!(
      title: Faker::Book.title,
      content: Faker::Lorem.paragraph,
      private: is_private # Ajout de la logique de privacité
    )
  end
end
