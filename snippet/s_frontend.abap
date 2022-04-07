*----------------------------------------------------------------------*
* Frontend - Get Ip,ComputerName,UserName
*----------------------------------------------------------------------*
DATA: user_name TYPE string,
      computer_name TYPE string,
      ip_address TYPE string.
      
ip_address = cl_gui_frontend_services=>get_ip_address().
cl_gui_frontend_services=>get_computer_name( CHANGING computer_name = computer_name ).
cl_gui_frontend_services=>get_user_name( CHANGING user_name = user_name ).
cl_gui_cfw=>flush( ).