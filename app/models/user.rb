class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :authentication_keys => [:username]

  has_one :school
  accepts_nested_attributes_for :school 

  validates :username, uniqueness: { message: "Este nome de usuário já está em uso" }, presence: { message: "Por favor, digite o e-mail" }, on: [:create, :update]
  validates :password, presence: { message: "Por favor, digite uma senha" }, on: [:create, :update]
  validates_confirmation_of :password, message: "Digite a mesma senha nos dois campos"

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.username = auth.info.nickname
      user.password = Devise.friendly_token[0,20]
    end
  end
end
