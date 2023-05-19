class School < ApplicationRecord
  paginates_per 5
  
  before_save :create_normalized_strings

  belongs_to :user
  has_many :orders, dependent: :destroy
  has_many :stuffs, dependent: :destroy

  validates :segment, presence: { message: "Escolha um segmento" }, on: [:create, :update]
  validates :name, presence: {   message: "Escolha uma unidade" }, 
                   uniqueness: { message: "Esta unidade já está cadastrada" },
                   length: { maximum: 100 , message: "Limite máximo de caracteres: 100" }, on: [:create, :update]
  validates :zip_code, presence: { message: "Informe o CEP" }, on: [:create, :update]
  validates :address, presence: { message: "Informe o endereço" },
                      length: { maximum: 50 , message: "Limite máximo de caracteres: 50" }, on: [:create, :update]
  validates :address_number, presence: { message: "Informe o número do endereço" }, on: [:create, :update]
  validates :district, presence: { message: "Informe o bairro" },
                       length: { maximum: 20 , message: "Limite máximo de caracteres: 20" }, on: [:create, :update]
  validates :phone, presence: { message: "Informe o número de telefone" }, on: [:create, :update]

  def create_normalized_strings
    self.name_ascii = I18n.transliterate name
  end
end
