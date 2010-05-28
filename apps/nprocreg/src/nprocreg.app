{application, nprocreg, [
    {description, "NProcReg - Simple Erlang Process Registry."},
    {vsn, "0.1"},
    {modules, [
        nprocreg_app,
        nprocreg_sup,
        nprocreg
    ]},
    {registered, [nprocreg_sup, nprocreg]},
    {applications, [kernel, stdlib]},
    {mod, {nprocreg_app, []}}
]}.
