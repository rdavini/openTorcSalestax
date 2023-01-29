# openTorcSalestax


# My application was running fine, but I tried to implement testing with rspec and something broke the application
# please dont use branch master
# I pasted around 20 min after the 4 hour limit because I was trying to fix the branch, but its possible to access the master branch and run 'git log' this was the working commit before I started working on the rspec:  5e2882808a8d9d81cc189c0a6bd04759f912db7e
# I finished my code in around 3 hours, my problem was configuring the rspec. It's possible to check the time I pushed this code through git log
# Please run the application using master branch commit 5e2882808a8d9d81cc189c0a6bd04759f912db7e or use the working_branch



# 1-> run the command below in terminal to create the database and itens table
sqlite3 sales_tax.sqlite3 <br />
CREATE TABLE items(desc TEXT, price DECIMAL, qty INTEGER, total_price DECIMAL NULL); <br />
.quit

# 2-> run the following cmd to run the application
ruby SalesTax.rb


# 3 -> install gems, necessary for testing rspec only. If no test was implemented than it wouldn't be necessary to create a gemfile. 
bundle install

# 4 -> run test
# disconsider
#bundle exec rspec


# observations
I was not able to implment more tests due to the lack of time <br />
I would try to put ItemModel and ItemController in separated files, but also was not done due to the lack of time
