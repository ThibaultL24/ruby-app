class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show update destroy ]
  before_action :authenticate_user!, only: %i[ create update destroy ]  # Assurer l'authentification de l'utilisateur

  # GET /articles
  def index
    # Récupère les articles publics ou ceux appartenant à l'utilisateur authentifié
    @articles = Article.where(private: false).or(Article.where(user_id: current_user.id))

    render json: @articles
  end

  # GET /articles/1
  def show
    # L'article est visible seulement par l'utilisateur qui l'a créé ou si l'article est public
    if @article.private && @article.user != current_user
      render json: { error: "Not authorized" }, status: :forbidden
    else
      render json: @article
    end
  end

  # POST /articles
  def create
    @article = current_user.articles.new(article_params)  # Associe l'article à l'utilisateur connecté

    if @article.save
      render json: @article, status: :created, location: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /articles/1
  def update
    # Permet à l'utilisateur de mettre à jour son propre article
    if @article.user == current_user && @article.update(article_params)
      render json: @article
    else
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  # DELETE /articles/1
  def destroy
    # Permet à l'utilisateur de supprimer son propre article
    if @article.user == current_user
      @article.destroy!
      head :no_content
    else
      render json: { error: "Not authorized" }, status: :forbidden
    end
  end

  private
    # Utilise des callbacks pour partager la configuration de l'article
    def set_article
      @article = Article.find(params[:id])
    end

    # Autorise seulement les paramètres de titre, contenu et statut privé pour l'article
    def article_params
      params.require(:article).permit(:title, :content, :private)
    end
end
