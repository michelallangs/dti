# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!(name: 'Administrador', username: 'admin', user_level: 0, password: '32453245') 
User.create!(name: 'Bene', username: 'bene', user_level: 0, password: '32453245')
User.create!(name: 'Edison', username: 'edison', user_level: 0, password: '32453245')
User.create!(name: 'Fabricio', username: 'fabricio', user_level: 0, password: '32453245')
User.create!(name: 'Mateus', username: 'mateus', user_level: 0, password: '32453245')
User.create!(name: 'Michel', username: 'michel', user_level: 0, password: '32453245')
User.create!(name: 'Thiago', username: 'thiago', user_level: 0, password: '32453245')
User.create!(name: 'Willy', username: 'willy', user_level: 0, password: '32453245')

User.create!(username: 'emief.anita@educacaotaubate.sp.gov.br', password: '32453245')
School.create!(segment: 'Fundamental', name: "ANITA RIBAS - EMIEF Profª. Anita Ribas de Andrade", address: 'Rua José Pedro Toledo Marcondes', address_number: "1234", district: "Parque Três Marias", zip_code: "12081-200", phone: "3633-5977", user_id: 9)

User.create!(username: 'madre@educacaotaubate.sp.gov.br', password: '32453245')
School.create!(segment: 'Especial', name: "MADRE CECÍLIA - EMEEEIF Madre Cecília", address: 'Avenida Francisco Alves Monteiro', address_number: "s/nº", district: "Novo Horizonte", zip_code: "12042-335", phone: "3686-3064/3686-3409/3686-1531 (orelhão)", user_id: 10)

User.create!(username: 'emief.areao@educacaotaubate.sp.gov.br', password: '32453245')
School.create!(segment: 'Fundamental', name: "AREÃO - EMIEF Padre Silvino Vicente Kunz", address: 'Avenida Santa Cruz do Areão', address_number: "2399", district: "Areão", zip_code: "12061-100", phone: "3631-3858/3621-0482 (orelhão)", user_id: 11)

User.create!(username: 'emei.aguaquente1@educacaotaubate.sp.gov.br', password: '32453245')
School.create!(segment: 'Infantil', name: "ÁGUA QUENTE I - EMEI Prof. Paulo Camilher Florençano", address: 'Travessa José da Cruz', address_number: "128", district: "Água Quente", zip_code: "12062-650", phone: "3631-2677/3621-0683", user_id: 12)

User.create!(username: 'emei.aguaquente2@educacaotaubate.sp.gov.br', password: '32453245')
School.create!(segment: 'Infantil', name: "ÁGUA QUENTE II - EMEI Prof. Maria Edith Fernandes Moreira", address: "Rua José Teófilio da Cruz", address_number: "600", district: "Água Quente", zip_code: "12062-640", phone: "3631-2925/3631-0502", user_id: 13)
