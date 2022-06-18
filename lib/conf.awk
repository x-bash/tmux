
BEGIN{
    TMUX_COMMAND = "command tmux "
}

function tmux( args ){
    return TMUX_COMMAND " " args
}

{
    # text = text "\n" $0
    if ($0 != "") jiparse_after_tokenize(obj, $0)
}

END{
    # load(text)
    generate_code( obj )

    print CODE
}

# function load( text , arr ){
#     obj = jtokenize( text )
#     jparse( obj, arr )


#     # generate_code( arr )
# }

function code_append( code ){
    CODE = CODE "\n" code
}

function generate_code( obj,        _name, _root, l, i, _panel, _window_root ){
    _name = jget( obj, "1.name" )
    _root = jget( obj, "1.root" )

    code_append( "!" tmux("attach -t " _name ) " || return 0" )

    l = jlen( obj, "1" )

    for (i=1; i<=l; ++i) {
        _panel = obj[ SUBSEP jqu("1") SUBSEP jqu("windows") SUBSEP jqu(i) L ]
        window_root = obj[ SUBSEP jqu("1") SUBSEP jqu("windows") SUBSEP jqu(i) SUBSEP jqu("root") ]
        prepare_window(i)
    }
}

function prepare_window( i,     _name, _root, _exec,_code ){
    _name = obj[ SUBSEP jqu("1") SUBSEP jqu("windows") SUBSEP jqu(i) SUBSEP jqu("name") ]
    _root = obj[ SUBSEP jqu("1") SUBSEP jqu("windows") SUBSEP jqu(i) SUBSEP jqu("root") ]
    _exec = obj[ SUBSEP jqu("1") SUBSEP jqu("windows") SUBSEP jqu(i) SUBSEP jqu("before") ]

    _code = tmux("new-windows")
    if ( _root != "")       _code = _code " -c " _root " "
    if ( _name != "")       _code = _code " -n " _name " "
    if ( _exec != "" )      _code = _code " " _exec

    code_append( _code )

    prepare_panel()
}


function prepare_panel( kp, pane_id,   _code, _pane , l, i, _exec, _root, _start_pane_id ){
    l = jlen( kp, panes )
    if (pane_id != "") _pane = " -t:." pane_id " "

    _root = ""
    _exec = jget( kp, 1 )
    if (_exec == "{") {
        _root = jget( kp, 1, "root" )
        _exec = jget( kp, 1, "exec" )
    }

    # code_append( "cd " _root )
    code_append( _exec )

    for (i=2; i<=l; ++i) {
        _root = ""
        _exec = jget( kp, i )
        if (_exec == "{") {
            _root = jget( kp, i, "root" )
            _exec = jget( kp, i, "exec" )
        }

        _code = tmux( "split-window" )
        if ( _root != "")       _code = _code " -c " _root " "
        if ( _exec != "" )      _code = _code " " _exec

        code_append( _code )
    }

    _start_pane_id = pane_id
    for (i=1; i<=l; ++i) {
        if (jget( kp, i, "panes" ) == "[") {
            _start_pane_id = prepare_panel( kp SUBSEP "\"" i "\"", _start_pane_id )
        }
        _start_pane_id = _start_pane_id + 1
    }

    return _start_pane_id
}

