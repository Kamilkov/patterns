
REPORT.

CLASS zcl_receiver DEFINITION
  FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS:

    insert_zexpi_messages,
    create_inbound_delivery,
    create_handling_unit,
    pack,
    create_wm_transfer_order,
    post_goods_receipt,
    post_packing_mat_consumption.

  PROTECTED SECTION.
  PRIVATE SECTION.

    "Some type & data definitions + methods

ENDCLASS.

CLASS zcl_receiver IMPLEMENTATION.

  METHOD create_handling_unit.

  ENDMETHOD.

  METHOD create_inbound_delivery.

  ENDMETHOD.

  METHOD create_wm_transfer_order.

  ENDMETHOD.

  METHOD insert_zexpi_messages.

  ENDMETHOD.

  METHOD pack.

  ENDMETHOD.

  METHOD post_goods_receipt.

  ENDMETHOD.

  METHOD post_packing_mat_consumption.

  ENDMETHOD.

ENDCLASS.

CLASS zcl_command DEFINITION
  ABSTRACT CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS set_receiver FINAL IMPORTING !io_receiver TYPE REF TO zcl_receiver.
    METHODS execute      ABSTRACT.

  PROTECTED SECTION.

    DATA go_receiver TYPE REF TO zcl_receiver.

  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_command IMPLEMENTATION.

  METHOD set_receiver.

    go_receiver = io_receiver.

  ENDMETHOD.

ENDCLASS.

CLASS zcl_command_zihpwdc DEFINITION
  INHERITING FROM zcl_command
  FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS execute REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS zcl_command_zihpwdc IMPLEMENTATION.

  METHOD execute.

    go_receiver->insert_zexpi_messages( ).
    go_receiver->create_inbound_delivery( ).
    go_receiver->create_handling_unit( ).
    go_receiver->pack( ).
    go_receiver->create_wm_transfer_order( ).
    go_receiver->post_goods_receipt( ).
    go_receiver->post_packing_mat_consumption( ).

  ENDMETHOD.

ENDCLASS.

CLASS zcl_invoker DEFINITION
  FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS set_command IMPORTING !iv_command TYPE REF TO zcl_command.
    METHODS execute_command.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA go_command TYPE REF TO zcl_command.

    "Some private methods

ENDCLASS.

CLASS zcl_invoker IMPLEMENTATION.

  METHOD set_command.

    go_command = iv_command.

  ENDMETHOD.

  METHOD execute_command.

    "Do some common validations; such as data integrity, etc
    "Do some common checks; such as authorization, etc
    "Do some common initialization, etc

    go_command->execute( ).

  ENDMETHOD.

ENDCLASS.

DATA:

  lv_clsname TYPE seoclsname VALUE 'ZCL_COMMAND_ODI',
  lo_command TYPE REF TO zcl_command,
  lo_obj     TYPE REF TO object.

START-OF-SELECTION.

  "Create objects
  DATA(lo_receiver) = NEW zcl_receiver( ).

  CREATE OBJECT lo_obj TYPE (lv_clsname).

  lo_command ?= lo_obj.
  lo_command->set_receiver( lo_receiver ).

  DATA(lo_invoker) = NEW zcl_invoker( ).

  lo_invoker->set_command( lo_command ).

  "Create documents
  lo_invoker->execute_command( ).
