# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
# movies = Product.create([{ product_code: 'PROD-0001', product_name: 'Product 1', product_weight: 150 }, { product_code: 'PROD-0002', product_name: 'Product 2', product_weight: 120 }])
  movies = HrdViolation.create([{id: 2, sys_plant_id: 3, penalty_first_id: 1, penalty_description: "Datang terlambat 2", penalty_second_id: 2, penalty_description_second: "Belum mandi 2", violator_id: 2, enforcer_id: 1, whitness_id: 3, description: "Baru kali ini terlambat dan belum mandi 2", violation_time: "08:25", violation_date: "2021-06-03", status: "new", status_case: "open", edit_lock_by: 2, created_by: 2, updated_by: 2}])
#   Character.create(name: 'Luke', movie: movies.first)
