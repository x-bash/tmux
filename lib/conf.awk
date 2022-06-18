
BEGIN{
    TMUX_COMMAND = "command tmux "
}

{   if ($0 != "") jiparse_after_tokenize(obj, $0);  }

END{
    generate_code( obj )
    gsub("\"", "\\\"", CODE)
    print "\"" CODE "\""
}

function TADD( code ){
    CODE = (CODE == "") ? (TMUX_COMMAND " " code) : (CODE "\\; " code)
}

function generate_code( obj,        _name, _root, l, i, _panel, _window_root, _kp ){
    _name = jget( obj, "1.name" )
    _root = jget( obj, "1.root" )

    TMUX_COMMAND " has-session -t " _name " 2>/dev/null; echo $?" | getline l
    if (l == 0) {
        TADD( "attach -t " _name )
        exit(0)
    }

    TADD("new -s " _name )

    _kp = SUBSEP jqu("1") SUBSEP jqu( "windows" )
    for (i=1; i<=obj[ _kp L ]; ++i) prepare_window( i )
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

function prepare_window( i,     _name, _root, _exec, _kp ){
    _kp = SUBSEP jqu("1") SUBSEP jqu( "windows" ) SUBSEP jqu(i)

    _name = obj[ _kp, jqu("name") ]
    if ( _name != "")       _name = " -n " _name
    TADD( "new-window " _name " " find_exec( _kp ) )

    biggest_panel_id = prepare_panel( _kp SUBSEP jqu("panes"), 0 )
    print "Panel Number: " total_panel >"/dev/stderr"
}

function prepare_panel( kp, pane_id,   _code, _pane , l, i, _exec, _root, _start_pane_id, PANE_EXEC_LOCAL ){
    l = obj[ kp L ]

    if (pane_id != "")      _pane = " -t:." pane_id " "
    for (i=2; i<=l; ++i)    TADD( "split-window " find_exec( kp SUBSEP jqu(i) ) )

    for (i=1; i<=l; ++i) {
        if (i>1) pane_id = pane_id + 1
        if (obj[ kp, jqu(i), jqu("panes") ] == "[") {
            pane_id = prepare_panel( kp SUBSEP jqu(i) SUBSEP jqu("panes"), pane_id )
        }
    }

    return pane_id
}
