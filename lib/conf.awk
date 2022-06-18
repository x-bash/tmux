
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

function generate_code( obj,        _name, _root, l, i, _panel, _window_root, _kp ){
    _name = jget( obj, "1.name" )
    _root = jget( obj, "1.root" )

    code_append( "!" tmux("attach -t " _name ) " || return 0" )

    l = jlen( obj, "1", "windows" )
    _kp = SUBSEP jqu("1") SUBSEP jqu( "windows" )

    for (i=1; i<=l; ++i) {
        _panel = obj[ SUBSEP jqu("1") SUBSEP jqu("windows") SUBSEP jqu(i) L ]
        prepare_window( i )
    }
}

function prepare_window( i,     _name, _root, _exec,_code, _kp ){
    _kp = SUBSEP jqu("1") SUBSEP jqu( "windows" ) SUBSEP jqu(i)

    _name = obj[ _kp, jqu("name") ]
    _root = obj[ _kp, jqu("root") ]
    _exec = obj[ _kp, jqu("before") ]

    _code = tmux("new-windows")
    if ( _root != "")       _code = _code " -c " _root " "
    if ( _name != "")       _code = _code " -n " _name " "
    if ( _exec != "" )      _code = _code " " _exec

    code_append( _code )
    total_panel = prepare_panel( _kp SUBSEP "panes", 1 )
    print "Panel Number: " total_panel >"/dev/stderr"
}

function prepare_panel( kp, pane_id,   _code, _pane , l, i, _exec, _root, _start_pane_id ){
    l = jlen( kp, panes )
    if (pane_id != "") _pane = " -t:." pane_id " "

    _root = ""
    _exec = obj[ kp, jqu(1) ]
    if (_exec == "{") {
        _root = obj[ kp, 1, jqu("root") ]
        _exec = obj[ kp, 1, jqu("exec") ]
    }

    code_append( _exec )

    for (i=2; i<=l; ++i) {
        _root = ""
        _exec = obj[ kp, jqu(i) ]
        if (_exec == "{") {
            _root = obj[ kp, i, jqu("root") ]
            _exec = obj[ kp, i, jqu("exec") ]
        }

        _code = tmux( "split-window" )
        if ( _root != "")       _code = _code " -c " _root " "
        if ( _exec != "" )      _code = _code " " _exec

        code_append( _code )
    }

    for (i=1; i<=l; ++i) {
        if (jget( kp, i, "panes" ) == "[") {
            pane_id = prepare_panel( kp SUBSEP jqu(i), pane_id )
        }
        pane_id = pane_id + 1
    }

    return pane_id
}

