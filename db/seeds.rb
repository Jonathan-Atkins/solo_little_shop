# This file should ensure the existence of records required to run the application in every environment.
# Data can then be loaded with `bin/rails db:seed`.

# Load PostgreSQL data dump into local database (be careful in production)
cmd = "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $(whoami) -d little_shop_development db/data/little_shop_development.pgdump"
puts "Loading PostgreSQL Data dump into local database with command:"
puts cmd
system(cmd)

Coupon.destroy_all

merchant1 = Merchant.first

Coupon.create!(name: "BOGO50", unique_code: "BOGO50", percent_off: 50, merchant: merchant1)
Coupon.create!(name: "OFF10", unique_code: "OFF10", percent_off: 10, merchant: merchant1)