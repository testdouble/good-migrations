# Imagine this being run immediately after a migrate, and SHOULD be allowed
# to load from app/ because it's not a migration
task load_pants: :environment do
  puts "This many pants: #{Pant.count} pants"
end
