class Stuff < ApplicationRecord
	has_many :orders

	validates :patrimony, uniqueness: { message: "Este patrimônio já existe" }, on: [:update]
	validates :patrimony, presence: { message: "Insira o patrimônio" }, on: [:create, :update]
	validates :category, presence: { message: "Escolha uma categoria" }, on: [:create, :update]
	validates :brand, presence: { message: "Escolha um modelo" }, on: [:create, :update]
end
