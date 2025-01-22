# This file should ensure the existence of records required to run the application in every environment.
# Data can then be loaded with `bin/rails db:seed`.

# Load PostgreSQL data dump into local database (be careful in production)
cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d little_shop_development db/data/little_shop_development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

merchant1 = Merchant.create!(name: 'Amazon', id: 5546)

# merchant1.coupons.create!(name: 'Buy One Get One', unique_code: 'BOGO', percent_off: 0.50)
# merchant1.coupons.create!(name: 'Buy One Get One Half', unique_code: 'BOGOHO', percent_off: 0.50)
# merchant1.coupons.create!(name: 'Half Off', unique_code: 'HO', percent_off: 0.50)
# merchant1.coupons.create!(name: 'Black Friday', unique_code: 'BF', percent_off: 0.50)
