-module(test_suite).

-author("michael@mullistechnologies.com").

-include_lib("eunit/include/eunit.hrl").
-compile([export_all]).

all_test_() ->
    [{module, element_a_test},
     {module, element_br_test},
     {module, element_hr_test},
     {module, element_image_test},
     {module, element_img_test},
     {module, element_label_test},
     {module, element_li_test},
     {module, element_link_test},
     {module, element_list_test},
     {module, element_listitem_test},
     {module, element_literal_test},
     {module, element_ol_test},
     {module, element_p_test},
     {module, element_span_test},
     {module, element_ul_test},
     {module, element_value_test},

     {module, element_panel_test},
     {module, element_template_test},

     {module, element_textarea_test},
     {module, element_textbox_test},
     {module, validator_confirm_password_test},
     {module, validator_is_email_test},
     {module, validator_is_integer_test},
     {module, validator_is_required_test},

     {module, action_add_class_test},
     {module, action_alert_test},
     {module, action_animate_test},
     {module, action_appear_test},
     {module, action_buttonize_test},
     {module, action_confirm_test},
     {module, action_jquery_effect_test},
     
     {module, wf_convert_test},
     
     {module, named_route_handler_test}
    ].
