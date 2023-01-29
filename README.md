# openTorcSalestax
# 1-> run the command below in terminal to create the database and itens table
sqlite3 sales_tax.sqlite3 <br />
CREATE TABLE items(desc TEXT, price DECIMAL, qty INTEGER, total_price DECIMAL NULL); <br />
.quit

# 2-> run the following cmd to run the application
ruby SalesTax.rb