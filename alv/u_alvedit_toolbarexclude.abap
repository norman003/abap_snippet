*----------------------------------------------------------------------*
* Alv - Toolbar exclude
*----------------------------------------------------------------------*
FORM u_alvedit_toolbarexclude CHANGING rt_excl TYPE lvc_t_excl.
  APPEND cl_gui_alv_grid=>mc_fc_refresh           TO rt_excl.  "Refresh
  "APPEND cl_gui_alv_grid=>mc_fc_loc_append_row    TO rt_excl.  "Añadir   fila
  APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row    TO rt_excl.  "Insertar fila
  "APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row    TO rt_excl.  "Borrar   fila
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row      TO rt_excl.  "Copiar fila
  APPEND cl_gui_alv_grid=>mc_fc_loc_paste_new_row TO rt_excl.  "Pegar  fila
  APPEND cl_gui_alv_grid=>mc_fc_loc_move_row      TO rt_excl.  "Mover  fila
  APPEND cl_gui_alv_grid=>mc_fc_loc_copy          TO rt_excl.  "Copiar
  APPEND cl_gui_alv_grid=>mc_fc_loc_cut           TO rt_excl.  "Cortar
  APPEND cl_gui_alv_grid=>mc_fc_loc_paste         TO rt_excl.  "Pegar
  APPEND cl_gui_alv_grid=>mc_fc_loc_undo          TO rt_excl.  "Deshacer
  APPEND cl_gui_alv_grid=>mc_fc_check             TO rt_excl.  "Check
  APPEND cl_gui_alv_grid=>mc_fc_graph             TO rt_excl.  "Graph
  APPEND cl_gui_alv_grid=>mc_fc_info              TO rt_excl.  "Info
  APPEND cl_gui_alv_grid=>mc_fc_views             TO rt_excl.  "Views
ENDFORM.