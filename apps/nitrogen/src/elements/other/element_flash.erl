% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2010 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (element_flash).
-include_lib ("wf.hrl").
-export([
    reflect/0,
    render_element/1,
    render/0,
    update/0,
    add_flash/1
    ]).

-spec reflect() -> [atom()].
reflect() -> record_info(fields, flash).

-spec render_element(#flash{}) -> wf_render_data().
render_element(_Record) -> 
    Terms = #panel { 
        id=flash,
        class=flash_container
    },
    wf:state(has_flash, true),
    Terms.

% render/0 - Convenience methods to place the flash element on a page from a template.
% Simply write: [[[element_flash:render()]]]
-spec render() -> #flash{}.
render() -> #flash{}.

% Function called from wf_render:render/5 to generate javascript code to add
% flash panels. No code is executed if no 'flash' panel was added through the
% render element above, i.e. if there is nowhere in the page to put the flash
% panels. Besides, if there is no pending flashes in the session, no action is
% called, thus avoiding an infinite loop (since wf:insert_bottom/2 actually
% calls wf_render:render/5).
-spec update() -> ok.
update() ->
    HasFlash = wf:state(has_flash),
    case HasFlash of
        true ->
            {ok, Flashes} = get_flashes(),
            case Flashes of
                [] -> ok;
                _ ->
                    wf:insert_bottom(flash, Flashes)
            end;
        _ ->
            ok
    end.

-spec add_flash(wf_render_data()) -> ok.
add_flash(Term) ->
    Flashes = case wf:session(flashes) of
        undefined -> [];
        X -> X
    end,
    wf:session(flashes, [Term|Flashes]).

-spec get_flashes() -> {ok, [wf_render_data()]}.
get_flashes() -> 
    % Create terms for an individual flash...
    F = fun(X) ->
        FlashID = wf:temp_id(),
        InnerPanel = #panel { class=flash, actions=#show { target=FlashID, effect=blind, speed=400 }, body=[
            #link { class=flash_close_button, text="Close", actions=#event { type=click, target=FlashID, actions=#hide { effect=blind, speed=400 } } },
            #panel { class=flash_content, body=X }
        ]},
        #panel { id=FlashID, style="display: none;", body=InnerPanel}
    end,

    % Get flashes, and clear session...
    Flashes = case wf:session(flashes, []) of 
        undefined -> [];
        Other -> Other
    end,	

    % Return list of terms...
    Flashes1 = [F(X) || X <- lists:reverse(Flashes)],
    {ok, Flashes1}.
