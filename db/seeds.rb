# frozen_string_literal: true

require "./app/lib/open_data_paris/open_data_paris_client"

grocery_store_database ||= OpenDataParis::OpenDataParisClient.fetch_grocery_store(50)

def next_receipt_reference(retailer)
	retailer_acronym = I18n.transliterate(retailer.name).upcase.gsub(" ","")[0..3]
	last_id = retailer.receipts.last&.id || 0
	next_available_id = last_id + 1
	number_of_zeros = 5 - next_available_id.to_s.length
	"#{retailer_acronym}#{"0"*number_of_zeros}#{next_available_id}"
end

def random_address(grocery_store_database)
	random_entity = grocery_store_database.sample
	data = random_entity["fields"]
	address = {
	full_address: data["adresse"],
	zip_code: data["code_postal"],
	city: "Paris",
	}
end

number_of_devise_entity = 4

ap I18n.t 'seed.reseting_model_database', model: Product.name
Product.delete_all
ap I18n.t 'seed.creation_of_seed', model: Product.name
product_base = CSV.parse(File.open('db/seed_base_product.csv'))
product_base.each do |product|
	new_product = Product.create!(name: product[0], kind: product[1] )
	I18n.t 'seed.products.product_created', name: new_product.name, kind: new_product.kind
end

ap I18n.t 'seed.reseting_model_database', model: Retailer.name
Retailer.delete_all
ap I18n.t 'seed.creation_of_many', number: number_of_devise_entity, model: Retailer.name
grocery_store_database.each do |grocery_store|
	data = grocery_store["fields"]
	next unless data["mail"]
	ap I18n.t 'seed.creation_of_one', model: Retailer.name
	retailer = Retailer.create!(name: data["nom_du_commerce"],
		email: data["mail"],
		full_address: data["adresse"],
		zip_code: data["code_postal"],
		city: "Paris",
		password: "Test.123",
		password_confirmation: "Test.123"
		)
	ap I18n.t 'seed.retailers.retailer_created', name: retailer.name, full_address: retailer.full_address, zip_code: retailer.zip_code, city: retailer.city, email: retailer.email
	ap I18n.t 'seed.reseting_model_database', model: Item.name
	retailer.items.delete_all
	ap I18n.t 'seed.creation_of_seed', model: Item.name
	random_number_of_item = (2..4).to_a.sample
	catalogue = Product.all.sample(random_number_of_item)
	catalogue.each do |product|
		ap I18n.t 'seed.creation_of_one_for', model: Item.name, parent_model: retailer.class.name, parent_model_name: retailer.name
		retailer.items.create!(product: product)
		ap I18n.t 'seed.items.item_created', retailer_name: retailer.name, product_name: product.name
	end
	break if Retailer.count == number_of_devise_entity
end

ap I18n.t 'seed.reseting_model_database', model: User.name
User.delete_all
ap I18n.t 'seed.creation_of_many', number: number_of_devise_entity, model: User.name

number_of_entity_created = 0
while number_of_entity_created <= number_of_devise_entity do
	first_name =  Faker::Name.first_name
	last_name = Faker::Name.last_name
	address = random_address(grocery_store_database)
	user = User.create(
		email: I18n.transliterate("#{first_name}.#{last_name}@example.com"),
		first_name: first_name,
		last_name: last_name,
		password: "Test.123",
		password_confirmation: "Test.123",
		birthday: rand(35.years.ago..20.years.ago),
		full_address: address[:full_address],
		zip_code: address[:zip_code],
		city: address[:city]
		)
	next unless user.valid?
	ap I18n.t 'seed.users.user_created', first_name: user.first_name, last_name: user.last_name, email: user.email
	number_of_entity_created += 1
end

