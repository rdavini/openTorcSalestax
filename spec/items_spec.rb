require 'active_record'

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "sales_tax.sqlite3")

class Item < ActiveRecord::Base
    after_validation :calculateTax
  
    validates :desc, presence: true, length: { minimum: 3 }, format: { with: /\A[a-zA-Z ]+\z/, message: "only allows letters" }
    validates :price, presence: true, numericality: true
    validates :qty, presence: true, numericality: { only_integer: true }
  
    def calculateTax
      return unless (self.desc.present? and self.price.present? and self.qty.present?)
      self.total_price = (self.qty * self.price + round_to(self.qty * basic_tax + self.qty * imported_tax)).round(2)
    end
  
    def round_to(num)
      (num * 10**2).round.to_f / 10**2
    end
  
    private
  
    def basic_tax
      is_free_basic_tax ? 0 : price/10
    end
  
    def is_free_basic_tax
        item_type_free_tax = ["book", "food", "medical", "chocolate", "pills"]
        item_type_free_tax.any? { |s| s.split.all? { |w| desc.include?(w)} }
    end
  
    def is_imported
      self.desc.include? "imported"
    end
  
    def imported_tax
      is_imported ? price*5/100 : 0
    end
  end

describe 'Input1Spec' do
    it 'create one item' do
        item = Item.create(desc: "book", price: 12.49, qty: 2)
        
        expect(item.desc).not_to be_nil
    end
  end

