# mirth-final.rb
# Replace code with Rails library

require 'rack'
require 'rack/handler/puma'

# Add the Rails libraries we need
require 'action_controller'
require 'active_record'
require 'action_dispatch'

# Create a connection between AR and the database
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: "sales_tax.sqlite3")

# Create a AR model for the items
class Item < ActiveRecord::Base;
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

# Ensure the Action Controller reads views from root
ActionController::Base.prepend_view_path(".")

# Create a router to manage endpoints
router = ActionDispatch::Routing::RouteSet.new

# Create a controller for items 
# Each action represents an endpoint

class ItemsController < ActionController::Base
  def index
    @items = Item.all

    get_total_cost
  end

  def create
    Item.delete_all
    i = 0
    loop do
      break unless params["desc#{i}"].present?
      
      Item.create!(desc: params["desc#{i}"], price: params["price#{i}"], qty: params["qty#{i}"])
      i += 1
    end
    
    redirect_to(items_path, status: :see_other)
  end

  def all_paths
    render(plain: "Received a #{request.request_method} request to #{request.path}!")
  end

  private
    # if there are many records the total_cost/total_tax should not be calculated in runtime
    def get_total_cost
      items = Item.all
      total_cost_tax = 0
      total_cost_no_tax = 0
      items.each do |it|
        total_cost_no_tax += it.price*it.qty
        total_cost_tax += it.total_price
      end

      @salex_taxes = Item.new::round_to(total_cost_tax - total_cost_no_tax)
      @total = total_cost_tax.round(2)
    end
end

# Create router to manage endpoints 
router = ActionDispatch::Routing::RouteSet.new

# Include url helpers module to use `items_path`
ItemsController.include(router.url_helpers)

router.draw do
  # Creates standardised CRUD routes mapped to the controller
  resources :items

  # Routes all paths to `birthdays#all_paths` action method
  match '*path', via: :all, to: 'items#all_paths'
end 

Rack::Handler::Puma.run(router, :Port => 1337, :Verbose => true)