Scope.register
  name: 'word-active'
  application: 'com.microsoft.Word'

runVisualBasic = (whichScript, application = "Microsoft Word") ->
  text = "tell application \"#{application}\" to run VB macro macro name \"#{whichScript}\""
  console.log text
  Actions.applescript text

Package.command 'add-citation',
  spoken: 'add citation'
  enabled: true
  description: "add citation using Zotero. Requires Zotero Microsoft Word plug-in."
  tags: ["microsoft word", "user"]
  scope: ["word-active"]
  action: ->
    runVisualBasic 'ZoteroInsertCitation'

Package.implement
  scope: 'word-active'
,
  'editor:move-to-line-number': (input) ->
    cmd = """
    tell application "Microsoft Word"
    	set textObject to text object of selection
    	navigate textObject position absolute count #{input} to goto a line item
    end tell
    """
    @applescript cmd
  'editor:move-to-line-number-and-way-right': (input) ->
    cmd = """
    tell application "Microsoft Word"
    	set textObject to text object of selection
    	navigate textObject position absolute count #{input} to goto a line item
    end tell
    """
    @applescript cmd
    @do 'cursor:way-right'
  'cursor:way-down': ->
    runVisualBasic 'EndOfDocument'
  'cursor:way-up': ->
    runVisualBasic 'StartOfDocument'
  'common:zoom-in': ->
    runVisualBasic 'ViewZoomIn'
  'common:zoom-out': ->
    runVisualBasic 'ViewZoomOut'
  'common:indent-right': ->
    runVisualBasic 'IncreaseIndent'
  'common:indent-left': ->
    runVisualBasic 'DecreaseIndent'
  'delete:lines': ({first, last} = {}) ->
    @do 'cursor:way-right'
    @do 'selection:way-left'
    @do 'common:delete'
  'selection:next-occurrence': (input) ->
    cmd = """
    tell application "Microsoft Word"
    	tell find object of selection
    		execute find find text "#{input.value}" with match forward
    	end tell
    end tell
    """
    @applescript cmd
  'selection:extend-to-next-occurrence': (input) ->
    cmd = """
    tell application "Microsoft Word"
      set extend mode of selection to true
    	tell find object of selection
    		execute find find text "#{input.value}" with match forward
    	end tell
      set extend mode of selection to false
    end tell
    """
    @applescript cmd

  'selection:previous-occurrence': (input) ->
    cmd = """
    tell application "Microsoft Word"
    	tell find object of selection
    		execute find find text "#{input.value}" without match forward
    	end tell
    end tell
    """
    @applescript cmd
  'selection:extend-to-previous-occurrence': (input) ->
    cmd = """
    tell application "Microsoft Word"
      set extend mode of selection to true
    	tell find object of selection
    		execute find find text "#{input.value}" without match forward
    	end tell
      set extend mode of selection to false
    end tell
    """
    @applescript cmd

  'clipboard:paste-from-history': ->
    cmd = """
    tell application "Microsoft Word"
    	set textObject to text object of selection
    	paste and format textObject type format plain text
    end tell
    """
    @applescript cmd
