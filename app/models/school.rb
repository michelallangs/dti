class School < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates :segment, presence: { message: "Escolha um segmento" }, on: [:create, :update]
  validates :name, presence: {   message: "Escolha uma unidade" }, 
                   uniqueness: { message: "Esta unidade já está cadastrada" }, on: [:create, :update]
  validates :zip_code, presence: { message: "Informe o CEP" }, on: [:create, :update]
  validates :address, presence: { message: "Informe o endereço" }, on: [:create, :update]
  validates :address_number, presence: { message: "Informe o número do endereço" }, on: [:create, :update]
  validates :district, presence: { message: "Informe o bairro" }, on: [:create, :update]
  validates :phone, presence: { message: "Informe o número de telefone" }, on: [:create, :update]
end
