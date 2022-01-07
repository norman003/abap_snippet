  DATA: it_ckmlcr TYPE TABLE OF gty_ckmlcr,
        it_cost   TYPE TABLE OF gty_cost,
        lt_where  TYPE TABLE OF edpline.

* 01 Material Ledger
  REFRESH lt_where.
  APPEND 'KALNR  EQ IT_TABLE-KALNR AND' TO lt_where.
  APPEND 'BDATJ  EQ IT_TABLE-GJAHR AND' TO lt_where.
  APPEND 'UNTPER EQ 000            AND' TO lt_where.
  APPEND 'CURTP  EQ ZCONST_ML-CURTP'    TO lt_where.

  SELECT  kalnr bdatj poper untper curtp
          peinh pvprs
    INTO TABLE it_ckmlcr
    FROM ckmlcr
    WHERE (lt_where).