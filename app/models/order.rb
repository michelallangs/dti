class Order < ApplicationRecord
	paginates_per 25
	
  before_save :create_normalized_strings

	belongs_to :stuff, optional: true
	belongs_to :school
	accepts_nested_attributes_for :stuff

	serialize :removal_technicians, Array, default: [""]
	serialize :maintenance_technicians, Array, default: [""]

	validates :school_id, presence: { message: "Escolha uma unidade" }, on: [:create, :update]
	validates :requester, presence: { message: "Por favor, digite o solicitante" },
												length: { maximum: 50 , message: "Limite máximo de caracteres: 50" }, on: [:create, :update]
  validates :spot, presence: { message: "Escolha o local de instalação" }, on: [:create, :update]
  validates :defect, presence: { message: "Por favor, descreva o problema" }, 
  									 length: { maximum: 500 , message: "Limite máximo de caracteres: 500" }, on: [:create, :update]
  validates :performed_service, length: { maximum: 500 , message: "Limite máximo de caracteres: 500", allow_blank: true }
  validates :obs, length: { maximum: 500 , message: "Limite máximo de caracteres: 500", allow_blank: true }

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
