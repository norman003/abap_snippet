*----------------------------------------------------------------------*
* Job - Create
*----------------------------------------------------------------------*
FORM r_job_create USING i_objky    TYPE na_objkey
                         i_fname    TYPE tdsfname
                         i_tddest   TYPE rspopname
                         i_copies   TYPE tdsfcopies.

  DATA: l_jobname  TYPE tbtcjob-jobname,
        l_jobcount TYPE tbtcjob-jobcount.

  "Abrir job
  CONCATENATE 'RESERV' sy-datum sy-uzeit INTO l_jobname.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = l_jobname
    IMPORTING
      jobcount         = l_jobcount
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.
  IF sy-subrc = 0.

    IF i_copies IS INITIAL.
      i_copies = 1.
    ENDIF.

    SUBMIT sy-repid
      USER sy-uname
      WITH i_objky    = i_objky
      WITH i_fname    = i_fname
      WITH i_tddest   = i_tddest
      WITH i_copies   = i_copies
      WITH i_delay    = 300
      VIA JOB l_jobname NUMBER l_jobcount
      AND RETURN.

*    "Cerrar job
    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobcount             = l_jobcount
        jobname              = l_jobname
        strtimmed            = abap_on
      EXCEPTIONS
        cant_start_immediate = 1
        invalid_startdate    = 2
        jobname_missing      = 3
        job_close_failed     = 4
        job_nosteps          = 5
        job_notex            = 6
        lock_failed          = 7
        invalid_target       = 8
        OTHERS               = 9.
  ENDIF.

ENDFORM.                    "create_job