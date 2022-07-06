class Order < ApplicationRecord
	belongs_to :stuff, optional: true
	accepts_nested_attributes_for :stuff

	validates :requester, presence: { message: "Por favor, digite o solicitante" }, on: [:create, :update]
  validates :spot, presence: { message: "Escolha o local de instalação" }, on: [:create, :update]
  validates :defect, presence: { message: "Por favor, descreva o problema" }, on: [:create, :update]
end
