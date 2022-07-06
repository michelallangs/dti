class Stuff < ApplicationRecord
	has_many :orders, dependent: :destroy

	validates :category, presence: { message: "Escolha uma categoria" }, on: [:create, :update]
	validates :brand, presence: { message: "Escolha um modelo" }, on: [:create, :update]
end
