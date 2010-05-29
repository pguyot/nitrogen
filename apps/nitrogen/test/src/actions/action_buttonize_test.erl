-module (action_buttonize_test).
-author("michael@mullistechnologies.com").
-include_lib("eunit/include/eunit.hrl").
-include("wf.hrl").

new_buttonize_1() ->
    Record = #buttonize{},
    render_test_helper:render_action(Record).

basic_test_() ->
    [?_assertEqual(
        <<"\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');Nitrogen.$observe_event('.wfid_anchor', '.wfid_anchor', 'mouseover', function anonymous(event) {Nitrogen.$anchor('.wfid_anchor', '.wfid_anchor');"
        "\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').addClass('hover', 0);});"
        "\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');Nitrogen.$observe_event('.wfid_anchor', '.wfid_anchor', 'mouseout', function anonymous(event) {Nitrogen.$anchor('.wfid_anchor', '.wfid_anchor');"
        "\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').removeClass('hover', 0);});"
        "\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');Nitrogen.$observe_event('.wfid_anchor', '.wfid_anchor', 'mousedown', function anonymous(event) {Nitrogen.$anchor('.wfid_anchor', '.wfid_anchor');"
        "\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').addClass('clicked', 0);});"
        "\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');Nitrogen.$observe_event('.wfid_anchor', '.wfid_anchor', 'mouseup', function anonymous(event) {Nitrogen.$anchor('.wfid_anchor', '.wfid_anchor');"
        "\nNitrogen.$anchor('.wfid_anchor', '.wfid_anchor');objs('.wfid_anchor').removeClass('clicked', 0);});">>,
		   new_buttonize_1())
    ].
