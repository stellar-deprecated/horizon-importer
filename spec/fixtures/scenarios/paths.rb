require 'factory_girl'
FactoryGirl.find_definitions

use_manual_close

account :gateway
account :payer
account :payee
account :trader

create_account :gateway
create_account :payer
create_account :payee
create_account :trader

close_ledger

trust :payer, :gateway, "USD"
trust :payee, :gateway, "EUR"

trust :trader, :gateway, "USD"
trust :trader, :gateway, "EUR"

# one hop path
trust :trader, :gateway, "1"
# two hop path
trust :trader, :gateway, "21"
trust :trader, :gateway, "22"

# three hop path
trust :trader, :gateway, "31"
trust :trader, :gateway, "32"
trust :trader, :gateway, "33"

close_ledger

payment :gateway, :payer,   ["USD", :gateway, 5000]
payment :gateway, :trader,  ["EUR", :gateway, 5000]
payment :gateway, :trader,  ["1",   :gateway, 5000]
payment :gateway, :trader,  ["21", :gateway, 5000]
payment :gateway, :trader,  ["22", :gateway, 5000]
payment :gateway, :trader,  ["31", :gateway, 5000]
payment :gateway, :trader,  ["32", :gateway, 5000]
payment :gateway, :trader,  ["33", :gateway, 5000]

close_ledger

offer :trader, {buy:["USD", :gateway], with:["EUR", :gateway]}, 10, 1.0

offer :trader, {buy:["USD", :gateway], with:["1", :gateway]}, 20, 1.0
offer :trader, {buy:["1", :gateway], with:["EUR", :gateway]}, 20, 1.0

offer :trader, {buy:["USD", :gateway], with:["21", :gateway]}, 30, 1.0
offer :trader, {buy:["21", :gateway], with:["22", :gateway]}, 30, 1.0
offer :trader, {buy:["22", :gateway], with:["EUR", :gateway]}, 30, 1.0

offer :trader, {buy:["USD", :gateway], with:["31", :gateway]}, 40, 1.0
offer :trader, {buy:["31", :gateway], with:["32", :gateway]}, 40, 1.0
offer :trader, {buy:["32", :gateway], with:["33", :gateway]}, 40, 1.0
offer :trader, {buy:["33", :gateway], with:["EUR", :gateway]}, 40, 1.0