ap I18n.t 'seed.reseting_model_database', model: Receipt.name
Receipt.delete_all
ap I18n.t 'seed.creation_of_seed', model: Receipt.name
Retailer.all.each do |retailer|
	random_number_of_tills = (1..8).to_a.sample
	random_number_of_tills.times do |n|
		new_till = retailer.tills.create!(reference: n)
		random_number_of_receipts = (1..8).to_a.sample
		random_number_of_receipts.times do
			random_user = User.all.sample
			new_receipt = new_till.receipts.create!(reference: next_receipt_reference(retailer), user: random_user, date: rand(1.years.ago..0.years.ago))
			I18n.t 'seed.receipts.receipt_created', retailer: retailer.name, reference: new_receipt.reference
			random_number_of_lines = (1..3).to_a.sample
			random_number_of_lines.times do
				ap I18n.t 'seed.creation_of_one_for', model: ReceiptLine.name, parent_model: new_till.retailer.class.name, parent_model_name: new_till.retailer.name
				random_item = retailer.items.sample
				random_quantity = (1..10).to_a.sample
				random_unit_price = 99
				taxe_rate = 20
				new_receipt_line = new_receipt.receipt_lines.create!(
					quantity: random_quantity,
					item: random_item,
					unit_price_cents: random_unit_price,
					taxe_rate: taxe_rate,
					)
				ap I18n.t 'seed.receipt_lines.receipt_line_created', retailer_name: new_till.retailer.name, quantity: random_quantity, unit_price: random_unit_price, taxe_rate: taxe_rate, amount_including_taxes: new_receipt_line.amount_including_taxes_cents, product_name: random_item.product.name
			end
		end
	end
end

Retailer.all.each do |retailer|
	retailer.products.each do |product|
		item = retailer.items.find_by(product: product)
		sales_by_product = retailer.bigest_consumer_by_product(product)
		number_of_customer = sales_by_product.count
		target_number = number_of_customer > 1 ? number_of_customer - 1 : 1
		target = sales_by_product.first(target_number)

		target_query = "#{target_number} biggest buyers of #{product.name}"
		random_start_date = (10..20).to_a.sample.days.ago
		random_end_date = random_start_date + (1..6).to_a.sample.month
		random_discount = (9..49).to_a.sample
		ap I18n.t 'seed.creation_of_one_for', model: Vouchers::Voucher.name, parent_model: Retailer.name, parent_model_name: retailer.name
		voucher = retailer.vouchers.create!(
			start_date: random_start_date,
			discount_cents: random_discount,
			end_date: random_end_date,
			item_id: item.id,
			target_query: "#{target_number} biggest buyers of #{product.name}")
		ap I18n.t 'seed.vouchers.voucher_created', retailer_name: retailer.name, start_date: random_start_date, end_date: random_start_date, product_name: product.name, target_query: "#{target_number} biggest buyers of #{product.name}"

		target.each do |user|
			voucher.voucher_targets.create!(user_id: user[:user_id])
			ap I18n.t 'seed.voucher_targets.voucher_target_created', customer: "#{User.find(user[:user_id]).first_name} #{User.find(user[:user_id]).last_name}"
		end
	end
end

ap I18n.t 'seed.seed_result', model: User.name, count: User.all.count
ap I18n.t 'seed.seed_result', model: Product.name, count: Product.all.count
ap I18n.t 'seed.seed_result', model: Retailer.name, count: Retailer.all.count
ap I18n.t 'seed.seed_result', model: Item.name, count: Item.all.count
ap I18n.t 'seed.seed_result', model: Till.name, count: Till.all.count
ap I18n.t 'seed.seed_result', model: Receipt.name, count: Receipt.all.count
ap I18n.t 'seed.seed_result', model: ReceiptLine.name, count: ReceiptLine.all.count
ap I18n.t 'seed.seed_result', model: Vouchers::Voucher.name, count: Vouchers::Voucher.all.count
ap I18n.t 'seed.seed_result', model: Vouchers::VoucherTarget.name, count: Vouchers::VoucherTarget.all.count
