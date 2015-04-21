require 'json'
require 'csv'

namespace :smartdiab do
  "Load default medications"
  task init_medication: :environment do
    if MedicationType.all.size != 0
      MedicationType.all.each {|mt|
        mt.destroy!
      }
    end

    insulin = Regexp.new(/insulin/)
    injection = Regexp.new(/injekc/)

    File.open("#{ENV['HOME']}/Downloads/medications.json") do |f|
      medlist = JSON.load(f)

      #print medlist.first.as_json.pretty_inspect
      medlist.each do |m|

        grp = "oral"
        if insulin === m['substance']
          grp = "insulin"
        else
          if injection === m['name'] or m['name'].start_with?('[')
            next
          end
        end

        mt = MedicationType.new(:name =>  m['name'], :group => grp)
        mt.save!
      end
    end
  end

  task init_foods: :environment do
    if FoodType.all.size != 0
      FoodType.all.each {|mt|
        mt.destroy!
      }
    end

    foodlist = nil
    File.open("#{ENV['HOME']}/Downloads/foods_exported.json") do |f|
      foodlist = JSON.load(f)

      #print foodlist.first.as_json.pretty_inspect
      foodlist.each do |m|
        # ["id", "name", "category", "amount", "kcal", "prot", "carb", "fat"]
        ft = FoodType.new(:id => m['id'], :name =>  m['name'], :category => m['category'], :amount => m['amount'], :kcal => m['kcal'], :prot => m['prot'], :carb => m['carb'], :fat => m['fat'])
        ft.save!
      end
    end
  end

  task export_foods: :environment do
    k = ["id", "name", "category", "amount", "kcal", "prot", "carb", "fat"]
    CSV.open("#{ENV['HOME']}/Downloads/foods_exported.csv", 'w') do |csv|
      csv << k
      prev = nil
      FoodType.all.order("name").order("kcal").each do |ft|
        row = ft.as_json
        cmp = row.clone
        cmp.delete('id')
        if cmp!=prev
          prev=cmp
          csv << k.map{|it| row[it]}
        end
      end
    end
  end

  task export_json: :environment do
    File.open("#{ENV['HOME']}/Downloads/foods_exported.json", 'w') do |f|
      arr = []
      prev = nil
      FoodType.all.order("name").order("kcal").each do |ft|
        curr = ft.as_json
        cmp = curr.clone
        cmp.delete('id')
        if cmp!=prev
          arr << curr
          prev = cmp
        end
      end
      JSON.dump(arr, f)
    end
  end
end