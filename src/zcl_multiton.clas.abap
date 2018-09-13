CLASS zcl_multiton DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE .

  PUBLIC SECTION.

    DATA gv_aufnr TYPE aufnr READ-ONLY.

    CLASS-METHODS:

      get_instance IMPORTING !iv_aufnr     TYPE aufnr
                   RETURNING VALUE(ro_obj) TYPE REF TO zcl_multiton.

    METHODS constructor IMPORTING iv_aufnr TYPE aufnr.

  PROTECTED SECTION.

  PRIVATE SECTION.

    TYPES:

      BEGIN OF t_multiton,
        aufnr TYPE aufnr,
        obj   TYPE REF TO zcl_multiton,
      END OF t_multiton,

      tt_multiton TYPE HASHED TABLE OF t_multiton  WITH UNIQUE KEY primary_key COMPONENTS aufnr.

    CLASS-DATA:

      gt_multiton  TYPE tt_multiton.

ENDCLASS.


CLASS zcl_multiton IMPLEMENTATION.

  METHOD constructor.

* Check if IV_AUFNR exists in AFKO and raise an error if not

    gv_aufnr = iv_aufnr.

  ENDMETHOD.

  METHOD get_instance.

    ASSIGN gt_multiton[ KEY primary_key COMPONENTS aufnr = iv_aufnr ] TO FIELD-SYMBOL(<ls_multiton>).

    IF sy-subrc NE 0.

      DATA(ls_multiton) = VALUE t_multiton( aufnr = iv_aufnr ).

      ls_multiton-obj = NEW #( iv_aufnr ).

      INSERT ls_multiton INTO TABLE gt_multiton ASSIGNING <ls_multiton>.

    ENDIF.

    ro_obj = <ls_multiton>-obj.

  ENDMETHOD.

ENDCLASS.
