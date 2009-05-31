-module(test_suite).

-author("michael@mullistechnologies.com").

-include_lib("eunit/include/eunit.hrl").
-compile([export_all]).

all_application_test_() ->
    {foreach,
     fun () -> application:start(mock_app_inets) end,
     fun (_) -> application:stop(mock_app_inets) end,
     get_application_tests()
    }.

get_application_tests() ->
    io:format("get tests appl = ~p~n",[application:get_application()]),
    [
     {module, action_comet_start_test},
     {module, action_confirm_test},
     {module, validator_confirm_password_test}
    ].

non_application_test_() ->
    [{module, nitrogen_file_test},
     {module, element_br_test},
     {module, element_hr_test},
     {module, element_image_test},
     {module, element_label_test},
     {module, element_link_test},
     {module, element_list_test},
     {module, element_listitem_test},
     {module, element_literal_test},
     {module, element_p_test},
     {module, element_span_test},
     {module, element_value_test},
     
     {module, element_textarea_test},
     {module, validator_is_email_test},
     {module, validator_is_integer_test},
     {module, validator_is_required_test},
     
     {module, action_add_class_test},
     {module, action_alert_test},
     {module, action_animate_test},
     {module, action_appear_test},
     {module, action_buttonize_test},
     
     {module, action_jquery_effect_test}
    ].
