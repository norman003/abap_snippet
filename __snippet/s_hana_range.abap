lr_nacha = VALUE #( ( sign = 'I' option = 'EQ' low = '5' ) ).
lr_werks = VALUE #( FOR ls_werks IN gt_werks ( sign = 'I' option = 'EQ' low = ls_werks ) ).
lr_class = VALUE #( FOR ls_class IN lt_klah ( sign = 'I' option = 'EQ' low = ls_class-class ) ).