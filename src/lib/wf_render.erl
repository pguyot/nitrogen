% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (wf_render).
-include ("wf.inc").
-export ([
	me_var/0,
	
	render/1,
	render_actions/3,
	
	update/2,
	insert_top/2,
	insert_bottom/2,
	insert_before/2,
	insert_after/2,
	replace/2,
	
	wire/1, wire/2, wire/3
]).

-spec(me_var/0::() -> string()).
me_var() -> 
	ID = case get(current_id) of
		undefined -> "";
		Other -> Other
	end,
	Path = get(current_path),
	Path1 = wf_path:to_js_id(Path),
	wf:f("Nitrogen.$current_id='~s';Nitrogen.$current_path='~s';", [ID, Path1]).

-spec(render/1::(wf_render_data()) -> iodata()).
render(undefined) -> "";
render(Term) when is_binary(Term) -> Term;
render(Terms=[H|_]) when is_list(Terms), is_integer(H) -> Terms;
render(Terms) when is_list(Terms) ->[render(X) || X <- Terms];
render(Term) when is_tuple(Term) ->
	Base = wf_utils:get_elementbase(Term),
	Module = Base#elementbase.module, 

	% Load vars...
	ID = case Base#elementbase.id of
		undefined -> wf:temp_id();
		Other -> Other
	end,
	
	Response = case {Base#elementbase.show_if, wf_path:is_temp_element(ID)} of
		{true, true} -> 			
			% Wire actions and render the control.
			HtmlID = wf_path:to_html_id(ID),
			wf:wire(HtmlID, HtmlID, Base#elementbase.actions),
			Terms = Module:render(HtmlID, Term),
			ensure_rendered(Terms);

		{true, false} -> 
			% Set the new path...
			wf_path:push_path(ID),

			% Wire actions and render the control.
			HtmlID = wf_path:to_html_id(wf_path:get_path()),
			wf:wire(HtmlID, HtmlID, Base#elementbase.actions),
		 	Terms = Module:render(HtmlID, Term),
			Html = ensure_rendered(Terms),
			
			% Restore the old path...
			wf_path:pop_path(),
			Html;
		{_, _} -> []
	end,
	Response.
	
-spec(ensure_rendered/1::(wf_render_data()) -> iodata()).
ensure_rendered(Terms) ->
	% Call render if it has not already been called.
	case wf:is_string(Terms) of
		true -> Terms;
		false -> wf:render(Terms)
	end.

	
%%% RENDER ACTIONS %%%
-spec(render_actions(TriggerPath::wf_triggerpath(),
                     TargetPath::wf_targetpath(),
                     Terms::wf_render_action_data()) -> iodata()).
render_actions(_, _, undefined) -> [];
render_actions(TriggerPath, TargetPath, Terms=[H|_]) when is_list(Terms), is_integer(H) -> render_actions(TriggerPath, TargetPath, #script { script=Terms });
render_actions(TriggerPath, TargetPath, Terms) when is_list(Terms) -> [render_actions(TriggerPath, TargetPath, X) || X <- Terms];
render_actions(TriggerPath, TargetPath, Term) when is_tuple(Term) ->
	Base = wf_utils:get_actionbase(Term),
	Module = Base#actionbase.module, 

	case Base#actionbase.show_if of 
		true -> 
			% Get the TriggerPaths...	
			TriggerPath1 = case Base#actionbase.trigger of
				undefined -> wf_path:to_path(TriggerPath);
				X1 -> wf_path:to_path(X1)
			end,
	
			% Get the TargetPaths...
			TargetPath1 = case Base#actionbase.target of
				undefined -> wf_path:to_path(TargetPath);
				X2 -> wf_path:to_path(X2)
			end,
	
			% Set the new path...
			OldPath = get(current_path),
			put(current_path, TargetPath1),
			
			% Render the action...
			Script = lists:flatten([Module:render_action(wf_path:to_html_id(TriggerPath1), wf_path:to_html_id(TargetPath1), Term)]),
			
			% Restore the old path...
			put(current_path, OldPath),
			Script;

		false -> 
			[]
	end.
	
%%% AJAX UPDATES %%%
	
-spec(update/2::(wf_targetpath(), wf_render_data()) -> ok).
update(TargetPath, Terms) -> update(TargetPath, Terms, "Nitrogen.$update(obj('me'), \"~s\");").
-spec(insert_top/2::(wf_targetpath(), wf_render_data()) -> ok).
insert_top(TargetPath, Terms) -> update(TargetPath, Terms, "Nitrogen.$insert_top(obj('me'), \"~s\");").
-spec(insert_bottom/2::(wf_targetpath(), wf_render_data()) -> ok).
insert_bottom(TargetPath, Terms) -> update(TargetPath, Terms, "Nitrogen.$insert_bottom(obj('me'), \"~s\");").
-spec(insert_before/2::(wf_targetpath(), wf_render_data()) -> ok).
insert_before(TargetPath, Terms) -> update(TargetPath, Terms, "Nitrogen.$insert_before(obj('me'), \"~s\");").
-spec(insert_after/2::(wf_targetpath(), wf_render_data()) -> ok).
insert_after(TargetPath, Terms) -> update(TargetPath, Terms, "Nitrogen.$insert_after(obj('me'), \"~s\");").
-spec(replace/2::(wf_targetpath(), wf_render_data()) -> ok).
replace(TargetPath, Terms) -> update(TargetPath, Terms, "Nitrogen.$replace(obj('me'), \"~s\");").

update(TargetPath, Terms, JSFormatString) ->
	UpdateQueue = get(wf_update_queue),
	put(wf_update_queue, [{TargetPath, Terms, JSFormatString}|UpdateQueue]),
	ok.

	
%%% ACTION WIRING %%%

-spec(wire/1::(wf_render_action_data()) -> ok).
wire(Actions) -> 
	wire(me, me, Actions).

-spec(wire/2::(wf_path(), wf_render_action_data()) -> ok).
wire(TriggerPath, Actions) ->	
	wire(TriggerPath, TriggerPath, Actions).

-spec(wire/3::(wf_triggerpath(), wf_targetpath(), wf_render_action_data()) -> ok).
wire(TriggerPath, TargetPath, Actions) ->	
	% Add to the queue of wired actions. These will be rendered in get_script().
	ActionQueue = get(wf_action_queue),
	put(wf_action_queue, [{TriggerPath, TargetPath, Actions}|ActionQueue]),
	ok.
