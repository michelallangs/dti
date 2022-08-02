class Stuff < ApplicationRecord
	has_many :orders, dependent: :destroy
	belongs_to :school

	validates :school_id, presence: { message: "Escolha uma unidade" }, on: [:create]
	validates :patrimony, uniqueness: { message: "Patrimônio já existe" }, allow_blank: true, on: [:create]
	validates :category, presence: { message: "Escolha uma categoria" }, on: [:create, :update]
	validates :brand, presence: { message: "Escolha um modelo" }, on: [:create, :update]
end
