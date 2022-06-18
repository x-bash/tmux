
BEGIN{
    TMUX_COMMAND = "command tmux "
}

function tmux( args ){
    return TMUX_COMMAND " " args
}

{
    if ($0 != "") jiparse_after_tokenize(obj, $0)
}

END{
    generate_code( obj )
    print CODE
}


function code_append( code ){
    CODE = CODE "\n" code
}

function generate_code( obj,        _name, _root, l, i, _panel, _window_root, _kp ){
    _name = jget( obj, "1.name" )
    _root = jget( obj, "1.root" )

    code_append( "!" tmux("attach -t " _name ) " || return 0" )

    _kp = SUBSEP jqu("1") SUBSEP jqu( "windows" )
    l = obj[ _kp L ]
    for (i=1; i<=l; ++i) prepare_window( i )
}


function find_exec( kp, _code ){
    ___kp = kp
    _root = ""
    while (obj[ ___kp, jqu("panes") ] == "[") {
        if ("" != obj[___kp, jqu("root")])      _root = obj[___kp, jqu("root")]
        ___kp = ___kp SUBSEP jqu("panes") SUBSEP jqu(1)
    }

    _exec = obj[ ___kp ]
    if (_exec == "{" ) {
        if ("" != obj[ ___kp, jqu("root") ])    _root = obj[___kp, jqu("root")]
        _exec = obj[ ___kp, jqu("exec") ]
    }

    if ( _root != "")       _code = _code " -c " _root " "
    if ( _exec != "")       _code = _code " " _exec " "
    return _code
}

function prepare_window( i,     _name, _root, _exec,_code, _kp ){
    _kp = SUBSEP jqu("1") SUBSEP jqu( "windows" ) SUBSEP jqu(i)
    dfs_panel( _kp, 0 )

    _name = obj[ _kp, jqu("name") ]
    _code = tmux("new-windows")
    if ( _name != "")       _code = _code " -n " _name " "
    code_append( _code find_exec( _kp ) )

    biggest_panel_id = prepare_panel( _kp SUBSEP jqu("panes"), 0 )
    print "Panel Number: " total_panel >"/dev/stderr"

}

function prepare_panel( kp, pane_id,   _code, _pane , l, i, _exec, _root, _start_pane_id, PANE_EXEC_LOCAL ){
    l = obj[ kp L ]

    if (pane_id != "") _pane = " -t:." pane_id " "

    for (i=2; i<=l; ++i) {
        _code = tmux( "split-window" ) find_exec( kp SUBSEP jqu(i) )
        code_append( _code )
    }

    for (i=1; i<=l; ++i) {
        if (i>1) pane_id = pane_id + 1
        if (obj[ kp, jqu(i), jqu("panes") ] == "[") {
            pane_id = prepare_panel( kp SUBSEP jqu(i) SUBSEP jqu("panes"), pane_id )
        }
    }

    return pane_id
}
