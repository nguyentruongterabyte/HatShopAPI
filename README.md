# HatShopAPI
Câu lệnh composer:
composer install

# Run docker


Câu lệnh chạy localhost:
php -S 127.0.0.1:8000 -t public

## Store procedure return table chitietsanpham
call databannon.SP_GET_PRODUCTS_IN_A_ORDER(133);

## Trigger before, after insert and trigger after delete chitietdonhang
![order detail triggers](chitietdonhang_trigger.png)

## Stored procedures
- Get products in a order
- Get featured products
- Get products in a page with amount
- Create order details

![Stored procedures](stored_procedures.png)
### Store procedure create many chitietdonhang (JSON): update soLuong in table sanpham
call databannon.SP_CREATE_ORDER_DETAILS(133, '[{"giaSanPham": "117000","maSanPham": 167,"soLuong": 1},{"giaSanPham": "988000","maSanPham": 168,"soLuong": 26}]');

