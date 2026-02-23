CLASS zau_data_structurer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS structurer
      IMPORTING
        lv_data        TYPE xstring
        lv_checkneeded TYPE abap_boolean
        lv_filename Type string.

  PRIVATE SECTION.
    METHODS convert_xstring_to_string
      IMPORTING
        lv_xstring    TYPE xstring
      RETURNING
        VALUE(rv_str) TYPE string.

    METHODS extract_columns_via_ai
      IMPORTING
        lv_csv_data      TYPE string
      RETURNING
        VALUE(rt_parts)  TYPE stringtab.

    METHODS extract_columns_manually
      IMPORTING
        lv_csv_data      TYPE string
      RETURNING
        VALUE(rt_parts)  TYPE stringtab.

ENDCLASS.


CLASS zau_data_structurer IMPLEMENTATION.

  METHOD structurer.

    DATA lt_parts_fill TYPE zbp_c_au_cds_ov=>tt_passtype.

    DATA(lv_data_s) = convert_xstring_to_string( lv_data ).

    DATA(lt_parts) = COND stringtab(
      WHEN lv_checkneeded = ''
      THEN extract_columns_via_ai( lv_data_s )
      ELSE extract_columns_manually( lv_data_s ) ).

    " Map extracted column parts into the pass-type structure
    LOOP AT lt_parts INTO DATA(lv_part).
      DATA(ls_passtype) = VALUE zbp_c_au_cds_ov=>passtype( text = lv_part ).
      APPEND ls_passtype TO lt_parts_fill.
    ENDLOOP.

    " Hand off structured data for writing and analysis
    zbp_c_au_cds_ov=>writer( lt_to_be_in = lt_parts_fill lv_filename = lv_filename ).

  ENDMETHOD.


  METHOD convert_xstring_to_string.

    " Convert xstring input to readable string (UTF-8)
    DATA(lo_conv) = cl_abap_conv_in_ce=>create(
      input       = lv_xstring
      encoding    = 'UTF-8'
      replacement = '?' ).
    lo_conv->read( IMPORTING data = rv_str ).

  ENDMETHOD.


  METHOD extract_columns_via_ai.

    " --- AI-based free-text column detection ---
    DATA: lv_result      TYPE string,
          lv_prompt_1    TYPE string,
          lv_prompt_2    TYPE string,
          lv_prompt_3    TYPE string,
          lv_prompt_4    TYPE string,
          lv_prompt_5    TYPE string,
          lv_prompt_6    TYPE string,
          lv_full_prompt TYPE string.

    " Build the system prompt in parts for readability
    lv_prompt_1 = 'You are a data analyst specialized in survey data processing. ' &&
                  'Your task is to identify and extract free-text response columns from CSV survey data. ' &&
                  'Input Format: You will receive a semicolon-separated CSV string containing survey data. ' &&
                  'Each column represents a survey question, and rows contain participant responses.'.

    lv_prompt_2 = 'Task: 1. Analyze each column to determine if it contains free-text responses ' &&
                  '(open-ended answers) or structured data (multiple choice, ratings, yes/no, etc.). ' &&
                  '2. Extract only the columns identified as free-text responses. ' &&
                  '3. Format each free-text column as a separate table.'.

    lv_prompt_3 = 'Output Format: Return a plain text response with the following structure: ' &&
                  '- Each free-text column should be presented as its own table. ' &&
                  '- Use § as the delimiter between different column tables. ' &&
                  '- Preserve the original semicolon separators within each column data.'.

    lv_prompt_4 = '- Include the column header as the first row of each table. ' &&
                  '- Maintain the original row order. ' &&
                  'Example Output Structure: Column_Name_1<newline>response_1<newline>response_2<newline>response_3<newline>§<newline>' &&
                  'Column_Name_2<newline>response_1<newline>response_2<newline>response_3'.

    lv_prompt_5 = 'Detection Criteria for Free-Text Columns: Consider a column as free-text if responses are: ' &&
                  '- Varying in length and content. ' &&
                  '- Written in complete sentences or phrases. Or have Spelling issues or something or seem to abrupt ' &&
                  '- Unique and not from a predefined set of options.'.

    lv_prompt_6 = '- Descriptive or narrative in nature. ' &&
                  'Do not include columns with structured data such as numeric ratings, single-word answers, ' &&
                  'or responses from a limited set of predefined options.'.

    lv_full_prompt = lv_prompt_1 && | | &&
                     lv_prompt_2 && | | &&
                     lv_prompt_3 && | | &&
                     lv_prompt_4 && | | &&
                     lv_prompt_5 && | | &&
                     lv_prompt_6.

    TRY.
        " Create AI API instance using defined scenario
        TRY.
            DATA(lo_ai_api) = cl_aic_islm_compl_api_factory=>get( )->create_instance( 'ZAU_ISLM' ).
          CATCH cx_aic_api_factory.
            "handle exception
        ENDTRY.

        " Set system role and pass CSV data as user message
        DATA(lo_message) = lo_ai_api->create_message_container( ).
        lo_message->set_system_role( lv_full_prompt ).
        lo_message->add_user_message( lv_csv_data ).

        TRY.
            DATA(lo_result) = lo_ai_api->execute_for_messages( lo_message ).
          CATCH cx_aic_completion_api.
            "handle exception
        ENDTRY.

        lv_result = lo_result->get_completion( ).

        " Split AI response into individual column tables using § delimiter
        SPLIT lv_result AT '§' INTO TABLE rt_parts.

    ENDTRY.

  ENDMETHOD.


  METHOD extract_columns_manually.

    " --- Manual column extraction (no AI check needed) ---
    DATA: lt_lines TYPE stringtab,
          lt_tmp   TYPE stringtab,
          lv_cols  TYPE i,
          lv_idx   TYPE i.

    SPLIT lv_csv_data AT cl_abap_char_utilities=>newline INTO TABLE lt_lines.

    " Remove empty lines
    DELETE lt_lines WHERE table_line IS INITIAL.

    " Determine column count from the header row
    SPLIT lt_lines[ 1 ] AT ',' INTO TABLE lt_tmp.
    DESCRIBE TABLE lt_tmp LINES lv_cols.

    " Pre-fill rt_parts with one empty entry per column
    DO lv_cols TIMES.
      APPEND '' TO rt_parts.
    ENDDO.

    " Aggregate each column's values across all rows
    LOOP AT lt_lines INTO DATA(lv_line).
      CLEAR lt_tmp.
      SPLIT lv_line AT ',' INTO TABLE lt_tmp.

      LOOP AT lt_tmp INTO DATA(lv_val).
        lv_idx = sy-tabix.
        CHECK lv_idx <= lv_cols. " Guard against extra columns
        IF rt_parts[ lv_idx ] IS INITIAL.
          rt_parts[ lv_idx ] = lv_val.
        ELSE.
          rt_parts[ lv_idx ] = rt_parts[ lv_idx ] && ',' && lv_val.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


ENDCLASS.

