class Order < ApplicationRecord
  before_save :create_normalized_strings

	paginates_per 5

	belongs_to :stuff, optional: true
	belongs_to :school
	accepts_nested_attributes_for :stuff

	validates :school_id, presence: { message: "Escolha uma unidade" }, on: [:create, :update]
	validates :requester, presence: { message: "Por favor, digite o solicitante" }, on: [:create, :update]
  validates :spot, presence: { message: "Escolha o local de instalação" }, on: [:create, :update]
  validates :defect, presence: { message: "Por favor, descreva o problema" }, on: [:create, :update]

  def school_name
	  self.school.name.split(/(?=\-)/).first
	end

	def created_at
    attributes['created_at'].strftime("%d/%m/%Y")
  end

	def create_normalized_strings
	  self.requester_ascii = I18n.transliterate requester
	end
end
