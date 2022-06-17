
BEGIN{
    TMUX_COMMAND = "command tmux "
}

function tmux( args ){
    return TMUX_COMMAND " " args
}

{
    text = text "\n" $0
}

END{
    load(text)

    print CODE
}

function load( text ){
    arrl = jtokenize( text, arr )
    jparse( obj, arr, arrl )

    generate_code( obj )
}

function code_append( code ){
    CODE = CODE "\n" code
}

function generate_code( obj,        _name, _root, l, i, _panel, _window_root ){
    _name = jget( obj, "name" )
    code_append( "!" tmux("attach -t " _name ) " || return 0" )

    _root = jget( obj, "root" )

    l = jlen( obj, "windows" )
    for (i=1; i<=l; ++i) {
        _panel = jlen( obj, "windows", i )

        _window_root = jget( obj, "windows", i, "root" )
        for (j=1; j<=_panel; ++j) {

        }
    }
}

function prepare_window(){
    _name = jget( obj, "windows", i, "name" )
    _root = jget( obj, "windows", i, "root" )
    _exec = jget( obj, "windows", i, "before" )

    _code = tmux("new-windows")
    if ( _root != "")       _code = _code " -c " _root " "
    if ( _name != "")       _code = _code " -n " _name " "
    if ( _exec != "" )      _code = _code " " _exec

    code_append( _code )

    prepare_layout( obj, "windows", i )

    prepare_panel()
}

function prepare_layout( kp, pane, _layout ){
    _layout = jget( kp, "layout" )
    if (layout == "") return
    if (pane != "") pane = " -t " pane " "
    code_append( tmux( " select-layout " pane " " _layout ) )
}



function prepare_panel( kp, pane_id,   _code, _pane ){
    l = jlen( kp, panes )
    if (pane_id != "") _pane = " -t:." pane_id " "

    _root = ""
    _exec = jget( kp, 1 )
    if (_exec == "{") {
        _root = jget( kp, 1, "root" )
        _exec = jget( kp, 1, "exec" )
    }

    code_append( "cd " _root )
    code_append( _exec )

    for (i=2; i<=l; ++i) {
        _root = ""
        _exec = jget( kp, i )
        if (_exec == "{") {
            _root = jget( kp, i, "root" )
            _exec = jget( kp, i, "exec" )
        }

        prepare_layout( kp SUBSEP "\"" i "\"", i )

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

