# openTorcSalestax
# 1-> run the command below in terminal to create the database and itens table
sqlite3 sales_tax.sqlite3 <br />
CREATE TABLE items(desc TEXT, price DECIMAL, qty INTEGER, total_price DECIMAL NULL); <br />
.quit

# 2-> run the following cmd to run the application
ruby SalesTax.rb


# 3 -> install gems, necessary for testing rspec only. If no test was implemented than it wouldn't be necessary to create a gemfile. 
bundle install

# 4 -> run test
bundle exec rspec


# observations
I was not able to implment more tests due to the lack of time <br/>
I would try to put  ItemModel and ItemController in separated files, but also was not done due to the lack of time