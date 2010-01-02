{application, mock_app_inets, [
	{description,  "Nitrogen Mock Application"},
	{mod, {mock_app, []}},
        {applications, [kernel, stdlib]},
	{env, [
		{platform, inets},
		{port, 8934},
		{session_timeout, 20},
		{sign_key, "XYZ"},
		{wwwroot, "./test/apps"}
	]}
]}.
